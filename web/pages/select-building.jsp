<%@ page import="com.atrosys.dao.ServiceFormParameterDAO" %>
<%@ page import="com.atrosys.dao.ServiceFormRequestDAO" %>
<%@ page import="com.atrosys.dao.SubsBuildingDAO" %>
<%@ page import="com.atrosys.entity.ServiceFormParameter" %>
<%@ page import="com.atrosys.entity.ServiceFormRequest" %>
<%@ page import="com.atrosys.entity.SubsBuilding" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    UserRoleType userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, userRoleType);
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        response.sendError(401);
        return;
    }
    University university = uniSessionInfo.getUniversity();
    UniStatus uniStatus = UniStatus.fromValue(university.getUniStatus());
    if (uniStatus.getValue() <= UniStatus.PRIMARY_AGENT_REGISTER.getValue()) {
        response.sendError(403);
        return;
    }

    boolean isBuildingSend = "send-building".equals(request.getParameter("action"));

    if(isBuildingSend){
        ServiceFormRequest serviceFormRequest=new ServiceFormRequest();
        serviceFormRequest.setStatusVal(ServiceFormRequestStatus.WAIT_FOR_SUBS_SIGNING.getValue());
        serviceFormRequest.setSubscriptionContractNo(university.getSubscriptionContractNo());
        serviceFormRequest.setSubscriptionDate(university.getSubscriptionContractDate());
        serviceFormRequest.setServiceFormContractNo(null);
        serviceFormRequest.setServiceFormContractDate(new java.sql.Date(new Date().getTime()));
        serviceFormRequest.setServiceFormParameterId(Long.valueOf(request.getParameter("service-form-parameter-id")));
        serviceFormRequest.setSubsBuildingId(Long.valueOf(request.getParameter("building-id")));
        serviceFormRequest.setUniId(university.getUniNationalId());
        ServiceFormRequestDAO.save(serviceFormRequest);
        request.getRequestDispatcher("requested-service-form.jsp?sub-code="+subSystemCode.getValue()).forward(request, response);
        return;
    }

    ServiceFormParameter serviceFormParameter = ServiceFormParameterDAO.findServiceFormParameterById(
            Long.valueOf(request.getParameter("service-form-parameter-id")));
    List<SubsBuilding> subsBuildingList = SubsBuildingDAO.findSubsBuildingsByUniId(university.getUniNationalId());
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
<div class="formBox">
    <form>
        <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
        <input type="hidden" name="action" value="send-building">
        <input type="hidden" name="service-form-parameter-id" value="<%=serviceFormParameter.getId()%>">
        <h3>انتخاب ساختمان</h3>
        <div class="formRow">
            <div class="formItem">
                <label>نام ساختمان:</label>
                <select id="building-select" name="building-id">
                    <% for (SubsBuilding subsBuilding : subsBuildingList) { %>
                    <option value="<%=subsBuilding.getId()%>"><%=subsBuilding.getBuildingName()%>
                    </option>
                    <%}%>
                </select>
            </div>
            <br>
            <p style="color: #c00">
                ساختمان های خود را در بخش تعریف ساختمان ثبت کنید.
            </p>
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
    </form>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/select-building.js"></script>
</body>
</html>