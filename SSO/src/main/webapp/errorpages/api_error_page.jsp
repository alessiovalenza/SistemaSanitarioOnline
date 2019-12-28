<%@ page import="it.unitn.disi.wp.progetto.api.exceptions.ApiException"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>

<%
    ApiException exc = (ApiException)exception;
    response.setStatus(exc.getStatusErrorCode());
%>

{
    "message": "<%= exc.getMessage()%>"
}