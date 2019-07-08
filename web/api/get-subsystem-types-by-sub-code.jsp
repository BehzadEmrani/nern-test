<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.SubSystemsType" %>
<%@ page import="com.atrosys.model.SubSystemsTypeResponse" %><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    SubSystemCode subSystemCode=SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    SubSystemsType[] subSystemsTypes =SubSystemCode.subSystemsTypeFromSubCode(subSystemCode);
    List<SubSystemsTypeResponse> subSystemsTypeResponses=new LinkedList<>();
    for (SubSystemsType subSystemsType : subSystemsTypes) {
        SubSystemsTypeResponse typeResponse=new SubSystemsTypeResponse();
        typeResponse.setFaStr(subSystemsType.getFaStr());
        typeResponse.setValue(subSystemsType.getValue());
        subSystemsTypeResponses.add(typeResponse);
    }
    String json = new Gson().toJson(subSystemsTypeResponses);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
