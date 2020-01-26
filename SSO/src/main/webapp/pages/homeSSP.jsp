<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Locale" %>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<%
    String languageSession = (String)session.getAttribute("language");
    String languageParam = (String)request.getParameter("language");

    if(languageParam != null) {
        session.setAttribute("language", languageParam);
    }
    else if(languageSession == null) {
        Enumeration<Locale> locales = request.getLocales();

        boolean found = false;
        Locale matchingLocale = null;
        while(locales.hasMoreElements() && !found) {
            Locale locale = locales.nextElement();
            if(locale.getLanguage().equals("it") ||
                    locale.getLanguage().equals("en") ||
                    locale.getLanguage().equals("fr")) {
                found = true;
                matchingLocale = locale;
            }
        }

        session.setAttribute("language", matchingLocale != null ? matchingLocale.toString() : "it_IT");
    }

    String selectedSection = (String)session.getAttribute("selectedSection") != null ? (String)session.getAttribute("selectedSection") : "";
    switch(selectedSection) {
        case "erogaEsame":
            break;
        case "richiamo1":
            break;
        case "richiamo2":
            break;
        case "report":
            break;
        case "cambiaPassword":
            break;
        default:
            session.setAttribute("selectedSection", "erogaEsame");
            break;
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/homeMB.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"/>
    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="../assets/css/homeStyles.css"/>
    <!-- Scrollbar Custom CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css"/>
    <!-- Select2 CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


    <!-- JQeuery JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

    <!-- Custom Scrollbar -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>

    <!-- Font Awesome JS -->
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"
            integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ"
            crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"
            integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY"
            crossorigin="anonymous"></script>

    <!-- Popper.JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
            integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
            crossorigin="anonymous"></script>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

    <!-- Select2 JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/i18n/it.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/i18n/en.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/i18n/fr.js"></script>

    <!-- Utils JS -->
    <script src="../scripts/utils.js"></script>

    <script>
        let components = new Set();
        $(document).ready(function() {

            $('#dismiss, .overlay').on('click', function () {
                // hide sidebar
                $('#sidebar').removeClass('active');
                // hide overlay
                $('.overlay').removeClass('active');
            });
            $('.componentControl, .overlay').on('click', function () {
                // hide sidebar
                $('#sidebar').removeClass('active');
                // hide overlay
                $('.overlay').removeClass('active');
            });

            $('#sidebarCollapse').on('click', function () {
                // open sidebar
                $('#sidebar').addClass('active');
                // fade in the overlay
                $('.overlay').addClass('active');
                $('.collapse.in').toggleClass('in');
                $('a[aria-expanded=true]').attr('aria-expanded', 'false');
            });

            let langSelect2;
            <c:choose>
            <c:when test="${fn:startsWith(language, 'it')}">
            langSelect2 = "it";
            </c:when>
            <c:when test="${fn:startsWith(language, 'en')}">
            langSelect2 = "en";
            </c:when>
            <c:when test="${fn:startsWith(language, 'fr')}">
            langSelect2 = "fr";
            </c:when>
            <c:otherwise>
            langSelect2 = "en";
            </c:otherwise>
            </c:choose>

            let labelCercaEsami = "Cerca esami";
            initSelect2General("esami", "#idesameRichiamo1", langSelect2, labelCercaEsami);
            initSelect2General("esami", "#idesameRichiamo2", langSelect2, labelCercaEsami);

            let labelCercaPaz = "Cerca pazienti";
            initSelect2Pazienti("#idPaziente", "${sessionScope.utente.prov}", langSelect2, labelCercaPaz);
            let labelCercaEsamiPresc = "Cerca esami prescritti";
            $("#idEsame").select2({
                placeholder: labelCercaEsamiPresc,
                language: langSelect2,
                width: 300,
                allowClear: true,
                ajax: {
                    url: function() {
                        let urlEsami = "http://localhost:8080/SSO_war_exploded/api/pazienti/" +
                        $("#idPaziente").children("option:selected").val() + "/esamiprescritti/?erogationly=false&nonerogationly=true";
                        return urlEsami;
                    },
                    datatype: "json",
                    data: function (params) {
                        var query = {
                            term: params.term,
                            type: "public",
                            page: params.page || 1
                        }
                        return query;
                    },
                    processResults: function (data) {
                        var myResults = [];
                        $.each(data, function (index, item) {
                            myResults.push({
                                'id': item.id,
                                'text': item.esame.nome + " " + item.esame.descrizione + ", prescritta da " +
                                    ( item.medicoBase !== undefined ?
                                        ( item.medicoBase.nome + " " + item.medicoBase.cognome ) : ("SSP")
                                    ) + " il " + item.emissione
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            $("#formErogaEsame").submit(function(event){
                event.preventDefault(); //prevent default action
                let formData = "esito="+$("#esito").val(); //Encode form elements for submission
                let urlErogaEsame = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$("#idPaziente").val()+"/esamiprescritti/" + $("#idEsame").val();
                $.ajax({
                    url : urlErogaEsame,
                    type: "PUT",
                    data : formData,
                    success: function (data) {
                        alert("Esame ergoato");
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formRichiamo1").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("#btnRichiamo1");
                let form_data = "infeta="+$("#infetaRichiamo1").val()+"&idesame="+$("#idesameRichiamo1").val()+"&supeta="+$("#supetaRichiamo1").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : "http://localhost:8080/SSO_war_exploded/api/pazienti/richiamo1",
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.inputRichiamo1').val(null).trigger("change")
                        successButton("#btnRichiamo1")
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnRichiamo1")
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formRichiamo2").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("#btnRichiamo2");
                let form_data = "infeta="+$("#infetaRichiamo2").val()+"&idesame="+$("#idesameRichiamo2").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : "http://localhost:8080/SSO_war_exploded/api/pazienti/richiamo2",
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        successButton("#btnRichiamo2")
                        $('.inputRichiamo2').val(null).trigger("change")
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnRichiamo2")
                        alert(xhr.responseText);
                    }
                });
            });

            document.getElementById("nomeProvincia").textContent = "${sessionScope.utente.prov}";

            $(".spinner-border").hide();
            $("#erogaEsameControl").click(() => showComponent("erogaEsame"));
            $("#reportControl").click(() => showComponent("report"));
            $("#richiamo1Control").click(() => showComponent("richiamo1"));
            $("#richiamo2Control").click(() => showComponent("richiamo2"));

            populateComponents();
            hideComponents();

            document.getElementById("${sectionToShow}Control").click();
        });
    </script>
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <%-- da inserire anche css --%>
            <div id="dismiss">
                <i class="fas fa-arrow-left"></i>
            </div>
            <div class="sidebar-header">
                <img class="avatar" alt="Avatar" src="../assets/img/logo_repubblica_colori.png"
                     data-holder-rendered="true">
                <h3>Servizio sanitario provinciale</h3> <h3 id="nomeProvincia"></h3>
            </div>

            <ul class="list-unstyled components">
                <li>
                    <a href="#" class="componentControl" id="erogaEsameControl">Eroga esame</a>
                </li>
                <li>
                    <a href="#"class="componentControl" id="reportControl">Report</a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="richiamo1Control">Richiamo</a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="richiamo2Control">Richiama chi è già stato richiamato</a>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">

                    <button type="button" id="sidebarCollapse" class="btn btn-info">
                        <i class="fas fa-align-left"></i>
                    </button>
                </div>
            </nav>

            <div id="erogaEsame" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Eroga un esame prescritto ad un paziente</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Eroga esame</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formErogaEsame" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idPaziente">Nome del paziente</label>
                                                        <select class="select2EvadiRicetta" type="text" id="idPaziente" name="idpaziente" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idEsame">Nome dell'esame</label>
                                                        <select class="select2EvadiRicetta" type="text" id="idEsame" name="idesame" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="esito">Esito</label>
                                                        <textarea type="text" id="esito" name="esito" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id="btnErogaEsame" type="submit">Eroga</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="report" class="component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Scarica report</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Seleziona il periodo</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formScaricaReport" action="../docs/reportprov" method="GET">
                                                <div class="form-group">
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="fromReport">Dal giorno</label>
                                                        <input type="date" id="fromReport" name="fromDay" required="required"/>
                                                        <br>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="toReport">Al giorno</label>
                                                        <input type="date" id="toReport" name="toDay" required="required"/>
                                                    </div>
                                                    <input type="hidden" name="idprovincia" value="${sessionScope.utente.prov}"/>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnReport" type="submit">Scarica</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="richiamo1" class="component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Effetua un richiamo per range di età</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Effetua richiamo</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formRichiamo1" >
                                                <div class="form-group">
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="infetaRichiamo1">limite inferiore di età</label>
                                                        <input class="inputRichiamo1" type="number" min="0" id="infetaRichiamo1" name="infeta" required="required"></input>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                        <br>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="supetaRichiamo1">limite superiore di età</label>
                                                        <input class="inputRichiamo1" type="number" min="0" id="supetaRichiamo1" name="supeta" required="required"></input>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idesameRichiamo1">Nome dell'esame</label>
                                                        <select class="inputRichiamo1" type="text" id="idesameRichiamo1" name="idesame" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnRichiamo1" type="submit">Richiama</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="richiamo2" class="component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Effetua un richiamo per chi è già stato richiamato in passato</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Effetua richiamo</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formRichiamo2">
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="infetaRichiamo2">limite inferiore di età</label>
                                                        <input class="inputRichiamo2" type="number" min="0" id="infetaRichiamo2" name="infeta" required="required"></input>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                        <br>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idesameRichiamo2">Nome dell'esame</label>
                                                        <select class="inputRichiamo2" type="text" id="idesameRichiamo2" name="idesame" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnRichiamo2" type="submit">Richiama</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>