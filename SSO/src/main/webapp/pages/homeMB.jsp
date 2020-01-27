<%@ page import="java.io.File" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>
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
        case "profilo":
            break;
        case "pazienti":
            break;
        case "schedaPaz":
            break;
        case "prescFarmaco":
            break;
        case "prescVisita":
            break;
        case "erogaVisita":
            break;
        case "prescEsame":
            break;
        case "cambiaPassword":
            break;
        default:
            session.setAttribute("selectedSection", "pazienti");
            break;
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeMB.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title>Dashboard Medico di Base</title>

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

    <!--DataTables JS -->
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.dataTables.min.css"></link>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css"></link>
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>

    <!-- Utils JS -->
    <script src="../scripts/utils.js"></script>

    <script type="text/javascript">
        let components = new Set();
        let baseUrl = "<%=request.getContextPath()%>";

        const labelLoadingButtons = "loading";
        const labelSuccessButtons = "success";
        const labelErrorButtons = "error";
        let labelAlertFoto = "Puoi caricare file solo con estensione .jpeg/.jpg";

        $(document).ready(function () {
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

            let urlLangDataTable;
            <c:choose>
                <c:when test="${fn:startsWith(language, 'it')}">
                    urlLangDataTable = "https://cdn.datatables.net/plug-ins/1.10.20/i18n/Italian.json";
                </c:when>
                <c:when test="${fn:startsWith(language, 'en')}">
                    urlLangDataTable = "https://cdn.datatables.net/plug-ins/1.10.20/i18n/English.json";
                </c:when>
                <c:when test="${fn:startsWith(language, 'fr')}">
                    urlLangDataTable = "https://cdn.datatables.net/plug-ins/1.10.20/i18n/French.json";
                </c:when>
                <c:otherwise>
                    urlLangDataTable = "https://cdn.datatables.net/plug-ins/1.10.20/i18n/English.json";
                </c:otherwise>
            </c:choose>

            let labelCercaPaz = "Cerca pazienti";

            initSelect2PazientiByMB("#idmedicobaseVisita", ${sessionScope.utente.id}, langSelect2, labelCercaPaz);

            initSelect2PazientiByMB("#idmedicobaseFarmaco", ${sessionScope.utente.id}, langSelect2, labelCercaPaz);

            initSelect2PazientiByMB("#idmedicobaseVisitaSpec", ${sessionScope.utente.id}, langSelect2, labelCercaPaz);

            initSelect2PazientiByMB("#idmedicobaseEsame", ${sessionScope.utente.id}, langSelect2, labelCercaPaz);

            initSelect2PazientiByMB("#idpazienteScheda", ${sessionScope.utente.id}, langSelect2, labelCercaPaz);

            let labelCercaFarm = "Cerca farmaci";

            initSelect2General("farmaci", "#idfarmaco", langSelect2, labelCercaFarm);

            let labelCercaEsami = "Cerca esami";

            initSelect2General("esami", "#idesame", langSelect2, labelCercaEsami);

            let labelCercaVisite = "Cerca visite";

            initSelect2General("visite", "#idvisita", langSelect2, labelCercaVisite);

            let basePathCarousel = "${baseUrl}/<%=Utilities.USER_IMAGES_FOLDER%>/${sessionScope.utente.id}/";
            let extension = ".<%=Utilities.USER_IMAGE_EXT%>";
            initCarousel(${sessionScope.utente.id}, "carouselInnerProfilo", basePathCarousel, extension);

            let labelUpload = document.getElementById("btnUploadFoto").innerHTML;
            initUploadFoto("#formUploadFoto", ${sessionScope.utente.id}, "#btnUploadFoto", labelUpload);

            initAvatar(${sessionScope.utente.id}, "avatarImg", basePathCarousel, extension);

            let labelMismatch = "La controlla di aver scritto correttamente la nuova password";
            let labelWrongPw = "Password vecchia non corretta. Riprova";
            let labelBtnPw = document.getElementById("btnCambiaPassword").innerHTML;
            initCambioPassword("#formCambiaPassword", "#vecchiaPassword", "#nuovaPassword", "#ripetiPassword", ${sessionScope.utente.id},
                "#btnCambiaPassword", "messaggioCambioPw", labelWrongPw, labelMismatch, labelBtnPw);

            let labelErogaVisita = document.getElementById("btnErogaVisita").innerHTML;
            $("#formErogaVisita").submit(function(event){
                loadingButton("#btnErogaVisita",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let urlErogaVisita = baseUrl + "/api/pazienti/"+$("#idmedicobaseVisita").val()+"/visitebase"
                let formData = "idmedicobase=${sessionScope.utente.id}&anamnesi="+$("#anamnesi").val() //Encode form elements for submission
                $.ajax({
                    url : urlErogaVisita,
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.select2ErogaVisita').val(null).trigger("change");
                        $('#anamnesi').val("");
                        successButton("#btnErogaVisita",labelSuccessButtons);
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnErogaVisita",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.select2ErogaVisita').on("change", function () {
                resetButton("#btnErogaVisita", labelErogaVisita);
            });
            $('#anamnesi').on("click", function () {
                resetButton("#btnErogaVisita", labelErogaVisita);
            });

            let labelPrescFarmaco = document.getElementById("btnPrescriviFarmaco").innerHTML;
            $("#formPrescFarmaco").submit(function(event) {
                event.preventDefault(); //prevent default action

                loadingButton("#btnPrescriviFarmaco",labelLoadingButtons)

                let urlPrescFarmaco = baseUrl + "/api/pazienti/"+$('#idmedicobaseFarmaco').val()+"/ricette";
                let formData = "idmedicobase=${sessionScope.utente.id}&idfarmaco="+$("#idfarmaco").val(); //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.select2PrescFarmaco').val(null).trigger("change");
                        successButton("#btnPrescriviFarmaco",labelSuccessButtons);
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        //alert(xhr.responseText);
                        errorButton("#btnPrescriviFarmaco",labelErrorButtons);
                        console.log(xhr.responseText);
                    }
                });
            });
            $('.select2PrescFarmaco').on("change", function () {
                resetButton("#btnPrescriviFarmaco", labelPrescFarmaco);
            });

            let labelPrescEsame = document.getElementById("btnPrescriviEsame").innerHTML;
            $("#formPrescEsame").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("#btnPrescriviEsame",labelLoadingButtons)
                let urlPrescFarmaco = baseUrl + "/api/pazienti/"+$("#idmedicobaseEsame").val()+"/esamiprescritti"
                let formData = "idmedicobase=${sessionScope.utente.id}&idesame="+$("#idesame").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.select2PrescEsame').val(null).trigger("change");
                        successButton("#btnPrescriviEsame",labelSuccessButtons);
                    },
                    complete: function(){

                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnPrescriviEsame",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.select2PrescEsame').on("change", function () {
                resetButton("#btnPrescriviEsame", labelPrescEsame);
            });

            let labelPrescVisita = document.getElementById("btnPrescriviVisita").innerHTML;
            $("#formPrescVisita").submit(function(event){
                loadingButton("#btnPrescriviVisita",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let urlPrescVisita = baseUrl + '/api/pazienti/'+$('#idmedicobaseVisitaSpec').val()+'/visitespecialistiche'
                let formData = "idmedicobase=${sessionScope.utente.id}&idvisita="+$("#idvisita").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescVisita,
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        $('.select2PrescVisita').val(null).trigger("change");
                        successButton("#btnPrescriviVisita",labelSuccessButtons);
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnPrescriviVisita",labelErrorButtons)
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.select2PrescVisita').on("change", function () {
                resetButton("#btnPrescriviVisita", labelPrescVisita);
            });

            let basePathScheda = "${baseUrl}/<%=Utilities.USER_IMAGES_FOLDER%>/";
            initFormSchedaPaz(basePathScheda, extension, "${fn:replace(language, '_', '-')}", urlLangDataTable);

            $("#profiloControl").click(() => showComponent("profilo"));
            $("#pazientiControl").click(() => {
                showComponent("pazienti");
                $("#tablePazienti").DataTable().destroy()
                let urlPazienti = baseUrl + "/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=true";
                $("#tablePazienti").DataTable( {
                    "autoWidth": false,
                    "responsive": true,
                    "processing": true,
                    "ordering": true,
                    "scrollX": false,
                    "paging": true,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlPazienti,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++){
                                if (json[i].dataUltimaVisitaBase != undefined && json[i].getDataUltimaRicetta != undefined) {
                                    let visita = new Date(json[i].dataUltimaVisitaBase)
                                    visita=visita.toLocaleDateString("${fn:replace(language, '_', '-')}",options)
                                    let ricetta = new Date(json[i].getDataUltimaRicetta)
                                    ricetta = ricetta.toLocaleDateString("${fn:replace(language, '_', '-')}",options)
                                    let nascita = new Date(json[i].paziente.dataNascita)
                                    nascita = nascita.toLocaleDateString("${fn:replace(language, '_', '-')}")
                                    returnData.push({
                                        'nome': json[i].paziente.nome,
                                        'cognome': json[i].paziente.cognome,
                                        'dataNascita': nascita,
                                        'luogoNascita': json[i].paziente.luogoNascita,
                                        'codiceFiscale': json[i].paziente.codiceFiscale,
                                        'sesso': json[i].paziente.sesso,
                                        'email': json[i].paziente.email,
                                        'dataUltimaVisitaBase': visita,
                                        'getDataUltimaRicetta':  ricetta,
                                    })
                                }
                                if (json[i].dataUltimaVisitaBase == undefined && json[i].getDataUltimaRicetta != undefined){
                                    let ricetta = new Date(json[i].getDataUltimaRicetta)
                                    ricetta=ricetta.toLocaleDateString("${fn:replace(language, '_', '-')}",options)
                                    let nascita = new Date(json[i].paziente.dataNascita)
                                    nascita = nascita.toLocaleDateString("${fn:replace(language, '_', '-')}")
                                    returnData.push({
                                        'nome': json[i].paziente.nome,
                                        'cognome': json[i].paziente.cognome,
                                        'dataNascita': nascita,
                                        'luogoNascita': json[i].paziente.luogoNascita,
                                        'codiceFiscale': json[i].paziente.codiceFiscale,
                                        'sesso': json[i].paziente.sesso,
                                        'email': json[i].paziente.email,
                                        'dataUltimaVisitaBase': "",
                                        'getDataUltimaRicetta':  ricetta,
                                    })
                                }
                                if (json[i].dataUltimaVisitaBase != undefined && json[i].getDataUltimaRicetta == undefined){
                                    let visita = new Date(json[i].dataUltimaVisitaBase)
                                    visita=visita.toLocaleDateString("${fn:replace(language, '_', '-')}",options)
                                    let nascita = new Date(json[i].paziente.dataNascita)
                                    nascita = nascita.toLocaleDateString("${fn:replace(language, '_', '-')}")
                                    returnData.push({
                                        'nome': json[i].paziente.nome,
                                        'cognome': json[i].paziente.cognome,
                                        'dataNascita': nascita,
                                        'luogoNascita': json[i].paziente.luogoNascita,
                                        'codiceFiscale': json[i].paziente.codiceFiscale,
                                        'sesso': json[i].paziente.sesso,
                                        'email': json[i].paziente.email,
                                        'dataUltimaVisitaBase':  visita,
                                        'getDataUltimaRicetta': "",
                                    })
                                }
                                if (json[i].dataUltimaVisitaBase == undefined && json[i].getDataUltimaRicetta == undefined){
                                    let nascita = new Date(json[i].paziente.dataNascita)
                                    nascita = nascita.toLocaleDateString("${fn:replace(language, '_', '-')}")
                                    returnData.push({
                                        'nome': json[i].paziente.nome,
                                        'cognome': json[i].paziente.cognome,
                                        'dataNascita': nascita,
                                        'luogoNascita': json[i].paziente.luogoNascita,
                                        'codiceFiscale': json[i].paziente.codiceFiscale,
                                        'sesso': json[i].paziente.sesso,
                                        'email': json[i].paziente.email,
                                        'dataUltimaVisitaBase': "",
                                        'getDataUltimaRicetta': "",
                                    })
                                }
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "nome" },
                        { "data": "cognome" },
                        { "data": "dataNascita" },
                        { "data": "luogoNascita" },
                        { "data": "codiceFiscale" },
                        { "data": "sesso" },
                        { "data": "email" },
                        { "data": "dataUltimaVisitaBase"},
                        { "data": "getDataUltimaRicetta" }
                    ]
                } );
            });
            $("#prescFarmacoControl").click(() => showComponent("prescFarmaco"));
            $("#prescVisitaControl").click(() => showComponent("prescVisita"));
            $('#erogaVisitaControl').click(() => showComponent("erogaVisita"));
            $('#prescEsameControl').click(() => showComponent("prescEsame"));
            $('#schedaPazControl').click(() => showComponent("schedaPaz"));
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
                <img id="avatarImg" class="avatar" data-holder-rendered="true">
                <br><br>
                <h4>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h4>
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

            <ul class="list-unstyled">
                <li>
                    <a href="#" class="componentControl" id="pazientiControl"><fmt:message key="paz"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="schedaPazControl"><fmt:message key="scpaz"/></a>
                </li>
                <li>
                    <a href="#"  class="componentControl" id="prescFarmacoControl"><fmt:message key="presfar"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="prescVisitaControl"><fmt:message key="presvis"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="prescEsameControl"><fmt:message key="preses"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="erogaVisitaControl"><fmt:message key="erovis"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="profiloControl"><fmt:message key="profilo"/></a>
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
            <div class="container">
                <button type="button" id="sidebarCollapse" class="btn btn-info">
                    <i class="fas fa-align-left"></i>
                    <span>Toggle Sidebar</span>
                </button>
            </div>
            <br>
            <div id="profilo" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="text-center">
                                    <div data-interval="false" id="carouselProfiloControls" class="carousel slide"
                                         data-ride="carousel">
                                        <div id="carouselInnerProfilo" class="carousel-inner">

                                        </div>
                                        <a class="carousel-control-prev" href="#carouselProfiloControls" role="button"
                                           data-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#carouselProfiloControls" role="button"
                                           data-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div style="clear: both">
                                        <form action="#" id="formUploadFoto" method="POST" role="form" enctype="multipart/form-data">
                                            <div>
                                                <input style="/*float: left;*/  max-width: 100%" class="btn btn-primary" type="file" id="fotoToUpload" name="foto"
                                                       onchange="return fileValidation('fotoToUpload', 'btnUploadFoto', labelAlertFoto)"/>
                                                <br>
                                                <button style="/*float:right;*/ height: 35pt; background: grey;" class="btn btn-primary" type="submit" id="btnUploadFoto" disabled><fmt:message key="carica"/> </button>
                                            </div>
                                        </form>
                                    </div>
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <hr>
                                        <h5 style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 align="right">${sessionScope.utente.nome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 align="right">${sessionScope.utente.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><b><fmt:message key="sesso"/></b>:  </h5>
                                        <h5 align="right">${sessionScope.utente.sesso}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><b><fmt:message key="codfis"/></b>:  </h5>
                                        <h5 align="right">${sessionScope.utente.codiceFiscale}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><b><fmt:message key="datanas"/></b>:  </h5>
                                        <h5 align="right"><fmt:formatDate value="${sessionScope.utente.dataNascita}"/></h5>
                                    </div>
                                    <hr>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="pazienti" class="container-fluid component">
                <h3>Visualizza il tuo parco pazienti</h3>
                <hr>
                <div class="container-fluid">
                    <table id="tablePazienti" class="table table-striped table-hover responsive nowrap display" style="width:100%">
                        <thead>
                        <tr>
                            <th><fmt:message key="nome"/></th>
                            <th><fmt:message key="cognome"/></th>
                            <th><fmt:message key="datanas"/></th>
                            <th><fmt:message key="luogonas"/></th>
                            <th><fmt:message key="codfis"/></th>
                            <th><fmt:message key="sesso"/></th>
                            <th><fmt:message key="email"/></th>
                            <th><fmt:message key="ulvisbas"/></th>
                            <th><fmt:message key="ulricpres"/></th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>

            <div id="schedaPaz" class="tool component  container-fluid" >
                <h3><fmt:message key="selpaz"/></h3>
                <hr>
                <form id="formScheda" class="container" style="max-width: 200px" >
                    <div class="row">
                        <div class="form-group">
                            <label  class="col-sm" for="idpazienteScheda"><fmt:message key="nomepaz"/></label>
                            <select class="col-sm" style="max-width: 200px" type="text" id="idpazienteScheda" name="idpazienteScheda" required="required"></select>
                            <button class="col-sm" class="bottone" style="margin-top: 1em" type="submit"><fmt:message key="cerca"/></button>
                        </div>
                    </div>
                </form>
                <br>

                <div id="schedaPaziente" class="container-fluid">
                    <div class="text-center">
                        <div data-interval="false" id="carouselPazienteControls" class="carousel slide"
                             data-ride="carousel">
                            <div id="carouselInnerPaziente" class="carousel-inner">

                            </div>
                            <a class="carousel-control-prev" href="#carouselPazienteControls" role="button"
                               data-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="sr-only">Previous</span>
                            </a>
                            <a class="carousel-control-next" href="#carouselPazienteControls" role="button"
                               data-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="sr-only">Next</span>
                            </a>
                        </div>
                    </div>
                    <h5><fmt:message key="datipaz"/></h5>
                    <div class="container-fluid">
                        <table id="dataPazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nome"/></th>
                                <th><fmt:message key="cognome"/></th>
                                <th><fmt:message key="datanas"/></th>
                                <th><fmt:message key="luogonas"/></th>
                                <th><fmt:message key="codfis"/></th>
                                <th><fmt:message key="sesso"/></th>
                                <th><fmt:message key="email"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="visbas"/></h5>
                    <div class="container-fluid">
                        <table id="visiteBasePazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="dataero"/></th>
                                <th><fmt:message key="anamn"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>

                    <br/>
                    <h5><fmt:message key="ricev"/></h5>
                    <div class="container-fluid">
                        <table id="ricetteEvasePazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomefar"/></th>
                                <th><fmt:message key="desfar"/></th>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                                <th><fmt:message key="evas"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="ricnevas"/></h5>
                    <div class="container-fluid">
                        <table id="ricetteNonEvasePazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomefar"/></th>
                                <th><fmt:message key="desfar"/></th>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="esero"/></h5>
                    <div class="container-fluid">
                        <table id="esamiErogatiPazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomeesa"/></th>
                                <th><fmt:message key="descresa"/></th>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                                <th><fmt:message key="ero"/></th>
                                <th><fmt:message key="esito"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="esnero"/></h5>
                    <div class="container-fluid">
                        <table id="esamiNonErogatiPazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomeesa"/></th>
                                <th><fmt:message key="descresa"/></th>
                                <th><fmt:message key="nomem"/></th>
                                <th><fmt:message key="cognomem"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="visspecero"/></h5>
                    <div class="container-fluid">
                        <table id="visiteSpecialisticheErogatePazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomevis"/></th>
                                <th><fmt:message key="nomems"/></th>
                                <th><fmt:message key="cognomems"/></th>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                                <th><fmt:message key="ero"/></th>
                                <th><fmt:message key="anamn"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <br/>
                    <h5><fmt:message key="visspecnero"/></h5>
                    <div class="container-fluid">
                        <table id="visiteSpecialisticheNonErogatePazienteScheda" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th><fmt:message key="nomevis"/></th>
                                <th><fmt:message key="nomemb"/></th>
                                <th><fmt:message key="cognomemb"/></th>
                                <th><fmt:message key="prescrizione"/></th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>

            <div id="prescFarmaco" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key="presfarpaz"/></h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key="presfar"/></h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescFarmaco" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseFarmaco"><fmt:message key="nomepaz"/></label>
                                                        <select class="select2PrescFarmaco" type="text" id="idmedicobaseFarmaco" name="idmedicobaseFarmaco" required="required"></select>
                                                    </div>
                                                    <div class="container" style="padding-top: 1rem">
                                                        <label for="idfarmaco"><fmt:message key="nomefar"/></label>
                                                        <select class="select2PrescFarmaco" type="text" id="idfarmaco" name="idfarmaco" required="required"></select>
                                                    </div>
                                                </div>
                                                <div class="form-group popup container">
                                                    <button id ="btnPrescriviFarmaco" type="submit" class="btn btn-primary " >Prescrivi</button>
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

            <div id="prescVisita" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key="presvisspecpaz"/></h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key="presvis"/></h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescVisita" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseVisitaSpec"><fmt:message key="nomepaz"/></label>
                                                        <select type="text" class="select2PrescVisita" id="idmedicobaseVisitaSpec" name="idmedicobaseVisitaSpec" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idvisita"><fmt:message key="nomevis"/></label>
                                                        <select class="select2PrescVisita" type="text" id="idvisita" name="idvisita" required="required"></select>
                                                    </div>
                                                </div>
                                                <div class="form-group container">
                                                    <button id ="btnPrescriviVisita" class="btn btn-primary" type="submit"><fmt:message key="pres"/></button>
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

            <div id="prescEsame" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key="presespaz"/></h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key="preses"/></h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescEsame" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseEsame"><fmt:message key="nomepaz"/></label>
                                                        <select class="select2PrescEsame" type="text" id="idmedicobaseEsame" name="idmedicobaseEsame" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idesame"><fmt:message key="nomeesa"/></label>
                                                        <select class="select2PrescEsame" type="text" id="idesame" name="idesame" required="required"></select>
                                                    </div>
                                                </div>
                                                <div class="form-group container">
                                                    <button id ="btnPrescriviEsame" type="submit"><fmt:message key="pres"/></button>
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

            <div id="erogaVisita" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key="erovispaz"/></h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key="erovis"/></h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formErogaVisita" >
                                                <div class="form-group">
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idmedicobaseVisita"><fmt:message key="nomepaz"/></label>
                                                        <select class="select2ErogaVisita inputErogaVisita" type="text" id="idmedicobaseVisita" name="idmedicobaseVisita" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="anamnesi"><fmt:message key="anamn"/></label>
                                                        <textarea placeholder="Scrivi l'anamnesi..." class="inputErogaVisita textAreaAnamnesi" type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group container">
                                                    <button id ="btnErogaVisita" type="submit"><fmt:message key="erovis"/></button>
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
                                                <div class="form-group container">
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