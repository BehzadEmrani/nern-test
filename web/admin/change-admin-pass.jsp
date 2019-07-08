<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    String message = null;
    boolean reload = false;
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if ("send-change".equals(request.getParameter("action"))) {
        personalInfo.hashAndSetPassword(request.getParameter("password"));
        personalInfo.setNeedChangePass(false);
        personalInfo = PersonalInfoDAO.save(personalInfo);
        reload = true;
    }
    if (reload) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script>
        window.parent.parent.location.href = "<%="index.jsp"%>"
    </script>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
</head>
</html>
<%
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
<form id="send-form" onsubmit="return validateForm('#send-form');" method="post" action="change-admin-pass.jsp">
    <input type="hidden" name="action" value="send-change">
    <div class="formBox">
        <h3>تغییر رمز عبور</h3>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>نام :</label>
                <input class="formInput formInputDeactive" name="name"
                       value="<%=personalInfo.combineName()%>"
                       maxlength="20"
                       style="width: 200px;margin-left: 20px;"
                       type="text" disabled>
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>نام کاربری :</label>
                <input class="formInput formInputDeactive" name="username"
                       maxlength="30" value="<%=personalInfo.getUsername()%>"
                       style="width: 200px;margin-left: 20px;"
                       type="text" disabled>
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>رمز عبور:</label>
                <input class="formInput" id="password" name="password"
                       maxlength="30"
                       style="width:200px;margin-left: 20px;"
                       type="password">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>تکرار رمز عبور:</label>
                <input class="formInput" name="re-password"
                       maxlength="30" id="re-password"
                       style="width:200px;margin-left: 20px;"
                       type="password">
            </div>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>