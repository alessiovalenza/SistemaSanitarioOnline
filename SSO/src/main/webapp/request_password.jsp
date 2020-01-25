<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Request Password</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="assets/css/styles.css">

    <script>
        function validateForm() {
            var inputEmail = document.forms["loginForm"]["email"].value;
            var inputPassword = document.forms["loginForm"]["password"].value;

            if (inputEmail == "") {
                alert("Inserire Email");
                return false;
            }
            if (inputPassword == "") {
                alert("Inserire password");
                return false;
            }
        }
    </script>
</head>

<body>
<div id="holder">
    <header>
        <nav class="navbar-expand-md sticky-top"
             style="background-color: #1e88e5;padding: 11px; border-style: groove; border-width: 1px;border-color:lightgray">
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
        <div class="container" style="padding-top: 5%">
            <div class="row">
                <div class="col-md-12">
                    <h3>Richiesta reset Password</h3>

                    <h5>Inserisci la tua e-mail e riceverai un modulo per reimpostare la tua password</h5>
                    <form action="reset_password.jsp">
                        <div class="form-group">
                            <label for="email">Email address:</label>
                            <input type="email" class="form-control" id="email">
                        </div>

                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>


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