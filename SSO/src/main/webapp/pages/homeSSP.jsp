<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Locale" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.EsamePrescrittoDAO" %>

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
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/homeSSP.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title>Dashboard SSP</title>

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
        let baseUrl = "<%=request.getContextPath()%>";
        let components = new Set();

        const labelLoadingButtons = "loading";
        const labelSuccessButtons = "success";
        const labelErrorButtons = "error";

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

            let labelMismatch = "La controlla di aver scritto correttamente la nuova password";
            let labelWrongPw = "Password vecchia non corretta. Riprova";
            let labelBtnPw = document.getElementById("btnCambiaPassword").innerHTML;
            initCambioPassword("#formCambiaPassword", "#vecchiaPassword", "#nuovaPassword", "#ripetiPassword", ${sessionScope.utente.id},
                "#btnCambiaPassword", "messaggioCambioPw", labelWrongPw, labelMismatch, labelBtnPw);

            let labelCercaEsami = "Cerca esami";
            initSelect2General("esami", "#idesameRichiamo1", langSelect2, labelCercaEsami);
            initSelect2General("esami", "#idesameRichiamo2", langSelect2, labelCercaEsami);

            let labelCercaPaz = "Cerca pazienti";
            initSelect2Pazienti("#idPaziente", "${sessionScope.utente.prov}", langSelect2, labelCercaPaz);
            let labelCercaEsamiPresc = "Cerca esami prescritti";
            let erogatori={};
            $("#idEsame").select2({
                placeholder: labelCercaEsamiPresc,
                language: langSelect2,
                width: "100%",
                allowClear: true,
                ajax: {
                    url: function() {
                        let urlEsamiPaziente = baseUrl + "/api/pazienti/" +
                            $("#idPaziente").children("option:selected").val() + "/esamiprescritti/?erogationly=false&nonerogationly=true";
                        return urlEsamiPaziente;
                    },
                    datatype: "json",
                    data: function (params) {
                        let query = {
                            term: params.term,
                            type: "public",
                            page: params.page || 1
                        }
                        return query;
                    },
                    processResults: function (data) {
                        let myResults = [];
                        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };

                        $.each(data, function (index, item) {
                            let prescrizione = new Date(item.prescrizione);
                            prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}");
                            erogatori[item.id]=item.medicoBase;
                            myResults.push({
                                "id": item.id,
                                "text": item.esame.nome + " " + item.esame.descrizione + ", prescritta da " +
                                    ( item.medicoBase !== undefined ?
                                            ( item.medicoBase.nome + " " + item.medicoBase.cognome ) : ("SSP")
                                    ) + " il " + prescrizione
                            });
                        });
                        return {
                            results: myResults
                        };
                    },
                    error: function(xhr, status, error) {
                        console.log(xhr.responseText);
                    }
                }
            });
            $('#idEsame').on('select2:select', function (e) {
                if (erogatori[$(this).children("option:selected").val()] == undefined){
                    $("#idPagato").prop("checked",true);
                    $("#idPagato").prop("disabled",true);
                }else{
                    $("#idPagato").prop("checked",false);
                    $("#idPagato").prop("disabled",false);
                }
            });

            let labelErogaEs = document.getElementById("btnErogaEsame").innerHTML;
            $("#formErogaEsame").submit(function(event){
                loadingButton("#btnErogaEsame",labelLoadingButtons);
                event.preventDefault(); //prevent default action
                let formData = "esito="+$("#esito").val(); //Encode form elements for submission
                let urlErogaEsame = baseUrl + "/api/pazienti/"+$("#idPaziente").val()+"/esamiprescritti/" + $("#idEsame").val();
                $.ajax({
                    url : urlErogaEsame,
                    type: "PUT",
                    data : formData,
                    success: function (data) {
                        $(".inputErogaEsame").val(null).trigger("change");
                        $("#idPagato").prop("checked",false);
                        $("#idPagato").prop("disabled",false);
                        successButton("#btnErogaEsame",labelSuccessButtons);
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        console.log(xhr.responseText);
                        errorButton("#btnErogaEsame",labelErrorButtons);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.inputErogaEsame').on("change", function () {
                resetButton("#btnErogaEsame", labelErogaEs);
            });
            $('#esito').on("click", function () {
                resetButton("#btnErogaEsame", labelErogaEs);
            });
            $('#esito').on("input", function () {
                resetButton("#btnErogaEsame", labelErogaEs);
            });

            let labelRichiamo1 = document.getElementById("btnRichiamo1").innerHTML;
            $("#formRichiamo1").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("#btnRichiamo1",labelLoadingButtons)
                let formData = "infeta="+$("#infetaRichiamo1").val()+"&idesame="+$("#idesameRichiamo1").val()+"&supeta="+$("#supetaRichiamo1").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : baseUrl + "/api/pazienti/richiamo1",
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.inputRichiamo1').val(null).trigger("change")
                        successButton("#btnRichiamo1",labelSuccessButtons)
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnRichiamo1",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.inputRichiamo1').on("change", function () {
                resetButton("#btnRichiamo1", labelRichiamo1);
            });
            $('.inputRichiamo1').on("click", function () {
                resetButton("#btnRichiamo1", labelRichiamo1);
            });
            $('.inputRichiamo1').on("input", function () {
                resetButton("#btnRichiamo1", labelRichiamo1);
            });

            let labelRichiamo2 = document.getElementById("btnRichiamo2").innerHTML;
            $("#formRichiamo2").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("#btnRichiamo2",labelLoadingButtons)
                let formData = "infeta="+$("#infetaRichiamo2").val()+"&idesame="+$("#idesameRichiamo2").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : baseUrl + "/api/pazienti/richiamo2",
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.inputRichiamo2').val(null).trigger("change");
                        successButton("#btnRichiamo2",labelSuccessButtons);
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnRichiamo2",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.inputRichiamo2').on("change", function () {
                resetButton("#btnRichiamo2", labelRichiamo2);
            });
            $('.inputRichiamo2').on("click", function () {
                resetButton("#btnRichiamo2", labelRichiamo2);
            });
            $('.inputRichiamo2').on("input", function () {
                resetButton("#btnRichiamo2", labelRichiamo2);
            });

            setNomeProvincia("nomeProvincia", "${sessionScope.utente.prov}");

            $("#erogaEsameControl").click(() => showComponent("erogaEsame"));
            $("#reportControl").click(() => showComponent("report"));
            $("#richiamo1Control").click(() => showComponent("richiamo1"));
            $("#richiamo2Control").click(() => showComponent("richiamo2"));
            $('#cambiaPasswordControl').click(() => showComponent("cambiaPassword"));

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
        <div id="dismiss">
            <i class="fas fa-arrow-left"></i>
        </div>
        <div class="sidebar-header">
            <img class="avatar" alt="Avatar" src="../assets/img/logo_repubblica_colori.png"
                 data-holder-rendered="true">
            <br/><br/>
            <h5>Servizio sanitario provinciale</h5> <h3 id="nomeProvincia"></h3>
            <br>
            <div class="sidebar-lang">
                <c:choose>
                    <c:when test="${!fn:startsWith(language, 'it')}">
                        <a href="${url}it_IT">italiano</a>
                    </c:when>
                    <c:otherwise>
                        <b>italiano</b>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${!fn:startsWith(language, 'en')}">
                        <a href="${url}en_EN">english</a>
                    </c:when>
                    <c:otherwise>
                        <b>english</b>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${!fn:startsWith(language, 'fr')}">
                        <a href="${url}fr_FR">français</a>
                    </c:when>
                    <c:otherwise>
                        <b>français</b>
                    </c:otherwise>
                </c:choose>
            </div>
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
            <li>
                <a href="#" class="componentControl" id="cambiaPasswordControl">Cambia password</a>
            </li>
            <li>
                <a href="../logout?forgetme=0">Log out</a>
            </li>
            <li>
                <a href="../logout?forgetme=1">Cambia account</a>
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
                                                    <select class="inputErogaEsame" type="text" id="idPaziente" name="idpaziente" required="required"></select>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idEsame">Nome dell'esame</label>
                                                    <select class="inputErogaEsame" type="text" id="idEsame" name="idesame" required="required"></select>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem;">
                                                    <label for="esito">Esito</label>
                                                    <textarea style="width: 100%" class="inputErogaEsame" type="text" id="esito" name="esito" required="required"></textarea>
                                                </div>
                                            </div>
                                            <input required="true" id="idPagato" type="checkbox">Ticket di <fmt:formatNumber value="<%=EsamePrescrittoDAO.PREZZO_TICKET%>" type="currency" currencyCode="EUR"/> pagato<br>
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
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo1">Limite inferiore di età</label>
                                                    <input class="inputRichiamo1" type="number" min="0" id="infetaRichiamo1" name="infeta" required="required"></input>
                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="supetaRichiamo1">Limite superiore di età</label>
                                                    <input class="inputRichiamo1" type="number" min="0" id="supetaRichiamo1" name="supeta" required="required"></input>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo1">Esame</label>
                                                    <select class="inputRichiamo1" type="text" id="idesameRichiamo1" name="idesame" required="required"></select>
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
                                        <h1>Effetua un richiamo</h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formRichiamo2">
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo2">Limite inferiore di età</label>
                                                    <input class="inputRichiamo2" type="number" min="0" id="infetaRichiamo2" name="infeta" required="required"/>
                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo2">Esame</label>
                                                    <select class="inputRichiamo2" type="text" id="idesameRichiamo2" name="idesame" required="required"></select>
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

        <div id="cambiaPassword" class="tool component">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Gestione password</h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1>Cambia password</h1>
                                    </div>
                                    <div class="form-content">
                                        <div class="alert alert-warning" role="alert" id="messaggioCambioPw"></div>
                                        <form id="formCambiaPassword" >
                                            <div class="form-group">
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="vecchiaPassword">Vecchia password</label>
                                                    <input class="inputCambiaPassword" type="password" id="vecchiaPassword" name="vecchiaPassword" required="required"/>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="nuovaPassword">Nuova password</label>
                                                    <input class="inputCambiaPassword" type="password" id="nuovaPassword" name="nuovaPassword" required="required"/>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="ripetiPassword">Ripeti nuova password</label>
                                                    <input class="inputCambiaPassword" type="password" id="ripetiPassword" name="ripetiPassword" required="required"/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <button id ="btnCambiaPassword" type="submit">Procedi</button>
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