<%@ page import="com.atrosys.dao.CityDAO" %>
<%@ page import="com.atrosys.entity.City" %>
<%@ page import="com.atrosys.model.CityResponse" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
 response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    request.setCharacterEncoding("UTF-8");
    List<City> cities = CityDAO.findCitiesByStateId(Long.valueOf(request.getParameter("state-id")));
    LinkedList<CityResponse> cityResponses = new LinkedList<>();
    for (City city : cities) {
        CityResponse cityResponse = new CityResponse();
        cityResponse.setCityId(city.getCityId());
        cityResponse.setName(city.getName());
        cityResponse.setLat(city.getMapCenterLat());
        cityResponse.setLng(city.getMapCenterLng());
        cityResponse.setZoom(city.getMapZoom());
        cityResponses.add(cityResponse);
    }
    String json = new Gson().toJson(cityResponses);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
