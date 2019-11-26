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


    String redirectUrl = "http://185.79.99.245/new-crm/landing-page?";
    redirectUrl = redirectUrl + "id=" + personalInfo.getNationalId();
    redirectUrl = redirectUrl + "&fname=" + personalInfo.getFname();
    redirectUrl = redirectUrl + "&lname=" + personalInfo.getLname();
    redirectUrl = redirectUrl + "&type=" + "Customer";
    redirectUrl = redirectUrl + "&email=" + agent.getSupportEmail();
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

    <script>
        window.parent.parent.location.href = "<%=redirectUrl%>"
    </script>

</head>
<body>


</body>
</html>