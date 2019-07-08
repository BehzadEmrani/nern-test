<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page import="com.atrosys.model.SubsDuration"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    List<Integer> existSubDurations=ServiceFormDAO.findExistForSubDurationsBySubServiceIdAndPayType(subServiceId,payType);
    HashMap<Integer,Boolean> existSubDurationsDic=new HashMap<>();
    for (SubsDuration subsDuration:SubsDuration.values() )
            existSubDurationsDic.put(subsDuration.getValue(),existSubDurations.contains(subsDuration.getValue()));
    String json = new Gson().toJson(existSubDurationsDic);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
