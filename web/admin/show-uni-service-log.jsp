<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();

    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.CRA_UNIVERSITY.getValue(), AdminSubAccessType.READ.getValue())) {
        response.sendError(403);
        return;
    }

    University university = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));


    List<ServiceFormRequest> serviceFormRequestList;
    List<ServiceContractTableRecord> serviceContractTableRecords = new LinkedList<>();

    serviceFormRequestList = ServiceFormRequestDAO.findServiceFormRequestByUniId(university.getUniNationalId());
    ServiceContractTableRecord serviceContractTableRecord = new ServiceContractTableRecord();
    serviceContractTableRecord.setServiceContractTableRecordType(ServiceContractTableRecordType.SUBS_CONTRACT);
    serviceContractTableRecord.setSubUni(university);
    serviceContractTableRecords.add(serviceContractTableRecord);

    for (ServiceFormRequest serviceFormRequest : serviceFormRequestList) {
        serviceContractTableRecord = new ServiceContractTableRecord();
        serviceContractTableRecord.setServiceContractTableRecordType(ServiceContractTableRecordType.SERVICE_FORM);
        serviceContractTableRecord.setServiceFormRequest(serviceFormRequest);
        serviceContractTableRecords.add(serviceContractTableRecord);
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
        .logItem {
            border: 1px solid #41709c;
            margin: 10px;
            padding: 10px;
        }

        .myHeading {
            color: #4cae4c;
        }

        .myData {
            margin: 10px;
            padding: 10px;
        }

        pre {
            white-space: pre-wrap; /* Since CSS 2.1 */
            white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
            white-space: -o-pre-wrap; /* Opera 7 */
            word-wrap: break-word; /* Internet Explorer 5.5+ */
        }
    </style>
</head>
<body>
<form id="send-change" method="post" action="change-uni-state.jsp">
    <div class="formBox">
        <h3>گزارش سرویس های "<%=university.getUniName()%>"</h3>
        <%
            for (int i = 0; i < serviceContractTableRecords.size(); i++) {
                serviceContractTableRecord = serviceContractTableRecords.get(i);
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
        <div class="logItem">
            <p>
                <span class="myHeading">
                    تاریخ ثبت درخواست:
                </span>
                <%
                    String dateStr = null;
                    if (isServiceForm) {
                        if (serviceFormRequestTable.getSubscriptionDate() != null)
                            if(serviceFormRequestTable.getSubscriptionDate().toString() != "null") {
                                dateStr = Util.convertGregorianToJalali(serviceFormRequestTable.getServiceFormContractDate());
                            }
                            else {
                                dateStr = "تعیین نشده";
                            }
                        else
                            dateStr = "تعیین نشده";
                    } else {
                        dateStr = Util.convertGregorianToJalali(universityTable.getSubscriptionContractDate());
                    }
                %>
                <%="  "+dateStr%>
            </p>
            <p>
                <span class="myHeading">
                    عنوان:
                </span>
                <%
                    String rowTitle = serviceContractTableRecord.getServiceContractTableRecordType().getFaStr();
                    if (isServiceForm) {
                        rowTitle += "<br>";
                        ServiceFormParameter serviceFormParameter = ServiceFormParameterDAO.findServiceFormParameterById(serviceFormRequestTable.getServiceFormParameterId());
                        ServiceForm serviceForm = ServiceFormDAO.findServiceFormById(serviceFormParameter.getServiceFormId());
                        rowTitle += serviceForm.faCombine() + "-" + serviceFormParameter.getSpecs();
                    }
                %>
                <%=rowTitle%>
            </p>
            <div>
                <p class="myHeading">مدارک:</p>
                <div>
                    <span class="myData"> فرمت قرارداد:
                        <%
                            String printLink = null;
                            if (isServiceForm)
                                printLink = "service-form-contract-print.jsp?request-id=" + serviceFormRequestTable.getId() + "";
                        %>
                        <a target="_blank"
                           href="<%=printLink!=null?printLink:"#"%>" <%=printLink == null ? "onclick='return false;'" : ""%>>
                            <img src="../images/pdf-icon<%=printLink == null ? "-dis" : ""%>.png"
                                 style="width: 30px">
                        </a>
                    </span>

                    <span class="myData"> قرارداد تک امضا:
                        <%
                            String singleSignServiceForm = null;
                            if (isServiceForm) {
                                if (serviceFormRequestTable.getSignedForm() != null)
                                    singleSignServiceForm = String.format(
                                            "../documents/get-service-form-request-docs.jsp?id=%s&type=%s&sub-code=%s",
                                            serviceFormRequestTable.getId(),
                                            ServiceFormRequestDocType.SIGNED_FORM.getValue(), null);
                            }
                        %>
                        <a target="_blank"
                           href="<%=singleSignServiceForm!=null?singleSignServiceForm:"#"%>" <%=singleSignServiceForm == null ? "onclick='return false;'" : ""%>>
                            <img src="../images/pdf-icon<%=singleSignServiceForm == null ? "-dis" : ""%>.png"
                                 style="width: 30px">
                        </a>
                    </span>

                    <span class="myData"> قرارداد نهایی:
                        <%
                            String finalServiceForm = null;
                            if (isServiceForm) {
                                if (serviceFormRequestTable.getFinalSignedForm() != null)
                                    finalServiceForm = String.format(
                                            "../documents/get-service-form-request-docs.jsp?id=%s&type=%s&sub-code=%s",
                                            serviceFormRequestTable.getId(),
                                            ServiceFormRequestDocType.FINAL_SIGNED_FORM.getValue(), null);
                            } else
                                finalServiceForm = "../documents/get-signed-sub-form.jsp?id=" + universityTable.getUniNationalId();
                        %>
                        <a target="_blank"
                           href="<%=finalServiceForm!=null?finalServiceForm:"#"%>" <%=finalServiceForm == null ? "onclick='return false;'" : ""%>>
                            <img src="../images/pdf-icon<%=finalServiceForm == null ? "-dis" : ""%>.png"
                                 style="width: 30px">
                        </a>
                    </span>

                    <span class="myData">نامه روکش:
                        <%
                            String letterLink = null;
                            if (isServiceForm) {
                                if (serviceFormRequestTable.getLetter() != null)
                                    letterLink = "../documents/get-service-form-request-docs.jsp?id=" +
                                            serviceFormRequestTable.getId() + "&type=" + ServiceFormRequestDocType.LETTER.getValue();
                            } else
                                letterLink = "../documents/get-service-form-request-docs.jsp?sub-code="
                                        + "&type=" + ServiceFormRequestDocType.SUBS_LETTER.getValue();
                        %>
                        <a target="_blank"
                           href="<%=letterLink!=null?letterLink:"#"%>" <%=letterLink == null ? "onclick='return false;'" : ""%>>
                            <img src="../images/pdf-icon<%=letterLink == null ? "-dis" : ""%>.png" style="width: 30px">
                        </a>
                    </span>

                    <span class="myData">رسید پست:
                        <%
                            String postRecLink = null;
                            if (isServiceForm) {
                                if (serviceFormRequestTable.getPostReceipt() != null)
                                    postRecLink = "../documents/get-service-form-request-docs.jsp?id=" +
                                            serviceFormRequestTable.getId() + "&type=" + ServiceFormRequestDocType.POST_RECEIPT.getValue();
                            } else
                                postRecLink = "../documents/get-service-form-request-docs.jsp?sub-code="
                                        + "&type=" + ServiceFormRequestDocType.SUBS_POST_RECEIPT.getValue();
                        %>
                        <a target="_blank"
                           href="<%=postRecLink!=null?postRecLink:"#"%>" <%=postRecLink == null ? "onclick='return false;'" : ""%>>
                            <img src="../images/pdf-icon<%=postRecLink == null ? "-dis" : ""%>.png" style="width: 30px">
                        </a>
                    </span>
                </div>
            </div>

<%--            <%if (uniStatusLog.getUniStatus() != null) {%>--%>
<%--            <p>تغییر وضعیت به :--%>
<%--                <%=UniStatus.fromValue(uniStatusLog.getUniStatus()).getFaStr()%>--%>
<%--            </p>--%>
<%--            <% }%>--%>
<%--            <%if (uniStatusLog.getUniSubStatus() != null) { %>--%>
<%--            <p>تغییر زیر وضعیت به :--%>
<%--                <%=UniSubStatus.fromValue(uniStatusLog.getUniSubStatus()).getFaStr()%>--%>
<%--            </p>--%>
<%--            <%}%>--%>
<%--            <p>شناسه ملی :--%>
<%--                <%=uniStatusLog.getUniNationalId()%>--%>
<%--            </p>--%>
<%--            <p>توسط :--%>
<%--                <%--%>
<%--                    String operator;--%>
<%--                    if (uniStatusLog.getApprovalId() != null) {--%>
<%--                        University operatorUni = UniversityDAO.findUniByUniNationalId(uniStatusLog.getApprovalId());--%>
<%--                        operator = operatorUni.getUniName() + " (" + operatorUni.getUniNationalId() + ")";--%>
<%--                    } else if (uniStatusLog.getApprovalAdminId() != null) {--%>
<%--                        Admin operatorAdmin = AdminDAO.findAdminByid(uniStatusLog.getApprovalAdminId());--%>
<%--                        UserRole operatorUserRole = UserRoleDAO.findUserRoleById(operatorAdmin.getRoleId());--%>
<%--                        PersonalInfo operatorPersonal = PersonalInfoDAO.findPersonalInfoByNationalId(operatorUserRole.getNationalId());--%>
<%--                        operator = operatorPersonal.combineName() + " (" + operatorPersonal.getUsername() + ")";--%>
<%--                    } else--%>
<%--                        operator = "نامشخص";--%>
<%--                %>--%>
<%--                <%=operator%>--%>
<%--            </p>--%>
<%--            <p>--%>
<%--                پیام :--%>
<%--            </p>--%>
<%--            <pre><%=uniStatusLog.getMessage()%></pre>--%>
        </div>
        <% }%>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>