<%@ page import="com.atrosys.dao.NewsDAO" %>
<%@ page import="com.atrosys.entity.News" %>
<%@ page import="com.atrosys.model.Constants" %>
<%@ page import="com.atrosys.model.NewsDest" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    String message = null;
    ArrayList<News> newses = null;
    Integer pageNumber = null;
    Long numberOfAllRows = null;
    NewsDest dest = NewsDest.fromStr(request.getParameter("dest"));
    if (dest == null) throw new Exception("dest Not Found");
    boolean needNextPageBtn = false;
    boolean needPreviousPageBtn = false;
    try {
        String pageNoParam = request.getParameter("page_no");
        pageNumber = pageNoParam != null ? Integer.valueOf(pageNoParam) : 1;
        newses = NewsDAO.findNewssInRange((pageNumber - 1) * Constants.INFO_NEWS_PER_PAGE,
                Constants.INFO_NEWS_PER_PAGE, dest.getValue());
        numberOfAllRows = NewsDAO.getRowCount(dest.getValue());
        if (pageNumber > 1)
            needPreviousPageBtn = true;
        if (pageNumber * Constants.INFO_NEWS_PER_PAGE < numberOfAllRows)
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat 01 Dec 2001 00:00:00 GMT">
</head>
<body>
<div class="formBox">
    <h3 style="text-align: center"><%=dest.getFAStr()%></h3>

    <div id="accordion" style="bottom:0;">
        <%
            for (int i = 0; i < newses.size(); i++) {
                News news = newses.get(i);
                boolean haveImage=news.getImageURL()!=null;
                if(haveImage)
                    haveImage=!news.getImageURL().isEmpty();
        %>
        <div class="news-con panel">
            <a data-toggle="collapse" data-parent="#accordion"
               href="#collapse<%=i%>" class="news-header">
                <h3>
                    <%=news.getTitle()%>
                </h3>
                <h4>
                    <%=news.getEmphasize()%>
                </h4>
            </a>
            <div id="collapse<%=i%>" class="collapse">
                <div class="news-collapse">
                    <%if(haveImage){%>
                    <div class="col-xs-12 col-sm-4">
                        <img src="../<%=news.getImageURL()%>" style="width: 100%">
                    </div>
                    <%}%>
                    <div class="col-xs-12<%=haveImage?"col-sm-8":""%>">
                        <p><%=news.getText()%>
                        </p>
                    </div>
                </div>
            </div>

        </div>
        <%}%>
    </div>
    <div style="display: table;width: 100%;margin-top: 20px">
        <%if (needNextPageBtn) {%>
        <a href="show-doc.jsp?dest=<%=dest.getStr()%>&page_no=<%=pageNumber+1%>">
            <div style="float: right">خبر های بعدی</div>
        </a>
        <%}%>
        <%if (needPreviousPageBtn) {%>
        <a href="show-doc.jsp?dest=<%=dest.getStr()%>&page_no=<%=pageNumber-1%>">
            <div style="float: left">خبر های قبلی</div>
        </a>
        <%}%>
    </div>

</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
</body>
</html>