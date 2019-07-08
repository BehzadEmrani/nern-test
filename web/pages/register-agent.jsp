<%@ page import="com.atrosys.dao.AgentDAO" %>
<%@ page import="com.atrosys.dao.PersonalInfoDAO" %>
<%@ page import="com.atrosys.dao.UniStatusLogDAO" %>
<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");

    List<FileItem> items = null;
    HashMap<String, String> uploadFields = null;
    HashMap<String, InputStream> uploadedFiles = null;
    if (ServletFileUpload.isMultipartContent(request)) {
        items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        uploadFields = new HashMap<>();
        uploadedFiles = new HashMap<>();
        for (FileItem item : items)
            if (item.isFormField()) {
                String fieldname = item.getFieldName();
                String fieldvalue = item.getString("UTF-8");
                uploadFields.put(fieldname, fieldvalue);
            } else {
                String fileName = item.getFieldName();
                InputStream inputStream = item.getInputStream();
                uploadedFiles.put(fileName, inputStream);
            }
    }

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter(
            "sub-code") != null ? request.getParameter("sub-code") : uploadFields.get("sub-code")));
    if (subSystemCode == null) {
        response.sendError(404, "No sub system code!");
        return;
    }
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
    University university = uniSessionInfo.getUniversity();
    Agent agent = uniSessionInfo.getAgent();
    PersonalInfo personalInfo = uniSessionInfo.getPersonalInfo();
    String message = null;
    boolean formUploaded = false;
    boolean isEdit = false;
    boolean reloadParent = false;
    boolean isComplete = false;
    PersonalDoc personalDoc = null;
    UserRole userRole = null;

    if (uniSessionInfo.isSubSystemLoggedIn()) {
        switch (UniStatus.fromValue(university.getUniStatus())) {
            case AGENT_EDIT_VERIFY:
            case PRIMARY_AGENT_REGISTER:
                break;
            default:
                request.getRequestDispatcher("register.jsp?sub-code=" + subSystemCode.getValue()).forward(request, response);
                return;
        }
    } else {
        request.getRequestDispatcher("register.jsp?sub-code=" + subSystemCode.getValue()).forward(request, response);
        return;
    }
    if (!agent.getNationalId().equals(university.getUniNationalId())) {
        isComplete = true;
        formUploaded = true;
    }
    try {
        if (ServletFileUpload.isMultipartContent(request) && !isComplete) {
            formUploaded = true;
            if ("send-form".equals(uploadFields.get("action"))) {
                byte[] bytes = IOUtils.toByteArray(uploadedFiles.get("form"));
                if (bytes != null) {
                    agent.setNationalId(new Long(uploadFields.get("national-id")));
                    agent.setIntroCert(bytes);

                    personalInfo = new PersonalInfo();
                    personalInfo.setNationalId(new Long(uploadFields.get("national-id")));
//                    personalInfo.setNationalCardNo(uploadFields.get("national-card-no"));
//                    String shenasSerial = uploadFields.get("shenas-no-1") + uploadFields.get("shenas-no-2")
//                            + uploadFields.get("shenas-no-3");
//                    personalInfo.setShenasSerial(shenasSerial);

                    session.setAttribute(Constants.SESSION_TEMP_PERSON, personalInfo);
                    session.setAttribute(Constants.SESSION_TEMP_AGENT, agent);
                    formUploaded = true;
                }
            }
            if ("send-info".equals(uploadFields.get("action"))) {
//              byte[] bytesNational = IOUtils.toByteArray(uploadedFiles.get("national-form"));
//              byte[] bytesShenas = IOUtils.toByteArray(uploadedFiles.get("shenas-form"));
                agent = (Agent) session.getAttribute(Constants.SESSION_TEMP_AGENT);
                personalInfo = (PersonalInfo) session.getAttribute(Constants.SESSION_TEMP_PERSON);
                if (agent != null && personalInfo != null) {
                    agent.setTelNo("0" + uploadFields.get("tel-pish") + uploadFields.get("tel"));
                    agent.setFaxNo("0" + uploadFields.get("fax-pish") + uploadFields.get("fax"));
                    agent.setSupportEmail(uploadFields.get("support-email"));
                    agent.setMobileNo("0" + uploadFields.get("mobile-pish") + uploadFields.get("mobile"));
                    agent.setAgentPos(uploadFields.get("agent-pos"));
                    agent.setPrimary(true);
                    agent.setUniNationalId(university.getUniNationalId());
                    AgentDAO.save(agent);

//                  java.sql.Date cDate = Util.convertJalaliToGregorian(
//                          uploadFields.get("date-year-bd") + "/" + uploadFields.get("date-mon-bd") +
//                                  "/" + uploadFields.get("date-day-bd"));
//                  personalInfo.setBirthDate(cDate);
//                  personalInfo.setFatherName(uploadFields.get("father-name"));
//                  personalInfo.setShenasNo(uploadFields.get("shenas-no"));
                    personalInfo.setFname(uploadFields.get("fname"));
                    personalInfo.setLname(uploadFields.get("lname"));
                    PersonalInfoDAO.save(personalInfo);

//                  personalDoc = new PersonalDoc();
//                  personalDoc.setNationalId(personalInfo.getNationalId());
//                  personalDoc.setNationalCard(bytesNational);
//                  personalDoc.setShenasFpage(bytesShenas);
//                  PersonalDocDAO.save(personalDoc);

                    university.setUniStatus(UniStatus.REGISTER_COMPLETED.getValue());
                    UniversityDAO.save(university);

                    UniStatusLog uniStatusLog = new UniStatusLog();
                    uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    uniStatusLog.setMessage("فرم ثبت نام نماینده اصلی " + university.getUniName() + " توسط مسئول دانشگاه اصلاح شد.");
                    uniStatusLog.setUniStatus(university.getUniStatus());
                    uniStatusLog.setUniNationalId(university.getUniNationalId());
                    uniStatusLog = UniStatusLogDAO.save(uniStatusLog);

                    session.removeAttribute(Constants.SESSION_TEMP_AGENT);
                    session.removeAttribute(Constants.SESSION_TEMP_PERSON);
                    reloadParent = true;
                }
            }
        }else if(ServletFileUpload.isMultipartContent(request) &&isComplete){
            reloadParent = true;

            university.setUniStatus(UniStatus.REGISTER_COMPLETED.getValue());
            UniversityDAO.save(university);

            UniStatusLog uniStatusLog = new UniStatusLog();
            uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
            uniStatusLog.setMessage("فرم ثبت نام نماینده اصلی " + university.getUniName() + " توسط مسئول دانشگاه اصلاح شد.");
            uniStatusLog.setUniStatus(university.getUniStatus());
            uniStatusLog.setUniNationalId(university.getUniNationalId());
            uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
        }
    } catch (Exception e) {
        message = "خطای نامشخص!";
        e.printStackTrace();
    }

    if (reloadParent) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script>
        window.parent.parent.location.href = "index.jsp?page=register&sub-code=<%=subSystemCode.getValue()%>";
    </script>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
