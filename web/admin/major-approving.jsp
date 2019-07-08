<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    if (subSystemCode.equals(SubSystemCode.HOSPITAL)) {
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue())) {

            response.sendError(403);
            return;
        }else{
            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.READ.getValue());
            removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.DELETE.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        }
    }else if(subSystemCode.equals(SubSystemCode.SEMINARY)){
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue())) {
            response.sendError(403);
            return;
        }else{
            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.READ.getValue());
            removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.DELETE.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        }
    }else{
        response.sendError(404);
        return;
    }


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
<div class="formBox" id="tableContainer" sub-code="<%=subSystemCode.getValue()%>">

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
<script src="js/major-approving.js"></script>
</body>
</html>