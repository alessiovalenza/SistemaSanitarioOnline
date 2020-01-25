<%--
  Created by IntelliJ IDEA.
  User: francesco
  Date: 19/12/19
  Time: 17:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/testSelect2.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<head>
    <title>Title</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/css/select2.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/js/select2.min.js"></script>





<%--    var urlCambioMedico = 'http://localhost:8080/SSO_war_exploded/api/general/medicibase/?idprovincia='+'${sessionScope.utente.prov}'+'&'--%>
</head>
<body>
<div class="spinner-border"></div>
<select class="form-control select2-allow-clear" id="esame" placeholder="Cerca Esami" type="text" data-ajax--url="http://localhost:8080/SSO_war_exploded/api/general/medicibase/?idprovincia=TA" data-ajax--cache="true"></select><br>
<button id="btn">elemento selezionato</button>
<script>
        (document.getElementById("btn")).onclick = function() {
            let idSelected = $("#esame option:selected")["0"].value;
            alert("hai selezionato " + idSelected);
        };
        $(document).ready(function(){

            $("#esame").select2({
                placeholder: 'Cerca Esami',
                width: 300,
                allowClear: true,
                ajax: {
                    url: "http://localhost:8080/SSO_war_exploded/api/general/medicibase/?idprovincia=TA",
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
            $("#esame").val(null).trigger("change");
            // $('#esame').on("select2:opening", function(e) {
            //     $("#esame").select2({
            //     ajax: {
            //         url: "http://localhost:8080/SSO_war_exploded/api/general/medicibase/?idprovincia=TA&term=",
            //         datatype: "json",
            //         // data: function (params) {
            //         //     var query = {
            //         //         term: "",
            //         //         type: 'public',
            //         //         page: params.page || 1
            //         //     }
            //         //     return query;
            //         // },
            //         processResults: function (data) {
            //             var myResults = [];
            //             $.each(data, function (index, item) {
            //                 myResults.push({
            //                     'id': item.id,
            //                     'text': item.nome
            //                 });
            //             });
            //             return {
            //                 results: myResults
            //             };
            //         }
            //     }
            // });
            // });

        });
    </script>
    <!--<select class="js-example-basic-single" name="state">
        <option value="AL">Alabama</option>
        <option value="WY">Wyoming</option>
    </select>
    <script>
        $(document).ready(function() {
            $('.js-example-basic-single').select2();
        });
    </script>-->
</body>
</html>
