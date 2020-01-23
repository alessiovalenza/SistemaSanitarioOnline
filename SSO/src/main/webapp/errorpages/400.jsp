<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error 400</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/css/styles.css">
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

<body style="background-color: #1e88e5">
<div id="holder">
    <header>
        <nav class="navbar-expand-md sticky-top "
             style="background-color: #1565c0;padding: 11px;border-style: groove; border-width: 0pt; border-color:lightgray">
            <div class="container-fluid"><img src="../assets/img/logoebbasta.png"
                                              style="height: 42px;padding: 0px;margin: 0px;">
                <a class="navbar-brand" href="../index.jsp"
                   style="padding: 3px;color: rgb(255,255,255);">
                    Ministero della salute
                </a>
            </div>
        </nav>
    </header>
    <div id="body">
        <div style="position: relative; text-align: center;width: 100%;">
            <img style="width:100%;" src="../assets/img/error.jpg">
            <div style="position: absolute; top: 40%; left: 40%;color: white;width: 60%;">
                <h3 class="scaled"
                    style="text-shadow: 1px 1px black; font-size: 4vw; ">
                    <fmt message>Errore 400<br> Richiesta Errata</fmt>
                </h3>

            </div>
        </div>

    </div>
    <footer>
        via Sommarive, 5 - 38123 Trento (Povo)
        Tel. +39 1234 567890
        CF e P.IVA 12345678901
        Numero verde 800 12345

    </footer>
</div>

</body>

</html>
