<%@ page import="com.atrosys.dao.ServiceFormDAO"%><%@ page import="com.atrosys.entity.ServiceForm"%><%@ page import="com.google.gson.Gson"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    int subsDuration=Integer.valueOf(request.getParameter("subs-duration"));
    int payPeriod=Integer.valueOf(request.getParameter("pay-period"));
    int slaType=Integer.valueOf(request.getParameter("sla-type"));
    ServiceForm serviceForm=ServiceFormDAO.findServiceFormByConditions(
            subServiceId,payType,subsDuration,payPeriod,slaType);
    String json = new Gson().toJson(serviceForm);
    response.setContentType("application/text");
    out.print(json);
    out.flush();
%>