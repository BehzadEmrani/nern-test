<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("../pages/login.jsp?role="+ UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }else if(!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("no-access.jsp").forward(request, response);
        return;
    }
    if (personalInfo.getNeedChangePass()) {
        request.getRequestDispatcher("change-admin-pass.jsp?action=change-pass").forward(request, response);
        return;
    }
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
<div class="formBox">
    <h3>
        به بخش مدیریت سایت خوش آمدید
        <br>
    </h3>
    <p>
        از منوی سمت راست بخش مورد نظر خود را برای تغییر انتخاب کنید
    </p>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>