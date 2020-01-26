<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/reset_password.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Reset Password</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script>


        function isValid(){
            let new_pass = $("#new_password").val()
            let repeat_pass = $("#repeat_password").val()
            return new_pass == repeat_pass
        }
        $(document).ready(function() {
            $("form").submit(function(e){
                if (!isValid()) {
                    e.preventDefault();
                    alert("<fmt:message key="le_password_non_coincidono"/>")
                }
            });
        });
    </script>
</head>

<body>
    <nav class="navbar-expand-md sticky-top"
        style="background-color: #51b5e0;font-family: 'Open Sans', sans-serif;padding: 11px; border-style: groove; border-width: 1px;border-color:lightgray">
        <div class="container-fluid"><img src="assets/img/logo_repubblica_colori.png"
                style="height: 42px;padding: 0px;margin: 0px;">
            <a class="navbar-brand" href="index.jsp"
                style="padding: 3px;font-family: default;color: rgb(255,255,255);">
                <fmt:message key="Ministero_della_salute"/>
            </a>
        </div>
    </nav>

    <div class="container" style="padding-top: 5%">
        <div class="row">
            <div class="col-md-12">
                <h5><fmt:message key="Inserisci_la_nuova_password"/></h5>
                <form action="passreset" method="post">
                    <div class="form-group">
                        <label for="new_password"><fmt:message key="Nuova_password"/></label>
                        <input type="password" class="form-control" name="new_password" id = "new_password">
                    </div>
                    <div class="form-group">
                        <label for="repeat_password"><fmt:message key="Riscrivi_la_nuova_password"/></label>
                        <input type="password" class="form-control" name="repeat_password" id = "repeat_password">
                    </div>

                    <button type="submit" class="btn btn-primary"><fmt:message key="Submit"/></button>
                </form>
            </div>
        </div>
    </div>

    <nav class="navbar"
        style="background-color: #51b5e0;font-family: 'Open Sans', sans-serif; border-style: groove; border-width: 1px;border-color:lightgray;bottom: 0;position: fixed;width: 100%; height: 4rem;">
        <p class="navbar-text" style="font-family: default;color: rgb(255,255,255); font-size: inherit">
            <fmt:message key="footer"/>
        </p>
    </nav>
</body>

</html>