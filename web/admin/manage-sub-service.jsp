<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.LinkedList" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SERVICES_ADD_SUB_SERVICE.getValue())) {
        response.sendError(403);
        return;
    }

    SubService changingSubService = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-sub-service".equals(request.getParameter("action"));
    boolean isSendNew = "send-sub-service".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SUB_SERVICE.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SUB_SERVICE.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SUB_SERVICE.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SUB_SERVICE.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingSubService = SubServiceDAO.findSubServiceById(
                Long.valueOf(request.getParameter("id")));

    if (isSendRemove)
        SubServiceDAO.delete(changingSubService.getId());

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
            changingSubService = new SubService();
        changingSubService.setFaName(request.getParameter("fa-name"));
        changingSubService.setEnName(request.getParameter("en-name"));
        changingSubService.setCode(request.getParameter("code"));
        changingSubService.setOtherCostTitle(request.getParameter("other-cost-title"));
        changingSubService.setServiceId(Long.valueOf(request.getParameter("service-id")));
        changingSubService.setApproveTypeVal(Integer.valueOf(request.getParameter("approve-type")));
        changingSubService.setApproveSessionNo(request.getParameter("approve-session-" + changingSubService.getApproveTypeVal()));
        changingSubService.setExclusiveTerms(request.getParameter("exclusive-terms"));
        changingSubService.setSlaMeasurement(request.getParameter("sla-measurement"));
        changingSubService = SubServiceDAO.save(changingSubService);

        SubServiceParameterDAO.deleteAllParameter(changingSubService.getId());
        int trSize = Integer.valueOf(request.getParameter("pr-tr-no"));
        for (int i = 0; i < trSize; i++) {
            SubServiceParameter subServiceParameter = new SubServiceParameter();
            subServiceParameter.setSubServiceId(changingSubService.getId());
            subServiceParameter.setFaName(request.getParameter("pr-name-" + i));
            subServiceParameter.setUnitVal(Integer.valueOf(request.getParameter("pr-unit-" + i)));
            subServiceParameter.setBronzeValue(Double.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-sla-B-" + i))));
            subServiceParameter.setSilverValue(Double.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-sla-S-" + i))));
            subServiceParameter.setGoldValue(Double.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-sla-G-" + i))));
            subServiceParameter.setDiamondValue(Double.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-sla-D-" + i))));
            SubServiceParameterDAO.save(subServiceParameter);
        }
    }

    List<SubService> subServiceList = SubServiceDAO.findAllSubServices();

    List<ServiceCategory> serviceCategoryList = ServiceCategoryDAO.findAllCats();
    List<List<ServiceResponse>> jsonServices = new LinkedList<>();
    for (ServiceCategory serviceCat : serviceCategoryList) {
        List<Service> services = ServiceDAO.findServicesByCatId(serviceCat.getId());
        List<ServiceResponse> serviceResponses = new LinkedList<>();
        for (Service service : services) {
            ServiceResponse serviceResponse = new ServiceResponse(service.getId(), service.getFaName());
            serviceResponses.add(serviceResponse);
        }
        jsonServices.add(serviceResponses);
    }
    Gson gson = new Gson();
    String serviceJson = gson.toJson(jsonServices).replaceAll("\"", "'");

    String ServiceParamterJson = "";
    if (isEdit) {
        List<SubServiceParameter> serviceParameterList =
                SubServiceParameterDAO.findSubServiceParameterBySubServiceId(changingSubService.getId());
        ServiceParamterJson = gson.toJson(serviceParameterList).replaceAll("\"", "'");
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
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
    </style>
</head>
<body>
<% if (addSubAccess) { %>
<form id="send-sub-service" method="post" action="manage-sub-service.jsp"
      onsubmit=" return validateForm('#send-sub-service');">
    <input type="hidden" id="pr-tr-no" name="pr-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-sub-service">
    <%} else {%>
    <input type="hidden" name="action" value="send-sub-service">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingSubService.getId()%>">
    <%}%>
    <div class="formBox">
        <h3>اضافه کردن به زیر خدمات</h3>
        <div class="formRow">
            <div class="formItem">
                <label>دسته :</label>
                <select class="formSelect" id="cat-select" style="width: 200px;">
                    <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) {%>
                    <option value="<%=serviceCategory.getId()%>"
                            <%=isEdit ? (ServiceDAO.findCatIdByServiceId(changingSubService.getServiceId()) == serviceCategory.getId() ? "selected" : "") : ""%>>
                        <%=serviceCategory.getFaName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>خدمت :</label>
                <select class="formSelect" selected-index="<%=isEdit?changingSubService.getServiceId():""%>"
                        id="service-select" name="service-id" style="width: 200px;"
                        json="<%=serviceJson%>">
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>نام :</label>
                <input class="formInput persianInput" name="fa-name"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingSubService.getFaName():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>نام به انگلیسی :</label>
                <input class="formInput" name="en-name"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingSubService.getEnName():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>کد :</label>
                <input class="formInput" name="code"
                       style="width: 200px;margin-left: 20px;" value="<%=isEdit?changingSubService.getCode():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>عنوان سایر هزینه ها :</label>
                <input class="formInput" name="other-cost-title"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingSubService.getOtherCostTitle():""%>"
                       type="text">
            </div>
        </div>

        <div class="formItem">
            <label>روش اندازه گیری SLA :</label>
            <input class="formInput" name="sla-measurement"
                   style="width: 200px;margin-left: 20px;"
                   value="<%=isEdit?changingSubService.getSlaMeasurement():""%>"
                   type="text">
        </div>
        <br>

        <label>مرجع تصویب SLA:</label>
        <%
            SubServiceApproveType[] subServiceApproveTypes = SubServiceApproveType.values();
            for (int i = 0; i < subServiceApproveTypes.length; i++) {
                SubServiceApproveType approveType = subServiceApproveTypes[i];
        %>
        <div class="formRow">
            <div class="formItem">
                <input type="radio" name="approve-type" value="<%=approveType.getValue()%>"
                    <%=isEdit?(changingSubService.getApproveTypeVal().equals(approveType.getValue())?"checked":""):
                    (i==0?"checked":"")%>>
                <%=approveType.getFaStr()%>
            </div>
            <div class="formItem">
                <label>شماره جلسه :</label>
                <input class="formInput" name="approve-session-<%=approveType.getValue()%>"
                       style="width: 100px;margin-left: 20px;"
                       value="<%=isEdit?(changingSubService.getApproveTypeVal().equals(approveType.getValue())?changingSubService.getApproveSessionNo():""):""%>"
                       type="text">
            </div>
        </div>
        <%}%>

        <div class="formRow">
            <label>شرایط اختصاصی :</label>
            <textarea style="width: 100%;height: 100px"
                      name="exclusive-terms"><%=isEdit ? changingSubService.getExclusiveTerms() : ""%></textarea>
        </div>

        <table class="formTable" id="sla-table" style="width: 100%" tr-no="0" json="<%=ServiceParamterJson%>">
            <caption>
                تعریف پارامتر های SLA
            </caption>
            <tr>
                <th></th>
                <th>نام پارامتر</th>
                <th>واحد</th>
                <% for (SLAType slaType : SLAType.values()) {%>
                <th><%=slaType.combinedFaStr()%>
                </th>
                <%}%>
            </tr>
            <tr class="rowTr" style="display: none" id="sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <input class="formInput pr-c" name="pr-name-" type="text" style="width: 100%">
                </td>
                <td>
                    <select class="pr-c" name="pr-unit-">
                        <%for (Unit unit : Unit.values()) {%>
                        <option value="<%=unit.getValue()%>">
                            <%=unit.getFaStr()%>
                        </option>
                        <%}%>
                    </select>
                </td>
                <% for (SLAType slaType : SLAType.values()) {%>
                <td>
                    <input class="formInput pr-c" name="pr-sla-<%=slaType.getAbbrStr()%>-" type="text"
                           style="width: 100%">
                </td>
                <%}%>
            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewPrRow()">اضافه
                کردن پارامتر
            </button>
        </div>
        <br>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
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
            <th>نام به انگلیسی</th>
            <th> خدمت</th>
            <th>کد</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < subServiceList.size(); i++) {
                SubService subServiceTable = subServiceList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=subServiceTable.getFaName()%>
            </td>
            <td>
                <%=subServiceTable.getEnName()%>
            </td>
            <td>
                <%
                    Service service = ServiceDAO.findServiceById(subServiceTable.getServiceId());
                %>
                <%=service != null ? service.getFaName() : "نامشخص"%>
            </td>
            <td>
                <%=subServiceTable.getCode()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=subServiceTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-sub-service.jsp?action=edit&id=<%=subServiceTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=subServiceTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=subServiceTable.getFaName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-sub-service.jsp?action=delete&id=<%=subServiceTable.getId()%>"
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
<script src="js/manage-sub-service.js"></script>
</body>
</html>