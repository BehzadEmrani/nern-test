<%@ page import="com.atrosys.dao.InfoDocDAO" %>
<%@ page import="com.atrosys.entity.InfoDoc" %>
<%@ page import="com.atrosys.model.Constants" %>
<%@ page import="com.atrosys.model.InfoDocDest" %>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    String message = null;
    ArrayList<InfoDoc> infoDocs = null;
    Integer pageNumber = null;
    Long numberOfAllRows = null;
    InfoDocDest dest = InfoDocDest.fromStr(request.getParameter("dest"));
    if (dest == null) throw new Exception("dest Not Found");
    boolean needNextPageBtn = false;
    boolean needPreviousPageBtn = false;
    try {
        String pageNoParam = request.getParameter("page_no");
        pageNumber = pageNoParam != null ? Integer.valueOf(pageNoParam) : 1;
        infoDocs = InfoDocDAO.findInfoDocsInRange((pageNumber - 1) * Constants.INFO_DOC_PER_PAGE,
                Constants.INFO_DOC_PER_PAGE, dest.getValue());
        numberOfAllRows = InfoDocDAO.getRowCount(dest.getValue());
        if (pageNumber > 1)
            needPreviousPageBtn = true;
        if (pageNumber * Constants.INFO_DOC_PER_PAGE < numberOfAllRows)
            needNextPageBtn = true;
    } catch (Exception e) {
        message = "خطای نامشخص!";
    }
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
    <h3 style="text-align: center">مقالات و مستندات</h3>
    <table class="formTable" style="width:100%;font-size: 9pt;">
        <tr>
            <th style="width: 7.5%">ردیف</th>
            <th style="width: 13%">تاریخ انتشار</th>
            <th style="width: 18%">موضوع</th>
            <th style="width: 13%">صاحب اثر</th>
            <th style="width: 13%">نویسنده/مترجم</th>
            <th style="width: 28%">شرح مختصر</th>
            <th style="width: 7.5%">دانلود</th>
        </tr>
        <%
            if (infoDocs != null) for (InfoDoc infoDoc : infoDocs) {
                String docURL = infoDoc.getFileURL();
                String docName = infoDoc.getFileURL().substring(docURL.lastIndexOf("/") + 1, docURL.lastIndexOf('.'));
        %>
        <tr>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%=(pageNumber - 1) * Constants.INFO_DOC_PER_PAGE + infoDocs.indexOf(infoDoc) + 1%>
                </a>
            </td>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%
                        Date date = new Date(
                                infoDoc.getPubDate().getYear()
                                , infoDoc.getPubDate().getMonth()
                                , infoDoc.getPubDate().getDate());
                    %>
                    <%=Util.convertGregorianToJalali(date)%>
                </a>
            </td>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%=infoDoc.getTitle()%>
                </a>
            </td>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%=infoDoc.getOwner()%>
                </a>
            </td>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%=infoDoc.getWriter()%>
                </a>
            </td>
            <td>
                <a target="_blank" href="view-doc.jsp?doc=<%=docName%>">
                    <%=infoDoc.getDescription()%>
                </a>
            </td>
            <td>
                <a href="../<%=infoDoc.getFileURL()%>" download="<%=infoDoc.getTitle()+".pdf"%>">
                    <img src="../images/pdf-icon.png" style="width: 20px;">
                </a>
            </td>
        </tr>
        <%}%>
    </table>
    <div style="display: table;width: 100%;margin-top: 20px">
        <%if (needNextPageBtn) {%>
        <a href="show-doc.jsp?dest=<%=dest.getStr()%>&page_no=<%=pageNumber+1%>">
            <div style="float: right">مقالات بعدی</div>
        </a>
        <%}%>
        <%if (needPreviousPageBtn) {%>
        <a href="show-doc.jsp?dest=<%=dest.getStr()%>&page_no=<%=pageNumber-1%>">
            <div style="float: left">مقالات قبلی</div>
        </a>
        <%}%>
    </div>

</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>