<%@ page import="com.atrosys.dao.SubServiceDAO" %>
<%@ page import="com.atrosys.entity.SubService" %><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    List<SubService> subServices = SubServiceDAO.findSubServiceByServiceId(Long.valueOf(request.getParameter("service-id")));
    String json = new Gson().toJson(subServices);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
