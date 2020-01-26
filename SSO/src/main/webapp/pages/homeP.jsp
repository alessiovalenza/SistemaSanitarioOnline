<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Collapsible sidebar using Bootstrap 4</title>

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
    <script src="../scripts/utils.js"></script>
    <script>
        const labelLoadingButtons = "loading";
        const labelSuccessButtons = "success";
        const labelErrorButtons = "error";

        $(document).ready(function(){

            $("#formPutCambiaMedico").submit(function(event){
                loadingButton("#btnCambiaMedico",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let form_data = $(this).serialize(); //Encode form elements for submission
                let url = 'http://localhost:8080/SSO_war_exploded/api/pazienti/' + ${sessionScope.utente.id} + '/medicobase'

                $.ajax({
                    url : url,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {
                        // alert("va")

                    },
                    complete: function(){
                        $('#idmedicobase').val(null).trigger("change")
                        successButton("#btnCambiaMedico",labelSuccessButtons)
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnCambiaMedico",labelErrorButtons)
                        alert(xhr.responseText);
                    }
                });
            });

            // $('#esamiFatti > tbody > tr').click(function() {// questa roba andava prima di datatables quindi ora la commento
            //     alert("riga cliccata")
            // });
            $('#medico').hide();
            $('#esami').hide();
            $('#formNostro').hide();
            $('#cambiaMedico').hide();
            $('#ricette').hide();


            $("#medicoControl").click(function(){
                $("#cambiaMedico").fadeOut(0);
                $("#esami").fadeOut(0);
                $("#profilo").fadeOut(0);
                $("#formNostro").fadeOut(0);
                $("#ricette").fadeOut(0);
                let url = 'http://localhost:8080/SSO_war_exploded/api/pazienti/${sessionScope.utente.id}/medicobase'
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
                $("#medico").fadeIn(0);

            });
            $("#profiloControl").click(function(){
                $("#esami").fadeOut(0);
                $("#medico").fadeOut(0);
                $("#cambiaMedico").fadeOut(0);
                $("#profilo").fadeIn(0);
                $("#formNostro").fadeOut(0);
                $("#ricette").fadeOut(0);
                $("#profilo").fadeIn(0);
            });
            $("#esamiControl").click(function(){
                $('#esamiErogati').DataTable().destroy()
                $('#esamiNonErogati').DataTable().destroy()
                $("#medico").fadeOut(0);
                $("#profilo").fadeOut(0);
                $("#formNostro").fadeOut(0);
                $("#cambiaMedico").fadeOut(0);
                $("#ricette").fadeOut(0);
                let urlEsamiNonErogati = "http://localhost:8080/SSO_war_exploded/api/utenti/${sessionScope.utente.id}/esamiprescritti?erogationly=false&nonerogationly=false";
                $('#esamiNonErogati').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlEsamiNonErogati,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "esame.nome" },//qua ovviamente va cambiato i
                        { "data": "esame.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" }

                    ]
                } );
                let urlEsamiErogati = "http://localhost:8080/SSO_war_exploded/api/utenti/"+ ${sessionScope.utente.id} +"/esamiprescritti?erogationly=true&nonerogationly=false";
                $('#esamiErogati').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlEsamiErogati,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        { "data": "esame.nome" },//qua ovviamente va cambiato i
                        { "data": "esame.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" },
                        { "data": "erogazione" },
                        { "data": "esito" }

                    ]
                } );
                $("#esami").fadeIn(0);
            });
            $("#formControl").click(function(){
                $("#medico").fadeOut(0);
                $("#profilo").fadeOut(0);
                $("#esami").fadeOut(0);
                $("#cambiaMedico").fadeOut(0);
                $("#ricette").fadeOut(0);
                $("#formNostro").fadeIn(0);
            });
            $("#cambiaMedicoControl").click(function(){
                $("#medico").fadeOut(0);
                $("#profilo").fadeOut(0);
                $("#esami").fadeOut(0);
                $("#formNostro").fadeOut(0);
                $("#ricette").fadeOut(0);
                $("#cambiaMedico").fadeIn(0);
                let urlCambioMedico = 'http://localhost:8080/SSO_war_exploded/api/general/medicibase/?idprovincia='+'${sessionScope.utente.prov}'
                $("#idmedicobase").click(function(){
                    alert("pre")
                    $("#idmedicobase").select2({
                        ajax: {
                            url: urlCambioMedico,
                            datatype: "json",
                            data: function (params) {
                                var query = {
                                    term: "",
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
                    $("#idmedicobase").val(null).trigger("change");

                });
                $("#idmedicobase").select2({
                    placeholder: 'Cerca Medici',
                    width: 300,
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
                $("#idmedicobase").val(null).trigger("change");
            });
            $("#ricetteControl").click(function(){
                $('#ricetteEvase').DataTable().destroy()
                $('#ricetteNonEvase').DataTable().destroy()
                $("#medico").fadeOut(0);
                $("#profilo").fadeOut(0);
                $("#esami").fadeOut(0);
                $("#formNostro").fadeOut(0);
                $("#cambiaMedico").fadeOut(0);
                let urlRicetteNonEvase = "http://localhost:8080/SSO_war_exploded/api/utenti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=false&nonevaseonly=true";
                $('#ricetteNonEvase').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlRicetteNonEvase,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [    //mettete in ordine le colonne in base a come le avete messe sull'html, seguite l'esempio che ho fatto con gli esami
                        { "data": "esame.nome" },//ovviamente tutto da cambiare
                        { "data": "esame.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" },
                        { "data": "esame.nome" },
                        { "data": "esame.nome" }
                    ]
                } );
                let urlRicetteEvase = "http://localhost:8080/SSO_war_exploded/api/utenti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=true&nonevaseonly=false";
                $('#ricetteEvase').DataTable( {
                    "processing": true,
                    "serverSide": true,
                    "ajax": {
                        "url": urlRicetteEvase,
                        "type":"GET",
                        "dataSrc": ""
                    },
                    "columns": [    //mettete in ordine le colonne in base a come le avete messe sull'html, seguite l'esempio che ho fatto con gli esami
                        { "data": "esame.nome" },//ovviamente tutto da cambiare
                        { "data": "esame.descrizione" },
                        { "data": "medicoBase.cognome" },
                        { "data": "prescrizione" },
                        { "data": "esame.nome" },
                        { "data": "esame.nome" }
                    ]
                } );
                $("#ricette").fadeIn(0);

            });
        });

    </script>


    <script>
        function appendImages() {

            for (var i=1; i<4; i++){
                var img=document.createElement("img");
                var slide=document.createElement("div");
                slide.id = i
                if (i == 1) {
                    slide.className="carousel-item active"
                }else{
                    slide.className="carousel-item"
                }
                img.src="../../${sessionScope.utente.id}/"+ i +".jpeg";
                img.style="width:100%;";
                console.log(img);
                document.body.appendChild(slide);
                document.getElementById(i).appendChild(img);
                console.log(slide.id);
                document.getElementById("prova").appendChild(slide);
                console.log("fatta slide");
            }
        }
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
            <h4>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h4>
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
                <a href="#"  class="componentControl" id ="esamiControl">Visualizza esami fatti</a>
            </li>
            <li>
                <a href="#" class="componentControl" id ="ricetteControl">Visualizza ricette</a>
            </li>
            <li>
                <a href="#" class="componentControl" id ="formControl">Visualizza form nostro</a>
            </li>
            <li>
                <a href="../mappe.jsp" id="mappeControl">Visualizza mappe</a>
            </li>
            <li>
                <a href="../logout?forgetme=0">Log out</a>
            </li>
            <li>
                <a href="../logout?forgetme=1">Cambia account</a>
            </li>

        </ul>
    </nav>

    <!-- Page Content  -->azzurro
    <div id="content">

        <div class="container-fluid" align="center" id="cambiaMedico">
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
        <div class="container-fluid" align="center" id="formNostro">
            <div class="form" method="post" >
                <div class="form-toggle"></div>
                <div class="form-panel one">
                    <div class="form-header">
                        <h1>form nostro</h1>
                    </div>
                    <div class="form-content">
                        <form method="post" action="http://localhost:8080/SSO_war_exploded/api/medicobase/esameprescritto">
                            <div class="form-group">
                                <label for="idesame">Username</label>
                                <input type="text" id="idesame" name="idesame" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="idpaziente">Password</label>
                                <input type="password" id="idpaziente" name="idpaziente" required="required"/>
                            </div>

                            <div class="form-group">
                                <button type="submit">Log In</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">

                <button type="button" id="sidebarCollapse" class="btn btn-info">
                    <i class="fas fa-align-left"></i>
                    <span>Toggle Sidebar</span>
                </button>
            </div>
        </nav>
        <div class="tool"  id="profilo">

            <div class="card" >
                <div class="text-center" >

                    <div data-interval="false" id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                        <div  id="prova" class="carousel-inner">
<%--                            <div class="carousel-item active">--%>
<%--                                <img class="img-fluid" src="propic.jpeg" alt="First slide">--%>
<%--                            </div>--%>
<%--                            <div class="carousel-item">--%>
<%--                                <img class="img-fluid" src="3.jpeg" alt="Second slide">--%>
<%--                            </div>--%>
<%--                            <div class="carousel-item">--%>
<%--                                <img class="img-fluid" src="2.jpeg" alt="Third slide">--%>
<%--                            </div>--%>
                        </div>
                        <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="sr-only">Previous</span>
                        </a>
                        <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div style="clear: both">
                        <form action="#" id="formUpload" method="POST" role="form" enctype="multipart/form-data">
                            <div>
                            <input style="float: left; height: 35pt" class="btn btn-primary" type="file" name="foto" id="foto" onchange="return fileValidation()"/>
                            <button style="float:right; height: 35pt; background: grey;" class="btn btn-primary" type="submit" id="Button" disabled> Aggiungi Immagine </button>
                            </div>
                        </form>
                        <script>
                            function fileValidation(){
                                var fileInput = document.getElementById('foto');
                                var filePath = fileInput.value;
                                var allowedExtensions = /(\.jpg|\.jpeg)$/i;
                                if(!allowedExtensions.exec(filePath)){
                                    alert('Please upload file having extensions .jpeg/.jpg only.');
                                    fileInput.value = null;
                                    return false;
                                } else {
                                    document.getElementById("Button").disabled = false;
                                    document.getElementById("Button").style.background = "#007bff";
                                }
                            }

                            $(document).ready(function() {
                                $("#formUpload").submit(function(e){
                                    e.preventDefault();
                                    var formData = new FormData($("#formUpload")[0]);

                                    $.ajax({
                                        url : '${pageContext.request.contextPath}/api/utenti/${sessionScope.utente.id}/foto',
                                        type : 'POST',
                                        data : formData,
                                        contentType : false,
                                        processData : false,
                                        success: function(resp) {
                                            alert("Immagine aggiunta con successo!");
                                            document.getElementById('foto').value = null;
                                            document.getElementById("Button").disabled = true;
                                            document.getElementById("Button").style.background = "grey";
                                        }
                                    });
                                });
                            });
                        </script>
                    </div>

                    <div style="clear: both; padding-top: 0.5rem">
                        <hr>
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
                    <button style="align: right" href="#" class="btn btn-primary">Go somewhere</button>
                </div>
            </div>
        </div>
        <div id="esami">
            <h2>esami non erogati</h2>
            <div class="table-responsive">
                <table id="esamiNonErogati" class="table table-striped table-hover ">
                    <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Medico</th>
                        <th>Data prescrizione</th>
                    </tr>
                    </thead>
                </table>
            </div>
            <h2>esami erogati</h2>
            <div class="table-responsive">
                <table id="esamiErogati" class="table table-striped table-hover ">
                    <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Medico</th>
                        <th>Data prescrizione</th>
                        <th>Data erogazione</th>
                        <th>Esito</th>
                    </tr>
                    </thead>
                </table>
            </div>

        </div>
        <div id="ricette">
            <h2>ricette non evase ovviamente dovete cambiare i campi</h2>
            <div class="table-responsive">
                <table id="ricetteNonEvase" class="table table-striped table-hover ">
                    <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Medico</th>
                        <th>Data prescrizione</th>
                        <th>Data erogazione</th>
                        <th>Esito</th>
                    </tr>
                    </thead>

                </table>
            </div>
            <h2>ricette evase ovviamente dovete cambiare i campi </h2>
            <div class="table-responsive">
                <table id="ricetteEvase" class="table table-striped table-hover ">
                    <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Medico</th>
                        <th>Data prescrizione</th>
                        <th>Data erogazione</th>
                        <th>Esito</th>
                    </tr>
                    </thead>

                </table>
            </div>
        </div>
        <div class="tool" id="medico">
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

        // $('#sidebar').on('hidden.bs.collapse', function() {
        //     alert('dasd')
        // });
        // $("#sidebar").mCustomScrollbar({
        //     theme: "minimal"
        // });
        //
        //
        // $('#sidebarCollapse').on('click', function () {
        //     $('#sidebar, #content').toggleClass('active');
        //     $('.collapse.in').toggleClass('in');
        //     $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        // });

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
    });
</script>
<script>appendImages()</script>
</body>

</html>