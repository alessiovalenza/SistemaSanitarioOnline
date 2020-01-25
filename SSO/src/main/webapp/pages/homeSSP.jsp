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
            $('#reportControl').click(() => showComponent('report'));
            $('#richiamo1Control').click(() => showComponent('richiamo1'));
            $('#richiamo2Control').click(() => showComponent('richiamo2'));

            $("#idesameRichiamo1").select2({
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

            $("#idesameRichiamo2").select2({
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

            $("#formRichiamo1").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let form_data = "infeta="+$("#infetaRichiamo1").val()+"&idesame="+$("#idesameRichiamo1").val()+"&supeta="+$("#supetaRichiamo1").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : "http://localhost:8080/SSO_war_exploded/api/pazienti/richiamo1",
                    type: "POST",
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

            $("#formRichiamo2").submit(function(event){
                $('.spinner-border').show();
                event.preventDefault(); //prevent default action
                let form_data = "infeta="+$("#infetaRichiamo2").val()+"&idesame="+$("#idesameRichiamo2").val()+"&idprovincia=${sessionScope.utente.prov}" //Encode form elements for submission
                $.ajax({
                    url : "http://localhost:8080/SSO_war_exploded/api/pazienti/richiamo2",
                    type: "POST",
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

        });
    </script>
</head>

<body>

<div class="wrapper">
    <!-- Sidebar  -->
    <nav id="sidebar">
<%--        da inserire anche css--%>
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
                <a href="#"class="componentControl" id="reportControl">Report</a>
            </li>
            <li>
                <a href="#" class="componentControl" id="richiamo1Control">Richiamo</a>
            </li>
            <li>
                <a href="#" class="componentControl" id="richiamo2Control">Richiama chi è già stato richiamato</a>
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

        <div class="container-fluid component" align="center" id="report">
            <div class="form">
                <div class="form-toggle"></div>
                <div class="form-panel one">
                    <div class="form-header">
                        <h1>Scarica report</h1>
                    </div>
                    <div class="form-content">
                        <form id="formScaricaReport" action="../docs/reportprov" method="get">
                            <div class="form-group">
                                <label for="idprovincia">Scegliere la provincia</label>
                                <select class="form-control" name="idprovincia" id="idprovincia">
                                    <option value="MN">Mantova</option>
                                    <option value="RE">Reggio Emilia</option>
                                    <option value="TA">Taranto</option>
                                    <option value="TN">Trento</option>
                                    <option value="VR">Verona</option>
                                    <option value="VI">Vicenza</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Scarica</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
show
        <div id="richiamo1" class="component">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Effetua un richiamo</h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1>effetua un richiamo</h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formRichiamo1" >
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo1">limite inferiore di età</label>
                                                    <input type="number" min="0" id="infetaRichiamo1" name="infeta" required="required"></input>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                                                                    <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="supetaRichiamo1">limite superiore di età</label>
                                                    <input type="number" min="0" id="supetaRichiamo1" name="supeta" required="required"></input>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo1">Nome dell'esame</label>
                                                    <select type="text" id="idesameRichiamo1" name="idesame" required="required"></select>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                </div>

                                            </div>


                                            <div class="form-group">
                                                <button id ="btnCambiaMedico" type="submit">Richiama</button>
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


        <div id="richiamo2" class="component">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Effetua un richiamo per chi è già stato richiamato in passato</h3>
                        <hr>
                        <div class="container-fluid" align="center">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1>Effetua un richiamo per chi è già stato richiamato in passato</h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formRichiamo2">
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="infetaRichiamo2">limite inferiore di età</label>
                                                    <input type="number" min="0" id="infetaRichiamo2" name="infeta" required="required"></input>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                   <br>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idesameRichiamo2">Nome dell'esame</label>
                                                    <select type="text" id="idesameRichiamo2" name="idesame" required="required"></select>
                                                    <div class="spinner-border text-primary" role="status">
                                                        <span class="sr-only">Loading...</span>
                                                    </div>
                                                </div>

                                            </div>


                                            <div class="form-group">
                                                <button id ="btnCambiaMedico" type="submit">Richiama</button>
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
    <%--        da inserire--%>
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
        // manageNavbar();
        // $(window).resize(manageNavbar);

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
        //});

        <%--        da inserire--%>

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

        // function hideNavbar() {
        //     $('#sidebar, #content').toggleClass('active');
        //     $('.collapse.in').toggleClass('in');
        //     $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        // }
        // function checkSize(){
        //     console.log("checkSize")
        //     if ($("#sidebarCollapse").is(':visible')){
        //         console.log("nascondo")
        //         $('#profiloControl, #reportControl, #richiamo1Control,#richiamo2Control').on('click.hideNavbar', function () {
        //             $('#sidebar, #content').toggleClass('active');
        //             $('.collapse.in').toggleClass('in');
        //             $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        //         });
        //
        //     }else{
        //         $("#profiloControl, #reportControl, #richiamo1Control,#richiamo2Control").off("click.hideNavbar");
        //     }
        // }
    });
</script>
</body>

</html>