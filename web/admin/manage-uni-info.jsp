<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>

<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%@ page import="com.atrosys.model.UserRoleType" %>

<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("UTF-8");
    AdminSessionInfo adminSessionInfo = null;
    try {
        adminSessionInfo = new AdminSessionInfo(session);
    } catch (Exception e) {
        e.printStackTrace();
    }
    assert adminSessionInfo != null;
    Admin admin = adminSessionInfo.getAdmin();
    String message = null;


    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!adminSessionInfo.isAdminLogedIn()) {
        response.sendError(403);
        return;
    }

    try {
        if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.UNIVERSITY.getValue())) {
            response.sendError(403);
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    boolean addSubAccess = false;
    boolean readSubAccess = false;
    boolean editSubAccess = false;

    try {

        addSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.UNIVERSITY.getValue(),
                AdminSubAccessType.ADD.getValue());
        readSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.UNIVERSITY.getValue(),
                AdminSubAccessType.READ.getValue());
        editSubAccess = AdminDAO.checkAdminSubAccess(admin.getId(),
                AdminAccessType.UNIVERSITY.getValue(),
                AdminSubAccessType.READ.getValue());
    } catch (Exception e) {
        e.printStackTrace();
    }
    boolean isEdit = "edit-uni".equals(request.getParameter("action")) && editSubAccess;
    boolean isSendEdit = "send-edit-uni".equals(request.getParameter("action"));

    boolean isEditMainInfo = "main-info".equals(request.getParameter("editType"));
    boolean isEditManagementInfo = "management-info".equals(request.getParameter("editType"));
    boolean isEditAddressInfo = "address-info".equals(request.getParameter("editType"));
    boolean isEditAgentInfo = "agent-info".equals(request.getParameter("editType"));

    String editType =null;

    if ((isEdit || isSendEdit) && !editSubAccess) {
        response.sendError(403);
        return;
    }

    University university = null;
    Agent uniPrimaryAgent = null;
    PersonalInfo uniPrimaryAgentPersonalInfo = null;

    if (isSendEdit || isEdit) {

        try {
            university = UniversityDAO.findUniByUniNationalId(
                    Long.valueOf(request.getParameter("uni-national-id")));

            uniPrimaryAgent = AgentDAO.findUniPrimaryAgentByUniId(university.getUniNationalId());
            uniPrimaryAgentPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(uniPrimaryAgent.getNationalId());
        } catch (Exception e) {
            e.printStackTrace();
        }


        if (isSendEdit) {
            editType = request.getParameter("editType");
            isEditAddressInfo=false;
            isEditAgentInfo=false;
            isEditMainInfo=false;
            isEditManagementInfo=false;

            if (editType.equals("main-info" )) {
                assert university != null;
                Long uniNationalIdNew = Long.valueOf(request.getParameter("uni-national-id-new"));
                Long uniNationalIdOld = university.getUniNationalId();

                university.setUniNationalId(uniNationalIdNew);
                university.setUniName(request.getParameter("uni-name"));
                university.setEcoCode(request.getParameter("uni-eco-code"));
                try {
                    UniversityDAO.update(uniNationalIdOld, university);
                    UniStatusLogDAO.updateUniNationalId(uniNationalIdOld, uniNationalIdNew);
                    AgentDAO.updateUniNationalId(uniNationalIdOld,uniNationalIdNew);
                    message="ثبت تغییرات با موفقیت انجام شد";
                }
                catch (Exception e) {
                    message = "خطایی در ثبت تغییرات ایجاد شد.";
                }
                isEditMainInfo = true;
            } else if(editType.equals("management-info")) {
                university.setTopManagerName(request.getParameter("uni-top-manager-name"));
                university.setTopManagerPos(request.getParameter("uni-top-manager-pos"));
                university.setSignatoryName(request.getParameter("uni-signatory-name"));
                university.setSignatoryPos(request.getParameter("uni-signatory-pos"));
                university.setSignatoryNationalId(request.getParameter("uni-signatory-national-id"));
                UniversityDAO.save(university);
                isEditManagementInfo = true;
                message="ثبت تغییرات با موفقیت انجام شد";
            } else if(editType.equals("address-info")) {
                boolean isCityCorrect = false;
                Long newCityID;

                try {
                    if (!CityDAO.isCityNameNew(request.getParameter("uni-city-name"))) {
                        isCityCorrect= true;
                    } else {
                        message = "نام شهر نادرست می باشد.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }


                if (isCityCorrect) {
                    try {
                        newCityID = CityDAO.findIdByCityName(request.getParameter("uni-city-name"));
                        assert university != null;
                        university.setCityId(newCityID);
                        university.setAddress(request.getParameter("uni-address"));
                        university.setPostalCode(request.getParameter("uni-postal-code"));
                        university.setTeleNo(request.getParameter("uni-tele-no"));
                        university.setFaxNo(request.getParameter("uni-fax-no"));
                        university.setSiteAddress(request.getParameter("uni-site-address"));
                        university.setUniPublicEmail(request.getParameter("uni-public-email"));
                        UniversityDAO.save(university);
                        message="ثبت تغییرات با موفقیت انجام شد";
                    } catch (Exception e) {
                        message = "ثبت تغییرات ناموفق بود. لطفا دوباره تلاش کنید و در صورت تکرار مشکل با ادمین سایت تماس برقرار کنید.";
                    }
                }


                isEditAddressInfo = true;
            } else if(editType.equals("agent-info")) {

                Long agentNationalIdNew = Long.valueOf(request.getParameter("agent-national-id"));
                assert uniPrimaryAgent != null;
                Long agentNationalIdOld = uniPrimaryAgent.getNationalId();

                assert uniPrimaryAgentPersonalInfo != null;
                uniPrimaryAgentPersonalInfo.setFname(request.getParameter("agent-fname"));
                uniPrimaryAgentPersonalInfo.setLname(request.getParameter("agent-lname"));
                uniPrimaryAgentPersonalInfo.setNationalId(agentNationalIdNew);


                uniPrimaryAgent.setNationalId(agentNationalIdNew);
                uniPrimaryAgent.setAgentPos(request.getParameter("agent-pos"));
                uniPrimaryAgent.setTelNo(request.getParameter("agent-tele-no"));
                uniPrimaryAgent.setMobileNo(request.getParameter("agent-mobile-no"));
                uniPrimaryAgent.setFaxNo(request.getParameter("agent-fax-no"));
                AgentDAO.save(uniPrimaryAgent);

                UserRole userRole = UserRoleDAO.findUserRolesByNationalId(agentNationalIdOld).get(0);
                userRole.setNationalId(agentNationalIdNew);
                UserRoleDAO.save(userRole);


                PersonalInfoDAO.update(agentNationalIdOld, uniPrimaryAgentPersonalInfo);

                message="ثبت تغییرات با موفقیت انجام شد";
                isEditAgentInfo = true;
            }


            isEdit=true;
        }

    }

    if (isEditMainInfo) {
        editType = "main-info";
    } else if (isEditManagementInfo) {
        editType = "management-info";
    } else if  (isEditAddressInfo) {
        editType = "address-info";
    } else if (isEditAgentInfo) {
        editType = "agent-info";
    }



//    List<University> universityList = null;
//    try {
//        universityList = UniversityDAO.findAllUnisBySubCode(0);
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta content="no-cache" http-equiv="Pragma">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        @media screen and (max-width: 1060px) {
            .formTable th {
                min-width: inherit !important;
                min-height: 800px;
            }
        }

    </style>
</head>
<body>
<%if (addSubAccess || isEdit) {%>
<form id="send-form" method="post" action="manage-uni-info.jsp">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="send-edit-uni">
    <input type="hidden" name="uni-national-id" value="<%=university.getUniNationalId()%>">
    <input type="hidden" name="editType" value="<%=editType%>">
    <%} else if (addSubAccess) {%>
    <input type="hidden" name="action" value="send-uni">
    <%}%>

    <div class="formBox" style="border-color: white">
        <h3>
            <%assert university !=null;%>
            <%=university.getUniName()%>
        </h3>
        <% if (message != null) {
            if (message.equals("ثبت تغییرات با موفقیت انجام شد")) {%>
        <h3 style="color: #4cae4c">
            <%=message%>
            <%message=null;%>
        </h3>
        <%} }%>
    </div>

    <% if (isEdit && isEditMainInfo) { %>
    <div class="formBox">
        <%if (isEdit) {
            assert uniPrimaryAgent !=null;
            assert uniPrimaryAgentPersonalInfo != null;
        %>

        <h3>ویرایش مشخصات کلی</h3>
        <%} else {%>
        <h3>افزودن دانشگاه</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow">
            <div class="formItem" style="margin-right: 10px">
                <label>شناسه ملی :</label>
                <input class="formInput numberInput" name="uni-national-id-new"
                       value="<%=isEdit?university.getUniNationalId():""%>"
                       maxlength="15"
                       style="width: 150px;margin-left: 20px;">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>نام اصلی:</label>
                <input class="formInput persianInput" name="uni-name" minlength="1"
                       style="width:400px;margin-left: 20px;"
                       value="<%=isEdit?university.getUniName():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> کد اقتصادی :</label>
                <input class="formInput numberInput" name="uni-eco-code" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getEcoCode():""%>">
            </div>
        </div>

        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-uni.jsp?sub-code=0" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
    <%}%>

    <% if(isEdit && isEditManagementInfo) {%>
    <div class="formBox">

        <%if (isEdit) {
            assert university != null;
        %>
        <h3>ویرایش مشخصات مدیران</h3>
        <%} else {%>
        <h3>افزودن مدیر</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>

        <div class="formRow">

            <div class="formItem" style="margin-right: 10px">
                <label> بالاترین مقام :</label>
                <input class="formInput persianInput" name="uni-top-manager-name" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getTopManagerName():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label> سمت:</label>
                <input class="formInput persianInput" name="uni-top-manager-pos" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getTopManagerPos():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> مقام مجاز امضا:</label>
                <input class="formInput persianInput" name="uni-signatory-name" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getSignatoryName():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> سمت:</label>
                <input class="formInput persianInput" name="uni-signatory-pos" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getSignatoryPos():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> کد ملی:</label>
                <input class="formInput numberInput" name="uni-signatory-national-id"
                       style="width:150px;margin-left: 20px;"
                       maxlength="12"
                       minlength="8"
                       value="<%=isEdit?university.getSignatoryNationalId():""%>">
            </div>
        </div>

        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-uni.jsp?sub-code=0" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
    <%}%>

    <% if(isEdit && isEditAddressInfo) {%>
    <div class="formBox">
        <%if (isEdit) {
            assert university != null;
        %>
        <h3>ویرایش نشانی:</h3>
        <%} else {%>
        <h3>افزودن نشانی:</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>

        <div class="formRow">

            <div class="formItem" style="margin-right: 10px">
                <label> استان:</label>
                <input class="formInput <%=isEdit?" formInputDeactive":" persianInput"%>" name="uni-state-name" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?StateDAO.findStateNameById(university.getStateId()):""%>"
                    <%=isEdit?" disabled":""%>>
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> شهر:</label>
                <input class="formInput persianInput" name="uni-city-name" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?CityDAO.findCityNameById(university.getCityId()):""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>آدرس کامل:</label>
                <input class="formInput persianInput" name="uni-address" maxlength="300"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getAddress():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> کد پستی:</label>
                <input class="formInput numberInput" name="uni-postal-code" maxlength="16"
                       style="width:200px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?university.getPostalCode():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>تلفن:</label>
                <input class="formInput numberInput" name="uni-tele-no" maxlength="12"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?university.getTeleNo():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>دورنگار:</label>
                <input class="formInput numberInput" name="uni-fax-no" maxlength="12"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?university.getFaxNo():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>وبسایت:</label>
                <input class="domainInput" name="uni-site-address" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getSiteAddress():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>پست الکترونیکی عمومی:</label>
                <input class="emailInput" name="uni-public-email" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?university.getUniPublicEmail():""%>">
            </div>
        </div>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-uni.jsp?sub-code=0" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
    <%}%>


    <% if(isEdit && isEditAgentInfo) {%>
    <div class="formBox">
        <%if (isEdit) {
            assert university != null;
        %>
        <h3>ویرایش مشخصات نماینده تام الختیار:</h3>
        <%} else {%>
        <h3>افزودن نماینده:</h3>
        <%}%>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>

        <div class="formRow">

            <div class="formItem" style="margin-right: 10px">
                <label> نام:</label>
                <input class="formInput persianInput" name="agent-fname" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?uniPrimaryAgentPersonalInfo.getFname():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> نام خانوادگی:</label>
                <input class="formInput persianInput" name="agent-lname" maxlength="30"
                       style="width:150px;margin-left: 20px;"
                       value="<%=isEdit?uniPrimaryAgentPersonalInfo.getLname():""%>">
            </div>
            <div class="formItem" style="margin-right: 10px">
                <label>کد ملی:</label>
                <input class="formInput numberInput" name="agent-national-id" maxlength="16"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?uniPrimaryAgent.getNationalId():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label> سمت:</label>
                <input class="formInput persianInput" name="agent-pos" maxlength="30"
                       style="width:200px;margin-left: 20px;"
                       value="<%=isEdit?uniPrimaryAgent.getAgentPos():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>شماره ثابت:</label>
                <input class="formInput numberInput" name="agent-tele-no" maxlength="12"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?uniPrimaryAgent.getTelNo():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>موبایل:</label>
                <input class="formInput numberInput" name="agent-mobile-no" maxlength="12"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?uniPrimaryAgent.getMobileNo():""%>">
            </div>

            <div class="formItem" style="margin-right: 10px">
                <label>دورنگار:</label>
                <input class="formInput numberInput" name="agent-fax-no" maxlength="12"
                       style="width:150px;margin-left: 20px;"
                       minlength="8"
                       value="<%=isEdit?uniPrimaryAgent.getFaxNo():""%>">
            </div>

        </div>
        <div class="formRow" style="display: inline-block;width: 100%">
            <input type="submit" value="تایید" class="btn btn-primary formBtn" style="float: left;">
            <%if (isEdit) {%>
            <a href="manage-uni.jsp?sub-code=0" class="btn btn-primary formBtn"
               style="float: left;margin-left: 10px">لغو</a>
            <%} %>
        </div>
    </div>
    <%}%>
</form>
<%}%>
<%if (readSubAccess) {%>
<%}%>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>