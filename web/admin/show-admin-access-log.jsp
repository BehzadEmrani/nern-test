<%@ page import="com.atrosys.dao.AdminAccessLogDAO" %>
<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.UserRoleDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.AdminAccessLog" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.UserRole" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.ADMINS_REPORT.getValue(), AdminSubAccessType.READ.getValue())) {
        response.sendError(403);
        return;
    }
    Admin reportingAdmin = AdminDAO.findAdminByid(Long.valueOf(request.getParameter("id")));
    UserRole reportingAdminUserRole = UserRoleDAO.findUserRoleById(reportingAdmin.getRoleId());
    PersonalInfo reportingAdminPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(reportingAdminUserRole.getNationalId());
    List<AdminAccessLog> adminAccessLogs = AdminAccessLogDAO.findAdminAccessLogByAdminId(reportingAdmin.getId());
    String message = null;

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
    <style>
        .logItem {
            border: 1px solid #41709c;
            margin: 10px;
            padding: 10px;
        }

        pre {
            font-family: BYekan;
            white-space: pre-wrap; /* Since CSS 2.1 */
            white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
            white-space: -o-pre-wrap; /* Opera 7 */
            word-wrap: break-word; /* Internet Explorer 5.5+ */
        }
    </style>
</head>
<body>
<div class="formBox">
    <h3>گزارش های "<%=reportingAdminPersonalInfo.combineName()%>"</h3>
    <%
        for (int i = 0; i < adminAccessLogs.size(); i++) {
            AdminAccessLog adminAccessLog = adminAccessLogs.get(i);
    %>
    <div class="logItem">
        <p> زمان :
            <%=Util.convertTimeStampToJalali(adminAccessLog.getTimeStamp())%>
        </p>
        <p>نوع علمیات :
            "<%=AdminAccessLogType.fromValue(adminAccessLog.getAdminAccessLogTypeVal()).getFaStr()%>"
        </p>
        <p>
            متن گزارش :
        </p>
        <pre><%=adminAccessLog.getMessage()%></pre>
    </div>
    <% }%>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>