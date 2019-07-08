<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.StateDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.State" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role="+ UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.STATES.getValue())) {
        response.sendError(403);
        return;
    } else if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.STATES.getValue(), AdminSubAccessType.ADD.getValue())) {
        response.sendError(403);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;
    try {
        if ("send-state".equals(request.getParameter("action"))) {
            State state = new State();
            state.setCountryId(Long.valueOf(98));
            state.setName(request.getParameter("name"));
            state.setPhoneCode(Integer.valueOf(request.getParameter("pish-tel")));
            StateDAO.save(state);
        }
    } catch (Exception e) {
        if (e.getMessage().equals("no-name"))
            message = "نام خالی است.";
        else if (e.getMessage().equals("repeated-name"))
            message = "نام تکراری است.";
        else if (e.getMessage().equals("repeated-code"))
            message = "کد تکراری است.";
    }
    List<State> states = StateDAO.findAllStates();
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
        .stateTable, .stateTable tbody {
            max-width: 400px !important;
        }
    </style>
</head>
<body>
<form id="send-form" onsubmit="return validateForm('#send-form')" method="post" action="add-state.jsp">
    <input type="hidden" name="action" value="send-state">
    <div class="formBox">
        <h3>اضافه کردن به استان ها</h3>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>نام :</label>
                <input class="formInput persianInput" name="name"
                       maxlength="20"
                       style="width: 200px;margin-left: 20px;"
                       type="text">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>پیش شماره تلفن :</label>
                <input class="formInput numberInput" name="pish-tel" maxlength="2" type="text"
                       style="width: 100px;margin-left: 20px;">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <input type="submit" value="تایید" class="btn btn-primary formBtn">
            </div>
        </div>
    </div>
</form>
<div class="formBox">
    <table class="fixed-table table table-striped stateTable">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام</th>
            <th>پیش شماره</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int j = 0; j < states.size(); j++) {
                State state = states.get(j);
        %>
        <tr>
            <td style="width:30px">
                <%=j + 1%>
            </td>
            <td>
                <%=state.getName()%>
            </td>
            <td>
                <%=state.getPhoneCode()%>
            </td>
        </tr>
        <% }%>
        </tbody>
    </table>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>