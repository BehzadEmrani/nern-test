<%@ page import="com.atrosys.dao.ServiceFormRequestDAO" %>
<%@ page import="com.atrosys.entity.ServiceFormRequest" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.ServiceFormRequestDocType" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%
    ServiceFormRequestDocType docType = ServiceFormRequestDocType.fromValue(Integer.valueOf(request.getParameter("type")));
    ServiceFormRequest serviceFormRequest = null;
    if (docType.getValue() >= 0 && docType.getValue() < 1000)
        serviceFormRequest = ServiceFormRequestDAO.findServiceFormRequestById(Long.valueOf(request.getParameter("id")));
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + docType.getFaStr() + ".pdf");
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = null;

    String subCodeStr = request.getParameter("sub-code");
    University university=null;
    if (subCodeStr != null&&!subCodeStr.equals("null")) {
        SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(subCodeStr));
        UserRoleType roleType = UserRoleType.fromSubSystemCode(subSystemCode);
        UniSessionInfo sessionInfo = new UniSessionInfo(session, roleType);
        university=sessionInfo.getUniversity();
    }
    switch (docType) {
        case LETTER:
            fileContents = serviceFormRequest.getLetter();
            break;
        case POST_RECEIPT:
            fileContents = serviceFormRequest.getPostReceipt();
            break;
        case SIGNED_FORM:
            fileContents = serviceFormRequest.getSignedForm();
            break;
        case FINAL_SIGNED_FORM:
            fileContents = serviceFormRequest.getFinalSignedForm();
            break;
        case SUBS_LETTER:
            fileContents = university.getSubscriptionLetter();
            break;
        case SUBS_POST_RECEIPT:
            fileContents = university.getSubscriptionPostTicket();
            break;
        case SUBS_SIGNED:
            fileContents = university.getSubscriptionFormSigned();
            break;
        case SUBS_FINAL:
            fileContents = university.getSubscriptionForm();
            break;
    }
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>