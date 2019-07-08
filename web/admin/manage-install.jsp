<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.EQUIPMENT_INSTALL.getValue())) {
        response.sendError(403);
        return;
    }
    InstallRecord changingInstallRecord = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-record".equals(request.getParameter("action"));
    boolean isSendNew = "send-record".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;

    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_INSTALL.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_INSTALL.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_INSTALL.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_INSTALL.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingInstallRecord = InstallRecordDAO.findInstallRecordById(Long.valueOf(request.getParameter("id")));
    else if (isSendNew)
        changingInstallRecord = new InstallRecord();
    if (isSendRemove)
        InstallRecordDAO.deleteInstalled(changingInstallRecord.getId());
    if (isSendNew || isSendEdit) {
        if (!addSubAccess && isSendNew) {
            response.sendError(403);
            return;
        }
        if (!editSubAccess && isSendEdit) {
            response.sendError(403);
            return;
        }

        changingInstallRecord.setEquipmentId(Long.valueOf(request.getParameter("equip-id")));
        changingInstallRecord.setTelecomCenterId(Long.valueOf(request.getParameter("telecom-id")));
        changingInstallRecord.setParentEquipmentId(Long.valueOf(request.getParameter("parent-id")));
        changingInstallRecord=InstallRecordDAO.save(changingInstallRecord);
    }

    List<InstallRecord> records = InstallRecordDAO.findAllInstallRecords();

    boolean lastOptions=false;
    TelecomCenter changingTelecom = null;
    City changingCity = null;
    State changingState = null;
    Equipment changingEquipment = null;
    if (changingInstallRecord != null) {
        changingTelecom = TelecomCenterDAO.findTelecomCenterById(changingInstallRecord.getTelecomCenterId());
        changingCity = CityDAO.findCityById(changingTelecom.getTelCityId());
        changingState = StateDAO.findStateById(changingCity.getStateId());
        changingEquipment = EquipmentDAO.findEquipmentById(changingInstallRecord.getEquipmentId());
        lastOptions=true;
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
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.min.css"/>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
    </style>
</head>
<body>
<% if (addSubAccess) { %>
<form id="send-record" method="post" action="manage-install.jsp"
      onsubmit=" return validateForm('#send-record');">
    <input type="hidden" id="install-record-tr-no" name="parameter-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-record">
    <%} else {%>
    <input type="hidden" name="action" value="send-record">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingInstallRecord.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3> ویرایش اطلاعات (<%=changingEquipment.getEquipmentShoaNo() + "[" + changingEquipment.getSerialNo() + "]"%>)
        </h3>
        <%} else {%>
        <h3>نصب تجهیزات</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>استان :</label>
                <select class="formSelect" style="width: 200px;" id="state-select">
                    <% for (State state : StateDAO.findAllStates()) { %>
                    <option value="<%=state.getStateId()%>"
                            <%=lastOptions ? (changingState.getStateId().equals(state.getStateId()) ? "selected" : "") : ""%>>
                        <%=state.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>شهر :</label>
                <select class="formSelect" style="width: 200px;" id="city-select"
                        selected-index="<%=lastOptions?changingCity.getCityId():""%>">
                </select>
            </div>
            <div class="formItem">
                <label>مرکز :</label>
                <select class="formSelect" name="telecom-id" style="width: 200px;" id="telecom-select"
                        selected-index="<%=lastOptions?changingTelecom.getId():""%>">
                </select>
            </div>
            <div class="formItem">
                <label>نوع تجهیز :</label>
                <select class="formSelect" style="width: 300px;" id="type-select"
                        selected-index="<%=isEdit?changingEquipment.getEquipmentTypeId():""%>">
                </select>
            </div>
            <div class="formItem">
                <label>تجهیز :</label>
                <select class="formSelect" name="equip-id" style="width: 200px;" id="equip-select"
                        selected-index="<%=isEdit?changingEquipment.getId():""%>">
                </select>
            </div>
            <div class="formItem">
                <label>تجهیز مادر :</label>
                <select class="formSelect" name="parent-id" style="width: 300px;" id="parent-select"
                        selected-index="<%=isEdit?changingInstallRecord.getParentEquipmentId():""%>">
                </select>
            </div>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="manage-install.jsp"
               style="margin-right: 10px;float: left">لغو</a>
            <%}%>
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
            <th>استان</th>
            <th>شهر</th>
            <th>نام مرکز</th>
            <th>نوع تجهیز[پارت]</th>
            <th>شماره اموال[سریال]</th>
            <th>تجهیز مادر</th>
            <th>عملیات</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < records.size(); i++) {
                InstallRecord tableRecord = records.get(i);

                TelecomCenter tableTelecom = TelecomCenterDAO.findTelecomCenterById(tableRecord.getTelecomCenterId());
                City tableCity = CityDAO.findCityById(tableTelecom.getTelCityId());
                State tableState = StateDAO.findStateById(tableCity.getStateId());
                Equipment tableEquipment = EquipmentDAO.findEquipmentById(tableRecord.getEquipmentId());
                EquipmentType tableEquipmentType = EquipmentTypeDAO.findEquipmentTypeById(tableEquipment.getEquipmentTypeId());

                Equipment tableParentEquipment = null;
                EquipmentType tableParentEquipmentType = null;

                if (tableRecord.getParentEquipmentId() != -1) {
                    tableParentEquipment = EquipmentDAO.findEquipmentById(tableRecord.getParentEquipmentId());
                    tableParentEquipmentType = EquipmentTypeDAO.findEquipmentTypeById(tableParentEquipment.getEquipmentTypeId());
                }
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=tableState.getName()%>
            </td>
            <td>
                <%=tableCity.getName()%>
            </td>
            <td>
                <%=tableTelecom.getName()%>
            </td>
            <td>
                <%=tableEquipmentType.getName()%>[<%=tableEquipmentType.getPartNumber()%>]
            </td>
            <td>
                <%=tableEquipment.getEquipmentShoaNo()%>[<%=tableEquipment.getSerialNo()%>]
            </td>
            <td>
                <%=tableParentEquipmentType!=null?(tableParentEquipmentType.getName()+"["+tableParentEquipment.getEquipmentShoaNo()+"]"):"-"%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=tableEquipment.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <%--<a href="manage-install.jsp?action=edit&id=<%=tableRecord.getId()%>"--%>
                        <%--<%=!editSubAccess ? "onclick='return false'" : ""%>>--%>
                    <%--<img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">--%>
                <%--</a>--%>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=tableEquipment.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف تجهیزات نصب شده(
                                    "<%=tableEquipment.getEquipmentShoaNo() + "[" + tableEquipment.getSerialNo() + "]"%>
                                    "
                                    )هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-install.jsp?action=delete&id=<%=tableRecord.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <%}%>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/manage-install.js"></script>
</body>
</html>