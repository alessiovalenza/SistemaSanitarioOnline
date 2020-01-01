<%--
  Created by IntelliJ IDEA.
  User: francesco
  Date: 01/01/20
  Time: 12:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Mail</title>
    </head>
    <body>
        <%@ page import="static it.unitn.disi.wp.progetto.commons.Utilities.sendEmail"%>
        <%@ page import="it.unitn.disi.wp.progetto.persistence.entities.Utente" %>

        <% Utente utente = (Utente) session.getAttribute("utente");
            String email = "frapava98@gmail.com"; //utente.getEmail();
            String subject = "Promemoria";
            String text = "Hai delle ricette non evase; se vuoi qui vicino trovi una farmacia" ; %>
        <% sendEmail(email, subject, text); %>
    </body>
</html>
