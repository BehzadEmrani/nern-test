<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.UniStatusLog" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UniStatus" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="com.atrosys.util.Mailing" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    UserRoleType userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, userRoleType);
    University university = uniSessionInfo.getUniversity();
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        response.sendError(401);
        return;
    }
    if (!UniversityDAO.doesUniHaveAccessToApproveUni(university.getUniNationalId(), Long.valueOf(request.getParameter("id")))) {
        response.sendError(403);
        return;
    }
    boolean isSendConfirm = "send-confirm".equals(request.getParameter("action"));
    University changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
    UniStatus changingUniStatus = UniStatus.REGISTER_SECOND_RELATED_ORGAN;

    if (isSendConfirm) {
        changingUni.setUniStatus(changingUniStatus.getValue());
        changingUni = UniversityDAO.save(changingUni);
        UniStatusLog uniStatusLog = new UniStatusLog();
        uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
        uniStatusLog.setMessage("تغییر وضعیت به " + changingUniStatus.getFaStr());
        uniStatusLog.setUniStatus(changingUni.getUniStatus());
        uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
        uniStatusLog.setApprovalId(university.getUniNationalId());
        uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
//        if ("on".equals(request.getParameter("send-mail")))
        String organStr="";
        if(changingUni.getUniSubSystemCode().equals(SubSystemCode.HOSPITAL.getValue()))
            organStr="وزارت بهداشت";
         if(changingUni.getUniSubSystemCode().equals(SubSystemCode.HOSPITAL.getValue()))
             organStr="مرکز حوزه های علمیه";
        Mailing.sendReqToOrganChangeMail(changingUni.getUniPublicEmail(), changingUni.getUniName(),
                changingUni.getTopManagerName(),organStr,university.getUniName(), request);
        request.getRequestDispatcher("approving.jsp").forward(request, response);
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
<form id="send-change" action="approve-confirm.jsp">
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