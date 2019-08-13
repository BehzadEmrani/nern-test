<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="com.ibm.icu.util.PersianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    String message = null;
    boolean isLegals = "true".equals(request.getParameter("legal"));

    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!adminSessionInfo.isAdminLogedIn()) {
        response.sendError(403);
        return;
    }

    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean editSubAccess = false;
    if (isLegals){
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.MANAGE_PERSONS_LEGAL.getValue())) {
            response.sendError(403);
            return;
        }
        try {

            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS_LEGAL.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS_LEGAL.getValue(),
                    AdminSubAccessType.READ.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS_LEGAL.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        } catch (Exception e) {

        }
    }
    else{

        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.MANAGE_PERSONS.getValue())) {
            response.sendError(403);
            return;
        }
        try {

            addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS.getValue(),
                    AdminSubAccessType.ADD.getValue());
            readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS.getValue(),
                    AdminSubAccessType.READ.getValue());
            editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                    AdminAccessType.MANAGE_PERSONS.getValue(),
                    AdminSubAccessType.EDIT.getValue());
        } catch (Exception e) {

        }
      }
    boolean isEdit = "edit-person".equals(request.getParameter("action")) && editSubAccess;
    boolean isSendEdit = "send-edit-person".equals(request.getParameter("action"));
    boolean isSendNewPerson = "send-person".equals(request.getParameter("action"));

    if (isSendNewPerson && !addSubAccess) {
        response.sendError(403);
        return;
    }
    if ((isEdit || isSendEdit) && !editSubAccess) {
        response.sendError(403);
        return;
    }
    PersonalInfo personalInfo = null;
    if (isSendEdit || isEdit) {
        personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(
                Long.valueOf(request.getParameter("national-id")));
    }
    try {
        if (isSendNewPerson || isSendEdit) {
            if (isSendNewPerson) {
                personalInfo = new PersonalInfo();
                personalInfo.setNeedChangePass(true);
                personalInfo.setNationalId(Long.valueOf(request.getParameter("national-id")));
            }

            personalInfo.setShenasNo(request.getParameter("shenas-no"));
            personalInfo.setFname(request.getParameter("fname"));
            personalInfo.setLname(request.getParameter("lname"));
            personalInfo.setUsername(request.getParameter("username"));
            if (!isSendNewPerson) {
                if (!request.getParameter("password").equals(personalInfo.getPassword()))
                    personalInfo.hashAndSetPassword(request.getParameter("password"));
            } else
                personalInfo.hashAndSetPassword(request.getParameter("password"));
            personalInfo.setFatherName(request.getParameter("father-name"));
            personalInfo.setLegalPersonality(false);
            java.sql.Date date = Util.convertJalaliToGregorian(
                    request.getParameter("birth-date-year") +
                            "/" + request.getParameter("birth-date-mon") +
                            "/" + request.getParameter("birth-date-day"));
            personalInfo.setBirthDate(date);
            if (isSendNewPerson)
                PersonalInfoDAO.saveNew(personalInfo);
            else if (isSendEdit)
                PersonalInfoDAO.save(personalInfo);

        }
    } catch (Exception e) {

    }
    List<PersonalInfo> personalInfoList = PersonalInfoDAO.findAllPersonalByLegality(isLegals);
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

        .personListTable, .personListTable tbody {
            max-width: 600px !important;
        }
    </style>
