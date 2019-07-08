<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page import="com.atrosys.entity.ServiceFormParameter"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    int subsDuration=Integer.valueOf(request.getParameter("subs-duration"));
    int payPeriod=Integer.valueOf(request.getParameter("pay-period"));
    int slaType=Integer.valueOf(request.getParameter("sla-type"));
    List<ServiceFormParameter> serviceFormParameters=ServiceFormDAO.findServiceFormParametersByConditions(
            subServiceId,payType,subsDuration,payPeriod,slaType);
    String json = new Gson().toJson(serviceFormParameters);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
