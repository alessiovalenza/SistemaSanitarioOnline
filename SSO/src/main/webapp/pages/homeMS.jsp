<%@ page import="java.io.File" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Locale" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.VisitaMedicoSpecialistaDAO" %>

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
        case "schedaPaz":
            break;
        case "erogaVisitaSpec":
            break;
        case "cambiaPassword":
            break;
        default:
            session.setAttribute("selectedSection", "erogaVisitaSpec");
            break;
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeMS.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key='Dashboard_MS'/></title>

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

    <!--DataTables JS -->
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.dataTables.min.css"></link>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css"></link>
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>

    <!-- Utils JS -->
    <script src="../scripts/utils.js"></script>

    <script>
        let components = new Set();
        let baseUrl = "<%=request.getContextPath()%>";

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
                    urlLangDataTable = "https://cdn.datatables.net/plug-ins/1.10.20/i18n/Italian.json";
                </c:otherwise>
            </c:choose>

            let basePathCarousel = "${baseUrl}<%=File.separator + Utilities.USER_IMAGES_FOLDER + File.separator%>${sessionScope.utente.id}<%=File.separator%>";
            let extension = ".<%=Utilities.USER_IMAGE_EXT%>";
            initCarousel(${sessionScope.utente.id}, "carouselInnerProfilo", basePathCarousel, extension);

            let labelUpload = document.getElementById("btnUploadFoto").innerHTML;
            initUploadFoto("#formUploadFoto", ${sessionScope.utente.id}, "#btnUploadFoto", labelUpload);

            initAvatar(${sessionScope.utente.id}, "avatarImg", basePathCarousel, extension);

            let labelMismatch = "<fmt:message key='Controlla'/>";
            let labelWrongPw = "<fmt:message key='Riprova'/>";
            let labelBtnPw = document.getElementById("btnCambiaPassword").innerHTML;
            initCambioPassword("#formCambiaPassword", "#vecchiaPassword", "#nuovaPassword", "#ripetiPassword", ${sessionScope.utente.id},
                "#btnCambiaPassword", "messaggioCambioPw", labelWrongPw, labelMismatch, labelBtnPw);

            let labelCercaPaz = "<fmt:message key='Cerca_pazienti'/>";
            initSelect2Pazienti("#idpazienteErogaVisitaSpec", null, langSelect2, labelCercaPaz);
            let labelCercaVisitaSpec = "<fmt:message key='Cerca_visita_specialistica'/>";
            $("#idvisitaErogaVisitaSpec").select2({
                placeholder: labelCercaVisitaSpec,
                language: langSelect2,
                width: "100%",
                allowClear: true,
                ajax: {
                    url: function () {
                        let urlSelectVisiteSpec = baseUrl + '/api/pazienti/' +
                            $('#idpazienteErogaVisitaSpec').children("option:selected").val() +
                            '/visitespecialistiche/?erogateonly=false&nonerogateonly=true'
                        return urlSelectVisiteSpec
                    },
                    datatype: "json",
                    data: function (params) {
                        var query = {
                            term: params.term,
                            type: 'public',
                            page: params.page || 1
                        }
                        return query;
                    },
                    processResults: function (data) {
                        var myResults = [];
                        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };

                        $.each(data, function (index, item) {
                            let prescrizione = new Date(item.prescrizione);
                            prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}");
                            myResults.push({
                                'id': item.id,
                                'text': item.visita.nome + " prescritta da " +
                                    item.medicoBase.nome + " " + item.medicoBase.cognome +" il " + prescrizione
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

            let labelErogaVisitaSpec = document.getElementById("btnErogaVisitaSpec").innerHTML;
            $("#formErogaVisitaSpec").submit(function(event){
                loadingButton("#btnErogaVisitaSpec",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let form_data = "idmedicospec=${sessionScope.utente.id}&anamnesi="+$("#anamnesi").val()
                let urlErogaVisitaSpec=baseUrl + "/api/pazienti/"+$("#idpazienteErogaVisitaSpec").val()+"/visitespecialistiche/"+$("#idvisitaErogaVisitaSpec").val()
                $.ajax({
                    url : urlErogaVisitaSpec,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {
                        $("#idPagato").prop("checked",false);
                        $('.select2ErogaVisitaSpec').val(null).trigger("change");
                        $("#anamnesi").val("");
                        successButton("#btnErogaVisitaSpec",labelSuccessButtons);
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnErogaVisitaSpec",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.select2ErogaVisitaSpec').on("change", function () {
                resetButton("#btnErogaVisitaSpec", labelErogaVisitaSpec);
                $("#idPagato").prop("checked",false);
            });
            $('#anamnesi').on("click", function () {
                resetButton("#btnErogaVisitaSpec", labelErogaVisitaSpec);
                $("#idPagato").prop("checked",false);
            });
            $('#anamnesi').on("input", function () {
                resetButton("#btnErogaVisitaSpec", labelErogaVisitaSpec);
                $("#idPagato").prop("checked",false);
            });

            initSelect2Pazienti("#idpazienteScheda", null, langSelect2, labelCercaPaz);
            let basePathScheda = "${baseUrl}/<%=Utilities.USER_IMAGES_FOLDER%>/";
            initFormSchedaPaz(basePathScheda, extension, "${fn:replace(language, '_', '-')}", urlLangDataTable);

            populateComponents();
            hideComponents();

            $('#erogaVisitaSpecControl').click(() => showComponent('erogaVisitaSpec'));
            $('#schedaPazControl').click(() => showComponent('schedaPaz'));
            $('#profiloControl').click(() => showComponent('profilo'));
            $('#cambiaPasswordControl').click(() => showComponent('cambiaPassword'));

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

            <ul class="list-unstyled components">
                <li>
                    <a href="#" class="componentControl" id="erogaVisitaSpecControl">Eroga visita<fmt:message key='Eroga_visita'/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="schedaPazControl">Visualizza scheda paziente<fmt:message key='Visualizza_scheda_paziente'/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="profiloControl"><fmt:message key="profilo"/></a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="cambiaPasswordControl">Cambia password<fmt:message key='Cambia Password'/></a>
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

            <div id="erogaVisitaSpec" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key='Eroga_visita_specialistica'/></h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key='Eroga_visita'/></h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formErogaVisitaSpec" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idpazienteErogaVisitaSpec"><fmt:message key='Paziente'/></label>
                                                        <select class="select2ErogaVisitaSpec" type="text" id="idpazienteErogaVisitaSpec" name="idpazienteErogaVisitaSpec" required="required"></select>
                                                        <br>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idvisitaErogaVisitaSpec"><fmt:message key='Visita_specialistica'/></label>
                                                        <select class="select2ErogaVisitaSpec" type="text" id="idvisitaErogaVisitaSpec" name="idvisitaErogaVisitaSpec" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="anamnesi"><fmt:message key='Anamnesi'/></label>
                                                        <textarea placeholder="Scrivi l'anamnesi..." class="textAreaAnamnesi" type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <input required="true" id="idPagato" type="checkbox"><fmt:message key='Ticket_di'/> <fmt:formatNumber value="<%=VisitaMedicoSpecialistaDAO.PREZZO_TICKET%>" type="currency" currencyCode="EUR"/> <fmt:message key='pagato'/><br>
                                                <div class="form-group">
                                                    <div class="container"style="padding-top: 1rem" >
                                                            <button id="btnErogaVisitaSpec" type="submit"><fmt:message key='Eroga'/></button>
                                                    </div>
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

            <div id="cambiaPassword" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key='Gestione_password'/></h3>
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
                                                <div class="form-group">
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