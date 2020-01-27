package it.unitn.disi.wp.progetto.filters;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import static it.unitn.disi.wp.progetto.commons.Utilities.urlIsLike;

@WebFilter(filterName = "AuthNFilter")
public class AuthNFilter implements Filter {
    private List<String> excludedUrls;
    private UtenteDAO utenteDAO;

    public void init(FilterConfig config) throws ServletException {
        ServletContext context = config.getServletContext();
        String urls = context.getInitParameter("excludedurls");
        excludedUrls = Arrays.asList(urls.split("[\\n\\t ]+"));

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

        ApiException exception = new ApiException(HttpServletResponse.SC_NOT_FOUND, "No resource found with that id");

        if(!Utilities.urlIsLike(field, excludedUrls)) {
            HttpSession s = httpRequest.getSession(false);
            boolean isAuthenticated = s != null && !s.isNew() && s.getAttribute("utente") != null;

            try {
                if(field.matches("api/pazienti/([\\d]+)[\\S]*")) {
                    Long id = Long.parseLong(field.replaceAll("api/pazienti/([\\d]+)[\\S]*", "$1"));
                    Utente utente = utenteDAO.getByPrimaryKey(id);
                    if(utente == null) {
                        throw exception;
                    }
                    else {
                        String ruolo = utente.getRuolo();
                        if (!ruolo.equals(Utilities.PAZIENTE_RUOLO) &&
                                !ruolo.equals(Utilities.MEDICO_BASE_RUOLO) &&
                                !ruolo.equals(Utilities.MEDICO_SPECIALISTA_RUOLO)) {
                            throw exception;
                        }
                    }
                }
                else if(field.matches("api/utenti/([\\d]+)[\\S]*")) {
                    Long id = Long.parseLong(field.replaceAll("api/utenti/([\\d]+)[\\S]*", "$1"));
                    Utente utente = utenteDAO.getByPrimaryKey(id);
                    if(utente == null) {
                        throw exception;
                    }
                }
                else if(field.matches("api/medicibase/([\\d]+)[\\S]*")) {
                    Long id = Long.parseLong(field.replaceAll("api/medicibase/([\\d]+)[\\S]*", "$1"));
                    Utente utente = utenteDAO.getByPrimaryKey(id);
                    if(utente == null) {
                        throw exception;
                    }
                    else {
                        String ruolo = utente.getRuolo();
                        if (!ruolo.equals(Utilities.MEDICO_BASE_RUOLO)) {
                            throw exception;
                        }
                    }
                }
            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }

            if (isAuthenticated) {
                System.out.println("Utente autenticato");
                request.setAttribute("isAuthenticated", true);
                chain.doFilter(request, response);
            } else {
                String res = httpRequest.getRequestURI();
                System.out.println("Impossibile accedere a " + res + " : login non effettuato. Redirect a LoginServlet");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
            }
        }else {
            String res = httpRequest.getRequestURI();
            System.out.println("Accesso a " + res + " consentito: risorsa ad accesso libero");
            chain.doFilter(request, response);
        }
    }
}
