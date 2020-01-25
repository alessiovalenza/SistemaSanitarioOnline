<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="assets/css/login.css">
</head>

<body>
    <div id="holder">
        <header>
     <nav class="navbar-expand-md sticky-top"
        style="background-color: #1565c0;padding: 11px; border-style: groove; border-width: 0px;border-color:lightgray">
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
    <div class="container-fluid">
        <div class="wrapper fadeInDown">
            <div id="formContent">
                <div class="alert alert-warning" role="alert">
                    ${error}
                </div>
                <p>${msg}</p>
                <form name="loginForm" action="LoginServlet" method="post">
                    <input type="email" id="email" class="fadeIn second" name="email" placeholder="Email" required>
                    <input type="password" id="password" class="fadeIn third" name="password" placeholder="Password"
                        required>
                    <input type="submit" class="fadeIn fourth" value="Log In"><br />
                    <label for="checkbox" class="fadeIn fourth">Remember Me</label>
                    <input type="checkbox" class="fadeIn fourth" name="remember_me" id="checkbox">
                </form>

                <div id="formFooter">
                    <a class="underlineHover" href="sendEmail.jsp">Forgot Password?</a>
                </div>

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