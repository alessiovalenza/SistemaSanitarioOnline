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
            $('#profilo').show();
            $('#profiloControl').click(() => showComponent('profilo'));
            $('#reportControl').click(() => showComponent('report'));
        });
    </script>
</head>

<body>

<div class="wrapper">
    <!-- Sidebar  -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <img class="avatar" alt="Avatar" src="propic.jpeg"
                 data-holder-rendered="true">
            <h3>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h3>
            <h6>${sessionScope.utente.cognome}</h6>
        </div>

        <ul class="list-unstyled components">
            <li>
                <a href="#" id="profiloControl">Profilo</a>
            </li>
            <li>
                <a href="#" id="reportControl">Report</a>
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
    </div>
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

        $('#sidebar').on('hidden.bs.collapse', function() {
            alert('dasd')
        });
        $("#sidebar").mCustomScrollbar({
            theme: "minimal"
        });

        $('#sidebarCollapse').on('click', function () {
            $('#sidebar, #content').toggleClass('active');
            $('.collapse.in').toggleClass('in');
            $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        });
    });
</script>
</body>

</html>