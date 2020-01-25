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
    <script>
        function isValid(){
            let new_pass = $("#new_password").val()
            let repeat_pass = $("#repeat_password").val()
            return new_pass == repeat_pass
        }
        $(document).ready(function() {
            $("form").submit(function(e){
                if (!isValid()) {
                    e.preventDefault();
                    alert("le password non coincidono")
                }
            });
        });
    </script>
</head>

<body>
    <nav class="navbar-expand-md sticky-top"
        style="background-color: #51b5e0;font-family: 'Open Sans', sans-serif;padding: 11px; border-style: groove; border-width: 1px;border-color:lightgray">
        <div class="container-fluid"><img src="assets/img/logo_repubblica_colori.png"
                style="height: 42px;padding: 0px;margin: 0px;">
            <a class="navbar-brand" href="index.jsp"
                style="padding: 3px;font-family: default;color: rgb(255,255,255);">
                Ministero della salute
            </a>
        </div>
    </nav>

    <div class="container" style="padding-top: 5%">
        <div class="row">
            <div class="col-md-12">
                <h5>Inserisci la nuova password</h5>
                <form action="passreset" method="post">
                    <div class="form-group">
                        <label for="new_password">Nuova password</label>
                        <input type="password" class="form-control" name="new_password" id = "new_password">
                    </div>
                    <div class="form-group">
                        <label for="repeat_password">Riscrivi la nuova password</label>
                        <input type="password" class="form-control" name="repeat_password" id = "repeat_password">
                    </div>

                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
        </div>
    </div>

    <nav class="navbar"
        style="background-color: #51b5e0;font-family: 'Open Sans', sans-serif; border-style: groove; border-width: 1px;border-color:lightgray;bottom: 0;position: fixed;width: 100%; height: 4rem;">
        <p class="navbar-text" style="font-family: default;color: rgb(255,255,255); font-size: inherit">
            via Sommarive, 5 - 38123 Trento (Povo)
            Tel. +39 1234 567890
            CF e P.IVA 12345678901
            Numero verde 800 12345
        </p>
    </nav>
</body>

</html>