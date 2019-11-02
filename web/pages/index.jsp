<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.atrosys.dao.ApprovingRoleDAO" %>
<%@ page import="com.atrosys.dao.ServiceCategoryDAO" %>
<%@ page import="com.atrosys.dao.ServiceFormDAO" %>
<%@ page import="com.atrosys.entity.Agent" %>
<%@ page import="com.atrosys.entity.ServiceCategory" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.entity.UserRole" %>
<%@ page import="com.atrosys.model.*" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    String message = null;
    String pageParam = null;
    boolean isContactPage = false;
    boolean isCRM = false;
    boolean isAboutPage = false;
    boolean isInfoPage = false;
    boolean isTariffPage = false;

    pageParam = request.getParameter("page");
    if (pageParam != null)
        switch (pageParam) {
            case "contact-shoa":
            case "contact-it":
            case "contact-seemsys":
            case "contact-tci":
            case "contact-radio":
            case "contact-tic":
            case "contact-ito":
                isContactPage = true;
                break;
            case "about":
            case "1st-gen":
            case "2nd-gen":
            case "3th-gen":
            case "srv-oriented":
            case "about-doc":
            case "about-assignment-instructions":
            case "about-partnership":
            case "about-supervisor-organization":
            case "about-what-partnership":
            case "about-agreement-tci":
            case "about-agreement-state":
                isAboutPage = true;
                break;
            case "info":
            case "info-intro":
            case "info-s1":
            case "info-s2":
            case "info-s3":
            case "info-s4":
            case "info-s5":
            case "info-doc":
            case "info-world":
                isInfoPage = true;
                break;
            case "tariffs":
                isTariffPage = true;
                break;
        }
    SubSystemCode subSystemCode = null;
    UniSessionInfo uniSessionInfo = null;
    boolean adminLoggedIn=false;

    try {
        AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
        adminLoggedIn= true;
    } catch (Exception ignored) {
    }


    if (!isContactPage && !isAboutPage && !isInfoPage && !isTariffPage) {
        isCRM = true;
        subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    } else {
        subSystemCode = SubSystemCode.fromValue(1);
    }

    if (subSystemCode == null) {
        response.sendError(404, "No sub system code!");
        return;
    } else {
        try {
            uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
        } catch (Exception ignored) {

        }
    }

    Boolean subSystemLoggedIn = null;
    University university = null;
    UniStatus uniStatus = null;
    UserRole userRole = null;
    Agent agent = null;
    boolean registerCompleted = false;
    boolean isCenter = false;
    if (subSystemCode != null)
        isCenter = subSystemCode.getValue() == SubSystemCode.RESEARCH_CENTER.getValue();
    if (isCRM) {
        subSystemLoggedIn = uniSessionInfo.isSubSystemLoggedIn();
        university = uniSessionInfo.getUniversity();
        if (university != null)
            uniStatus = UniStatus.fromValue(university.getUniStatus());
        userRole = uniSessionInfo.getUserRole();
        agent = uniSessionInfo.getAgent();
        registerCompleted = uniSessionInfo.isSubSystemLoggedIn() ?
                university.getUniStatus() >= UniStatus.REGISTER_COMPLETED.getValue() : false;
    }
    boolean haveApprovingRole = false;
    if (university != null)
        haveApprovingRole = ApprovingRoleDAO.countApprovingRoleByUniId(university.getUniNationalId()) > 0;
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
    <style>

    </style>
