package it.unitn.disi.wp.progetto.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SetSectionServlet", urlPatterns = {"/section"})
public class SetSectionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedSection = request.getParameter("selectedSection");
        HttpSession session = request.getSession(false);
        if(session != null) {
            if(selectedSection != null) {
                session.setAttribute("selectedSection", selectedSection);
            }
            else {
                session.setAttribute("selectedSection", "");
            }
        }
    }
}
