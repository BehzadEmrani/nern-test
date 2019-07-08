<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Path" %>
<%@ page import="java.nio.file.Paths" %><%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline;filename=" + request.getParameter("doc"));
    ServletOutputStream servletOutputStream = response.getOutputStream();
    String docPath = request.getServletContext().getRealPath("/") + "documents/" + request.getParameter("doc")+".pdf";
    Path path = Paths.get(docPath);
    byte[] fileContents = Files.readAllBytes(path);
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>