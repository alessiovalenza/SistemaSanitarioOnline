<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Locale" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO" %>
<%@ page import="it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.entities.Utente" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.entities.Ricetta" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException" %>
<%@ page import="it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException" %>

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

    String pazienteStr = (String)request.getParameter("idpaziente");
    String ricettaStr = (String)request.getParameter("idricetta");
    if(pazienteStr == null || ricettaStr == null) {
        throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You must specify both paziente and ricetta");
    }
    else {
        try {
            Long idPaziente = Long.parseLong(pazienteStr);
            Long idRicetta = Long.parseLong(ricettaStr);

            request.setAttribute("idpaziente", idPaziente);
            request.setAttribute("idricetta", idRicetta);

            DAOFactory daoFactory = (DAOFactory) session.getServletContext().getAttribute("daoFactory");

            if (daoFactory == null) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Impossible to get dao factory for storage system");
            }

            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);

            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);
            Ricetta ricetta = ricettaDAO.getByPrimaryKey(idRicetta);

            if(paziente == null || ricetta == null) {
                throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Paziente or ricetta not found with that id");
            }

            Utente medico = utenteDAO.getByPrimaryKey(paziente.getIdMedicoBase());

            request.setAttribute("paziente", paziente);
            request.setAttribute("medico", medico);
            request.setAttribute("ricetta", ricetta);
        }
        catch (NumberFormatException e) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "Both paziente and ricetta must be integer numbers");
        }
        catch (DAOFactoryException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        }
        catch (DAOException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }
    }
%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/evadiQR.jsp?idricetta=${requestScope.idricetta}&idpaziente=${requestScope.idpaziente}&language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<!DOCTYPE html>
<html>

<head>
    <title><fmt:message key="evadi_qr"/></title>

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

            let labelEvadiRicetta = document.getElementById("btnEvadiRicetta").innerHTML;
            $("#formEvadiRicetta").submit(function(event){
                loadingButton("#btnEvadiRicetta",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let urlEvadiRicetta = baseUrl + '/api/pazienti/${requestScope.paziente.id}/ricette/${requestScope.ricetta.id}';
                let form_data = "idfarmacia=${sessionScope.utente.id}"
                $.ajax({
                    url : urlEvadiRicetta,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {
                        $("#idPagato").prop("checked",false);
                        successButton("#btnEvadiRicetta",labelSuccessButtons)
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnEvadiRicetta",labelErrorButtons)
                        //alert(xhr.responseText);
                    }
                });
            });
            $('.select2EvadiRicetta').on("change", function () {
                resetButton("#btnEvadiRicetta", labelEvadiRicetta);
                $("#idPagato").prop("checked",false);
            });
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
                <a href="${baseUrl}/pages/homeF.jsp">Home</a>
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
                            <h4><fmt:message key="Paziente"/></h4>
                            <div class="container-fluid">
                                <div class="card-body">
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 class="profileFields" id="nomePaziente" align="right">${requestScope.paziente.nome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 class="profileFields" id="cognomePaziente" align="right">${requestScope.paziente.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="codfis"/></b>:  </h5>
                                        <h5 class="profileFields" id="codiceFiscalePaziente" align="right">${requestScope.paziente.codiceFiscale}</h5>
                                    </div>
                                </div>
                            </div>
                            <h4><fmt:message key="Medico"/></h4>
                            <div class="container-fluid">
                                <div class="card-body">
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 class="profileFields" id="nomeMedico" align="right">${requestScope.medico.nome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="cognome"/></b>:  </h5>
                                        <h5 class="profileFields" id="cognomeMedico" align="right">${requestScope.medico.cognome}</h5>
                                    </div>
                                    <hr>
                                    <div style="clear: both">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="codfis"/></b>:  </h5>
                                        <h5 class="profileFields" id="codiceFiscaleMedico" align="right">${requestScope.medico.codiceFiscale}</h5>
                                    </div>
                                </div>
                            </div>
                            <h4><fmt:message key="Farmaco"/></h4>
                            <div class="container-fluid">
                                <div class="card-body">
                                    <div style="clear: both; padding-top: 0.5rem">
                                        <h5 class="profileFields" style="float: left"><b><fmt:message key="nome"/></b>:  </h5>
                                        <h5 class="profileFields" id="nomeFarmaco" align="right">${requestScope.ricetta.farmaco.nome}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="form">
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1><fmt:message key='Evadi_Ricetta'/></h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formEvadiRicetta" >
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
    </div>
</div>
</body>
</html>