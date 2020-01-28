<%--
  Created by IntelliJ IDEA.
  User: francesco
  Date: 01/01/20
  Time: 12:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeMB.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title><fmt:message key="Email"/></title>
    </head>
    <body>
        <%@ page import="static it.unitn.disi.wp.progetto.commons.Utilities.sendEmail"%>
        <%@ page import="it.unitn.disi.wp.progetto.commons.Email"%>
        <%@ page import="it.unitn.disi.wp.progetto.persistence.entities.Utente" %>
        <%@ page import="java.util.ArrayList" %>

        <% Utente utente = (Utente) session.getAttribute("utente");
            String recipient = utente.getEmail();
            String subject = "Promemoria";
            String text = "Hai delle ricette non evase; se vuoi qui vicino trovi una farmacia" ;
            Email email = new Email(recipient, subject, text);
            ArrayList<Email> emails = new ArrayList();
            emails.add(new Email(recipient, subject, text));
            sendEmail(emails); %>
    </body>
</html>
