<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <script src="../scripts/utils.js"></script>
    <script>
        const labelLoadingButtons = "loading";
        const labelSuccessButtons = "success";
        const labelErrorButtons = "error";
        $(document).ready(function () {
            /* $('#esamiFatti > tbody > tr').click(function () {
                alert("riga cliccata")
            }); */
            // $('#evadiRicette').hide();

            let labelCercaPaz = "Cerca pazienti";

            $("#idpaziente").select2({
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
            // let urlSelectRicette = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idpaziente').children("option:selected").val()+'/ricette/?evaseonly=false&nonevaseonly=true'
            //
            // $("#idricetta").select2({
            //     placeholder: 'Cerca Farmaci',
            //     width: 300,
            //     allowClear: true,
            //     ajax: {
            //         url: urlSelectRicette,
            //         datatype: "json",
            //         data: function (params) {
            //             var query = {
            //                 term: params.term,
            //                 type: 'public',
            //                 page: params.page || 1
            //             }
            //             return query;
            //         },
            //         processResults: function (data) {
            //             var myResults = [];
            //             $.each(data, function (index, item) {
            //                 myResults.push({
            //                     'id': item.id,
            //                     'text': item.farmaco.nome+" "+item.farmaco.descrizione +", prescritta da "+item.medicoBase.nome+" "+item.medicoBase.cognome+" il "+item.emissione
            //                 });
            //             });
            //             return {
            //                 results: myResults
            //             };
            //         }
            //     }
            // });
            //$("#idricetta").select2({})


            $("#idricetta").select2({
                placeholder: 'Cerca Farmaci',
                width: 300,
                allowClear: true,
                ajax: {
                    url: function () {
                        let urlSelectRicette = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idpaziente').children("option:selected").val()+'/ricette/?evaseonly=false&nonevaseonly=true'
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
                        $.each(data, function (index, item) {
                            myResults.push({
                                'id': item.id,
                                'text': item.farmaco.nome+" "+item.farmaco.descrizione +", prescritta da "+item.medicoBase.nome+" "+item.medicoBase.cognome+" il "+item.emissione
                            });
                        });
                        return {
                            results: myResults
                        };
                    }
                }
            });


            $("#formEvadiRicetta").submit(function(event){
                loadingButton("#btnEvadiRicetta",labelLoadingButtons)
                event.preventDefault(); //prevent default action
                let urlEvadiRicetta = 'http://localhost:8080/SSO_war_exploded/api/pazienti/'+$('#idpaziente').val()+'/ricette/'+$('#idricetta').val();
                let form_data = "idfarmacia=${sessionScope.utente.id}"
                $.ajax({
                    url : urlEvadiRicetta,
                    type: "PUT",
                    data : form_data,
                    success: function (data) {

                        $('.select2EvadiRicetta').val(null).trigger("change")
                        successButton("#btnEvadiRicetta",labelSuccessButtons)
                    },
                    complete: function(){
                    },
                    error: function(xhr, status, error) {
                        errorButton("#btnEvadiRicetta",labelErrorButtons)
                        alert(xhr.responseText);
                    }
                });
            });



            $('#profiloControl').click(function () {
                $('#erogaMed').fadeOut(0);
                $('#evadiEicette').fadeOut(0);
            });
            $('#erogaMedControl').click(function () {
                $('#erogaMed').fadeIn(0);
                $('#evadiRicette').fadeOut(0);
            });
            $('#ricetteControl').click(function () {
                $('#erogaMed').fadeOut(0);
                $('#evadiRicette').fadeIn(0);
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
        <div id="dismiss">
            <i class="fas fa-arrow-left"></i>
        </div>
        <div class="sidebar-header">
            <img class="avatar" alt="Avatar" src="../assets/img/logo_repubblica_colori.png" data-holder-rendered="true">
            <h3>${sessionScope.utente.nome} ${sessionScope.utente.cognome}</h3>
        </div>

        <ul class="list-unstyled">
            <li>
                <a href="#" class="componentControl" id="ricetteControl">Evadi Ricette</a>
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
                    <i class="fas fa-align-justify"></i>
                </button>

                <h3>SSC</h3>
            </div>
        </nav>

        <div id="evadiRicette" class="tool">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Evadi una ricetta ad un paziente:</h3>
                        <hr>
                        <div class="container-fluid" align="center" id="cambiaMedico">
                            <div class="form"  >
                                <div class="form-toggle"></div>
                                <div class="form-panel one">
                                    <div class="form-header">
                                        <h1>Evadi una ricetta</h1>
                                    </div>
                                    <div class="form-content">
                                        <form id="formEvadiRicetta" >
                                            <div class="form-group">
                                                <div class="container-fluid">
                                                    <label for="idpaziente">Nome del paziente</label>
                                                    <select class="select2EvadiRicetta" type="text" id="idpaziente" name="idpaziente" required="required"></select>
                                                </div>
                                                <div class="container-fluid" style="padding-top: 1rem">
                                                    <label for="idricetta">Nome del farmaco</label>
                                                    <select class="select2EvadiRicetta" type="text" id="idricetta" name="idricetta" required="required"></select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <button id="btnEvadiRicetta" type="submit">Evadi</button>
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

        /* $('#sidebar').on('hidden.bs.collapse', function () {
            alert('dasd')
        }); */
        // $("#sidebar").mCustomScrollbar({
        //     theme: "minimal"
        // });


        /*    $('#sidebarCollapse').on('click', function () {
               $('#sidebar, #content').toggleClass('active');
               $('.collapse.in').toggleClass('in');
               $('a[aria-expanded=true]').attr('aria-expanded', 'false');
           }); */
    });
</script>
<script>

    // document.getElementById("pagato").required = true;
</script>
<!-- jQuery CDN - Slim version (=without AJAX) -->
<!-- Popper.JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
        integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
        crossorigin="anonymous"></script>
<!-- Bootstrap JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
        integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm"
        crossorigin="anonymous"></script>
<!-- jQuery Custom Scroller CDN -->
<script
        src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>
</body>

</html>