<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.entity.University" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    University targetUniversity = UniversityDAO.findUniByUniNationalId(Long.valueOf(request.getParameter("id")));
    String message = null;

%>
<html>
<head>
    <title></title>
    <style>
        .mapShow {
            position: inherit !important;
            width: 100%;
            height:100%;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
</head>
<body>
<div class="mapShow" lat="<%=targetUniversity.getMapLocLat()%>" lng="<%=targetUniversity.getMapLocLng()%>"></div>
<script src="../js/script.js"></script>
<script src="/js/jquery.min.js"></script>
<script type="text/javascript" src="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.js?callback=initMaps" defer async></script>
</body>
</html>
