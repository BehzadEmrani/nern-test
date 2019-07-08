<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    boolean readSubAccess = false;
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = null;
    SubSystemCode subSystemCode = null;
    UserRoleType userRoleType = null;
    University university = null;
    UniStatus uniStatus = null;
    UniSessionInfo uniSessionInfo = null;
    if (adminSessionInfo.isAdminLogedIn()) {
        admin = adminSessionInfo.getAdmin();
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.SEE_REQUESTED_SERVICE_FORMS.getValue())) {
            response.sendError(403);
            return;
        } else {
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.SERVICES_ADD_SERVICE_FORM.getValue(),
                    AdminSubAccessType.READ.getValue());
            if (!readSubAccess) {
                response.sendError(403);
                return;
            }
        }
    } else {
        subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
        userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
        uniSessionInfo = new UniSessionInfo(session, userRoleType);
        if (!uniSessionInfo.isSubSystemLoggedIn()) {
            response.sendError(401);
            return;
        }
        university = uniSessionInfo.getUniversity();
        uniStatus = UniStatus.fromValue(university.getUniStatus());
        if (uniStatus.getValue() < UniStatus.REGISTER_COMPLETED.getValue()) {
            response.sendError(403);
            return;
        }
    }

    ServiceFormRequest serviceFormRequest = ServiceFormRequestDAO.findServiceFormRequestById(
            Long.valueOf(request.getParameter("request-id")));

    ServiceFormParameter serviceFormParameter = ServiceFormParameterDAO.findServiceFormParameterById(
            serviceFormRequest.getServiceFormParameterId());
    ServiceForm serviceForm = ServiceFormDAO.findServiceFormById(serviceFormParameter.getServiceFormId());
    SubService subService = SubServiceDAO.findSubServiceById(serviceForm.getSubServiceId());
    List<SubServiceParameter> subServiceParameters =
            SubServiceParameterDAO.findSubServiceParameterBySubServiceId(subService.getId());

    SubsBuilding subsBuilding = SubsBuildingDAO.findSubsBuildingById(serviceFormRequest.getSubsBuildingId());

    City buildingCity = CityDAO.findCityById(subsBuilding.getCityId());
    State buildingState = StateDAO.findStateById(buildingCity.getStateId());

    Agent buildingAgent = AgentDAO.findAgentById(subsBuilding.getAgentId());
    PersonalInfo buildingPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(buildingAgent.getNationalId());

    University subsUni = UniversityDAO.findUniByUniNationalId(serviceFormRequest.getUniId());
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
        @media print {
        }

        @font-face {
            font-family: BTitr;
            src: url("../fonts/BTitrBd.ttf");
        }

        @page {
            size: 210mm 297mm;
            margin: 0;
        }

        body {
            width: 210mm;
            margin: auto;
        }

        .pageLayout {
            height: 296mm;
            border: 1px solid black;
            padding: 15mm;
            direction: rtl;
            position: relative;
        }

        .pageBackGround {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 80%;
            margin-top: -157px; /* Half the height */
            margin-left: -40%; /* Half the width */
            z-index: -1;
        }

        .pageHeader {
            border-bottom: 3px solid black;
            float: right;
            width: 100%;
            margin-bottom: 30px;
        }

        .headerLogo {
            float: right;
            margin-top: -100px;
            margin-bottom: 10px;
            height: 100px;
        }

        .pageHeader h1 {
            text-align: center;
            font-size: 12pt;
            font-family: BTitr !important;
            white-space: pre-line;
        }

        .timeAndNo {
            float: left;
            margin-top: -60px;
            padding-left: 100px;
            margin-bottom: 10px;
        }

        .timeAndNo p {
            margin: 0;
        }

        .pageBody {

        }

        .boxTitles {
            font-family: BTitr;
            margin: 10px 0;
        }

        .featuresTable {
            width: 100%;
        }

        .featuresBox {
            border: 1px solid black;
            padding: 5px 20px;
            margin-bottom: 12px;
        }

        .pageFooter {
            position: absolute;
            bottom: 0;
            right: 0;
            border-top: 1px solid black;
            width: 100%;
            padding: 10px 15mm;
        }

        .pageFooter table {
            width: 100%;
        }
    </style>
