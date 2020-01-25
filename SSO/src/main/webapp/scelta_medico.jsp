<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/scelta_medico.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Home</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

</head>

<body>
<div id="holder">
    <header>
        <nav class="navbar-expand-md sticky-top"
             style="background-color: #1565c0;padding: 11px;">
            <div class="container-fluid"><img src="assets/img/logo_repubblica_colori.png"
                                              style="height: 42px;padding: 0px;margin: 0px;">
                <a class="navbar-brand" href="index.jsp"
                   style="padding: 3px;color: rgb(255,255,255);">
                    Ministero della salute
                </a>
            </div>
        </nav>
    </header>
    <br>
    <div id="body">
        <div class="container-fluid" >
            <div class="row" style="color: #1e88e5">
                <div class="col-md-6">
                    <a href="">
                        <div class="card">
                            <div class="card-body" style="text-align: center">
                                <h2>Medico</h2> <img style="height: 25rem;max-width: 100%;object-fit:contain; "
                                                                                         src="assets/img/logo_medico.jpeg">
                            </div>
                        </div>
                    </a>
                </div>

                <br>

                <div class="col-md-6">
                    <a href="">
                        <div class="card">
                            <div class="card-body" style="text-align:center;">
                                <h2>Paziente</h2><img style="height: 25rem;max-width: 100%;object-fit:contain; "
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
        via Sommarive, 5 - 38123 Trento (Povo)
        Tel. +39 1234 567890
        CF e P.IVA 12345678901
        Numero verde 800 12345
    </footer>
</div>
</body>

</html>