<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Reset Password</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="assets/css/styles.css">
</head>

<body>
<div id="holder">
    <header>
        <nav class="navbar-expand-md sticky-top"
             style="background-color: #1e88e5;padding: 11px; border-style: groove; border-width: 1px;border-color:lightgray">
            <div class="container-fluid"><img src="assets/img/logoebbasta.png"
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
            <p>${msg}</p>
            <div class="row">
                <div class="col-md-12">
                    <h5>Inserisci la tua email</h5>
                    <hr>
                    <br>
                    <form action="passreset" method="get">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" name="email" id="email" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Invia</button>
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
