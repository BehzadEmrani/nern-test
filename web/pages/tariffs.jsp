<%@ page import="com.atrosys.dao.ServiceDAO" %>
<%@ page import="com.atrosys.entity.Service" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    Long catId = Long.valueOf(request.getParameter("cat-id"));

    Unit[] units = Unit.values();
    HashMap<Integer, String> unitDic = new HashMap<>();
    for (Unit unit : units)
        unitDic.put(unit.getValue(), unit.getFaStr());
    String unitsJson = new Gson().toJson(unitDic).replaceAll("\"", "'");


    boolean isSelectServiceForm = "select-service-form".equals(request.getParameter("action"));

    UniSessionInfo uniSessionInfo = null;
    SubSystemCode subSystemCode = null;
    UserRoleType userRoleType = null;
    University university = null;
    UniStatus uniStatus = null;
    if (isSelectServiceForm) {
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
        .serviceFormHeaderRow {
            background: #41709c;
            color: white;
        }

        input[type=radio] {
            margin-right: 10px;
        }

        input[type=radio]:disabled + label {
            color: #8c8c8c;
        }

        .selectTd > input {
            margin: 0;
        }
    </style>
</head>
<body>
<div class="formBox">
    <h3>تعرفه‌ی خدمات</h3>
    <div class="formRow">
        <div class="formItem">
            <label>خدمت :</label>
            <select class="formSelect" id="service-select" style="width: 200px;">
                <% for (Service service : ServiceDAO.findServicesByCatId(catId)) {%>
                <option value="<%=service.getId()%>">
                    <%=service.getFaName()%>
                </option>
                <%}%>
            </select>
        </div>
        <div class="formItem" style="margin-right:20px;">
            <label>زیر خدمت :</label>
            <select class="formSelect" id="sub-service-select" name="sub-service-id" style="width: 200px;">
            </select>
        </div>
    </div>
    <br>
    <div class="formRow">
        سرشناسه خدمت:
        <span style="margin-right: 20px; " id="service-form-combine"></span>
    </div>
    <div class="formRow">
        تعریف کلی خدمت:
        <span style="margin-right: 20px; " id="sub-service-name"></span>
    </div>
    <div class="formRow">
        <label style="margin-left:41px">نوع پرداخت :</label>
        <% for (PayType payType : PayType.values()) {%>
        <input type="radio" name="pay-type" value="<%=payType.getValue()%>">
        <label><%=payType.getFaStr()%>
        </label>
        <%}%>
    </div>
    <div class="formRow">
        <label>مدت قرارداد :</label>
        <div class="formRow" style="margin-right: 112px;margin-top: -27px;">
            <% for (SubsDuration subsDuration : SubsDuration.values()) {%>
            <%=subsDuration.getValue() == 24 ? "<br>" : ""%>
            <input type="radio" name="subs-duration" value="<%=subsDuration.getValue()%>">
            <label><%=subsDuration.getFaStr()%>
            </label>
            <%}%>
        </div>
    </div>
    <div class="formRow">
        <label>دوره پرداخت :</label>
        <div class="formRow" style="margin-right: 112px;margin-top: -27px;">
            <% for (PayPeriod payPeriod : PayPeriod.values()) {%>
            <%=payPeriod.getValue() == 0 ? "<br>" : ""%>
            <input type="radio" name="pay-period" value="<%=payPeriod.getValue()%>">
            <label><%=payPeriod.getFaStr()%>
            </label>
            <%}%>
        </div>
    </div>
    <br>
    <div class="formRow">سطح خدمات SLA (<span id="sla-measurement"></span>)</div>
    <div class="formBox">
        <div class="formRow">
            <label>نوع SLA:</label>
            <% for (SLAType slaType : SLAType.values()) {%>
            <input type="radio" name="sla-type" value="<%=slaType.getValue()%>">
            <label><%=slaType.getFaStr()%>
            </label>
            <%}%>
        </div>
        <div class="formRow">
            <span>
                <input name="approve-type" id="approve-type-1" type="radio" disabled style="margin-right: 0">
                مصوبه‌ی <%=SubServiceApproveType.REGULATORY.getFaStr()%>
                <span> جلسه:
                    <span id="approve-session-no-1"></span>
                </span>
            </span>
            <span>
                <input name="approve-type" id="approve-type-2" type="radio" disabled>
                مصوبه‌ی <%=SubServiceApproveType.BOARD.getFaStr()%>
                <span> جلسه:
                    <span id="approve-session-no-2"></span>
                </span>
            </span>
        </div>

        <div class="formRow" id="sla-parameters" units="<%=unitsJson%>">

        </div>
    </div>
    <br>
    <div class="formRow">
        <label>شرایط اختصاصی خدمت :</label>
        <p style="white-space: pre-line;" id="exclusive-terms"></p>
    </div>
    <%if (isSelectServiceForm) {%>
    <form action="select-building.jsp">
        <input type="hidden" name="action" value="send-service-form">
        <input type="hidden" name="cat-id" value="<%=catId%>">
        <input type="hidden" name="action" value="service-form-send">
        <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
        <%}%>
        <div class="formRow">
            <table class="formTable" id="service-form-table">
                <thead>
                <tr class="serviceFormHeaderRow">
                    <th colspan="<%=isSelectServiceForm?"14":"11"%>">
                        تعرفه خدمات به ریال
                    </th>
                </tr>
                <tr class="serviceFormHeaderRow">
                    <%if (isSelectServiceForm) {%>
                    <th colspan="3" rowspan="2"></th>
                    <%}%>
                    <th colspan="3" rowspan="2">
                        زیر شناسه خدمت
                    </th>
                    <th colspan="3" rowspan="2">
                        شرح زیر خدمت
                    </th>
                    <th colspan="5" rowspan="1">
                        تعهدات مالی مشترک(خدمت گیرنده) به ریال
                    </th>
                </tr>
                <tr class="serviceFormHeaderRow">
                    <th>
                        ودیعه
                    </th>
                    <th>
                        ضمانت بانکی
                    </th>
                    <th>
                        هزینه اولیه(نصب)
                    </th>
                    <th>
                        پرداخت دوره ای
                    </th>
                    <th id="other-costs">
                        سایر هزینه ها
                    </th>
                </tr>
                <tr id="sample-service-form-pr-row" style="display: none">
                    <%if (isSelectServiceForm) {%>
                    <td colspan="3" class="selectTd"><input type="radio" name="service-form-parameter-id"></td>
                    <%}%>
                    <td colspan="3" class="codeTd"></td>
                    <td colspan="3" class="specsTd"></td>
                    <td class="depositTd"></td>
                    <td class="warrantyTd"></td>
                    <td class="initialCostTd"></td>
                    <td class="periodicPaymentTd"></td>
                    <td class="otherCostTd"></td>
                </tr>
                </thead>
                <tbody id="service-form-tbody">

                </tbody>
            </table>
        </div>
        <br>
        <div class="formRow">
            <label>سایر شرایط و الزامات خدمت :</label>
            <p style="white-space: pre-line;" id="other-terms"></p>
        </div>
        <%if (isSelectServiceForm) {%>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left" disabled>
        </div>
    </form>
    <%}%>

</div>
<script src="js/accounting.min.js"></script>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/tariffs.js"></script>
</body>
</html>