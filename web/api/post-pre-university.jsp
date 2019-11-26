<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="com.atrosys.model.PreUniversityDataItem"%>
<%@ page import="com.atrosys.entity.PreUniversityData"%>
<%@ page import="com.atrosys.dao.PreUniversityDataDAO"%>
<%@ page import="com.atrosys.model.PreDataType"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");

    StringBuilder sb = new StringBuilder();
    BufferedReader reader = request.getReader();
    try {
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append('\n');
        }
    } finally {
        reader.close();
    }
    PreUniversityDataItem dataItem = new Gson().fromJson(sb.toString(),PreUniversityDataItem.class);

    PreDataType a =PreDataType.formFaStr(dataItem.getUniType());

    PreUniversityData data = PreUniversityDataDAO.findPreUniversityDataByInternalUniCode(dataItem.getUniInternalCode(),a.getValue());
    if (data ==null) {
        data = new PreUniversityData();
        data.setUniInternalCode(Long.valueOf(dataItem.getUniInternalCode()));
        data.setUniSourceType(Integer.valueOf(dataItem.getUniType()));
    }
    data.setAddress(dataItem.getAddress());
    data.setName(dataItem.getName());
    PreUniversityDataDAO.save(data);

    String json = new Gson().toJson(data);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
