<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    University university = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
%>
<html>
<head>
    <style type="text/css" media="print">
        @page {
            size: auto;   /* auto is the initial value */
            margin: 0;  /* this affects the margin in the printer settings */
        }
    </style>
</head>
<body style="font-family: BYekan">
<table style="margin: auto">
        <td dir="rtl">
            <%=university.getAddress()%>
        </td>
        <td dir="rtl">
            <%=university.getUniName()%>
        </td>
    </tr>
</table>
</body>
</html>