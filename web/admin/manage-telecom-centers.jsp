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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.TECH_OP_TELECOM_CENTERS.getValue())) {
        response.sendError(403);
        return;
    }

    TelecomCenter changingTelecomCenter = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-telecom-center".equals(request.getParameter("action"));
    boolean isSendNew = "send-telecom-center".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_OP_TELECOM_CENTERS.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_OP_TELECOM_CENTERS.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_OP_TELECOM_CENTERS.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_OP_TELECOM_CENTERS.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingTelecomCenter = TelecomCenterDAO.findTelecomCenterById(Long.valueOf(request.getParameter("id")));
    if (isSendRemove)
        TelecomCenterDAO.delete(changingTelecomCenter.getId());
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
            changingTelecomCenter = new TelecomCenter();
        changingTelecomCenter.setName(request.getParameter("name"));
        changingTelecomCenter.setCenterAgentName(request.getParameter("agent-name"));
        changingTelecomCenter.setCenterTel(request.getParameter("tel-no"));
        changingTelecomCenter.setTelCityId(Long.valueOf(request.getParameter("city-id")));
        changingTelecomCenter.setType(Integer.valueOf(request.getParameter("type")));
        changingTelecomCenter.setCenterLat(Double.valueOf(request.getParameter("lat")));
        changingTelecomCenter.setCenterLng(Double.valueOf(request.getParameter("lng")));
        changingTelecomCenter.setAddress(request.getParameter("address"));
        changingTelecomCenter = TelecomCenterDAO.save(changingTelecomCenter);

        TelecomCenterPreFixDAO.deleteAllPrefixes(changingTelecomCenter.getId());
        int trSize = Integer.valueOf(request.getParameter("pre-fix-tr-no"));
        for (int i = 0; i < trSize; i++) {
            TelecomCenterPreFix telecomCenterPreFix = new TelecomCenterPreFix();
            telecomCenterPreFix.setTelecomCenterId(changingTelecomCenter.getId());
            telecomCenterPreFix.setPreFixNo(request.getParameter("pre-fix-" + i));
            TelecomCenterPreFixDAO.save(telecomCenterPreFix);
        }
    }

    String preFixesJson = "";
    if (isEdit) {
        List<TelecomCenterPreFix> changingPreFixes =
                TelecomCenterPreFixDAO.findTelecomCenterPreFixByTelecomIdDesc(changingTelecomCenter.getId());
        preFixesJson = new Gson().toJson(changingPreFixes).replace("\"", "\'");
    }

    List<TelecomCenter> telecomCenters = TelecomCenterDAO.findAllTelecomCenters();
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
        #mapTel {
            margin: 20px auto;
            width: 420px;
            height: 260px;
            border: 1px solid #41709c;
        }
    </style>
</head>
<body>
<% if (addSubAccess) { %>
<form id="send-telecom-center" method="post" action="manage-telecom-centers.jsp"
      onsubmit=" return validateForm('#send-telecom-center');">
    <input type="hidden" id="pre-fix-tr-no" name="pre-fix-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-telecom-center">
    <%} else {%>
    <input type="hidden" name="action" value="send-telecom-center">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingTelecomCenter.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات <%=changingTelecomCenter.getName()%>
        </h3>
        <%} else {%>
        <h3>اضافه کردن به مراکز مخابراتی</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>استان :</label>
                <select class="formSelect" id="state-select" style="width: 200px;">
                    <%
                        Long selectedStateId = null;
                        if (isEdit)
                            selectedStateId = CityDAO.findCityById(changingTelecomCenter.getTelCityId()).getStateId();
                        for (State state : StateDAO.findAllStates()) {%>
                    <option value="<%=state.getStateId()%>"
                            <%=isEdit ? (selectedStateId == state.getStateId() ? "selected" : "") : ""%>>
                        <%=state.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>شهر :</label>
                <select class="formSelect" selected-index="<%=isEdit?changingTelecomCenter.getTelCityId():""%>"
                        id="city-select" name="city-id" style="width: 200px;">
                </select>
            </div>
            <div class="formItem">
                <label>نوع :</label>
                <select class="formSelect" name="type" style="width: 200px;">
                    <%
                        Integer selectedType = null;
                        if (isEdit)
                            selectedType = changingTelecomCenter.getType();
                        for (TelecomCenterType type : TelecomCenterType.values()) {%>
                    <option value="<%=type.getValue()%>"
                            <%=isEdit ? (selectedType == type.getValue() ? "selected" : "") : ""%>>
                        <%=type.getFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <div class="formItem">
                    <label>نام :</label>
                    <input class="formInput" name="name" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingTelecomCenter.getName():""%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label>شماره تماس :</label>
                    <input class="formInput" name="tel-no" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingTelecomCenter.getCenterTel():""%>" type="text">
                </div>
            </div>
            <div class="formItem">
                <div class="formItem">
                    <label>نام کارشناس :</label>
                    <input class="formInput" name="agent-name" style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingTelecomCenter.getCenterAgentName():""%>" type="text">
                </div>
                <div class="formItem">
                    <label>آدرس :</label>
                    <input class="formInput addressInput"
                           style="width: 650px;margin-left: 20px;" type="text" name="address"
                           value="<%=isEdit ?changingTelecomCenter.getAddress():""%>"
                           maxlength="300">
                </div>
            </div>
        </div>
        <div class="formRow">
            <div id="mapTel" <%=isEdit ? "lat='" + changingTelecomCenter.getCenterLat() + "' lng='" + changingTelecomCenter.getCenterLng() + "'" : ""%>></div>
            <input type="hidden" name="lat" value="<%=isEdit?changingTelecomCenter.getCenterLat():""%>" id="telLat">
            <input type="hidden" name="lng" value="<%=isEdit?changingTelecomCenter.getCenterLng():""%>" id="telLng">
        </div>
        <table class="formTable" id="pre-fix-table" style="width: 300px" tr-no="0" json="<%=preFixesJson%>">
            <tr>
                <th style="width: 70px;"></th>
                <th>پیش شماره</th>
            </tr>
            <tr class="rowTr" style="display: none" id="sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <input class="formInput pre-fix-c" name="pre-fix-" type="text" style="width: 100%">
                </td>
            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewPrRow()">اضافه
                کردن پیش شماره جدید
            </button>
        </div>
        <br>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="manage-telecom-centers.jsp"
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
            <th>نوع</th>
            <th>استان</th>
            <th>شهر</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < telecomCenters.size(); i++) {
                TelecomCenter telecomCenterTable = telecomCenters.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=telecomCenterTable.getName()%>
            </td>
            <td>
                <%=TelecomCenterType.fromValue(telecomCenterTable.getType()).getFaStr()%>
            </td>
            <%
                City cityTable = CityDAO.findCityById(telecomCenterTable.getTelCityId());
                State stateTable = StateDAO.findStateById(cityTable.getStateId());
            %>
            <td>
                <%=stateTable.getName()%>
            </td>
            <td>
                <%=cityTable.getName()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=telecomCenterTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-telecom-centers.jsp?action=edit&id=<%=telecomCenterTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=telecomCenterTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=telecomCenterTable.getName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-telecom-centers.jsp?action=delete&id=<%=telecomCenterTable.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>d
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
<script src="js/manage-telecom-centers.js"></script>

</body>
</html>