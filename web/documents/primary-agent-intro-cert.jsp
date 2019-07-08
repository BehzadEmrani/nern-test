<%@ page import="com.atrosys.dao.AgentDAO" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    if (!adminSessionInfo.isLogedIn()) {
        response.sendError(403);
        try {

            request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return;
    }
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + "نماینده-اصلی.pdf");
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = AgentDAO.findUniPrimaryAgentByUniId(Long.valueOf(request.getParameter("id"))).getIntroCert();
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>