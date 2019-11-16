<%@ page import="com.atrosys.dao.UniversityDAO"%>
<%@ page import="com.atrosys.model.SubSystemCode"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.HashMap"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, X-Requested-With, access-control-allow-origin, access-control-allow-methods, access-control-allow-headers");

    if (request.getMethod().equals("OPTIONS")) {
        response.setStatus(HttpServletResponse.SC_OK);
        out.flush();
    }

    request.setCharacterEncoding("UTF-8");


    HashMap<String, String> responseFields = new HashMap<>();

    try {
        responseFields.put("UNIVERSITY",String.valueOf(UniversityDAO.getRowCount(SubSystemCode.UNIVERSITY.getValue())));
        responseFields.put("SEMINARY",String.valueOf(UniversityDAO.getRowCount(SubSystemCode.SEMINARY.getValue())));
        responseFields.put("RESEARCH_CENTER",String.valueOf(UniversityDAO.getRowCount(SubSystemCode.RESEARCH_CENTER.getValue())));
        responseFields.put("HOSPITAL",String.valueOf(UniversityDAO.getRowCount(SubSystemCode.HOSPITAL.getValue())));
    } catch (Exception e) {
        response.sendError(500,"خطای نامشخص");
    }

    String json = new Gson().toJson(responseFields);
    response.setContentType("application/json");
    out.print(json);
    out.flush();

%>
