<%@ page import="java.io.File" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${not empty sessionScope.language ? sessionScope.language : pageContext.request.locale}" scope="session" />

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
        $(document).ready(function () {

            $("#sidebar").mCustomScrollbar({
                theme: "minimal"
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

            $("#formErogaVisita").submit(function(event){
                $('.spinner-border').show();
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
                        $('.spinner-border').delay(500).fadeOut(0);
                        document.getElementById("erogaVisitaBaseOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("erogaVisitaBaseOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formPrescFarmaco").submit(function(event) {
                $(".spinner-border").show();
                event.preventDefault(); //prevent default action
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
                        $(".spinner-border").delay(500).fadeOut(0);
                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formPrescEsame").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let urlPrescFarmaco = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$("#idmedicobaseEsame").val()+"/esamiprescritti"
                let formData = "idmedicobase=${sessionScope.utente.id}&idesame="+$("#idesame").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : formData,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').delay(500).fadeOut(0);
                        document.getElementById("prescriviEsameOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("prescriviEsameOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formPrescVisita").submit(function(event){
                $('.spinner-border').show();
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
                        $('.spinner-border').delay(500).fadeOut(0);
                        document.getElementById("prescriviVisitaOK").classList.toggle("show");
                        setTimeout(function() {
                            document.getElementById("prescriviVisitaOK").classList.toggle("show");
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });

            $("#formScheda").submit(function(event){
                event.preventDefault();

                $('#dataPazienteScheda').DataTable().destroy()
                let urlDataPaziente = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val();
                $('#dataPazienteScheda').DataTable( {
                    "processing": false,
                    "ordering": false,
                    "paging": false,
                    "searching": false,
                    "serverSide": false,
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

                let table = $('#visiteBasePazienteScheda').DataTable().destroy()
                let urlVisiteBase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitebase"
                $('#visiteBasePazienteScheda').DataTable( {
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

            });

            populateComponents();
            hideComponents();
            $(".spinner-border").hide();
            $("#profilo").show();

            $("#profiloControl").click(() => showComponent("profilo"));
            $("#pazientiControl").click(function() {
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

            $("#sidebarCollapse").on("click", function () {
                $("#sidebar, #content").toggleClass("active");
                $(".collapse.in").toggleClass("in");
                $("a[aria-expanded=true]").attr("aria-expanded", "false");
            });
        });
    </script>
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <img class="avatar" alt="Avatar" src="propic.jpeg" data-holder-rendered="true">
                <h3>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h3>
                <h6>${sessionScope.utente.email}</h6>
            </div>

            <ul class="list-unstyled">
                <li>
                    <a href="#" id="profiloControl">Profilo</a>
                </li>
                <li>
                    <a href="#" id="pazientiControl">Pazienti</a>
                </li>
                <li>
                    <a href="#" id="schedaPazControl">Scheda Paziente</a>
                </li>
                <li>
                    <a href="#" id="prescFarmacoControl">Prescrivi Farmaco</a>
                </li>
                <li>
                    <a href="#" id="prescVisitaControl">Prescrivi Visita</a>
                </li>
                <li>
                    <a href="#" id="prescEsameControl">Prescrivi Esame</a>
                </li>
                <li>
                    <a href="#" id="erogaVisitaControl">Eroga Visita</a>
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

                    <h3>SSO</h3>
                </div>
            </nav>

            <div id="profilo" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="text-center">

                                    <div data-interval="false" id="carouselExampleControls" class="carousel slide"
                                         data-ride="carousel">
                                        <div id="carouselInnerProfilo" class="carousel-inner">

                                        </div>
                                        <a class="carousel-control-prev" href="#carouselExampleControls" role="button"
                                           data-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#carouselExampleControls" role="button"
                                           data-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <h5 style="float: left">Nome:  </h5>
                                        <h5 align="right">${sessionScope.utente.nome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left">Cognome:  </h5>
                                        <h5 align="right">${sessionScope.utente.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left">Sesso:  </h5>
                                        <h5 align="right">${sessionScope.utente.sesso}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left">Codice fiscale:  </h5>
                                        <h5 align="right">${sessionScope.utente.codiceFiscale}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 style="float: left">Data di nascita:  </h5>
                                        <h5 align="right">${sessionScope.utente.dataNascita}</h5>
                                    </div>
                                    <hr>
                                    <button href="#" class="btn btn-primary">Go somewhere</button>
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
                                    <th>Nome</th>
                                    <th>Cognome</th>
                                    <th>Data di nascita</th>
                                    <th>Luogo di nascita</th>
                                    <th>Codice fiscale</th>
                                    <th>Sesso</th>
                                    <th>Email</th>
                                    <th>Ultima visita di base</th>
                                    <th>Ultima ricetta prescritta</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome</th>
                                    <th>Cognome</th>
                                    <th>Data di nascita</th>
                                    <th>Luogo di nascita</th>
                                    <th>Codice fiscale</th>
                                    <th>Sesso</th>
                                    <th>Email</th>
                                    <th>Ultima visita di base</th>
                                    <th>Ultima ricetta prescritta</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div id="schedaPaz" class="tool component" style="align-content: center;">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Seleziona un paziente per ricevere la scheda completa</h3>
                            <hr>
                            <form id="formScheda">
                                <label for="idpazienteScheda">Nome del paziente</label>
                                <select type="text" id="idpazienteScheda" name="idpazienteScheda" required="required"></select>
                                <button class="bottone" style="padding-left: 1em" type="submit">Cerca</button>

                            </form>
                            <hr>specialistica
                            <br>
                        </div>

                        <div class="col-md-12">
                            <h5>Dati Paziente</h5>
                            <div class="table table-responsive">
                                <table id="dataPazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome</th>
                                        <th>Cognome</th>
                                        <th>Data di Nascita</th>
                                        <th>Luogo di Nascita</th>
                                        <th>Codice Fiscale</th>
                                        <th>Sesso</th>
                                        <th>Email</th>
                                    </tr>
                                    </thead>
                                </table>

                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Visite di base</h5>
                            <div class="table table-responsive">
                                <table id="visiteBasePazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Data erogazione</th>
                                        <th>Anamnesi</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Data erogazione</th>
                                        <th>Anamnesi</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Ricette evase</h5>
                            <div class="table table-responsive">
                                <table id="ricetteEvasePazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome farmaco</th>
                                        <th>Descrizione farmaco</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Evasione</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome farmaco</th>
                                        <th>Descrizione farmaco</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Evasione</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Ricette non evase</h5>
                            <div class="table table-responsive">
                                <table id="ricetteNonEvasePazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome farmaco</th>
                                        <th>Descrizione farmaco</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome farmaco</th>
                                        <th>Descrizione farmaco</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Esami erogati</h5>
                            <div class="table table-responsive">
                                <table id="esamiErogatiPazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome esame</th>
                                        <th>Descrizione esame</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Erogazione</th>
                                        <th>Esito</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome esame</th>
                                        <th>Descrizione esame</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Erogazione</th>
                                        <th>Esito</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Esami non erogati</h5>
                            <div class="table table-responsive">
                                <table id="esamiNonErogatiPazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome esame</th>
                                        <th>Descrizione esame</th>
                                        <th>Nome medico</th>
                                        <th>Cognome medico</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome esame</th>
                                        <th>Descrizione esame</th>
                                        <th>Nome medico</th>
                                        <th>Cognome medico</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Visite specialistiche erogate</h5>
                            <div class="table table-responsive">
                                <table id="visiteSpecialisticheErogatePazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome visita</th>
                                        <th>Nome medico specialista</th>
                                        <th>Cognome medico specialista</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Erogazione</th>
                                        <th>Anamnesi</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome visita</th>
                                        <th>Nome medico specialista</th>
                                        <th>Cognome medico specialista</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                        <th>Erogazione</th>
                                        <th>Anamnesi</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <br/>
                        <div class="col-md-12">
                            <h5>Visite specialistiche non erogate</h5>
                            <div class="table table-responsive">
                                <table id="visiteSpecialisticheNonErogatePazienteScheda" class="table table-striped table-hover ">
                                    <thead>
                                    <tr>
                                        <th>Nome visita</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </thead>
                                    <tfoot>
                                    <tr>
                                        <th>Nome visita</th>
                                        <th>Nome medico di base</th>
                                        <th>Cognome medico di base</th>
                                        <th>Prescrizione</th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="prescFarmaco" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3>Prescrivi una farmaco ad un paziente</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Prescrivi un farmaco</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescFarmaco" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseFarmaco">Nome del paziente</label>
                                                        <select type="text" id="idmedicobaseFarmaco" name="idmedicobaseFarmaco" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idfarmaco">Nome del farmaco</label>
                                                        <select type="text" id="idfarmaco" name="idfarmaco" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group popup">
                                                    <button id ="btnPrescriviFarmaco" type="submit">Prescrivi</button>
                                                    <span class="popuptext" id="prescriviFarmacoOK">Farmaco prescritto</span>
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
                            <h3>Prescrivi una visita specialista ad un paziente</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Prescrivi una visita</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescVisita" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseVisitaSpec">Nome del paziente</label>
                                                        <select type="text" id="idmedicobaseVisitaSpec" name="idmedicobaseVisitaSpec" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idvisita">Nome della visita</label>
                                                        <select type="text" id="idvisita" name="idvisita" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnPrescriviVisita" type="submit">Prescrivi</button>
                                                    <span class="popuptext" id="prescriviVisitaOK">Visita specialistica prescritta</span>
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
                            <h3>Prescrivi un esame ad un paziente</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Prescrivi un esame</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formPrescEsame" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseEsame">Nome del paziente</label>
                                                        <select type="text" id="idmedicobaseEsame" name="idmedicobaseEsame" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idesame">Nome dell'esame</label>
                                                        <select type="text" id="idesame" name="idesame" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnPrescriviEsame" type="submit">Prescrivi</button>
                                                    <span class="popuptext" id="prescriviEsameOK">Esame prescritto</span>
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
                            <h3>Eroga una visita ad un paziente</h3>
                            <hr>
                            <div class="container-fluid" align="center">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1>Eroga una visita</h1>
                                        </div>
                                        <div class="form-content">
                                            <form id="formErogaVisita" >
                                                <div class="form-group">
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idmedicobaseVisita">Nome del paziente</label>
                                                        <select type="text" id="idmedicobaseVisita" name="idmedicobaseVisita" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="anamnesi">Anamnesi</label>
                                                        <textarea type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <button id ="btnErogaVisita" type="submit">Eroga visita</button>
                                                    <span class="popuptext" id="erogaVisitaBaseOK">Visita erogata</span>
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