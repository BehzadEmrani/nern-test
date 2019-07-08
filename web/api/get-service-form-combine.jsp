<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    int subsDuration=Integer.valueOf(request.getParameter("subs-duration"));
    int payPeriod=Integer.valueOf(request.getParameter("pay-period"));
    int slaType=Integer.valueOf(request.getParameter("sla-type"));
    String comnineStr=ServiceFormDAO.findServiceFormCombinedNameByConditions(
            subServiceId,payType,subsDuration,payPeriod,slaType);
    response.setContentType("application/text");
    out.print(comnineStr);
    out.flush();
%>