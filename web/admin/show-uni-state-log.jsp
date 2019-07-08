<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
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
    if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.UNIVERSITY.getValue(), AdminSubAccessType.READ.getValue())) {
        response.sendError(403);
        return;
    }
    List<UniStatusLog> uniStatusLogs = UniStatusLogDAO.findUniStatusLogByUniNationalId(Long.valueOf(request.getParameter("id")));
    University university = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
    request.setCharacterEncoding("UTF-8");
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
            white-space: pre-wrap; /* Since CSS 2.1 */
            white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
            white-space: -o-pre-wrap; /* Opera 7 */
            word-wrap: break-word; /* Internet Explorer 5.5+ */
        }
    </style>
</head>
<body>
<form id="send-change" method="post" action="change-uni-state.jsp">
    <div class="formBox">
        <h3>گزارش های "<%=university.getUniName()%>"</h3>
        <%
            for (int i = 0; i < uniStatusLogs.size(); i++) {
                UniStatusLog uniStatusLog = uniStatusLogs.get(i);
        %>
        <div class="logItem">
            <p>تاریخ :
                <%Date date = new Date(uniStatusLog.getTimeStamp().getTime());%>
                <%=new SimpleDateFormat("kk:mm:ss").format(date) %>
                <%=Util.convertGregorianToJalali(date)%>
            </p>
            <%if (uniStatusLog.getUniStatus() != null) {%>
            <p>تغییر وضعیت به :
                <%=UniStatus.fromValue(uniStatusLog.getUniStatus()).getFaStr()%>
            </p>
            <% }%>
            <%if (uniStatusLog.getUniSubStatus() != null) { %>
            <p>تغییر زیر وضعیت به :
                <%=UniSubStatus.fromValue(uniStatusLog.getUniSubStatus()).getFaStr()%>
            </p>
            <%}%>
            <p>شناسه ملی :
                <%=uniStatusLog.getUniNationalId()%>
            </p>
            <p>توسط :
                <%
                    String operator;
                    if (uniStatusLog.getApprovalId() != null) {
                        University operatorUni = UniversityDAO.findUniByUniNationalId(uniStatusLog.getApprovalId());
                        operator = operatorUni.getUniName() + " (" + operatorUni.getUniNationalId() + ")";
                    } else if (uniStatusLog.getApprovalAdminId() != null) {
                        Admin operatorAdmin = AdminDAO.findAdminByid(uniStatusLog.getApprovalAdminId());
                        UserRole operatorUserRole = UserRoleDAO.findUserRoleById(operatorAdmin.getRoleId());
                        PersonalInfo operatorPersonal = PersonalInfoDAO.findPersonalInfoByNationalId(operatorUserRole.getNationalId());
                        operator = operatorPersonal.combineName() + " (" + operatorPersonal.getUsername() + ")";
                    } else
                        operator = "نامشخص";
                %>
                <%=operator%>
            </p>
            <p>
                پیام :
            </p>
            <pre><%=uniStatusLog.getMessage()%></pre>
        </div>
        <% }%>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>