</head>
<body>
<div class="pageLayout">
    <img src="../images/university/service-form/bg.png" class="pageBackGround">
    <div class="pageHeader">
        <h1>
            باسمه تعالی
            فرم استفاده از خدمات و امکانات
            (سرویس‌فرم)
        </h1>
        <img src="../images/university/service-form/top.png" class="headerLogo">
        <div class="timeAndNo">
            <p>شماره الحاقیه:</p>
            <p>تاریخ الحاقیه:</p>
            <p>صفحه 1 از 3</p>
        </div>
    </div>
    <div class="pageBody">
        <p>
            پیرو قرارداد اشتراک خدمات و امکانات شبکه‌ی علمی کشور به شماره
            <%=subsUni.getSubscriptionContractNo()%>
            و تاریخ
            <%=Util.convertGregorianToJalaliNoWeekDay(subsUni.getSubscriptionContractDate())%>
            و
            بر اساس بند 3-15 آن
            <%=subsUni.getUniName()%>
            با شناسه‌ی ملی
            <span style="direction: ltr;display: inline-block;"><%=subsUni.nationalIdForContract()%></span>
            متقاضی واگذاری خدمات و امکانات اشاره شده در
            این فرم است، لذا این فرم به عنوان الحاقیه‌ی لاینفک قرارداد مذکور در دو نسخه بین طرفین امضا و مبادله می‌شود.
        </p>
        <b class="boxTitles">1- مشخصات شرکت</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <td style="width:170px;">
                        نام کامل شرکت
                    </td>
                    <td colspan="3">
                        شرکت خدمات و ارتباطات شبکه علمی سیمرغ
                    </td>
                </tr>
                <tr>
                    <td>
                        شناسه‌ی ملی
                    </td>
                    <td>
                        14006907204
                    </td>
                    <td>
                        کد اقتصادی
                    </td>
                    <td>
                        411558116437
                    </td>
                </tr>
                <tr>
                    <td>
                        نام و نام خانوادگی مقام مجاز
                    </td>
                    <td>
                        سادینا آبائی
                    </td>
                    <td>
                        کد ملی
                    </td>
                    <td>
                        3961769311
                    </td>
                </tr>
                <tr>
                    <td>
                        سمت سازمانی
                    </td>
                    <td>
                        رییس هیات مدیره
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        نشانی دقیق پستی
                    </td>
                    <td colspan="3">
                        تهران، خیابان بهشتی، خیابان مفتح شمالی، پلاک 390، واحد 44
                    </td>
                </tr>
                <tr>
                    <td>
                        کدپستی
                    </td>
                    <td>
                        1587815143
                    </td>
                    <td>
                        نشانی پست الکترونیکی
                    </td>
                    <td>
                        Sales@NERN.ir
                    </td>
                </tr>
                <tr>
                    <td>
                        تلفن
                    </td>
                    <td>
                        9361 8874 (9821+)
                    </td>
                    <td>
                        دورنگار
                    </td>
                    <td>
                        9360 8874 (9821+)
                    </td>
                </tr>
            </table>
        </div>

        <b class="boxTitles">2- مشخصات مشترک</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <td style="width:170px;">
                        نام کامل مشترک
                    </td>
                    <td colspan="3">
                        <%=subsUni.getUniName()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        شناسه‌ی ملی
                    </td>
                    <td style="direction: ltr">
                        <%=subsUni.nationalIdForContract()%>
                    </td>
                    <td>
                        کد اقتصادی
                    </td>
                    <td>
                        <%=subsUni.getEcoCode()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        نام و نام خانوادگی مقام مجاز
                    </td>
                    <td>
                        <%=subsUni.getSignatoryName()%>
                    </td>
                    <td>
                        کد ملی
                    </td>
                    <td>
                        <%=subsUni.getSignatoryNationalId()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        سمت سازمانی
                    </td>
                    <td>
                        <%=subsUni.getSignatoryPos()%>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        نشانی دقیق پستی
                    </td>
                    <td colspan="3">
                        <%=subsUni.getAddress()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        کدپستی
                    </td>
                    <td>
                        <%=subsUni.getPostalCode()%>
                    </td>
                    <td>
                        نشانی پست الکترونیکی
                    </td>
                    <td>
                        <%=subsUni.getUniPublicEmail()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        تلفن
                    </td>
                    <td>
                        <%=subsUni.getTeleNo()%>
                    </td>
                    <td>
                        دورنگار
                    </td>
                    <td>
                        <%=subsUni.getFaxNo()%>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <b class="boxTitles">3- مشخصات محل تحویل خدمت</b>
    <div class="featuresBox">
        <table class="featuresTable">
            <tr>
                <td style="width:170px;">
                    نام ساختمان
                </td>
                <td colspan="3">
                    <%=subsBuilding.getBuildingName()%>
                </td>
            </tr>
            <tr>
                <td style="width:170px;">
                    استان
                </td>
                <td>
                    <%=buildingState.getName()%>
                </td>
                <td>
                    شهر
                </td>
                <td>
                    <%=buildingCity.getName()%>
                </td>
            </tr>
            <tr>
                <td>
                    نشانی دقیق پستی
                </td>
                <td colspan="3">
                    <%=subsBuilding.getAddress()%>
                </td>
            </tr>
            <tr>
                <td>
                    کد پستی
                </td>
                <td>
                    <%=subsBuilding.getPostalCode()%>
                </td>
                <td>
                    تلفن۱:
                </td>
                <td>
                    <%=subsBuilding.getFirstTel()%>
                </td>
            </tr>
            <tr>
                <td>
                    تلفن۲:
                </td>
                <td>
                    <%=subsBuilding.getSecondTel()%>
                </td>
                <td>
                    دورنگار
                </td>
                <td>
                    <%=subsBuilding.getFax()%>
                </td>
            </tr>
            <tr>
                <td>
                    طول جغرافیایی
                </td>
                <td>
                    <%=new DecimalFormat("#.####").format(subsBuilding.getMapLocLng())%>
                </td>
                <td>
                    عرض جغرافیایی
                </td>
                <td>
                    <%=new DecimalFormat("#.####").format(subsBuilding.getMapLocLat())%>
                </td>
            </tr>
        </table>
    </div>
    <b class="boxTitles">4- مشخصات ارتباطی</b>
    <div class="featuresBox">
        <table class="featuresTable">
            <tr>
                <td style="width:170px;">
                    نام مرکز مخابراتی مربوطه
                </td>
                <td colspan="3">
                    <%=subsBuilding.getTelecomName()%>
                </td>
            </tr>
            <tr>
                <td style="width:170px;">
                    وضعیت فیبر نوری با مخابرات
                </td>
                <td>
                    <input type="radio" name="have-fiber" <%=subsBuilding.getHaveFiber()?"checked":""%> disabled>
                    <label>دارد</label>
                </td>
                <td>
                    تعداد core فیبر:
                    <%=subsBuilding.getHaveFiber() ? subsBuilding.getFiberCoreCount() : ""%>
                </td>
                <td>
                    تعداد core آزاد:
                    <%=subsBuilding.getHaveFiber() && subsBuilding.getHaveFreeFiber() ? subsBuilding.getFreeFiberCoreCount() : ""%>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                    شماره قرارداد فیبر نوری (fos)
                </td>
                <td>
                    <%=subsBuilding.getHaveFiber() && subsBuilding.getHaveFreeFiber() ? subsBuilding.getFirstFosContract() : ""%>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                    شماره قرارداد فیبر نوری (fos)
                </td>
                <td>
                    <%=subsBuilding.getHaveFiber() && subsBuilding.getHaveFreeFiber() ? subsBuilding.getSecondFosContract() : ""%>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <input type="radio" name="have-fiber" <%=!subsBuilding.getHaveFiber()?"checked":""%> disabled>
                    <label>ندارد</label>
                </td>
                <td>
                    فاصله تقریبی تا مرکز
                </td>
                <td>
                    <%=!subsBuilding.getHaveFiber() ? subsBuilding.getDistanceToTelecom() : ""%>
                </td>
            </tr>
        </table>
    </div>
    <div class="pageFooter">
        <table>
            <tr>
                <td>مهر و امضای مشترک</td>
                <td></td>
                <td>مهر و امضای شرکت</td>
                <td></td>
            </tr>
            <tr>
                <td>نام و نام خانوادگی</td>
                <td><%=subsUni.getSignatoryName()%>
                </td>
                <td>نام و نام خانوادگی</td>
                <td>سادینا آبائی</td>
            </tr>
            <tr>
                <td>سمت</td>
                <td><%=subsUni.getSignatoryPos()%>
                </td>
                <td>سمت</td>
                <td>رییس هیأت مدیره</td>
            </tr>
        </table>
    </div>
