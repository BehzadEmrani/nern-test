<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.model.*" %>
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
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SUBS_REPORT.getValue())) {
        response.sendError(403);
        return;
    }
    UniversityType[] universityTypes = UniversityType.values();
    long unisCount = UniversityDAO.getRowCount(SubSystemCode.UNIVERSITY.getValue());
    ResearchCenterType[] researchCenterTypes = ResearchCenterType.values();
    long researchesCount = UniversityDAO.getRowCount(SubSystemCode.RESEARCH_CENTER.getValue());
    request.setCharacterEncoding("UTF-8");
    String message = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
    </style>
</head>
<body>
<% if (AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.SUBS_REPORT.getValue(), AdminSubAccessType.READ.getValue())) { %>
<div class="formBox">
    <h3 style="text-align: center">گزارش کمیتی مشترکان</h3>
    <table class="formTable" style="width: 100%">
        <tr style="background: #41709c;color: white;">
            <th>بخش</th>
            <th>نوع</th>
            <th>کل درخواست ها</th>
            <th>در حال انتظار</th>
            <th>منتظر امضای مشترک</th>
            <th>منتظر امضای اپراتور</th>
            <th>منتظر معرفی نماینده</th>
            <th>آماده درخواست سرویس</th>
            <th>شهرهای فازهای بعدی</th>
            <th>جمع</th>
        </tr>
        <%
            for (int i = 0; i < universityTypes.length; i++) {
                UniversityType universityType = universityTypes[i];
        %>
        <tr>
            <%if (i == 0) {%>
            <td rowspan="<%=universityTypes.length%>">دانشگاه ها</td>
            <%}%>
            <td><%=universityType.getFaStr()%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndStateRange(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.REGISTER_PAGE_VERIFY.getValue(), UniStatus.UNI_SUBSCRIPTION_CANCELLED.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndStateRange(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.REGISTER_PAGE_VERIFY.getValue(), UniStatus.SUBSCRIBE_PAGE.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.SUBSCRIBE_PAGE.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.SUBSCRIBE_PAGE_VERIFY.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.PRIMARY_AGENT_REGISTER.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.REGISTER_COMPLETED.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.UNIVERSITY.getValue(), universityType.getValue()
                    , UniStatus.NEXT_PHASE.getValue())%>
            </td>
            <%if (i == 0) {%>
            <td rowspan="<%=universityTypes.length%>"><%=unisCount%>
            </td>
            <%}%>
        </tr>
        <%}%>
        <tr style="border-top:2px solid black;">
            <td>حوزه های علمیه</td>
            <td>-</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <%
            for (int i = 0; i < researchCenterTypes.length; i++) {
                ResearchCenterType researchCenterType = researchCenterTypes[i];
        %>
        <tr <%=i == 0 ? "style=\"border-top:2px solid black;\"" : ""%>>
            <%if (i == 0) {%>
            <td rowspan="<%=researchCenterTypes.length%>">مراکز پژوهشی و تحقیقاتی</td>
            <%}%>
            <td><%=researchCenterType.getFaStr()%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndStateRange(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.REGISTER_PAGE_VERIFY.getValue(), UniStatus.UNI_SUBSCRIPTION_CANCELLED.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndStateRange(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.REGISTER_PAGE_VERIFY.getValue(), UniStatus.SUBSCRIBE_PAGE.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.SUBSCRIBE_PAGE.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.SUBSCRIBE_PAGE_VERIFY.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.PRIMARY_AGENT_REGISTER.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.REGISTER_COMPLETED.getValue())%>
            </td>
            <td><%=UniversityDAO.getUnisCountBySubCodeAndTypeAndState(
                    SubSystemCode.RESEARCH_CENTER.getValue(), researchCenterType.getValue()
                    , UniStatus.NEXT_PHASE.getValue())%>
            </td>
            <%if (i == 0) {%>
            <td rowspan="<%=researchCenterTypes.length%>"><%=researchesCount%>
            </td>
            <%}%>
        </tr>
        <%}%>
        <tr style="border-top:2px solid black;">
            <td>کتابخانه ها</td>
            <td>-</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <tr style="border-top:2px solid black;">
            <td rowspan="5">اشخاص حقیقی</td>
            <td>دانشجویان</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td rowspan="5">0</td>
        </tr>
        <tr>
            <td>استادان</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <tr>
            <td>طلاب</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <tr>
            <td>پژوهشگران</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <tr>
            <td>دانش آموختگان</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
            <td>0</td>
        </tr>
        <tr style="border-top:3px solid black;background:#4fc1f3;color: white;font-size: larger">
            <td colspan="2">جمع کل</td>
            <td colspan="8"><%=unisCount + researchesCount%>
            </td>
        </tr>
    </table>
    <%} %>
    <br>
    <a href="#" onclick="printReport()">
        <img src="../images/print.png" style="width: 30px">
    </a>
</div>
<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script>
    function printReport() {
        window.print();
    }
</script>
</body>
</html>