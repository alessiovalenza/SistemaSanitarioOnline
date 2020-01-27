package it.unitn.disi.wp.progetto.commons;
import it.unitn.disi.wp.progetto.persistence.dao.EsameDAO;
import it.unitn.disi.wp.progetto.persistence.dao.FarmacoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.*;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;
import javax.servlet.http.*;
import javax.ws.rs.core.Response;
import javax.xml.bind.DatatypeConverter;

public class Utilities {
    public final static String PAZIENTE_RUOLO = "p";
    public final static String FARMACIA_RUOLO = "f";
    public final static String MEDICO_BASE_RUOLO = "mb";
    public final static String MEDICO_SPECIALISTA_RUOLO = "ms";
    public final static String SSN_RUOLO = "ssn";
    public final static String SSP_RUOLO = "ssp";
    public final static Response EMPTY_RESPONSE = Response.status(204).build();
    public final static Response CREATED_RESPONSE = Response.status(201).build();

    public final static String WEBAPP_REL_DIR = File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator;

    public final static String USER_IMAGE_EXT_REGEX = "(.*/)*.+\\.(jpg|jpeg)$";
    public final static String USER_IMAGE_EXT = "jpeg";
    public final static String USER_IMAGES_FOLDER = "foto";
    public final static int USER_IMAGES_WIDTH_MAX = 1024;
    public final static int USER_IMAGES_HEIGHT_MAX = 1024;

    public final static String TEMP_FOLDER = "tmp";
    public static long tempFileCount = 0;

    //salt per i token
    public final static long TOKEN_SALT = 69696969;

