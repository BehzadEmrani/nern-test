<%@ page import="com.atrosys.dao.ServiceFormRequestDAO"%>
<%@ page import="com.atrosys.model.ServiceFormRequestModel"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.List"%>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");


    List<ServiceFormRequestModel> requestModels = ServiceFormRequestDAO.findAllServiceFormRequestModels();

    String json = new Gson().toJson(requestModels);
    response.setContentType("application/json");
    out.print(json);
    out.flush();

%>
