<%@ page import="com.atrosys.dao.*"%>
<%@ page import="com.atrosys.entity.Agent"%>
<%@ page import="com.atrosys.entity.PersonalInfo"%>
<%@ page import="com.atrosys.entity.University"%>
<%@ page import="com.atrosys.entity.UserRole"%>
<%@ page import="com.atrosys.model.LoginInfoResponse"%>
<%@ page import="com.atrosys.model.UserRoleType"%><%@ page import="com.google.gson.Gson"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    if (request.getMethod().equals("OPTIONS")){
        out.flush();
    } else {
    request.setCharacterEncoding("UTF-8");

    long id = Long.valueOf(request.getParameter("id"));
    LoginInfoResponse infoResponse = new LoginInfoResponse();

        UserRole userRole = UserRoleDAO.findUserRolesByNationalId(id).get(0);
        UserRoleType userRoleType = UserRoleType.fromValue(userRole.getUserRoleVal());

        assert userRoleType != null;
        if (userRoleType.getValue() < 2000) {

            Agent agent = AgentDAO.findAgentByNationalId(id);
            PersonalInfo agentPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(agent.getNationalId());
            University university = UniversityDAO.findUniByUniNationalId(agent.getUniNationalId());

            infoResponse.setAdmin(false);
            infoResponse.setUniNationalId(id);
            infoResponse.setUniState(StateDAO.findStateNameById(university.getStateId()));
            infoResponse.setUniCity(CityDAO.findCityNameById(university.getCityId()));
            infoResponse.setUniName(university.getUniName());
            infoResponse.setAgentName(agentPersonalInfo.combineName());
            infoResponse.setAgentMobile(agent.getMobileNo());
            infoResponse.setAgentTell(agent.getTelNo());

        } else {
            PersonalInfo adminPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(id);

            infoResponse.setAdmin(true);
            infoResponse.setAdminNationalId(id);
            infoResponse.setAdminUsername(adminPersonalInfo.getUsername());
            infoResponse.setAdminName(adminPersonalInfo.combineName());
        }



    String json = new Gson().toJson(infoResponse);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
}
%>
