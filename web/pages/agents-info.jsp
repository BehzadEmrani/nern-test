<%@ page import="com.atrosys.dao.AgentDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.SubsBuildingDAO" %>
<%@ page import="com.atrosys.entity.Agent" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.SubsBuilding" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UniStatus" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
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
    UniStatus uniStatus = UniStatus.fromValue(university.getUniStatus());
    if (uniStatus.getValue() < UniStatus.SUBSCRIBE_PAGE.getValue()) {
        response.sendError(403);
        return;
    }
    List<SubsBuilding> buildingList = SubsBuildingDAO.findSubsBuildingsByUniId(university.getUniNationalId());
    Agent primaryAgent = AgentDAO.findUniPrimaryAgentByUniId(university.getUniNationalId());
    PersonalInfo primaryPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(primaryAgent.getNationalId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        .infoBox span {
            margin-right: 20px;
        }
    </style>
</head>
<body>
<div class="formBox infoBox">
    <h3>مشخصات بالاترین مقام</h3>
    <span> نام و نام خانوادگی:<%=university.getTopManagerName()%></span>
    <span> سمت:<%=university.getTopManagerPos()%></span>
</div>
<div class="formBox infoBox">
    <h3>مشخصات مقام مجاز امضا</h3>
    <span> نام و نام خانوادگی:<%=university.getSignatoryName()%></span>
    <span> سمت:<%=university.getSignatoryPos()%></span>
    <span> کد ملی:<%=university.getSignatoryNationalId()%></span>
</div>
<div class="formBox infoBox">
    <h3>مشخصات نماینده تام الاختیار</h3>
    <span> نام:<%=primaryPersonalInfo.getFname()%></span>
    <span> نام خانوادگی:<%=primaryPersonalInfo.getLname()%></span>
    <span> کد ملی:<%=primaryPersonalInfo.getNationalId()%></span>
    <span> سمت:<%=primaryAgent.getAgentPos()%></span>
    <br>
    <span> شماره ثابت:<%=primaryAgent.getTelNo()%></span>
    <span> موبایل:<%=primaryAgent.getMobileNo()%></span>
    <span> دورنگار:<%=primaryAgent.getFaxNo()%></span>
    <span>                                فرم معرفی نماینده:
    <a href="../documents/primary-agent-intro-cert.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
    </span>
</div>
<%
    for (int i = 0; i < buildingList.size(); i++) {
        SubsBuilding tableBuilding = buildingList.get(i);
        Agent tableAgent = AgentDAO.findAgentById(tableBuilding.getAgentId());
        PersonalInfo tablePersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(tableAgent.getNationalId());
%>
<div class="formBox infoBox">
    <h3>مشخصات نماینده ساختمان "<%=tableBuilding.getBuildingName()%>"</h3>
    <span> نام:<%=tablePersonalInfo.getFname()%></span>
    <span> نام خانوادگی:<%=tablePersonalInfo.getLname()%></span>
    <span> کد ملی:<%=tablePersonalInfo.getNationalId()%></span>
    <span> سمت:<%=tableAgent.getAgentPos()%></span>
    <br>
    <span> شماره ثابت:<%=tableAgent.getTelNo()%></span>
    <span> موبایل:<%=tableAgent.getMobileNo()%></span>
    <span> دورنگار:<%=tableAgent.getFaxNo()%></span>
</div>
<% } %>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>