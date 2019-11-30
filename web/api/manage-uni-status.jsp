<%@ page import="com.atrosys.dao.UniversityDAO"%>
<%@ page import="com.atrosys.entity.University"%>
<%@ page import="com.atrosys.model.UniStatus"%>
<%@ page import="com.atrosys.model.UniStatusItem"%>
<%@ page import="com.atrosys.model.UniSubStatus"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");

    if (request.getMethod().equals("GET")) {

        long id = Long.valueOf(request.getParameter("id"));
        University university = UniversityDAO.findUniByUniNationalId(id);
        int uniStat = university.getUniStatus();

        List<UniStatusItem> myResponse = new LinkedList<>();
        for (UniStatus status: UniStatus.values()) {
            UniStatusItem item = new UniStatusItem();
            item.setValue(status.getValue());
            item.setFaStr(status.getFaStr());
            if (uniStat == status.getValue()) {
                item.setCurrentStatus(true);
                if (university.getUniSubStatus() != null) {
                    item.setCurrentSubStatus(university.getUniSubStatus());
                }
            } else {
                item.setCurrentStatus(false);
            }
            if (status == UniStatus.REGISTER_PAGE_ERROR || status == UniStatus.SUBSCRIBE_PAGE_ERROR) {
                item.setHasSubStatus(true);
            } else {
                item.setHasSubStatus(false);
            }
            myResponse.add(item);
        }

        String json = new Gson().toJson(myResponse);
        response.setContentType("application/json");
        out.print(json);
        out.flush();

    } else if (request.getMethod().equals("POST")) {

        long id = Long.valueOf(request.getParameter("id"));
        University university = UniversityDAO.findUniByUniNationalId(id);

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

        UniStatusItem newStat = new Gson().fromJson(sb.toString(), UniStatusItem.class);

        university.setUniStatus(newStat.getValue());
        if (newStat.isHasSubStatus()) {
            UniSubStatus subStatus = UniSubStatus.fromValue(newStat.getCurrentSubStatus());
            university.setUniSubStatus(subStatus.getValue());
        }

        UniversityDAO.save(university);

        String json = new Gson().toJson("OK");
        response.setContentType("application/json");
        out.print(json);
        out.flush();
    }

%>
