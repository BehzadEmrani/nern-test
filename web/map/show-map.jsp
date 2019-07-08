<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
    <style>
        #mapShowCon {
            position: inherit !important;
            height: 100%;
            width: 100%;
        }

        #marker {
            text-decoration: none;
            color: white;
            font-size: 11pt;
            font-weight: bold;
            text-shadow: black 0.1em 0.1em 0.2em;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
</head>database
<body>
<div id="mapShowCon"></div>
<span class="overlay" id="vienna" target="_blank" href="http://en.wikipedia.org/wiki/Vienna"><%=request.getParameter("name")%></span>
<script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script type="text/javascript" src="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.js?callback=initMyMap" defer
        async></script>
<script>
    var lat = Number("<%=request.getParameter("lat")%>");
    var lng = Number("<%=request.getParameter("lng")%>");
    var zoom = <%=request.getParameter("zoom")%>;
    function initMyMap() {
        map1 = new ol.Map({
            target: 'mapShowCon',
            key: '92c963c181a6f92a0ecf752432e6658c540c820c',
            view: new ol.View({
                center: ol.proj.fromLonLat([lng, lat]),
                zoom: zoom
            })
        });
        map1.setMapType('neshan');


        // marker
        var lonLat = new OpenLayers.LonLat(lng, lat);
        alert("1");
        var marker = new Overlay({
            position: lonLat,
            element: document.getElementById('marker')
        });
        map1.addOverlay(marker);
    }
</script>
</body>
</html>
