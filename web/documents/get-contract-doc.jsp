<%@ page import="com.atrosys.dao.ContractDocDAO" %>
<%@ page import="com.atrosys.entity.ContractDoc" %>
<%
    ContractDoc contractDoc = ContractDocDAO.findContractDocById(Long.valueOf(request.getParameter("id")));
    response.setContentType("application/" + contractDoc.getExtension());
    response.setHeader("Content-Disposition", "inline;filename=" + contractDoc.getTitle() + "." + contractDoc.getExtension());
    ServletOutputStream servletOutputStream = response.getOutputStream();
    byte[] fileContents = contractDoc.getDocument();
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>