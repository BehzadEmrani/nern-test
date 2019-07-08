<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.Date" %>
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
            size: 297mm 210mm;
            margin: 0;
        }

        body {
            width: 290mm;
            margin: auto;
        }

        .pageLayout {
            height: 205mm;
            padding: 15mm;
            direction: rtl;
            position: relative;
        }

        .pageBackGround {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 80%;
            margin-top: -250px; /* Half the height */
            margin-left: -40%; /* Half the width */
            z-index: -1;
        }

        .featuresBox {
            border: 1px solid black;
            padding: 5px 20px;
            margin-bottom: 12px;
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

        #serviceTable {
            border: 1px black solid;
            width: 100%;
            text-align: center;
        }

        #serviceTable td, th {
            border: 1px solid black;
        }

    </style>
</head>
<body>
<div class="pageLayout">
    <img src="../images/university/service-form/bg.png" class="pageBackGround">
    <table>
        <tr>
            <td>
                <img src="../images/university/service-form/top.png" style="display: inline-block">
            </td>
            <td>
                <div style="display: inline-block;margin: auto;padding: 20px">
                    <b>
                        شرکت خدمات و ارتباطات شبکه علمی سیمرغ
                    </b>
                    <br>
                    شناسه‌ی ملی:14006907204
                    <br>
                    کد اقتصادی:411558116437
                    <br>
                    تهران، خیابان بهشتی، خیابان مفتح شمالی،
                    <br>
                    پلاک 390، واحد 44
                    <br>

                    کدپستی:1587815143
                    <br>
                </div>
            </td>
        </tr>
        <tr>
            <td style="width: 50%;" colspan="2">
                <div class="featuresBox">
                    <b class="boxTitles"> مشخصات مشترک</b>
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
                            <td>
                                <%=subsUni.getUniNationalId()%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                کد اقتصادی
                            </td>
                            <td>
                                <%=subsUni.getEcoCode()%>
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
                        </tr>
                    </table>
                </div>
                <div class="featuresBox">
                    <b class="boxTitles"> مشخصات اشتراک</b>
                    <table class="featuresTable">
                        <tr>
                            <td style="width:170px;">
                                شماره ی اشتراک
                            </td>
                            <td colspan="3">
                                <%=subsUni.getSubscriptionContractNo()%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                تاریخ اشتراک
                            </td>
                            <td>
                                <%=Util.convertGregorianToJalaliNoWeekDay(subsUni.getSubscriptionContractDate())%>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
            <td style="width: 50%;vertical-align: top;padding-right: 20px;" colspan="2">
                <div class="">
                    <table class="featuresTable">
                        <tr>
                            <td style="width:170px;">
                                تاریخ صدور
                            </td>
                            <td colspan="3">
                                <%=Util.convertGregorianToJalaliNoWeekDay(new Date())%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                سریال قبض
                            </td>
                            <td>
                                ۱۲۳۴۵۶۷۸۹
                            </td>
                        </tr>
                        <tr>
                            <td>
                                شناسه قبض
                            </td>
                            <td>
                                ۹۸۷۶۵۴۳۲۱
                            </td>
                        </tr>
                        </tr>
                        <tr>
                        </tr>
                        <tr>
                            <td>
                                شناسه ی پرداخت
                            </td>
                            <td>
                                ۰۰۰۰۰۰۰۰
                            </td>
                        </tr>

                        <tr>
                            <td>
                                مبلغ قابل پرداخت
                            </td>
                            <td style="font-weight: bold">
                                <%=String.format("%,.0f",(serviceFormParameter.getDeposit()+serviceFormParameter.getInitialCost())*1.09)%>ریال
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-weight: bold">
                                صد پنجاه و نه میلیون و صد و چهل هزار ریال
                            </td>
                        </tr>
                        <tr>
                            <td>
                                مهلت پرداخت
                            </td>
                            <td>
                                <%=Util.convertGregorianToJalaliNoWeekDay(new Date())%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <img src="../images/barcode-sample.png"
                                     style="width: 100%;margin-bottom: 20px;height: 15mm;">
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <table id="serviceTable">
        <tr>
            <th>
                ردیف
            </th>
            <th>
                شماره سرویس فرم
            </th>
            <th>
                تعریف کلی خدمت
            </th>
            <th>
                شرح زیر خدمت
            </th>
            <th>
                محل دریافت خدمت
            </th>
            <th>
                مشخصات خدمت
            </th>
            <th>
                هزینه اولیه(نصب)
            </th>
            <th>
                وجه‌التضمین سرویس (ودیعه)
            </th>
            <th>
                مالیات بر ارزش افزوده
            </th>
            <th>
                جمع
            </th>
        </tr>
        <tr>
            <td>
                1
            </td>
            <td>
                1234567
            </td>
            <td>
                <%=subService.getFaName()%>
            </td>
            <td>
                <%=serviceFormParameter.getSpecs()%>
            </td>
            <td>
                <%=buildingState.getName()%>-<%=buildingCity.getName()%>-<%=subsBuilding.getBuildingName()%>
            </td>
            <td>
                نوع پرداخت:           <%=PayType.fromValue(serviceForm.getPayTypeVal()).getFaStr()%>-
                مدت قرارداد:     <%=SubsDuration.fromValue(serviceForm.getSubsDuration()).getFaStr()%>-
                دوره پرداخت: <%=PayPeriod.fromValue(serviceForm.getPayPeriod()).getFaStr()%>-
                SLA:<%=SLAType.fromValue(serviceForm.getSlaVal()).getFaStr()%>
            </td>

            <td>
                <%=String.format("%,d",serviceFormParameter.getInitialCost())%>
            </td>
            <td>
                <%=String.format("%,d",serviceFormParameter.getDeposit())%>
            </td>
            <td>
                <%=String.format("%,.0f",(serviceFormParameter.getDeposit()+serviceFormParameter.getInitialCost())*0.09)%>
            </td>
            <td>
                <%=String.format("%,.0f",(serviceFormParameter.getDeposit()+serviceFormParameter.getInitialCost())*1.09)%>
            </td>
        </tr>
        <tr>
            <td colspan="9">
                جمع کل
            </td>
            <td>
                <%=String.format("%,.0f",(serviceFormParameter.getDeposit()+serviceFormParameter.getInitialCost())*1.09)%>
            </td>
        </tr>
    </table>
    <div style="border: 1px solid black;height: 40mm;position: absolute;bottom: 20px ;right: 5%;width: 90%;padding: 20px">
        <p style="font-size: 18pt;text-align: center">
            مشترک گرامی برای اطلاع از اخرین سرویس ها و خدمات شبکه علمی ایران به سایت شبکه علمی به نشانی
            www.nern.ir
            مراجعه نمایید
        </p>
    </div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script>
    //    window.print();
</script>
</body>
</html>