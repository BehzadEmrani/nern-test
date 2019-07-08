<%@ page import="com.atrosys.model.Constants" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
</head>
<body style="width: 100vw;height: 100vh;margin: 0;padding: 0;">
<iframe style="width: 100%;height: 100%;" src="../documents/ViewerJS/#<%=Constants.WEB_APP_ROOT%>documents/pdf.jsp?doc=<%=request.getParameter("doc")%>"></iframe>
</body>
</html>