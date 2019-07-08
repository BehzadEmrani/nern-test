<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.ContractDocDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.ContractDoc" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
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
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.ADD_CONTRACT_DOC.getValue())) {
        response.sendError(403);
        return;
    }
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.ADD_CONTRACT_DOC.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.ADD_CONTRACT_DOC.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.ADD_CONTRACT_DOC.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.ADD_CONTRACT_DOC.getValue(),
            AdminSubAccessType.EDIT.getValue());

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
            ContractDoc contractDoc = new ContractDoc();
            String fname = uploadedFiles.get("doc").getName();
            String ext = fname.substring(fname.lastIndexOf('.') + 1, fname.length());
            byte[] bytes = IOUtils.toByteArray(uploadedFiles.get("doc").getInputStream());
            contractDoc.setDocument(bytes);
            contractDoc.setExtension(ext);
            contractDoc.setTitle(uploadFields.get("title"));
            contractDoc.setDescription(uploadFields.get("description"));
            ContractDocDAO.save(contractDoc);
        }
    }
    if ("delete".equals(request.getParameter("action"))) {
        if (removeSubAccess) {
            ContractDocDAO.delete(Long.valueOf(request.getParameter("id")));
        } else {
            response.sendError(403);
            return;
        }
    }

    List<ContractDoc> contractDocs = ContractDocDAO.findAllContractDocs();
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
      action="add-contract-doc.jsp">
    <input type="hidden" name="action" value="send-doc">
    <div class="formBox">
        <h3>
            اضافه کردن سند
        </h3>
        <div class="formRow">
            <div class="formItem">
                <label>عنوان :</label>
                <input class="formInput" name="title"
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
<%if (readSubAccess) {%>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>عنوان</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < contractDocs.size(); i++) {
                ContractDoc contractDocTable = contractDocs.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=contractDocTable.getTitle()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=contractDocTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="../documents/get-contract-doc.jsp?id=<%=contractDocTable.getId()%>" target="_blank">
                    <img src="../images/pdf-icon.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=contractDocTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=contractDocTable.getTitle()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="add-contract-doc.jsp?action=delete&id=<%=contractDocTable.getId()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        <% }%>
        </tbody>
    </table>
</div>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>