<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.EquipmentParameterDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.EquipmentParameter" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.EQUIPMENT_PARAMETERS.getValue())) {
        response.sendError(403);
        return;
    }

    EquipmentParameter changingEquipmentParameter = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-equipment-parameter".equals(request.getParameter("action"));
    boolean isSendNew = "send-equipment-parameter".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_PARAMETERS.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_PARAMETERS.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_PARAMETERS.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_PARAMETERS.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingEquipmentParameter = EquipmentParameterDAO.findEquipmentParameterById(
                Long.valueOf(request.getParameter("id")));

    if (isSendRemove)
        EquipmentParameterDAO.delete(changingEquipmentParameter.getId());

    if (isSendNew || isSendEdit) {
        if (!addSubAccess && isSendNew) {
            response.sendError(403);
            return;
        }
        if (!editSubAccess && isSendEdit) {
            response.sendError(403);
            return;
        }
        if (isSendNew)
            changingEquipmentParameter = new EquipmentParameter();
        changingEquipmentParameter.setParameterName(request.getParameter("name"));
        changingEquipmentParameter.setUnitName(request.getParameter("unit-name"));
        changingEquipmentParameter = EquipmentParameterDAO.save(changingEquipmentParameter);
    }

    List<EquipmentParameter> equipmentParameterList = EquipmentParameterDAO.findAllEquipmentParameters();
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
<% if (addSubAccess) { %>
<form id="send-equipment-parameter" method="post" action="manage-equipment-parameter.jsp"
      onsubmit=" return validateForm('#send-equipment-parameter');">
    <input type="hidden" id="pr-tr-no" name="pr-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-equipment-parameter">
    <%} else {%>
    <input type="hidden" name="action" value="send-equipment-parameter">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingEquipmentParameter.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3> ویرایش اطلاعات "<%=changingEquipmentParameter.getParameterName()%>"
        </h3>
        <%} else {%>
        <h3>اضافه کردن پارامتر تجهیزات</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>نام :</label>
                <input class="formInput" name="name"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingEquipmentParameter.getParameterName():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>نام واحد :</label>
                <input class="formInput" name="unit-name"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingEquipmentParameter.getUnitName():""%>"
                       type="text">
            </div>
            <div class="formRow" style=" display: table; width: 100%;">
                <input type="submit" value="تایید" class="btn btn-primary formBtn"
                       style="margin-right: 10px;float: left">
                <%if (isEdit) {%>
                <a class="btn btn-primary formBtn" href="manage-equipment-parameter.jsp"
                   style="margin-right: 10px;float: left">لغو</a>
                <%}%>
            </div>
        </div>
    </div>
</form>
<%}%>
<% if (readSubAccess) { %>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام</th>
            <th>نام واحد</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < equipmentParameterList.size(); i++) {
                EquipmentParameter equipmentParameterTable = equipmentParameterList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=equipmentParameterTable.getParameterName()%>
            </td>
            <td>
                <%=equipmentParameterTable.getUnitName()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=equipmentParameterTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-equipment-parameter.jsp?action=edit&id=<%=equipmentParameterTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=equipmentParameterTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=equipmentParameterTable.getParameterName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-equipment-parameter.jsp?action=delete&id=<%=equipmentParameterTable.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
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