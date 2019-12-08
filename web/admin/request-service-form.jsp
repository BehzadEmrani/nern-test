<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.ServiceDAO" %>
<%@ page import="com.atrosys.dao.ServiceFormRequestDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.Service" %>
<%@ page import="com.atrosys.entity.ServiceFormRequest" %>
<%@ page import="static com.atrosys.dao.UniversityDAO.findUniStatusByUniNationalId" %>
<%@ page import="static com.atrosys.dao.UniversityDAO.findUniStatusByUniNationalId" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!adminSessionInfo.isAdminLogedIn()) {
        response.sendError(403);
        return;
    }

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;

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



    if ("remove".equals(request.getParameter("action"))) {
        if (!removeSubAccess) {
            response.sendError(403);
            return;
        }
        ServiceFormRequest changingServiceFormRequest = ServiceFormRequestDAO.findServiceFormRequestById(Long.valueOf(request.getParameter("id")));
        if (changingServiceFormRequest.getStatusVal() < ServiceFormRequestStatus.WAIT_FOR_SHOA_SIGNING.getValue())
            ServiceFormRequestDAO.delete(Long.valueOf(request.getParameter("id")));
    }

    request.setCharacterEncoding("UTF-8");
    String message = null;
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

        .operatorBox a {
            margin: 0 2px;
        }

        .infoModal span {
            margin: 0 20px;
        }

        .infoModal {
            line-height: 30px;
        }
    </style>
</head>
<body>
<div class="formBox">
    <div class="formItem">
        <label>نام اصلی:</label>
        <input class="formInput" id="nameFilter"
               maxlength="20"
               style="width: 150px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label>استان :</label>
        <input class="formInput" id="stateFilter"
               maxlength="20"
               style="width: 100px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label>شهر :</label>
        <input class="formInput" id="cityFilter"
               maxlength="20"
               style="width: 100px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label>خدمت :</label>

        <select class="formSelect" id="serviceFilter" style="width: 150px;  margin-left: 20px;">
            <option value="-1">همه خدمت ها</option>
            <% for (Service service : ServiceDAO.findServicesByCatId(Long.valueOf("1"))) {%>
            <option value="<%=service.getId()%>">
                <%=service.getFaName()%>
            </option>
            <%}%>
        </select>
    </div>


    <!--...................................................................................-->

    <div class="formItem">
        <label>وضعیت :</label>
        <select class="formSelect" id="situationFilter" style="width: 150px; margin-left: 20px;">
            <option value="-1">همه وضعیت ها</option>
            <% for (ServiceFormRequestStatus serviceFormRequestStatus : ServiceFormRequestStatus.values()) {%>
            <option value="<%=serviceFormRequestStatus.getValue()%>">
                <%=serviceFormRequestStatus.getFaStr()%>
            </option>
            <%}%>
        </select>
    </div>

    <!--...................................................................................-->




    <button class="btn btn-primary" onclick="getTableData(0)">اعمال</button>
</div>
<div class="formBox" id="tableContainer" >
</div>
<!-- Modal -->
<div class="modal fade infoModal" id="infoModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body" id="infoModalBody" style="direction: rtl">
            </div>
        </div>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="mapModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <iframe src="" id="mapIframe" style="width: 100%;height: 90vh;"></iframe>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="logModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <div>
            <iframe src="" id="logIframe" style="width: 100%;height: 90vh;" allowfullscreen></iframe>
        </div>
    </div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="../pages/js/tariffs.js"></script>
<script src="js/request-service-form.js"></script>

</body>
</html>