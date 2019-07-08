<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.ADMIN_APPROVING_ROLES.getValue())) {
        response.sendError(403);
        return;
    }
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean editSubAccess = false;
    boolean deleteSubAccess = false;
    try {
        addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_APPROVING_ROLES.getValue(),
                AdminSubAccessType.ADD.getValue());
        readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_APPROVING_ROLES.getValue(),
                AdminSubAccessType.READ.getValue());
        editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_APPROVING_ROLES.getValue(),
                AdminSubAccessType.EDIT.getValue());
        deleteSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.ADMIN_APPROVING_ROLES.getValue(),
                AdminSubAccessType.DELETE.getValue());
    } catch (Exception e) {
    }
    boolean isEdit = "edit".equals(request.getParameter("action")) && editSubAccess;
    boolean isSendEdit = "edit-approving".equals(request.getParameter("action"));
    boolean isSendNew = "send-approving".equals(request.getParameter("action"));
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

    ApprovingRole targetApprovingRole = null;
    University targetUniversity = null;


    try {
        if (isEdit || isSendEdit || isSendNew || isSendDelete) {
            if (isSendNew) {
                targetUniversity = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("uni-national-id")));
                targetApprovingRole = new ApprovingRole();
            } else if (isEdit || isSendEdit || isSendDelete) {
                targetApprovingRole = ApprovingRoleDAO.findApprovingRoleByid(Long.valueOf(request.getParameter("id")));
                targetUniversity = UniversityDAO.findUniByUniNationalId(targetApprovingRole.getUniId());
            }
            if (isSendEdit || isSendNew) {
                targetApprovingRole.setUniId(targetUniversity.getUniNationalId());
                targetApprovingRole.setStateId(Long.valueOf(request.getParameter("state")));
                targetApprovingRole.setSubSystemVal(Integer.valueOf(request.getParameter("sub-code")));
                targetApprovingRole.setSubSystemTypeVal(Integer.valueOf(request.getParameter("sub-type")));
                targetApprovingRole = ApprovingRoleDAO.save(targetApprovingRole);
            }
            if (isSendDelete)
                ApprovingRoleDAO.delete(targetApprovingRole.getId());
        }
    } catch (Exception e) {
        if (e.getMessage().equals("repeated-approval"))
            message = "این تایید کننده وجود دارد لطفا انرا ویرایش کنید";
        else
            message = "خطای غیر منتظره";
    }
    List<ApprovingRole> approvingRoles = ApprovingRoleDAO.findAllApprovingRoles();
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
<form id="send-form" onsubmit="return validateForm('#send-form');" method="post" action="manage-approvals.jsp">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-approving">
    <input type="hidden" name="id" value="<%=targetApprovingRole.getId()%>">
    <%} else if (addSubAccess) {%>
    <input type="hidden" name="action" value="send-approving">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات "<%=targetUniversity.getUniName()%>"</h3>
        <%} else {%>
        <h3>افزودن تایید کننده جدید</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>کد ملی دانشگاه :</label>
                <input class="formInput<%=isEdit?" formInputDeactive":" numberInput"%>" name="uni-national-id"
                       value="<%=isEdit?targetUniversity.getUniNationalId():""%>"
                       maxlength="11"
                       minlength="10"
                       style="width: 150px;margin-left: 20px;" type="text"<%=isEdit?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>بخش :</label>
                <select class="formSelect" name="sub-code"
                        style="width: 200px;margin-left: 20px">
                    <%
                        for (SubSystemCode subSystemCode : SubSystemCode.values()) {
                            if (subSystemCode.isHaveApprovingSystem()) {
                    %>
                    <option value="<%=subSystemCode.getValue()%>"<%=isEdit ? (targetApprovingRole.getSubSystemVal().equals(subSystemCode.getValue()) ? "selected" : "") : ""%>>
                        <%=subSystemCode.getFaStr()%>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            <div class="formItem">
                <label>نوع :</label>
                <select class="formSelect" name="sub-type"
                        style="width: 200px;margin-left: 20px"
                        selected-index="<%=isEdit ?targetApprovingRole.getSubSystemTypeVal():""%>">
                    <option value="-1">همه انواع</option>
                </select>
            </div>
            <div class="formItem">
                <label>استان :</label>
                <select class="formSelect" name="state"
                        style="width: 200px;margin-left: 20px">
                    <option value="-1">همه استان ها</option>
                    <% for (State state : StateDAO.findAllStates()) {%>
                    <option value="<%=state.getStateId()%>"<%=isEdit ? (targetApprovingRole.getStateId().equals(state.getStateId()) ? "selected" : "") : ""%>>
                        <%=state.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-approvals.jsp" class="btn btn-primary formBtn" style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
</form>
<%}%>
<%if (readSubAccess) {%>
<div class="formBox" style="text-align: center;margin-bottom:10px ">
    <h4 style="text-align: center">
        فهرست تایید کنندگان
    </h4>
    <table class="fixed-table table table-striped" style="display: inline-block;;">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th width="30px">ردیف</th>
            <th>شناسه ملی</th>
            <th>نام سازمان</th>
            <th>نام</th>
            <th>بخش</th>
            <th>نوع</th>
            <th>استان</th>
            <th style="width:200px;">عملیات ها</th>
        </tr>
        <thead>
        <tbody>
        <%
            for (int i = 0; i < approvingRoles.size(); i++) {
                ApprovingRole tableApprovingRole = approvingRoles.get(i);
                University tableUniversity = UniversityDAO.findUniByUniNationalId(tableApprovingRole.getUniId());
                Agent primaryAgent = AgentDAO.findUniPrimaryAgentByUniId(tableUniversity.getUniNationalId());
                PersonalInfo tablePersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(primaryAgent.getNationalId());
        %>
        <tr>
            <td width="30px">
                <%=i + 1%>
            </td>
            <td>
                <%=tableUniversity.getUniNationalId()%>
            </td>
            <td>
                <%=tableUniversity.getUniName()%>
            </td>
            <td>
                <%=tablePersonalInfo.combineName()%>
            </td>
            <td>
                <%=tableApprovingRole.getSubSystemVal() == -1 ? "همه بخش ها" : SubSystemCode.fromValue(tableApprovingRole.getSubSystemVal()).getFaStr()%>
            </td>
            <td>
                <%=tableApprovingRole.getSubSystemTypeVal() == -1 ? "همه نوع ها" : SubSystemCode.subSystemsTypeFromValue(
                        SubSystemCode.fromValue(tableApprovingRole.getSubSystemVal()), tableApprovingRole.getSubSystemTypeVal()).getFaStr()%>
            </td>
            <td>
                <%=tableApprovingRole.getStateId() == -1 ? "همه استان ها" : StateDAO.findStateNameById(tableApprovingRole.getStateId())%>
            </td>
            <td class="operatorBox" style="width:200px;">
                <%--<a href="#" data-toggle="modal"--%>
                <%--data-target="#dataModal<%=i%>">--%>
                <%--<img src="../images/access.png">--%>
                <%--</a>--%>
                <%--<!-- Modal -->--%>
                <%--<div class="modal fade" id="dataModal<%=i%>" role="dialog">--%>
                <%--<div class="modal-dialog modal-sm">--%>
                <%--<div class="modal-content">--%>
                <%--<div class="modal-body" style="text-align: right">--%>
                <%--شماره ملی :--%>
                <%--<%=tablePersonalInfo.getNationalId()%><br>--%>
                <%--نام کاربری :--%>
                <%--<%=tablePersonalInfo.getUsername()%><br>--%>
                <%--بخش :--%>

                <%--<br>--%>
                <%--نوع :--%>

                <%--<br>--%>
                <%--استان :--%>

                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
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
                                <h4>آیا مایل به حذف دسترسی"<%=tableUniversity.getUniName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-approvals.jsp?action=delete&id=<%=tableApprovingRole.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="manage-approvals.jsp?action=edit&id=<%=tableApprovingRole.getId()%>" <%=!editSubAccess ? "onclick='return false'" : ""%>>
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
<script src="js/manage-approvals.js"></script>
</body>
</html>