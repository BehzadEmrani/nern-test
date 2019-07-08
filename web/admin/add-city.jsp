<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.CityDAO" %>
<%@ page import="com.atrosys.dao.StateDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.entity.City" %>
<%@ page import="com.atrosys.entity.State" %>
<%@ page import="com.atrosys.model.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!adminSessionInfo.isAdminLogedIn()) {
        request.getRequestDispatcher("/pages/login.jsp?role=" + UserRoleType.ADMINS.getValue()).forward(request, response);
        return;
    }
    if (!AdminDAO.checkAdminAccess(session, admin.getId(), AdminAccessType.CITIES.getValue())) {
        response.sendError(403);
        return;
    } else if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.CITIES.getValue(), AdminSubAccessType.ADD.getValue())) {
        response.sendError(403);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String message = null;
    List<State> states = null;
    State sentState = null;
    boolean isStateSent = false;

    try {
        if ("send-state".equals(request.getParameter("action"))) {
            sentState = StateDAO.findStateById(Long.valueOf(request.getParameter("state-id")));
            session.setAttribute(Constants.SESSION_TEMP_STATE, sentState);
            isStateSent = true;
        } else if ("send-city".equals(request.getParameter("action"))) {
            sentState = (State) session.getAttribute(Constants.SESSION_TEMP_STATE);
            City city = new City();
            city.setCountryId((long) 98);
            city.setStateId(sentState.getStateId());
            city.setName(request.getParameter("name"));
            city.setMapCenterLat(Double.valueOf(request.getParameter("lat")));
            city.setMapCenterLng(Double.valueOf(request.getParameter("lng")));
            city.setMapZoom(Integer.valueOf(request.getParameter("zoom")));
            CityDAO.save(city);
            session.removeAttribute(Constants.SESSION_TEMP_STATE);
        }
    } catch (Exception e) {
        if (e.getMessage().equals("no-name"))
            message = "نام خالی است.";
        else if (e.getMessage().equals("repeated-name"))
            message = "نام تکراری است.";
    }

    try {
        if (isStateSent) {
            states = new LinkedList<>();
            states.add(sentState);
        } else
            states = StateDAO.findAllStates();
    } catch (Exception e) {
        message = "خطای نامشخص";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        #mapCity {
            margin: 20px auto;
            width: 420px;
            height: 260px;
            border: 1px solid #41709c;
        }

        @media screen and (max-width: 500px) {
            #mapCity {
                width: 80vw;
            }
        }

    </style>
</head>
<body>
<form id="send-city" method="post" action="add-city.jsp">
    <%if (isStateSent) {%>
    <input type="hidden" name="action" value="send-city">
    <%} else {%>
    <input type="hidden" name="action" value="send-state">
    <%}%>
    <div class="formBox">
        <h3>اضافه کردن شهر ها</h3>
        <%if (message != null) {%>
        <h3 style="color: #c00">
            <%=message%>
        </h3>
        <%}%>
        <div class="formRow" style="">
            <div class="formItem formDatePicker">
                <label>نام استان:</label>
                <select class="formSelect<%=isStateSent?" formInputDeactive":""%>" id="state-select"
                        name="state-id" style="width: 200px;">
                    <%if (!isStateSent) {%>
                    <option value="" disabled selected hidden>استان مورد نظر را انتخاب کنید&nbsp;...</option>
                    <% for (State state : states) {%>
                    <option value="<%=state.getStateId()%>">
                        <%=state.getName()%>
                    </option>
                    <%
                        }
                    } else {
                    %>
                    <option value="<%=sentState.getStateId()%>" selected>
                        <%=sentState.getName() %>
                    </option>
                    <%}%>
                </select>
            </div>
        </div>
        <%if (isStateSent) {%>
        <div class="formItem">
            <label>نام شهر :</label>
            <input class="formInput persianInput" name="name"
                   maxlength="20"
                   style="width: 200px;margin-left: 20px;"
                   type="text">
        </div>
        <div class="formRow">
            <div id="mapCity"></div>
            <input type="hidden" name="zoom" id="cityZoom">
            <input type="hidden" name="lat" id="cityCLat">
            <input type="hidden" name="lng" id="cityCLng">
        </div>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
        </div>
        <%}%>
    </div>
</form>
<div class="formBox">
    <table class="fixed-table table table-striped cityTable">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام استان</th>
            <th>نام شهر</th>
            <th>نقشه</th>
        </tr>
        </thead>
        <tbody>
        <%
            int k = 0;
            for (int i = 0; i < states.size(); i++) {
                State state = states.get(i);
                List<City> cities = CityDAO.findCitiesByStateId(state.getStateId());
                for (int j = 0; j < cities.size(); j++) {
                    City city = cities.get(j);
                    k++;
        %>
        <tr>
            <td style="width:30px">
                <%=k%>
            </td>
            <td>
                <%=state.getName()%>
            </td>
            <td>
                <%=city.getName()%>
            </td>
            <td>
                <a href="#"
                   onclick="getMapData('../map/show-map.jsp?lat=<%=city.getMapCenterLat()%>&lng=<%=city.getMapCenterLng()%>&zoom=10&name=<%=city.getName()%>')">
                    <img src="../images/map.png" style="width: 30px">
                </a>
            </td>
        </tr>
        <% }%>
        <% }%>
        </tbody>
    </table>
</div>
<!-- Modal -->
<div class="modal fade" id="mapModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <iframe src="" id="mapIframe" style="width: 100%;height: 90vh;"></iframe>
    </div>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/add-city.js"></script>
<script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script>
    document.getElementById("state-select").onchange = function () {
        document.getElementById("send-city").submit()
    };

    var map;
    function initMyMap() {
        map = new ol.Map({
            target: 'mapCity',
            key: '92c963c181a6f92a0ecf752432e6658c540c820c',
            view: new ol.View({
                center: ol.proj.fromLonLat([50.65, 35.699756]),
                zoom: 6
            })
        });
        map.setMapType('neshan');
        $("#cityCLat").val(50.65);
        $("#cityCLng").val(35.699756);
        $("#cityZoom").val(6);

        map.on('moveend', function (evt) {
            var coord = map.getView().getCenter();
            var latLonCoord = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
            var zoom = map.getView().getZoom();
            $("#cityCLat").val(latLonCoord[1]);
            $("#cityCLng").val(latLonCoord[0]);
            $("#cityZoom").val(zoom);
        });
    }
</script>
<script type="text/javascript" src="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.js?callback=initMyMap" defer
        async></script>
</body>
</html>