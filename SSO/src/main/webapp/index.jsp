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
<c:set var="url" value="${baseUrl}?language=" scope="page"/>

<fmt:setLocale value="${language}"/>
<fmt:setBundle basename="labels"/>

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key="servizio_sanitario"/></title>

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="icon" href="${baseUrl}/assets/img/favicon.ico" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"
            integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ"
            crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"
            integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY"
            crossorigin="anonymous"></script>
</head>

<body style="background-color:#1e88e5">
<div id="holder">
    <header>
        <nav id="navTop" class="navbar-expand-md sticky-top "
        >
            <div class="container-fluid">
                <img id="logoMin" src="${baseUrl}/assets/img/logo_repubblica_colori.png">
                <a id="linkLandPag" class="navbar-brand" href="index.jsp">
                    <fmt:message key="ministero_della_salute"/>
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
    <div id="body">
        <div style="position: relative; text-align: center;width: 100%;">
            <img style="width:100%;" src="assets/img/sfondo_index.jpeg">
            <div style="position: absolute; top: 20%; left: 50%;color: white;width: 50%;">
                <h3 id="SSN" class="scaled">
                    <fmt message><fmt:message key="sistema_sanitario"/> <br><fmt:message key="per_il_cittadino"/></fmt>
                </h3>

                <p id="welcome">
                    <fmt message><fmt:message key="benvenuto_sul_sistema_universale"/> <br> <fmt:message
                            key="per_il_servizio_Sanitario"/></fmt>
                </p>
                <div><a href="LoginServlet">
                    <button id="welBtn" type="button" class="btn btn-primary"
                    >Login
                    </button>
                </a>
                </div>
            </div>
        </div>

        <div class="container-fluid">
            <div class="row" style="background-color:#1e88e5;color: white;">
                <div class="col-md-12" style="text-align: center;">
                    <h4 style="text-shadow: 1px 1px black; padding-top: 2%;padding-bottom: 2%;font-family: 'Roboto','Poppins', sans-serif;">
                        <fmt:message key="usurfruire"/></h4>
                </div>
            </div>
        </div>

        <div class="container-fluid">
            <div class="row" style="background-color:#1e88e5;color: white;padding-bottom: 5%;">
                <div class="col-md-6" style="text-align: center;text-shadow: 1px 1px black;">


                    <div style="background-color: transparent;padding-bottom: 2%">
                        <h5 class="" style=" text-shadow: 1px 1px black; background-color:
                                transparent; ">
                            <fmt:message key="Per_chi"/>
                        </h5>
                    </div>

                    <h6><fmt:message key="Medici"/></h6>

                    <h6><fmt:message key="Pazienti"/></h6>

                    <h6>
                        <fmt:message key="Farmacie"/>
                    </h6>

                    <h6><fmt:message key="ervizio_Sanitario_Nazionale/Provinciale"/></h6>
                    </fmt>

                </div>
                <div class="col-md-6" style="text-align: center;text-shadow: 1px 1px black;">

                    <div style="background-color: transparent;padding-bottom: 2%;">
                        <h5 class="" style="text-shadow: 1px 1px black; background-color: transparent; ">
                            <fmt:message key="Cosa si puo fare"/>
                        </h5>
                    </div>
                    <h6><fmt:message key="Prenotare_Appuntamenti"/></h6>

                    <h6><fmt:message key="Richiedere_farmaci"/></h6>

                    <h6><fmt:message key="Anamnesi"/></h6>

                    <h6><fmt:message key="Resoconto economico"/></h6>
                </div>
            </div>
        </div>
    </div>
    <footer>
        <fmt:message key="footer"/>
    </footer>
</div>
</body>
</html>