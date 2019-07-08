<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.NewsDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.News" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="com.ibm.icu.util.Calendar" %>
<%@ page import="com.ibm.icu.util.PersianCalendar" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role="+ UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    News news = null;
    String message = null;
    NewsDest dest = NewsDest.fromStr(request.getParameter("dest"));
    if (dest == null)

        //file upload multi part request
        if (ServletFileUpload.isMultipartContent(request)) {
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            HashMap<String, String> uploadFields = new HashMap<>();
            HashMap<String, FileItem> uploadedFiles = new HashMap<>();
            for (FileItem item : items)
                if (item.isFormField()) {
                    String fieldname = item.getFieldName();
                    String fieldvalue = item.getString("UTF-8");
                    uploadFields.put(fieldname, fieldvalue);
                } else {
                    String fileName = item.getFieldName();
                    uploadedFiles.put(fileName, item);
                }
            dest = NewsDest.fromStr(uploadFields.get("dest"));
            if (dest == null) throw new Exception("dest Not Found");
            if (!(AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.MEDIA_NEWS.getValue()) && dest.equals(NewsDest.ABOUT_MEDIA))
                    && !(AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.STUDIO_SHOA_NEWS.getValue()) && dest.equals(NewsDest.ABOUT_OPERATOR))) {
                response.sendError(403);
                return;
            } else if (!(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.MEDIA_NEWS.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(NewsDest.ABOUT_MEDIA))
                    && !(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.STUDIO_SHOA_NEWS.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(NewsDest.ABOUT_OPERATOR))) {
                response.sendError(403);
                return;
            }
            if ("send-news".equals(uploadFields.get("action"))) {
                dest = NewsDest.fromStr(uploadFields.get("dest"));
                FileItem item = uploadedFiles.get("news-image");
                String url = null;
                if (item != null) {
                    int no = -1;
                    boolean pathFound = false;
                    String docFolder = request.getServletContext().getRealPath("/") + "images/news/";
                    String timeStamp = String.valueOf(System.currentTimeMillis());
                    String fileName = item.getName();
                    String ext = fileName.substring(fileName.indexOf('.'), fileName.length());
                    File file = null;
                    while (!pathFound) {
                        file = new File(docFolder + timeStamp + (no >= 0 ? "_" + no : "") + ext);
                        if (!file.exists())
                            pathFound = true;
                        else
                            no++;
                    }
                    try {
                        File temp = File.createTempFile(file.getName().substring(0, file.getName().lastIndexOf('.'))
                                , ext, new File(docFolder));
                        item.write(file);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    url = "images/news/" + file.getName();
                }
                news = new News();
                news.setTitle(uploadFields.get("title"));
                news.setImageURL(url);
                news.setEmphasize(uploadFields.get("emphasize"));
                news.setText(uploadFields.get("news-text"));
                java.sql.Date date = Util.convertJalaliToGregorian(
                        uploadFields.get("date-year") + "/" + uploadFields.get("date-mon") + "/" + uploadFields.get("date-day"));
                news.setDate(date);
                news.setNewsDest(dest.getValue());
                news.setSource(uploadFields.get("source"));
                NewsDAO.save(news);
            }
        }
    if (dest == null) throw new Exception("dest Not Found");
    if (!(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.MEDIA_NEWS.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(NewsDest.ABOUT_MEDIA))
            && !(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.STUDIO_SHOA_NEWS.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(NewsDest.ABOUT_OPERATOR))) {
        response.sendError(403);
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
<form onsubmit="return validateForm('#send-news');"
      id="send-form" method="post"
      enctype="multipart/form-data"
      action="add-news.jsp">
    <input type="hidden" name="action" value="send-news">
    <input type="hidden" name="dest" value="<%=dest.getStr()%>">
    <div class="formBox">
        <h3>
            اضافه کردن خبر به بخش
            "<%=dest.getFAStr()%>"
        </h3>
        <div class="formRow">
            <div class="formItem">
                <label>عنوان :</label>
                <input class="formInput" name="title"
                       maxlength="60"
                       style="width: 310px;margin-left: 20px;"
                       type="text">
            </div>
            <%if (!dest.equals(NewsDest.ABOUT_OPERATOR)) {%>
            <div class="formItem" style="margin-right: 10px">
                <label>منبع :</label>
                <input class="formInput" name="source"
                       maxlength="60"
                       style="width: 300px;margin-left: 20px;"
                       type="text">
            </div>
            <%}%>
            <div class="formItem formDatePicker">
                <label>تاریخ :</label>
                <%
                    PersianCalendar persianCalendar = new PersianCalendar(new Date());
                    int currentYear = persianCalendar.get(Calendar.YEAR);
                    int currentMonth = persianCalendar.get(Calendar.MONTH) + 1;
                    int currentDay = persianCalendar.get(Calendar.DAY_OF_MONTH);
                %>
                <select class="formSelect dateDay" name="date-day" style="width: 50px;"
                        current-date="<%=currentDay%>"></select>
                <select class="formSelect dateMon" name="date-mon"
                        style="width: 50px;">
                    <% for (int i = 1; i <= 12; i++) { %>
                    <option value="<%=i<10?"0"+i:i%>"<%=i == currentMonth ? " selected" : ""%>><%=i%>
                    </option>
                    <% } %>
                </select>
                <select class="formSelect dateYear" name="date-year"
                        style="width: 60px;">
                    <%
                        for (int i = 0; i >= -100; i--) {
                            int year = currentYear + i;
                    %>
                    <option value="<%=year%>"><%=year%>
                    </option>
                    <% } %>
                </select>
            </div>


            <div class="formRow">

                <div class="formItem formInputCon">
                    <label>تصویر خبر :</label>
                    <a href="#" class="formFileInputBtn">
                        <img src="../images/file-choose.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                    <input type="file" name="news-image" accept=".png,.jpg"
                           class="formFileInput">
                </div>
                <div class="formItem">
                    <input class="formInput formFileInputTxt"
                           style="width: 490px;"
                           type="text" name="file-name"
                           readonly>
                </div>
            </div>
            <div>
                <label style="float: right;">خلاصه ی خبر :</label>
                <textarea class="formRow" name="emphasize" rows="4"
                          style="border: 1px solid black;width: 100%"> </textarea>
            </div>
            <div style="margin-bottom: 20px">
                <label style="float: right;">متن خبر :</label>
                <textarea class="formRow" name="news-text" rows="4"
                          style="border: 1px solid black;width: 100%"> </textarea>
            </div>
            <div class="formRow" style=" display: table; width: 100%;">
                <input type="submit" value="اضافه کردن خبر" class="btn btn-primary formBtn"
                       style="margin-right: 10px;float: left">
            </div>
        </div>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>