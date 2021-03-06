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
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeSSP.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key='Dashboard_SSP'/></title>

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="icon" href="${baseUrl}/assets/img/favicon.ico" type="image/x-icon">

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

        const labelLoadingButtons = "<fmt:message key='Loading'/>";
        const labelSuccessButtons = "<fmt:message key='Succed'/>";
        const labelErrorButtons = "<fmt:message key='Error'/>";

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
                setTimeout(function(){$('#content').delay(10).trigger('sidebar_visible')},1000);
            });

            $('#content').on("sidebar_visible",function () {
                $('#content ,.overlay').on('click', function () {
                    // hide sidebar
                    $('#sidebar').removeClass('active');
                    // hide overlay
                    $('.overlay').removeClass('active');
                    $(this).unbind("click")
                });

            })

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
                    langSelect2 = "it";
                </c:otherwise>
            </c:choose>

            let labelTooMany = "<fmt:message key='troppi_risultati'/>";

            let labelMismatch = "<fmt:message key='Controlla'/>";
            let labelWrongPw = "<fmt:message key='Riprova'/>";
            let labelBtnPw = document.getElementById("btnCambiaPassword").innerHTML;
            initCambioPassword("#formCambiaPassword", "#vecchiaPassword", "#nuovaPassword", "#ripetiPassword", ${sessionScope.utente.id},
                "#btnCambiaPassword", "messaggioCambioPw", labelWrongPw, labelMismatch, labelBtnPw);

            let labelCercaEsami = "<fmt:message key='Cerca_esami'/>";
            initSelect2General("esami", "#idesameRichiamo1", langSelect2, labelCercaEsami);
            initSelect2General("esami", "#idesameRichiamo2", langSelect2, labelCercaEsami);

            let labelCercaPaz = "<fmt:message key='Cerca_pazienti'/>";
            initSelect2Pazienti("#idPaziente", "messaggioCercaPaz", "${sessionScope.utente.prov}", langSelect2, labelCercaPaz, labelTooMany);
            let labelCercaEsamiPresc = "<fmt:message key='Cerca_esami_prescritti'/>";
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
                                "text": item.esame.nome + " " + item.esame.descrizione + ", <fmt:message key='prescritta da'/> " +
                                    ( item.medicoBase !== undefined ?
                                            ( item.medicoBase.nome + " " + item.medicoBase.cognome ) : ("SSP")
                                    ) + " <fmt:message key='il'/> " + prescrizione
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

            document.getElementById("messaggioRichiamo1").style.visibility = "hidden";
            let labelRichiamo1 = document.getElementById("btnRichiamo1").innerHTML;
            let labelErrorRange = "Il limite inferiore di età deve essere minore o uguale al limite superiore";
            $("#formRichiamo1").submit(function(event){
                event.preventDefault(); //prevent default action
                if($("#infetaRichiamo1").val() <= $("#supetaRichiamo1").val()) {
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
                }
                else {
                    document.getElementById("messaggioRichiamo1").style.visibility ="visible";
                    document.getElementById("messaggioRichiamo1").textContent = labelErrorRange;
                    errorButton("#btnRichiamo1", labelErrorButtons);
                }
            });
            $('.inputRichiamo1').on("change", function () {
                document.getElementById("messaggioRichiamo1").style.visibility = "hidden";
                resetButton("#btnRichiamo1", labelRichiamo1);
                document.getElementById("messaggioRichiamo1").textContent = "";
            });
            $('.inputRichiamo1').on("click", function () {
                document.getElementById("messaggioRichiamo1").style.visibility = "hidden";
                document.getElementById("messaggioRichiamo1").textContent = "";
                resetButton("#btnRichiamo1", labelRichiamo1);
            });
            $('.inputRichiamo1').on("input", function () {
                document.getElementById("messaggioRichiamo1").style.visibility = "hidden";
                resetButton("#btnRichiamo1", labelRichiamo1);
                document.getElementById("messaggioRichiamo1").textContent = "";
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

            initReport();

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
            <h5><fmt:message key='Servizio_sanitario_provinciale'/></h5> <h3 id="nomeProvincia"></h3>
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
                <a href="#" class="componentControl" id="erogaEsameControl"><fmt:message key='Eroga_esame'/></a>
            </li>
            <li>
                <a href="#"class="componentControl" id="reportControl"><fmt:message key='Report'/></a>
            </li>
            <li>
                <a href="#" class="componentControl" id="richiamo1Control"><fmt:message key='Richiamo'/></a>
            </li>
            <li>
                <a href="#" class="componentControl" id="richiamo2Control"><fmt:message key='Richiama_again'/></a>
            </li>
            <li>
                <a href="#" class="componentControl" id="cambiaPasswordControl"><fmt:message key='Cambia Password'/></a>
            </li>
            <li>
                <a href="../logout?forgetme=0"><fmt:message key='Log_out'/></a>
            </li>
            <li>
                <a href="../logout?forgetme=1"><fmt:message key='Cambia_account'/></a>
            </li>
        </ul>
    </nav>

    <!-- Page Content  -->
    <div id="content">
        <div class="container">
            <button type="button" id="sidebarCollapse" class="btn btn-info">
                <i class="fas fa-align-left"></i>
                <span>Toggle Sidebar</span>
            </button>
        </div>
        <br>

        <div id="erogaEsame" class="tool component">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3><fmt:message key='Eroga_un_esame'/></h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Eroga_esame'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <div class="alert alert-warning" role="alert" id="messaggioCercaPaz"></div>
                                        <form id="formErogaEsame" >
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="idPaziente"><fmt:message key='Nome_del_Paziente'/></label>
                                                    <select class="inputErogaEsame" type="text" id="idPaziente" name="idpaziente" required="required"></select>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idEsame"><fmt:message key='Nome_del_esame'/></label>
                                                    <select class="inputErogaEsame" type="text" id="idEsame" name="idesame" required="required"></select>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem;">
                                                    <label for="esito"><fmt:message key='Esito'/></label>
                                                    <textarea placeholder="<fmt:message key='Scrivi_esito'/>..." class="inputErogaEsame" type="text" id="esito" name="esito" required="required"></textarea>
                                                </div>
                                            </div>
                                            <input required="true" id="idPagato" type="checkbox"><fmt:message key='Ticket_di'/> <fmt:formatNumber value="<%=EsamePrescrittoDAO.PREZZO_TICKET%>" type="currency" currencyCode="EUR"/> <fmt:message key='pagato'/><br>
                                            <div class="form-group container" style="padding-top: 1rem">
                                                <button id="btnErogaEsame" type="submit"><fmt:message key='Eroga'/></button>
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
                        <h3><fmt:message key='Scarica_il_report'/></h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Seleziona_perdiodo'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <div class="alert alert-warning" role="alert" id="messaggioReport"></div>
                                        <form id="formScaricaReport" action="../docs/reportprov" method="GET">
                                            <div class="form-group">
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="fromReport"><fmt:message key='Dal_giorno'/></label>
                                                    <input class="inputReport" type="date" id="fromReport" name="fromDay" required="required"/>
                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="toReport"><fmt:message key='Al giorno'/></label>
                                                    <input class="inputReport" type="date" id="toReport" name="toDay" required="required"/>
                                                </div>
                                                <input type="hidden" name="idprovincia" value="${sessionScope.utente.prov}"/>
                                            </div>
                                            <div class="form-group container">
                                                <button id ="btnReport" type="submit"
                                                        onclick="return checkReport('#fromReport', '#toReport', 'messaggioReport', '#btnReport', 'Il periodo selezione non è valido', 'Scarica')"><fmt:message key='Scarica'/></button>
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
                        <h3><fmt:message key='Effetua_un_richiamo_per_ range_di_età'/></h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Effettua_richiamo'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <div class="alert alert-warning" role="alert" id="messaggioRichiamo1"></div>
                                        <form id="formRichiamo1" >
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo1"><fmt:message key='Limte_inf'/></label>
                                                    <input class="inputRichiamo1" type="number" min="0" id="infetaRichiamo1" name="infeta" required="required"></input>
                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="supetaRichiamo1"><fmt:message key='Limite_sup'/></label>
                                                    <input class="inputRichiamo1" type="number" min="0" id="supetaRichiamo1" name="supeta" required="required"></input>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo1"><fmt:message key='Esame'/></label>
                                                    <select class="inputRichiamo1" type="text" id="idesameRichiamo1" name="idesame" required="required"></select>
                                                </div>
                                            </div>
                                            <div class="form-group container">
                                                <button id ="btnRichiamo1" type="submit"><fmt:message key='Richiama'/></button>
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
                        <h3><fmt:message key='Richiama_again_2'/></h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Effettua_un_richiamo'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formRichiamo2">
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo2"><fmt:message key='Limte_inf'/></label>
                                                    <input class="inputRichiamo2" type="number" min="0" id="infetaRichiamo2" name="infeta" required="required"/>
                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo2"><fmt:message key='Esame'/></label>
                                                    <select class="inputRichiamo2" type="text" id="idesameRichiamo2" name="idesame" required="required"></select>
                                                </div>
                                            </div>
                                            <div class="form-group container">
                                                <button id ="btnRichiamo2" type="submit"><fmt:message key='Richiama'/></button>
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
                        <h3><fmt:message key='Gestione_credenziali'/></h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Cambia Password'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <div class="alert alert-warning" role="alert" id="messaggioCambioPw"></div>
                                        <form id="formCambiaPassword" >
                                            <div class="form-group">
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="vecchiaPassword"><fmt:message key='Vecchia_password'/></label>
                                                    <input class="inputCambiaPassword" type="password" id="vecchiaPassword" name="vecchiaPassword" required="required"/>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="nuovaPassword"><fmt:message key='Nuova_password'/></label>
                                                    <input class="inputCambiaPassword" type="password" id="nuovaPassword" name="nuovaPassword" required="required"/>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="ripetiPassword"><fmt:message key='Ripeti'/></label>
                                                    <input class="inputCambiaPassword" type="password" id="ripetiPassword" name="ripetiPassword" required="required"/>
                                                </div>
                                            </div>
                                            <div class="form-group container">
                                                <button id ="btnCambiaPassword" type="submit"><fmt:message key='Procedi'/></button>
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