<%@ page import="com.atrosys.entity.University" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UniStatus" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, UserRoleType.fromSubSystemCode(subSystemCode));
    University university = uniSessionInfo.getUniversity();
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.fromSubSystemCode(subSystemCode)).forward(request, response);
        return;
    }
    if (university.getUniStatus() < UniStatus.SUBSCRIBE_PAGE.getValue()) {
        response.sendError(403);
        return;
    }
//    Integer pageNumber = null;
//    Long numberOfAllRows = null;
//    boolean needNextPageBtn = false;
//    boolean needPreviousPageBtn = false;
//    String pageNoParam = request.getParameter("page_no");
//    pageNumber = pageNoParam != null ? Integer.valueOf(pageNoParam) : 1;
//    List<ContractDoc> contractDocs = ContractDocDAO.findContractDocsInRange((pageNumber - 1) * Constants.CONTRACT_DOC_PER_PAGE, Constants.CONTRACT_DOC_PER_PAGE);
//    numberOfAllRows = ContractDocDAO.getCount();
//    if (pageNumber > 1)
//        needPreviousPageBtn = true;
//    if (pageNumber * Constants.CONTRACT_DOC_PER_PAGE < numberOfAllRows)
//        needNextPageBtn = true;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
</head>
<body>
<div class="formBox">
    <h3 style="text-align: center">نامه های ارسالی</h3>
    <table class="formTable" style="width:100%;font-size: 9pt;">
        <tr>
            <th style="width: 7.5%">ردیف</th>
            <th style="width: 18%">موضوع</th>
            <th style="width: 28%">شرح مختصر</th>
            <th style="width: 7.5%">دانلود</th>
        </tr>
        <%--<%--%>
        <%--for (int i = 0; i < contractDocs.size(); i++) {--%>
        <%--ContractDoc tableContractDoc = contractDocs.get(i);--%>
        <%--%>--%>
        <%--<tr>--%>
        <%--<td>--%>
        <%--<%=(pageNumber - 1) * Constants.INFO_DOC_PER_PAGE + i + 1%>--%>
        <%--</td>--%>
        <%--<td>--%>

        <%--<%=tableContractDoc.getTitle()%>--%>
        <%--</td>--%>
        <%--<td>--%>

        <%--<%=tableContractDoc.getDescription()%>--%>
        <%--</td>--%>
        <%--<td>--%>
        <%--<a href="../documents/get-contract-doc.jsp?id=<%=tableContractDoc.getId()%>">--%>
        <%--<img src="../images/pdf-icon.png" style="width: 20px;">--%>
        <%--</a>--%>
        <%--</td>--%>
        <%--</tr>--%>
        <%--<%}%>--%>
    </table>
    <div style="display: table;width: 100%;margin-top: 20px">
        <%--<%if (needNextPageBtn) {%>--%>
        <%--<a href="show-contract-doc.jsp?page_no=<%=pageNumber+1%>">--%>
        <%--<div style="float: right">مقالات بعدی</div>--%>
        <%--</a>--%>
        <%--<%}%>--%>
        <%--<%if (needPreviousPageBtn) {%>--%>
        <%--<a href="show-contract-doc.jsp?page_no=<%=pageNumber-1%>">--%>
        <%--<div style="float: left">مقالات قبلی</div>--%>
        <%--</a>--%>
        <%--<%}%>--%>
    </div>

</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>