</div>
<div class="pageLayout">
    <img src="../images/university/service-form/bg.png" class="pageBackGround">
    <div class="pageHeader">
        <h1>
            فرم استفاده از خدمات و امکانات
            (سرویس‌فرم)
        </h1>
        <img src="../images/university/service-form/top.png" class="headerLogo">
        <div class="timeAndNo">
            <p>شماره الحاقیه:</p>
            <p>تاریخ الحاقیه:</p>
            <p>صفحه 2 از 3</p>
        </div>
    </div>
    <div class="pageBody">
        <b class="boxTitles">5- مشخصات تحویل گیرنده خدمت</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <td style="width:170px;">
                        نام و نام خانوادگی
                    </td>
                    <td>
                        <%=buildingPersonalInfo.combineName()%>
                    </td>
                    <td>
                        سمت
                    </td>
                    <td>
                        <%=buildingAgent.getAgentPos()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        تلفن
                    </td>
                    <td>
                        <%=buildingAgent.getTelNo()%>
                    </td>
                    <td>
                        دورنگار
                    </td>
                    <td>
                        <%=buildingAgent.getFaxNo()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        ایمیل
                    </td>
                    <td>
                        <%=buildingAgent.getSupportEmail()%>
                    </td>
                    <td>
                        تلفن همراه
                    </td>
                    <td>
                        <%=buildingAgent.getMobileNo()%>
                    </td>
                </tr>
            </table>
        </div>
        <b class="boxTitles">6- مشخصات سرویس مورد تقاضا</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <td style="width: 170px">
                        شناسه خدمت
                    </td>
                    <td colspan="3">
                        <%=serviceForm.combine() + "-" + serviceFormParameter.getCode()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        تعریف کلی خدمت
                    </td>
                    <td colspan="3">
                        <%=subService.getFaName()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        شرح زیر خدمت
                    </td>
                    <td colspan="3">
                        <%=serviceFormParameter.getSpecs()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        نوع پرداخت
                    </td>
                    <td colspan="3">
                        <%=PayType.fromValue(serviceForm.getPayTypeVal()).getFaStr()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        مدت قرارداد
                    </td>
                    <td>
                        <%=SubsDuration.fromValue(serviceForm.getSubsDuration()).getFaStr()%>
                    </td>
                    <td>
                        دوره پرداخت
                    </td>
                    <td>
                        <%=PayPeriod.fromValue(serviceForm.getPayPeriod()).getFaStr()%>
                    </td>
                </tr>
            </table>
        </div>
        <b class="boxTitles">7- مشخصات سطح سرویس خدمات (SLA)</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <th style="width: 170px;"></th>
                    <th></th>
                    <th style="width:40%"></th>
                    <th></th>
                </tr>
                <tr>
                    <td>
                        سطح خدمات
                    </td>
                    <td colspan="3">
                        <%=SLAType.fromValue(serviceForm.getSlaVal()).getFaStr() + " - " + subService.getSlaMeasurement()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        مرجع تصویب
                    </td>
                    <td colspan="3">
                        <%=SubServiceApproveType.fromValue(subService.getApproveTypeVal()).getFaStr() + " جلسه شماره:" + subService.getApproveSessionNo()%>
                    </td>
                </tr>
                <% for (SubServiceParameter subServiceParameter : subServiceParameters) {%>
                <tr>
                    <td colspan="2">
                        <%=subServiceParameter.getFaName()%>
                    </td>
                    <td>
                        <%=subServiceParameter.valueBySLAVal(serviceForm.getSlaVal())
                                + Unit.fromValue(subServiceParameter.getUnitVal()).combinedFaStr()%>
                    </td>
                    <td></td>
                </tr>
                <%}%>
            </table>
        </div>
        <b class="boxTitles">8- شرایط اختصاصی خدمت</b>
        <div class="featuresBox">
            <p style="white-space: pre-line"><%=subService.getExclusiveTerms()%>
            </p>
        </div>
        <b class="boxTitles">9- هزینه‌ها (به مبالغ زیر مالیات ارزش افزوده و سایر حقوق و عوارض مطابق قوانین اضافه
            می‌شود)</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <th style="width: 400px"></th>
                    <th style="width: 120px"></th>
                    <th></th>
                    <th style="width: 200px"></th>
                </tr>
                <tr>
                    <td>
                        هزینه اولیه (نصب)
                    </td>
                    <td>
                        <%=String.format("%,d",serviceFormParameter.getInitialCost())%>
                    </td>
                    <td colspan="2">
                        ریال یک‌بار پرداخت می‌شود
                    </td>
                </tr>
                <tr>
                    <td>
                        هزینه خدمات درخواستی
                    </td>
                    <td>
                        <%=String.format("%,d",serviceFormParameter.getPeriodicPayment())%>
                    </td>
                    <td colspan="2">
                        ریال مطابق دوره‌ی پرداخت
                    </td>
                </tr>
                <tr>
                    <td>
                        سایر هزینه ها:<%=subService.getOtherCostTitle()%>
                    </td>
                    <td>
                        <%=String.format("%,d",serviceFormParameter.getOtherCost())%>
                    </td>
                    <td colspan="2">
                        ریال
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="pageFooter">
        <table>
            <tr>
                <td>مهر و امضای مشترک</td>
                <td></td>
                <td>مهر و امضای شرکت</td>
                <td></td>
            </tr>
            <tr>
                <td>نام و نام خانوادگی</td>
                <td><%=subsUni.getSignatoryName()%>
                </td>
                <td>نام و نام خانوادگی</td>
                <td>سادینا آبائی</td>
            </tr>
            <tr>
                <td>سمت</td>
                <td><%=subsUni.getSignatoryPos()%>
                </td>
                <td>سمت</td>
                <td>رییس هیأت مدیره</td>
            </tr>
        </table>
    </div>
