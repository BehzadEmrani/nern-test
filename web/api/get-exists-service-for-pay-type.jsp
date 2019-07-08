<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page import="com.atrosys.model.PayType"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    Long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    List<Integer> existPayTypes=ServiceFormDAO.findExistForPayTypesBySubServiceId(subServiceId);
    HashMap<Integer,Boolean> existPayTypesDic=new HashMap<>();
    for (PayType payType :PayType.values() )
            existPayTypesDic.put(payType.getValue(),existPayTypes.contains(payType.getValue()));
    String json = new Gson().toJson(existPayTypesDic);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
