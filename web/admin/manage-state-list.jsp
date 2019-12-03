<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
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
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    String message = null;

    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.ADMIN_STATE_LIST_ROLES.getValue())) {
        response.sendError(403);
        return;
    }
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean editSubAccess = false;
    boolean deleteSubAccess = false;
    try {
        addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_STATE_LIST_ROLES.getValue(),
                AdminSubAccessType.ADD.getValue());
        readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_STATE_LIST_ROLES.getValue(),
                AdminSubAccessType.READ.getValue());
        editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_STATE_LIST_ROLES.getValue(),
                AdminSubAccessType.EDIT.getValue());
        deleteSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_STATE_LIST_ROLES.getValue(),
                AdminSubAccessType.DELETE.getValue());
    } catch (Exception e) {
    }
    boolean isEdit = "edit".equals(request.getParameter("action")) && editSubAccess;
    boolean isSendEdit = "edit-list-role".equals(request.getParameter("action"));
    boolean isSendNew = "send-list-role".equals(request.getParameter("action"));
    boolean isSendDelete = "delete".equals(request.getParameter("action"));
    if (isSendNew && !addSubAccess) {
        response.sendError(403);
        return;
    }
    if ((isSendEdit || isEdit) && !editSubAccess) {
        response.sendError(403);
        return;
    }
    if (isSendDelete && !deleteSubAccess) {
        response.sendError(403);
        return;
    }

    AdminStateListRole targetAdminStateListRole = null;
    Admin targetAdmin = null;
    UserRole targetUserRole = null;
    PersonalInfo targetPersonal = null;


    try {
        if (isEdit || isSendEdit || isSendNew || isSendDelete) {
            if (isSendNew) {
                targetAdmin = AdminDAO.findAdminByid(Long.valueOf(request.getParameter("admin-id")));
                targetAdminStateListRole = new AdminStateListRole();
            } else if (isEdit || isSendEdit || isSendDelete) {
                targetAdminStateListRole = AdminStateListRoleDAO.findAdminStateListRoleByid(Long.valueOf(request.getParameter("id")));
                targetAdmin = AdminDAO.findAdminByid(targetAdminStateListRole.getAdminId());
            }
            if (isSendEdit || isSendNew) {
                targetAdminStateListRole.setAdminId(targetAdmin.getId());
                targetAdminStateListRole.setStateId(Long.valueOf(request.getParameter("state")));
                targetAdminStateListRole = AdminStateListRoleDAO.save(targetAdminStateListRole);
            }
            targetUserRole = UserRoleDAO.findUserRoleById(targetAdmin.getRoleId());
            targetPersonal = PersonalInfoDAO.findPersonalInfoByNationalId(targetUserRole.getNationalId());
            if (isSendDelete)
                AdminStateListRoleDAO.delete(targetAdminStateListRole.getId());
        }
    } catch (Exception e) {
        if (e.getMessage().equals("repeated-list-role"))
            message = "این مشاهده کننده وجود دارد لطفا انرا ویرایش کنید";
        else
            message = "خطای غیر منتظره";
    }
    List<AdminStateListRole> stateListRoles = AdminStateListRoleDAO.findAllAdminStateListRoles();
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
    </style>
</head>
<body>
<%if (addSubAccess || isEdit) {%>
<form id="send-form" onsubmit="return validateForm('#send-form');" method="post" action="manage-state-list.jsp">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-list-role">
    <input type="hidden" name="id" value="<%=targetAdminStateListRole.getId()%>">
    <%} else if (addSubAccess) {%>
    <input type="hidden" name="action" value="send-list-role">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات "<%=targetPersonal.getUsername()%>"</h3>
        <%} else {%>
        <h3>افزودن مشاهده کننده جدید</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>مدیر :</label>
                <select class="formSelect <%=isEdit ? "formInputDeactive" : ""%>" name="admin-id"
                        style="width: 200px;margin-left: 20px"<%=isEdit ? "disabled" : ""%>>
                    <%
                        if (!isEdit)
                            for (Admin sAdmin : AdminDAO.findAllAdmins()) {
                                UserRole sUserRole = UserRoleDAO.findUserRoleById(sAdmin.getRoleId());
                                PersonalInfo sPersonal = PersonalInfoDAO.findPersonalInfoByNationalId(sUserRole.getNationalId());
                    %>
                    <option value="<%=sAdmin.getId()%>">
                        <%=sPersonal.getUsername()%>
                    </option>
                    <%}else{%>
                    <option >
                        <%=targetPersonal.getUsername()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>استان :</label>
                <select class="formSelect" name="state"
                        style="width: 200px;margin-left: 20px">
                    <% for (State state : StateDAO.findAllStates()) {%>
                    <option value="<%=state.getStateId()%>"<%=isEdit ? (targetAdminStateListRole.getStateId().equals(state.getStateId()) ? "selected" : "") : ""%>>
                        <%=state.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-list-roles.jsp" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
</form>
<%}%>
<%if (readSubAccess) {%>
<div class="formBox" style="text-align: center;margin-bottom:10px ">
    <h4 style="text-align: center">
        فهرست مشاهده کنندگان
    </h4>
    <table class="fixed-table table table-striped" style="display: inline-block;;">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th width="30px">ردیف</th>
            <th>شناسه کاربری</th>
            <th>استان</th>
            <th style="width:200px;">عملیات ها</th>
        </tr>
        <thead>
        <tbody>
        <%
            for (int i = 0; i < stateListRoles.size(); i++) {
                AdminStateListRole tableListRole = stateListRoles.get(i);
                Admin tableAdmin = AdminDAO.findAdminByid(tableListRole.getAdminId());
                State tableState = StateDAO.findStateById(tableListRole.getStateId());
                UserRole tableUserRole = UserRoleDAO.findUserRoleById(tableAdmin.getRoleId());
                PersonalInfo tablePersonal = PersonalInfoDAO.findPersonalInfoByNationalId(tableUserRole.getNationalId());
        %>
        <tr>
            <td width="30px">
                <%=i + 1%>
            </td>
            <td><%=tablePersonal.getUsername()%>
            </td>
            <td><%=tableState.getName()%>
            </td>
            <td class="operatorBox">
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=i%>">
                    <img src="../images/delete.png">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=i%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف دسترسی"<%=tablePersonal.getUsername()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-state-list.jsp?action=delete&id=<%=tableListRole.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="manage-state-list.jsp?action=edit&id=<%=tableListRole.getId()%>" <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess?"-dis":""%>.png">
                </a>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
</div>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/manage-list-roles.js"></script>
</body>
</html>