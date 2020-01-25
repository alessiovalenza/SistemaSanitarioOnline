package it.unitn.disi.wp.progetto.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import static it.unitn.disi.wp.progetto.commons.Utilities.getCookieByName;


@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final String LANDING_URL = "/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession s = request.getSession(false);
        if (request.isRequestedSessionIdValid() && s != null) {
            s.invalidate();
            System.out.println("sessione invalidata");
        }
        Cookie jsessionCookie = getCookieByName(request.getCookies(),"JSESSIONID");
        if (jsessionCookie != null) {
            jsessionCookie.setMaxAge(0);
            jsessionCookie.setValue(null);
            response.addCookie(jsessionCookie);
            System.out.println("cookie settato a null");
        }
        System.out.println("logged out");
        response.sendRedirect(request.getContextPath() + LANDING_URL);
    }
}