</head>
<body>
<div id="header" style="border-bottom: 1px solid black;">
    <span class="lanGroup" id="langGP">
    <div class="lanPop">
    <a href="#" onclick="return false;">SP</a>
      <div class="lanPopContent">
       Version en español
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">EN</a>
      <div class="lanPopContent">
       English version
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">CH</a>
      <div class="lanPopContent">
       中文版
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">RU</a>
      <div class="lanPopContent">
       Русская версия
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">AR</a>
      <div class="lanPopContent">
       النسخة العربية
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">FR</a>
      <div class="lanPopContent">
       version française
      </div>
    </div>
    </span>

    <a href="javascript:void(0);" onclick="langDropDown()" id="langBtn">Lang</a>


    <div id="btnContainer">
        <a href="login.jsp?<%=(uniSessionInfo.isLoggedIn()?"action=logout&":"")
        +"role="+UserRoleType.fromSubSystemCode(subSystemCode).getValue()%>"
           target="iframe"
           class="btn btn-primary topBtn">
            <%=!uniSessionInfo.isLoggedIn() ? "ورود" : "خروج"%>
        </a>
        <%
            if (uniSessionInfo.isSubSystemLoggedIn()) {
                if (registerCompleted) {
                    if (uniSessionInfo.getUserRole().getValidity() == Validity.ACTIVE.getValue()) {
                        String payIconImageURL = "../images/no-payment.png";
            /*if (sessionInfo.userRoleStatus == UserRoleStatus.INCOMPELETE_PAYMENT)
                payIconImageURL = "../images/have-payment.png";
            else
                payIconImageURL = "../images/no-payment.png";*/
        %>
        <a target="iframe"><img class="topImageBtn" src="../images/profile-setting.png"></a>
        <a href="#" onclick="return false;"> <img src="<%=payIconImageURL%>" class="topImageBtn"
                                                  style="height: 30px;width: auto"> </a>
        <%
            }
        } else if (uniSessionInfo.getUniversity().getUniStatus() > UniStatus.SUBSCRIBE_PAGE_VERIFY.getValue()) {%>
        <div style="display: inline-block;margin-left: 20px">
            <a target="_blank" href="../documents/get-signed-sub-form.jsp?id=<%=university.getUniNationalId()%>"><img
                    class="topImageBtn" src="../images/pdf-icon.png"></a>


            شماره قرارداد:<%=university.getSubscriptionContractNo()%>
        </div>
        <%
                }
            }
        %>

    </div>



    <div class="topnav" id="topnav">
        <a href="javascript:void(0);" style="font-size:15px;" class="menuBtn" onclick="toggleNav()">منو &nbsp;
            &nbsp;&#9776;</a>
        <a href="../index.jsp" id="topLogoAnchor"><img id="topLogo" src="../images/logo.png"></a>
        <a href="index.jsp?page=info" id="firstNavItem">شبکه علمی چیست ؟</a>
        <a href="index.jsp?page=about">درباره ي ما</a>
        <a href="index.jsp?page=tariffs">خدمات و تعرفه ها</a>
        <a href="../co-operate/index.jsp">همکاری با شعا</a>
        <a href="index.jsp?page=contact-shoa">اطلاعات تماس</a>
        <a href="javascript:void(0);" class="optionsBtn" onclick="dropDown()">گزینه
            ها &nbsp;
            &nbsp;&#9776;</a>
    </div>