</div>


<div class="pageLayout">
    <img src="../images/university/service-form/bg.png" class="pageBackGround">
    <div class="pageHeader">
        <h1>
            فرم استفاده از خدمات و امکانات
            (سرویس‌فرم)
        </h1>
        <img src="../images/university/service-form/top.png" class="headerLogo">
        <div class="timeAndNo">
            <p>شماره الحاقیه:</p>
            <p>تاریخ الحاقیه:</p>
            <p>صفحه 3 از 3</p>
        </div>
    </div>
    <div class="pageBody">


        <b class="boxTitles">10- وجه‌التضمین (ودیعه)</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <th style="width: 400px"></th>
                    <th style="width: 120px"></th>
                    <th></th>
                    <th style="width: 200px"></th>
                </tr>
                <tr>
                    <td>
                        وجه‌التضمین سرویس (ودیعه) به مبلغ
                    </td>
                    <td>
                        <%=String.format("%,d",serviceFormParameter.getDeposit())%>
                    </td>
                    <td colspan="2">
                        ریال
                    </td>
                </tr>
                <tr>
                    <td>
                        ضمانت‌نامه‌ی بانکی به مبلغ
                    </td>
                    <td>
                        <%=String.format("%,d",serviceFormParameter.getWarranty())%>
                    </td>
                    <td colspan="2">
                        ریال
                    </td>
                </tr>
            </table>
        </div>
        <b class="boxTitles">11- جرایم و تشویق‌ها</b>
        <div class="featuresBox">
            <table class="featuresTable">
                <tr>
                    <td>
                        مبلغ جریمه به ازای هر روز تاخیر در پرداخت صورت‌حساب
                    </td>
                    <td>
                        365 / (مبلغ بدهی نرخ سود سپرده یک ساله)
                    </td>
                </tr>
                <tr>
                    <td>
                        مبلغ تشویق به ازای هر روز تعجیل در پرداخت صورت‌حساب
                    </td>
                    <td>
                        365 / (مبلغ صورت‌حساب نرخ سود سپرده یک ساله)
                    </td>
                </tr>
            </table>
        </div>
        <b class="boxTitles">12- سایر شرایط و الزامات خدمت</b>
        <div class="featuresBox">
            <p style="white-space: pre-line"><%=serviceForm.getOtherTerms()%>
            </p>
        </div>
    </div>
    <div class="pageFooter">
        <table>
            <tr>
                <td>مهر و امضای مشترک</td>
                <td></td>
                <td>مهر و امضای شرکت</td>
                <td></td>
            </tr>
            <tr>
                <td>نام و نام خانوادگی</td>
                <td><%=subsUni.getSignatoryName()%>
                </td>
                <td>نام و نام خانوادگی</td>
                <td>سادینا آبائی</td>
            </tr>
            <tr>
                <td>سمت</td>
                <td><%=subsUni.getSignatoryPos()%>
                </td>
                <td>سمت</td>
                <td>رییس هیأت مدیره</td>
            </tr>
        </table>
    </div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script>
    window.print();
</script>
</body>
</html>