<%@ page import="com.atrosys.dao.ServiceFormDAO"%>
<%@ page import="com.atrosys.model.SLAType"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    long subServiceId=Long.valueOf(request.getParameter("sub-service-id"));
    int payType=Integer.valueOf(request.getParameter("pay-type"));
    int subsDuration=Integer.valueOf(request.getParameter("subs-duration"));
    int payPeriod=Integer.valueOf(request.getParameter("pay-period"));
    List<Integer> existSlaTypes=ServiceFormDAO.findExistSlaTypesBySubServiceIdAndPayTypeAndSubsDurationAndPayPeriod(
            subServiceId,payType,subsDuration,payPeriod);
    HashMap<Integer,Boolean> existSlaTypesDic=new HashMap<>();
    for (SLAType slaType:SLAType.values() )
            existSlaTypesDic.put(slaType.getValue(),existSlaTypes.contains(slaType.getValue()));
    String json = new Gson().toJson(existSlaTypesDic);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