</div>
<div id="siteContent" >
    <div class="sidenav" id="sideNav">
        <% if (isContactPage) {%>
        <a href="contact-shoa.jsp" target="iframe" onclick="itemSelected('contact-shoa.jsp')">
            <img src="../images/lg-logo.jpg" style="width: 180px">
            <p style="text-align: center;color: #000;">اطلاعات تماس</p>
        </a>
        <div class="sideItems" style="top: 150px;">
            <div class="panel-group accordion" id="accordion" style="bottom:0;">
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" target="iframe" href="contact-shoa.jsp"
                           onclick="itemSelected('contact-shoa.jsp')">
                            شبکه علمی
                        </a>
                    </h3>
                </div>

                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse1">هسته و شرکاء اصلی</a>
                    </h3>
                    <div id="collapse1" class="panel-collapse collapse">
                        <a href="contact-pajohesh.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('contact-pajohesh.jsp')">
                            سازمان پژوهش های علمی و صنعتی ایران
                        </a>
                        <a href="contact-ito.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('contact-ito.jsp')">
                            سازمان فناوری اطلاعات ایران
                        </a>
                        <a href="contact-seemsys.jsp" target="iframe" class="active sub"
                           onclick="itemSelected('contact-seemsys.jsp')">
                            شرکت سیمرغ سامانه تهران
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse2">
                            سازمان ناظر</a>
                    </h3>
                    <div id="collapse2" class="panel-collapse collapse">
                        <a href="contact-radio.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('contact-radio.jsp')">
                            سازمان تنظیم مقررات و ارتباطات رادیوئی
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse3">
                            شرکاء تجاری اصلی
                        </a>
                    </h3>
                    <div id="collapse3" class="panel-collapse collapse">
                        <a href="contact-tic.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('contact-tic.jsp')">
                            شرکت ارتباطات زیرساخت
                        </a>
                        <a href="contact-tci.jsp" target="iframe" class="active sub"
                           onclick="itemSelected('contact-tci.jsp')">
                            شرکت مخابرات ایران
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class="panel-header-h panel-header-h-deactive">
                        <a class="collapse-header" href="#collapse1">
                            همکاران</a>
                    </h3>
                </div>
            </div>
        </div>
        <% } else if (isAboutPage) {%>
        <a href="contact-shoa.jsp" target="iframe" onclick="itemSelected('contact-shoa.jsp')">
            <img style="width: 180px" src="../images/lg-logo.jpg">
            <p style="text-align: center;text-decoration: none;color: #000;">درباره ما</p>
        </a>

        <div class="sideItems" style="top: 150px;">
            <div class="panel-group accordion" id="accordion" style="bottom:0;">
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse2">
                            مشارکت عمومی ـ خصوصی
                        </a>
                    </h3>
                    <div id="collapse2" class="panel-collapse collapse">
                        <a href="about-partnership.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('about-partnership.jsp')">
                            اپراتور شبکه علمی
                        </a>
                        <a href="about-what-partnership.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('about-what-partnership.jsp')">
                            مشارکت عمومی و خصوصی چیست ؟
                        </a>
                        <a href="about-assignment-instructions.jsp" target="iframe" class="active sub"
                           style="margin-bottom: 10px"
                           onclick="itemSelected('about-assignment-instructions.jsp')">
                            دستورالعمل شرایط واگذاری
                        </a>
                        <a href="show-doc.jsp?dest=about" target="iframe" class="active sub"
                           style="margin-bottom: 10px"
                           onclick="itemSelected('show-doc.jsp?dest=about')">
                            مقالات و مستندات
                        </a>
                        <a href="about-supervisor-organization.jsp" target="iframe" class="active sub"
                           style="margin-bottom: 10px"
                           onclick="itemSelected('about-supervisor-organization.jsp')">
                            اطلاعات تماس سازمان ناظر
                        </a>
                    </div>
                </div>

                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse1">تاریخچه</a>
                    </h3>
                    <div id="collapse1" class="panel-collapse collapse">
                        <a href="1st-gen.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('1st-gen.jsp')">
                            نسل اول
                        </a>
                        <a href="2nd-gen.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('2nd-gen.jsp')">
                            نسل دوم
                        </a>
                        <a href="3th-gen.jsp" target="iframe" class="active sub" onclick="itemSelected('3th-gen.jsp')">
                            نسل سوم
                            <br>
                            (شبکه خدمتگرا)
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" target="iframe" href="srv-oriented.jsp"
                           onclick="itemSelected('srv-oriented.jsp')">
                            شبکه خدمتگرا</a>
                    </h3>
                </div>
                <div class="panel panel-default">
                    <h3 class="panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse4">تفاهم نامه های اجرایی اپراتور</a>
                    </h3>
                    <div id="collapse4" class="panel-collapse collapse">
                        <a href="about-agreement-tci.jsp" target="iframe" style="margin-bottom: 10px" class="active sub"
                           onclick="itemSelected('about-agreement-tci.jsp')">
                            مخابرات ایران
                        </a>
                        <a href="about-agreement-state.jsp" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('about-agreement-state.jsp')">
                            تفاهم نامه استانی
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class="panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse3">
                            اخبار شبکه علمی ایران
                        </a>
                    </h3>
                    <div id="collapse3" class="panel-collapse collapse">
                        <a href="show-news.jsp?dest=operator" target="iframe" style="margin-bottom: 10px"
                           class="active sub"
                           onclick="itemSelected('show-news.jsp?dest=operator')">
                            استودیو شعا (شبکه علمی ایران)
                        </a>
                        <a href="#" target="iframe" style="margin-bottom: 10px" class="sub"
                           onclick="return false;">
                            صفحات اجتماعی
                        </a>
                        <a href="#" target="iframe" style="margin-bottom: 10px" class="sub" onclick="return false;">
                            گزارشات تصویری
                        </a>
                        <a href="show-news.jsp?dest=media" target="iframe" class="active sub"
                           onclick="itemSelected('show-news.jsp?dest=media')">
                            در آیینه ی دیگر رسانه ها
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <% } else if (isInfoPage) {%>
        <a href="info.jsp" target="iframe" onclick="itemSelected('info.jsp')">
            <img style="width: 180px" src="../images/lg-logo.jpg">
            <p style="text-align: center;color: #000;">شبکه علمی چیست؟</p>
        </a>
        <div class="sideItems" style="top: 150px;">
            <div class="panel-group accordion" id="accordion" style="bottom:0;">
                <div class="panel panel-default">
                    <h3 class="panel-header-h">
                        <a class="collapse-header" data-toggle="collapse" data-parent="#accordion"
                           href="#collapse2">
                            نقشه جامع علمی کشور
                        </a>
                    </h3>
                    <div id="collapse2" class="panel-collapse collapse">
                        <a href="info-intro.jsp" target="iframe" onclick="itemSelected('info-intro.jsp')"
                           class="active sub">
                            مقدمه
                        </a>
                        <a href="info-s1.jsp" target="iframe" onclick="itemSelected('info-s1.jsp')"
                           style="margin-top: 10px;"
                           class="active sub">
                            ارزش هاي بنيادين نقشه جامع علمي كشور
                        </a>
                        <a href="info-s2.jsp" target="iframe" onclick="itemSelected('info-s2.jsp')"
                           style="margin-top: 10px;"
                           class="active sub">
                            وضع مطلوب علم و فناوري
                        </a>
                        <a href="info-s3.jsp" target="iframe" onclick="itemSelected('info-s3.jsp')"
                           style="margin-top: 10px;"
                           class="active sub">
                            اولويت هاي علم و فناوري كشور
                        </a>
                        <a href="info-s4.jsp" target="iframe" onclick="itemSelected('info-s4.jsp')"
                           style="margin-top: 10px;"
                           class="active sub">
                            راهبردها و اقدامات ملي براي توسعه علم و فناوری در كشور
                        </a>
                        <a href="info-s5.jsp" target="iframe" onclick="itemSelected('info-s5.jsp')"
                           style="margin-top: 10px;"
                           class="active sub">
                            چارچوب نهادي علم و فناوري و نوآوري
                        </a>
                    </div>
                </div>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header" target="iframe"
                           href="info.jsp" onclick="itemSelected('info.jsp')">
                            چرائی شبکه علمی
                        </a>
                    </h3>
                </div>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header"
                           href="info-world.jsp"
                           target="iframe"
                           onclick="itemSelected('info-world.jsp')">گستره جهانی</a>
                    </h3>
                </div>
                <div class="panel panel-default">
                    <h3 class="panel-header-h">
                        <a class="collapse-header" target="iframe" href="show-doc.jsp?dest=info"
                           onclick="itemSelected('show-doc.jsp?dest=info')">
                            مقالات و مستندات
                        </a>
                    </h3>
                </div>
            </div>
        </div>

        <% } else if (isTariffPage) {%>
        <a href="info.jsp" target="iframe" onclick="itemSelected('info.jsp')">
            <img style="width: 180px" src="../images/lg-logo.jpg">
            <p style="text-align: center;color: #000;">تعرفه ها</p>
        </a>
        <div class="sideItems" style="top: 150px;">
            <div class="panel-group accordion" id="accordion" style="bottom:0;">
                <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) { %>
                <div class="panel panel-default">
                    <%
                        boolean catHaveServiceForm =
                                ServiceFormDAO.checkIfThereIsServiceFormForCat(serviceCategory.getId());
                    %>
                    <h3 class="panel-header-h<%=!catHaveServiceForm?" panel-header-h-deactive":""%>">
                        <a class="collapse-header" target="iframe"
                           href="tariffs.jsp?cat-id=<%=serviceCategory.getId()%>"
                           onclick="<%=catHaveServiceForm?"itemSelected('tariffs.jsp?cat-id="+serviceCategory.getId()+"')":"return false"%>">
                            <%=serviceCategory.getFaName()%>
                        </a>
                    </h3>
                </div>
                <%}%>
            </div>
        </div>
        <% } else { %>
        <a href="index.jsp?page=intro&sub-code=<%=subSystemCode.getValue()%>">
            <div class="menuTopIcon">
                <img src="../images/front-page/<%=subSystemCode.getImageURL()%>">
                <p><%=subSystemCode.getFaStr()%>
                </p>
            </div>
        </a>
        <%
            String buttonName="عضویت";
            if (uniSessionInfo.isSubSystemLoggedIn())
                if (university.getUniStatus() >= UniStatus.REGISTER_COMPLETED.getValue()) {
                    buttonName="پروفایل";
        %>
        <p style="text-align: center; width:inherit; margin: 10px 0; overflow-wrap: break-spaces">
            <%=university.getUniName()%>
        </p>
        <% } else if (university.getUniStatus() > UniStatus.REGISTER_PAGE_VERIFY.getValue()) {%>
        <p style="text-align: center;">
            <%=university.getUniName()%>
        </p>
        <% } else if(adminLoggedIn) {
            buttonName="پروفایل";
        }%>
        <div class="sideItems">
            <div class="panel-group accordion" id="accordion">
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header " data-toggle="collapse" data-parent="accordion"
                           href="#collapse1">
                            <%=buttonName%></a>
                    </h3>
                    <div id="collapse1" class="panel-collapse collapse">
                        <% if(!registerCompleted)
                        {
                        %>
                        <a target="iframe"
                           class="<%="active "%>sub"
                           onclick="<%="itemSelected('register.jsp?sub-code="+subSystemCode.getValue()+"')"%>"
                           href="register.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            عضویت
                        </a>
                        <%}if (registerCompleted) {%>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="requested-service-form.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            فرم اشتراک و سرویس فرم ها
                        </a>
                        <%}%>
                        <%
                            if (uniSessionInfo.isSubSystemLoggedIn() ?
                                    university.getUniStatus() >= UniStatus.SUBSCRIBE_PAGE.getValue() : false) {
                        %>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="agents-info.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            اطلاعات نمایندگان
                        </a>
                        <%
                            }
                            if (registerCompleted) {
                        %>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="add-buildings.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            اطلاعات ساختمان ها
                        </a>
                        <%
                            }
                            if (uniSessionInfo.isSubSystemLoggedIn() ?
                                    university.getUniStatus() >= UniStatus.SUBSCRIBE_PAGE.getValue() : false) {
                        %>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="show-contract-doc.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            مستندات مورد نیاز
                        </a>
                        <%
                            }
                            if (registerCompleted) {
                        %>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="subs-mails.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            نامه های ارسالی مشترک
                        </a>
                        <a target="iframe"
                           class="active sub"
                           onclick="itemSelected(event)"
                           href="subs-mails.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            نامه های ارسالی اپراتور
                        </a>
                        <%}%>
                    </div>
                </div>

                <%if (haveApprovingRole) {%>
                <div class="panel panel-default">
                    <h3 class=" panel-header-h">
                        <a class="collapse-header " target="iframe"
                           href="approving.jsp?sub-code=<%=subSystemCode.getValue()%>">
                            تایید درخواست ها
                        </a>
                    </h3>
                </div>
                <%}%>

                <% for (ServiceCategory serviceCategory : ServiceCategoryDAO.findAllCats()) {
                    boolean catHaveServiceForm = ServiceFormDAO.checkIfThereIsServiceFormForCat(serviceCategory.getId());
                %>
                <div class="panel panel-default">
                    <h3 class="panel-header-h<%=!registerCompleted||!catHaveServiceForm?" panel-header-h-deactive":""%>">
                        <a class="collapse-header"
                           target="iframe" <%=!registerCompleted || !catHaveServiceForm ? "onclick=\"return false\"" : ""%>
                           href="<%="tariffs.jsp?cat-id="+serviceCategory.getId()+"&action=select-service-form&sub-code="+subSystemCode.getValue()%>">
                            <%=serviceCategory.getFaName()%>
                        </a>
                    </h3>
                </div>
                <%}%>
                <div class="panel panel-default">
                    <h3 class="panel-header-list">
                        <a class="collapse-header" href="#">
                            <%=isCenter ? "فهرست مراکز پژوهشی عضو" : "فهرست دانشگاه ها و مراکز آموزش عالی عضو"%>
                        </a>
                    </h3>
                </div>
            </div>
        </div>
        <%}%>
    </div>
    <div id="mainFrame" style="margin-right: 270px;">
        <%
            String iframeURL = null;
            if (isCRM)
                iframeURL = "entry-page.jsp?sub-code=" + subSystemCode.getValue();
            if (pageParam != null)
                switch (pageParam) {
                    case "login":
                        iframeURL = "login.jsp";
                        break;
                    case "register":
                        iframeURL = "register.jsp?sub-code=" + subSystemCode.getValue();
                        break;
                    case "intro":
                        iframeURL = "entry-page.jsp?sub-code=" + subSystemCode.getValue();
                        break;
                    case "contact-shoa":
                        iframeURL = "contact-shoa.jsp";
                        break;
                    case "contact-it":
                        iframeURL = "contact-it.jsp";
                        break;
                    case "contact-pajohesh":
                        iframeURL = "contact-pajohesh.jsp";
                        break;
                    case "contact-seemsys":
                        iframeURL = "contact-seemsys.jsp";
                        break;
                    case "contact-tci":
                        iframeURL = "contact-tci.jsp";
                        break;
                    case "contact-radio":
                        iframeURL = "contact-radio.jsp";
                        break;
                    case "contact-tic":
                        iframeURL = "contact-tic.jsp";
                        break;
                    case "contact-ito":
                        iframeURL = "contact-ito.jsp";
                        break;
                    case "1st-gen":
                        iframeURL = "1st-gen.jsp";
                        break;
                    case "2nd-gen":
                        iframeURL = "2nd-gen.jsp";
                        break;
                    case "3th-gen":
                        iframeURL = "3th-gen.jsp";
                        break;
                    case "srv-oriented":
                        iframeURL = "srv-oriented.jsp";
                        break;
                    case "about":
                        iframeURL = "contact-shoa.jsp";
                        break;
                    case "info":
                        iframeURL = "info.jsp";
                        break;
                    case "info-s1":
                        iframeURL = "info-s1.jsp";
                        break;
                    case "info-s2":
                        iframeURL = "info-s2.jsp";
                        break;
                    case "info-s3":
                        iframeURL = "info-s3.jsp";
                        break;
                    case "info-s4":
                        iframeURL = "info-s4.jsp";
                        break;
                    case "info-s5":
                        iframeURL = "info-s5.jsp";
                        break;
                    case "info-doc":
                        iframeURL = "show-doc.jsp?dest=info";
                        break;
                    case "info-world":
                        iframeURL = "info-world.jsp";
                        break;
                    case "about-assignment-instructions":
                        iframeURL = "about-assignment-instructions.jsp";
                        break;
                    case "about-partnership":
                        iframeURL = "about-partnership.jsp";
                        break;
                    case "about-supervisor-organization":
                        iframeURL = "about-supervisor-organization.jsp";
                        break;
                    case "about-what-partnership":
                        iframeURL = "about-what-partnership.jsp";
                        break;
                    case "about-doc":
                        iframeURL = "show-doc.jsp?dest=about";
                        break;
                    case "about-agreement-tci":
                        iframeURL = "about-agreement-tci.jsp";
                        break;
                    case "about-agreement-state":
                        iframeURL = "about-agreement-state.jsp";
                        break;
                    case "register-unit-manager":
                        iframeURL = "register-unit-manager.jsp";
                        break;
                    case "register-agent":
                        iframeURL = "register-agent.jsp";
                        break;
                    case "unit-manager":
                        iframeURL = "unit-manager.jsp";
                        break;
                    case "tariffs":
                        iframeURL = "tariffs.jsp?cat-id=1";
                        break;
                }
            if (isCRM)
                if (uniSessionInfo.isSubSystemLoggedIn())
                    if (userRole.getValidity() < Validity.ACTIVE.getValue())
                        iframeURL = "login.jsp?sub-code=" + subSystemCode.getValue();
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
</body>
</html>