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
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.servlet.http.*;
import javax.ws.rs.core.Response;

public class Utilities {
    public final static String PAZIENTE_RUOLO = "p";
    public final static String FARMACIA_RUOLO = "f";
    public final static String MEDICO_BASE_RUOLO = "mb";
    public final static String MEDICO_SPECIALISTA_RUOLO = "ms";
    public final static String SSN_RUOLO = "ssn";
    public final static String SSP_RUOLO = "ssp";

    public final static Response daoFactoryErrorResponse = Response.status(500,"Impossible to get dao interface for storage system").build();
    public final static Response daoErrorResponse = Response.status(500,"Impossible to get/update requested data from storage system").build();
    public final static Response ioErrorResponse = Response.status(500, "an I/O error has occurred.").build();
    public final static Response badRequestResponse = Response.status(400,"bad request").build();
    public final static Response notFoundResponse = Response.status(404,"Not found").build();
    public final static Response requestForbiddenResponse = Response.status(403).build();
    public final static Response noContentResponse = Response.status(204).build();
    public final static Response createdResponse = Response.status(201).build();

    public final static String USER_IMAGE_EXT_REGEX = "(.*/)*.+\\.(jpg|jpeg)$";
    public final static String USER_IMAGE_EXT = "jpeg";
    public final static String USER_IMAGES_FOLDER = "foto";
    public final static int USER_IMAGES_WIDTH = 1024;
    public final static int USER_IMAGES_HEIGHT = 1024;

    public final static String TEMP_FOLDER = "tmp";
    public static long tempFileCount = 0;

    //salt per i token
    public final static long tokenSalt = 69696969;

    public static void sendEmail(String Destinatario, String Subject, String Text) {
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
        Message msg = new MimeMessage(session);
        try {
            msg.setFrom(new InternetAddress(username));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(Destinatario, false));
            msg.setSubject(Subject);
            msg.setText(Text);
            msg.setSentDate(new Date());
            Transport.send(msg);
        } catch (MessagingException me) {
            me.printStackTrace(System.err);
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
            BigInteger no = new BigInteger(1, messageDigest);
            return no.toString(16);
        }catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    //sha512 per i token
    public static String sha512(String givenPass) {
        return computeHash(givenPass, tokenSalt);
    }

    public static String getMainPageFromRole(String ruolo){
        String url = "/";
        switch(ruolo){
            case FARMACIA_RUOLO:
                url = "/farmacia";
                break;
            case MEDICO_BASE_RUOLO:
                url = "/medicobase";
                break;
            case MEDICO_SPECIALISTA_RUOLO:
                url = "/medicospecialista";
                break;
            case PAZIENTE_RUOLO:
                url = "/paziente";
                break;
            case SSN_RUOLO:
                url = "/ssn";
                break;
            case SSP_RUOLO:
                url = "/ssp";
                break;
        }
        return url;
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
            utenteView.setEmail(utente.getEmail().strip());
            utenteView.setProv(utente.getProv().strip());
            utenteView.setRuolo(utente.getRuolo().strip());
            utenteView.setNome(utente.getNome().strip());
            utenteView.setCognome(utente.getCognome().strip());
            utenteView.setSesso(utente.getSesso());
            utenteView.setDataNascita(utente.getDataNascita());
            utenteView.setLuogoNascita(utente.getLuogoNascita().strip());
            utenteView.setCodiceFiscale(utente.getCodiceFiscale().strip());
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

        for(Utente utente: richiamati) {
            String body = "Gentile paziente " + utente.getNome() + " " + utente.getCognome() + ",\n" +
                    "con la presente comunicazione la informiamo che dovrà effettuare un richiamo per il seguente esame:\n" +
                    esame.getNome() + ".\n" +
                    "Disinti saluti";
            Utilities.sendEmail(utente.getEmail(), "Richiamo SSP " + idProvincia, body);
        }
    }

    public static void sendEmailPrescrizioneEsame(Long idEsame, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        EsameDAO esameDAO = daoFactory.getDAO(EsameDAO.class);
        Esame esame = esameDAO.getByPrimaryKey(idEsame);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto il seguente esame:\n" +
                esame.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(paziente.getEmail(), "Prescrizione esame", body);
    }

    public static void sendEmailPrescrizioneVisitaSpec(Long idVisita, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        VisitaDAO visitaDAO = daoFactory.getDAO(VisitaDAO.class);
        Visita visita = visitaDAO.getByPrimaryKey(idVisita);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto la seguente visita specialistica:\n" +
                visita.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(paziente.getEmail(), "Prescrizione visita specialistica", body);
    }

    public static void sendEmailPrescrizioneRicetta(Long idFarmaco, Utente paziente, DAOFactory daoFactory) throws DAOFactoryException, DAOException {
        FarmacoDAO farmacoDAO = daoFactory.getDAO(FarmacoDAO.class);
        Farmaco farmaco = farmacoDAO.getByPrimaryKey(idFarmaco);

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che il suo medico di base le ha prescritto il seguente farmaco:\n" +
                farmaco.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(paziente.getEmail(), "Prescrizione ricetta", body);
    }

    public static void sendEmailRisultatoEsame(EsamePrescritto esamePrescritto) {
        Esame esame = esamePrescritto.getEsame();
        UtenteView paziente = esamePrescritto.getPaziente();

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che può ora visualizzare l'esito del seguente esame:\n" +
                esame.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(paziente.getEmail(), "Esito esame", body);
    }

    public static void sendEmailRisultatoVisita(VisitaMedicoSpecialista visitaMedicoSpecialista){
        Visita visita = visitaMedicoSpecialista.getVisita();
        UtenteView paziente = visitaMedicoSpecialista.getPaziente();

        String body = "Gentile paziente " + paziente.getNome() + " " + paziente.getCognome() + ",\n" +
                "con la presente comunicazione la informiamo che può ora visualizzare il referto della seguente visita specialistica:\n" +
                visita.getNome() + ".\n" +
                "Disinti saluti";
        Utilities.sendEmail(paziente.getEmail(), "Referto visita specialistica", body);
    }
}