</head>
<body>
<%if (addSubAccess || isEdit) {%>
<form id="send-form" onsubmit="return validateForm('#send-form');" method="post" action="manage-personal-info.jsp">
    <input type="hidden" name="legal" value="<%=request.getParameter("legal")%>">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="send-edit-person">
    <input type="hidden" name="national-id" value="<%=request.getParameter("national-id")%>">
    <%} else if (addSubAccess) {%>
    <input type="hidden" name="action" value="send-person">
    <%}%>
    <div class="formBox">
        <%if (isEdit) {%>
        <h3>ویرایش اطلاعات "<%=personalInfo.combineName()%>"</h3>
        <%} else {%>
        <h3>افزودن شخص</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>شماره ملی :</label>
                <input class="formInput<%=isEdit?" formInputDeactive":" numberInput"%>" name="national-id"
                       value="<%=isEdit?personalInfo.getNationalId():""%>"
                       maxlength="10"
                       style="width: 150px;margin-left: 20px;" type="text"<%=isEdit?" disabled":""%>>
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> شماره شناسنامه :</label>
                <input class="formInput numberInput" name="shenas-no" minlength="1" maxlength="10"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?personalInfo.getShenasNo():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> نام :</label>
                <input class="formInput persianInput" name="fname" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?personalInfo.getFname():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> نام خانوادگی :</label>
                <input class="formInput persianInput" name="lname" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?personalInfo.getLname():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> نام پدر:</label>
                <input class="formInput persianInput" name="father-name" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?personalInfo.getFatherName():""%>">
            </div>
            <div class="formItem formDatePicker">
                <label>تاریخ تولد :</label>
                <%
                    PersianCalendar persianCalendar = new PersianCalendar(new Date());
                    int currentYear = persianCalendar.get(Calendar.YEAR);
                    int selectedYear = persianCalendar.get(Calendar.YEAR);
                    int selectedMonth = persianCalendar.get(Calendar.MONTH) + 1;
                    int selectedDay = persianCalendar.get(Calendar.DAY_OF_MONTH);
                    if (isEdit && personalInfo.getBirthDate() != null) {
                        PersianCalendar personBirthPersianCalendar = new PersianCalendar(personalInfo.getBirthDate());
                        selectedYear = personBirthPersianCalendar.get(Calendar.YEAR);
                        selectedMonth = personBirthPersianCalendar.get(Calendar.MONTH) + 1;
                        selectedDay = personBirthPersianCalendar.get(Calendar.DAY_OF_MONTH);
                    }

                %>
                <select class="formSelect dateDay" name="birth-date-day" style="width: 50px;"
                        current-date="<%=selectedDay%>"></select>
                <select class="formSelect dateMon" name="birth-date-mon"
                        style="width: 50px;">
                    <% for (int i = 1; i <= 12; i++) { %>
                    <option value="<%=i<10?"0"+i:i%>"<%=i == selectedMonth ? " selected" : ""%>><%=i%>
                    </option>
                    <% } %>
                </select>
                <select class="formSelect dateYear" name="birth-date-year"
                        style="width: 60px;">
                    <%
                        for (int i = 0; i >= -100; i--) {
                            int year = currentYear + i;
                    %>
                    <option value="<%=year%>"<%=year == selectedYear ? " selected" : ""%>><%=year%>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>نام کاربری :</label>
                <input class="formInput userNameInput" name="username"
                       maxlength="30" value="<%=isEdit?personalInfo.getUsername():""%>"
                       style="width: 150px;margin-left: 20px;direction: ltr"
                       type="text">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>رمز عبور:</label>
                <input class="formInput" id="password" name="password"
                       maxlength="30" value="<%=isEdit?personalInfo.getPassword():""%>"
                       style="width:150px;margin-left: 20px;"
                       type="password">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>تکرار رمز عبور:</label>
                <input class="formInput" name="re-password" maxlength="30" id="re-password"
                       style="width:150px;margin-left: 20px;" type="password"
                       value="<%=isEdit?personalInfo.getPassword():""%>">
            </div>
        </div>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-personal-info.jsp?legal=<%=isLegals%>" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
</form>
<%}%>
<%if (readSubAccess) {%>
<div class="formBox" style="text-align: center;margin-bottom:10px ">
    <%if (isLegals)  {%>
        <h4 style="text-align: center">
            فهرست اشخاص حقوقی
        </h4>
    <%} else {%>
        <h4 style="text-align: center">
            فهرست اشخاص حقیقی
        </h4>
    <%}%>
    <table class="fixed-table table table-striped personListTable" style="display: inline-block;;">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th width="30px">ردیف</th>
            <th>شماره شناسنامه</th>
            <th>نام</th>
            <th>نام کاربری</th>
            <th style="width:200px;">عملیات ها</th>
        </tr>
        <thead>
        <tbody>
        <%
            for (int i = 0; i < personalInfoList.size(); i++) {
                PersonalInfo tablePersonalInfo = personalInfoList.get(i);
        %>
        <tr>
            <td width="30px">
                <%=i + 1%>
            </td>
            <td>
                <%=tablePersonalInfo.getNationalId()%>
            </td>
            <td>
                <%=tablePersonalInfo.combineName()%>
            </td>
            <td>
                <%=tablePersonalInfo.getUsername()%>
            </td>
            <td class="operatorBox" style="width:200px;">
                <a href="#" data-toggle="modal"
                   data-target="#personInfo<%=i%>">
                    <img src="../images/show-info.png" style="width: 25px">
                </a>
                <!-- Modal -->
                <div class="modal fade" id="personInfo<%=i%>" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-body" style="text-align: right">
                                شماره ملی :
                                <%=tablePersonalInfo.getNationalId()%><br>
                                شماره شناسنامه :
                                <%=tablePersonalInfo.getShenasNo()%><br>
                                نام کاربری :
                                <%=tablePersonalInfo.getUsername()%><br>
                                نام :
                                <%=tablePersonalInfo.combineName()%><br>
                                تاریخ تولد :
                                <%=Util.convertGregorianToJalali(tablePersonalInfo.getBirthDate())%><br>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="#" onclick="return false">
                    <img src="../images/delete.png">
                </a>
                <a href="manage-personal-info.jsp?legal=<%=isLegals%>&action=edit-person&national-id=<%=tablePersonalInfo.getNationalId()%>"
                <%=!editSubAccess ? "onclick='return false'" : ""%>>
                <img src="../images/edit.png">
                </a>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
</div>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>

</body>
</html>

