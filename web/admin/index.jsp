<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="java.util.List" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
    if (adminSessionInfo.getAdmin() != null)
        adminSessionInfo.getAdmin().getId();
    boolean subSystemLogedIn = adminSessionInfo.isAdminLogedIn();
    List<AdminAccessType> adminAccessTypes = null;
    if (subSystemLogedIn) {
        adminAccessTypes = AdminDAO.findAllAdminAccessTypes(admin.getId());
    }
    String message = null;
    String pageParam = null;
    pageParam = request.getParameter("page");

    boolean anyAccessToSiteManage = false;
    boolean anyAccessToInitialData = false;
    boolean anyAccessToSubs = false;
    boolean anyAccessToDoc = false;
    boolean anyAccessToNewsService = false;
    boolean anyAccessToPersonal = false;
    boolean anyAccessToCoOperate = false;
    boolean anyAccessToTech = false;
    boolean anyAccessToServices = false;
    boolean anyAccessToMonitoring = false;
    boolean anyAccessToApproving = false;
    boolean anyAccessToTechOP = false;
    boolean anyAccessToCRA = false;
    if (subSystemLogedIn) {
        for (AdminAccessType adminAccessType : adminAccessTypes) {
            if (adminAccessType != null) {
                int accessVal = adminAccessType.getValue();
                anyAccessToSiteManage |= accessVal >= 1000 && accessVal < 2000;
                anyAccessToInitialData |= accessVal >= 2000 && accessVal < 3000;
                anyAccessToSubs |= accessVal >= 3000 && accessVal < 4000;
                anyAccessToDoc |= accessVal >= 4000 && accessVal < 5000;
                anyAccessToNewsService |= accessVal >= 5000 && accessVal < 6000;
                anyAccessToPersonal |= accessVal >= 6000 && accessVal < 7000;
                anyAccessToCoOperate |= accessVal >= 7000 && accessVal < 8000;
                anyAccessToTech |= accessVal >= 8000 && accessVal < 9000;
                anyAccessToServices |= accessVal >= 9000 && accessVal < 10000;
                anyAccessToMonitoring |= accessVal >= 10000 && accessVal < 11000;
                anyAccessToApproving |= accessVal >= 11000 && accessVal < 12000;
                anyAccessToTechOP |= accessVal >= 12000 && accessVal < 13000;
                anyAccessToCRA |= accessVal >= 13000 && accessVal < 14000;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>شبکه علمی</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <link href="css/index-style.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="../images/favicon.png"/>
</head>
<body>
<div id="header" style="border-bottom: 1px solid black;height:65px;">

    <div id="btnContainer">
        <a
                href="../pages/login.jsp?<%=(adminSessionInfo.isLogedIn()?"action=logout&":"")
        +"role="+UserRoleType.ADMINS.getValue()%>"
                target="iframe"
                class="btn btn-primary topBtn">
            <%=!adminSessionInfo.isLogedIn() ? "ورود" : "خروج"%>
        </a>
        <%if (subSystemLogedIn) {%>
        <a target="iframe" href="change-admin-pass.jsp?action=change-pass">
            <img class="topImageBtn" src="../images/profile-setting.png">
        </a>
        <%}%>
    </div>


    <div class="topnav" id="topnav">
        <a href="javascript:void(0);" style="font-size:15px;" class="menuBtn" onclick="toggleNav()">منو &nbsp;
            &nbsp;&#9776;</a>
        <a href="../index.jsp" id="topLogoAnchor"><img id="topLogo" src="../images/logo.png"></a>
    </div>
</div>
<div id="siteContent" style="top: 65px">
    <div class="sidenav" id="sideNav">
        <a href="#" target="iframe" onclick="return false;">
            <img src="../images/lg-logo.jpg" style="width: 180px">
            <%if (subSystemLogedIn) {%>
            <p style="text-align: center;color: #000;"><%=personalInfo.combineName()%>
            </p>
            <%} else {%>
            <p style="text-align: center;color: #000;">مدیریت سایت</p>
            <%}%>
        </a>
        <div class="sideItems" style="top: 150px;">
            <div class="panel-group accordion" id="accordion" style="bottom:0;">
                <%
                    if (subSystemLogedIn && !personalInfo.getNeedChangePass()) {
                        if (anyAccessToSubs) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse5"> مشترکین</a>
                    </h3>
                    <div id="collapse5" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.SUBS_REPORT)) { %>
                        <a href="report-subs.jsp" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('report-subs.jsp')">
                            گزارش کمیت مشترکین
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.UNIVERSITY)) { %>
                        <a href="manage-uni.jsp?sub-code=<%=SubSystemCode.UNIVERSITY.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-uni.jsp?sub-code=<%=SubSystemCode.UNIVERSITY.getValue()%>')">
                            <%=SubSystemCode.UNIVERSITY.getFaStr()%>
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.HOSPITALS)) { %>
                        <a href="manage-uni.jsp?sub-code=<%=SubSystemCode.HOSPITAL.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-uni.jsp?sub-code=<%=SubSystemCode.HOSPITAL.getValue()%>')">
                            <%=SubSystemCode.HOSPITAL.getFaStr()%>
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.RESEARCH_CENTER)) { %>
                        <a href="manage-uni.jsp?sub-code=<%=SubSystemCode.RESEARCH_CENTER.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-uni.jsp?sub-code=<%=SubSystemCode.RESEARCH_CENTER.getValue()%>')">
                            <%=SubSystemCode.RESEARCH_CENTER.getFaStr()%>
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SEE_REQUESTED_SERVICE_FORMS)) {
                        %>
                        <a href="request-service-form.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('request-service-form.jsp')">
                            سرویس فرم های درخواستی
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.STATE_SUBS)) {
                        %>
                        <a href="state-list.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('state-list.jsp')">
                            مشترکان استان
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.MEDICAL_SUBS)) {
                        %>
                        <a href="manage-uni-medicals.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-uni-medicals.jsp')">
                            بهداشت
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.SEMINARY)) {
                        %>
                        <a href="manage-uni.jsp?sub-code=<%=SubSystemCode.SEMINARY.getValue()%>" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-uni.jsp?sub-code=<%=SubSystemCode.SEMINARY.getValue()%>')">
                            حوزه های علمیه
                        </a>
                        <% }%>

                    </div>
                </div>

                <%
                    }
                }
                    if (subSystemLogedIn && !personalInfo.getNeedChangePass()) {
                        if (anyAccessToCRA) {
                %>

                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse6"> اطلاعات مشترکین</a>
                    </h3>
                    <div id="collapse6" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.CRA_SUBS_REPORT)) { %>
                        <a href="report-subs.jsp" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('report-subs.jsp')">
                            گزارش کمیت مشترکین
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.CRA_UNIVERSITY)) { %>
                        <a href="show-uni.jsp?sub-code=<%=SubSystemCode.UNIVERSITY.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('show-uni.jsp?sub-code=<%=SubSystemCode.UNIVERSITY.getValue()%>')">
                            <%=SubSystemCode.UNIVERSITY.getFaStr()%>
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.CRA_HOSPITALS)) { %>
                        <a href="show-uni-medicals.jsp" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('show-uni-medicals.jsp')">
                            <%=SubSystemCode.HOSPITAL.getFaStr()%>
                        </a>
                        <% }
                            if (adminAccessTypes.contains(AdminAccessType.CRA_RESEARCH_CENTER)) { %>
                        <a href="show-uni.jsp?sub-code=<%=SubSystemCode.RESEARCH_CENTER.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('show-uni.jsp?sub-code=<%=SubSystemCode.RESEARCH_CENTER.getValue()%>')">
                            <%=SubSystemCode.RESEARCH_CENTER.getFaStr()%>
                        </a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToServices) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse10">تعریف خدمات</a>
                    </h3>
                    <div id="collapse10" class="panel-collapse collapse">
                        <%if (adminAccessTypes.contains(AdminAccessType.SERVICES_ADD_SERVICE_FORM)) {%>
                        <a href="manage-service-form.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-service-form.jsp')">
                            اضافه کردن سرویس فرم
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SERVICES_ADD_SERVICE_CATEGORY)) {
                        %>
                        <a href="manage-service-category.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-service-category.jsp')">
                            اضافه کردن دسته‌ی خدمات
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SERVICES_ADD_SERVICE)) {
                        %>
                        <a href="manage-service.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-service.jsp')">
                            اضافه کردن خدمت
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SERVICES_ADD_SUB_SERVICE)) {
                        %>
                        <a href="manage-sub-service.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-sub-service.jsp')">
                            اضافه کردن زیرخدمت
                        </a>

                        <% } %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToTechOP) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse13"> فنی</a>
                    </h3>
                    <div id="collapse13" class="panel-collapse collapse">
                        <%if (adminAccessTypes.contains(AdminAccessType.TECH_OP_TELECOM_CENTERS)) {%>
                        <a href="manage-telecom-centers.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-telecom-centers.jsp')">
                            مدیریت مراکز مخابراتی
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.EQUIPMENT_PARAMETERS)) {
                        %>
                        <a href="manage-equipment-parameter.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-equipment-parameter.jsp')">
                            پارامتر های تجهیزات
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.EQUIPMENT_TYPES)) {
                        %>
                        <a href="manage-equipment-type.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-equipment-type.jsp')">
                            نوع تجهیزات
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.EQUIPMENT_DEFINITION)) {
                        %>
                        <a href="manage-equipments.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-equipments.jsp')">
                            ثبت تجهیزات
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.EQUIPMENT_INSTALL)) {
                        %>
                        <a href="manage-install.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-install.jsp')">
                            نصب تجهیزات
                        </a>
                        <% } %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToMonitoring) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse11">مانیتورینگ</a>
                    </h3>
                    <div id="collapse11" class="panel-collapse collapse">
                        <%if (adminAccessTypes.contains(AdminAccessType.MONITORING_SIMPLE)) {%>
                        <form action="http://172.20.1.242" name="auth_cacti1" method="post" TARGET="iframe">
                            <input type="hidden" name="action" value="login">
                            <input type="hidden" name="realm" value="local">
                            <input type="hidden" name="login_username" value="cra">
                            <input type="hidden" name="login_password" value="1020304050cra">
                            <a href="#" onClick="sendCactiLogin()" class="active sub">
                                مانیتورینگ نظارتی
                            </a>
                        </form>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.MONITORING_ADVANCE)) {
                        %>
                        <a href="#" style="margin-bottom: 10px" class="active sub"
                           onclick="loginIntoCacti('admin','1020304050admin');">
                            مانیتورینگ داخلی
                        </a>

                        <% } %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToApproving) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse12">تایید درخواست ها</a>
                    </h3>
                    <div id="collapse12" class="panel-collapse collapse">
                        <%if (adminAccessTypes.contains(AdminAccessType.RELATED_ORGAN_APPROVING_HOSPITAL)) {%>
                        <a href="major-approving.jsp?sub-code=<%=SubSystemCode.HOSPITAL.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('major-approving.jsp?sub-code=<%=SubSystemCode.HOSPITAL.getValue()%>')">
                            تایید توسط وزارت بهداشت
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.RELATED_ORGAN_APPROVING_SEMINARY)) {
                        %>
                        <a href="major-approving.jsp?sub-code=<%=SubSystemCode.SEMINARY.getValue()%>" target="iframe"
                           style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('major-approving.jsp?sub-code=<%=SubSystemCode.SEMINARY.getValue()%>')">
                            تایید حوزه های علمیه
                        </a>
                        <% } %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToSiteManage) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse7"> مدیران سایت</a>
                    </h3>
                    <div id="collapse7" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.ADMINS_REGISTER)) { %>
                        <a href="manage-admins.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-admins.jsp')">
                            عضویت
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.ADMIN_APPROVING_ROLES)) {
                        %>
                        <a href="manage-approvals.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-approvals.jsp')">
                            تاییدکنندگان
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.ADMIN_STATE_LIST_ROLES)) {
                        %>
                        <a href="manage-state-list.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-state-list.jsp')">
                            نمایندگان استان ها
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.ADMINS_REPORT)) {
                        %>
                        <a href="report-admins.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('report-admins.jsp')">
                            گزارش کارکرد
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SEND_FEED_BACK)) {
                        %>
                        <a href="manage-feed-back.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('manage-feed-back.jsp')">
                            اعلام خطا
                        </a>
                        <% }%>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToTech) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse9">پشتیبانی</a>
                    </h3>
                    <div id="collapse9" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.TECH_ERROR_HANDLING)) {
                        %>
                            <a href="tech-manage-feed-back.jsp" target="iframe" style="margin-bottom: 10px"
                               class="active sub"
                               onclick="itemSelected('tech-manage-feed-back.jsp')">
                                پیگیری خطاها
                            </a>
                        <%} if (adminAccessTypes.contains(AdminAccessType.TECH_REDIRECT_TICKETING)) {
                        %>
                            <a href="redirect-to-NC.jsp" target="iframe" style="margin-bottom: 10px"
                               class="active sub"
                               onclick="itemSelected('redirect-to-NC.jsp')">
                                ثبت تیکت
                            </a>
                        <%}%>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToPersonal) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse4">اشخاص</a>
                    </h3>
                    <div id="collapse4" class="panel-collapse collapse">
                        <%
                            if (adminAccessTypes.contains(AdminAccessType.MANAGE_PERSONS)) {
                        %>
                        <a href="manage-personal-info.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-personal-info.jsp')">
                            اشخاص حقیقی
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.MANAGE_PERSONS_LEGAL)) {
                        %>
                        <a href="manage-personal-info.jsp?legal=true" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('manage-personal-info.jsp?legal=true')">
                            اشخاص حقوقی
                        </a>
                        <% } %>
                    </div>
                </div>

                <%
                    }
                    if (anyAccessToInitialData) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse3"> اطلاعات اولیه</a>
                    </h3>
                    <div id="collapse3" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.STATES)) { %>
                        <a href="add-state.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-state.jsp')">
                            استان
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.CITIES)) {
                        %>
                        <a href="add-city.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-city.jsp')">
                            شهرها
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.WORLD_NRERN)) {
                        %>
                        <a href="add-world-nren.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-world-nren.jsp')">
                            گستره جهانی
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.PRE_UNI_DATA)) {
                        %>
                        <a href="add-uni-pre-data.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-uni-pre-data.jsp')">
                            اطلاعات دانشگاه های پیشفرض
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.PRE_UNI_DATA)) {
                        %>
                        <a href="add-contract-doc.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-contract-doc.jsp')">
                            مسندات و قراردادها
                        </a>
                        <%}%>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToCoOperate) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse8"> همکاری با شعا</a>
                    </h3>
                    <div id="collapse8" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.ADD_JOB_TITLE)) { %>
                        <a href="../co-operate/admin/addTitle_new.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('../co-operate/admin/addTitle_new.jsp')">
                            اضافه کردن به حوزه
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.ADD_SUBJOB_TITLE)) {
                        %>
                        <a href="../co-operate/admin/addSubTitle_new.jsp" target="iframe"
                           style="margin-bottom: 10px;text-align: center"
                           class="active sub"
                           onclick="itemSelected('../co-operate/admin/addSubTitle_new.jsp')">
                            اضافه کردن به مدیریت
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.ADD_JOB_INFO)) {
                        %>
                        <a href="../co-operate/admin/addJob_new.jsp" target="iframe"
                           style="margin-bottom: 10px;text-align: center"
                           class="active sub"
                           onclick="itemSelected('../co-operate/admin/addJob_new.jsp')">
                            اضافه کردن به مشاغل
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.SHOW_JOB_REQUEST)) {
                        %>
                        <a href="../co-operate/admin/jobTable.jsp" target="iframe"
                           style="margin-bottom: 10px;text-align: center"
                           class="active sub"
                           onclick="itemSelected('../co-operate/admin/jobTable.jsp')">
                            مشاهده ی لیست افراد
                        </a>
                        <% } %>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToDoc) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse1">اسناد مکتوب</a>
                    </h3>
                    <div id="collapse1" class="panel-collapse collapse">
                        <% if (adminAccessTypes.contains(AdminAccessType.DOC_INFO)) { %>
                        <a href="add-doc.jsp?dest=info" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-doc.jsp?dest=info')">
                            شبکه علمی چیست؟
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.DOC_PUBLIC_PRIVATE)) {
                        %>
                        <a href="add-doc.jsp?dest=about" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-doc.jsp?dest=about')">
                            درباره ما
                        </a>
                        <%}%>
                    </div>
                </div>
                <%
                    }
                    if (anyAccessToNewsService) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse2">سرویس اخبار</a>
                    </h3>
                    <div id="collapse2" class="panel-collapse collapse">
                        <%if (adminAccessTypes.contains(AdminAccessType.MEDIA_NEWS)) {%>
                        <a href="add-news.jsp?dest=media" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('add-news.jsp?dest=media')">
                            در آیینه ی دیگر رسانه ها
                        </a>
                        <%
                            }
                            if (adminAccessTypes.contains(AdminAccessType.STUDIO_SHOA_NEWS)) {
                        %>
                        <a href="add-news.jsp?dest=operator" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('add-newsx`.jsp?dest=operator')">
                            استودیو شعا
                        </a>
                        <% } %>
                    </div>
                </div>

                <%
                    }
                } else if (admin != null) {
                    if (personalInfo.getNeedChangePass()) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" target="iframe" href="change-admin-pass.jsp?action=change-pass"
                           onclick="itemSelected('change-admin-pass.jsp?action=change-pass')">
                            تغییر رمز
                        </a>
                    </h3>
                </div>
                <%
                    }
                } else if (!adminSessionInfo.isLogedIn()) {
                %>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" target="iframe"
                           href="../pages/login.jsp?role=<%=UserRoleType.ADMINS.getValue()%>"
                           onclick="itemSelected('../pages/login.jsp?role=<%=UserRoleType.ADMINS.getValue()%>')">
                            ورود
                        </a>
                    </h3>
                </div>
                <%}%>
            </div>
        </div>
    </div>
    <div id="mainFrame" style="margin-right: 270px;">
        <%
            String iframeURL = "/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue();
            if (pageParam != null)
                switch (pageParam) {
                    case "login":
                        iframeURL = "/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue();
                        break;
                    case "add-info-doc":
                        iframeURL = "add-doc.jsp?dest=info";
                        break;
                    case "add-about-doc":
                        iframeURL = "add-doc.jsp?dest=about";
                        break;
                    case "add-nren":
                        iframeURL = "add-world-nren.jsp";
                        break;
                    case "add-media-news":
                        iframeURL = "add-news.jsp?dest=media";
                        break;
                    case "add-operator-news":
                        iframeURL = "add-news.jsp?dest=operator";
                        break;
                    case "manage-uni":
                        iframeURL = "manage-uni.jsp";
                        break;
                    case "manage-admins":
                        iframeURL = "manage-admins.jsp";
                        break;
                    case "no-access":
                        iframeURL = "no-access.jsp";
                        break;
                    case "welcome":
                        iframeURL = "welcome.jsp";
                        break;
                }
            if (adminSessionInfo.isAdminLogedIn())
                if (personalInfo.getNeedChangePass())
                    iframeURL = "change-admin-pass.jsp";
                else
                    iframeURL = "welcome.jsp";
        %>
        <iframe id="iframe" name="iframe" src="<%=iframeURL%>" width="100%" height="100%"
                onload="scroll(0,0);" allowfullscreen></iframe>
    </div>
</div>
<div id="footer">
    <p>
        کلیه حقوق مادي ومعنوي محتوا و اطلاعات موجود در سایت طبق قوانین حمایت از مولفین و مصنفین و قوانین حق کپی رایت
        ایران و بین المللی متعلق است به
        <strong>اپراتور شبکه علمی ایران (فاوا یا نفت مسئله این است : 1394 – 1404)</strong><br>
        این نرم افزار توسط شرکت سامانه های هوشمند سیمرغ طراحی ، پیاده سازي ، پشتیبانی و راهبري کامل گردیده و حق
        امتیاز
        آن به شرکت سامانه های هوشمند سیمرغ تعلق دارد.
    </p>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/index.js"></script>
</body>
</html>