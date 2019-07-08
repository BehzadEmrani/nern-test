<%@ page import="com.atrosys.dao.TelecomCenterDAO" %>
<%@ page import="com.atrosys.entity.TelecomCenter" %>
<%@ page import="com.atrosys.model.TelecomResponse" %><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
 response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    request.setCharacterEncoding("UTF-8");
    List<TelecomCenter> telecomCenters = TelecomCenterDAO.findTelecomCentersByCityId(Long.valueOf(request.getParameter("city-id")));
    LinkedList<TelecomResponse> responses = new LinkedList<>();
    for (TelecomCenter telecomCenter : telecomCenters) {
        TelecomResponse telecomResponse = new TelecomResponse();
        telecomResponse.setId(telecomCenter.getId());
        telecomResponse.setName(telecomCenter.getName());
        responses.add(telecomResponse);
    }
    String json = new Gson().toJson(responses);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
