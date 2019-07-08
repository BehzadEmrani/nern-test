<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.PreUniversityDataDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.PreUniversityData" %>
<%@ page import="com.atrosys.model.*" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.PRE_UNI_DATA.getValue())) {
        response.sendError(403);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;

    if ("send-pre-data".equals(request.getParameter("action"))) {
        if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.PRE_UNI_DATA.getValue(), AdminSubAccessType.ADD.getValue())) {
            response.sendError(403);
            return;
        }
        long internalCode = Long.valueOf(request.getParameter("internal-code"));
        PreUniversityData preUniversityData = PreUniversityDataDAO.findPreUniversityDataByInternalUniCodeAndNational(
                internalCode, Integer.valueOf(request.getParameter("source")));
        if (preUniversityData == null) {
            preUniversityData = new PreUniversityData();
            preUniversityData.setUniInternalCode(internalCode);
            preUniversityData.setUniSourceType(Integer.valueOf(request.getParameter("source")));
        }
        preUniversityData.setName(request.getParameter("name"));
        preUniversityData.setAddress(request.getParameter("address"));
        PreUniversityDataDAO.save(preUniversityData);
    }
    List<PreUniversityData> preUniversityDataList = PreUniversityDataDAO.findAllPreUniversityDatas();

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
    </style>
</head>
<body>
<% if (AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.PRE_UNI_DATA.getValue(), AdminSubAccessType.ADD.getValue())) { %>
<form id="send-pre-data" method="post" action="add-uni-pre-data.jsp"onsubmit=" return validateForm('#send-pre-data');">
    <input type="hidden" name="action" value="send-pre-data">
    <div class="formBox">
        <h3>اضافه کردن اطلاعات دانشگاه های پیش فرض</h3>
        <div class="formRow">
            <select class="formSelect" id="select-source"
                    name="source"
                    style="width: 200px;margin-left: 20px">
                <option value="" disabled selected hidden>نوع مرکز خود را انتخاب کنید&nbsp;...</option>
                <%
                    for (PreDataType preDataType : PreDataType.values()) {
                        if (!preDataType.equals(PreDataType.FROM_ILENC)) {
                %>
                <option value="<%=preDataType.getValue()%>">
                    <%=preDataType.getFaStr()%>
                </option>
                <%
                        }
                    }
                %>
            </select>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>کد دانشگاه :</label>
                <input class="formInput numberInput" name="internal-code"
                       maxlength="5" minlength="1"
                       style="width: 100px;margin-left: 20px;"
                       type="text">
            </div>
            <div class="formItem">
                <label>نام دانشگاه :</label>
                <input class="formInput persianInput" name="name"
                       maxlength="40"
                       style="width: 200px;margin-left: 20px;"
                       type="text">
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>آدرس :</label>
                <input class="formInput" name="address"
                       maxlength="200"
                       style="width: 400px;margin-left: 20px;"
                       type="text">
            </div>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
    </div>
</form>
<%}%>
<% if (AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.PRE_UNI_DATA.getValue(), AdminSubAccessType.READ.getValue())) { %>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>کد واحد</th>
            <th>نوع دانشگاه</th>
            <th>نام واحد</th>
            <th>آدرس</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < preUniversityDataList.size(); i++) {
                PreUniversityData tablePreUniversityData = preUniversityDataList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=tablePreUniversityData.getUniInternalCode()%>
            </td>
            <td>
                <%=PreDataType.fromValue(tablePreUniversityData.getUniSourceType()).getFaStr()%>
            </td>
            <td>
                <%=tablePreUniversityData.getName()%>
            </td>
            <td>
                <%=tablePreUniversityData.getAddress()%>
            </td>
        </tr>
        <% }%>
        </tbody>
    </table>
    <%} %>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>