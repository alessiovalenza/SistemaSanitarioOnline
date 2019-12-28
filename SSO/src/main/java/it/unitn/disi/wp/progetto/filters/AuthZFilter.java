package it.unitn.disi.wp.progetto.filters;

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
                    System.out.println("Utente autorizzato ad accedere alla risorsa " + field);
                    chain.doFilter(request, response);
                }
                else {
                    //System.out.println("Utente non autorizzato ad accedere alla risorsa " + field + ". Redirect alla suo homePage");
                    //httpResponse.sendRedirect(httpRequest.getContextPath() + Utilities.getMainPageFromRole(utente.getRuolo()));

                    if(Utilities.urlIsLike(field, urlsUnion)) {
                        throw new SSOServletException(HttpServletResponse.SC_FORBIDDEN, "You do not have the permission to access this resource");
                    }
                    else {
                        chain.doFilter(request, response);
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

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) || url.matches(urlPatterns.get(2))) {
            Enumeration<String> e = request.getParameterNames();
            while(e.hasMoreElements()) {
                System.out.println(e.nextElement());
            }
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                Enumeration<String> e = request.getParameterNames();
                while(e.hasMoreElements()) {
                    System.out.println(e.nextElement());
                }
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(5))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(5), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente.getIdMedicoBase() == utente.getId()) {
                if(request.getMethod().equals("GET")) {
                    res = true;
                }
                else if(request.getMethod().equals("POST")) {
                    Enumeration<String> e = request.getParameterNames();
                    while(e.hasMoreElements()) {
                        System.out.println(e.nextElement());
                    }
                    res = true;
                }
            }
        }
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente.getIdMedicoBase() == utente.getId() && request.getMethod().equals("GET")) {
                res = true;
            }
            else if(idUrl == utente.getId()) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(7))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(7), "$1"));
            if(idUrl == utente.getId()) {
                res = true;
            }
            else {
                Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
                if(paziente.getIdMedicoBase() == utente.getId()) {
                    res = true;
                }
            }
        }

        return res;
    }

    private boolean checkMS(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) || url.matches(urlPatterns.get(2))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(4))) {
            if(request.getMethod().equals("GET") && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(5))) {
            if(request.getMethod().equals("PUT")) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            if(request.getMethod().equals("GET")) {
                res = true;
            }
            else if(idUrl == utente.getId()) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }

        return res;
    }

    private boolean checkP(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(4))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(5))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(5), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(6))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
            if(idUrl == utente.getId() && request.getMethod().equals("GET")) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(7))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(7), "$1"));
            if(idUrl == utente.getId() && request.getMethod().equals("PUT")) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(8))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(8), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(9))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(9), "$1"));
            if(idUrl == utente.getId()) {
                res = true;
            }
        }

        return res;
    }

    private boolean checkF(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        /*for(String u: urlPatterns) {
            System.out.println(u + "\t"+url+" match " + url.matches(u));
        }*/

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2))|| url.matches(urlPatterns.get(6))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(4)) && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(3))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(3), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(5))) {
            if(request.getMethod().equals("PUT")) {
                res = true;
            }
            else if(request.getMethod().equals("GET")) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }

        return res;
    }

    private boolean checkSSP(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3)) || url.matches(urlPatterns.get(8))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(5)) && !url.matches(Arrays.asList(context.getInitParameter(Utilities.MEDICO_BASE_RUOLO).split("[\\n\\t ]+")).get(4))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }
        if(!res && url.matches(urlPatterns.get(6))) {
            if(request.getMethod().equals("PUT") || request.getMethod().equals("GET")) {
                long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(6), "$1"));
                Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
                if(paziente.getProv().equals(utente.getProv())) {
                    res = true;
                }
            }
        }
        if(!res && url.matches(urlPatterns.get(7))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(9))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(9), "$1"));
            Utente paziente = utenteDAO.getByPrimaryKey(idUrl);
            if(paziente.getProv().equals(utente.getProv())) {
                res = true;
            }
        }

        return res;
    }

    private boolean checkSSN(String url, List<String> urlPatterns, Utente utente, HttpServletRequest request) throws DAOException {
        boolean res = false;

        if(url.matches(urlPatterns.get(0)) || url.matches(urlPatterns.get(1)) ||
                url.matches(urlPatterns.get(2)) || url.matches(urlPatterns.get(3))) {
            res = true;
        }
        if(!res && url.matches(urlPatterns.get(4))) {
            long idUrl = Long.parseLong(url.replaceAll(urlPatterns.get(4), "$1"));
            if(utente.getId() == idUrl) {
                res = true;
            }
        }

        return res;
    }
}
