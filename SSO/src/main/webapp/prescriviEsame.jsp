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


<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title><fmt:message key="Prescrivi_esame"/></title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/Profile-Edit-Form-1.css">
    <link rel="stylesheet" href="assets/css/Profile-Edit-Form.css">
    <link rel="stylesheet" href="assets/css/styles.css">
</head>

<body>
    <nav class="navbar navbar-light navbar-expand-md sticky-top"
        style="background-color: #51b5e0;font-family: 'Open Sans', sans-serif;padding: 11px;border-style: groove; border-width: 1px; border-color:lightgray">
        <div class="container-fluid"><img src="assets/img/logo_repubblica_colori.png"
                style="height: 42px;padding: 0px;margin: 0px;"><a class="navbar-brand" href="index.jsp"
                style="padding: 3px;font-family: default;color: rgb(255,255,255)">Ministero della salute</a><button
                data-toggle="collapse" class="navbar-toggler" data-target="#navcol-1"><span class="sr-only">Toggle
                    navigation</span><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navcol-1">
                <ul class="nav navbar-nav">
                    <li class="nav-item" role="presentation"><a class="nav-link active" href="profilo.jsp"
                            style="font-family: default;color: rgb(255,255,255)">Profilo</a></li>
                    <li class="nav-item" role="presentation"><a class="nav-link"
                            style="color: rgb(255,255,255);font-family: default;" href="pazienti.jsp">Pazienti</a></li>
                    <li class="nav-item" role="presentation"><a class="nav-link" href="prescriviEsame.jsp"
                            style="color: rgb(255,255,255);font-family: default;">Prescrivi esame</a></li>
                </ul>
                <ul class="nav navbar-nav">
                    <li class="nav-item" role="presentation"></li>
                    <li class="nav-item" role="presentation"></li>
                    <li class="nav-item" role="presentation"></li>
                </ul>
                <ul class="nav navbar-nav">
                    <li class="nav-item" role="presentation"><a class="nav-link active" href="prescriviFarmaco.jsp"
                            style="color: rgb(255,255,255)">Prescrivi farmaco</a></li>
                    <li class="nav-item" role="presentation"></li>
                    <li class="nav-item" role="presentation"></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container" style="text-align: left; padding-top: 10vh" >
        <form method="POST" autocomplete="on">
            <div class="form-group">
                <label for="paziente">Paziente:</label>
                <input type="text" class="form-control" id="paziente">
            </div>
            <div class="form-group">
                <label for="pwd">Esame:</label>
                <input type="text" class="form-control" id="esame">
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</body>

</html>