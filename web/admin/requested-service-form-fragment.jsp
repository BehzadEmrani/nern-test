<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
%>


<%
    boolean isAdminPage = false;

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = null;
    SubSystemCode subSystemCode = null;
    UserRoleType userRoleType = null;
    University university = null;
    UniStatus uniStatus = null;
    UniSessionInfo uniSessionInfo = null;
    if (adminSessionInfo.isAdminLogedIn()) {
        admin = adminSessionInfo.getAdmin();
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue())) {
            response.sendError(403);
            return;
        } else {
            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue(),
                    AdminSubAccessType.READ.getValue());
            removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue(),
                    AdminSubAccessType.DELETE.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        }
        isAdminPage = true;
    } else {
        subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
        userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
        uniSessionInfo = new UniSessionInfo(session, userRoleType);
        if (!uniSessionInfo.isSubSystemLoggedIn()) {
            response.sendError(401);
            return;
        }
        university = uniSessionInfo.getUniversity();
        uniStatus = UniStatus.fromValue(university.getUniStatus());
        if (uniStatus.getValue() < UniStatus.REGISTER_COMPLETED.getValue()) {
            response.sendError(403);
            return;
        }
    }

    if ("remove".equals(request.getParameter("action"))) {
        if (!removeSubAccess) {
            response.sendError(403);
            return;
        }
        ServiceFormRequest changingServiceFormRequest = ServiceFormRequestDAO.findServiceFormRequestById(Long.valueOf(request.getParameter("id")));
        if (isAdminPage || changingServiceFormRequest.getStatusVal() < ServiceFormRequestStatus.WAIT_FOR_SHOA_SIGNING.getValue())
            ServiceFormRequestDAO.delete(Long.valueOf(request.getParameter("id")));
    }
    List<ServiceFormRequest> serviceFormRequestList;
    List<ServiceContractTableRecord> serviceContractTableRecords = new LinkedList<>();
    String uniName = request.getParameter("uni-name");
    String stateName = request.getParameter("state");
    String cityName = request.getParameter("city");
    String stateId = request.getParameter("service");
    if (isAdminPage)

        serviceFormRequestList = ServiceFormRequestDAO.filterServiceFormRequestByUniId(uniName, stateName, cityName, stateId);
    else
        serviceFormRequestList = ServiceFormRequestDAO.findServiceFormRequestByUniId(university.getUniNationalId());

    if (!isAdminPage) {
        ServiceContractTableRecord serviceContractTableRecord = new ServiceContractTableRecord();
        serviceContractTableRecord.setServiceContractTableRecordType(ServiceContractTableRecordType.SUBS_CONTRACT);
        serviceContractTableRecord.setSubUni(university);
        serviceContractTableRecords.add(serviceContractTableRecord);
    }

    for (ServiceFormRequest serviceFormRequest : serviceFormRequestList) {
        ServiceContractTableRecord serviceContractTableRecord = new ServiceContractTableRecord();
        serviceContractTableRecord.setServiceContractTableRecordType(ServiceContractTableRecordType.SERVICE_FORM);
        serviceContractTableRecord.setServiceFormRequest(serviceFormRequest);
        serviceContractTableRecords.add(serviceContractTableRecord);
    }


%>

