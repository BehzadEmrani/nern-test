<%@ page import="com.atrosys.dao.EquipmentDAO" %>
<%@ page import="com.atrosys.dao.EquipmentTypeDAO" %>
<%@ page import="com.atrosys.entity.Equipment"%>
<%@ page import="com.atrosys.entity.EquipmentType"%><%@ page import="com.atrosys.model.EquipmentInstallResponse"%><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    request.setCharacterEncoding("UTF-8");
    List<Equipment> equipmentList = EquipmentDAO.findAllEquipmentsCanInstallByTelecomId(
            Long.valueOf(request.getParameter("telecom-id")));
    List<EquipmentInstallResponse> responses=new LinkedList<>();
    for (Equipment equipment :equipmentList ) {
        EquipmentInstallResponse installResponse=new EquipmentInstallResponse();
        installResponse.setEquipmentId(equipment.getId());
        installResponse.setEquipmentName(equipment.getEquipmentShoaNo()+"["+equipment.getSerialNo()+"]");
        EquipmentType equipmentType=EquipmentTypeDAO.findEquipmentTypeById(equipment.getEquipmentTypeId());
        installResponse.setEquipmentTypeId(equipmentType.getId());
        installResponse.setEquipmentTypeName(equipmentType.getName()+"["+equipmentType.getPartNumber()+"]");
        responses.add(installResponse);
    }
    String json = new Gson().toJson(responses);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
