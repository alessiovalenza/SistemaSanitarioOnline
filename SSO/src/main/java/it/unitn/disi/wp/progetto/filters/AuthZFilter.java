package it.unitn.disi.wp.progetto.filters;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;
import org.apache.thrift.protocol.TField;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;

import static it.unitn.disi.wp.progetto.commons.Utilities.urlIsLike;

@WebFilter(filterName = "AuthZFilter")
public class AuthZFilter implements Filter {
    private List<String> excludedUrls;
    private List<String> tuttiUrls;
    private List<String> urlsUnion;
    private ServletContext context;
    private UtenteDAO utenteDAO;

    public void init(FilterConfig config) throws ServletException {
        context = config.getServletContext();
        excludedUrls = Arrays.asList(context.getInitParameter("excludedurls").split("[\\n\\t ]+"));
        tuttiUrls = Arrays.asList(context.getInitParameter("tutti").split("[\\n\\t ]+"));

        urlsUnion = new ArrayList<>();
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")));
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.MEDICO_SPECIALISTA_RUOLO).split("[\\n\\t ]+")));
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.PAZIENTE_RUOLO).split("[\\n\\t ]+")));
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.FARMACIA_RUOLO).split("[\\n\\t ]+")));
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.SSP_RUOLO).split("[\\n\\t ]+")));
        urlsUnion.addAll(Arrays.asList(context.getInitParameter(Utilities.SSN_RUOLO).split("[\\n\\t ]+")));

        DAOFactory daoFactory = (DAOFactory)context.getAttribute("daoFactory");
        try {
            utenteDAO = daoFactory.getDAO(UtenteDAO.class);
        }
        catch (DAOFactoryException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        }
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        URL url = new URL(httpRequest.getRequestURL().toString());
        String field = url.getPath().substring(httpRequest.getContextPath().length() + 1);
        System.out.println(field);
        if (request.getAttribute("isAuthenticated") != null && !urlIsLike(field, excludedUrls)){
            HttpSession s = httpRequest.getSession(false);
            Utente utente = (Utente) s.getAttribute("utente");

            try {
                if (checkRole(field, utente, (HttpServletRequest) request)) {
                    System.out.println("Utente " + utente.getId() + " (ruolo "+ utente.getRuolo() + ") autorizzato ad accedere alla risorsa " + field);
                    chain.doFilter(request, response);
                }
                else {
                    System.out.println("Utente " + utente.getId() + " non autorizzato ad accedere alla risorsa " + field + ". Redirect alla suo homePage");
                    //httpResponse.sendRedirect(httpRequest.getContextPath() + Utilities.getMainPageFromRole(utente.getRuolo()));

                    if(field.startsWith("api/")) { //la richiesta è verso un'API
                        throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                    }
                    else {
                        throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                    }
                }
            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }else {
            chain.doFilter(request, response);
        }
    }

    public boolean checkRole(String field, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;
        if(Utilities.urlIsLike(field, tuttiUrls)) {
            res = true;
        }
        else {
            String urls = context.getInitParameter(utente.getRuolo());
            List<String> urlsAllowed = Arrays.asList(urls.split("[\\n\\t ]+"));

            switch (utente.getRuolo()) {
                case Utilities.MEDICO_BASE_RUOLO:
                    res = checkMB(field, urlsAllowed, utente, request);
                    break;
                case Utilities.MEDICO_SPECIALISTA_RUOLO:
                    res = checkMS(field, urlsAllowed, utente, request);
                    break;
                case Utilities.PAZIENTE_RUOLO:
                    res = checkP(field, urlsAllowed, utente, request);
                    break;
                case Utilities.FARMACIA_RUOLO:
                    res = checkF(field, urlsAllowed, utente, request);
                    break;
                case Utilities.SSP_RUOLO:
                    res = checkSSP(field, urlsAllowed, utente, request);
                    break;
                case Utilities.SSN_RUOLO:
                    res = checkSSN(field, urlsAllowed, utente, request);
                    break;
            }
        }

        return res;
    }

    private boolean checkMB(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            medicobase[/]?
            pages/homeMB[\S]*
            api/general/[\S]*
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) || url.matches(urlPatterns.get(2))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/medicibase/([\d]+)/pazienti[/]?
         */
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)[\S]*
         */
        if(!res && url.matches(urlPatterns.get(5))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(5), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente != null && paziente.getIdMedicoBase() == utente.getId()) {
                if(request.getMethod().equals("GET")) {
                    res = true;
                }
                else if(request.getMethod().equals("POST")) {
                    res = true;
                }
            }
        }

        /*
            api/utenti/([\d]+)/foto[/]?
         */
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente != null && paziente.getIdMedicoBase() == utente.getId() && request.getMethod().equals("GET")) {
                res = true;
            }
            else if(idUrl == utente.getId()) {
                res = true;
            }
        }

        /*
            foto/([\d]+)/([\d]+).jpeg[/]?
         */
        if(!res && url.matches(urlPatterns.get(7))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(7), "$1"));
            if(idUrl == utente.getId()) {
                res = true;
            }
            else {
                Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
                if(paziente != null && paziente.getIdMedicoBase() == utente.getId()) {
                    res = true;
                }
            }
        }

        /*
            scelta_medicobase[\S]*
         */
        if(!res && url.matches(urlPatterns.get(8))) {
            res = true;
        }

        return res;
    }

    private boolean checkMS(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            medicospecialista[/]?
            pages/homeMS[\S]*
            api/general/[\S]*
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) || url.matches(urlPatterns.get(2))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/pazienti[\S]*
         */
        if(!res && url.matches(urlPatterns.get(4))) {
            if(request.getMethod().equals("GET") && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)/visitespecialistiche/([\d]+)[/]?
         */
        if(!res && url.matches(urlPatterns.get(5))) {
            if(request.getMethod().equals("PUT")) {
                res = true;
            }
        }

        /*
            api/utenti/([\d]+)/foto[/]?
         */
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            if(request.getMethod().equals("GET")) {
                res = true;
            }
            else if(idUrl == utente.getId()) {
                res = true;
            }
        }

        /*
            foto/([\d]+)/([\d]+).jpeg[/]?
         */
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }

        /*
            scelta_medicospec[\S]*
         */
        if(!res && url.matches(urlPatterns.get(8))) {
            res = true;
        }

        return res;
    }

    private boolean checkP(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            paziente[/]?
            pages/homeP[\S]*
            docs/ricevute[/]?
            docs/ricette[/]?
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3))) {
            res = true;
        }

        /*
            api/general/[\S]*
         */
        if(!res && url.matches(urlPatterns.get(4))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(5))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(5), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)[\S]*
         */
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            if(idUrl == utente.getId() && request.getMethod().equals("GET")) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)/medicobase[/]?
         */
        if(!res && url.matches(urlPatterns.get(7))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(7), "$1"));
            if(idUrl == utente.getId() && request.getMethod().equals("PUT")) {
                res = true;
            }
        }

        /*
            api/utenti/([\d]+)/foto[/]?
         */
        if(!res && url.matches(urlPatterns.get(8))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(8), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            foto/([\d]+)/([\d]+).jpeg[/]?
         */
        if(!res && url.matches(urlPatterns.get(9))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(9), "$1"));
            if(idUrl == utente.getId()) {
                res = true;
            }
        }

        /*
            mappe[\S]*
         */
        if(!res && url.matches(urlPatterns.get(10))) {
            res = true;
        }

        /*
            medicobase[/]?
            scelta_medicobase[\S]*
         */
        if(!res && (url.matches(urlPatterns.get(11)) || url.matches(urlPatterns.get(12)))) {
            Utente actualUtente = utenteDAO.getByPrimaryKey(utente.getId());
            if(actualUtente.getRuolo().equals(Utilities.MEDICO_BASE_RUOLO)) {
                res = true;
            }
        }

        /*
            medicospecialista[/]?
            scelta_medicospec[\S]*
         */
        if(!res && (url.matches(urlPatterns.get(13)) || url.matches(urlPatterns.get(14)))) {
            Utente actualUtente = utenteDAO.getByPrimaryKey(utente.getId());
            if(actualUtente.getRuolo().equals(Utilities.MEDICO_SPECIALISTA_RUOLO)) {
                res = true;
            }
        }

        return res;
    }

    private boolean checkF(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            farmacia[/]?
            pages/homeF[\S]*
            api/general/[\S]*
            api/pazienti/([\d]+)[/]?
            pages/evadiQR[\S]*
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2))|| url.matches(urlPatterns.get(6)) || url.matches(urlPatterns.get(8))) {
            res = true;
        }

        /*
            api/pazienti[/]?
         */
        if(!res && url.matches(urlPatterns.get(4)) && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)/ricette[\S]*
         */
        if(!res && url.matches(urlPatterns.get(5))) {
            if(request.getMethod().equals("PUT")) {
                res = true;
            }
            else if(request.getMethod().equals("GET")) {
                res = true;
            }
        }

        /*
            foto/([\d]+)/([\d]+).jpeg[/]?
         */
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }

        return res;
    }

    private boolean checkSSP(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            ssp[/]?
            pages/homeSSP[\S]*
            api/general/[\S]*
            docs/reportprov[/]?
            api/pazienti/([\d]+)[/]?
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3)) || url.matches(urlPatterns.get(8))) {
            res = true;
        }

        /*
            api/pazienti[/]?
         */
        if(!res && url.matches(urlPatterns.get(5)) && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        /*
            api/pazienti/([\d]+)/esamiprescritti[\S]*
         */
        if(!res && url.matches(urlPatterns.get(6))) {
            if(request.getMethod().equals("PUT") || request.getMethod().equals("GET")) {
                long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
                Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
                if(paziente != null && paziente.getProv().equals(utente.getProv())) {
                    res = true;
                }
            }
        }

        /*
            api/pazienti/richiamo[\S]*
         */
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }

        /*
            foto/([\d]+)/([\d]+).jpeg[/]?
         */
        if(!res && url.matches(urlPatterns.get(9))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(9), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente != null && paziente.getProv().equals(utente.getProv())) {
                res = true;
            }
        }

        return res;
    }

    private boolean checkSSN(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*
            ssn[/]?
            pages/homeSSN[\S]*
            api/general/[\S]*
            docs/reportnazionale[/]?
         */
        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3))) {
            res = true;
        }

        /*
            api/utenti/([\d]+)/password[/]?
         */
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        return res;
    }
}
