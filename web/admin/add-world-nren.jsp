<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.CountryDAO" %>
<%@ page import="com.atrosys.dao.WorldNrenDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.Country" %>
<%@ page import="com.atrosys.entity.WorldNren" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.WORLD_NRERN.getValue())) {
        response.sendError(403);
        return;
    } else if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.WORLD_NRERN.getValue(), AdminSubAccessType.ADD.getValue())) {
        response.sendError(403);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;
    ArrayList<Country> countries = null;
    Country sentCountry = null;
    WorldNren countryNren = null;
    boolean isCountrySent = false;
    boolean nrenHadImage = false;

    try {
        countries = CountryDAO.findAllCountries();
    } catch (Exception e) {
        message = "خطای نامشخص";
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
        if ("send-nren".equals(uploadFields.get("action"))) {
            String url = null;
            countryNren = WorldNrenDAO.findNrenByCountryId(uploadFields.get("country-id"));
            if (Boolean.valueOf(uploadFields.get("do-edit"))) {
                FileItem item = uploadedFiles.get("image");
                if (!item.getName().isEmpty()) {
                    boolean pathFound = false;
                    String imageFolder = request.getServletContext().getRealPath("/") + "images/nrens/";
                    String fileName = item.getName();
                    String ext = fileName.substring(fileName.lastIndexOf('.'), fileName.length());
                    File file = null;
                    file = new File(imageFolder + uploadFields.get("country-id") + ext);
                    for (File parentFile : file.getParentFile().listFiles())
                        if (parentFile.getName().substring(0, parentFile.getName().lastIndexOf('.'))
                                .equals(file.getName().substring(0, file.getName().lastIndexOf('.'))))
                            parentFile.delete();
                    File.createTempFile(file.getName(), null);
                    item.write(file);
                    url = "images/nrens/" + file.getName();
                }
            }

            WorldNren worldNren = new WorldNren();
            worldNren.setCountryId(uploadFields.get("country-id"));
            worldNren.setNernName(uploadFields.get("nren-name"));
            worldNren.setImageURL(url != null ? url : countryNren != null ? countryNren.getImageURL() : null);
            worldNren.setSiteURL(uploadFields.get("nren-site"));
            worldNren.setDescription(uploadFields.get("description"));
            WorldNrenDAO.save(worldNren);
        }
    } else if ("send-country".equals(request.getParameter("action"))) {
        sentCountry = CountryDAO.findCountryByID(request.getParameter("country-id"));
        countryNren = WorldNrenDAO.findNrenByCountryId(request.getParameter("country-id"));
        if (countryNren != null)
            if (countryNren.getImageURL() != null)
                if (!countryNren.getImageURL().isEmpty())
                    nrenHadImage = true;
        isCountrySent = true;
    }
    List<WorldNren> worldNrens = WorldNrenDAO.findAllNrens();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
<form
        id="send-nren" method="post"
        enctype="<%=!isCountrySent?"application/x-www-form-urlencoded":"multipart/form-data"%>"
        action="add-world-nren.jsp">
    <%if (isCountrySent) {%>
    <input type="hidden" name="action" value="send-nren">
    <%} else {%>
    <input type="hidden" name="action" value="send-country">
    <%}%>
    <div class="formBox">
        <h3>اضافه کردن شبکه علمی کشورهای جهان</h3>
        <div class="formRow" style="">
            <div class="formItem formDatePicker">
                <label>نام کشور:</label>
                <select class="formSelect<%=isCountrySent?" formInputDeactive":""%>" id="country-select"
                        name="country-id" style="width: 200px;">
                    <%if (!isCountrySent) {%>
                    <option value="" disabled selected hidden>کشور مورد نظر را انتخاب کنید&nbsp;...</option>
                    <% for (Country country : countries)
                        if (!country.getFaName().isEmpty()) { %>
                    <option value="<%=country.getCountryId()%>">
                        <%=country.getFaName()%>
                    </option>
                    <% } %>
                    <%} else {%>
                    <option value="<%=sentCountry.getCountryId()%>" selected>
                        <%=sentCountry.getFaName() %>
                    </option>
                    <%}%>
                </select>
            </div>
            <%if (!isCountrySent) {%>
        </div>
        <%} else {%>
        <div class="formItem">
            <label>نام شبکه علمی :</label>
            <input class="formInput" name="nren-name"
                   maxlength="60"
                   style="width: 320px;margin-left: 20px;"
                   type="text" value="<%=countryNren!=null?countryNren.getNernName():""%>">
        </div>

        <div class="formItem">
            <label>آدرس اینترنتی :</label>
            <input class="formInput" name="nren-site"
                   maxlength="60"
                   style="width: 320px;margin-left: 20px;"
                   type="text" value="<%=countryNren!=null?countryNren.getSiteURL():""%>">
        </div>
    </div>
    <div class="formRow" style="">

        <div class="formItem formInputCon" id="selectNrenImage"<%=nrenHadImage ? "style='display: none;'" : ""%>>
            <label>فایل تصویر :</label>
            <a href="#" class="formFileInputBtn">
                <img src="../images/file-choose.png" style="margin-bottom: 3px;margin-left: 3px;">
            </a>
            <input type="file" name="image" accept=".png,.jpg" class="formFileInput">
        </div>
        <div class="formItem" id="selectNrenTxt" <%=nrenHadImage ? "style='display: none;'" : ""%>>
            <input class="formInput formFileInputTxt"
                   style="width: 490px;"
                   type="text" name="file-name"
                   readonly>
        </div>
        <div class="formItem formInputCon" id="editImageCon" <%=!nrenHadImage ? "style='display: none;'" : ""%>>
            <input type="hidden" name="do-edit"
                   value="<%=countryNren!=null?(countryNren.getSiteURL()==null?"false":"true"):"true"%>"
                   id="doEditParam">
            <label>ویرایش تصویر :</label>
            <a href="#" id="editImageBtn">
                <img src="../images/replace.png" style="width: 40px;margin-bottom: 3px;margin-left: 3px;">
            </a>
        </div>
    </div>
    <div>
        <label style="float: right;">شرح مختصر :</label>
        <textarea class="formRow" name="description" rows="4"
                  style="display: inline;border: 1px solid black;margin-right: 5px;max-width: 750px;width: 100%"> <%=countryNren != null ? countryNren.getDescription() : ""%></textarea>
    </div>
    <div class="formRow" style=" display: table; width: 100%;">
        <input type="submit" value="تایید" class="btn btn-primary formBtn"
               style="margin-right: 10px;float: left">
    </div>
    <%}%>
    </div>
</form>
<div class="formBox">
    <table class="fixed-table table table-striped stateTable">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام</th>
            <th>آدرس سایت</th>
            <th>تصویر</th>
            <th>شرح مختصر</th>
            <th>ویرایش</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int j = 0; j < worldNrens.size(); j++) {
                WorldNren worldNren = worldNrens.get(j);
        %>
        <tr>
            <td style="width:30px">
                <%=j + 1%>
            </td>
            <td>
                <%=worldNren.getNernName()%>
            </td>
            <td>
                <%=!worldNren.getSiteURL().isEmpty() ? worldNren.getSiteURL() : "ندارد"%>
            </td>
            <td>
                <%
                    if (worldNren.getImageURL() != null) {
                        if (!worldNren.getImageURL().trim().isEmpty()) {
                %>

                <a href="#" data-toggle="modal"
                   data-target="#imgModal<%=worldNren.getCountryId()%>">
                    <img src="../images/image.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade" id="imgModal<%=worldNren.getCountryId()%>" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div>
                            <img src="../<%=worldNren.getImageURL()%>">
                        </div>
                    </div>
                    ¬
                </div>
                <%
                    }
                } else {
                %>
                ندارد
                <%}%>
            </td>
            <td>
                <%=!worldNren.getDescription().trim().isEmpty() ? worldNren.getDescription() : "ندارد"%>
            </td>
            <td>
                <a href="add-world-nren.jsp?action=send-country&country-id=<%=worldNren.getCountryId()%>"
                   target="iframe">
                    <img src="../images/edit.png" style="width: 30px">
                </a>
            </td>
        </tr>
        <% }%>
        </tbody>
    </table>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script>
    document.getElementById("country-select").onchange = function () {
        document.getElementById("send-nren").submit()
    };
    document.getElementById("editImageBtn").onclick = function () {
        document.getElementById("editImageCon").style.display = "none";
        document.getElementById("selectNrenImage").style.display = "block";
        document.getElementById("selectNrenTxt").style.display = "block";
        document.getElementById("doEditParam").value = "true";
    };
</script>
</body>
</html>