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
        default:
            session.setAttribute("selectedSection", "profilo");
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

    <!-- Utils JS -->
    <script src="../scripts/utils.js"></script>

    <script type="text/javascript">
        let components = new Set();
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

            let basePath = "..<%=File.separator + Utilities.USER_IMAGES_FOLDER + File.separator%>${sessionScope.utente.id}<%=File.separator%>";
            let extension = ".<%=Utilities.USER_IMAGE_EXT%>";
            initCarousel(${sessionScope.utente.id}, "carouselInnerProfilo", basePath, extension);

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

            initUploadFoto("#formUploadFoto", ${sessionScope.utente.id}, "");

            initAvatar(${sessionScope.utente.id}, "avatarImg", basePath, extension);

            $("#formErogaVisita").submit(function(event){
                loadingButton("#btnErogaVisita")
                event.preventDefault(); //prevent default action
                let urlErogaVisita = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$("#idmedicobaseVisita").val()+"/visitebase"
                let formData = "idmedicobase=${sessionScope.utente.id}&anamnesi="+$("#anamnesi").val() //Encode form elements for submission
                $.ajax({
                    url : urlErogaVisita,
                    type: "POST",
                    data : formData,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.select2ErogaVisita').val(null).trigger("change")
                        successButton("#btnErogaVisita")
                        document.getElementById("erogaVisitaBaseOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("erogaVisitaBaseOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnErogaVisita")
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formPrescFarmaco").submit(function(event) {
                event.preventDefault(); //prevent default action

                loadingButton("#btnPrescriviFarmaco")

                let urlPrescFarmaco = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idmedicobaseFarmaco').val()+"/ricette";
                let formData = "idmedicobase=${sessionScope.utente.id}&idfarmaco="+$("#idfarmaco").val(); //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : formData,
                    success: function (data) {
                        document.getElementById("prescriviFarmacoOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("prescriviFarmacoOK").classList.toggle("show");
                        }, 3000);
                    },
                    complete: function(){
                        successButton("#btnPrescriviFarmaco")
                        $('.select2PrescFarmaco').val(null).trigger("change")

                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                        errorButton("#btnPrescriviFarmaco")
                    }
                });
            });

            $("#formPrescEsame").submit(function(event){
                event.preventDefault(); //prevent default action
                loadingButton("btnPrescriviEsame")
                let urlPrescFarmaco = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$("#idmedicobaseEsame").val()+"/esamiprescritti"
                let formData = "idmedicobase=${sessionScope.utente.id}&idesame="+$("#idesame").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : formData,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.select2PrescEsame').val(null).trigger("change")
                        successButton("btnPrescriviEsame")
                        document.getElementById("prescriviEsameOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("prescriviEsameOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnPrescriviEsame")
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formPrescVisita").submit(function(event){
                loadingButton("#btnPrescriviVisita")
                event.preventDefault(); //prevent default action
                let urlPrescVisita = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idmedicobaseVisitaSpec').val()+'/visitespecialistiche'
                let formData = "idmedicobase=${sessionScope.utente.id}&idvisita="+$("#idvisita").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescVisita,
                    type: "POST",
                    data : formData,
                    success: function (data) {

                    },
                    complete: function(){
                        successButton("#btnPrescriviVisita")
                        $('.select2PrescVisita').val(null).trigger("change")
                        document.getElementById("prescriviVisitaOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("prescriviVisitaOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnPrescriviVisita")
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formScheda").submit(function(event){
                event.preventDefault();

                let basePath = "..<%=File.separator + Utilities.USER_IMAGES_FOLDER + File.separator%>" + $('#idpazienteScheda').val() + "<%=File.separator%>";
                let extension = ".<%=Utilities.USER_IMAGE_EXT%>";
                initCarousel($('#idpazienteScheda').val(), "carouselInnerPaziente", basePath, extension);

                $('#dataPazienteScheda').DataTable().destroy()
                let urlDataPaziente = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val();
                $('#dataPazienteScheda').DataTable( {
                    "processing": false,
                    "ordering": false,
                    "paging": false,
                    "searching": false,
                    "serverSide": false,
                    "info": false,
                    "language": {
                        "url": urlLangDataTable
                    },
                    "ajax": {
                        "url": urlDataPaziente,
                        "type":"GET",
                        "dataSrc": function (json) {
                            let returnData = new Array();
                            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            let dataNascita = new Date(json.dataNascita);
                            dataNascita=dataNascita.toLocaleDateString("${fn:replace(language, '_', '-')}");
                            returnData.push({
                                'nome': json.nome,
                                'cognome': json.cognome,
                                'dataNascita': dataNascita,
                                'luogoNascita': json.luogoNascita,
                                'codiceFiscale': json.codiceFiscale,
                                'sesso': json.sesso,
                                'email': json.email
                            });
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
                        { "data": "codiceFiscale"},
                        { "data": "sesso" },
                        { "data": "email" }
                    ]
                } );

                $('#visiteBasePazienteScheda').DataTable().destroy()
                let urlVisiteBase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitebase"
                let table = $('#visiteBasePazienteScheda').DataTable( {
                    "processing": true,
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
                            alert(xhr.responseText);
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

                $("#visiteBasePazienteScheda tbody").on("click", ".anamnesiColumn", function () {
                    let data = table.row( this ).data();
                    alert(data.anamnesi);
                } );

                $('#visiteSpecialisticheErogatePazienteScheda').DataTable().destroy()
                let urlVisiteSpacialisticheErogate = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=true&nonerogateonly=false"
                $('#visiteSpecialisticheErogatePazienteScheda').DataTable( {
                    "processing": true,
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
                            alert(xhr.responseText);
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

                $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable().destroy()
                let urlVisiteSpacialisticheNonErogate = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=false&nonerogateonly=true"
                $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable( {
                    "processing": true,
                    "ordering": true,
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
                            alert(xhr.responseText);
                        }
                    },
                    "columns": [
                        { "data": "visitaNome" },
                        { "data": "medicoBaseNome" },
                        { "data": "medicoBaseCognome" },
                        { "data": "prescrizione" }
                    ]
                } );

                $('#ricetteEvasePazienteScheda').DataTable().destroy()
                let urlRicetteEvase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=true&nonevaseonly=false"
                $('#ricetteEvasePazienteScheda').DataTable( {
                    "processing": true,
                    "ordering": true,
                    "paging": true,
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
                            alert(xhr.responseText);
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

                $('#ricetteNonEvasePazienteScheda').DataTable().destroy()
                let urlRicetteNonEvase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=false&nonevaseonly=true"
                $('#ricetteNonEvasePazienteScheda').DataTable( {
                    "processing": true,
                    "ordering": true,
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
                            alert(xhr.responseText);
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

                $('#esamiErogatiPazienteScheda').DataTable().destroy()
                let urlEsamiErogati = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/esamiprescritti/?erogationly=true&nonerogationly=false"
                $('#esamiErogatiPazienteScheda').DataTable( {
                    "processing": true,
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
                        },
                        "error": function(xhr, status, error) {
                            alert(xhr.responseText);
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

                $('#esamiNonErogatiPazienteScheda').DataTable().destroy()
                let urlEsamiNonErogati = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/esamiprescritti/?erogationly=false&nonerogationly=true"
                $('#esamiNonErogatiPazienteScheda').DataTable( {
                    "processing": true,
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
                        "error": function(xhr, status, error) {
                            alert(xhr.responseText);
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

                document.getElementById("schedaPaziente").style.display="block";
            });

            $("#profiloControl").click(() => showComponent("profilo"));
            $("#pazientiControl").click(() => {
                showComponent("pazienti");
                $("#tablePazienti").DataTable().destroy()
                let urlPazienti = "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=true";
                $("#tablePazienti").DataTable( {
                    "processing": true,
                    "ordering": true,
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
                <h6>${sessionScope.utente.email}</h6>
            </div>

            <ul class="list-unstyled">
                <li>
                    <a href="#" class="componentControl" id="profiloControl"><fmt:message key="profilo"/></a>
                </li>
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
                    <a href="../logout">Log out</a>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">

            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-info">
                        <i class="fas fa-align-justify"></i>
                    </button>

                    <div class="headerWidget">
                        <c:choose>
                            <c:when test="${!fn:startsWith(language, 'en')}">
                                <a href="${url}en_EN">english</a>
                            </c:when>
                            <c:otherwise>
                                english
                            </c:otherwise>
                        </c:choose> |
                        <c:choose>
                            <c:when test="${!fn:startsWith(language, 'it')}">
                                <a href="${url}it_IT">italiano</a>
                            </c:when>
                            <c:otherwise>
                                italiano
                            </c:otherwise>
                        </c:choose> |
                        <c:choose>
                            <c:when test="${!fn:startsWith(language, 'fr')}">
                                <a href="${url}fr_FR">français</a>
                            </c:when>
                            <c:otherwise>
                                français
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>
            </nav>

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
                                                <input style="float: left; height: 35pt" class="btn btn-primary" type="file" id="fotoToUpload" name="foto"
                                                       onchange="return fileValidation('fotoToUpload','btnUploadFoto',labelAlertFoto)"/>
                                                <button style="float:right; height: 35pt; background: grey;" class="btn btn-primary" type="submit" id="btnUploadFoto" disabled><fmt:message key="carica"/> </button>
                                            </div>
                                        </form>
                                    </div>
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <hr>
                                        <h5 style="float: left"><fmt:message key="nome"/>:  </h5>
                                        <h5 align="right">${sessionScope.utente.nome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><fmt:message key="cognome"/>:  </h5>
                                        <h5 align="right">${sessionScope.utente.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><fmt:message key="sesso"/>:  </h5>
                                        <h5 align="right">${sessionScope.utente.sesso}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><fmt:message key="codfis"/>:  </h5>
                                        <h5 align="right">${sessionScope.utente.codiceFiscale}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left"><fmt:message key="datanas"/>:  </h5>
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
                <div class="row">
                    <div class="col-md-12">
                        <div class="table table-responsive">
                            <table id="tablePazienti" class="table table-striped table-hover ">
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
                                <tfoot>
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
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div id="schedaPaz" class="tool component" style="align-content: center;">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key="selpaz"/></h3>
                            <hr>
                            <form id="formScheda">
                                <label for="idpazienteScheda"><fmt:message key="nomepaz"/></label>
                                <select type="text" id="idpazienteScheda" name="idpazienteScheda" required="required"></select>
                                <button class="bottone" style="padding-left: 1em" type="submit"><fmt:message key="cerca"/></button>
                            </form>
                            <br>
                        </div>
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

                            <div class="col-md-12">
                                <h5><fmt:message key="datipaz"/></h5>
                                <div class="table table-responsive">
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
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="visbas"/></h5>
                                <div class="table table-responsive">
                                    <table id="visiteBasePazienteScheda" class="table table-striped table-hover ">
                                        <thead>
                                        <tr>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="dataero"/></th>
                                            <th><fmt:message key="anamn"/></th>
                                        </tr>
                                        </thead>
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="dataero"/></th>
                                            <th><fmt:message key="anamn"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="ricev"/></h5>
                                <div class="table table-responsive">
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
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomefar"/></th>
                                            <th><fmt:message key="desfar"/></th>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                            <th><fmt:message key="evas"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="ricnevas"/></h5>
                                <div class="table table-responsive">
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
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomefar"/></th>
                                            <th><fmt:message key="desfar"/></th>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="esero"/></h5>
                                <div class="table table-responsive">
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
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomeesa"/></th>
                                            <th><fmt:message key="descresa"/></th>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                            <th><fmt:message key="ero"/></th>
                                            <th><fmt:message key="esito"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="esnero"/></h5>
                                <div class="table table-responsive">
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
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomeesa"/></th>
                                            <th><fmt:message key="descresa"/></th>
                                            <th><fmt:message key="nomem"/></th>
                                            <th><fmt:message key="cognomem"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="visspecero"/></h5>
                                <div class="table table-responsive">
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
                                        <tfoot>
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
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <h5><fmt:message key="visspecnero"/></h5>
                                <div class="table table-responsive">
                                    <table id="visiteSpecialisticheNonErogatePazienteScheda" class="table table-striped table-hover ">
                                        <thead>
                                        <tr>
                                            <th><fmt:message key="nomevis"/></th>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                        </tr>
                                        </thead>
                                        <tfoot>
                                        <tr>
                                            <th><fmt:message key="nomevis"/></th>
                                            <th><fmt:message key="nomemb"/></th>
                                            <th><fmt:message key="cognomemb"/></th>
                                            <th><fmt:message key="prescrizione"/></th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
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
                                                    <span class="popuptext" id="prescriviFarmacoOK"><fmt:message key="farpres"/></span>
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
                                                <div class="form-group">
                                                    <button id ="btnPrescriviVisita" type="submit"><fmt:message key="pres"/></button>
                                                    <span class="popuptext" id="prescriviVisitaOK"><fmt:message key="visspecpres"/></span>
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
                                                <div class="form-group">
                                                    <button id ="btnPrescriviEsame" type="submit"><fmt:message key="prescrizione"/></button>
                                                    <span class="popuptext" id="prescriviEsameOK"><fmt:message key="esprescr"/></span>
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
                                                        <select class="select2ErogaVisita" type="text" id="idmedicobaseVisita" name="idmedicobaseVisita" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="anamnesi"><fmt:message key="anamn"/></label>
                                                        <textarea type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnErogaVisita" type="submit"><fmt:message key="erovis"/></button>
                                                    <span class="popuptext" id="erogaVisitaBaseOK"><fmt:message key="visero"/></span>
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