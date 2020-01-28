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
<c:set var="url" value="${baseUrl}/login.jsp?language=" scope="page"/>

<fmt:setLocale value="${language}"/>
<fmt:setBundle basename="labels"/>

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key="Login"/></title>

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="icon" href="${baseUrl}/assets/img/favicon.ico" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="assets/css/login.css">
</head>

<body>
<div id="holder">
    <header>
        <nav id="navTop" class="navbar-expand-md sticky-top"
             style="background-color: #1565c0;">
            <div class="container-fluid">
                <img id="logoMin" src="assets/img/logo_repubblica_colori.png">
                <a id="linkLandPag" class="navbar-brand" href="index.jsp">
                    <fmt:message key="Ministero_della_salute"/>
                </a>
                <div id="selLang" class="sidebar-lang" style="color: white;">
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
        <div class="container-fluid">
            <div class="wrapper fadeInDown">
                <div id="formContent">
                    <div class="alert alert-warning" role="alert">
                        ${error}
                    </div>
                    <p>${msg}</p>
                    <form name="loginForm" action="LoginServlet" method="post">
                        <input type="email" id="email" class="fadeIn second" name="email" placeholder="Email" required>
                        <input type="password" id="password" class="fadeIn third" name="password" placeholder="Password"
                               required>
                        <input type="submit" class="fadeIn fourth" value="Log In"><br/>
                        <label for="checkbox" class="fadeIn fourth"><fmt:message key="Ricordami"/></label>
                        <input type="checkbox" class="fadeIn fourth" name="remember_me" id="checkbox">
                    </form>

                    <div id="formFooter">
                        <a class="underlineHover" href="sendEmail.jsp"><fmt:message key="Forgot_Password?"/></a>
                    </div>

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