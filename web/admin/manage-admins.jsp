<%@ page import="com.atrosys.dao.AdminAccessDAO" %>
<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.UserRoleDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.AdminAccess" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.UserRole" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    String message = null;

    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.ADMINS_REGISTER.getValue())) {
        response.sendError(403);
        return;
    }
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean editSubAccess = false;

    try {

        addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMINS_REGISTER.getValue(),
                AdminSubAccessType.ADD.getValue());
        readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMINS_REGISTER.getValue(),
                AdminSubAccessType.READ.getValue());
        editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMINS_REGISTER.getValue(),
                AdminSubAccessType.EDIT.getValue());
    } catch (Exception e) {

    }
    boolean isEdit = "edit".equals(request.getParameter("action")) && editSubAccess;
    boolean isSendEdit = "edit-admin".equals(request.getParameter("action"));
    boolean isSendNewAdmin = "send-admin".equals(request.getParameter("action"));
    if (isSendNewAdmin && !addSubAccess) {
        response.sendError(403);
        return;
    }
    if ((isSendEdit || isEdit) && !editSubAccess) {
        response.sendError(403);
        return;
    }

    Admin targetAdmin = null;
    UserRole targetUserRole = null;
    PersonalInfo targetPersonalInfo = null;
    if (isEdit || isSendEdit || isSendNewAdmin) {
        targetPersonalInfo =
                PersonalInfoDAO.findPersonalInfoByNationalId(Long.valueOf(request.getParameter("national-id")));
    }
    if (isEdit || isSendEdit) {
        targetUserRole = UserRoleDAO.findUserRolesByNationalIdAndType(
                targetPersonalInfo.getNationalId(), UserRoleType.ADMINS.getValue()).get(0);
        targetAdmin = AdminDAO.findAdminByRoleId(targetUserRole.getRoleId());
    }

    try {
        if (isSendNewAdmin || isSendEdit) {
            if (isSendNewAdmin)
                if (!AdminDAO.isAdminNewByNationalId(targetPersonalInfo.getNationalId()))
                    throw new Exception("repeated-admin");
            if (isSendNewAdmin) {
                targetUserRole = new UserRole();
                targetUserRole.setUserRoleVal(UserRoleType.ADMINS.getValue());
                targetUserRole.setNationalId(targetPersonalInfo.getNationalId());
                targetUserRole.setValidity(Validity.ACTIVE.getValue());
                targetUserRole = UserRoleDAO.save(targetUserRole);

                targetAdmin = new Admin();
                targetAdmin.setRoleId(targetUserRole.getRoleId());
                targetAdmin = AdminDAO.save(targetAdmin);
            }
            AdminDAO.deleteAllAdminAccess(targetAdmin.getId());
            for (AdminAccessType adminAccessType : AdminAccessType.values())
                for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values())
                    if ("on".equals(request.getParameter(adminAccessType.getValue() + "-" + adminSubAccessType.getValue()))) {
                        AdminAccess newAdminAccess = new AdminAccess();
                        newAdminAccess.setAccessVal(adminAccessType.getValue());
                        newAdminAccess.setSubAccessVal(adminSubAccessType.getValue());
                        newAdminAccess.setAdminId(targetAdmin.getId());
                        AdminAccessDAO.save(newAdminAccess);
                    }
        }
    } catch (Exception e) {
        if (e.getMessage().equals("repeated-username"))
            message = "نام کاربری تکراری است.";
        else if (e.getMessage().equals("no-username"))
            message = "نام کاربری خالی است.";
        else if (e.getMessage().equals("no-password"))
            message = "کلمه عبور خالی است.";
        else if (e.getMessage().equals("repeated-admin"))
            message = "مدیر با این شماره ملی قبلا ثبت شده است.";
    }
    List<UserRole> adminsUserRoleList = UserRoleDAO.findUserRolesByUserRoleType(UserRoleType.ADMINS.getValue());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href=../css/bootstrap.min.css">
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

        .accessTable, .accessTable tbody {
            max-width: 700px !important;
        }

        .personListTable, .personListTable tbody {
            max-width: 600px !important;
        }
    </style>
