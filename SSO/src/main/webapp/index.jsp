<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servizio Sanitario</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"
            integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ"
            crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"
            integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY"
            crossorigin="anonymous"></script>
</head>

<body style="background-color:#1e88e5">
<div id="holder">
    <header>
        <nav class="navbar-expand-md sticky-top "
             style="background-color: #1565c0;padding: 11px;border-style: groove; border-width: 0pt; border-color:lightgray">
            <div class="container-fluid"><img src="assets/img/logo_repubblica_colori.png"
                                              style="height: 42px;padding: 0px;margin: 0px;">
                <a class="navbar-brand" href="index.jsp"
                   style="padding: 3px;color: rgb(255,255,255);">
                    Ministero della salute
                </a>
            </div>
        </nav>
    </header>
    <div id="body">
        <div style="position: relative; text-align: center;width: 100%;">
            <img style="width:100%;" src="assets/img/sfondo_index.jpeg">
            <div style="position: absolute; top: 20%; left: 50%;color: white;width: 50%;">
                <h3 class="scaled"
                    style="text-shadow: 1px 1px black; font-size: 4vw; ">
                    <fmt message>Sistema Sanitario <br> per il Cittadino</fmt>
                </h3>

                <p
                        style="text-shadow: 1px 1px black;font-size: 2vw;">
                    <fmt message>Benvenuto sul sistema universale <br> per il servizio Sanitario</fmt>
                </p>
                <div> <a href="LoginServlet"><button type="button" class="btn btn-primary"
                                                   style="box-shadow: 1pt 1pt black;font-size:2vw ; width: 30%;background-color:#1e88e5">Login</button></a>
                </div>
            </div>
        </div>

        <div class="container-fluid">
            <div class="row" style="background-color:#1e88e5;color: white;">
                <div class="col-md-12" style="text-align: center;">
                    <h4 style="text-shadow: 1px 1px black; padding-top: 2%;padding-bottom: 2%;font-family: 'Roboto','Poppins', sans-serif;">
                        Da qui
                        potrai usufruire di tutti i servizi
                        disponibili a tutti gli utenti.</h4>
                </div>
            </div>
        </div>

        <div class="container-fluid">
            <div class="row" style="background-color:#1e88e5;color: white;padding-bottom: 5%;">
                <div class="col-md-6" style="text-align: center;text-shadow: 1px 1px black;">


                    <div style="background-color: transparent;padding-bottom: 2%">
                        <h5 class="" style=" text-shadow: 1px 1px black; background-color:
                            transparent; ">
                            Per chi
                        </h5>
                    </div>

                    <h6>Medici</h6>

                    <h6>Pazienti</h6>

                    <h6>
                        Farmacie
                    </h6>

                    <h6>Servizio Sanitario Nazionale/Provinciale</h6>
                    </fmt>

                </div>
                <div class="col-md-6" style="text-align: center;text-shadow: 1px 1px black;">

                    <div style="background-color: transparent;padding-bottom: 2%;">
                        <h5 class="" style="text-shadow: 1px 1px black; background-color: transparent; ">
                            Cosa si puo fare
                        </h5>
                    </div>



                    <h6>Prenotare Appuntamenti</h6>

                    <h6>Richiedere farmaci</h6>

                    <h6>Ananmnesi</h6>

                    <h6>Resoconto economico</h6>



                </div>
            </div>
        </div>

    </div>
    <footer>
        via Sommarive, 5 - 38123 Trento (Povo)
        Tel. +39 1234 567890
        CF e P.IVA 12345678901
        Numero verde 800 12345

    </footer>
</div>

</body>

</html>