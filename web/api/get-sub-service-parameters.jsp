<%@ page import="com.atrosys.dao.SubServiceParameterDAO"%>
<%@ page import="com.atrosys.entity.SubServiceParameter"%><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    List<SubServiceParameter> subServiceParameters =
     SubServiceParameterDAO.findSubServiceParameterBySubServiceId(Long.valueOf(request.getParameter("sub-service-id")));
    String json = new Gson().toJson(subServiceParameters);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
