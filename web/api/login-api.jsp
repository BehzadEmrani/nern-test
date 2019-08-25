<%@ page import="com.atrosys.entity.PersonalInfo"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.atrosys.model.UserRoleType"%>
<%@ page import="com.atrosys.dao.PersonalInfoDAO "%>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("user");
    String password = request.getParameter("pass");
    UserRoleType userRoleType = UserRoleType.fromValue(1000);


    try {
        PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByUserNameAndPassword(username,password,userRoleType);
        if (personalInfo == null) {
            response.sendError(404,"نام کاربری یا رمز عبور اشتباه است");
        } else {
            response.setStatus(HttpServletResponse.SC_OK,"ورود با موفقیت انجام شد");
            String json = new Gson().toJson(personalInfo);
            response.setContentType("application/json");
            out.print(json);
            out.flush();
        }
    } catch (Exception e) {
        response.sendError(500,"خطای نامشخص");
    }



%>
