<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="url" value="http://localhost:8080/SSO_war_exploded/pages/uploadImage.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />


<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Upload a file</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  </head>
  <body>

    <h1>Choose a file</h1>
    <!-- File input field -->
    <!--<form action="#" method="POST" enctype="multipart/form-data" role="form" id="formUpload">
      <input type="file" name="foto" id="foto" onchange="return fileValidation()"/><br>
      <button type="submit">Submit </button><br>
    </form>-->
    <form action="#" id="formUpload" method="POST" role="form" enctype="multipart/form-data">
      <input type="file" name="foto" id="foto" onchange="return fileValidation()"/><br>
      <button type="submit">Submit </button>
    </form>

    <!-- Image preview -->
    <div id="imagePreview"></div>

    <script>
      function fileValidation(){
        var fileInput = document.getElementById('foto');
        var filePath = fileInput.value;
        var allowedExtensions = /(\.jpg|\.jpeg)$/i;
        if(!allowedExtensions.exec(filePath)){
          alert('Please upload file having extensions .jpeg/.jpg only.');
          fileInput.value = null;
          return false;
        }else{
          //Image preview
          if (fileInput.files && fileInput.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('imagePreview').innerHTML = '<img src="'+e.target.result+'" width="20%"/>';
            };
            reader.readAsDataURL(fileInput.files[0]);
          }
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
              console.log(resp);
            }
          });
        });
      });
    </script>
  </body>
</html>