<table class="fixed-table table table-striped" id="customerTable" style="height: 500px">
    <thead style="height: 50px">
    <tr style="background: #337ab7;color: white;">
        <th style="width:30px">ردیف</th>
        <%if (isAdminPage) {%>
        <th>نام دانشگاه</th>
        <%}%>
        <th>عنوان</th>
        <th>وضعیت</th>
        <th>شماره</th>
        <th>تاریخ</th>
        <th>فرمت قرارداد</th>
        <th>قرارداد تک امضا</th>
        <th>قرارداد نهایی</th>
        <th>نامه روکش</th>
        <th>رسید پست</th>
        <th>عمیلیات</th>
    </tr>
    </thead>
    <tbody style="height: 450px">
    <%
        for (int i = 0; i < serviceContractTableRecords.size(); i++) {
            ServiceContractTableRecord serviceContractTableRecord = serviceContractTableRecords.get(i);
            ServiceFormRequest serviceFormRequestTable = null;
            University universityTable = null;
            boolean isServiceForm = serviceContractTableRecord.getServiceContractTableRecordType() == ServiceContractTableRecordType.SERVICE_FORM;
            if (isServiceForm) {
                serviceFormRequestTable = serviceContractTableRecord.getServiceFormRequest();
                universityTable = UniversityDAO.findUniByUniNationalId(serviceFormRequestTable.getUniId());
            } else {
                universityTable = serviceContractTableRecord.getSubUni();
            }
    %>
    <tr>
        <td style="width:30px">
            <%=i + 1%>
        </td>
        <%if (isAdminPage) {%>
        <td>
            <%=universityTable != null ? universityTable.getUniName() : "نامشخص"%>
        </td>
        <%}%>
        <td>
            <%
                String rowTitle = serviceContractTableRecord.getServiceContractTableRecordType().getFaStr();
                if (isServiceForm) {
                    rowTitle += "<br>";
                    ServiceFormParameter serviceFormParameter = ServiceFormParameterDAO.findServiceFormParameterById(serviceFormRequestTable.getServiceFormParameterId());
                    ServiceForm serviceForm = ServiceFormDAO.findServiceFormById(serviceFormParameter.getServiceFormId());
                    rowTitle += serviceForm.combine() + "-" + serviceFormParameter.getCode();
                }
            %>
            <%=rowTitle%>
        </td>
        <td>
            <%
                String statusStr = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getStatusVal() != null)
                        statusStr = ServiceFormRequestStatus.fromValue(serviceFormRequestTable.getStatusVal()).getFaStr();
                    else
                        statusStr = "نامشخص";
                } else {
                    statusStr = "-";
                }
            %>
            <%=statusStr%>
        </td>
        <td>
            <%
                String contractNo = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getServiceFormContractNo() != null)
                        contractNo = serviceFormRequestTable.getSubscriptionContractNo() + "/" + serviceFormRequestTable.getServiceFormContractNo();
                    else
                        contractNo = "تعیین نشده";
                } else {
                    contractNo = universityTable.getSubscriptionContractNo();
                }
            %>
            <%=contractNo%>
        </td>
        <td>
            <%
                String dateStr = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getSubscriptionDate() != null)
                        dateStr = Util.convertGregorianToJalaliNoWeekDay(serviceFormRequestTable.getServiceFormContractDate());
                    else
                        dateStr = "تعیین نشده";
                } else {
                    dateStr = Util.convertGregorianToJalaliNoWeekDay(universityTable.getSubscriptionContractDate());
                }
            %>
            <%=dateStr%>
        </td>
        <td>
            <%
                String printLink = null;
                if (isServiceForm)
                    printLink = "../pages/service-form-contract-print.jsp?request-id=" + serviceFormRequestTable.getId() +
                            (!isAdminPage ? "&sub-code=" + subSystemCode.getValue() : "");
            %>
            <a target="_blank"
               href="<%=printLink!=null?printLink:"#"%>" <%=printLink == null ? "onclick='return false;'" : ""%>>
                <img src="../images/pdf-icon<%=printLink == null ? "-dis" : ""%>.png"
                     style="width: 30px">
            </a>
        </td>
        <td>
            <%
                String singleSignServiceForm = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getSignedForm() != null)
                        singleSignServiceForm = String.format(
                                "../documents/get-service-form-request-docs.jsp?id=%s&type=%s&sub-code=%s",
                                serviceFormRequestTable.getId(),
                                ServiceFormRequestDocType.SIGNED_FORM.getValue(),
                                subSystemCode != null ? subSystemCode.getValue() : null);
                }
            %>
            <a target="_blank"
               href="<%=singleSignServiceForm!=null?singleSignServiceForm:"#"%>" <%=singleSignServiceForm == null ? "onclick='return false;'" : ""%>>
                <img src="../images/pdf-icon<%=singleSignServiceForm == null ? "-dis" : ""%>.png"
                     style="width: 30px">
            </a>
        </td>

        <td>
            <%
                String finalServiceForm = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getFinalSignedForm() != null)
                        finalServiceForm = String.format(
                                "../documents/get-service-form-request-docs.jsp?id=%s&type=%s&sub-code=%s",
                                serviceFormRequestTable.getId(),
                                ServiceFormRequestDocType.FINAL_SIGNED_FORM.getValue(),
                                subSystemCode != null ? subSystemCode.getValue() : null);
                } else
                    finalServiceForm = "../documents/get-signed-sub-form.jsp?id=" + universityTable.getUniNationalId();
            %>
            <a target="_blank"
               href="<%=finalServiceForm!=null?finalServiceForm:"#"%>" <%=finalServiceForm == null ? "onclick='return false;'" : ""%>>
                <img src="../images/pdf-icon<%=finalServiceForm == null ? "-dis" : ""%>.png"
                     style="width: 30px">
            </a>
        </td>
        <td>
            <%
                String letterLink = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getLetter() != null)
                        letterLink = "../documents/get-service-form-request-docs.jsp?id=" +
                                serviceFormRequestTable.getId() + "&type=" + ServiceFormRequestDocType.LETTER.getValue();
                } else
                    letterLink = "../documents/get-service-form-request-docs.jsp?sub-code=" + (subSystemCode != null ? subSystemCode.getValue() : null)
                            + "&type=" + ServiceFormRequestDocType.SUBS_LETTER.getValue();
            %>
            <a target="_blank"
               href="<%=letterLink!=null?letterLink:"#"%>" <%=letterLink == null ? "onclick='return false;'" : ""%>>
                <img src="../images/pdf-icon<%=letterLink == null ? "-dis" : ""%>.png" style="width: 30px">
            </a>
        </td>
        <td>
            <%
                String postRecLink = null;
                if (isServiceForm) {
                    if (serviceFormRequestTable.getPostReceipt() != null)
                        postRecLink = "../documents/get-service-form-request-docs.jsp?id=" +
                                serviceFormRequestTable.getId() + "&type=" + ServiceFormRequestDocType.POST_RECEIPT.getValue();
                } else
                    postRecLink = "../documents/get-service-form-request-docs.jsp?sub-code=" + (subSystemCode != null ? subSystemCode.getValue() : null)
                            + "&type=" + ServiceFormRequestDocType.SUBS_POST_RECEIPT.getValue();
            %>
            <a target="_blank"
               href="<%=postRecLink!=null?postRecLink:"#"%>" <%=postRecLink == null ? "onclick='return false;'" : ""%>>
                <img src="../images/pdf-icon<%=postRecLink == null ? "-dis" : ""%>.png" style="width: 30px">
            </a>
        </td>
        <td>
            <%if (isServiceForm) {%>
            <%
                boolean canRemoveRequest = (isAdminPage && removeSubAccess) || (!isAdminPage && serviceFormRequestTable.getStatusVal() < ServiceFormRequestStatus.WAIT_FOR_SHOA_SIGNING.getValue());
            %>
            <a href="#" <%=canRemoveRequest ? "data-toggle='modal' data-target='#removeModal" + i + "'" : ""%>>
                <img src="../images/delete<%=!canRemoveRequest ? "-dis" : ""%>.png" style="width: 30px">
            </a>
            <%if (canRemoveRequest) {%>
            <div class="modal fade infoModal" id="removeModal<%=i%>" role="dialog">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4>آیا مایل به حذف سرویس فرم هستید؟</h4>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                            <a href="requested-service-form.jsp?<%=!isAdminPage?"sub-code="+( subSystemCode != null ? subSystemCode.getValue() : null)+"&":""%>action=remove&id=<%=serviceFormRequestTable.getId()%>"
                               style="float: left;" class="btn btn-default">بله</a>
                        </div>
                    </div>
                </div>
            </div>
            <%}%>
            <%
                String uploadLink = "../pages/upload-service-form-doc.jsp?id=" + serviceFormRequestTable.getId() + (!isAdminPage ? "&sub-code=" + (subSystemCode != null ? subSystemCode.getValue() : null) : "");
            %>
            <a href="<%=uploadLink!=null?uploadLink:"#"%>" <%=uploadLink == null ? "onclick='return false;'" : ""%>>
                <img src="../images/upload<%=uploadLink == null ? "-dis" : ""%>.png" style="width: 30px">

            </a>

            <%}%>
        </td>
    </tr>
    <% }%>
    </tbody>
</table>