package com.atrosys.util;

import com.atrosys.dao.CityDAO;
import com.atrosys.dao.StateDAO;
import com.atrosys.entity.City;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by met on 5/21/18.
 * create json from city table data.
 */

public class CityExportJsonUtil {
    public static void main(String[] args) throws Exception {
        Gson gson = new Gson();
        List<CityExportJsonObject> objectList = new ArrayList<>();
        for (City city : CityDAO.findAllCities()) {
            CityExportJsonObject object = new CityExportJsonObject();
            object.setCityId(city.getCityId());
            object.setMapCenterLat(city.getMapCenterLat());
            object.setMapCenterLng(city.getMapCenterLng());
            object.setMapZoom(city.getMapZoom());
            object.setName(city.getName());
            object.setStateName(StateDAO.findStateById(city.getStateId()).getName());
            objectList.add(object);
        }
        System.out.println(gson.toJson(objectList));
    }

    private static class CityExportJsonObject {
        private Long cityId;
        private String stateName;
        private String name;
        private Double mapCenterLat;
        private Double mapCenterLng;
        private Integer mapZoom;

        public Long getCityId() {
            return cityId;
        }

        public void setCityId(Long cityId) {
            this.cityId = cityId;
        }

        public String getStateName() {
            return stateName;
        }

        public void setStateName(String stateName) {
            this.stateName = stateName;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public Double getMapCenterLat() {
            return mapCenterLat;
        }

        public void setMapCenterLat(Double mapCenterLat) {
            this.mapCenterLat = mapCenterLat;
        }

        public Double getMapCenterLng() {
            return mapCenterLng;
        }

        public void setMapCenterLng(Double mapCenterLng) {
            this.mapCenterLng = mapCenterLng;
        }

        public Integer getMapZoom() {
            return mapZoom;
        }

        public void setMapZoom(Integer mapZoom) {
            this.mapZoom = mapZoom;
        }

    }
}