<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.FeedBackDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.FeedBack" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SEND_FEED_BACK.getValue())) {
        response.sendError(403);
        return;
    }

    boolean addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SEND_FEED_BACK.getValue(), AdminSubAccessType.ADD.getValue());
    boolean readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SEND_FEED_BACK.getValue(), AdminSubAccessType.READ.getValue());

    request.setCharacterEncoding("UTF-8");
    String message = null;
    try {
        if (ServletFileUpload.isMultipartContent(request)) {
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            HashMap<String, String> uploadFields = new HashMap<>();
            HashMap<String, InputStream> uploadedFiles = new HashMap<>();
            String extension = null;
            boolean fileUploaded = false;
            for (FileItem item : items)
                if (item.isFormField())
                    uploadFields.put(item.getFieldName(), item.getString("UTF-8"));
                else {
                    String fileName = item.getName();
                    if (!fileName.isEmpty()) {
                        fileUploaded = true;
                        if (fileName.lastIndexOf('.') != -1)
                            extension = fileName.substring(fileName.lastIndexOf('.'), fileName.length());
                    }
                    uploadedFiles.put(item.getFieldName(), item.getInputStream());
                }
            if ("send-feed".equals(uploadFields.get("action"))) {
                if (!addSubAccess) {
                    response.sendError(403);
                    return;
                }
                FeedBack feedBack = new FeedBack();
                feedBack.setAdminId(admin.getId());
                if (fileUploaded) {
                    byte[] bytes = IOUtils.toByteArray(uploadedFiles.get("attach-file"));
                    feedBack.setAttachedFileExtension(extension);
                    feedBack.setAttachedFile(bytes);
                }
                feedBack.setDescription(uploadFields.get("desc"));
                feedBack.setPageAddress(uploadFields.get("page-address"));
                feedBack.setStatus(FeedBackStatus.WORKING_ON.getValue());
                feedBack.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                FeedBackDAO.save(feedBack);
            }
        }
    } catch (Exception e) {
        message = "خطای ناگهانی";
    }
    List<FeedBack> feedBacks = null;
    if (readSubAccess)
        feedBacks = FeedBackDAO.findAllFeedBacks();
    else
        feedBacks = FeedBackDAO.findAllFeedBacksByAdminId(admin.getId());
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
<form id="send-form" onsubmit="return validateForm('#send-form')" enctype="multipart/form-data" method="post"
      action="manage-feed-back.jsp">
    <input type="hidden" name="action" value="send-feed">
    <%if (addSubAccess) {%>
    <div class="formBox">
        <h3>اعلام خطا</h3>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formRow">
                <label>نام یا آدرس صفحه :</label>
                <input class="formInput" name="page-address"
                       maxlength="60"
                       style="width: 260px;margin-right: 20px"
                       type="text">
            </div>
            <br>
            <div class="formRow">
                <label>توضیحات خطا :</label>
                <textarea name="desc" maxlength="2000"
                          style="width: 100%;height: 200px"></textarea>
            </div>
            <br>
            <div class="formRow">
                <label>ضمیمه ی فایل :</label>
                <input type="file" name="attach-file" style="display: inline-block;margin-right: 20px;"/>
                <div class="formItem" style="float:left;margin-right: 10px">
                    <input type="submit" value="تایید" class="btn btn-primary formBtn">
                </div>
            </div>

            <br style="clear: both;">
        </div>
    </div>
    <%}%>
</form>
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
                <%=String.format("مشکل در تاریخ %s برطرف شده",Util.convertTimeStampToJalali(feedBack.getRepairTimeStamp()))%>
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
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>