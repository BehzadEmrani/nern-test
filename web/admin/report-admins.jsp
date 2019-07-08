<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.UserRoleDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.AdminAccess" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.UserRole" %>
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
    PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.ADMINS_REPORT.getValue())) {
        response.sendError(403);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;
    List<UserRole> adminsUserRoleList = UserRoleDAO.findUserRolesByUserRoleType(UserRoleType.ADMINS.getValue());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        @media screen and (max-width: 1060px) {
            .formTable th {
                min-width: inherit !important;
            }
        }

        .reportTable, .reportTable tbody {
            max-width: 600px !important;
        }

    </style>
</head>
<body>
<div class="formBox">
    <h4>
        گزارش کارکرد
    </h4>
    <table class="fixed-table table table-striped reportTable">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th width="30px">ردیف</th>
            <th>نام</th>
            <th>نام کاربری</th>
            <th style="width:150px;">دسترسی ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < adminsUserRoleList.size(); i++) {
                UserRole tableUserRole = adminsUserRoleList.get(i);
                PersonalInfo tablePersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(tableUserRole.getNationalId());
                Admin tableAdmin = AdminDAO.findAdminByRoleId(tableUserRole.getRoleId());
        %>
        <tr>
            <td>
                <%=i + 1%>
            </td>
            <td>
                <%=tablePersonalInfo.combineName()%>
            </td>
            <td>
                <%=tablePersonalInfo.getUsername()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#accessModal<%=i%>" style="margin: auto">
                    <img src="../images/access.png" style="width: 30px">
                </a>
                <a href="#" data-toggle="modal" data-target="#logModal<%=tableAdmin.getId()%>" style="margin: auto">
                    <img src="../images/log.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade" id="logModal<%=tableAdmin.getId()%>" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <iframe src="show-admin-access-log.jsp?id=<%=tableAdmin.getId()%>"
                                style="width: 100%;height: 90vh;"></iframe>
                    </div>
                </div>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
    <%
        for (int i = 0; i < adminsUserRoleList.size(); i++) {
            UserRole tableUserRole = adminsUserRoleList.get(i);
            PersonalInfo tablePersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(tableUserRole.getNationalId());
            Admin tableAdmin = AdminDAO.findAdminByRoleId(tableUserRole.getRoleId());
    %>
    <!-- Modal -->
    <div class="modal fade" id="accessModal<%=i%>" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-body" style="text-align: center">
                    <h4 style="text-align: center">
                        دسترسی های ‌<%=tablePersonalInfo.combineName()%>
                    </h4>
                    <table class="table table-striped" style="border: 1px solid #41709c;">
                        <tr style="background: #337ab7;color: white;">
                            <th width="30px">ردیف</th>
                            <th>نام بخش</th>
                            <% for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values()) { %>
                            <th><%=adminSubAccessType.getFaStr()%>
                            </th>
                            <%}%>
                        </tr>
                        <%
                            List<AdminAccess> adminAccesses = AdminDAO.findAllAdminAccess(tableAdmin.getId());
                            for (int j = 0; j < AdminAccessType.values().length; j++) {
                                AdminAccessType adminAccessType = AdminAccessType.values()[j];
                        %>
                        <tr>
                            <td width="30px"><%=j%>
                            </td>
                            <td><%=adminAccessType.getFaStr()%>
                            </td>
                            <% for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values()) { %>
                            <td>
                                <%
                                    boolean isSelected = false;
                                    for (AdminAccess adminAccess : adminAccesses)
                                        isSelected |= adminAccessType.getValue() == adminAccess.getAccessVal() &&
                                                adminSubAccessType.getValue() == adminAccess.getSubAccessVal();
                                %>
                                <input type="checkbox" style="margin: auto" <%=isSelected?"checked":""%>
                                       disabled>
                            </td>
                            <%}%>
                        </tr>
                        <% }%>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <%}%>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>

</body>
</html>