    public static void sendEmail(List<Email> emails) {
        System.out.println("Sto per inviare una email");
        final String host = "smtp.gmail.com";
        final String port = "465";
        final String username = "sistema.sanitario.online@gmail.com";
        final String password = "ucwphytnbmkkwkow";
        Properties props = System.getProperties();

        props.setProperty("mail.smtp.host", host);
        props.setProperty("mail.smtp.port", port);
        props.setProperty("mail.smtp.socketFactory.port", port);
        props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.smtp.starttls.enable", "true");
        props.setProperty("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Transport transport = session.getTransport("smtp");

            transport.connect(host, username, password);

            final int MAX_EMAIL = 50;
            for(int i = 0; i < emails.size() && i < MAX_EMAIL; i++) {
                Email email = emails.get(i);

                String destinatario = email.getRecipient();
                String subject = email.getSubject();
                String text = email.getText();

                Message msg = new MimeMessage(session);

                try {
                    InternetAddress [] addressRecipient = InternetAddress.parse(destinatario, false);
                    msg.setFrom(new InternetAddress(username));
                    msg.setRecipients(Message.RecipientType.TO, addressRecipient);
                    msg.setSubject(subject);
                    msg.setContent(text, "text/html; charset=utf-8");
                    //msg.setText(text);
                    msg.setSentDate(new Date());
                    msg.saveChanges();

                    transport.sendMessage(msg, addressRecipient);
                } catch (MessagingException me) {
                    me.printStackTrace();
                }
            }
            transport.close();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static String sha512(String givenPass, long salt) {
        return computeHash(givenPass, salt);
    }

    private static String computeHash(String givenPass, long salt) {
        String input = givenPass + Long.toString(salt);
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] messageDigest = md.digest(input.getBytes());
            return DatatypeConverter.printHexBinary(messageDigest).toLowerCase();
        }catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    //sha512 per i token
    public static String sha512(String givenPass) {
        return computeHash(givenPass, TOKEN_SALT);
    }

    public static boolean urlIsLike(String url, List<String> urlsList){
        boolean res = false;
        for (String e : urlsList){
            res = res || url.matches(e);
        }
        return res;
    }

    public static UtenteView fromUtenteToUtenteView(Utente utente) {
        UtenteView utenteView = null;

        if(utente != null) {
            utenteView = new UtenteView();
            utenteView.setId(utente.getId());
            utenteView.setEmail(utente.getEmail());
            utenteView.setProv(utente.getProv());
            utenteView.setRuolo(utente.getRuolo());
            utenteView.setNome(utente.getNome());
            utenteView.setCognome(utente.getCognome());
            utenteView.setSesso(utente.getSesso());
            utenteView.setDataNascita(utente.getDataNascita());
            utenteView.setLuogoNascita(utente.getLuogoNascita());
            utenteView.setCodiceFiscale(utente.getCodiceFiscale());
            utenteView.setIdMedicoBase(utente.getIdMedicoBase());
        }

        return utenteView;
    }

    public static String generaToken(){
        String alphabet= "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        int len = 32;
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder(len);
        for( int i = 0; i < len; i++ ){
            sb.append(alphabet.charAt(rnd.nextInt(alphabet.length())));
        }
        return sb.toString();
    }

    public static Cookie getCookieByName(Cookie[] cookies, String name){
        Cookie res = null;
        if (cookies != null){
            for (Cookie c : cookies) {
                if (c.getName().equals(name)) {
                    res = c;
                }
            }
        }
        return res;
    }

    public static void sendEmailRichiamo(String idProvincia, Long idEsame, List<Utente> richiamati, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        EsameDAO esameDAO = daoFactory.getDAO(EsameDAO.class);
        Esame esame = esameDAO.getByPrimaryKey(idEsame);

        ArrayList<Email> emails = new ArrayList();
        for(Utente utente: richiamati) {
            String body = "Gentile paziente " + utente.getNome() + " " + utente.getCognome() + ",\n" +
                    "con la presente comunicazione la informiamo che dovrà effettuare un richiamo per il seguente esame:\n" +
                    esame.getNome() + ".\n" +
                    "Disinti saluti";

            emails.add(new Email(utente.getEmail(), "Richiamo SSP " + idProvincia, body));
        }

        Utilities.sendEmail(emails);
    }

    public static void sendEmailPrescrizioneEsame(Long idEsame, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        EsameDAO esameDAO = daoFactory.getDAO(EsameDAO.class);
        Esame esame = esameDAO.getByPrimaryKey(idEsame);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto il seguente esame:\n" +
                esame.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(Collections.singletonList(new Email(paziente.getEmail(), "Prescrizione esame", body)));
    }

    public static void sendEmailPrescrizioneVisitaSpec(Long idVisita, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        VisitaDAO visitaDAO = daoFactory.getDAO(VisitaDAO.class);
        Visita visita = visitaDAO.getByPrimaryKey(idVisita);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto la seguente visita specialistica:\n" +
                visita.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(Collections.singletonList(new Email(paziente.getEmail(), "Prescrizione visita specialistica", body)));
    }

    public static void sendEmailPrescrizioneRicetta(Long idFarmaco, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        FarmacoDAO farmacoDAO = daoFactory.getDAO(FarmacoDAO.class);
        Farmaco farmaco = farmacoDAO.getByPrimaryKey(idFarmaco);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto il seguente farmaco:\n" +
                farmaco.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(Collections.singletonList(new Email(paziente.getEmail(), "Prescrizione ricetta", body)));
    }

    public static void sendEmailRisultatoEsame(EsamePrescritto esamePrescritto) {
        Esame esame = esamePrescritto.getEsame();
        UtenteView paziente = esamePrescritto.getPaziente();

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che può ora visualizzare l'esito del seguente esame:\n" +
                esame.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(Collections.singletonList(new Email(paziente.getEmail(), "Esito esame", body)));
    }

    public static void sendEmailRisultatoVisita(VisitaMedicoSpecialista visitaMedicoSpecialista){
        Visita visita = visitaMedicoSpecialista.getVisita();
        UtenteView paziente = visitaMedicoSpecialista.getPaziente();

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che può ora visualizzare il referto della seguente visita specialistica:\n" +
                visita.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(Collections.singletonList(new Email(paziente.getEmail(), "Referto visita specialistica", body)));
    }

    public static void redirectHomePaziente(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String homePage = request.getServletContext().getInitParameter("homePaziente").substring(1);

        HttpSession session = request.getSession(false);
        Utente paziente = (Utente)session.getAttribute("utente");
        paziente.setRuolo("p");

        response.sendRedirect(homePage);
    }
}
