<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page import="com.atrosys.model.PayPeriod"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    int subsDuration=Integer.valueOf(request.getParameter("subs-duration"));
    List<Integer> existPayPeriods=ServiceFormDAO.findExistForPayPeriodBySubServiceIdAndPayTypeAndSubsDuration(subServiceId,payType,subsDuration);
    HashMap<Integer,Boolean> existPayPeriodsDic=new HashMap<>();
    for (PayPeriod payPeriod:PayPeriod.values() )
            existPayPeriodsDic.put(payPeriod.getValue(),existPayPeriods.contains(payPeriod.getValue()));
    String json = new Gson().toJson(existPayPeriodsDic);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
