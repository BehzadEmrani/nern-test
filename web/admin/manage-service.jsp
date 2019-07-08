<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.ServiceCategoryDAO" %>
<%@ page import="com.atrosys.dao.ServiceDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.Service" %>
<%@ page import="com.atrosys.entity.ServiceCategory" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SERVICES_ADD_SERVICE.getValue())) {
        response.sendError(403);
        return;
    }

    Service changingService = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-service".equals(request.getParameter("action"));
    boolean isSendNew = "send-service".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE.getValue(),
            AdminSubAccessType.ADD.getValue());
    readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE.getValue(),
            AdminSubAccessType.READ.getValue());
    removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE.getValue(),
            AdminSubAccessType.DELETE.getValue());
    editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
            AdminAccessType.SERVICES_ADD_SERVICE.getValue(),
            AdminSubAccessType.EDIT.getValue());

    if (isEdit || isSendEdit || isSendRemove)
        changingService = ServiceDAO.findServiceById(
                Long.valueOf(request.getParameter("id")));

    if (isSendRemove)
        ServiceDAO.delete(changingService.getId());

    if (isSendNew || isSendEdit) {
        if (!addSubAccess && isSendNew) {
            response.sendError(403);
            return;
        }
        if (!editSubAccess && isSendEdit) {
            response.sendError(403);
            return;
        }
        if (isSendNew)
            changingService = new Service();
        changingService.setFaName(request.getParameter("fa-name"));
        changingService.setEnName(request.getParameter("en-name"));
        changingService.setCode(request.getParameter("code"));
        changingService.setCategoryId(Long.valueOf(request.getParameter("cat-id")));
        ServiceDAO.save(changingService);
    }
    List<Service> serviceList = ServiceDAO.findAllServices();
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
    <style>
    </style>
</head>
<body>
<% if (addSubAccess) { %>
<form id="send-service" method="post" action="manage-service.jsp" onsubmit=" return validateForm('#send-service');">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-service">
    <%} else {%>
    <input type="hidden" name="action" value="send-service">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingService.getId()%>">
    <%}%>
    <div class="formBox">
        <h3>اضافه کردن به خدمات</h3>
        <div class="formRow">
            <div class="formItem">
                <select class="formSelect" name="cat-id" style="width: 200px;">
                    <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) {%>
                    <option value="<%=serviceCategory.getId()%>"
                            <%=isEdit && changingService.getCategoryId().equals(serviceCategory.getId()) ? "selected" : ""%>>
                        <%=serviceCategory.getFaName()%>
                    </option>
                    <%}%>
                </select>
                <label>نام :</label>
                <input class="formInput persianInput" name="fa-name"
                       maxlength="30" minlength="1"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingService.getFaName():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>نام به انگلیسی :</label>
                <input class="formInput" name="en-name"
                       maxlength="30"
                       style="width: 200px;margin-left: 20px;"
                       value="<%=isEdit?changingService.getEnName():""%>"
                       type="text">
            </div>
            <div class="formItem">
                <label>کد :</label>
                <input class="formInput" name="code"
                       maxlength="10"
                       style="width: 200px;margin-left: 20px;" value="<%=isEdit?changingService.getCode():""%>"
                       type="text">
            </div>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
    </div>
</form>
<%}%>
<% if (readSubAccess) { %>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام</th>
            <th>نام به انگلیسی</th>
            <th>دسته خدمت</th>
            <th>کد</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < serviceList.size(); i++) {
                Service serviceTable = serviceList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=serviceTable.getFaName()%>
            </td>
            <td>
                <%=serviceTable.getEnName()%>
            </td>
            <td>
                <%
                    ServiceCategory serviceCategory = ServiceCategoryDAO.findServiceCategoryById(serviceTable.getCategoryId());
                %>
                <%=serviceCategory!=null?serviceCategory.getFaName():"نامشخص"%>
            </td>
            <td>
                <%=serviceTable.getCode()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=serviceTable.getId()%>"<%=!removeSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/delete<%=!removeSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <a href="manage-service.jsp?action=edit&id=<%=serviceTable.getId()%>"
                        <%=!editSubAccess ? "onclick='return false'" : ""%>>
                    <img src="../images/edit<%=!editSubAccess ? "-dis" : ""%>.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=serviceTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=serviceTable.getFaName()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="manage-service.jsp?action=delete&id=<%=serviceTable.getId()%>"
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
    <%} %>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>