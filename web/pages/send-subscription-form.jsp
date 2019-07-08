<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.UniStatusLog" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UniStatus" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
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
    request.setCharacterEncoding("UTF-8");
    SubSystemCode subSystemCode = null;
    String message = null;
    boolean waitForVerify = false;
    boolean isError = false;
    University university = null;
    UniSessionInfo uniSessionInfo = null;
    if (!ServletFileUpload.isMultipartContent(request)) {
        subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
        uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
    } else {
        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        HashMap<String, String> uploadFields = new HashMap<>();
        HashMap<String, InputStream> uploadedFiles = new HashMap<>();
        for (FileItem item : items)
            if (item.isFormField()) {
                String fieldname = item.getFieldName();
                String fieldvalue = item.getString("UTF-8");
                uploadFields.put(fieldname, fieldvalue);
            } else {
                String fileName = item.getFieldName();
                InputStream inputStream = item.getInputStream();
                uploadedFiles.put(fileName, inputStream);
            }
        subSystemCode = SubSystemCode.fromValue(Integer.valueOf(uploadFields.get("sub-code")));
        uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
        if ("send-form".equals(uploadFields.get("action"))) {
            byte[] bytes = IOUtils.toByteArray(uploadedFiles.get("form"));
            if (bytes != null) {
                university = UniversityDAO.findUniByUniNationalId(uniSessionInfo.getUniversity().getUniNationalId());
                university.setSubscriptionForm(bytes);
                university.setUniStatus(UniStatus.SUBSCRIBE_PAGE_VERIFY.getValue());
                UniversityDAO.save(university);
                UniStatusLog uniStatusLog = new UniStatusLog();
                uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                uniStatusLog.setMessage(String.format(university.getUniName() + " فرم درخواست اشتراک را تکمیل کرد."));
                uniStatusLog.setUniStatus(university.getUniStatus());
                uniStatusLog.setUniNationalId(university.getUniNationalId());
                uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
                waitForVerify = true;
            }
        }
    }
    //check access to page
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    } else if (uniSessionInfo.getUniversity() == null) {
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    } else if (uniSessionInfo.getUniversity().getUniStatus() == UniStatus.SUBSCRIBE_PAGE_VERIFY.getValue()) {
        waitForVerify = true;
    } else if (uniSessionInfo.getUniversity().getUniStatus() == UniStatus.SUBSCRIBE_PAGE_ERROR.getValue()) {
        isError = true;
        university = uniSessionInfo.getUniversity();
    } else if (uniSessionInfo.getUniversity().getUniStatus() != UniStatus.SUBSCRIBE_PAGE.getValue()) {
        request.getRequestDispatcher("register.jsp").forward(request, response);
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<div class="formBox" style="padding-bottom:40px;">
    <% if (waitForVerify) {%>
    <h3 style="color: #c00;text-align: center;">فرم اشتراک شما در حال بررسی توسط اپراتور شبکه علمی ایران میباشد. <br>لطفا
        جهت اطلاع از آخرین
        وضعیت احتمالی به <u>پست
            الکترونیکی عمومی</u> اعلام شده در فرم الکترونیکی عضویت مراجعه فرمائید.</h3>
    <% } else { %>
    <% if (isError) {
        String topMessage = UniStatusLogDAO.findUniStatusLogById(university.getUniStatusLog()).getMessage();
        if (topMessage.isEmpty())
            topMessage = "اصلاح قرارداد اشتراک";
    %>
    <h3 style="color: #c00;text-align: right;">اصلاحات درخواستی در کاربرگ اشتراک:<br></h3>
    <pre style="color: #c00;text-align: right;text-indent: 0;font-size: 12px;"><%=topMessage%></pre>
    <%} else {%>
    <div class="formRow" style="color: green;font-size: 18pt;">
        خوش آمدید !
    </div>
    <%} %>
    <div class="formRow">
        <br>
        لطفا با کلیک بر روی آیکون زیر فرم اشتراک شبکه علمی ایران را دانلود و در
        <b><u> دونسخه</u></b>
        پرینت فرمایید
        <br>
        <br>
        پس از امضاء و مهر توسط مقام مجاز فرم مذکور را به صورت الکترونیکی و در فرمت PDF (بدون امکان اصلاح) از طریق همین
        صفحه آپلود نمایید
        <img src="../images/help.png" style="width: 20px;">
    </div>
    <form onsubmit="return validateForm('#send-form');" id="send-form"
          method="post"
          enctype="multipart/form-data"
          action="send-subscription-form.jsp">
        <input type="hidden" name="action" value="send-form">
        <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
        <div class="formRow formInputCon">
            <div class="formItem">
                <label>فرم اشتراک :</label>
                <a href="subs-form-contract-print.jsp?sub-code=<%=subSystemCode.getValue()%>"
                   target="-_blank">
                    <img src="../images/get-form.png">
                </a>
                <a href="#" class="formFileInputBtn">
                    <img src="../images/file-choose.png"
                         style="margin-bottom: 3px;margin-left: 3px;">
                </a>
                <input type="file" name="form" accept="application/pdf" class="formFileInput">
            </div>
            <div class="formItem">
                <input class="formInput formFileInputTxt" id="formFileInput" style="width: 490px;" type="text">
            </div>
        </div>
        <p style="color:#c00">
            پس از ارسال الکترونیکی فرم اشتراک، حداکثر ظرف سه روز کاری، هر دو نسخه‌ی فرم اشتراک کاغذی را به نشانی
            تهران ، خیابان بهشتی ، خیابان مفتح شمالی ، پلاک 390 ، واحد 44، کدپستی 1587815141 شرکت خدمات و ارتباطات شبکه
            علمی ارسال نمایید.
            <br>
            <br>
            پس از دریافت نسخه‌های کاغذی یک نسخه از فرم اشتراک توسط اپراتور امضا و مهر شده و ضمن آپلود در سامانه به نشانی
            آن مشترک محترم از طریق پست ارسال خواهد شد.
            <br>
            <br>
             بدیهی است تا قبل از دریافت فرم اشتراک کاغذی، با توجه به قوانین فعلی کشور، عضویت شما قطعی نشده است. لیکن در
            این مرحله می‌توانید فعالیت‌های خود در شبکه علمی ایران را آغاز نمایید.
        </p>
        <div class="formRow" style="display: block;">
            <input type="submit" value="تایید ارسال فرم اشتراک" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left;"/>
        </div>
    </form>
    <%}%>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>