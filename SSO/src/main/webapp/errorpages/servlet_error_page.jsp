<%@ page import="it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>

<%
    SSOServletException exc = (SSOServletException) exception;
    response.setStatus(exc.getStatusErrorCode());
%>

<html>
<head>
    <title>Error page - <%= exc.getStatusErrorCode()%></title>
</head>
<body>
    <h1><%= exc.getStatusErrorCode()%></h1>
    <p>
        <%=exc.getMessage()%>
    </p>
</body>
</html>