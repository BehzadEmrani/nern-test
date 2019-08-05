<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.List" %>
<%@ page import="com.atrosys.dao.AdminDAO" %>
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
    boolean canNotEdit = !AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.MEDICAL_SUBS.getValue(), AdminSubAccessType.EDIT.getValue());
    request.setCharacterEncoding("UTF-8");
    String message = null;

    String nameStr = request.getParameter("uni-name");
    String nationalStr = request.getParameter("national-id");
    String stateStr = request.getParameter("state");
    String cityStr = request.getParameter("city");
    String typeStr = request.getParameter("type");
    String subCodeStr = request.getParameter("sub-code");
    String statusStr = request.getParameter("status");
    String pageNoStr = request.getParameter("page");

    String nameFilter = nameStr != null ? nameStr : "-1";
    String stateFilter = stateStr != null ? stateStr : "-1";
    String cityFilter = cityStr != null ? cityStr : "-1";
    Long nationalFilter = nationalStr != null ? Long.valueOf(nationalStr) : -1;
    Integer typeFilter = typeStr != null ? Integer.valueOf(typeStr) : -1;
    Integer subCodeFilter = subCodeStr != null ? Integer.valueOf(subCodeStr) : -1;
    Integer statusFilter = statusStr != null ? Integer.valueOf(statusStr) : -1;
    Integer pageNo = pageNoStr != null ? Integer.valueOf(pageNoStr) : 1;

    List<UniTableRecord> tableRecords = UniversityDAO.filterUniversitiesInRange(subCodeFilter, nationalFilter, nameFilter, stateFilter
            , cityFilter, typeFilter, statusFilter, (pageNo - 1) * Constants.SUBS_PER_PAGE, Constants.SUBS_PER_PAGE);
    boolean needPreviousPageBtn = pageNo > 1;
    boolean needNextPageBtn = UniversityDAO.filterUniversitiesInRangeHaveNextPage(subCodeFilter, nationalFilter, nameFilter, stateFilter
            , cityFilter, typeFilter, statusFilter, (pageNo - 1) * Constants.SUBS_PER_PAGE, Constants.SUBS_PER_PAGE);
%>
<table class="formTable" id="customerTable" style="width: 100%" page="<%=pageNo%>">
    <caption>
       مراکز تحت نظارت وزارت بهداشت
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
        <th style="min-width: 150px"> عملیات</th>
    </tr>
    <%
        for (int i = 0; i < tableRecords.size(); i++) {
            UniTableRecord record = tableRecords.get(i);
            University university = record.getUniversity();
    %>
    <tr class="rowTr">
        <td>
            <%= (pageNo - 1) * Constants.ADMIN_SERVICE_FORM_PER_PAGE + i + 1%>
        </td>
        <td class="nationalIdTd">
            <%=university.getUniNationalId()%>
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
            <a href="#" onclick="getUniData('<%=university.getUniNationalId()%>')">
                <img src="../images/show-info.png" style="width: 30px">
            </a>
        </td>
        <td class="statusTd">
            <%=UniStatus.fromValue(university.getUniStatus()).getFaStr()%>
        </td>
        <td>
            <%if (university.getUniStatus().equals(UniStatus.REGISTER_PAGE_ERROR.getValue())) {%>
            <%=UniSubStatus.fromValue(university.getUniSubStatus()).getFaStr()%>
            <%} else {%>
            -
            <%}%>
        </td>
        <td>
            <%=Util.convertTimeStampToJalali(record.getLastLogTimeStamp())%>
        </td>
        <td>
            <%=Util.convertTimeStampToJalali(UniStatusLogDAO.findRegisterTimeStampByUniNationalId(university.getUniNationalId()))%>
        </td>
        <td>
            <a href="#" onclick="getMapData(<%=university.getUniNationalId()%>)">
                <img src="../images/map.png" style="width: 30px">
            </a>
        </td>
        <td>
            <div class="operatorBox" style="margin: auto;display: inline-block">
                <a href="change-uni-state.jsp?action=remove&id=<%=university.getUniNationalId()%>"
                        <%=canNotEdit ? "onclick=\"return false\"" : ""%>
                   style="float: left;">
                    <img src="../images/delete<%=canNotEdit?"-dis":""%>.png" style="width: 30px">
                </a>
                <a href="change-uni-state.jsp?action=error&id=<%=university.getUniNationalId()%>"
                   style="float: left;"   <%=canNotEdit ? "onclick=\"return false\"" : ""%>>
                    <img src="../images/send-error<%=canNotEdit?"-dis":""%>.png" style="width: 30px">
                </a>
                <a href="#" onclick="getLogData(<%=university.getUniNationalId()%>)">
                    <img src="../images/log.png" style="width: 30px">
                </a>
                <a href="change-uni-state.jsp?action=confirm&id=<%=university.getUniNationalId()%>"
                        <%=canNotEdit ? "onclick=\"return false\"" : ""%>
                   style="float: left;">
                    <img src="../images/check<%=canNotEdit?"-dis":""%>.png" style="width: 30px">
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
