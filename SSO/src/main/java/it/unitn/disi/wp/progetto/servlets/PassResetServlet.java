package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.TokenPswDAO;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.TokenPsw;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static it.unitn.disi.wp.progetto.commons.Utilities.sha512;

@WebServlet(name = "PassResetServlet", urlPatterns = {"/passreset"})
public class PassResetServlet extends HttpServlet {
    String resetUrl = "/reset_password.jsp";
    String sendEmailUrl = "/sendEmail.jsp";
    String emailSentMessage = "E' stata inviata una email all'indirizzo di posta specificato. Controlla la tua mailbox.";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        String newPass = request.getParameter("new_password");
        String repeatPass = request.getParameter("repeat_password");
        if (!newPass.equals(repeatPass)){
            request.setAttribute("msg", "le password non coincidono.");
            System.out.println("le password non coincidono");
            request.getRequestDispatcher(resetUrl).include(request, response);
        }else {
            try {
                HttpSession session = request.getSession(false);
                long id = (long) session.getAttribute("id");
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente utente = utenteDAO.getByPrimaryKey(id);
                if (utente != null) {
                    long salt = utente.getSalt();
                    String hashed = sha512(newPass, salt);
                    utenteDAO.updatePassword(id, hashed, salt);
                    session.invalidate();
                    TokenPswDAO tokenPswDAO = daoFactory.getDAO(TokenPswDAO.class);
                    tokenPswDAO.deleteToken(id);
                    request.setAttribute("msg", "La password è stata modificata con successo");
                    response.sendRedirect("LoginServlet?rp=1");
                }else{
                    response.sendError(404, "id non trovato");
                }
            } catch (DAOFactoryException e) {
                e.printStackTrace();
                throw new RuntimeException(new ServletException("Impossible to get dao interface for storage system"));
            } catch (DAOException e) {
                e.printStackTrace();
                throw new RuntimeException(new ServletException("Impossible to get requested data from storage system"));
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String email = request.getParameter("email");
        System.out.println("in passrecovery doGet method.\ntoken: " + token + "\nemail: " + email);
        if (email != null && token == null){
            emailStep(email, request, response);
        }else if (email == null && token != null){
            resetStep(token, request, response);
        }else{
            System.out.println("please provide one between email and token");
            response.sendError(400);
        }
    }

    private void emailStep(String email, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        System.out.println("in emailStep method");
        long id;
        String token;
        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente utente = utenteDAO.getUserByEmail(email);
            if (utente != null){
                id = utente.getId();
                token = Utilities.generaToken();
                TokenPswDAO tokenPswDAO = daoFactory.getDAO(TokenPswDAO.class);
                tokenPswDAO.creaToken(sha512(token), id);
                createAndSendEmail(utente, token);
                System.out.println("email inviata");
                request.setAttribute("msg", emailSentMessage);
                request.getRequestDispatcher(sendEmailUrl).include(request, response);
            }else{
                System.out.println("l'email inviata non appartiene a nessun utente.");
            }
        }catch (DAOFactoryException e) {
            throw new RuntimeException(new ServletException("Impossible to get dao interface for storage system"));
        } catch (DAOException e) {
            throw new RuntimeException(new ServletException("Impossible to get requested data from storage system"));
        }
    }

    private void resetStep(String token, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        System.out.println("in resetStep method");
        try {
            TokenPswDAO tokenPswDAO = daoFactory.getDAO(TokenPswDAO.class);
            TokenPsw tokenPsw = tokenPswDAO.getTokenByToken(sha512(token));
            if (tokenPsw == null){
                System.out.println("nessun token trovato. X");
                response.sendError(404, "X");
            }else{
                long id = tokenPsw.getIdUtente();
                System.out.println("Token trovato, corrisponde all'id: " + id);
                HttpSession session = request.getSession();
                session.setAttribute("id", id);
                request.getRequestDispatcher(resetUrl).include(request, response);
            }
        }catch (DAOFactoryException e) {
            throw new RuntimeException(new ServletException("Impossible to get dao interface for storage system"));
        } catch (DAOException e) {
            throw new RuntimeException(new ServletException("Impossible to get requested data from storage system"));
        }
    }

    private void createAndSendEmail(Utente utente, String token){
        String link = "http://localhost:8080/SSO_war_exploded/passreset?token=" + token;
        String testo = String.format("Ciao %s,\neccoti il link per ripristinare la password: %s", utente.getNome(), link);
        Utilities.sendEmail(utente.getEmail(), "Password Recovery", testo);
    }

}
