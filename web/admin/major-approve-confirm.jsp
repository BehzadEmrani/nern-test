<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.UniStatusLog" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Mailing" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
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
        } else {
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
    } else if (subSystemCode.equals(SubSystemCode.SEMINARY)) {
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue())) {
            response.sendError(403);
            return;
        } else {
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
    } else {
        response.sendError(404);
        return;
    }

    boolean isSendConfirm = "send-confirm".equals(request.getParameter("action"));
    University changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
    UniStatus changingUniStatus = UniStatus.SUBSCRIBE_PAGE;

    if (isSendConfirm) {
        changingUni.setUniStatus(changingUniStatus.getValue());
        changingUni = UniversityDAO.save(changingUni);
        UniStatusLog uniStatusLog = new UniStatusLog();
        uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
        uniStatusLog.setMessage("تغییر وضعیت به " + changingUniStatus.getFaStr());
        uniStatusLog.setUniStatus(changingUni.getUniStatus());
        uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
        uniStatusLog.setApprovalAdminId(admin.getId());
        uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
//        if ("on".equals(request.getParameter("send-mail")))
        Mailing.sendReqToSubsChangeMail(changingUni.getUniPublicEmail(), changingUni.getUniName(),
                changingUni.getTopManagerName(), request);
        request.getRequestDispatcher("major-approving.jsp").forward(request, response);
        return;
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
<form id="send-change" action="major-approve-confirm.jsp">
    <input type="hidden" name="action" value="send-confirm">
    <input type="hidden" name="id" value="<%=changingUni.getUniNationalId()%>">
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <div class="formBox">
        <h3>تایید دانشگاه</h3>
        <div class="formRow">
            <div class="formItem">
                <label>نوع تغییر :</label>
                <select class="formSelect formInputDeactive" name="uni-status" style="width: 400px;margin-left: 20px"
                        disabled>
                    <option value="<%=changingUniStatus.getValue()%>"><%="تغییر وضعیت به " + changingUniStatus.getFaStr()%>
                    </option>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>شناسه ملی:</label>
                <input class="formInput formInputDeactive" style="width: 200px;"
                       type="text" value="<%=changingUni.getUniNationalId()%>" disabled>
            </div>
            <div class="formItem" style="margin-right: 20px">
                <label>نام دانشگاه:</label>
                <input class="formInput formInputDeactive" style="width: 200px;"
                       type="text" value="<%=changingUni.getUniName()%>" disabled>
            </div>

        </div>
        <div class="formItem" style="margin-right: 10px">
            <input  type="checkbox" class="btn btn-primary formBtn" disabled checked>
            <label  style="margin-right: 5px">ارسال پست الکترونیکی به مشترک</label>
        </div>
        <div class="formRow">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <a href="http://localhost:8282/pages/approving.jsp?sub-code=0" class="btn btn-primary formBtn"
               style="margin-right: 10px;float: left">
                لغو
            </a>
        </div>
        <br style="clear: both">
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>