<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!adminSessionInfo.isAdminLogedIn()) {
        response.sendError(403);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.MEDICAL_SUBS.getValue())) {
        response.sendError(403);
        return;
    }
    boolean canNotEdit = !AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.MEDICAL_SUBS.getValue(), AdminSubAccessType.EDIT.getValue());
    request.setCharacterEncoding("UTF-8");
    String message = null;

    List<String> values = new ArrayList<>();
    List<SubSystemsType> types = new ArrayList<>();
    types.add(UniversityType.MEDICAL_UNIVERSITY);
    values.add(String.valueOf(SubSystemCode.UNIVERSITY.getValue()) + '&' + UniversityType.MEDICAL_UNIVERSITY.getValue());
    types.add(ResearchCenterType.RESEARCH_CENTER_MINIS_HEALTH);
    values.add(String.valueOf(SubSystemCode.RESEARCH_CENTER.getValue()) + '&' + ResearchCenterType.RESEARCH_CENTER_MINIS_HEALTH.getValue());
    types.addAll(Arrays.asList(SubSystemCode.subSystemsTypeFromSubCode(SubSystemCode.HOSPITAL)));
    values.add(String.valueOf(SubSystemCode.HOSPITAL.getValue()) + '&' + HospitalType.MEDICAL_GOV.getValue());
    values.add(String.valueOf(SubSystemCode.HOSPITAL.getValue()) + '&' + HospitalType.MEDICAL_NON_GOV.getValue());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        @media screen and (max-width: 1060px) {
            .formTable th {
                min-width: inherit !important;
            }
        }

        .operatorBox a {
            margin: 0 2px;
        }

        .infoModal span {
            margin: 0 20px;
        }

        .infoModal {
            line-height: 30px;
        }
    </style>
</head>
<body>
<div class="formBox">
    <div class="formItem">
        <label hidden="hidden">شناسه ملی :</label>
        <input class="formInput" id="nationalFilter"
               maxlength="15"
               style="width: 150px;margin-left: 20px;"
               type="text" hidden="hidden">
    </div>
    <div class="formItem">
        <label>نام اصلی:</label>
        <input class="formInput" id="nameFilter"
               maxlength="20"
               style="width: 150px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label>نوع:</label>
        <select class="formInput" id="typeFilter"
                style="width: 100px;">
            <%
                for (int i = 0; i < types.size(); i++){
                    SubSystemsType type=types.get(i);
                    String value = values.get(i);
            %>
            <option value="<%=value%>"><%=type.getFaStr()%>
            </option>
            <%}%>
        </select>
    </div>
    <div class="formItem">
        <label>استان :</label>
        <input class="formInput" id="stateFilter"
               maxlength="20"
               style="width: 100px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label>شهر :</label>
        <input class="formInput" id="cityFilter"
               maxlength="20"
               style="width: 100px;margin-left: 20px;"
               type="text">
    </div>
    <div class="formItem">
        <label hidden="hidden">وضعیت :</label>
        <select class="formInput" id="statusFilter"
                style="width: 130px;" hidden="hidden">
            <option value="-1">همه وضعیت ها</option>
            <%for (UniStatus status : UniStatus.values()) {%>
            <option value="<%=status.getValue()%>"><%=status.getFaStr()%>
            </option>
            <%}%>
        </select>
    </div>
    <button class="btn btn-primary" onclick="getTableData(0)">اعمال</button>
</div>
<div class="formBox" id="tableContainer">
</div>
<!-- Modal -->
<div class="modal fade infoModal" id="infoModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body" id="infoModalBody" style="direction: rtl">
            </div>
        </div>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="mapModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <iframe src="" id="mapIframe" style="width: 100%;height: 90vh;"></iframe>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="logModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <div>
            <iframe src="" id="logIframe" style="width: 100%;height: 90vh;" allowfullscreen></iframe>
        </div>
    </div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/show-uni-medicals.js"></script>
</body>
</html>