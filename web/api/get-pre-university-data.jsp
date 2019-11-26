<%@ page import="com.atrosys.dao.PreUniversityDataDAO"%>
<%@ page import="com.atrosys.entity.PreUniversityData"%>
<%@ page import="com.atrosys.model.PreDataType"%>
<%@ page import="com.atrosys.model.PreUniversityDataItem"%><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");



    List<PreUniversityData> preUniversityDataList = PreUniversityDataDAO.findAllPreUniversityDatas();
    List<PreUniversityDataItem> myResponse = new LinkedList<>();
    PreUniversityDataItem responseItem;

    for (PreUniversityData data:preUniversityDataList ) {
        responseItem = new PreUniversityDataItem();
        responseItem.setAddress(data.getAddress());
        responseItem.setId(data.getId());
        responseItem.setName(data.getName());
        responseItem.setUniInternalCode(data.getUniInternalCode());
        responseItem.setUniType(PreDataType.fromValue(data.getUniSourceType()).getFaStr());

        myResponse.add(responseItem);
    }

    String json = new Gson().toJson(myResponse);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
