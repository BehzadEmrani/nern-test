<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + "قرارداد-اشتراک-شعا.pdf");
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = UniversityDAO.findUniSubSignedFormByUniNationalId(Long.valueOf(request.getParameter("id")));
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>