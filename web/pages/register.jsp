<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.UserRoleUtil" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="org.jsoup.HttpStatusException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    request.setCharacterEncoding("UTF-8");
    String message = null;

    boolean reloadParent = false;
    boolean formUploaded = false;
    boolean waitForVerify = false;
    boolean isPreDefined = false;
    boolean isEditVerify = false;
    boolean isErrorEdit = false;
    boolean isErrorUploadEdit = false;
    boolean isErrorInfoEdit = false;

    boolean goToAdminPage = false;

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    if (subSystemCode == null && !ServletFileUpload.isMultipartContent(request)) {
        response.sendError(404, "No sub system code!");
        return;
    }
    SubSystemsType[] subSystemsTypes = SubSystemCode.subSystemsTypeFromSubCode(subSystemCode);
    List<State> states = null;
    HashMap<String, String> uploadFields = null;
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
    University university = uniSessionInfo.getUniversity();
    Agent agent = null;
    PersonalInfo personalInfo = null;
    UserRole userRole = uniSessionInfo.getUserRole();
    if (uniSessionInfo.isSubSystemLoggedIn()) {
        if (userRole.getValidity() < Validity.ACTIVE.getValue()) {
            request.getRequestDispatcher("login.jsp?sub-code=" + subSystemCode.getValue()).forward(request, response);
            return;
        }
    } else if (uniSessionInfo.isLoggedIn()) {
        goToAdminPage = true;
        reloadParent = true;
    }
    if (uniSessionInfo.isSubSystemLoggedIn()) {
        switch (UniStatus.fromValue(uniSessionInfo.getUniversity().getUniStatus())) {
            case REGISTER_PAGE_VERIFY:
                waitForVerify = true;
                agent = uniSessionInfo.getAgent();
                personalInfo = uniSessionInfo.getPersonalInfo();
                break;
            case SUBSCRIBE_PAGE:
            case SUBSCRIBE_PAGE_VERIFY:
            case SUBSCRIBE_PAGE_ERROR:
                request.getRequestDispatcher("send-subscription-form.jsp?sub-code=" + subSystemCode.getValue()).forward(request, response);
                return;
            case AGENT_EDIT_VERIFY:
            case PRIMARY_AGENT_REGISTER:
                request.getRequestDispatcher("register-agent.jsp").forward(request, response);
                return;
            case REGISTER_COMPLETED:
                request.getRequestDispatcher("welcome.jsp").forward(request, response);
                return;
            case UNI_EDIT_VERIFY:
                isEditVerify = true;
                waitForVerify = true;
                break;
            case REGISTER_PAGE_ERROR:
                UniSubStatus uniSubStatus = UniSubStatus.fromValue(university.getUniSubStatus());
                if (uniSubStatus == UniSubStatus.REGISTER_PAGE_REQUEST_FORM_ERROR)
                    isErrorUploadEdit = true;
                else {
                    isErrorInfoEdit = true;
                    formUploaded = true;
                    states = StateDAO.findAllStates();
                }
                isErrorEdit = true;
                break;
            case UNI_CANCEL_REQUEST_VERIFY:
                request.getRequestDispatcher("cancell-contract.jsp").forward(request, response);
                return;
            case UNI_CANCEL_REQUEST_CONFIRM:
                request.getRequestDispatcher("confirm-cancell-contract.jsp").forward(request, response);
                return;
            case NEXT_PHASE:
                request.getRequestDispatcher("next-phase.jsp").forward(request, response);
                return;
            default:
                break;
        }
    }

    try {
        //file upload multi part request
        if (ServletFileUpload.isMultipartContent(request)) {
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            uploadFields = new HashMap<>();
            HashMap<String, InputStream> uploadedFiles = new HashMap<>();
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
            if ("send-form".equals(uploadFields.get("action"))) {
                formUploaded = true;
                UniversityType universityType = UniversityType.fromValue(Integer.valueOf(uploadFields.get("type")));
                PreDataType preDataType = universityType.getPreDataType();
                isPreDefined = !preDataType.equals(PreDataType.FROM_ILENC);
                university = new University();
                Long uniNationalId = null;
                PreUniversityData preUniversityData = null;
                if (!isPreDefined)
                    uniNationalId = Long.valueOf(uploadFields.get("uni-national-id"));
                else {
                    preUniversityData = PreUniversityDataDAO.findPreUniversityDataByInternalUniCode(
                            Long.valueOf(uploadFields.get("internal-code")), preDataType.getValue());
                    if (preUniversityData == null)
                        throw new Exception("pre-data-not-defined");
                    uniNationalId = Long.valueOf(preDataType.getNationalId() +
                                Util.fixNumberlength(preUniversityData.getUniInternalCode(), 5));
                }
                if (!UniversityDAO.checkUniIdIsNew(uniNationalId))
                    throw new Exception("repeatedId");
                byte[] bytes = IOUtils.toByteArray(uploadedFiles.get("form"));
                if (bytes != null)
                    if (bytes.length > 512 * 1024)
                        throw new Exception("large-file");
                if (uniNationalId != null && bytes != null) {
                    states = StateDAO.findAllStates();
                    if (isPreDefined) {
                        university.setPostalCode(String.valueOf(1111111111));
                        university.setUniName(preDataType.getFaStr() + " - " + preUniversityData.getName());
                        university.setAddress(preUniversityData.getAddress());
                    }
                    if (bytes != null)
                        university.setRequestForm(bytes);
                    university.setUniNationalId(uniNationalId);
                    university.setUniStatus(0);
                    university.setTypeVal(universityType.getValue());
                    session.setAttribute(Constants.SESSION_TEMP_UNI, university);
                    session.setAttribute(Constants.SESSION_TEMP_REGISTER_UPLOAD_FIELD, uploadFields);
                }
                if ("send-error-form".equals(uploadFields.get("action"))) {
                    reloadParent = true;
                    bytes = IOUtils.toByteArray(uploadedFiles.get("form"));
                    if (bytes.length > 512 * 1024)
                        throw new Exception("large-file");
                    if (uniSessionInfo.isSubSystemLoggedIn() && bytes != null) {
                        university.setRequestForm(bytes);
                        university.setUniStatus(UniStatus.REGISTER_PAGE_VERIFY.getValue());
                        UniversityDAO.save(university);
                        UniStatusLog uniStatusLog = new UniStatusLog();
                        uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                        uniStatusLog.setMessage("فرم درخواست عضویت " + university.getUniName() + " توسط مسئول دانشگاه اصلاح شد.");
                        uniStatusLog.setUniStatus(university.getUniStatus());
                        uniStatusLog.setUniNationalId(university.getUniNationalId());
                        uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                }
            }
        }
        if ("send-info".equals(request.getParameter("action"))) {
            uploadFields = (HashMap<String, String>) session.getAttribute(Constants.SESSION_TEMP_REGISTER_UPLOAD_FIELD);
            university = (University) session.getAttribute(Constants.SESSION_TEMP_UNI);
            if (university != null && uploadFields != null) {
                university.setUniName(request.getParameter("uni-name"));
                university.setTopManagerName(request.getParameter("top-manager"));
                university.setTopManagerPos(request.getParameter("top-manager-pos"));
                university.setSignatoryName(request.getParameter("sig-name"));
                university.setSignatoryPos(request.getParameter("sig-pos"));
                university.setSignatoryNationalId(request.getParameter("sig-national-code"));
                university.setTeleNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode()
                        + request.getParameter("tel"));
                university.setFaxNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode()
                        + request.getParameter("fax"));
                university.setSiteAddress(request.getParameter("domain"));
                university.setUniPublicEmail(request.getParameter("public-email"));
                university.setUniStatus(UniStatus.REGISTER_PAGE_VERIFY.getValue());
                university.setMapLocLat(Double.valueOf(request.getParameter("lat")));
                university.setMapLocLng(Double.valueOf(request.getParameter("lng")));
                university.setPostalCode(request.getParameter("postal-code"));
                university.setStateId(Long.valueOf(request.getParameter("state")));
                university.setCityId(Long.valueOf(request.getParameter("city")));
                university.setAddress(request.getParameter("address"));
                university.setEcoCode(request.getParameter("eco-code"));
                university.setUniSubSystemCode(subSystemCode.getValue());
                university = UniversityDAO.save(university);

                UniStatusLog uniStatusLog = new UniStatusLog();
                uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                uniStatusLog.setMessage(String.format(university.getUniName() + " فرم درخواست عضویت را تکمیل کرد."));
                uniStatusLog.setUniStatus(university.getUniStatus());
                uniStatusLog.setUniNationalId(university.getUniNationalId());
                uniStatusLog = UniStatusLogDAO.save(uniStatusLog);

                personalInfo = new PersonalInfo();
                personalInfo.setNationalId(Long.valueOf(request.getParameter("agent-national-id")));
                personalInfo.setFname(request.getParameter("agent-f-name"));
                personalInfo.setLname(request.getParameter("agent-l-name"));
                personalInfo.setUsername(Util.fixNumberlength(university.getUniNationalId(), university.getUniNationalId().toString().length() <= 11 ? 11 : 16));
                personalInfo.hashAndSetPassword(Util.fixNumberlength(university.getUniNationalId(), university.getUniNationalId().toString().length() <= 11 ? 11 : 16));
                personalInfo.setLegalPersonality(true);
                personalInfo.setNeedChangePass(false);
                personalInfo = personalInfo = PersonalInfoDAO.save(personalInfo);

                userRole = new UserRole();
                userRole.setValidity(Validity.ACTIVE.getValue());
                userRole.setNationalId(personalInfo.getNationalId());
                userRole.setUserRoleVal(UserRoleType.fromSubSystemCode(subSystemCode).getValue());
                userRole = UserRoleDAO.save(userRole);

                agent = new Agent();
                agent.setPrimary(true);
                agent.setUniNationalId(university.getUniNationalId());
                agent.setNationalId(personalInfo.getNationalId());
                agent.setTelNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode() + request.getParameter("a-tel"));
                agent.setFaxNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode() + request.getParameter("a-fax"));
                agent.setAgentPos(request.getParameter("agent-pos"));
                agent.setMobileNo("0" + request.getParameter("a-mobile"));
                agent.setSupportEmail(request.getParameter("a-email"));
                agent.setRoleId(userRole.getRoleId());
                agent = AgentDAO.save(agent);


                session.setAttribute(Constants.SESSION_USER_NATIONAL_ID, userRole.getRoleId());
                session.removeAttribute(Constants.SESSION_TEMP_UNI);
                UserRoleUtil.updateUserRolesFromDb(session, userRole.getNationalId());
                uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
                waitForVerify = true;
                reloadParent = true;
            }
        }
        //user sends edit
        if ("send-error-info".equals(request.getParameter("action"))) {
            if (university != null) {
                university.setUniName(request.getParameter("uni-name"));
                university.setTopManagerName(request.getParameter("top-manager"));
                university.setTopManagerPos(request.getParameter("top-manager-pos"));
                university.setSignatoryName(request.getParameter("sig-name"));
                university.setSignatoryPos(request.getParameter("sig-pos"));
                university.setSignatoryNationalId(request.getParameter("sig-national-code"));
                university.setTeleNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode()
                        + request.getParameter("tel"));
                university.setFaxNo("0" + StateDAO.findStateById(Long.valueOf(request.getParameter("state"))).getPhoneCode()
                        + request.getParameter("fax"));
                university.setSiteAddress(request.getParameter("domain"));
                university.setUniPublicEmail(request.getParameter("public-email"));
                university.setUniStatus(UniStatus.REGISTER_PAGE_VERIFY.getValue());
                university.setMapLocLat(Double.valueOf(request.getParameter("lat")));
                university.setMapLocLng(Double.valueOf(request.getParameter("lng")));
                university.setPostalCode(request.getParameter("postal-code"));
                university.setStateId(Long.valueOf(request.getParameter("state")));
                university.setCityId(Long.valueOf(request.getParameter("city")));
                university.setAddress(request.getParameter("address"));
                university.setEcoCode(request.getParameter("eco-code"));
                university = UniversityDAO.save(university);

                UniStatusLog uniStatusLog = new UniStatusLog();
                uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                uniStatusLog.setMessage(String.format("فرم درخواست عضویت " + university.getUniName() + " توسط مسئول دانشگاه اصلاح شد."));
                uniStatusLog.setUniStatus(university.getUniStatus());
                uniStatusLog.setUniSubStatus(university.getUniSubStatus());
                uniStatusLog.setUniNationalId(university.getUniNationalId());
                uniStatusLog = UniStatusLogDAO.save(uniStatusLog);

                reloadParent = true;
            }
        }
    } catch (Exception e) {
        reloadParent = false;
        formUploaded = false;
        waitForVerify = false;
        isEditVerify = false;
        isErrorEdit = false;
        isErrorUploadEdit = false;
        isErrorInfoEdit = false;
        message = e.getMessage();
        if (e.getClass().equals(HttpStatusException.class))
            message = "شناسه ملی مورد نظر یافت نشد!";
        else if (e.getMessage().equals("repeatedId"))
            message = "برای ثبت نام این شناسه قبلا اقدام شده است!";
        else if (e.getMessage().equals("large-file"))
            message = "حجم فایل ارسالی بیش از حد مجاز می باشد!";
        else if (e.getMessage().equals("pre-data-not-defined"))
            message = "کد واحد مورد نظر شما در سیستم ثبت نشده است!\n لطفا با پشتیبانی بگیرید.";
        else message = "خطای غیر منتظره";
    }
    if (reloadParent) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <%if (!goToAdminPage) {%>
    <script>
        window.parent.parent.location.href = "index.jsp?page=register&sub-code=<%=subSystemCode.getValue()%>"
    </script>
    <%}%>
