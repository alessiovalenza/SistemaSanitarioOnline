package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.persistence.dao.TokenRememberMeDAO;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.TokenRememberMe;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import static it.unitn.disi.wp.progetto.commons.Utilities.getCookieByName;
import static it.unitn.disi.wp.progetto.commons.Utilities.sha512;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final String LANDING_URL = "/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String arg = request.getParameter("forgetme");
        int forgetme = arg == null ? 0 : Integer.valueOf(arg);
        long idUtente = -1;

        String lang = null;
        HttpSession s = request.getSession(false);
        if (request.isRequestedSessionIdValid() && s != null) {
            idUtente = ((Utente) s.getAttribute("utente")).getId();
            lang = (String)s.getAttribute("language");
            s.invalidate();
            System.out.println("Sessione Invalidata");
        }
        Cookie jsessionCookie = getCookieByName(request.getCookies(),"JSESSIONID");
        if (jsessionCookie != null) {
            jsessionCookie.setMaxAge(0);
            jsessionCookie.setValue(null);
            response.addCookie(jsessionCookie);
            System.out.println("JSESSIONID has been set to null");
        }

        if (forgetme == 1 && idUtente != -1){
            deleteRememberMe(request, response, idUtente);
        }

        System.out.println("logged out");
        response.sendRedirect(request.getContextPath() + LANDING_URL + (lang != null ? "?language=" + lang : ""));
    }

    protected void deleteRememberMe(HttpServletRequest request, HttpServletResponse response, long idUtente) throws ServletException, IOException{
        Cookie rememberMeCookie = getCookieByName(request.getCookies(), "rememberMe");
        if (rememberMeCookie != null){
            try {
                DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
                TokenRememberMeDAO tokenRememberMeDAO = daoFactory.getDAO(TokenRememberMeDAO.class);
                tokenRememberMeDAO.deleteTokenByUtente(idUtente);
            }
            catch (DAOFactoryException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
            rememberMeCookie.setMaxAge(0);
            rememberMeCookie.setValue(null);
            response.addCookie(rememberMeCookie);
            System.out.println("rememberMe cookie has been set to null");
        }

    }

}
