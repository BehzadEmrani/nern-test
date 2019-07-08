<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.ServiceFormRequestDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.ServiceFormRequest" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");

    boolean isAdminPage = false;

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
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue(),
                    AdminSubAccessType.EDIT.getValue());
            if(!editSubAccess){
                response.sendError(403);
                return;
            }
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

    ServiceFormRequest changingServiceRequestForm =
            ServiceFormRequestDAO.findServiceFormRequestById(Long.valueOf(request.getParameter("id")));

    if (ServletFileUpload.isMultipartContent(request)) {
        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        HashMap<String, String> uploadFields = new HashMap<>();
        HashMap<String, InputStream> uploadedFiles = new HashMap<>();
        for (FileItem item : items)
            if (item.isFormField())
                uploadFields.put(item.getFieldName(), item.getString("UTF-8"));
            else
                uploadedFiles.put(item.getFieldName(), item.getInputStream());
        if ("send-doc".equals(uploadFields.get("action"))) {
            changingServiceRequestForm.setSignedForm(IOUtils.toByteArray(uploadedFiles.get("signed-form")));
            changingServiceRequestForm.setStatusVal(ServiceFormRequestStatus.WAIT_FOR_SHOA_SIGNING.getValue());
            ServiceFormRequestDAO.save(changingServiceRequestForm);
            response.sendRedirect("requested-service-form.jsp?sub-code="+subSystemCode.getValue());
            return;
        } else if ("send-admin-doc".equals(uploadFields.get("action"))) {
            changingServiceRequestForm.setFinalSignedForm(IOUtils.toByteArray(uploadedFiles.get("signed-form")));
            changingServiceRequestForm.setPostReceipt(IOUtils.toByteArray(uploadedFiles.get("post-receipt")));
            changingServiceRequestForm.setLetter(IOUtils.toByteArray(uploadedFiles.get("letter")));
            changingServiceRequestForm.setStatusVal(ServiceFormRequestStatus.SERVICE_FORM_COMPLETED.getValue());
//            if("on".equals(uploadFields.get("send-mail")))
//                Mailing.sendGeneralUniStatusChangeMail()
            ServiceFormRequestDAO.save(changingServiceRequestForm);
            response.sendRedirect("../pages/requested-service-form.jsp");
            return;
        }
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
</head>
<body>
<form id="send-change-info" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="<%=isAdminPage?"send-admin-doc":"send-doc"%>">
    <input type="hidden" name="id" value="<%=changingServiceRequestForm.getId()%>">
    <%if (!isAdminPage) {%>
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <%}%>
    <div class="formBox">
        <div class="formRow">
            <div class="formRow formInputCon">
                <div class="formItem">
                    <label>قرارداد امضا شده :</label>
                    <a href="#" class="formFileInputBtn">
                        <img src="../images/file-choose.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                    <input type="file" name="signed-form" accept="application/pdf" class="formFileInput">
                </div>
                <div class="formItem">
                    <input class="formInput formFileInputTxt" id="formFileInput" style="width: 490px;" type="text">
                </div>
            </div>
        </div>
        <%if (isAdminPage) {%>
        <div class="formRow">
            <div class="formRow formInputCon">
                <div class="formItem">
                    <label>نامه روکش :</label>
                    <a href="#" class="formFileInputBtn">
                        <img src="../images/file-choose.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                    <input type="file" name="letter" accept="application/pdf" class="formFileInput">
                </div>
                <div class="formItem">
                    <input class="formInput formFileInputTxt" id="formFileInput" style="width: 490px;" type="text">
                </div>
            </div>
        </div>
        <div class="formRow">
            <div class="formRow formInputCon">
                <div class="formItem">
                    <label>رسید پستی :</label>
                    <a href="#" class="formFileInputBtn">
                        <img src="../images/file-choose.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                    <input type="file" name="post-receipt" accept="application/pdf" class="formFileInput">
                </div>
                <div class="formItem">
                    <input class="formInput formFileInputTxt" id="formFileInput" style="width: 490px;" type="text">
                </div>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <input style="margin-left: 10px" name="send-mail" type="checkbox" class="btn btn-primary formBtn">
                <label>آیا نامه ی الکترونیکی به مشترک ارسال شود؟</label>
            </div>
        </div>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="float:left;margin-right: 10px">
                <input type="submit" value="تایید" class="btn btn-primary formBtn">
            </div>
        </div>
        <br style="clear: both;">
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="./js/change-uni-state.js"></script>
</body>
</html>