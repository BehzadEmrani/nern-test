<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.google.gson.Gson" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.EQUIPMENT_TYPES.getValue())) {
        response.sendError(403);
        return;
    }
    EquipmentType changingEquipmentType = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-equipment-type".equals(request.getParameter("action"));
    boolean isSendNew = "send-equipment-type".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;

    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_TYPES.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_TYPES.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_TYPES.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.EQUIPMENT_TYPES.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingEquipmentType = EquipmentTypeDAO.findEquipmentTypeById(Long.valueOf(request.getParameter("id")));
    if (isSendRemove) {
        EquipmentTypeDAO.delete(changingEquipmentType.getId());
        EquipmentTypeParametersDAO.deleteAllParameters(changingEquipmentType.getId());
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
            changingEquipmentType = new EquipmentType();
        changingEquipmentType.setName(request.getParameter("name"));
        changingEquipmentType.setManufacturer(request.getParameter("manufacturer"));
        changingEquipmentType.setPartNumber(request.getParameter("part-no"));
        changingEquipmentType.setTypeVal(Integer.valueOf(request.getParameter("type")));
        changingEquipmentType.setCapacity(Integer.valueOf(request.getParameter("capacity")));
        changingEquipmentType.setCapacityUse(Integer.valueOf(request.getParameter("capacity-use")));
        changingEquipmentType.setIranManufactured("on".equals(request.getParameter("is-iranian")));
        if (changingEquipmentType.getTypeVal().equals(EquipmentTypes.ACTIVE.getValue())) {
            changingEquipmentType.setElectronicSourceVal(Integer.valueOf(request.getParameter("source-type")));
            changingEquipmentType.setAmpere(Integer.valueOf(request.getParameter("ampere")));
            changingEquipmentType.setWatt(Integer.valueOf(request.getParameter("watt")));
        } else {
            changingEquipmentType.setElectronicSourceVal(null);
            changingEquipmentType.setAmpere(null);
            changingEquipmentType.setWatt(null);
        }
        changingEquipmentType = EquipmentTypeDAO.save(changingEquipmentType);

        EquipmentTypeParametersDAO.deleteAllParameters(changingEquipmentType.getId());
        int trSize = Integer.valueOf(request.getParameter("parameter-tr-no"));
        for (int i = 0; i < trSize; i++) {
            EquipmentTypeParameters equipmentTypeParameters = new EquipmentTypeParameters();
            equipmentTypeParameters.setEquipmentTypeId(changingEquipmentType.getId());
            equipmentTypeParameters.setEquipmentParameterId(Long.valueOf(request.getParameter("parameter-" + i)));
            equipmentTypeParameters.setAmount(request.getParameter("amount-" + i));
            EquipmentTypeParametersDAO.save(equipmentTypeParameters);
        }

        EquipmentTypePortDAO.deleteAllPorts(changingEquipmentType.getId());
        int portTrSize = Integer.valueOf(request.getParameter("port-tr-no"));
        for (int i = 0; i < portTrSize; i++) {
            EquipmentTypePort equipmentTypePort = new EquipmentTypePort();
            equipmentTypePort.setEquipmentTypeId(changingEquipmentType.getId());
            equipmentTypePort.setPortNo(Integer.valueOf(request.getParameter("port-no-" + i)));
            equipmentTypePort.setUnitVal(Integer.valueOf(request.getParameter("port-unit-" + i)));
            equipmentTypePort.setValue(Double.valueOf(request.getParameter("port-amount-" + i)));
            EquipmentTypePortDAO.save(equipmentTypePort);
        }

        EquipmentParentRelDAO.deleteAllParentRels(changingEquipmentType.getId());
        int parentTrSize = Integer.valueOf(request.getParameter("parent-tr-no"));
        for (int i = 0; i < parentTrSize; i++) {
            EquipmentParentRel parentRel = new EquipmentParentRel();
            parentRel.setChildId(changingEquipmentType.getId());
            parentRel.setParentId(Long.valueOf(request.getParameter("equip-type-" + i)));
            EquipmentParentRelDAO.save(parentRel);
        }
    }

    String parametersJson = "";
    String portsJson = "";
    String parentsJson = "";
    if (isEdit) {
        List<EquipmentTypeParameters> changingTypeParameters =
                EquipmentTypeParametersDAO.findEquipmentTypeParametersByEquipmentTypeIdDesc(changingEquipmentType.getId());
        parametersJson = new Gson().toJson(changingTypeParameters).replace("\"", "\'");

        List<EquipmentTypePort> changingTypePorts = EquipmentTypePortDAO.findEquipmentTypePortByEquipmentTypeId(changingEquipmentType.getId());
        portsJson = new Gson().toJson(changingTypePorts).replace("\"", "\'");

        List<EquipmentParentRel> changingParentRels = EquipmentParentRelDAO.findEquipmentParentRelByChildId(changingEquipmentType.getId());
        parentsJson = new Gson().toJson(changingParentRels).replace("\"", "\'");
    }

    List<EquipmentType> equipmentTypes = EquipmentTypeDAO.findAllEquipmentTypes();
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
<form id="send-equipment-type" method="post" action="manage-equipment-type.jsp"
      onsubmit=" return validateForm('#send-equipment-type');">
    <input type="hidden" id="parameter-tr-no" name="parameter-tr-no" value="0">
    <input type="hidden" id="port-tr-no" name="port-tr-no" value="0">
    <input type="hidden" id="parent-tr-no" name="parent-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-equipment-type">
    <%} else {%>
    <input type="hidden" name="action" value="send-equipment-type">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingEquipmentType.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات <%=changingEquipmentType.getName()%>
        </h3>
        <%} else {%>
        <h3>اضافه کردن به نوع تجهیزات</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <div class="formItem">
                    <label>نام :</label>
                    <input class="formInput" name="name" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingEquipmentType.getName():""%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label>پارت نامبر :</label>
                    <input class="formInput" name="part-no" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingEquipmentType.getPartNumber():""%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label> سازنده :</label>
                    <input class="formInput" name="manufacturer" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingEquipmentType.getManufacturer():""%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label> ظرفیت :</label>
                    <input class="formInput" name="capacity" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingEquipmentType.getCapacity():"0"%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label> ظرفیت اشغالی :</label>
                    <input class="formInput" name="capacity-use" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingEquipmentType.getCapacityUse():"0"%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <label>نوع :</label>
                <select class="formSelect" name="type" style="width: 200px;" id="typeSelect">
                    <%
                        Integer selectedType = null;
                        if (isEdit)
                            selectedType = changingEquipmentType.getTypeVal();
                        for (EquipmentTypes type : EquipmentTypes.values()) {
                    %>
                    <option value="<%=type.getValue()%>"
                            <%=isEdit ? (selectedType == type.getValue() ? "selected" : "") : ""%>>
                        <%=type.getFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>محل تولید: </label>
                <%
                    boolean checkIran = false;
                    if (isEdit)
                        checkIran = changingEquipmentType.getIranManufactured();
                %>
                <input style="margin-left: 10px" name="is-iranian" type="radio" class="btn btn-primary formBtn"
                       value="on"<%=checkIran?"checked":""%>>تولید داخل
                <input style="margin-left: 10px" name="is-iranian" type="radio" class="btn btn-primary formBtn"
                       value="off" <%=!checkIran?"checked":""%>>تولید خارج
            </div>
        </div>
        <div class="formRow" id="activePanel"  style="display: none;">
            <div class="formItem" style="margin-right: 10px">
                <label>نوع منبع: </label>
                <%
                    boolean checkAC = false;
                    if (isEdit&&changingEquipmentType.getTypeVal().equals(EquipmentTypes.ACTIVE.getValue()))
                        checkAC = changingEquipmentType.getElectronicSourceVal().equals(EquipmentElectronicSource.AC.getValue());
                %>
                <input style="margin-top: 0;margin-left: 3px;" name="source-type" type="radio"
                       class="btn btn-primary formBtn"
                       value="<%=EquipmentElectronicSource.AC.getValue()%>"<%=checkAC?"checked":""%>><%=EquipmentElectronicSource.AC.getAbbreStr()%>
                <input style="margin-top: 0;margin-left: 3px;margin-right: 10px" name="source-type" type="radio"
                       class="btn btn-primary formBtn"
                       value="<%=EquipmentElectronicSource.DC.getValue()%>" <%=!checkAC?"checked":""%>><%=EquipmentElectronicSource.DC.getAbbreStr()%>
            </div>
            <br>
            <div class="formItem">
                <label> آمپر :</label>
                <input class="formInput" name="ampere" style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit&&changingEquipmentType.getAmpere()!=null?changingEquipmentType.getAmpere():""%>" type="text">
            </div>
            <div class="formItem">
                <label> وات :</label>
                <input class="formInput" name="watt" style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit&&changingEquipmentType.getWatt()!=null?changingEquipmentType.getWatt():""%>" type="text">
            </div>
        </div>
        <table class="formTable" id="parameter-table" style="width: 100%" tr-no="0" json="<%=parametersJson%>">
            <caption>پارامترها</caption>
            <tr>
                <th style="width: 70px;"></th>
                <th>نام پارامتر</th>
                <th>واحد</th>
                <th>مقدار</th>
            </tr>
            <tr class="rowTr" style="display: none" id="sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <select class="formInput parameter-c" name="parameter-" type="text" style="width: 100%">
                        <% for (EquipmentParameter parameter : EquipmentParameterDAO.findAllEquipmentParameters()) {%>
                        <option value="<%=parameter.getId()%>" unit="<%=parameter.getUnitName()%>">
                            <%=parameter.getParameterName()%>
                        </option>
                        <%}%>
                    </select>
                </td>
                <td>
                    <label class="parameter-c" name="unit-" type="text" style="width: 100%"></label>
                </td>
                <td>
                    <input class="formInput parameter-c" name="amount-" type="text" style="width: 100%">
                </td>

            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewPrRow()">اضافه
                کردن پارامتر جدید
            </button>
        </div>
        <br>
        <br>
        <table class="formTable" style="width: auto;" id="parent-table" tr-no="0" json="<%=parentsJson%>">
            <caption>تجهیزات مادر</caption>
            <tr>
                <th style="width: 70px;"></th>
                <th style="max-width: 100px">تجهیز</th>
            </tr>
            <tr class="rowTr" style="display: none" id="parent-sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <select class="formInput parameter-c" name="equip-type-"  style="width: 100%">
                        <% for (EquipmentType equipmentType : EquipmentTypeDAO.findAllEquipmentTypes()) {%>
                        <option value="<%=equipmentType.getId()%>">
                            <%=equipmentType.getName()%>(<%=equipmentType.getPartNumber()%>)
                        </option>
                        <%}%>
                    </select>
                </td>
            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewParentRow()">اضافه
                کردن تجهیز مادر جدید
            </button>
        </div>
        <br>
        <br>
        <br>
        <table class="formTable" style="width: auto;" id="port-table" tr-no="0" json="<%=portsJson%>">
            <caption>پورت ها</caption>
            <tr>
                <th style="width: 70px;"></th>
                <th style="max-width: 100px">شماره</th>
                <th style="max-width: 100px">واحد</th>
                <th style="max-width: 100px">مقدار</th>
            </tr>
            <tr class="rowTr" style="display: none" id="port-sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <input class="formInput port-c" name="port-no-" type="text" style="width: 100%">
                </td>
                <td>
                    <select class="formInput port-c" name="port-unit-"  style="width: 100%">
                        <% for (PortUnit portUnit : PortUnit.values()) {%>
                        <option value="<%=portUnit.getValue()%>">
                            <%=portUnit.getAbbreStr()%>
                        </option>
                        <%}%>
                    </select>
                </td>
                <td>
                    <input class="formInput port-c" name="port-amount-" type="text" style="width: 100%">
                </td>
            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewPortRow()">اضافه
                کردن پورت جدید
            </button>
        </div>
        <br>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="manage-equipment-type.jsp"
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
            <th>نوع</th>
            <th>تولید کننده</th>
            <th>سازنده</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < equipmentTypes.size(); i++) {
                EquipmentType equipmentTypeTable = equipmentTypes.get(i);
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
                <%=EquipmentTypes.fromValue(equipmentTypeTable.getTypeVal()).getFaStr()%>
            </td>
            <td>
                <%=equipmentTypeTable.getIranManufactured() ? "تولید داخل" : "تولید خارج"%>
            </td>
            <td>
                <%=equipmentTypeTable.getManufacturer()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=equipmentTypeTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-equipment-type.jsp?action=edit&id=<%=equipmentTypeTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=equipmentTypeTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=equipmentTypeTable.getName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-equipment-type.jsp?action=delete&id=<%=equipmentTypeTable.getId()%>"
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
<script src="../js/script.js"></script>
<script src="js/manage-equipment-type.js"></script>
</body>
</html>