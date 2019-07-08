<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    if (!adminSessionInfo.isLogedIn()) {
        response.sendError(403);
        try {

        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        }catch (Exception e){
            e.printStackTrace();
        }
        return;
    }
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + "قرارداد-اشتراک-شعا.pdf");
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = UniversityDAO.findUniSubsFormByUniNationalId(Long.valueOf(request.getParameter("id")));
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>