</head>
<%if (goToAdminPage) {%>
<body>
<h1 style="text-align: center;direction: rtl;color: #c00;">شما در بخش مدیریت وارد شدید!
    <br>
    انتقال به بخش مدیریت ...</h1>
<script>
    setTimeout(function () {
        window.parent.parent.location.href = "../admin"
    }, 3000);
</script>
</body>
<%}%>
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
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<form onsubmit="<%=formUploaded||waitForVerify ? "return false;" : "return validateForm('#send-agent-form');"%>"
      id="send-agent-form" method="post"
      enctype="multipart/form-data"
      action="register.jsp?sub-code=<%=subSystemCode.getValue()%>">
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <div class="formBox">
        <% if (waitForVerify) {%>
        <h3 style="color:#c00;">عضویت شما در حال بررسی توسط اپراتور شبکه علمی ایران میباشد. لطفا جهت اطلاع از آخرین
            وضعیت
            احتمالی به
            <u>پست الکترونیکی عمومی</u> اعلام شده در فرم الکترونیکی عضویت مراجعه فرمائید.</h3>
        <%} %>

        <%if (isErrorUploadEdit) {%>
        <input type="hidden" name="action" value="send-error-form">
        <%} else {%>
        <input type="hidden" name="action" value="send-form">
        <%}%>

        <%if (isEditVerify) {%>
        <h3 style="color: #c00;text-align: center">
            اصلاحات عضویت شما در حال بررسی توسط اپراتور شبکه علمی ایران می باشد.
        </h3>
        <%
        } else if (isErrorEdit) {
            String topMessage = UniStatusLogDAO.findUniStatusLogById(university.getUniStatusLog()).getMessage();
            if (topMessage.isEmpty())
                topMessage = "اصلاح عضویت";
        %>
        <h3 style="color: #c00;text-align: right;">اصلاحات درخواستی در کاربرگ عضویت:<br></h3>
        <pre style="color: #c00;text-align: right;text-indent: 0;font-size: 12px;"><%=topMessage%></pre>
        <%} else {%>
        <h3>
            <%=subSystemCode.getRegisterTopTitle()%>
        </h3>
        <%}%>

        <div class="formRow">
            <div class="formItem formInputCon">
                <%if (!isEditVerify) {%>
                <label>درخواست رسمی عضویت در شبکه علمی ایران(حداکثر حجم تا 512kb):</label>
                <%} else {%>
                <label>نامه درخواست اصلاحات(حداکثر حجم تا 512kb):</label>
                <%}%>
                <a href="../documents/<%=subSystemCode.getRequestFormURL()%>" id="request-form"
                   download="نمونه فرم درخواست عضویت.docx">
                    <img src="../images/get-form.png">
                </a>
                <a href="#" <%=formUploaded || waitForVerify ? "style=\"pointer-events: none\"" : ""%>
                   class="formFileInputBtn">
                    <img src="../images/file-choose.png"
                         style="margin-bottom: 3px;margin-left: 3px;">
                </a>
                <input type="file" name="form" accept="application/pdf"
                       class="formFileInput"<%=formUploaded||waitForVerify?"disabled ":""%>>
            </div>
            <div class="formItem">
                <input class="<%=formUploaded||waitForVerify?"formInputDeactive ":""%>formInput formFileInputTxt"
                       style="width: 490px;"
                       type="text" name="file-name"
                       value="<%=formUploaded?(!isEditVerify&&!isErrorEdit? uploadFields.get("file-name"):""):""%>"
                       readonly>
                <button type="submit" value="" class="uploadBtn"></button>
            </div>

        </div>
        <div class="formRow">
            <div class="formItem">
                <label>نوع مرکز <%=subSystemCode.equals(SubSystemCode.UNIVERSITY) ? "آموزش عالی" : "آموزشی"%>:</label>
                <select class="formSelect<%=waitForVerify||formUploaded||isErrorUploadEdit?" formInputDeactive":""%>"
                        id="select-type"
                        name="type"
                        style="width: 200px;margin-left: 20px"<%=waitForVerify ? "disabled" : ""%> <%=isErrorUploadEdit ? "isEdit" : ""%>>
                    <% if (!waitForVerify && !formUploaded && !isErrorUploadEdit) { %>
                    <option value="" disabled selected hidden>نوع مرکز خود را انتخاب کنید&nbsp;...</option>
                    <% for (SubSystemsType subSystemsType : subSystemsTypes) { %>
                    <option value="<%=subSystemsType.getValue()%>"
                            source="<%=subSystemsType.getPreDataType().getValue()%>"
                            <%=!subSystemsType.isActive() ? "disabled" : ""%>>
                        <%=subSystemsType.getFaStr()%>
                    </option>
                    <%
                        }
                    } else {
                    %>
                    <option value="" disabled selected
                            hidden><%=SubSystemCode.subSystemsTypeFromValue(subSystemCode, university.getTypeVal()).getFaStr()%>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="formItem" id="uni-national-id-div"
                 style="display:<%=!formUploaded&&!waitForVerify&&!isErrorUploadEdit?"none":""%>;">
                <% if (!formUploaded && !waitForVerify) { %>
                <label>شناسه ملی :</label>
                <%
                } else {
                %>
                <label>شناسه دانشگاه :</label>
                <%}%>
                <input <%=!isErrorUploadEdit?"name=\"uni-national-id\" ":""%>maxlength="16" minlength="11"
                       class="<%=formUploaded||waitForVerify||isErrorEdit||isErrorUploadEdit?"formInputDeactive ":"numberInput "%>formInput"
                       style="width: 170px;"
                       type="text" <%=formUploaded||waitForVerify||isErrorEdit||isErrorUploadEdit?"value=\""
                       +Util.fixNumberlength(university.getUniNationalId(),university.getUniNationalId().toString().length()<=11?11:16) +"\" disabled":""%> >
                <% if (!formUploaded && !waitForVerify) { %>
                <label style="margin-right: 10px">برای دریافت شناسه ملی دانشگاه می توانید به سایت ilenc.ir مراجعه
                    فرمایید.</label>
                <%}%>
            </div>
            <div class="formRow" id="both-div" style="display: none;">
                <input type="radio" value="seprate" name="jame-type" checked="checked" style="margin-left: 10px">ثبت نام
                از طریق شناسه ملی مرکز آموزش علمی کاربردی(در صورت داشتن شناسه مستقل)<br>
                <input type="radio" value="not-seprate" name="jame-type" style="xmargin-left: 10px">ثبت نام از طریق
                شناسه
                ملی دستگاه/سازمان/موسسه/شرکت متبوع(در صورت نداشتن شناسه مستقل)
                <br>
                <br>
                <label>شناسه ملی :</label>
                <input name="uni-national-id" id="bNational" maxlength="11"
                       class="numberInput formInput"
                       style="width: 170px;"
                       type="text">
                <label>کد مرکز:</label>
                <input name="internal-code" id="bInternal" maxlength="5" minlength="1"
                       class="numberInput formInput"
                       style="width: 170px;"
                       type="text">
            </div>
            <div class="formItem" id="internal-code-div" style="display:none">
                <label>کد دانشگاه:</label>
                <input name="internal-code" maxlength="5" minlength="1"
                       class="<%=formUploaded||waitForVerify||isErrorEdit?"formInputDeactive ":"numberInput "%>formInput"
                       style="width: 170px;"
                       type="text">
            </div>
            <% if (message != null) { %>
            <p style="color: #c00;display: inline ">
                <%=message%>
            </p>
            <%}%>
        </div>

    </div>
</form>
<% if (formUploaded || waitForVerify) { %>
<form onsubmit="return validateForm('#uni-info')" id="uni-info" action="register.jsp" method="post"
      enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <% if (isErrorInfoEdit) { %>
    <input type="hidden" name="action" value="send-error-info">
    <% } else { %>
    <input type="hidden" name="action" value="send-info">
    <%}%>
    <div class="formBox" style="position: relative">
        <div class="formRow">
            <div class="formItem">
                <label>نام اصلی :</label>
                <input class="formInput persianInput<%=waitForVerify||isErrorEdit?" formInputDeactive":""%>"
                       style="width: 350px;"
                       type="text" maxlength="100" name="uni-name"
                       value="<%=waitForVerify||isErrorEdit?university.getUniName():isPreDefined?university.getUniName():""%>" <%=waitForVerify ? "disabled" : ""%>>
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>کد اقتصادی :</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>"
                       style="width: 175px;margin-left: 20px;direction: ltr"
                       value="<%=waitForVerify||isErrorEdit?university.getEcoCode():""%>"
                       maxlength="12" name="eco-code" type="text"<%=waitForVerify?"disabled":""%>>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>استان :</label>
                <select class="formSelect<%=waitForVerify?" formInputDeactive":""%>" id="select-state" name="state"
                        style="width: 200px;margin-left: 20px"<%=waitForVerify ? "disabled" : ""%><%=isErrorInfoEdit ? " selected-id='" +
                        university.getStateId() + "' " : ""%>>
                    <% if (!waitForVerify) { %>
                    <option value="" disabled selected hidden>استان مورد نظر را انتخاب کنید&nbsp;...</option>
                    <% for (State state : states) { %>
                    <option value="<%=state.getStateId()%>" pishCode="<%=state.getPhoneCode()%>">
                        <%=state.getName()%>
                    </option>
                    <%}%>
                    <%
                    } else {
                        State state = StateDAO.findStateById(university.getStateId());
                    %>
                    <option value="<%=state.getStateId()%>" selected>
                        <%=state.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <div class="formItem">
                <label>شهر :</label>
                <select class="formSelect<%=waitForVerify?" formInputDeactive":""%>" id="select-city"
                        style="width: 200px;"
                        name="city"<%=waitForVerify ? "disabled" : ""%><%=isErrorInfoEdit ?
                        " selected-id='" + university.getCityId() + "' " : ""%>>
                    <% if (!waitForVerify) { %>
                    <option value="" disabled selected hidden>شهر مورد نظر را انتخاب کنید&nbsp;...</option>
                    <%
                    } else {
                        City city = CityDAO.findCityById(university.getCityId());
                    %>
                    <option value="<%=city.getCityId()%>" selected>
                        <%=city.getName()%>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>آدرس :</label>
                <input class="formInput addressInput<%=waitForVerify?" formInputDeactive":""%>"
                       style="width: 650px;margin-left: 20px;" type="text" name="address"
                       value="<%=waitForVerify||isErrorEdit? university.getAddress() :isPreDefined?university.getAddress():""%>"
                       maxlength="300" <%=waitForVerify?"disabled":""%>>
            </div>
            <%
                boolean hadPostalCode = false;
                if (university.getPostalCode() != null)
                    hadPostalCode = !university.getPostalCode().equals("1111111111");
            %>
            <div class="formItem">
                <label>کد پستی :</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>"
                       style="width: 175px;margin-left: 20px;direction: ltr"
                       value="<%=hadPostalCode?university.getPostalCode():"" %>"
                       maxlength="10" name="postal-code" type="text"<%=waitForVerify?"disabled":""%>>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>تلفن :</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>" name="tel" minlength="3"
                       maxlength="8"
                       value="<%=waitForVerify||isErrorEdit?university.getTeleNo().substring(3,university.getTeleNo().length()):""%>"
                       style="width: 140px;"
                       type="text"<%=waitForVerify?"disabled":""%>>


                <input class="formInput formInputDeactive"
                       value="<%=waitForVerify?university.getTeleNo().substring(1,3):""%>" maxlength="2" id="pish-tel"
                       style="width: 55px;direction: ltr;" type="text" disabled>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr" type="text" disabled>
            </div>
            <div class="formItem">
                <label>فکس :</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>" maxlength="8"
                       minlength="3" name="fax"
                       value="<%=waitForVerify||isErrorEdit?university.getFaxNo().substring(3,university.getFaxNo().length()):""%>"
                       style="width: 140px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
                <input class="formInput  formInputDeactive"
                       style="width: 55px;direction: ltr" type="text"
                       value="<%=waitForVerify?university.getTeleNo().substring(1,3):""%>"
                       maxlength="3" id="pish-fax" disabled>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr;" type="text" disabled>
            </div>
        </div>
        <div class="formRow">
            <div class="formRow">
                <div class="formItem">
                    <label>سایت اینترنتی :</label>
                    <input class="formInput domainInput<%=waitForVerify?" formInputDeactive":""%>" name="domain"
                           maxlength="35" value="<%=waitForVerify||isErrorEdit?university.getSiteAddress():""%>"
                           style="width: 420px;margin-right: 47px"
                           type="text"<%=waitForVerify?"disabled":""%>>
                </div>
            </div>
            <div class="formRow" id="afterMapRow" style="padding-bottom: 110px">
                <div class="formItem">
                    <label>پست الکترونیکی عمومی :</label>
                    <input class="formInput emailInput<%=waitForVerify?" formInputDeactive":""%>" name="public-email"
                           maxlength="60" value="<%=waitForVerify||isErrorEdit?university.getUniPublicEmail():""%>"
                           style="width: 420px;"
                           type="text"<%=waitForVerify?"disabled":""%>>
                </div>
            </div>
        </div>
        <div id="mapCon">
            <div class="<%=isEditVerify?"mapShow":"mapChoose"%>" <%=isErrorEdit || waitForVerify ? " lat='" + university.getMapLocLat()
                    + "' lng='" + university.getMapLocLng() + "' " : ""%> lat-input-id="lat" lng-input-id="lng"></div>
            <label style="padding: 10px">آدرس مرکز اصلی برروي نقشه</label>
            <input type="hidden" name="lat" id="lat">
            <input type="hidden" name="lng" id="lng">
        </div>
    </div>

    <div class="formBox" style="position: relative">
        <div class="formRow">
            <div class="formItem">
                <label>نام و نام خانوادگی بالاترین مقام :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="top-manager"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?university.getTopManagerName():""%>"
                       style="width: 240px;margin-left: 20px;margin-right: 9px"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>سمت بالاترین مقام :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="top-manager-pos"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?university.getTopManagerPos():""%>"
                       style="width: 200px;margin-left: 20px;margin-right: 9px"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>نام و نام خانوادگی مقام مجاز امضا :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="sig-name"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?university.getSignatoryName():""%>"
                       style="width: 240px;margin-left: 20px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>سمت مقام مجاز امضا :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="sig-pos"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?university.getSignatoryPos():""%>"
                       style="width: 200px;margin-left: 20px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>کد ملی مقام مجاز امضاء:</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>"
                       style="width: 175px;margin-left: 20px;direction: ltr"
                       value="<%=waitForVerify||isErrorEdit?university.getSignatoryNationalId():"" %>"
                       maxlength="10" name="sig-national-code" type="text"<%=waitForVerify?"disabled":""%>>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>نام نماینده :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="agent-f-name"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?personalInfo.getFname():""%>"
                       style="width: 140px;margin-left: 20px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>نام خانوادگی نماینده :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="agent-l-name"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?personalInfo.getLname():""%>"
                       style="width: 140px;margin-left: 20px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>سمت نماینده :</label>
                <input class="formInput persianInput<%=waitForVerify?" formInputDeactive":""%>" name="agent-pos"
                       maxlength="100" value="<%=waitForVerify||isErrorEdit?agent.getAgentPos():""%>"
                       style="width: 200px;margin-left: 20px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>کد ملی نماینده :</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>"
                       style="width: 175px;margin-left: 20px;direction: ltr"
                       value="<%=waitForVerify||isErrorEdit?agent.getNationalId():"" %>"
                       maxlength="10" name="agent-national-id" type="text"<%=waitForVerify?"disabled":""%>>
            </div>
            <div class="formItem">
                <label>تلفن نماینده:</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>" name="a-tel"
                       minlength="3"
                       maxlength="8"
                       value="<%=waitForVerify||isErrorEdit?agent.getTelNo().substring(3,agent.getTelNo().length()):""%>"
                       style="width: 140px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
                <input class="formInput formInputDeactive"
                       value="<%=waitForVerify?agent.getTelNo().substring(1,3):""%>" maxlength="2" id="a-pish-tel"
                       style="width: 55px;direction: ltr;" type="text" disabled>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr" type="text" disabled>
            </div>
            <div class="formItem">
                <label>فکس نماینده:</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>" name="a-fax"
                       minlength="3"
                       maxlength="8"
                       value="<%=waitForVerify||isErrorEdit?agent.getFaxNo().substring(3,agent.getFaxNo().length()):""%>"
                       style="width: 140px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
                <input class="formInput formInputDeactive"
                       value="<%=waitForVerify?university.getFaxNo().substring(1,3):""%>" maxlength="2" id="a-pish-fax"
                       style="width: 55px;direction: ltr;" type="text" disabled>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr" type="text" disabled>
            </div>
            <div class="formItem">
                <label>تلفن همراه نماینده:</label>
                <input class="formInput numberInput<%=waitForVerify?" formInputDeactive":""%>" name="a-mobile"
                       maxlength="10"
                       value="<%=waitForVerify||isErrorEdit?agent.getMobileNo().substring(1,agent.getMobileNo().length()):""%>"
                       style="width: 140px;"
                       type="text"<%=waitForVerify?"disabled":""%>>
                <input class="formInput formInputDeactive" value="+98"
                       style="width: 55px;margin-left: 20px;direction: ltr;" type="text" disabled>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>پست الکترونیکی نماینده:</label>
                <input class="formInput emailInput<%=waitForVerify?" formInputDeactive":""%>" name="a-email"
                       maxlength="35"
                       value="<%=waitForVerify||isErrorEdit?agent.getSupportEmail():""%>"
                       style="width: 300px;margin-left: 20px;" type="text"<%=waitForVerify?"disabled":""%>>
            </div>
        </div>
        <div class="formRow" style="display: block; position: relative;top:75px">
            <label style="color: #c00;">جهت رهگیری ثبت نام تا قبل از قطعی شدن عضویت ، لطفا با :<br>
                نام کاربری :
                <%=university.getUniNationalId()%>
                ، کلمه عبور :
                <%=university.getUniNationalId()%>
                به سایت وارد شوید.
            </label>
            <% if (!waitForVerify) { %>
            <input type="submit" value="ثبت عضویت" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left;">
            <%}%>
        </div>
    </div>
</form>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/register.js"></script>
<script type="text/javascript" src="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.js?callback=initMaps" defer
        async></script>
</body>
</html>