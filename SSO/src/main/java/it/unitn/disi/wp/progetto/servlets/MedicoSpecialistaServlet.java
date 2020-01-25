package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name="MedicoSpecialistaServlet", urlPatterns = {"/medicospecialista"})
public class MedicoSpecialistaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ruolo = request.getParameter("ruolo");

        if(ruolo == null || ruolo.equals("ms")) {
            String homePage = request.getServletContext().getInitParameter("homeMedicoSpecialista").substring(1);

            HttpSession session = request.getSession(false);
            Utente medicoBase = (Utente)session.getAttribute("utente");
            medicoBase.setRuolo("ms");

            response.sendRedirect(homePage);
        }
        else if(ruolo.equals("p")) {
            Utilities.redirectHomePaziente(request, response);
        }
        else {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "Role not valid");
        }
    }
}
