<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Long reqNationalId = Long.valueOf(request.getParameter("id"));
    if (!adminSessionInfo.isAdminLogedIn()) {
        SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
        UserRoleType userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
        UniSessionInfo uniSessionInfo = new UniSessionInfo(session, userRoleType);
        if (!uniSessionInfo.isSubSystemLoggedIn()) {
            response.sendError(401);
            return;
        } else if (!uniSessionInfo.getUniversity().getUniNationalId().equals(reqNationalId)) {
            response.sendError(403);
            return;
        }
    }
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + "قرارداد-اشتراک-شعا.pdf");
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = UniversityDAO.findUniSubsExampleFormByUniNationalId(reqNationalId);
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>