</head>
</html>
<%
        return;
    }
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<form onsubmit="<%=formUploaded ? "return false;" : "return validateForm('#send-agent-form');"%>" id="send-agent-form"
      method="post"
      enctype="multipart/form-data"
      action="register-agent.jsp<%=isEdit?"?action=edit-form":""%>">
    <input type="hidden" name="primary" value="true">
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <div class="formBox">
        <input type="hidden" name="action" value="send-form">
        <h3 style="color: green;">فرم اشتراک (قرارداد) شما به نشانی شما پست شد، لطفا اطلاعات نماینده تام‌الاختیار
            دانشگاه برای پی‌گیری‌های بعدی وارد نمایید.</h3>
        <h3>
            <%if (isEdit) {%>
            تغییر در نماینده اصلی
            <%} else {%>
            اطلاعات نماینده اصلی
            <%}%>
        </h3>

        <div class="formRow formInputCon">
            <div class="formItem">
                <label>معرفی نامه نماینده اصلی :</label>
                <a href="../documents/agent-template.pdf" id="request-form"
                   download="نمونه فرم معرفی نماینده.pdf">
                    <img src="../images/get-form.png">
                </a>
                <a href="#" class="formFileInputBtn"<%=formUploaded ? "style=\"pointer-events: none\"" : ""%>>
                    <img src="../images/file-choose.png"
                         style="margin-bottom: 3px;margin-left: 3px;">
                </a>
                <input type="file" name="form" value="" accept="application/pdf"
                       class="formFileInput" <%=formUploaded ? "disabled" : ""%>>
            </div>
            <div class="formItem">
                <input name="form-file-name" class="<%=formUploaded?"formInputDeactive ":""%>formInput formFileInputTxt"
                       id="formFileInput"
                       value="<%=formUploaded? (!isComplete?uploadFields.get("form-file-name"):""):""%>"
                       style="width: 490px;" type="text" readonly>
                <input type="submit" value="" class="uploadBtn">
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>شماره ملی :</label>
                <input class="<%=formUploaded?"formInputDeactive ":""%>formInput numberInput" name="national-id"
                       maxlength="10"
                       style="width: 180px;margin-left: 20px;" type="text"
                       value="<%=formUploaded?personalInfo.getNationalId():""%>"<%=formUploaded?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>شماره سریال کارت ملی :</label>
                <input class="formInputDeactive formInput"
                       maxlength="16"
                       style="width: 180px;margin-left: 20px;"
                       value=""
                       type="text" disabled>
            </div>
            <div class="formItem">
                <label>شماره سریال شناسنامه :</label>
                <div class="formItem">
                    <input class="formInputDeactive formInput"
                           maxlength="6" style="width: 150px;"
                           value=""
                           type="text" disabled>
                    <input class="formInputDeactive formInput"
                           maxlength="2" style="width: 45px;"
                           value=""
                           type="text" disabled>
                    <input class="formInputDeactive formInput"
                           maxlength="1" style="width: 45px;"
                           value=""
                           type="text" disabled>
                </div>
            </div>
        </div>
    </div>
