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
        case "visita":
            break;
        case "mappe":
            break;
        default:
            session.setAttribute("selectedSection", "profilo");
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
    <title>Dashboard Paziente</title>

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


    <script>
        let components = new Set();
        const labelLoadingButtons = "loading";
        const labelSuccessButtons = "success";
        const labelErrorButtons = "error";
        let baseUrl = "<%=request.getContextPath()%>";

        $(document).ready(function(){

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

            let basePathCarousel = "${baseUrl}/<%=Utilities.USER_IMAGES_FOLDER%>/${sessionScope.utente.id}/";
            let extension = ".<%=Utilities.USER_IMAGE_EXT%>";

            initAvatar(${sessionScope.utente.id}, "avatarImg", basePathCarousel, extension);

            populateComponents();
            hideComponents();
            $('#profilo').show();
            $('#profiloControl').click(() => showComponent('profilo'));
            $('#medicoControl').click(() => showComponent('medico'));
            $('#cambiaMedicoControl').click(() => showComponent('cambiaMedico'));
            $('#esamiControl').click(() => showComponent('esami'));
            $('#ricetteControl').click(() => showComponent('ricette'));
            $('#visiteBaseControl').click(() => showComponent('visiteBase'));
            $('#visiteSpecialisticheControl').click(() => showComponent('visiteSpecialistiche'));
            $('#mappeControl').click(() => showComponent('mappe'));

            document.getElementById("${sectionToShow}Control").click();


            $("#formPutCambiaMedico").submit(function(event){
                loadingButton("#btnCambiaMedico",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let form_data = $(this).serialize(); //Encode form elements for submission
                let url = baseUrl + '/api/pazienti/' + ${sessionScope.utente.id} + '/medicobase'

                $.ajax({
                    url : url,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {
                        // alert("va")

                        $('#idmedicobase').val(null).trigger("change")
                        successButton("#btnCambiaMedico",labelSuccessButtons)
                    }.data,
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnCambiaMedico",labelErrorButtons)
                        alert(xhr.responseText);
                    }
                });
            });

            $("#medicoControl").click(function(){
                let url = baseUrl + '/api/pazienti/${sessionScope.utente.id}/medicobase'
                $.ajax({
                    type: "GET",
                    url: url,
                    // dataType: 'jsonp',
                    // contentType: "text/html",
                    // crossDomain:'true',
                    success: function (data) {
                        let fields = data;
                        let nome = fields["nome"];
                        let cognome = fields["cognome"];
                        let sesso = fields["sesso"];
                        $("#nomeMedico").html(nome);
                        $("#cognomeMedico").html(cognome);
                        $("#sessoMedico").html(sesso);

                    },
                    error: function(xhr, status, error) {

                        console.log("errore");
                    }

                });
            });
            $("#esamiControl").click(function(){
                $('#esamiErogati').DataTable().destroy()
                $('#esamiNonErogati').DataTable().destroy()
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
                                    'cognomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.cognome,
                                    'nomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.nome,
                                    'prescrizione': prescrizione
                                });
                            }
                            return returnData;
                        },
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
                                    'cognomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.cognome,
                                    'nomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.nome,
                                    'prescrizione': prescrizione,
                                    'erogazione': erogazione,
                                    'esito': json[i].esito
                                });
                            }
                            return returnData;
                        }
                    },
                    "columns": [
                        { "data": "nomeEsame" },
                        { "data": "descrizioneEsame" },
                        { "data": "nomeMedicoBase" },
                        { "data": "cognomeMedicoBase" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "esito" }
                    ]
                } );
            });
            let urlCambioMedico = baseUrl + '/api/general/medicibase/?idprovincia='+'${sessionScope.utente.prov}'

                $("#idmedicobase").select2({
                    placeholder: 'Cerca Medici',
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
                                returnData.push({
                                    'farmacoNome': json[i].farmaco.nome,
                                    'farmacoDescrizione': json[i].farmaco.descrizione,
                                    'medicoBaseCognome': json[i].medicoBase.cognome,
                                    'medicoBaseNome': json[i].medicoBase.nome,
                                    'emissione': emissione
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
                        { "data": "emissione" }
                    ]
                } );


                let urlRicetteEvase = baseUrl + "/api/pazienti/"+${sessionScope.utente.id}+"/ricette/?evaseonly=true&nonevaseonly=false"
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
                                    'evasione': evasione
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
                        { "data": "evasione" }
                    ]
                } );


            });

            $("#visiteBaseControl").click(function () {
                $('#visiteBaseTable').DataTable().destroy()
                let urlVisiteBase = baseUrl + "/api/pazienti/"+${sessionScope.utente.id}+"/visitebase"
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
                let urlVisiteSpacialisticheErogate = baseUrl + "/api/pazienti/"+${sessionScope.utente.id}+"/visitespecialistiche/?erogateonly=true&nonerogateonly=false"
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
                    "columns": [
                        { "data": "visitaNome" },
                        { "data": "medicoSpecialistaNome" },
                        { "data": "medicoSpecialistaCognome" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "anamnesi" }
                    ]
                } );

                $('#visiteSpecialisticheNonErogate').DataTable().destroy()
                let urlVisiteSpacialisticheNonErogate = baseUrl + "/api/pazienti/"+${sessionScope.utente.id}+"/visitespecialistiche/?erogateonly=false&nonerogateonly=true"
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
                <a href="#" class="componentControl" id="profiloControl">Profilo</a>
            </li>
            <li>
                <a href="#" class="componentControl" id="medicoControl">Visualizza medico di base</a>
            </li>
            <li>
                <a href="#" class="componentControl" id="cambiaMedicoControl">Cambia medico di base</a>
            </li>
            <li>
                <a href="#"  class="componentControl" id ="esamiControl">Visualizza esami</a>
            </li>
            <li>
                <a href="#" class="componentControl" id ="ricetteControl">Visualizza ricette</a>
            </li>
            <li>
                <a href="#" class="componentControl" id ="visiteBaseControl">Visualizza visite base</a>
            </li>
            <li>
                <a href="#" class="componentControl" id ="visiteSpecialisticheControl">Visualizza visite specialistiche</a>
            </li>
            <li>
                <a href="../mappe.jsp" target="_blank" class="componentControl" id="mappeControl">Visualizza mappe</a>
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
                        <span>Toggle Sidebar</span>
                    </button>
                </div>
            </nav>
            <div class="container-fluid tool component" id="mappe">
                <div id="mapContainer"></div>
            </div>

            <div class="container-fluid tool component" align="center" id="cambiaMedico">
                <div class="form">
                    <div class="form-toggle"></div>
                    <div class="form-panel one">
                        <div class="form-header">
                            <h1>Cambia medico di base</h1>
                        </div>
                        <div class="form-content">
                            <form id="formPutCambiaMedico">
                                <div class="form-group">
                                    <label for="idmedicobase">Nome del medico</label>
                                    <select type="text" id="idmedicobase" name="idmedicobase" required="true"></select>
                                    <span class="glyphicon glyphicon-ok"></span>
                                </div>
                            <div class="form-group">
                                <button id ="btnCambiaMedico" type="submit">Cambia</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

            <div id="esami" class="tool component">
                <h2>esami non erogati</h2>
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
                <h2>esami erogati</h2>
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
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>

            <div id="ricette" class="component tool">
                <h5><fmt:message key="ricev"/></h5>
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
                        </tr>
                        </thead>
                    </table>
                </div>
                <br/>
                <h5><fmt:message key="ricnevas"/></h5>
                <div class="container-fluid">
                    <table id="ricetteNonEvase" class="table table-striped table-hover ">
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
            </div>


            <div id="visiteBase" class="component tool">
                <h5><fmt:message key="visbas"/></h5>
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
                <h5><fmt:message key="visspecero"/></h5>
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
                        </tr>
                        </thead>
                    </table>
                </div>
                <br/>
                <h5><fmt:message key="visspecnero"/></h5>
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
            </div>

        <div class="tool component" id="medico">
            <div class="card" >

                <img src="3.jpeg" class="rounded mx-auto d-block">
                <div class="card-body">
                    <div style="clear: both; padding-top: 0.5rem">
                        <h5 style="float: left">Nome:  </h5>
                        <h5 align="right" id="nomeMedico"></h5>
                    </div>
                    <hr>
                    <div style="clear: both">
                        <h5 style="float: left">Cognome:  </h5>
                        <h5 align="right" id="cognomeMedico"></h5>
                    </div>
                    <hr>

                    <div style="clear: both">
                        <h5 style="float: left">Sesso:  </h5>
                        <h5 align="right" id="sessoMedico"></h5>
                    </div>
                    <hr>
                </div>
            </div>
        </div>


    </div>

</div>
</body>

</html>