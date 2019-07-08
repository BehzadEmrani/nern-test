<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.FeedBackDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.FeedBack" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.List" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.TECH_ERROR_HANDLING.getValue())) {
        response.sendError(403);
        return;
    }
    boolean editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_ERROR_HANDLING.getValue(), AdminSubAccessType.EDIT.getValue());
    boolean readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.TECH_ERROR_HANDLING.getValue(), AdminSubAccessType.READ.getValue());

    if ("correct-feed".equals(request.getParameter("action"))) {
        FeedBack correctingFeedBack = FeedBackDAO.findFeedBackById(Long.valueOf(request.getParameter("feed-id")));
        correctingFeedBack.setStatus(FeedBackStatus.CORRECTED.getValue());
        correctingFeedBack.setRepairTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
        FeedBackDAO.save(correctingFeedBack);
    }

    request.setCharacterEncoding("UTF-8");
    List<FeedBack> feedBacks = FeedBackDAO.findAllFeedBacks();
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
<%if (readSubAccess) {%>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام صفحه</th>
            <th style="width:220px;">زمان ثبت</th>
            <th style="width:300px;">وضعیت</th>
            <th style="width:70px">توضیحات</th>
            <th style="width:70px">فایل ضمیمه</th>
            <th style="width:70px">اعلام اصلاح</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < feedBacks.size(); i++) {
                FeedBack feedBack = feedBacks.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=feedBack.getPageAddress()%>
            </td>

            <td style="width:220px;">
                <%=Util.convertTimeStampToJalali(feedBack.getTimeStamp())%>
            </td>
            <td style="width:300px;">
                <%
                    FeedBackStatus feedBackStatus = FeedBackStatus.fromValue(feedBack.getStatus());
                    if (feedBackStatus.equals(FeedBackStatus.WORKING_ON)) {
                %>
                <%=FeedBackStatus.fromValue(feedBack.getStatus()).getFaStr()%>
                <%} else if (feedBackStatus.equals(FeedBackStatus.CORRECTED)) {%>
                <%=String.format("مشکل در تاریخ %s برطرف شده", Util.convertTimeStampToJalali(feedBack.getRepairTimeStamp()))%>
                <%}%>
            </td>
            <td style="width:70px">
                <a href="#" data-toggle="modal"
                   data-target="#descModal<%=i%>">
                    <img src="../images/desc.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade" id="descModal<%=i%>" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-body">
                                <pre style="color: #c00;text-align: right;text-indent: 0"><%=feedBack.getDescription()%></pre>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
            <td style="width:70px">
                <%if (feedBack.getAttachedFile() == null) {%>
                ندارد
                <%} else {%>
                <a href="../files/feed-back.jsp?id=<%=feedBack.getId()%>"
                   download="<%="error"+feedBack.getId()+
                   (feedBack.getAttachedFileExtension()!=null?feedBack.getAttachedFileExtension():"")%>">
                    <img src="../images/download.png" style="width: 30px">
                </a>
                <%}%>
            </td>
            <td style="width:70px">
                <a href="tech-manage-feed-back.jsp?action=correct-feed&feed-id=<%=feedBack.getId()%>" <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/check<%=editSubAccess?"":"-dis"%>.png" style="width: 30px">
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>