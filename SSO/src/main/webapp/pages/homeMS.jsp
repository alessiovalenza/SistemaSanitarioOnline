<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Home</title>
    <link href = "https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel = "stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet"/>
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <!-- Our Custom CSS -->
    <!-- Scrollbar Custom CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">
    <link rel="stylesheet" href="../assets/css/homeStyles.css">
    <!-- Font Awesome JS -->
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"> </script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/css/select2.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/js/select2.min.js"></script>
    <!-- Our Custom scripts-->
    <script src="../scripts/utils.js"></script>
    <script>
        let components = new Set();
        $(document).ready(function() {
            populateComponents();
            hideComponents();
            $('.spinner-border').hide();
            $('#profilo').show();
            $('#profiloControl').click(() => showComponent('profilo'));
            $('#erogaVisitaSpecControl').click(() => showComponent('erogaVisitaSpec'));



            $("#formErogaVisitaSpec").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let form_data = "idmedicospec=${sessionScope.utente.id}&anamnesi="+$("#anamnesi").val()
                let urlErogaVisitaSpec="http://localhost:8080/SSO_war_exploded/api/pazienti/"+$("#idpazienteErogaVisitaSpec").val()+"/visitespecialistiche/"+$("#idvisitaErogaVisitaSpec").val()
                $.ajax({
                    url : urlErogaVisitaSpec,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {

                    },
                    complete: function(){
                        $('.spinner-border').fadeOut(0);
                    },
                    error: function(xhr, status, error) {

                        alert(xhr.responseText);
                    }
                });
            });
            $("#idpazienteErogaVisitaSpec").select2({
                placeholder: 'Cerca Pazienti',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/pazienti",
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

            $("#idvisitaErogaVisitaSpec").select2({
                placeholder: 'Cerca visite',
                width: 300,
                allowClear: true,
                ajax: {
                    url: function () {
                        let urlSelectVisiteSpec = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idpazienteErogaVisitaSpec').children("option:selected").val()+'/visitespecialistiche/?erogateonly=false&nonerogateonly=true'
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
                        $.each(data, function (index, item) {
                            myResults.push({
                                'id': item.id,
                                'text': item.visita.nome+" prescritta da "+item.medicoBase.nome+" "+item.medicoBase.cognome+" il "+item.prescrizione
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
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
            <img class="avatar" alt="Avatar" src="propic.jpeg"
                 data-holder-rendered="true">
            <h3>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h3>
            <h6>${sessionScope.utente.cognome}</h6>
        </div>

        <ul class="list-unstyled components">
            <li>
                <a href="#" class="componentControl" id="profiloControl">Profilo</a>
            </li>
            <li>
                <a href="#" class="componentControl" id="erogaVisitaSpecControl">Eroga visita</a>
            </li>
        </ul>
    </nav>

    <!-- Page Content  -->
    <div id="content">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">

                <button type="button" id="sidebarCollapse" class="btn btn-info">
                    <i class="fas fa-align-left"></i>
                </button>
            </div>
        </nav>

        <div class="tool component" id="profilo">
            <div class="card">
                <div class="card-body">
                    <div style="clear: both; padding-top: 0.5rem">
                        <h5 align="center">${sessionScope.utente.nome}</h5>
                    </div>
                    <hr>
                    <div style="clear: both">
                        <h5 align="left">${sessionScope.utente.luogoNascita}</h5>
                        <h5 align="right">${sessionScope.utente.prov}</h5>
                    </div>
                    <hr>
                    <div style="clear: both; padding-top: 0.5rem">
                        <h5 align="center">${sessionScope.utente.email}</h5>
                    </div>
                </div>
            </div>
        </div>


        <div id="erogaVisitaSpec" class="component">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Eroga una visita specialistica</h3>
                        <hr>
                        <div class="container-fluid" align="center">
                                    <div class="form"  >
                                        <div class="form-toggle"></div>
                                        <div class="form-panel one">
                                            <div class="form-header">
                                                <h1>Eroga una visita specialistica</h1>
                                            </div>
                                            <div class="form-content">
                                                <form id="formErogaVisitaSpec" >
                                                    <div class="form-group">
                                                        <div class="container-fluid">
                                                            <label for="idpazienteErogaVisitaSpec">Paziente</label>
                                                            <select type="text" id="idpazienteErogaVisitaSpec" name="idpazienteErogaVisitaSpec" required="required"></select>
                                                            <div class="spinner-border text-primary" role="status">
                                                                <span class="sr-only">Loading...</span>
                                                            </div>
                                                            <br>
                                                        </div>
                                                        <div class="container-fluid" style="padding-top: 1rem">
                                                            <label for="idvisitaErogaVisitaSpec">Visita specialistica</label>
                                                            <select type="text" id="idvisitaErogaVisitaSpec" name="idvisitaErogaVisitaSpec" required="required"></select>
                                                            <div class="spinner-border text-primary" role="status">
                                                                <span class="sr-only">Loading...</span>
                                                            </div>
                                                        </div>

                                                        <div class="container-fluid" style="padding-top: 1rem">
                                                            <label for="anamnesi">Anamnesi</label>
                                                            <textarea type="text" id="anamnesi" name="anamnesi" required="required"></textarea>
                                                        </div>


                                                    </div>
                                                    <input required="true" type="checkbox"> Pagato<br>
                                                    <div class="form-group">
                                                        <div class="container"style="padding-top: 1rem" >
                                                                <button type="submit">Eroga</button>
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
    <div class="overlay"></div>
</div>

<!-- jQuery CDN - Slim version (=without AJAX) -->
<!-- Popper.JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
<!-- Bootstrap JS -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<!-- jQuery Custom Scroller CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript">
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
        // $('#sidebar').on('hidden.bs.collapse', function() {
        //     alert('dasd')
        // });
        // $("#sidebar").mCustomScrollbar({
        //     theme: "minimal"
        // });
        //
        // $('#sidebarCollapse').on('click', function () {
        //     $('#sidebar, #content').toggleClass('active');
        //     $('.collapse.in').toggleClass('in');
        //     $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        // });
    });
</script>
</body>

</html>