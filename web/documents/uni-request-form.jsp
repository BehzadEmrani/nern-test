<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + request.getParameter("doc"));
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = UniversityDAO.findUniRequestFormByUniNationalId(Long.valueOf(request.getParameter("id")));
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>