<%@ page import="com.atrosys.dao.CountryDAO" %>
<%@ page import="com.atrosys.dao.WorldNrenDAO" %>
<%@ page import="com.atrosys.entity.Country" %>
<%@ page import="com.atrosys.entity.WorldNren" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    String message = null;
    ArrayList<WorldNren> worldNrens = null;
    ArrayList<Country> countries = null;
    try {
        countries = CountryDAO.findAllCountries();
    } catch (Exception e) {
        message = "خطای نامشخص";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="ammap/ammap.css" type="text/css" media="all"/>
</head>
<body>
<div class="formBox" style="font-size: 13pt;text-align: justify">
    <h3 style="text-align: center">گستره ی جهانی</h3>
    <div id="mapdiv"
         style="width: 90vw; max-width: 1080px;height: 60vw;max-height: 800px;margin:auto;background: #ffffff"></div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="../js/script.js"></script>
<script src="ammap/ammap.js"></script>
<script type="text/javascript">
    var areasInfo = [<%
    for(int i = 0; i < countries.size(); i++)  {
        Country country =countries.get(i);
        WorldNren worldNren=WorldNrenDAO.findNrenByCountryId(country.getCountryId());
        String countryDescHTML="";
        if(worldNren!=null){
            if(worldNren.getImageURL()!=null)
                if(!worldNren.getImageURL().isEmpty())
                 countryDescHTML+=String.format( "<img class='nrenMapImage' src='%s'/>"
                ,"../"+ worldNren.getImageURL());
             countryDescHTML+=  String.format(  "<p class='nrenMapName'>نام شبکه علمی : %s </p>",
            worldNren.getNernName());
            if(!worldNren.getSiteURL().isEmpty())
               countryDescHTML+= String.format(    "<p class='nrenMapUrl' >آدرس سایت:<a href='http://%s' target='_blank'>%s</a></p>",
                  worldNren.getSiteURL(),worldNren.getSiteURL());
            String nrenDesc=worldNren.getDescription();
            if(!nrenDesc.isEmpty())
              countryDescHTML+=String.format("<p class='nrenMapDesc'>%s</p>",worldNren.getDescription()  );
        }else{
                 countryDescHTML+=String.format( "<img class='nrenMapImage' src='%s'/>"
                ,"../images/nrens/no-nren.png");
        }
        %>
        {
            "id": "<%=country.getCountryId()%>",
            "description": "<%=countryDescHTML%>"
        }
        <%=i!= countries.size()-1?",\n":""%>
        <%}%>
    ]
    var map = AmCharts.makeChart("mapdiv", {
        "type": "map",
        "dataProvider": {
            "mapURL": "../map/worldLow-persian.svg",
            "getAreasFromMap": true,
            "areas": areasInfo
        },
        "smallMap": {},
        "areasSettings": {
            "autoZoom": true,
            "selectedColor": "#9abfe5"
        }
    });
</script>
</body>
</html>