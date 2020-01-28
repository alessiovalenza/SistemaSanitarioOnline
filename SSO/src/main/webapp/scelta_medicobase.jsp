<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String languageSession = (String) session.getAttribute("language");
    String languageParam = (String) request.getParameter("language");

    if (languageParam != null) {
        session.setAttribute("language", languageParam);
    } else if (languageSession == null) {
        Enumeration<Locale> locales = request.getLocales();

        boolean found = false;
        Locale matchingLocale = null;
        while (locales.hasMoreElements() && !found) {
            Locale locale = locales.nextElement();
            if (locale.getLanguage().equals("it") ||
                    locale.getLanguage().equals("en") ||
                    locale.getLanguage().equals("fr")) {
                found = true;
                matchingLocale = locale;
            }
        }

        session.setAttribute("language", matchingLocale != null ? matchingLocale.toString() : "it_IT");
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page"/>
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/scelta_medicobase.jsp?language=" scope="page"/>

<fmt:setLocale value="${language}"/>
<fmt:setBundle basename="labels"/>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Home Medico di Base</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

</head>

<body>
<div id="holder">
    <header>
        <nav id="navTop" class="navbar-expand-md sticky-top">
            <div class="container-fluid"><img id="logoMin" src="assets/img/logo_repubblica_colori.png">
                <a id="linkLandPag" class="navbar-brand" href="index.jsp">
                    <fmt:message key="Ministero_della_salute"/>
                </a>
                <div id="selLang" class="sidebar-lang">
                    <c:choose>
                        <c:when test="${!fn:startsWith(language, 'it')}">
                            <a href="${url}it_IT" style="color: white;">italiano</a>
                        </c:when>
                        <c:otherwise>
                            <b>italiano</b>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${!fn:startsWith(language, 'en')}">
                            <a href="${url}en_EN" style="color: white;">english</a>
                        </c:when>
                        <c:otherwise>
                            <b>english</b>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${!fn:startsWith(language, 'fr')}">
                            <a href="${url}fr_FR" style="color: white;">français</a>
                        </c:when>
                        <c:otherwise>
                            <b>français</b>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>
    </header>
    <br>
    <div id="body">
        <div class="container-fluid">
            <div class="row" style="color: #1e88e5">
                <div class="col-md-6">
                    <a href="medicobase?ruolo=mb">
                        <div class="card">
                            <div class="card-body" style="text-align: center">
                                <h2><fmt:message key="Medico"/></h2> <img
                                    style="height: 25rem;max-width: 100%;object-fit:contain; "
                                    src="assets/img/logo_medico.jpeg">
                            </div>
                        </div>
                    </a>
                </div>

                <br>

                <div class="col-md-6">
                    <a href="medicobase?ruolo=p">
                        <div class="card">
                            <div class="card-body" style="text-align:center;">
                                <h2><fmt:message key="Paziente"/></h2><img
                                    style="height: 25rem;max-width: 100%;object-fit:contain; "
                                    src="assets/img/logo_paziente.png">
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <br>
    <footer>
        <fmt:message key="footer"/>
    </footer>
</div>
</body>

</html>