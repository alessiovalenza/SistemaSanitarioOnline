package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.commons.Email;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.TokenPswDAO;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.TokenPsw;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.Collections;

import static it.unitn.disi.wp.progetto.commons.Utilities.sha512;

@WebServlet(name = "PassResetServlet", urlPatterns = {"/passreset"})
public class PassResetServlet extends HttpServlet {
    String resetUrl = "/reset_password.jsp";
    String sendEmailUrl = "/sendEmail.jsp";
    String emailSentMessage = "email_sent";

    private static final long TOKEN_EXPIRY = 1000 * 60 * 5; //5 minuti in ms

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        String newPass = request.getParameter("new_password");
        String repeatPass = request.getParameter("repeat_password");
        if (!newPass.equals(repeatPass)) {
            request.setAttribute("msg", "pw_mismtach");
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
                    String lang = (String)session.getAttribute("language");
                    session.invalidate();
                    TokenPswDAO tokenPswDAO = daoFactory.getDAO(TokenPswDAO.class);
                    tokenPswDAO.deleteToken(id);
                    request.setAttribute("msg", "pw_modified_OK");
                    response.sendRedirect("LoginServlet?rp=1&language=" + lang);
                }else{
                    throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Id not found");
                }
            }
            catch (DAOFactoryException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
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
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You must supply either email or token");
        }
    }

    private void emailStep(String email, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String baseUrl = request.getRequestURL().toString();
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
                createAndSendEmail(utente, token, baseUrl);
                System.out.println("email inviata");
                request.setAttribute("msg", emailSentMessage);
                request.getRequestDispatcher(sendEmailUrl).include(request, response);
            }else{
                request.setAttribute("error", "email_not_found");
                request.getRequestDispatcher(sendEmailUrl).include(request, response);
            }
        }
        catch (DAOFactoryException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        }
        catch (DAOException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }
    }

    private void resetStep(String token, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        System.out.println("in resetStep method");
        try {
            TokenPswDAO tokenPswDAO = daoFactory.getDAO(TokenPswDAO.class);
            TokenPsw tokenPsw = tokenPswDAO.getTokenByToken(sha512(token));
            if (tokenPsw == null){
                request.setAttribute("error", "token_not_found");
                request.getRequestDispatcher(sendEmailUrl).include(request, response);
            }else{
                Timestamp expiry = new Timestamp(System.currentTimeMillis() - TOKEN_EXPIRY);
                Timestamp lastEdit = tokenPsw.getLastEdit();

                if(lastEdit.compareTo(expiry) >= 0) {
                    long id = tokenPsw.getIdUtente();
                    System.out.println("Token trovato, corrisponde all'id: " + id);
                    HttpSession session = request.getSession();
                    session.setAttribute("id", id);
                    request.setAttribute("token", token);
                    request.getRequestDispatcher(resetUrl).include(request, response);
                }
                else {
                    request.setAttribute("error", "token_expired");
                    request.getRequestDispatcher(sendEmailUrl).include(request, response);
                }
            }
        }
        catch (DAOFactoryException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        }
        catch (DAOException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }
    }

    private void createAndSendEmail(Utente utente, String token, String baseUrl){

        /*
        String link = baseUrl + "/passreset?token=" + token;
        String testo = String.format("Gentile utente %s %s,\npuò recuperare la password al seguente link:\n%s\nDistinti saluti", utente.getCognome(), utente.getNome(), link);
        Utilities.sendEmail(Collections.singletonList(new Email(utente.getEmail(), "Password Recovery", testo)));
        */

        /*
        String link = baseUrl + "/passreset?token=" + token;
        String testo = String.format("Gentile utente %s %s,\npuò recuperare la password al seguente link:\n%s\nDistinti saluti", utente.getCognome(), utente.getNome(), link);
        Utilities.oldSendEmail(utente.getEmail(), "Password Recovery", testo);
        */


        String link = baseUrl + "?token=" + token;
        try {
            URL resource = getServletContext().getResource("res/email.txt");
            Path path = Paths.get(resource.getPath());
            String content = Files.readString(path, StandardCharsets.UTF_8);
            content = content.replaceFirst("(%s)", utente.getCognome() + " " + utente.getNome());
            content = content.replaceFirst("(%s)", link);
            Utilities.sendEmail(Collections.singletonList(new Email(utente.getEmail(), "Password Recovery", content)));
        }catch(IOException e){
            e.printStackTrace();
            System.out.println("Qualcosa è andato storto");
        }


    }
}
