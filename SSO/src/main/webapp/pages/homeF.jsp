<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Locale" %>
<%@ page import="it.unitn.disi.wp.progetto.commons.Utilities" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.EsamePrescrittoDAO" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO" %>

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
        case "evadiRicetta":
            break;
        case "cambiaPassword":
            break;
        default:
            session.setAttribute("selectedSection", "evadiRicetta");
            break;
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/homeF.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key="Dashboard_Farmacia"/></title>

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
        let components = new Set();
        let baseUrl = "<%=request.getContextPath()%>";
        const labelLoadingButtons = "<fmt:message key='Loading'/>";
        const labelSuccessButtons = "<fmt:message key='Succed'/>";
        const labelErrorButtons = "<fmt:message key='Error'/>";

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

            let labelCercaPaz = "<fmt:message key='Cerca_pazienti'/>";
            initSelect2Pazienti("#idpaziente", "messaggioCercaPaz", null, langSelect2, labelCercaPaz, labelTooMany);
            let labelCercaRicette = "<fmt:message key='Cerca_ricetta'/>";
            $("#idricetta").select2({
                placeholder: labelCercaRicette,
                language: langSelect2,
                width: "100%",
                allowClear: true,
                ajax: {
                    url: function () {
                        let urlSelectRicette = baseUrl + '/api/pazienti/'+$('#idpaziente').children("option:selected").val()+'/ricette/?evaseonly=false&nonevaseonly=true'
                        return urlSelectRicette
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
                            let emissione = new Date(item.emissione);
                            emissione=emissione.toLocaleDateString("${fn:replace(language, '_', '-')}");
                            myResults.push({
                                'id': item.id,
                                'text': item.farmaco.nome+" "+item.farmaco.descrizione +", ><fmt:message key='prescritta da'/> "+item.medicoBase.nome+" "+item.medicoBase.cognome+" ><fmt:message key='il'/> "+emissione
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

            let labelEvadiRicetta = document.getElementById("btnEvadiRicetta").innerHTML;
            $("#formEvadiRicetta").submit(function(event){
                loadingButton("#btnEvadiRicetta",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let urlEvadiRicetta = baseUrl + '/api/pazienti/'+$('#idpaziente').val()+'/ricette/'+$('#idricetta').val()
                let form_data = "idfarmacia=${sessionScope.utente.id}"
                $.ajax({
                    url : urlEvadiRicetta,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {
                        $("#idPagato").prop("checked",false);
                        $('.select2EvadiRicetta').val(null).trigger("change")
                        successButton("#btnEvadiRicetta",labelSuccessButtons)
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnEvadiRicetta",labelErrorButtons)
                        //alert(xhr.responseText);
                        console.log(xhr.responseText);
                    }
                });
            });
            $('.select2EvadiRicetta').on("change", function () {
                resetButton("#btnEvadiRicetta", labelEvadiRicetta);
                $("#idPagato").prop("checked",false);
            });

            populateComponents();
            hideComponents();

            $('#evadiRicettaControl').click(() => showComponent('evadiRicetta'));
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
                <img class="avatar" alt="Avatar" src="${baseUrl}/assets/img/logo_farmacia.jpeg" data-holder-rendered="true">
                <br><br>
                <h3>Farmacia ${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h3>
                <br>
                <div class="sidebar-lang">
                    <c:choose>
                        <c:when test="${!fn:startsWith(language, 'it')}">
                            <a href="${url}it_IT">Italiano</a>
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
                    <a href="#" class="componentControl" id="evadiRicettaControl"><fmt:message key='Evadi_Ricette'/></a>
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


            <div id="evadiRicetta" class="tool component">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3><fmt:message key='Evadi_ricetta_paziente'/></h3>
                            <hr>
                            <div class="container-fluid" align="center" id="cambiaMedico">
                                <div class="form"  >
                                    <div class="form-toggle"></div>
                                    <div class="form-panel one">
                                        <div class="form-header">
                                            <h1><fmt:message key='Evadi_Ricetta'/></h1>
                                        </div>
                                        <div class="form-content">
                                            <div class="alert alert-warning" role="alert" id="messaggioCercaPaz"></div>
                                            <form id="formEvadiRicetta" >
                                                <div class="form-group">
                                                    <div class="container-fluid">
                                                        <label for="idpaziente"><fmt:message key='Nome_del_Paziente'/></label>
                                                        <select class="select2EvadiRicetta" type="text" id="idpaziente" name="idpaziente" required="required"></select>
                                                    </div>
                                                    <div class="container-fluid" style="padding-top: 1rem">
                                                        <label for="idricetta"><fmt:message key='Nome_del_farmaco'/></label>
                                                        <select class="select2EvadiRicetta" type="text" id="idricetta" name="idricetta" required="required"></select>
                                                    </div>
                                                </div>
                                                <input required="true" id="idPagato" type="checkbox"> <fmt:message key='Ticket_di'/> <fmt:formatNumber value="<%=RicettaDAO.PREZZO_TICKET%>" type="currency" currencyCode="EUR"/> <fmt:message key='pagato'/><br>
                                                <div class="form-group" >
                                                    <div class="container"style="padding-top: 1rem" >
                                                        <button id="btnEvadiRicetta" type="submit"><fmt:message key='Evadi'/></button>
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
                                                    <div class="container" >
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