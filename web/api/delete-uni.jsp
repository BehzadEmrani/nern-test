<%@ page import="com.atrosys.dao.PersonalInfoDAO"%>
<%@ page import="com.atrosys.dao.UniversityDAO"%>
<%@ page import="com.atrosys.entity.PersonalInfo"%>
<%@ page import="com.atrosys.entity.University"%>
<%@ page import="com.atrosys.model.UserRoleType"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");

    long id = Long.parseLong(request.getParameter("id"));
    try{
        University university = UniversityDAO.findUniByUniNationalId(id);
        PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByUserNameAndPassword(String.valueOf(id),String.valueOf(id),UserRoleType.UNIVERSITY);
        assert university != null;
        university.setActive(false);
        personalInfo.setActive(false);
        UniversityDAO.save(university);
        PersonalInfoDAO.save(personalInfo);

        String json = new Gson().toJson("OK");
        response.setContentType("application/json");
        out.print(json);
        out.flush();
    } catch (Exception e) {
        response.sendError(500,e.getMessage());
    }

%>
