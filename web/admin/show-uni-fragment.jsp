<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.List" %>
<%@ page import="com.atrosys.dao.ServiceFormRequestDAO" %>
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
    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    if (subSystemCode == null) {
        response.sendError(404, "No sub system code!");
        return;
    }
    boolean canNotEdit = true;
    switch (subSystemCode) {
        case UNIVERSITY:
            if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.CRA_UNIVERSITY.getValue())) {
                response.sendError(403);
                return;
            }
            canNotEdit = !AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.CRA_UNIVERSITY.getValue(), AdminSubAccessType.EDIT.getValue());
            break;
        case RESEARCH_CENTER:
            if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.CRA_RESEARCH_CENTER.getValue())) {
                response.sendError(403);
                return;
            }
            canNotEdit = !AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.CRA_RESEARCH_CENTER.getValue(), AdminSubAccessType.EDIT.getValue());
            break;
        case HOSPITAL:
            if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.CRA_HOSPITALS.getValue())) {
                response.sendError(403);
                return;
            }
            canNotEdit = !AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.CRA_HOSPITALS.getValue(), AdminSubAccessType.EDIT.getValue());
            break;
    }

    request.setCharacterEncoding("UTF-8");
    String message = null;

    String nameStr = request.getParameter("uni-name");
    String nationalStr = request.getParameter("national-id");
    String stateStr = request.getParameter("state");
    String cityStr = request.getParameter("city");
    String typeStr = request.getParameter("type");
    String statusStr = request.getParameter("status");
    String pageNoStr = request.getParameter("page");

    String nameFilter = nameStr != null ? nameStr : "-1";
    String stateFilter = stateStr != null ? stateStr : "-1";
    String cityFilter = cityStr != null ? cityStr : "-1";
    Long nationalFilter = nationalStr != null ? Long.valueOf(nationalStr) : -1;
    Integer typeFilter = typeStr != null ? Integer.valueOf(typeStr) : -1;
    Integer statusFilter = statusStr != null ? Integer.valueOf(statusStr) : -1;
    Integer pageNo = pageNoStr != null ? Integer.valueOf(pageNoStr) : 1;

    List<UniTableRecord> tableRecords = UniversityDAO.filterUniversitiesInRange(subSystemCode.getValue(), nationalFilter, nameFilter, stateFilter
            , cityFilter, typeFilter, statusFilter, (pageNo - 1) * 25,25);
    boolean needPreviousPageBtn = pageNo > 1;
    boolean needNextPageBtn = UniversityDAO.filterUniversitiesInRangeHaveNextPage(subSystemCode.getValue(), nationalFilter, nameFilter, stateFilter
            , cityFilter, typeFilter, statusFilter, (pageNo - 1) * 25, 25);
%>
<table class="formTable" id="customerTable" style="width: 100%" page="<%=pageNo%>">
    <caption>
        مشاهده&nbsp;<%=subSystemCode.getFaStr()%>
    </caption>
    <tr>
        <th>ردیف</th>
        <th>نام اصلی</th>
        <th>نوع</th>
        <th> استان</th>
        <th> شهر</th>
        <th>تاریخ عضویت</th>
        <th> تعداد سرویس های خریداری شده</th>
        <th style="min-width: 150px">گزارش سرویس فرم های درخواستی</th>
    </tr>
    <%
        for (int i = 0; i < tableRecords.size(); i++) {
            UniTableRecord record = tableRecords.get(i);
            University university = record.getUniversity();
    %>
    <tr class="rowTr">
        <td>
            <%= (pageNo - 1) * 25 + i + 1%>
        </td>
        <td class="nameTd">
            <%=university.getUniName()%>
        </td>
        <td class="typeTd">
            <%=university.getTypeVal() != null ? SubSystemCode.subSystemsTypeFromValue(SubSystemCode.fromValue(university.getUniSubSystemCode())
                    , university.getTypeVal()).getFaStr() : "نامشخص"%>
        </td>
        <td class="stateTd">
            <%=record.getStateName()%>
        </td>
        <td class="cityTd">
            <%=record.getCityName()%>
        </td>
        <td>
            <%=Util.convertTimeStampToJalali(UniStatusLogDAO.findRegisterTimeStampByUniNationalId(university.getUniNationalId()))%>
        </td>
        <td>
            <%=ServiceFormRequestDAO.findServiceFormRequestByUniId(university.getUniNationalId()).size()%>
        </td>
        <td>
            <div class="operatorBox" style="margin: auto;display: inline-block">
                <a href="#" onclick="getLogData(<%=university.getUniNationalId()%>)">
                    <img src="../images/log.png" style="width: 30px">
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
