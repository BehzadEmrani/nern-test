<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.InfoDocDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.InfoDoc" %>
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
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role="+ UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    InfoDoc infoDoc = null;
    String message = null;
    InfoDocDest dest = InfoDocDest.fromStr(request.getParameter("dest"));
    if (!(AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.DOC_INFO.getValue()) && dest.equals(InfoDocDest.INFO_DOCS))
            && !(AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.DOC_PUBLIC_PRIVATE.getValue()) && dest.equals(InfoDocDest.ABOUT_DOCS))) {
        response.sendError(403);
        return;
    } else if (!(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.DOC_INFO.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(InfoDocDest.INFO_DOCS))
            && !(AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.DOC_PUBLIC_PRIVATE.getValue(), AdminSubAccessType.ADD.getValue()) && dest.equals(InfoDocDest.ABOUT_DOCS))) {
        response.sendError(403);
        return;
    }
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
        if ("send-doc".equals(uploadFields.get("action"))) {
            dest = InfoDocDest.fromStr(uploadFields.get("dest"));
            FileItem item = uploadedFiles.get("doc");
            int no = -1;
            boolean pathFound = false;
            String docFolder = request.getServletContext().getRealPath("/") + "documents/";
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
            String url = "documents/" + file.getName();
            infoDoc = new InfoDoc();
            infoDoc.setFileURL(url);
            infoDoc.setOwner(uploadFields.get("owner"));
            infoDoc.setDescription(uploadFields.get("description"));
            java.sql.Date date = Util.convertJalaliToGregorian(
                    uploadFields.get("date-year") + "/" + uploadFields.get("date-mon") + "/" + uploadFields.get("date-day"));
            infoDoc.setPubDate(date);
            infoDoc.setTitle(uploadFields.get("title"));
            infoDoc.setWriter(uploadFields.get("writer"));
            infoDoc.setDocDest(dest.getValue());
            InfoDocDAO.save(infoDoc);
        }
    }
    if (dest == null) throw new Exception("dest Not Found");
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
<form onsubmit="return validateForm('#send-doc');"
      id="send-form" method="post"
      enctype="multipart/form-data"
      action="add-doc.jsp">
    <input type="hidden" name="action" value="send-doc">
    <input type="hidden" name="dest" value="<%=dest.getStr()%>">
    <div class="formBox">
        <h3>
            اضافه کردن سند به بخش
            "<%=dest.getFAStr()%>"
        </h3>
        <div class="formRow">
            <div class="formItem">
                <label>موضوع :</label>
                <input class="formInput" name="title"
                       maxlength="60"
                       style="width: 320px;margin-left: 20px;"
                       type="text">
            </div>
            <div class="formItem formDatePicker">
                <label>تاریخ انتشار :</label>
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
        </div>

        <div class="formRow">
            <div class="formItem">
                <label>صاحب اثر :</label>
                <input class="formInput" name="owner"
                       maxlength="60"
                       style="width: 320px;margin-left: 20px;"

                       type="text">
            </div>
            <div class="formItem">
                <label>نویسنده/مترجم :</label>
                <input class="formInput" name="writer"
                       maxlength="60"
                       style="width: 320px;margin-left: 20px;"
                       type="text">
            </div>

        </div>

        <div class="formRow">

            <div class="formItem formInputCon">
                <label>فایل سند :</label>
                <a href="#" class="formFileInputBtn">
                    <img src="../images/file-choose.png"
                         style="margin-bottom: 3px;margin-left: 3px;">
                </a>
                <input type="file" name="doc" accept=".pdf,.doc,.docx"
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
            <label style="float: right;">شرح مختصر :</label>
            <textarea class="formRow" name="description" rows="4"
                      style="display: inline;border: 1px solid black;margin-right: 5px;max-width: 750px;width: 100%"> </textarea>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="اضافه کردن سند" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
    </div>
</form>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>