</form>
<%if (formUploaded) {%>
<form onsubmit="return validateForm('#send-agent-info');" id="send-agent-info" method="post"
      enctype="multipart/form-data"
      action="register-agent.jsp<%=isEdit?"?action=edit-form":""%>">
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <div class="formBox">
        <div class="formRow">
            <div class="formItem">
                <label>نام :</label>
                <input value="<%=isComplete?personalInfo.getFname():""%>"
                       class=" formInput <%=isComplete?"formInputDeactive":"persianInput"%>" name="fname" style="width: 180px;margin-left: 20px;"
                       type="text" maxlength="30"<%=isComplete?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>نام خانوادگی :</label>
                <input value="<%=isComplete?personalInfo.getLname():""%>"
                       class=" formInput <%=isComplete?"formInputDeactive":"persianInput"%>" name="lname"
                       style="width: 180px;margin-left: 20px;" type="text" max="30"<%=isComplete?"disabled":""%>>
            </div>

        </div>
        <div class="formRow">
            <div class="formItem">
                <label>شماره شناسنامه :</label>
                <input value="" class=" formInput formInputDeactive"
                       maxlength="10"
                       minlength="1"
                       style="width: 180px" type="text" disabled>
            </div>
            <div class="formItem formDatePicker">
                <label>تاریخ تولد :</label>
                <%
                    //                    PersianCalendar persianCalendar = new PersianCalendar(new Date());
//                    int currentYear = persianCalendar.get(Calendar.YEAR);
//                    int currentMonth = persianCalendar.get(Calendar.MONTH) + 1;
//                    int currentDay = persianCalendar.get(Calendar.DAY_OF_MONTH);
                %>
                <select class="formSelect dateDay formInputDeactive" style="width: 50px;"
                        current-date="<%//currentDay%>" disabled></select>
                <select class="formSelect dateMon formInputDeactive"
                        style="width: 50px;" disabled>
                    <%--<% for (int i = 1; i <= 12; i++) { %>--%>
                    <%--<option value="<%=i<10?"0"+i:i%>"<%=i == currentMonth ? " selected" : ""%>><%=i%>--%>
                    <%--</option>--%>
                    <%--<% } %>--%>
                </select>
                <select class="formSelect dateYear formInputDeactive"
                        style="width: 60px;" disabled>
                    <%--<%--%>
                    <%--for (int i = 0; i >= -100; i--) {--%>
                    <%--int year = currentYear + i;--%>
                    <%--%>--%>
                    <%--<option value="<%=year%>"><%=year%>--%>
                    <%--</option>--%>
                    <%--<% } %>--%>
                </select>
            </div>
            <div class="formItem">
                <label>نام پدر :</label>
                <input value="" class="formInput formInputDeactive" maxlength="30"
                       style="width: 180px;" type="text" disabled>
            </div>
        </div>
        <%
            //boolean hadNationalCardImage = personalDoc.getNationalCard() != null;
            //boolean hadNationalCardImage = false;
        %>
        <div class="formRow">
            <div class="formItem formInputCon" style="display: inline-block;">
                <label>تصویر کارت ملی :</label>
                <div class="formItem">
                    <a class="formFileInputBtn"<%//hadNationalCardImage ? "style=\"pointer-events: none\"" : ""%>>
                        <img src="../images/file-choose-dis.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                </div>
            </div>
            <div class="formItem">
                <input class="formInputDeactive formInput"
                       style="width: 250px;margin-left: 10px"
                       type="text"
                       value=""
                       readonly disabled>
            </div>
            <%
                //                boolean hadShenasFpage = personalDoc.getShenasFpage() != null;
//                boolean hadShenasFpage = false;
            %>
            <div class="formItem formInputCon" style="display: inline-block;">
                <label>تصویر صفحه اول شناسنامه :</label>
                <div class="formItem">
                    <a class="formFileInputBtn" <%//hadShenasFpage ? "style=\"pointer-events: none\"" : ""%>>
                        <img src="../images/file-choose-dis.png"
                             style="margin-bottom: 3px;margin-left: 3px;">
                    </a>
                </div>
            </div>
            <div class="formItem">
                <input class="formInputDeactive formInput"
                       style="width: 250px;"
                       type="text"
                       value=""
                       readonly disabled>
            </div>
        </div>
    </div>
    <div class="formBox">
        <input type="hidden" name="action" value="send-info">
        <div class="formRow">
            <div class="formItem">
                <label>تلفن :</label>
                <input class="formInput <%=isComplete?"formInputDeactive":"numberInput"%>" name="tel" maxlength="8" minlength="3"
                       style="width: 140px;"
                       value="<%=isComplete?agent.getTelNo().substring(3,agent.getTelNo().length()):""%>"
                       type="text"<%=isComplete?"disabled":""%>>
                <input class="formInput <%=isComplete?"formInputDeactive":"numberInput"%>" maxlength="2"
                       value="<%=isComplete?agent.getTelNo().substring(1,3):""%>"
                       style="width: 55px;direction: ltr;" type="text" name="tel-pish"<%=isComplete?"disabled":""%>>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr" type="text" disabled>
            </div>
            <div class="formItem">
                <label>فکس :</label>
                <input class="formInput <%=isComplete?"formInputDeactive":"numberInput"%>" maxlength="8" name="fax" minlength="3"
                       value="<%=isComplete?agent.getFaxNo().substring(3,agent.getFaxNo().length()):""%>"
                       style="width: 140px;" type="text"<%=isComplete?"disabled":""%>>
                <input class="formInput <%=isComplete?"formInputDeactive":"numberInput"%>" maxlength="2" style="width: 55px;direction: ltr" type="text"
                       value="<%=isComplete?agent.getFaxNo().substring(1,3):""%>"
                       name="fax-pish"<%=isComplete?"disabled":""%>>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr;" type="text" disabled>
            </div>
            <div class="formItem">
                <label>تلفن همراه :</label>
                <input class="formInput <%=isComplete?"formInputDeactive":"numberInput"%>" maxlength="10" name="mobile"
                       value="<%=isComplete?agent.getMobileNo().substring(1,agent.getMobileNo().length()):""%>"
                       style="width: 140px;" type="text"<%=isComplete?"disabled":""%>>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr;" type="text" disabled>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>پست الکترونیکی :</label>
                <input class="formInput <%=isComplete?"formInputDeactive":"emailInput"%>" name="support-email" maxlength="35"
                       value="<%=isComplete?agent.getSupportEmail():""%>"
                       style="width: 300px;margin-left: 20px;" type="text"<%=isComplete?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>سمت :</label>
                <input class="formInput <%=isComplete?"formInputDeactive":"persianInput"%>" name="agent-pos" maxlength="35"
                       value="<%=isComplete?agent.getAgentPos():""%>"
                       style="width: 300px;margin-left: 20px;" type="text"<%=isComplete?"disabled":""%>>
            </div>
        </div>
        <div class="formRow">
            <br>
            <label style="color: #c00;font-size: 14pt">پس از تایید ، عضویت شما در شبکه علمی ایران نهایی شده و می توانید
                خدمات مورد نیاز را درخواست نمایید.لطفا در اولین فرصت کلمه عبور خود را اصلاح
                نمایید.
            </label>
            <input type="submit" value=" تایید نماینده اصلی" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left;"/>
            <br clear="both">
        </div>
    </div>
</form>
<%}%>

<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>