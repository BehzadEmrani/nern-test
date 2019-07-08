<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
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
    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean removeSubAccess = false;
    boolean editSubAccess = false;
    if (subSystemCode.equals(SubSystemCode.HOSPITAL)) {
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue())) {

            response.sendError(403);
            return;
        } else {
            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.READ.getValue());
            removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.DELETE.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        }
    } else if (subSystemCode.equals(SubSystemCode.SEMINARY)) {
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue())) {
            response.sendError(403);
            return;
        } else {
            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.READ.getValue());
            removeSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.DELETE.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        }
    } else {
        response.sendError(404);
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String message = null;
    String pageNoStr = request.getParameter("page");
    Integer pageNo = pageNoStr != null ? Integer.valueOf(pageNoStr) : 1;
    List<UniTableRecord> tableRecords = UniversityDAO.majorApprovingUnisList(subSystemCode.getValue(), (pageNo - 1) * Constants.SUBS_PER_PAGE, Constants.SUBS_PER_PAGE);
    boolean needPreviousPageBtn = pageNo > 1;
    boolean needNextPageBtn = UniversityDAO.majorApprovingUnisListHaveNextPage(subSystemCode.getValue(), (pageNo - 1) * Constants.SUBS_PER_PAGE, Constants.SUBS_PER_PAGE);
%>
<table class="formTable" id="customerTable" style="width: 100%" page="<%=pageNo%>">
    <caption>
        تایید درخواست درخواست کنندگان
    </caption>
    <tr>
        <th>ردیف</th>
        <th>شناسه ملی</th>
        <th>نام اصلی</th>
        <th>نوع</th>
        <th> استان</th>
        <th> شهر</th>
        <th>اطلاعات کامل</th>
        <th>وضعیت</th>
        <th>زیر وضعیت</th>
        <th>تاریخ آخرین تغییر وضعیت</th>
        <th>تاریخ عضویت</th>
        <th> نقشه</th>
        <th> عملیات</th>
    </tr>
    <%
        for (int i = 0; i < tableRecords.size(); i++) {
            UniTableRecord record = tableRecords.get(i);
            University tableUniversity = record.getUniversity();
    %>
    <tr class="rowTr">
        <td>
            <%= (pageNo - 1) * Constants.ADMIN_SERVICE_FORM_PER_PAGE + i + 1%>
        </td>
        <td class="nationalIdTd">
            <%=tableUniversity.getUniNationalId()%>
        </td>
        <td class="nameTd">
            <%=tableUniversity.getUniName()%>
        </td>
        <td class="typeTd">
            <%=tableUniversity.getTypeVal() != null ? SubSystemCode.subSystemsTypeFromValue(SubSystemCode.fromValue(tableUniversity.getUniSubSystemCode()),
                    tableUniversity.getTypeVal()).getFaStr() : "نامشخص"%>
        </td>
        <td class="stateTd">
            <%=record.getStateName()%>
        </td>
        <td class="cityTd">
            <%=record.getCityName()%>
        </td>
        <td>
            <a href="#" onclick="getUniData('<%=tableUniversity.getUniNationalId()%>','<%=subSystemCode.getValue()%>')">
                <img src="../images/show-info.png" style="width: 30px">
            </a>
        </td>
        <td class="statusTd">
            <%=UniStatus.fromValue(tableUniversity.getUniStatus()).getFaStr()%>
        </td>
        <td>
            <%if (tableUniversity.getUniStatus().equals(UniStatus.REGISTER_PAGE_ERROR.getValue())) {%>
            <%=UniSubStatus.fromValue(tableUniversity.getUniSubStatus()).getFaStr()%>
            <%} else {%>
            -
            <%}%>
        </td>
        <td>
            <%=Util.convertTimeStampToJalali(record.getLastLogTimeStamp())%>
        </td>
        <td>
            <%=Util.convertTimeStampToJalali(UniStatusLogDAO.findRegisterTimeStampByUniNationalId(tableUniversity.getUniNationalId()))%>
        </td>
        <td>
            <a href="#" onclick="getMapData(<%=tableUniversity.getUniNationalId()%>,'<%=subSystemCode.getValue()%>')">
                <img src="../images/map.png" style="width: 30px">
            </a>
        </td>
        <td>
            <div class="operatorBox" style="margin: auto;display: inline-block">
                <a href="major-approve-confirm.jsp?sub-code=<%=subSystemCode.getValue()%>&id=<%=tableUniversity.getUniNationalId()%>">
                    <img src="../images/check.png" style="width: 30px">
                </a>
            </div>
        </td>
    </tr>
    <%}%>
</table>
<br>
<%if (needNextPageBtn) {%>
<a href="#" onclick="getTableData(1)">
    <div style="float: right">صفحه بعدی</div>
</a>
<%}%>
<%if (needPreviousPageBtn) {%>
<a href="#" onclick="getTableData(-1)">
    <div style="float: left">صفحه قبلی</div>
</a>
<%}%>
<br clear="both">
