<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="com.atrosys.util.Mailing" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.ibm.icu.util.PersianCalendar" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();

    List<UniStatus> uniErrorStatuses = new LinkedList<>();
    uniErrorStatuses.add(UniStatus.REGISTER_PAGE_ERROR);
    uniErrorStatuses.add(UniStatus.SUBSCRIBE_PAGE_ERROR);

    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.UNIVERSITY.getValue(), AdminSubAccessType.EDIT.getValue())) {
        response.sendError(403);
        return;
    }
    University changingUni = null;
    if (!ServletFileUpload.isMultipartContent(request))
        changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
    boolean isConfirm = "confirm".equals(request.getParameter("action"));
    boolean isSendConfirm = "send-confirm".equals(request.getParameter("action"));
    boolean isRemove = "remove".equals(request.getParameter("action"));
    boolean isSendRemove = "send-remove".equals(request.getParameter("action"));
    boolean isError = "error".equals(request.getParameter("action"));
    boolean isSendError = "send-error".equals(request.getParameter("action"));
    String errorSubStatusJson = null;
    String changeStr = "";
    UniStatus changingUniStatus = null;
    if (isSendConfirm) {
        changingUniStatus = UniStatus.fromValue(Integer.valueOf(request.getParameter("uni-status")));
        changeStr = "تغییر وضعیت به " + changingUniStatus.getFaStr();
    }

    if (ServletFileUpload.isMultipartContent(request)) {
        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        HashMap<String, String> uploadFields = new HashMap<>();
        HashMap<String, InputStream> uploadedFiles = new HashMap<>();
        String extension = null;
        boolean fileUploaded = false;
        for (FileItem item : items)
            if (item.isFormField())
                uploadFields.put(item.getFieldName(), item.getString("UTF-8"));
            else {
                String fileName = item.getName();
                if (!fileName.isEmpty()) {
                    fileUploaded = true;
                    if (fileName.lastIndexOf('.') != -1)
                        extension = fileName.substring(fileName.lastIndexOf('.'), fileName.length());
                }
                uploadedFiles.put(item.getFieldName(), item.getInputStream());
            }
        if ("send-info-confirm".equals(uploadFields.get("action"))) {
            changingUniStatus = UniStatus.fromValue(Integer.valueOf(uploadFields.get("uni-status")));
            changeStr = "تغییر وضعیت به " + changingUniStatus.getFaStr();
            if (changingUniStatus.equals(UniStatus.SUBSCRIBE_PAGE)) {
                byte[] bytes = null;
                if (fileUploaded)
                    bytes = IOUtils.toByteArray(uploadedFiles.get("attach-file"));
                changeStr = "تغییر وضعیت به " + UniStatus.SUBSCRIBE_PAGE.getFaStr();
                changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(uploadFields.get("id")));
                changingUni.setUniStatus(UniStatus.SUBSCRIBE_PAGE.getValue());
                changingUni.setSubscriptionExampleForm(bytes);
                changingUni = UniversityDAO.save(changingUni);
                UniStatusLog uniStatusLog = new UniStatusLog();
                uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                uniStatusLog.setMessage(changeStr);
                uniStatusLog.setUniStatus(changingUni.getUniStatus());
                uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
                uniStatusLog.setApprovalAdminId(admin.getId());
                uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
                if ("on".equals(uploadFields.get("send-mail")))
                    Mailing.sendReqToSubsChangeMail(changingUni.getUniPublicEmail(), changingUni.getUniName(), changingUni.getTopManagerName(), request);
                request.getRequestDispatcher("manage-uni.jsp?sub-code=" + changingUni.getUniSubSystemCode()).forward(request, response);
                return;
            } else if (changingUniStatus.equals(UniStatus.PRIMARY_AGENT_REGISTER)) {
                byte[] SubsFileBytes = IOUtils.toByteArray(uploadedFiles.get("subs-file"));
                byte[] postTicketFileBytes = IOUtils.toByteArray(uploadedFiles.get("post-ticket-file"));
                byte[] letterFileBytes = IOUtils.toByteArray(uploadedFiles.get("letter-file"));
                uploadFields.get("contract-no");
                java.sql.Date cDate = Util.convertJalaliToGregorian(
                        uploadFields.get("date-year-c") + "/" + uploadFields.get("date-mon-c") +
                                "/" + uploadFields.get("date-day-c"));
                if (SubsFileBytes != null && postTicketFileBytes != null
                        && letterFileBytes != null && uploadFields.get("contract-no") != null) {
                    changeStr = "تغییر وضعیت به " + UniStatus.AGENT_EDIT_VERIFY.getFaStr();
                    changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(uploadFields.get("id")));
                    changingUni.setUniStatus(UniStatus.PRIMARY_AGENT_REGISTER.getValue());
                    changingUni.setSubscriptionFormSigned(SubsFileBytes);
                    changingUni.setSubscriptionPostTicket(postTicketFileBytes);
                    changingUni.setSubscriptionLetter(letterFileBytes);
                    changingUni.setSubscriptionContractNo(uploadFields.get("contract-no"));
                    changingUni.setSubscriptionContractDate(cDate);
                    changingUni = UniversityDAO.save(changingUni);
                    UniStatusLog uniStatusLog = new UniStatusLog();
                    uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    uniStatusLog.setMessage(changeStr);
                    uniStatusLog.setUniStatus(changingUni.getUniStatus());
                    uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
                    uniStatusLog.setApprovalAdminId(admin.getId());
                    uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
                    if ("on".equals(uploadFields.get("send-mail")))
                        Mailing.sendSubsToAgentChangeMail(changingUni.getUniPublicEmail(), changingUni.getUniName(),
                                changingUni.getTopManagerName(), uploadFields.get("contract-no"), cDate, request);
                    request.getRequestDispatcher("manage-uni.jsp?sub-code=" + changingUni.getUniSubSystemCode()).forward(request, response);
                    return;
                }
            } else {
                changeStr = "تغییر وضعیت به " + changingUniStatus.getFaStr();
                changingUni = UniversityDAO.findUniByUniNationalId(Long.valueOf(uploadFields.get("id")));
                changingUni.setUniStatus(changingUniStatus.getValue());
                changingUni = UniversityDAO.save(changingUni);
                UniStatusLog uniStatusLog = new UniStatusLog();
                uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                uniStatusLog.setMessage(changeStr);
                uniStatusLog.setUniStatus(changingUni.getUniStatus());
                uniStatusLog.setApprovalAdminId(admin.getId());
                uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
                uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
                if ("on".equals(uploadFields.get("send-mail"))) {
                    if (changingUniStatus.equals(UniStatus.NEXT_PHASE)) {
                        Mailing.sendToNextPhaseChangeMail(changingUni.getUniPublicEmail(), changingUni.getTopManagerName(), request);
                    } else {
                        Mailing.sendGeneralUniStatusChangeMail(changingUni.getUniPublicEmail(), changingUni.getUniName(),
                                changingUni.getTopManagerName(), changingUniStatus.getFaStr(), request);
                    }
                }
                request.getRequestDispatcher("manage-uni.jsp?sub-code=" + changingUni.getUniSubSystemCode()).forward(request, response);
                return;
            }
        }
    }
    if (isRemove || isSendRemove)
        changeStr = "حذف اطلاعات " + changingUni.getUniName();
    if (isSendRemove) {
        UniversityDAO.delete(changingUni.getUniNationalId());
        PersonalInfoDAO.delete(changingUni.getUniNationalId());
        List<UserRole> userRoles = UserRoleDAO.findUserRolesByNationalId(changingUni.getUniNationalId());
        for (UserRole userRole : userRoles) {
            Agent agent = AgentDAO.findAgentByRoleId(userRole.getRoleId());
            AgentDAO.delete(agent.getAgentId());
            UserRoleDAO.delete(userRole.getRoleId());
        }

        UniStatusLog uniStatusLog = new UniStatusLog();
        uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
        uniStatusLog.setMessage(changeStr);
        uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
        uniStatusLog.setApprovalAdminId(admin.getId());
        uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
        request.getRequestDispatcher("manage-uni.jsp?sub-code=" + changingUni.getUniSubSystemCode()).forward(request, response);
        return;
    }

    if (isError) {
        changeStr = String.format("تغییر وضعیت %s به %s و تغییر زیر وضعیت به", changingUni.getUniName(), UniStatus.REGISTER_PAGE_ERROR.getFaStr());
        List<List<UniSubStatusResponse>> errorUniSubStatuses = new LinkedList<>();
        List<UniSubStatusResponse> subStatuses2 = new LinkedList<>();
        List<UniSubStatusResponse> subStatuses1002 = new LinkedList<>();
        for (UniSubStatus subStatus : UniSubStatus.values()) {
            UniSubStatusResponse subStatusResponse = new UniSubStatusResponse(subStatus.getValue(), subStatus.getFaStr());
            if (subStatus.getValue() < 1000)
                subStatuses2.add(subStatusResponse);
            else if (subStatus.getValue() >= 1000 && subStatus.getValue() < 2000) {
                subStatuses1002.add(subStatusResponse);
            }
        }
        errorUniSubStatuses.add(subStatuses2);
        errorUniSubStatuses.add(subStatuses1002);
        Gson gson = new Gson();
        errorSubStatusJson = gson.toJson(errorUniSubStatuses).replaceAll("\"", "'");
    }
    if (isSendError) {
        int errorUnistatusVal = Integer.valueOf(request.getParameter("uni-status"));
        changingUni.setUniStatus(errorUnistatusVal);
        changingUni.setUniSubStatus(Integer.valueOf(request.getParameter("sub-status")));
        UniStatusLog uniStatusLog = new UniStatusLog();
        uniStatusLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
        uniStatusLog.setMessage(request.getParameter("message"));
        uniStatusLog.setUniStatus(changingUni.getUniStatus());
        uniStatusLog.setUniSubStatus(changingUni.getUniSubStatus());
        uniStatusLog.setApprovalAdminId(admin.getId());
        uniStatusLog.setUniNationalId(changingUni.getUniNationalId());
        uniStatusLog = UniStatusLogDAO.save(uniStatusLog);
        changingUni.setUniStatusLog(uniStatusLog.getId());
        changingUni = UniversityDAO.save(changingUni);
        if ("on".equals(request.getParameter("send-mail")))
            Mailing.sendReqErrorMail(changingUni.getUniPublicEmail(), changingUni.getUniName(),
                    changingUni.getTopManagerName(), UniSubStatus.fromValue(changingUni.getUniSubStatus()), uniStatusLog.getMessage(), request);
        request.getRequestDispatcher("manage-uni.jsp").forward(request, response);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;

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
</head>
<body>
<form id="send-change" method="post" action="change-uni-state.jsp">
    <input type="hidden" name="action" value="send-<%=request.getParameter("action")%>">
    <input type="hidden" name="id" value="<%=changingUni.getUniNationalId()%>">
    <input type="hidden" name="sub-code" value="<%=changingUni.getUniSubSystemCode()%>">
    <%if (isSendConfirm) {%>
    <input type="hidden" name="uni-status" value="<%=changingUniStatus.getValue()%>">
    <%}%>
    <div class="formBox">
        <h3>تغییر در وضعیت دانشگاه</h3>
        <div class="formRow">

            <div class="formItem">
                <label>نوع تغییر :</label>
                <%if (isError) {%>
                <select name="uni-status" id="uni-status-select"
                        class="formSelect"
                        style="width: 300px;margin-left: 20px">
                    <% for (UniStatus errorStatus : uniErrorStatuses) {%>
                    <option <%=uniErrorStatuses.indexOf(errorStatus) == 0 ? "selected" : ""%>
                            value="<%=errorStatus.getValue()%>"><%=errorStatus.getFaStr()%>
                    </option>
                    <%}%>
                </select>
                <%} else if (isConfirm) {%>
                <select class="formSelect" name="uni-status" style="width: 300px;margin-left: 20px">
                    <% for (UniStatus uniStatus : UniStatus.values()) { %>
                    <option value="<%=uniStatus.getValue()%>"><%="تغییر وضعیت به " + uniStatus.getFaStr()%>
                    </option>
                    <% }%>

                </select>
                <%} else {%>
                <select class="formSelect formInputDeactive" style="width: 300px;margin-left: 20px">
                    <option selected disabled hidden><%=changeStr%>
                    </option>
                </select>
                <%}%>
            </div>
            <%if (isError || isSendError) {%>
            <div class="formItem">
                <label>زیر وضعیت :</label>
                <select name="sub-status" id="sub-status-select" json="<%=errorSubStatusJson%>">
                </select>
            </div>
            <%}%>
        </div>
        <div class="formRow">
            <div class="formItem">
                <label>شناسه ملی:</label>
                <input class="formInput formInputDeactive" style="width: 200px;"
                       type="text" value="<%=changingUni.getUniNationalId()%>" disabled>
            </div>
            <div class="formItem">
                <label>نام دانشگاه:</label>
                <input class="formInput formInputDeactive" style="width: 200px;"
                       type="text" value="<%=changingUni.getUniName()%>" disabled>
            </div>
        </div>
        <%if (isError) {%>
        <div>
            <label style="float: right;">پیام :</label>
            <textarea class="formRow" name="message" rows="4"
                      style="border: 1px solid black;width: 100%;margin:10px 0;white-space: pre-wrap;"> </textarea>
        </div>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <input style="margin-left: 10px" name="send-mail" type="checkbox" class="btn btn-primary formBtn">
                <label>آیا نامه ی الکترونیکی به مشترک ارسال شود؟</label>
            </div>
        </div>
        <%}%>
        <%if (!isSendConfirm) {%>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
        <%}%>
    </div>
</form>
<%if (isSendConfirm && changingUniStatus.equals(UniStatus.SUBSCRIBE_PAGE)) {%>
<form id="send-change-info" method="post" enctype="multipart/form-data" action="change-uni-state.jsp">
    <input type="hidden" name="action" value="send-info-confirm">
    <input type="hidden" name="id" value="<%=changingUni.getUniNationalId()%>">
    <input type="hidden" name="sub-code" value="<%=changingUni.getUniSubSystemCode()%>">
    <input type="hidden" name="uni-status" value="<%=UniStatus.SUBSCRIBE_PAGE.getValue()%>">
    <div class="formBox">
        <div class="formRow">
            <label>ضمیمه ی فایل :</label>
            <input type="file" name="attach-file" style="display: inline-block;margin-right: 20px;"/>
        </div>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <input style="margin-left: 10px" name="send-mail" type="checkbox" class="btn btn-primary formBtn">
                <label>آیا نامه ی الکترونیکی به مشترک ارسال شود؟</label>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem" style="float:left;margin-right: 10px">
                <input type="submit" value="تایید" class="btn btn-primary formBtn">
            </div>
        </div>
        <br style="clear: both;">
    </div>
</form>
<%} else if (isSendConfirm && changingUniStatus.equals(UniStatus.PRIMARY_AGENT_REGISTER)) {%>
<form id="send-change-info" method="post" enctype="multipart/form-data" action="change-uni-state.jsp">
    <input type="hidden" name="action" value="send-info-confirm">
    <input type="hidden" name="id" value="<%=changingUni.getUniNationalId()%>">
    <input type="hidden" name="sub-code" value="<%=changingUni.getUniSubSystemCode()%>">
    <input type="hidden" name="uni-status" value="<%=UniStatus.PRIMARY_AGENT_REGISTER.getValue()%>">
    <div class="formBox">
        <div class="formRow">
            <label>ضمیمه ی فایل اشتراک امضاء شده توسط طرفین:</label>
            <input type="file" name="subs-file" style="display: inline-block;margin-right: 20px;"/>
        </div>
        <div class="formRow">
            <label>ضمیمه ی فایل نامه ارسال قرداد :</label>
            <input type="file" name="letter-file" style="display: inline-block;margin-right: 20px;"/>
        </div>
        <div class="formRow">
            <label>ضمیمه ی فایل رسید پست ارسال قرارداد:</label>
            <input type="file" name="post-ticket-file" style="display: inline-block;margin-right: 20px;"/>
        </div>
        <div class="formItem">
            <label>شماره قرارداد اشتراک :</label>
            <input class="formInput numberInput" name="contract-no"
                   maxlength="7"
                   style="width: 200px;margin-left: 20px;"
                   type="text">
        </div>
        <div class="formItem formDatePicker">
            <label>تاریخ قرارداد اشتراک :</label>
            <%
                PersianCalendar persianCalendar = new PersianCalendar(new Date());
                int currentYear = persianCalendar.get(Calendar.YEAR);
                int currentMonth = persianCalendar.get(Calendar.MONTH) + 1;
                int currentDay = persianCalendar.get(Calendar.DAY_OF_MONTH);
            %>
            <select class="formSelect dateDay" name="date-day-c" style="width: 50px;"
                    current-date="<%=currentDay%>"></select>
            <select class="formSelect dateMon" name="date-mon-c"
                    style="width: 50px;">
                <% for (int i = 1; i <= 12; i++) { %>
                <option value="<%=i<10?"0"+i:i%>"<%=i == currentMonth ? " selected" : ""%>><%=i%>
                </option>
                <% } %>
            </select>
            <select class="formSelect dateYear" name="date-year-c"
                    style="width: 60px;">
                <%
                    for (int i = 0; i >= -100; i--) {
                        int year = currentYear + i;
                %>
                <option value="<%=year%>"><%=year%>
                </option>
                <% } %>
            </select>
        </div>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <input style="margin-left: 10px" name="send-mail" type="checkbox" class="btn btn-primary formBtn">
                <label>آیا نامه ی الکترونیکی به مشترک ارسال شود؟</label>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem" style="float:left;margin-right: 10px">
                <input type="submit" value="تایید" class="btn btn-primary formBtn">
            </div>
        </div>
        <br style="clear: both;">
    </div>
</form>
<%} else if (isSendConfirm) {%>
<form id="send-change-info" method="post" enctype="multipart/form-data" action="change-uni-state.jsp">
    <input type="hidden" name="action" value="send-info-confirm">
    <input type="hidden" name="id" value="<%=changingUni.getUniNationalId()%>">
    <input type="hidden" name="sub-code" value="<%=changingUni.getUniSubSystemCode()%>">
    <input type="hidden" name="uni-status" value="<%=changingUniStatus.getValue()%>">
    <div class="formBox">
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <input style="margin-left: 10px" name="send-mail" type="checkbox" class="btn btn-primary formBtn">
                <label>آیا نامه ی الکترونیکی به مشترک ارسال شود؟</label>
            </div>
        </div>
        <div class="formRow">
            <div class="formItem" style="float:left;margin-right: 10px">
                <input type="submit" value="تایید" class="btn btn-primary formBtn">
            </div>
        </div>
        <br style="clear: both;">
    </div>
</form>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="./js/change-uni-state.js"></script>
</body>
</html>