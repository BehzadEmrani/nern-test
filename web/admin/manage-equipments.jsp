<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.EquipmentDAO" %>
<%@ page import="com.atrosys.dao.EquipmentTypeDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.Equipment" %>
<%@ page import="com.atrosys.entity.EquipmentType" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.EQUIPMENT_DEFINITION.getValue())) {
        response.sendError(403);
        return;
    }
    Equipment changingEquipment = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-equipment".equals(request.getParameter("action"));
    boolean isSendNew = "send-equipment".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_DEFINITION.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_DEFINITION.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_DEFINITION.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_DEFINITION.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingEquipment = EquipmentDAO.findEquipmentById(Long.valueOf(request.getParameter("id")));
    if (isSendRemove) {
        EquipmentDAO.delete(changingEquipment.getId());
    }
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
            changingEquipment = new Equipment();
        changingEquipment.setEquipmentTypeId(Long.valueOf(request.getParameter("type-id")));
        changingEquipment.setSerialNo(request.getParameter("serial-no"));
        changingEquipment.setEquipmentShoaNo(request.getParameter("equipment-shoa-no"));
        changingEquipment.setShoaOwner("on".equals(request.getParameter("is-shoa-owner")));
        if (!changingEquipment.getShoaOwner()) {
            changingEquipment.setOwnerName(request.getParameter("owner-name"));
            changingEquipment.setEquipmentNo1(request.getParameter("equipment-no-1"));
            changingEquipment.setEquipmentNo2(request.getParameter("equipment-no-2"));
        }
        changingEquipment.setDescription(request.getParameter("description"));
        changingEquipment = EquipmentDAO.save(changingEquipment);
    }

    List<Equipment> equipments = EquipmentDAO.findAllEquipments();
    List<EquipmentType> equipmentTypes = EquipmentTypeDAO.findAllEquipmentTypes();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/bootstrap-select.min.css">
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
<form id="send-equipment" method="post" action="manage-equipments.jsp"
      onsubmit=" return validateForm('#send-equipment');">
    <input type="hidden" id="parameter-tr-no" name="parameter-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-equipment">
    <%} else {%>
    <input type="hidden" name="action" value="send-equipment">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingEquipment.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات <%=changingEquipment.getSerialNo()%>
        </h3>
        <%} else {%>
        <h3>اضافه کردن به نوع تجهیزات</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>نوع :</label>
                <select class="formSelect" name="type-id" style="width: 200px;">
                    <%
                        Long selectedType = null;
                        if (isEdit)
                            selectedType = changingEquipment.getEquipmentTypeId();
                        for (EquipmentType equipmentType : equipmentTypes) {%>
                    <option value="<%=equipmentType.getId()%>"
                            <%=isEdit ? (selectedType.equals(equipmentType.getId()) ? "selected" : "") : ""%>>
                        <%=equipmentType.getName() + "-" + equipmentType.getPartNumber()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <%--<div class="formItem">--%>
                <%--<select class="selectpicker" id="type-search" data-live-search="true">--%>
                    <%--&lt;%&ndash;<option data-tokens="ketchup mustard">Hot Dog, Fries and a Soda</option>&ndash;%&gt;--%>
                    <%--&lt;%&ndash;<option data-tokens="mustard">Burger, Shake and a Smile</option>&ndash;%&gt;--%>
                    <%--&lt;%&ndash;<option data-tokens="frosting">Sugar, Spice and all things nice</option>&ndash;%&gt;--%>
                <%--</select>--%>

            <%--</div>--%>
            <div class="formItem">
                <label>سریال نامبر :</label>
                <input class="formInput" name="serial-no" style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingEquipment.getSerialNo():""%>" type="text">
            </div>
            <div class="formItem">
                <label>شماره اموال خاشع :</label>
                <input class="formInput" name="equipment-shoa-no" style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingEquipment.getEquipmentShoaNo():""%>" type="text">
            </div>
        </div>
        <div class="formItem">مالکیت :

            <%
                boolean checkShoa = true;
                if (isEdit)
                    checkShoa = changingEquipment.getShoaOwner();
            %>
            <div class="formItem">
                <input name="is-shoa-owner" value="on" type="radio"<%=checkShoa?"checked":""%>
                       style="margin-right: 60px"> خاشع
            </div>

            <div class="formItem">
                <input name="is-shoa-owner" value="off" type="radio"<%=!checkShoa?"checked":""%>
                       style="margin-right: 60px"> امانی
            </div>
            <div class="formBox" id="owner-box">
                <br>
                <label> مالک :</label>
                <input class="formInput" name="owner-name" style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit&&!changingEquipment.getShoaOwner()?changingEquipment.getOwnerName():""%>"
                       type="text">
                <label> شماره اموال۱ :</label>
                <input class="formInput" name="equipment-no-1" style="width: 100px;margin-left: 20px;"
                       value="<%=isEdit&&!changingEquipment.getShoaOwner()?changingEquipment.getEquipmentNo1():""%>"
                       type="text">
                <label> شماره اموال۲ :</label>
                <input class="formInput" name="equipment-no-2" style="width: 100px;margin-left: 20px;"
                       value="<%=isEdit&&!changingEquipment.getShoaOwner()?changingEquipment.getEquipmentNo2():""%>"
                       type="text">
            </div>
        </div>
        <div class="formRow">
            <label>توضیحات :</label>
            <textarea class="formInput" name="description" style="width: 100%;height: 100px;"
                      type="text"><%=isEdit ? changingEquipment.getDescription() : ""%></textarea>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="manage-equipments.jsp"
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
            <th>نام</th>
            <th>پارت نامبر</th>
            <th>سریال نامبر</th>
            <th>شماره اموال</th>
            <th>مالک</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < equipments.size(); i++) {
                Equipment equipmentTable = equipments.get(i);
                EquipmentType equipmentTypeTable = EquipmentTypeDAO.findEquipmentTypeById(equipmentTable.getEquipmentTypeId());
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=equipmentTypeTable.getName()%>
            </td>
            <td>
                <%=equipmentTypeTable.getPartNumber()%>
            </td>
            <td>
                <%=equipmentTable.getSerialNo()%>
            </td>
            <td>
                <%=equipmentTable.getEquipmentShoaNo()%>
            </td>
            <td>
                <%=equipmentTable.getShoaOwner() ? "خاشع" : (equipmentTable.getOwnerName() + "-" + equipmentTable.getEquipmentNo1() + "-" + equipmentTable.getEquipmentNo2())%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=equipmentTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-equipments.jsp?action=edit&id=<%=equipmentTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=equipmentTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=equipmentTable.getSerialNo()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-equipments.jsp?action=delete&id=<%=equipmentTable.getId()%>"
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
<script src="../js/bootstrap-select.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/manage-equipments.js"></script>
</body>
</html>