</head>
<body>
<%if (addSubAccess || isEdit) {%>
<form id="send-form" onsubmit="return validateForm('#send-form');" method="post" action="manage-admins.jsp">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-admin">
    <input type="hidden" name="national-id" value="<%=targetPersonalInfo.getNationalId()%>">
    <%} else if (addSubAccess) {%>
    <input type="hidden" name="action" value="send-admin">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات "<%=targetPersonalInfo.combineName()%>"</h3>
        <%} else {%>
        <h3>افزودن مدیر جدید</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>شماره ملی :</label>
                <input class="formInput<%=isEdit?" formInputDeactive":" numberInput"%>" name="national-id"
                       value="<%=isEdit?targetPersonalInfo.getNationalId():""%>"
                       maxlength="10"
                       style="width: 150px;margin-left: 20px;" type="text"<%=isEdit?"disabled":""%>>
            </div>
        </div>
        <table class="fixed-table table table-striped accessTable">
            <thead>
            <tr style="background: #337ab7;color: white;">
                <th style="width:30px">ردیف</th>
                <th>نام بخش</th>
                <% for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values()) { %>
                <th>
                    <%=adminSubAccessType.getFaStr()%>
                </th>
                <%}%>
            </tr>
            </thead>
            <tbody>
            <%
                for (int j = 0; j < AdminAccessType.values().length; j++) {
                    AdminAccessType adminAccessType = AdminAccessType.values()[j];
            %>
            <tr>
                <td style="width:30px"><%=j + 1%>
                </td>
                <td><%=adminAccessType.getFaStr()%>
                </td>
                <% for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values()) { %>
                <td>
                    <input type="checkbox" name="<%=adminAccessType.getValue()%>-<%=adminSubAccessType.getValue()%>"
                           style="margin: auto"<%=isEdit?(AdminDAO.checkAdminSubAccess(targetAdmin.getId(),adminAccessType.getValue(),adminSubAccessType.getValue())?"checked":""):""%>>
                </td>
                <% } %>
            </tr>
            <% }%>
            </tbody>
        </table>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-admins.jsp" class="btn btn-primary formBtn" style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
</form>
<%}%>
<%if (readSubAccess) {%>
<div class="formBox" style="text-align: center;margin-bottom:10px ">
    <h4 style="text-align: center">
        فهرست مدیران سایت
    </h4>
    <table class="fixed-table table table-striped adminListTable" style="display: inline-block;;">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th width="30px">ردیف</th>
            <th>نام</th>
            <th>نام کاربری</th>
            <th style="width:200px;">عملیات ها</th>
        </tr>
        <thead>
        <tbody>
        <%
            for (int i = 0; i < adminsUserRoleList.size(); i++) {
                UserRole tableUserRole = adminsUserRoleList.get(i);
                PersonalInfo tablePersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(tableUserRole.getNationalId());
                Admin tableAdmin = AdminDAO.findAdminByRoleId(tableUserRole.getRoleId());
        %>
        <tr>
            <td width="30px">
                <%=i + 1%>
            </td>
            <td>
                <%=tablePersonalInfo.combineName()%>
            </td>
            <td>
                <%=tablePersonalInfo.getUsername()%>
            </td>
            <td class="operatorBox" style="width:200px;">
                <a href="#" data-toggle="modal"
                   data-target="#accessModal<%=i%>">
                    <img src="../images/access.png">
                </a>
                <a href="#" onclick="return false">
                    <img src="../images/delete.png">
                </a>
                <a href="manage-admins.jsp?action=edit&national-id=<%=tablePersonalInfo.getNationalId()%>" <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess?"-dis":""%>.png">
                </a>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
    <%
        for (int i = 0; i < adminsUserRoleList.size(); i++) {
            UserRole userRole = adminsUserRoleList.get(i);
            PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(userRole.getNationalId());
            Admin tableAdmin = AdminDAO.findAdminByRoleId(userRole.getRoleId());
    %>
    <!-- Modal -->
    <div class="modal fade" id="accessModal<%=i%>" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-body" style="text-align: center">
                    <h4 style="text-align: center">
                        دسترسی ها
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
                            <td width="30px"><%=j + 1%>
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
                                <input type="checkbox" style="margin: auto" <%=isSelected?"checked":""%> disabled>
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
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>

</body>
</html>