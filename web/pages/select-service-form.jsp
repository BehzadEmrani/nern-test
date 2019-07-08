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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue())) {
        response.sendError(403);
        return;
    }

    ServiceForm changingServiceForm = null;
    SubService changingServiceFormSubService = null;
    Service changingServiceFormService = null;
    ServiceCategory changingServiceFormServiceCat = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-service-form".equals(request.getParameter("action"));
    boolean isSendNew = "send-service-form".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));
    boolean isActive = "active-toggle".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove || isActive) {
        changingServiceForm = ServiceFormDAO.findServiceFormById(
                Long.valueOf(request.getParameter("id")));
        changingServiceFormSubService = SubServiceDAO.findSubServiceById(changingServiceForm.getSubServiceId());
        changingServiceFormService = ServiceDAO.findServiceById(changingServiceFormSubService.getServiceId());
        changingServiceFormServiceCat = ServiceCategoryDAO.findServiceCategoryById(changingServiceFormService.getCategoryId());
    }

    if (isSendRemove)
        ServiceFormDAO.delete(changingServiceForm.getId());

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
            changingServiceForm = new ServiceForm();
        changingServiceForm.setSubServiceId(Long.valueOf(request.getParameter("sub-service-id")));
        changingServiceForm.setSlaVal(Integer.valueOf(request.getParameter("sla-type")));
        changingServiceForm.setPayTypeVal(Integer.valueOf(request.getParameter("pay-type")));
        changingServiceForm.setSubsDuration(Integer.valueOf(request.getParameter("subs-duration")));
        changingServiceForm.setPayPeriod(Integer.valueOf(request.getParameter("pay-period")));
        changingServiceForm.setOtherTerms(request.getParameter("other-terms"));
        changingServiceForm.setVersion(request.getParameter("version"));
        changingServiceForm.setActive(true);
        changingServiceForm = ServiceFormDAO.save(changingServiceForm);

        ServiceFormParameterDAO.deleteAllParameter(changingServiceForm.getId());
        int trSize = Integer.valueOf(request.getParameter("pr-tr-no"));
        for (int i = 0; i < trSize; i++) {
            ServiceFormParameter serviceFormParameter = new ServiceFormParameter();
            serviceFormParameter.setServiceFormId(changingServiceForm.getId());
            serviceFormParameter.setCode(request.getParameter("pr-code-" + i));
            serviceFormParameter.setSpecs(request.getParameter("pr-spec-" + i));
            serviceFormParameter.setDeposit(Long.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-deposit-" + i))));
            serviceFormParameter.setWarranty(Long.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-warranty-" + i))));
            serviceFormParameter.setInitialCost(Long.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-initial-cost-" + i))));
            serviceFormParameter.setPeriodicPayment(Long.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-periodic-payment-" + i))));
            serviceFormParameter.setOtherCost(Long.valueOf(Util.convertToEnglishDigits(request.getParameter("pr-other-cost-" + i))));
            ServiceFormParameterDAO.save(serviceFormParameter);
        }
    }

    if (isActive) {
        changingServiceForm.setActive(!changingServiceForm.getActive());
        changingServiceForm = ServiceFormDAO.save(changingServiceForm);
    }

    List<ServiceCategory> serviceCategoryList = ServiceCategoryDAO.findAllCats();
    List<List<ServiceResponse>> jsonServices = new LinkedList<>();
    List<List<List<SubServiceResponse>>> jsonSubServices = new LinkedList<>();
    for (ServiceCategory serviceCat : serviceCategoryList) {
        List<Service> services = ServiceDAO.findServicesByCatId(serviceCat.getId());
        List<ServiceResponse> serviceResponses = new LinkedList<>();
        for (Service service : services) {
            ServiceResponse serviceResponse = new ServiceResponse(service.getId(), service.getFaName());
            serviceResponses.add(serviceResponse);
        }
        jsonServices.add(serviceResponses);
        List<List<SubServiceResponse>> subServiceResponsesList = new LinkedList<>();
        for (Service service : services) {
            List<SubService> subServices = SubServiceDAO.findSubServiceByServiceId(service.getId());
            List<SubServiceResponse> subServiceResponses = new LinkedList<>();
            for (SubService subService : subServices) {
                SubServiceResponse subServiceResponse = new SubServiceResponse(
                        subService.getId(), subService.getFaName(), subService.getOtherCostTitle());
                subServiceResponses.add(subServiceResponse);
            }
            subServiceResponsesList.add(subServiceResponses);
        }
        jsonSubServices.add(subServiceResponsesList);
    }
    Gson gson = new Gson();
    String serviceJson = gson.toJson(jsonServices).replaceAll("\"", "'");
    String subServiceJson = gson.toJson(jsonSubServices).replaceAll("\"", "'");

    String ServiceFormParamterJson = "";
    if (isEdit) {
        List<ServiceFormParameter> serviceFormParameterList =
                ServiceFormParameterDAO.findServiceFormParameterByServiceFormId(changingServiceForm.getId());
        ServiceFormParamterJson = gson.toJson(serviceFormParameterList).replaceAll("\"", "'");
    }

    String subServiceIdParam = request.getParameter("sub-service-param");
    long fsubServiceId = subServiceIdParam != null ? Long.valueOf(subServiceIdParam) : -1;
    String payTypeParam = request.getParameter("pay-type-param");
    int fpayType = payTypeParam != null ? Integer.valueOf(payTypeParam) : -1;
    String payPeriodParam = request.getParameter("pay-period-param");
    int fpayPeriod = payPeriodParam != null ? Integer.valueOf(payPeriodParam) : -1;
    String subsDurationParam = request.getParameter("sub-duration-param");
    int fsubsDuration = subsDurationParam != null ? Integer.valueOf(subsDurationParam) : -1;
    String pageParam = request.getParameter("page-param");
    int pageNumber = pageParam != null ? Integer.valueOf(pageParam) : 1;

    boolean needPreviousPageBtn = false;
    boolean needNextPageBtn = false;
    List<ServiceForm> serviceFormList = ServiceFormDAO.filterServiceFormsInRange(fsubServiceId, fpayType, fpayPeriod, fsubsDuration,
            (pageNumber - 1) * Constants.ADMIN_SERVICE_FORM_PER_PAGE, Constants.ADMIN_SERVICE_FORM_PER_PAGE);
    long numberOfAllRows = ServiceFormDAO.getRowCount();
    if (pageNumber > 1)
        needPreviousPageBtn = true;
    if (pageNumber * Constants.ADMIN_SERVICE_FORM_PER_PAGE < numberOfAllRows)
        needNextPageBtn = true;
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
<form id="send-service-form" method="post" action="../admin/manage-service-form.jsp"
      onsubmit=" return validateForm('#send-service-form');">
    <input type="hidden" id="pr-tr-no" name="pr-tr-no" value="0">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-service-form">
    <%} else {%>
    <input type="hidden" name="action" value="send-service-form">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingServiceForm.getId()%>">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات <%=changingServiceForm.combine()%>
        </h3>
        <%} else {%>
        <h3>اضافه کردن به زیر خدمات</h3>
        <%}%>
        <div class="formRow">
            <div class="formItem">
                <label>دسته :</label>
                <select class="formSelect" id="cat-select" style="width: 200px;">
                    <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) {%>
                    <option value="<%=serviceCategory.getId()%>"
                            <%=isEdit ? (ServiceDAO.findCatIdByServiceId(changingServiceFormServiceCat.getId()) == serviceCategory.getId() ? "selected" : "") : ""%>>
                        <%=serviceCategory.getFaName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>خدمت :</label>
                <select class="formSelect" selected-index="<%=isEdit?changingServiceFormService.getId():""%>"
                        id="service-select" style="width: 200px;" json="<%=serviceJson%>">
                </select>
            </div>
            <div class="formItem">
                <label>زیر خدمت :</label>
                <select class="formSelect" selected-index="<%=isEdit?changingServiceFormSubService.getId():""%>"
                        id="sub-service-select" name="sub-service-id" style="width: 200px;" json="<%=subServiceJson%>">
                </select>
            </div>
            <div class="formItem">
                <label>SLA:</label>
                <select class="formSelect" name="sla-type" style="width: 200px;">
                    <% for (SLAType slaType : SLAType.values()) {%>
                    <option value="<%=slaType.getValue()%>"
                            <%=isEdit ? (slaType.getValue() == changingServiceForm.getSlaVal() ? "selected" : "") : ""%>>
                        <%=slaType.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>نوع پرداخت :</label>
                <select class="formSelect" name="pay-type" style="width: 200px;">
                    <% for (PayType payType : PayType.values()) {%>
                    <option value="<%=payType.getValue()%>"
                            <%=isEdit ? (payType.getValue() == changingServiceForm.getPayTypeVal() ? "selected" : "") : ""%>>
                        <%=payType.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>مدت قرارداد :</label>
                <select class="formSelect" name="subs-duration" style="width: 200px;">
                    <% for (SubsDuration subsDuration : SubsDuration.values()) {%>
                    <option value="<%=subsDuration.getValue()%>"
                            <%=isEdit ? (subsDuration.getValue() == changingServiceForm.getSubsDuration() ? "selected" : "") : ""%>>
                        <%=subsDuration.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>دوره پرداخت :</label>
                <select class="formSelect" name="pay-period" style="width: 200px;">
                    <% for (PayPeriod payPeriod : PayPeriod.values()) {%>
                    <option value="<%=payPeriod.getValue()%>"
                            <%=isEdit ? (payPeriod.getValue() == changingServiceForm.getPayPeriod() ? "selected" : "") : ""%>>
                        <%=payPeriod.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <div class="formItem">
                    <label>ورژن :</label>
                    <input class="formInput" name="version"
                           style="width: 200px;margin-left: 20px;"
                           value="<%=isEdit?changingServiceForm.getVersion():""%>"
                           type="text">
                </div>
            </div>
        </div>
        <p style="display: none" id="other-cost">*عنوان سایر هزینه ها: <span></span></p>
        <div class="formRow">
            <label>سایر شرایط و الزامات :</label>
            <textarea style="width: 100%;height: 100px"
                      name="other-terms"><%=isEdit ? changingServiceForm.getOtherTerms() : ""%></textarea>
        </div>
        <table class="formTable" id="sla-table" style="width: 100%" tr-no="0" json="<%=ServiceFormParamterJson%>">
            <caption>
                تعریف خدمت
            </caption>
            <tr>
                <th></th>
                <th>کد</th>
                <th>مشخصات</th>
                <th>ودیعه(ریال)</th>
                <th>ضمانت نامه(ریال)</th>
                <th>هزینه اولیه(نصب)(ریال)</th>
                <th>پرداخت دوره ای(ریال)</th>
                <th>سایر هزینه ها(ریال)</th>
            </tr>
            <tr class="rowTr" style="display: none" id="sample-tr" no="-1">
                <td>
                    <button type="button" class="btn btn-primary formBtn" style="float: right">-</button>
                </td>
                <td>
                    <input class="formInput pr-c" name="pr-code-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" name="pr-spec-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" value="0" name="pr-deposit-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" value="0" name="pr-warranty-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" value="0" name="pr-initial-cost-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" value="0" name="pr-periodic-payment-" type="text" style="width: 100%">
                </td>
                <td>
                    <input class="formInput pr-c" value="0" name="pr-other-cost-" type="text" style="width: 100%">
                </td>
            </tr>
        </table>
        <br>
        <div class="formRow">
            <button type="button" class="btn btn-primary formBtn" style="float: right" onclick="addNewPrRow()">اضافه
                کردن مورد جدید
            </button>
        </div>
        <br>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="../admin/manage-service-form.jsp"
               style="margin-right: 10px;float: left">لغو</a>
            <%}%>
        </div>
    </div>
</form>
<%}%>
<% if (readSubAccess) { %>
<div class="formBox">
    <form id="send-service-form" action="../admin/manage-service-form.jsp">
        <div class="formBox">
            <div class="formItem">
                <label>دسته :</label>
                <select class="formSelect" id="cat-select-param" style="width: 100px;">
                    <option value="-1"> همه دسته ها</option>
                    <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) {%>
                    <option value="<%=serviceCategory.getId()%>">
                        <%=serviceCategory.getFaName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>خدمت :</label>
                <select class="formSelect" id="service-select-param" style="width: 200px;" json="<%=serviceJson%>">
                </select>
            </div>
            <div class="formItem">
                <label>زیر خدمت :</label>
                <select class="formSelect" id="sub-service-select-param" name="sub-service-param" style="width: 200px;"
                        json="<%=subServiceJson%>">
                </select>
            </div>
            <div class="formItem">
                <label>نوع پرداخت :</label>
                <select class="formSelect" name="pay-type-param" style="width: 200px;">
                    <option value="-1">همه</option>
                    <% for (PayType payType : PayType.values()) {%>
                    <option value="<%=payType.getValue()%>"
                            <%=isEdit ? (payType.getValue() == changingServiceForm.getPayTypeVal() ? "selected" : "") : ""%>>
                        <%=payType.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>مدت قرارداد :</label>
                <select class="formSelect" name="sub-duration-param" style="width: 200px;">
                    <option value="-1">همه</option>
                    <% for (SubsDuration subsDuration : SubsDuration.values()) {%>
                    <option value="<%=subsDuration.getValue()%>"
                            <%=isEdit ? (subsDuration.getValue() == changingServiceForm.getSubsDuration() ? "selected" : "") : ""%>>
                        <%=subsDuration.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>دوره پرداخت :</label>
                <select class="formSelect" name="pay-period-param" style="width: 200px;">
                    <option value="-1">همه</option>
                    <% for (PayPeriod payPeriod : PayPeriod.values()) {%>
                    <option value="<%=payPeriod.getValue()%>"
                            <%=isEdit ? (payPeriod.getValue() == changingServiceForm.getPayPeriod() ? "selected" : "") : ""%>>
                        <%=payPeriod.combinedFaStr()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <input type="submit" value="اعمال" class="btn btn-primary formBtn"
                       style="margin-right: 10px;">
            </div>
        </div>
    </form>
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>کد سرویس فرم</th>
            <th>نام سرویس فرم</th>
            <th>فعال</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < serviceFormList.size(); i++) {
                ServiceForm serviceFormTable = serviceFormList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=(pageNumber - 1) * Constants.ADMIN_SERVICE_FORM_PER_PAGE +i + 1%>
            </td>
            <td style="direction: ltr">
                <%=serviceFormTable.combine()%>
            </td>
            <td style="white-space: pre-line">
                <%=serviceFormTable.faCombine()%>
            </td>
            <td>
                <%=serviceFormTable.getActive() ? "فعال" : "غیر فعال"%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=serviceFormTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="../admin/manage-service-form.jsp?action=edit&id=<%=serviceFormTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="#" data-toggle="modal"
                   data-target="#activeModal<%=serviceFormTable.getId()%>"<%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/check<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=serviceFormTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=serviceFormTable.combine()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="../admin/manage-service-form.jsp?action=delete&id=<%=serviceFormTable.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="activeModal<%=serviceFormTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>ایا مایل به <%=serviceFormTable.getActive() ? "غیر فعال" : "فعال"%> کردن سرویس فرم
                                    هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="../admin/manage-service-form.jsp?action=active-toggle&id=<%=serviceFormTable.getId()%>"
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
    <%
        String pageLink = "manage-service-form.jsp?page-param=%s&";
        if (needNextPageBtn || needPreviousPageBtn)
            pageLink += String.format("sub-service-param=%s&pay-type-param=%s&pay-period-param=%s&sub-duration-param=%s&page-param=%s"
                    , fsubServiceId, fpayType, fpayPeriod, fsubsDuration, pageNumber);
    %>
    <%if (needNextPageBtn) {%>
    <a href="<%=String.format(pageLink,pageNumber+1)%>">
        <div style="float: right">صفحه بعدی</div>
    </a>
    <%}%>
    <%if (needPreviousPageBtn) {%>
    <a href="<%=String.format(pageLink,pageNumber-1)%>">
        <div style="float: left">صفحه قبلی</div>
    </a>
    <%}%>
    <br clear="both">
    <%} %>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="../admin/js/manage-service-form.js"></script>
</body>
</html>