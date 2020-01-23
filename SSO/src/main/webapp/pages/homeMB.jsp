<%@ page import="java.io.File" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Home</title>

    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="../assets/css/homeStyles.css">
    <!-- Scrollbar Custom CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">

    <!-- Font Awesome JS -->
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"
            integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ"
            crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"
            integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY"
            crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>

    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#idmedicobaseFarmaco").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=false",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome+" "+item.cognome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            $("#idmedicobaseVisita").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=false",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome+" "+item.cognome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            $("#idmedicobaseVisitaSpec").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=false",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome+" "+item.cognome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            $("#formPrescFarmaco").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let urlPrescFarmaco = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idmedicobaseFarmaco').val()+'/ricette'
                let form_data = "idmedicobase=${sessionScope.utente.id}&idfarmaco="+$("#idfarmaco").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').delay(500).fadeOut(0);
                    },
                    error: function(xhr, status, error) {

                        alert(xhr.responseText);
                    }
                });
            });

            $("#idmedicobaseEsame").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=false",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome+" "+item.cognome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });


            $("#idpazienteScheda").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=false",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome+" "+item.cognome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            // $("#idmedicobase").val(null).trigger("change");
            $("#idfarmaco").select2({
                placeholder: 'Cerca Farmaci',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/general/farmaci/",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });


            $("#idesame").select2({
                placeholder: 'Cerca Esami',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/general/esami/",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });
            $("#idvisita").select2({
                placeholder: 'Cerca Visite',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/general/visite/",
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
                            myResults.push({
                                'id': item.id,
                                'text': item.nome
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });

            //$("#idfarmaco").val(null).trigger("change");

            $("#formErogaVisita").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let urlErogaVisita = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idmedicobaseVisita').val()+'/visitebase'
                let form_data = "idmedicobase=${sessionScope.utente.id}&anamnesi="+$("#anamnesi").val() //Encode form elements for submission
                $.ajax({
                    url : urlErogaVisita,
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').delay(500).fadeOut(0);
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
                let form_data = "idmedicobase=${sessionScope.utente.id}&idvisita="+$("#idvisita").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescVisita,
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').delay(500).fadeOut(0);
                    },
                    error: function(xhr, status, error) {

                        alert(xhr.responseText);
                    }
                });
            });

            $("#formScheda").submit(function(event){
                event.preventDefault();
                // $('#dataPazienteScheda').DataTable().destroy()
                // let url = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()
                // $('#dataPazienteScheda').DataTable( {
                //     "processing": true,
                //     "serverSide": true,
                //     "ajax": {
                //         "url": url,
                //         "type":"GET",
                //         "dataSrc": ""
                //     },
                //     "columns": [
                //         { "data": "nome" },//qua ovviamente va cambiato i
                //         { "data": "cognome" },
                //         { "data": "dataNascita" },
                //         { "data": "luogoNascita" },
                //         { "data": "codiceFiscale" },
                //         { "data": "sesso" },
                //         { "data": "email" }
                //     ]
                // } );
                $('#visiteBasePazienteScheda').DataTable().destroy()
                let urlVisiteBase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitebase"
                $('#visiteBasePazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlVisiteBase,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "medicoBase.nome" },//qua ovviamente va cambiato i
                        { "data": "medicoBase.cognome" },
                        { "data": "erogazione" },
                        { "data": "anamnesi" }
                    ]
                } );


                $('#visiteSpecialisticheErogatePazienteScheda').DataTable().destroy()
                let urlVisiteSpacialisticheErogate = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=true&nonerogateonly=false"
                $('#visiteSpecialisticheErogatePazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlVisiteSpacialisticheErogate,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "visita.nome" },//qua ovviamente va cambiato i
                        { "data": "medicoSpecialista.nome" },
                        { "data": "medicoSpecialista.cognome" },
                        { "data": "medicoBase.nome" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "anamnesi" }
                    ]
                } );

                $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable().destroy()
                let urlVisiteSpacialisticheNonErogate = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=false&nonerogateonly=true"
                $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlVisiteSpacialisticheNonErogate,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "visita.nome" },//qua ovviamente va cambiato i
                        { "data": "medicoBase.nome" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" }
                    ]
                } );

                $('#ricetteEvasePazienteScheda').DataTable().destroy()
                let urlRicetteEvase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=true&nonevaseonly=false"
                $('#ricetteEvasePazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlRicetteEvase,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "farmaco.nome" },//qua ovviamente va cambiato i
                        { "data": "farmaco.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "medicoBase.nome" },
                        { "data": "emissione" },
                        { "data": "evasione" }
                    ]
                } );

                $('#ricetteNonEvasePazienteScheda').DataTable().destroy()
                let urlRicetteNonEvase = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=false&nonevaseonly=true"
                $('#ricetteNonEvasePazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlRicetteNonEvase,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "farmaco.nome" },//qua ovviamente va cambiato i
                        { "data": "farmaco.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "medicoBase.nome" },
                        { "data": "emissione" }
                    ]
                } );


                $('#esamiErogatiPazienteScheda').DataTable().destroy()
                let urlEsamiErogati = "http://localhost:8080/SSO_war_exploded/api/pazienti/"+$('#idpazienteScheda').val()+"/esamiprescritti/?erogationly=true&nonerogationly=false"
                $('#esamiErogatiPazienteScheda').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlEsamiErogati,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "esame.nome" },
                        { "data": "esame.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "medicoBase.nome" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "esito" }
                    ]
                } );

            });


            $("#formPrescEsame").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let urlPrescFarmaco = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idmedicobaseEsame').val()+'/esamiprescritti'
                let form_data = "idmedicobase=${sessionScope.utente.id}&idesame="+$("#idesame").val() //Encode form elements for submission
                $.ajax({
                    url : urlPrescFarmaco,
                    type: "POST",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').delay(500).fadeOut(0);
                    },
                    error: function(xhr, status, error) {

                        alert(xhr.responseText);
                    }
                });
            });

            /* $('#esamiFatti > tbody > tr').click(function () {
                alert("riga cliccata")
            }); */
            $('#pazienti').hide();
            $('#prescVisita').hide();
            $('#erogaVisita').hide();
            $('#prescFarmaco').hide();
            $('#schedaPaz').hide();
            $('#prescEsame').hide();
            $('#eroga').hide();

            $('#profiloControl').click(function () {
                $('#profilo').fadeIn(0);
                $('#prescVisita').fadeOut(0);
                $('#pazienti').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
            });
            $('#pazientiControl').click(function () {
                $("#profilo").fadeOut(0);
                $('#prescVisita').fadeOut(0);
                $("#pazienti").fadeIn(0);
                $("#erogaVisita").fadeOut(0);
                $("#prescFarmaco").fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
                $('#tablePazienti').DataTable().destroy()
                let urlPazienti = "http://localhost:8080/SSO_war_exploded/api/medicibase/${sessionScope.utente.id}/pazienti?datericettavisita=true";
                $('#tablePazienti').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlPazienti,
                        "type":"GET",
                        "dataSrc": function (json) {
                                        let return_data = new Array();
                                        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                                        for(let i=0;i< json.length; i++){
                                            if (json[i].dataUltimaVisitaBase != undefined && json[i].getDataUltimaRicetta != undefined) {
                                                let visita = new Date(json[i].dataUltimaVisitaBase)
                                                visita=visita.toLocaleDateString("it-IT",options)
                                                let ricetta = new Date(json[i].getDataUltimaRicetta)
                                                ricetta = ricetta.toLocaleDateString("it-IT",options)
                                                let nascita = new Date(json[i].paziente.dataNascita)
                                                nascita = nascita.toLocaleDateString("it-IT")
                                                return_data.push({
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
                                                ricetta=ricetta.toLocaleDateString("it-IT",options)
                                                let nascita = new Date(json[i].paziente.dataNascita)
                                                nascita = nascita.toLocaleDateString("it-IT")
                                                return_data.push({
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
                                                visita=visita.toLocaleDateString("it-IT",options)
                                                let nascita = new Date(json[i].paziente.dataNascita)
                                                nascita = nascita.toLocaleDateString("it-IT")
                                                return_data.push({
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
                                                nascita = nascita.toLocaleDateString("it-IT")
                                                return_data.push({
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
                                        return return_data;
                                    }
                     },
                    "columns": [
                        { "data": "nome" },//qua ovviamente va cambiato i
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
            $('#prescFarmacoControl').click(function () {
                $('.spinner-border').hide();
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeIn(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
                $('#prescVisita').fadeOut(0);
            });
            $('#prescVisitaControl').click(function () {
                $('.spinner-border').hide();
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
                $('#prescVisita').fadeIn(0);
            });

            $('#erogaVisitaControl').click(function () {
                $('.spinner-border').hide();
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeIn(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
                $('#prescVisita').fadeOut(0);
            });
            $('#prescEsameControl').click(function () {
                $('.spinner-border').hide();
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeIn(0);
                $('#schedaPaz').fadeOut(0);
                $('#eroga').fadeOut(0);
                $('#prescVisita').fadeOut(0);
            });
            $('#schedaPazControl').click(function () {
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeIn(0);
                $('#eroga').fadeOut(0);
                $('#prescVisita').fadeOut(0);
            });

            $('#erogaControl').click(function () {
                $('#pazienti').fadeOut(0);
                $('#profilo').fadeOut(0);
                $('#erogaVisita').fadeOut(0);
                $('#prescFarmaco').fadeOut(0);
                $('#prescEsame').fadeOut(0);
                $('#schedaPaz').fadeOut(0);
                $('#prescVisita').fadeOut(0);
                $('#eroga').fadeIn(0);
            });
            $('#sidebarCollapse').on('click', function () {
                $('#sidebar, #content').toggleClass('active');
                $('.collapse.in').toggleClass('in');
                $('a[aria-expanded=true]').attr('aria-expanded', 'false');
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

                <h3>SSC</h3>
            </div>
        </nav>
        <div class="tool" id="profilo">
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
                            <div style="padding-top: 20pt; padding-bottom: 20pt;align-self: center;">
                                <form id="imageUploader" action="upload.php" method="post"
                                      enctype="multipart/form-data">
                                    Seleziona un' immagine da inserire:<br>
                                    <input type="file" name="fileToUpload" id="fileToUpload" style="height: 25pt;">
                                    <input type="submit" style="height: 25pt;" value="Invia" name="submit">
                                </form>
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
                                <hr>paziente	{…}
1

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


        <div class="container-fluid" id="pazienti">
            <div class="row">
                <div class="col-md-12">
                    <div class="table table-responsive">
                        <table id="tablePazienti" class="table table-striped table-hover ">
                            <thead>
                            <tr>
                                <th>Nome</th>
                                <th>Cognome</th>
                                <th>Data di Nascita</th>
                                <th>Luogo di Nascita</th>
                                <th>Codice Fiscale</th>
                                <th>Sesso</th>
                                <th>Email</th>
                                <th>Ultima visita prescritta</th>
                                <th>Ultima ricetta prescritta</th>
                            </tr>
                            </thead>
                            <tfoot>
                            <tr>
                                <th>Nome</th>
                                <th>Cognome</th>
                                <th>Data di Nascita</th>
                                <th>Luogo di Nascita</th>
                                <th>Codice Fiscale</th>
                                <th>Sesso</th>
                                <th>Email</th>
                                <th>Ultima visita prescritta</th>
                                <th>Ultima ricetta prescritta</th>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="prescVisita" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Prescrivi una visita specialista ad un paziente:</h3>
                        <hr>
                        <div class="container-fluid" align="center" id="cambiaMedico">
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
<%--                                                <br>--%>
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
                                                <button id ="btnCambiaMedico" type="submit">Prescrivi</button>
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

        <div id="prescFarmaco" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Prescrivi una farmaco ad un paziente:</h3>
                        <hr>
                        <div class="container-fluid" align="center" id="cambiaMedico">
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
                                                    <%--                                                <br>--%>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idfarmaco">Nome del farmaco</label>
                                                    <select type="text" id="idfarmaco" name="idfarmaco" required="required"></select>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                </div>

                                            </div>


                                            <div class="form-group">
                                                <button id ="btnCambiaMedico" type="submit">Prescrivi</button>
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


        <div id="erogaVisita" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Eroga una visita ad un paziente:</h3>
                        <hr>
                        <div class="container-fluid" align="center" id="cambiaMedico">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1>Eroga una visita</h1>
                                    </div>
                                        <div class="form-content">
                                            <form id="formErogaVisita" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idmedicobaseVisita">Nome del paziente</label>
                                                        <select type="text" id="idmedicobaseVisita" name="idmedicobaseVisita" required="required"></select>
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Loading...</span>
                                                        </div>
                                                        <%--                                                <br>--%>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="anamnesi">Anamnesi</label>
                                                        <textarea type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                    </div>
                <%----%>
                                                </div>
                <%----%>
                <%----%>
                                                <div class="form-group">
                                                    <button id ="btnCambiaMedico" type="submit">Eroga visita</button>
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

        <div id="prescEsame" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Prescrivi un esame ad un paziente:</h3>
                        <hr>
                        <div class="container-fluid" align="center" id="cambiaMedico">
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
                                                    <%--                                                <br>--%>
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
                                                <button id ="btnCambiaMedico" type="submit">Prescrivi</button>
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

        <div id="schedaPaz" class="tool" style="align-content: center;">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Seleziona un paziente per ricevere la scheda completa</h3>
                        <hr>
                        <form id="formScheda">
                            <label for="idpazienteScheda">Nome del paziente</label>
                            <select type="text" id="idpazienteScheda" name="idpazienteScheda" required="required"></select>
                            <button class="bottone" style="padding-left: 1em" type="submit">Cerca</button>

                        </form>
                        <hr>
                        <br>
                    </div>

                    <div class="col-md-12">
                        <h5>Dati Paziente</h5>
                        <div class="table table-responsive">
                            <table id="dataPazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th >Nome</th>
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


                    <div class="col-md-12">
                        <h5>Visite di base</h5>
                        <div class="table table-responsive">
                            <table id="visiteBasePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Data Erogazione</th>
                                    <th>Anamnesi</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Data Erogazione</th>
                                    <th>Anamnesi</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <h5>Visite Specialistiche erogate</h5>
                        <div class="table table-responsive">
                            <table id="visiteSpecialisticheErogatePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Visita</th>
                                    <th>Nome Medico specialista</th>
                                    <th>Cognome Medico specialista</th>
                                    <th>Nome medico di base</th>
                                    <th>Cognome medico di base</th>
                                    <th>Prescrizione</th>
                                    <th>Erogazione</th>
                                    <th>Anamnesi</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Visita</th>
                                    <th>Nome Medico specialista</th>
                                    <th>Cognome Medico specialista</th>
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

                    <div class="col-md-12">
                        <h5>Visite Specialistiche non erogate</h5>
                        <div class="table table-responsive">
                            <table id="visiteSpecialisticheNonErogatePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Visita</th>
                                    <th>Nome medico di base</th>
                                    <th>Cognome medico di base</th>
                                    <th>Prescrizione</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Visita</th>
                                    <th>Nome medico di base</th>
                                    <th>Cognome medico di base</th>
                                    <th>Prescrizione</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>


                    <div class="col-md-12">
                        <h5>Ricette evase  ASDSADASDASDASDSADASDASDADSAD</h5>
                        <div class="table table-responsive">
                            <table id="ricetteEvasePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Evasione</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Evasione</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <h5>Ricette non evase  ASDSADASDASDASDSADASDASDADSAD</h5>
                        <div class="table table-responsive">
                            <table id="ricetteNonEvasePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <h5>Esami erogati  ASDSADASDASDASDSADASDASDADSAD</h5>
                        <div class="table table-responsive">
                            <table id="esamiErogatiPazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Esame</th>
                                    <th>Descrizione esame</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Erogazione</th>
                                    <th>Esito</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Esame</th>
                                    <th>Descrizione esame</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Erogazione</th>
                                    <th>Esito</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <h5>Ricette evase  ASDSADASDASDASDSADASDASDADSAD</h5>
                        <div class="table table-responsive">
                            <table id="ricetteEvasePazienteScheda" class="table table-striped table-hover ">
                                <thead>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Evasione</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>Nome Farmaco</th>
                                    <th>Descrizione farmaco</th>
                                    <th>Nome medico</th>
                                    <th>Cognome medico</th>
                                    <th>Prescrizione</th>
                                    <th>Evasione</th>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="eroga" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <form id="imageUploader" action="upload.php" method="post" enctype="multipart/form-data">
                            <h3>Eroga una visita per un paziente</h3>
                            <hr>
                            <label>Seleziona paziente:</label>
                            <br>
                            <select name="" id=""></select>
                            <br>
                            <br>
                            <label>Seleziona visita:</label>
                            <br>
                            <select name="" id=""></select>
                            <br>
                            <hr>
                            <input type="submit" style="height: 25pt;" value="Invia" name="submit">
                        </form>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
<script>
    function appendImages(imagesIDs) {
        for (let i=0; i < imagesIDs.length; i++){
            var img=document.createElement("img");
            var slide=document.createElement("div");
            slide.id = i;
            if (i == 0) {
                slide.className="carousel-item active"
            }else{
                slide.className="carousel-item"
            }
            img.src="..<%=File.separator + Utilities.USER_IMAGES_FOLDER + File.separator%>${sessionScope.utente.id}<%=File.separator%>" + imagesIDs[i] + ".<%=Utilities.USER_IMAGE_EXT%>";
            console.log(img.src);
            img.style="width:100%;";
            console.log(img);
            document.body.appendChild(slide);
            document.getElementById(i).appendChild(img);
            console.log(slide.id);
            document.getElementById("carouselInnerProfilo").appendChild(slide);
            console.log("fatta slide");
        }
    }
</script>

<script type="text/javascript">
    $(document).ready(function () {

        /* $('#sidebar').on('hidden.bs.collapse', function () {
            alert('dasd')
        }); */
        $("#sidebar").mCustomScrollbar({
            theme: "minimal"
        });


        /*    $('#sidebarCollapse').on('click', function () {
               $('#sidebar, #content').toggleClass('active');
               $('.collapse.in').toggleClass('in');
               $('a[aria-expanded=true]').attr('aria-expanded', 'false');
           }); */

        let urlFotoUtente = "http://localhost:8080/SSO_war_exploded/api/utenti/${sessionScope.utente.id}/foto";

        $.ajax({
            url : urlFotoUtente,
            type: "GET",
            success: function (data) {
                imagesIDs = [];
                for(let i = 0; i < data.length; i++) {
                    imagesIDs[i] = data[i].id;
                }
                appendImages(imagesIDs);
            },
            error: function(xhr, status, error) {
                alert(xhr.responseText);
            }
        });
    });
</script>
<!-- jQuery CDN - Slim version (=without AJAX) -->
<!-- Popper.JS -->fidia.donatantonio@gmail.com
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
        integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
        crossorigin="anonymous"></script>
<!-- Bootstrap JS -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<!-- jQuery Custom Scroller CDN -->
<script
        src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
</body>

</html>