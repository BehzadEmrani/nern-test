<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.FeedBackDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.FeedBack" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.List" %>
<%@ page import="com.atrosys.dao.AgentDAO" %>
<%@ page import="com.atrosys.entity.Agent" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.TECH_REDIRECT_TICKETING.getValue())) {
        response.sendError(403);
        return;
    }

    long agentId = Long.valueOf("61826596");

    Agent agent = AgentDAO.findAgentByNationalId(agentId);
    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(agentId);


    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
</head>
<body>
<script>
    sessionStorage.setItem("PersonNational_ID","<%=personalInfo.getNationalId()%>");
    sessionStorage.setItem("FirstName","<%=personalInfo.getFname()%>");
    sessionStorage.setItem("LastName","<%=personalInfo.getLname()%>");
    sessionStorage.setItem("UserType","Customer");
    sessionStorage.setItem("Email","<%=agent.getSupportEmail()%>");
    window.parent.parent.location.href = "http://localhost:4200/landing-page";
</script>

</body>
</html>