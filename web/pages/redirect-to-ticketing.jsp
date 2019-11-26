<%@ page import="com.atrosys.dao.AgentDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.entity.Agent" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    UserRoleType userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, userRoleType);
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        response.sendError(401);
        return;
    }
    University university = uniSessionInfo.getUniversity();
    Agent agent = AgentDAO.findUniPrimaryAgentByUniId(university.getUniNationalId());
    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(agent.getNationalId());


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