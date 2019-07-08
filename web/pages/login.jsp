<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.UserRoleDAO" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.UserRole" %>
<%@ page import="com.atrosys.model.Constants" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="com.atrosys.util.UserRoleUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    String message = null;
    boolean reloadParent = false;
    boolean logOut = false;
    boolean userRolesUpdated = false;
    UserRoleType userRoleType = UserRoleType.fromValue(Integer.valueOf(request.getParameter("role")));
    Long userNationalId = (Long) session.getAttribute(Constants.SESSION_USER_NATIONAL_ID);
    if (userNationalId != null)
        reloadParent = true;
    try {
        String actionParam = request.getParameter("action");
        if (actionParam != null)
            switch (actionParam) {
                case "login":
                    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByUserNameAndPassword
                            (request.getParameter("username"), request.getParameter("password"), userRoleType);
                    if (personalInfo == null) {
                        message = "نام کاربری یا رمز عبور اشتباه است.";
                    } else {
                        session.setAttribute(Constants.SESSION_USER_NATIONAL_ID, personalInfo.getNationalId());
                        UserRoleUtil.updateUserRolesFromDb(session, personalInfo.getNationalId());
                        userRolesUpdated = true;
                        reloadParent = true;
                    }
                    break;
                case "logout":
                    session.removeAttribute(Constants.SESSION_USER_NATIONAL_ID);
                    session.removeAttribute(Constants.SESSION_USER_ROLES);
                    reloadParent = true;
                    logOut = true;
                    break;
            }
    } catch (Exception e) {
        message = "خطای نامشخص!";
    }
    if (reloadParent) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script>
        <%
        String redirectUrl;
        if(request.getParameter("redirect")!=null&&!"null".equals(request.getParameter("redirect"))){
            redirectUrl=request.getParameter("redirect");
        } else{
            redirectUrl="../"+userRoleType.getRedirectPage();
            if(userRolesUpdated){
                HashMap<String, Long> userRoleList = (HashMap<String, Long>) session.getAttribute(Constants.SESSION_USER_ROLES);
                if(userRoleList.size()==1){
                    Long singleUserRoleId=userRoleList.get(userRoleList.keySet().toArray()[0]);
                    UserRole singleUserRole=UserRoleDAO.findUserRoleById(singleUserRoleId);
                    redirectUrl="../"+UserRoleType.fromValue(singleUserRole.getUserRoleVal()).getRedirectPage();
                }
            }
        }
        %>
        window.parent.parent.location.href = "<%=redirectUrl%>"

    </script>
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
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
<form action="../pages/login.jsp?role=<%=userRoleType.getValue()%>" method="post">
    <input type="hidden" name="redirect" value=<%=request.getParameter("redirect")%>>
    <div class="formBox">
        <div class="row">
            <h4 style="color: #c00;"><%=message == null ? "" : message%>
            </h4>
            <input type="hidden" name="action" value="login">
            <div class="formItem">
                <label>نام کاربری:</label>
                <input class="formInput" name="username" style="width: 250px;" maxlength="30" type="text">
            </div>
            <div class="formItem">
                <label>رمز عبور:</label>
                <input class="formInput" name="password" style="width: 100px;" maxlength="30" type="password">
            </div>
            <div class="formItem">
                <button class="btn btn-primary formBtn" style="margin-right: 10px">ورود</button>
            </div>
            <%if (userRoleType.equals(UserRoleType.JOB_SEEKER)) {%>
            <a href=<%="/co-operate/signup.jsp?redirect=" + request.getParameter("redirect")%> target="iframe"
               style="margin-top: 10px;margin-bottom: 5px;display: block;">ثبت نام ننموده ام ...</a>
            <%}%>
            <a href="#" onclick="return false" target="iframe" class="formGetLink"
               style="margin-top: 10px;margin-bottom: 5px;display: block;">کلمه عبور خود را فراموش نموده ام ...</a>
            <a href="#" onclick="return false" class="formGetLink">نام کاربري و کلمه عبور خود را فراموش نموده ام
                ...</a>
        </div>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>