<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.Agent" %>
<%@ page import="com.atrosys.entity.PersonalInfo" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    Long targetUniId = Long.valueOf(request.getParameter("id"));

    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();

    if (!adminSessionInfo.isLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;

    University university = UniversityDAO.findUniByUniNationalId(targetUniId);
%>
<h3>
    مشخصات کلی
    <a href="manage-uni-info.jsp?action=edit-uni&uni-national-id=<%=university.getUniNationalId()%>&editType=main-info">
        <img src="../images/edit.png" style="width: 30px">
    </a>
</h3>
<span>شناسه ملی:<%=university.getUniNationalId()%></span>
<span>نام اصلی:<%=university.getUniName()%></span>
<span>کد اقتصادی:<%=university.getEcoCode()%></span>
<br>
<%if (university.getSubscriptionContractNo() != null) {%>
<span>شماره اشتراک:<%=university.getSubscriptionContractNo()%></span>
<span>تاریخ اشتراک:<%=Util.convertGregorianToJalali(university.getSubscriptionContractDate())%></span>
<%}%>
<h3>
    مشخصات مدیران
    <a href="manage-uni-info.jsp?action=edit-uni&uni-national-id=<%=university.getUniNationalId()%>&editType=management-info">
        <img src="../images/edit.png" style="width: 30px">
    </a>
</h3>
<span>بالاترین مقام:<%=university.getTopManagerName()%></span>
<span>سمت:<%=university.getTopManagerPos()%></span>
<span>مقام مجاز امضاء:<%=university.getSignatoryName()%></span>
<span>سمت:<%=university.getSignatoryPos()%></span>
<span> کد ملی:<%=university.getSignatoryNationalId()%></span>
<h3>
    نشانی
    <a href="manage-uni-info.jsp?action=edit-uni&uni-national-id=<%=university.getUniNationalId()%>&editType=address-info">
        <img src="../images/edit.png" style="width: 30px">
    </a>
</h3>
<span> استان:<%=StateDAO.findStateNameById(university.getStateId())%></span>
<span> شهر:<%=CityDAO.findCityNameById(university.getCityId())%></span>
<span> آدرس کامل:<%=university.getAddress()%></span>
<span> کد پستی:<%=university.getPostalCode()%></span>
<span> تلفن:<%=university.getTeleNo()%></span>
<span> دورنگار:<%=university.getFaxNo()%></span>
<span> وبسایت:<%=university.getSiteAddress()%></span>
<span>پست الکترونیکی عمومی:<%=university.getUniPublicEmail()%></span>
<h3>فایل ها</h3>

<span>                                فرم درخواست عضویت:
    <a href="../documents/uni-request-form.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
    </span>
<%if (university.getSubscriptionExampleForm() != null) {%>
<span>                                فرم نمونه اشتراک:
    <a href="../documents/get-sub-example.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
    </span>
<%}%>
<br>
<% if (university.getSubscriptionForm() != null) { %>
<span>                                فرم اشتراک امضا شده توسط مشترک:
    <a href="../documents/get-sub-form.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
    </span>
<%
    }
    if (university.getSubscriptionFormSigned() != null) {
%>
<span>                                فرم اشتراک امضا شده توسط طرفین:
    <a href="../documents/get-signed-sub-form.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
    </span>
<%
    }
    Agent primaryAgent = AgentDAO.findUniPrimaryAgentByUniId(university.getUniNationalId());
    PersonalInfo primaryPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(primaryAgent.getNationalId());
%>
<h3>
    مشخصات نماینده تام الاختیار
    <a href="manage-uni-info.jsp?action=edit-uni&uni-national-id=<%=university.getUniNationalId()%>&editType=agent-info">
        <img src="../images/edit.png" style="width: 30px">
    </a>
</h3>
<span> نام:<%=primaryPersonalInfo.getFname()%></span>
<span> نام خانوادگی:<%=primaryPersonalInfo.getLname()%></span>
<span> کد ملی:<%=primaryPersonalInfo.getNationalId()%></span>
<span> سمت:<%=primaryAgent.getAgentPos()%></span>
<br>
<span> شماره ثابت:<%=primaryAgent.getTelNo()%></span>
<span> موبایل:<%=primaryAgent.getMobileNo()%></span>
<span> دورنگار:<%=primaryAgent.getFaxNo()%></span>
<%if (primaryAgent.getIntroCert() != null) {%>
<span>                                فرم معرفی نماینده:
    <a href="../documents/primary-agent-intro-cert.jsp?id=<%=university.getUniNationalId()%>"
       target="_blank">
        <img src="../images/pdf-icon.png" style="width: 30px">
    </a>
</span>
<%}%>
