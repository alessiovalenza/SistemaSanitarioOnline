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
        case "medico":
            break;
        case "cambiaMedico":
            break;
        case "esami":
            break;
        case "ricette":
            break;
        case "visiteBase":
            break;
        case "visiteSpecialistiche":
            break;
        case "cambiaPassword":
            break;
        default:
            session.setAttribute("selectedSection", "profilo");
            break;
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeP.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key='Dashboard_P'/></title>

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
        const labelLoadingButtons = "<fmt:message key='Loading'/>";
        const labelSuccessButtons = "<fmt:message key='Succed'/>";
        const labelErrorButtons = "<fmt:message key='Error'/>";
        let baseUrl = "<%=request.getContextPath()%>";

        $(document).ready(function(){

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

            let basePathCarousel = "${baseUrl}/<%=Utilities.USER_IMAGES_FOLDER%>/${sessionScope.utente.id}/";
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

            let labelCambiaMed = document.getElementById("btnCambiaMedico").innerHTML;
            $("#formPutCambiaMedico").submit(function(event){
                loadingButton("#btnCambiaMedico",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let formData = "idmedicobase="+$("#idmedicobase").val(); //Encode form elements for submission
                let url = baseUrl + '/api/pazienti/' + ${sessionScope.utente.id} + '/medicobase'

                $.ajax({
                    url : url,
                    type: "PUT",
                    data : formData,
                    success: function (data) {
                        $('#idmedicobase').val(null).trigger("change")
                        successButton("#btnCambiaMedico", labelSuccessButtons);
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnCambiaMedico",labelErrorButtons);
                        console.log(xhr.responseText);
                        //alert(xhr.responseText);
                    }
                });
            });
            $("#idmedicobase").on("change", function () {
                resetButton("#btnCambiaMedico", labelCambiaMed);
            });

            $("#medicoControl").click(function(){
                let url = baseUrl + '/api/pazienti/${sessionScope.utente.id}/medicobase';
                $.ajax({
                    type: "GET",
                    url: url,
                    success: function (data) {
                        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };

                        let fields = data;

                        let nome = fields["nome"];
                        let cognome = fields["cognome"];
                        let email = fields["email"];
                        let sesso = fields["sesso"];
                        let cf = fields["codiceFiscale"];
                        let dataNascita = new Date(fields["dataNascita"]);
                        dataNascita = dataNascita.toLocaleDateString("${fn:replace(language, '_', '-')}",options);

                        $("#nomeMedico").html(nome);
                        $("#cognomeMedico").html(cognome);
                        $("#sessoMedico").html(sesso);
                        $("#emailMedico").html(email);
                        $("#dataNascitaMedico").html(dataNascita);
                        $("#codiceFiscaleMedico").html(cf);
                    },
                    error: function(xhr, status, error) {
                        console.log(xhr.responseText);
                    }
                });

            });

            $("#esamiControl").click(function(){
                $('#esamiErogati').DataTable().destroy();
                $('#esamiNonErogati').DataTable().destroy();
                let urlEsamiNonErogati = baseUrl + "/api/pazienti/${sessionScope.utente.id}/esamiprescritti?erogationly=false&nonerogationly=true";
                $('#esamiNonErogati').DataTable( {
                    "autoWidth": false,
                    "responsive": true,
                    "processing": true,
                    "scrollX": false,
                    "ordering": true,
                    "paging": true,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlEsamiNonErogati,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let prescrizione = new Date(json[i].prescrizione);
                                prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'nomeEsame': json[i].esame.nome,
                                    'descrizioneEsame': json[i].esame.descrizione,
                                    'cognomeMedicoBase': json[i].medicoBase == undefined ? "SSP" : json[i].medicoBase.cognome,
                                    'nomeMedicoBase': json[i].medicoBase == undefined ? "SSP" : json[i].medicoBase.nome,
                                    'prescrizione': prescrizione
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log("errore");
                        }
                    },
                    "columns": [
                        { "data": "nomeEsame" },
                        { "data": "descrizioneEsame" },
                        { "data": "nomeMedicoBase" },
                        { "data": "cognomeMedicoBase" },
                        { "data": "prescrizione" }
                    ]
                } );
                let urlEsamiErogati = baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id} +"/esamiprescritti?erogationly=true&nonerogationly=false";
                $('#esamiErogati').DataTable( {
                    "autoWidth": false,
                    "responsive": true,
                    "processing": true,
                    "scrollX": false,
                    "ordering": true,
                    "paging": true,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlEsamiErogati,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let prescrizione = new Date(json[i].prescrizione);
                                prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                let erogazione = new Date(json[i].erogazione);
                                erogazione=erogazione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'nomeEsame': json[i].esame.nome,
                                    'descrizioneEsame': json[i].esame.descrizione,
                                    'cognomeMedicoBase': json[i].medicoBase == undefined ? "SSP" : json[i].medicoBase.cognome,
                                    'nomeMedicoBase': json[i].medicoBase == undefined ? "SSP" : json[i].medicoBase.nome,
                                    'prescrizione': prescrizione,
                                    'erogazione': erogazione,
                                    'esito': json[i].esito,
                                    'downloadRicevuta': "<a href='${baseUrl}/docs/ricevute?tipo=esame&id=" + String(json[i].id) + "'>" +
                                        "<img style='width: 30px; height: 30px;'" +
                                        "src='${baseUrl}/assets/img/pdf.png'/>" +
                                        "</a>"
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log("errore");
                        }
                    },
                    "columns": [
                        { "data": "nomeEsame" },
                        { "data": "descrizioneEsame" },
                        { "data": "nomeMedicoBase" },
                        { "data": "cognomeMedicoBase" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "esito" },
                        { "data": "downloadRicevuta"}
                    ]
                } );
            });

            let urlCambioMedico = baseUrl + '/api/general/medicibase/?idprovincia='+'${sessionScope.utente.prov}'

            $("#idmedicobase").select2({
                placeholder: '<fmt:message key="Cerca medici"/>',
                language: langSelect2,
                width: '100%',
                allowClear: true,
                ajax: {
                    url: urlCambioMedico,
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
                        $.each(data, function (index, item) {
                            if (item.id != ${sessionScope.utente.id}) {
                                myResults.push({
                                    'id': item.id,
                                    'text': item.nome
                                });
                            }
                        });
                        return {
                            results: myResults
                        };
                    },
                    error: function(xhr, status, error) {
                        console.log("errore");
                    }
                }
            });

            $("#ricetteControl").click(function(){
                $('#ricetteEvase').DataTable().destroy()
                $('#ricetteNonEvase').DataTable().destroy()

                let urlRicetteNonEvase = baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=false&nonevaseonly=true";
                $('#ricetteNonEvase').DataTable( {
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
                        "url": urlRicetteNonEvase,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let emissione = new Date(json[i].emissione);
                                emissione=emissione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                console.log("aaaaaaaaaaa " + json[i].id);
                                returnData.push({
                                    'farmacoNome': json[i].farmaco.nome,
                                    'farmacoDescrizione': json[i].farmaco.descrizione,
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'emissione': emissione,
                                    'downloadRicetta': "<a href='${baseUrl}/docs/ricette?id=" + String(json[i].id) + "'>" +
                                        "<img style='width: 30px; height: 30px;'" +
                                        "src='${baseUrl}/assets/img/pdf.png'/>" +
                                        "</a>"
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log(xhr.responseText);
                            //alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "farmacoNome" },
                        { "data": "farmacoDescrizione" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "emissione" },
                        { "data": "downloadRicetta"}
                    ]
                } );


                let urlRicetteEvase = baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id}+"/ricette/?evaseonly=true&nonevaseonly=false"
                $('#ricetteEvase').DataTable( {
                    "autoWidth": false,
                    "responsive": true,
                    "processing": true,
                    "ordering": true,
                    "paging": true,
                    "scrollX": false,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlRicetteEvase,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let emissione = new Date(json[i].emissione);
                                emissione=emissione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                let evasione = new Date(json[i].evasione);
                                evasione=evasione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'farmacoNome': json[i].farmaco.nome,
                                    'farmacoDescrizione': json[i].farmaco.descrizione,
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'emissione': emissione,
                                    'evasione': evasione,
                                    'downloadRicevuta': "<a href='${baseUrl}/docs/ricevute?tipo=ricetta&id=" + String(json[i].id) + "'>" +
                                        "<img style='width: 30px; height: 30px;'" +
                                        "src='${baseUrl}/assets/img/pdf.png'/>" +
                                        "</a>"
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log(xhr.responseText);
                            //alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "farmacoNome" },
                        { "data": "farmacoDescrizione" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "emissione" },
                        { "data": "evasione" },
                        { "data": "downloadRicevuta"}
                    ]
                } );


            });

            $("#visiteBaseControl").click(function () {
                $('#visiteBaseTable').DataTable().destroy()
                let urlVisiteBase = baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id} +"/visitebase"
                let table = $('#visiteBaseTable').DataTable( {
                    "autoWidth": false,
                    "responsive": true,
                    "processing": true,
                    "scrollX": false,
                    "ordering": true,
                    "paging": true,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlVisiteBase,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let erogazione = new Date(json[i].erogazione);
                                erogazione=erogazione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'erogazione': erogazione,
                                    'anamnesi': json[i].anamnesi
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log(xhr.responseText);
                            //alert(xhr.responseText);
                        }
                    },
                    "columnDefs": [
                        { className: "anamnesiColumn", targets: 3 }
                    ],
                    "columns": [
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "erogazione" },
                        { "data": "anamnesi" }
                    ]
                } );
            })

            $("#visiteSpecialisticheControl").click(function () {
                $('#visiteSpecialisticheErogate').DataTable().destroy()
                let urlVisiteSpacialisticheErogate = baseUrl + "/api/pazienti/" + ${sessionScope.utente.id} + "/visitespecialistiche/?erogateonly=true&nonerogateonly=false"
                $('#visiteSpecialisticheErogate').DataTable( {
                    "autoWidth": false,
                    "processing": true,
                    "responsive": true,
                    "scrollX": false,
                    "ordering": true,
                    "paging": true,
                    "searching": true,
                    "serverSide": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlVisiteSpacialisticheErogate,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let prescrizione = new Date(json[i].prescrizione);
                                prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                let erogazione = new Date(json[i].erogazione);
                                erogazione=erogazione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'visitaNome': json[i].visita.nome,
                                    'medicoSpecialistaCognome': json[i].medicoSpecialista.cognome,
                                    'medicoSpecialistaNome': json[i].medicoSpecialista.nome,
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'prescrizione': prescrizione,
                                    'erogazione': erogazione,
                                    'anamnesi': json[i].anamnesi,
                                    'downloadRicevuta': "<a href='${baseUrl}/docs/ricevute?tipo=visita&id=" + String(json[i].id) + "'>" +
                                        "<img style='width: 30px; height: 30px;'" +
                                        "src='${baseUrl}/assets/img/pdf.png'/>" +
                                        "</a>"
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log(xhr.responseText);
                            //alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "visitaNome" },
                        { "data": "medicoSpecialistaNome" },
                        { "data": "medicoSpecialistaCognome" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "anamnesi" },
                        { "data": "downloadRicevuta"}
                    ]
                } );

                $('#visiteSpecialisticheNonErogate').DataTable().destroy()
                let urlVisiteSpacialisticheNonErogate = baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id}+"/visitespecialistiche/?erogateonly=false&nonerogateonly=true"
                $('#visiteSpecialisticheNonErogate').DataTable( {
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
                        "url": urlVisiteSpacialisticheNonErogate,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            for(let i=0;i< json.length; i++) {
                                let prescrizione = new Date(json[i].prescrizione);
                                prescrizione=prescrizione.toLocaleDateString("${fn:replace(language, '_', '-')}",options);
                                returnData.push({
                                    'visitaNome': json[i].visita.nome,
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'prescrizione': prescrizione
                                });
                            }
                            return returnData;
                        },
                        "error": function(xhr, status, error) {
                            console.log(xhr.responseText);
                            //alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "visitaNome" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "prescrizione" }
                    ]
                } );

            })

            function notifyMe() {
                // Let's check if the browser supports notifications
                if (!("Notification" in window)) {
                    alert("<fmt:message key='This_browser'/>");
                }

                // Let's check whether notification permissions have already been granted
                else if (Notification.permission === "granted") {
                    // If it's okay let's create a notification
                    var notification = new Notification("<fmt:message key='alert_farmacia'/> ;)");
                }

                // Otherwise, we need to ask the user for permission
                else if (Notification.permission !== "denied") {
                    Notification.requestPermission().then(function (permission) {
                        // If the user accepts, let's create a notification
                        if (permission === "granted") {
                            var notification = new Notification("<fmt:message key='alert_farmacia_2'/> ;)");
                        }
                    });
                }
            }

            function sendEmail(){
                $.get("../mappeEmail.jsp")
            }

            navigator.geolocation.getCurrentPosition(showPosition);

            function showPosition(position) {
                $.ajax({
                    type: "GET",
                    url: "https://places.sit.ls.hereapi.com/places/v1/discover/search"+
                        "?app_id=eXyeKXjLMDyo92pFfzNf"+
                        "&app_code=QuU-fH5ZjNfHHzf2IZHEkg"+
                        "&at="+ position.coords.latitude + "," + position.coords.longitude +
                        "&q=pharmacies"+
                        "&pretty",
                    success: function (data) {
                        if (data.results && data.results.items) {

                            var distance = data.results.items[0].distance;
                            $.ajax({
                                type: "GET",
                                url: baseUrl + "/api/pazienti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=false&nonevaseonly=true",
                                success: function (data) {
                                    if (data[0] && distance <= 2000) {
                                        notifyMe();
                                        $(sendEmail());
                                    }
                                },
                                error: function(xhr, status, error) {
                                    console.log("errore");
                                }
                            });

                        } else {
                            onError(data);
                        }
                    },
                    error: function(xhr, status, error) {

                        console.log("errore" + xhr.responseText);
                    }

                });
            }

            populateComponents();
            hideComponents();

            $('#profiloControl').click(() => showComponent('profilo'));
            $('#medicoControl').click(() => showComponent('medico'));
            $('#cambiaMedicoControl').click(() => showComponent('cambiaMedico'));
            $('#esamiControl').click(() => showComponent('esami'));
            $('#ricetteControl').click(() => showComponent('ricette'));
            $('#visiteBaseControl').click(() => showComponent('visiteBase'));
            $('#visiteSpecialisticheControl').click(() => showComponent('visiteSpecialistiche'));
            //$('#mappeControl').click(() => showComponent('mappe'));
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
                <img class="avatar" id="avatarImg" data-holder-rendered="true">
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
                    <a href="#" class="componentControl" id="medicoControl"><fmt:message key='Visualizza_MB'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="cambiaMedicoControl"><fmt:message key='Cambia_MB'/> </a>
                </li>
                <li>
                    <a href="#"  class="componentControl" id ="esamiControl"><fmt:message key='Visualizza_esami'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id ="ricetteControl"><fmt:message key='Visualizza_ricette'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id ="visiteBaseControl"><fmt:message key='Visualizza_visite_base'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id ="visiteSpecialisticheControl"><fmt:message key='Visualizza_visite_SP'/> </a>
                </li>
                <li>
                    <a href="../mappe.jsp" target="_blank" class="componentControl" id="mappeControl"><fmt:message key='Visualizza_mappe'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="profiloControl"><fmt:message key='Profilo'/> </a>
                </li>
                <li>
                    <a href="#" class="componentControl" id="cambiaPasswordControl"><fmt:message key='Cambia Password'/> </a>
                </li>
                <li>
                    <a href="../logout?forgetme=0"><fmt:message key='Log_out'/> </a>
                </li>
                <li>
                    <a href="../logout?forgetme=1"><fmt:message key='Cambia_account'/> </a>
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

            <div class="container-fluid tool component" id="mappe">
                <div id="mapContainer"></div>
            </div>

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
                                            <div class="row">
                                                <input style="/*float: left;*/  width: auto" class="btn btn-primary float-left" type="file" id="fotoToUpload" name="foto"
                                                       onchange="return fileValidation('fotoToUpload', 'btnUploadFoto', labelAlertFoto)"/>
                                                <div class="col-sm" style="width: 100%;min-width: 10px"></div>
                                                <button style="width: auto; height: 35pt; background: grey;" class="btn btn-primary float-right"  type="submit" id="btnUploadFoto" disabled><fmt:message key="carica"/> </button>
                                            </div>
                                        </form>
                                    </div>
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <hr>
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 class="profileFields" align="right">${sessionScope.utente.nome}</h5>
                                    </div>
                                    <hr>
                                    <div  style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 class="profileFields" align="right">${sessionScope.utente.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div class="profileFields" style="clear: both">
                                        <h5 class="profileFields"  style="float: left"><b><fmt:message key="sesso"/></b>:  </h5>
                                        <h5 class="profileFields" align="right">${sessionScope.utente.sesso}</h5>
                                    </div>
                                    <hr>
                                    <div class="profileFields" style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="codfis"/></b>:  </h5>
                                        <h5 class="profileFields" align="right">${sessionScope.utente.codiceFiscale}</h5>
                                    </div>
                                    <hr>
                                    <div class="profileFields" style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="datanas"/></b>:  </h5>
                                        <h5 class="profileFields" align="right"><fmt:formatDate value="${sessionScope.utente.dataNascita}"/></h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container-fluid tool component" align="center" id="cambiaMedico">
                <div class="form">
                    <div class="form-toggle"></div>
                    <div class="form-panel one">
                        <div class="form-header">
                            <h1><fmt:message key='Cambia_MB'/> </h1>
                        </div>
                        <div class="form-content">
                            <form id="formPutCambiaMedico">
                                <div class="form-group">
                                    <label for="idmedicobase"><fmt:message key='Nome_del_medico'/> </label>
                                    <select type="text" id="idmedicobase" name="idmedicobase" required="true"></select>
                                    <span class="glyphicon glyphicon-ok"></span>
                                </div>
                                <div class="form-group">
                                    <button id ="btnCambiaMedico" type="submit"><fmt:message key='Cambia'/></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div id="esami" class="tool component">
                <h2><fmt:message key='Esami_non_erogati'/></h2>
                <div class="container-fluid">
                    <table id="esamiNonErogati" class="table table-striped table-hover ">
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
                <h2><fmt:message key='Esami_erogati'/></h2>
                <div class="container-fluid">
                    <table id="esamiErogati" class="table table-striped table-hover ">
                        <thead>
                        <tr>
                            <th><fmt:message key="nomeesa"/></th>
                            <th><fmt:message key="descresa"/></th>
                            <th><fmt:message key="nomemb"/></th>
                            <th><fmt:message key="cognomemb"/></th>
                            <th><fmt:message key="prescrizione"/></th>
                            <th><fmt:message key="ero"/></th>
                            <th><fmt:message key="esito"/></th>
                            <th><fmt:message key='Ricevuta'/></th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>

            <div id="ricette" class="component tool">
                <h2><fmt:message key="ricnevas"/></h2>
                <div class="container-fluid">
                    <table id="ricetteNonEvase" class="table table-striped table-hover ">
                        <thead>
                        <tr>
                            <th><fmt:message key="nomefar"/></th>
                            <th><fmt:message key="desfar"/></th>
                            <th><fmt:message key="nomemb"/></th>
                            <th><fmt:message key="cognomemb"/></th>
                            <th><fmt:message key="prescrizione"/></th>
                            <th><fmt:message key='PDF'/></th>
                        </tr>
                        </thead>
                    </table>
                </div>
                <h2><fmt:message key="ricev"/></h2>
                <div class="container-fluid">
                    <table id="ricetteEvase" class="table table-striped table-hover ">
                        <thead>
                        <tr>
                            <th><fmt:message key="nomefar"/></th>
                            <th><fmt:message key="desfar"/></th>
                            <th><fmt:message key="nomemb"/></th>
                            <th><fmt:message key="cognomemb"/></th>
                            <th><fmt:message key="prescrizione"/></th>
                            <th><fmt:message key="evas"/></th>
                            <th><fmt:message key='Ricevuta'/></th>
                        </tr>
                        </thead>
                    </table>
                </div>
                <br/>
                <br/>
            </div>

            <div id="visiteBase" class="component tool">
                <h2><fmt:message key="visbas"/></h2>
                <div class="container-fluid">
                    <table id="visiteBaseTable" class="table table-striped table-hover ">
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
            </div>

            <div id="visiteSpecialistiche" class="component tool">
                <h2><fmt:message key="visspecnero"/></h2>
                <div class="container-fluid">
                    <table id="visiteSpecialisticheNonErogate" class="table table-striped table-hover ">
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
                <h2><fmt:message key="visspecero"/></h2>
                <div class="container-fluid">
                    <table id="visiteSpecialisticheErogate" class="table table-striped table-hover ">
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
                            <th><fmt:message key='Ricevuta'/></th>
                        </tr>
                        </thead>
                    </table>
                </div>
                <br/><br/>
            </div>

            <div id="medico" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <hr>
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 class="profileFields" id="nomeMedico" align="right"></h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 class="profileFields" id="cognomeMedico" align="right"></h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 class="profileFields" id="emailMedico" align="right"></h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="datanas"/></b>:  </h5>
                                        <h5 class="profileFields" id="dataNascitaMedico" align="right"></h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="sesso"/></b>:  </h5>
                                        <h5 class="profileFields" id="sessoMedico" align="right"></h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="codfis"/></b>:  </h5>
                                        <h5 class="profileFields" id="codiceFiscaleMedico" align="right"></h5>
                                    </div>
                                    <hr>
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
                                                    <div class="form-group container">
                                                        <button id ="btnCambiaPassword" type="submit"><fmt:message key='Procedi'/></button>
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
        </div>
    </div>
</body>
</html>