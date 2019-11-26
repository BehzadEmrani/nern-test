<%@ page import="com.atrosys.dao.*"%>
<%@ page import="com.atrosys.entity.*"%>
<%@ page import="com.atrosys.model.UniStatus"%>
<%@ page import="com.atrosys.model.UniStatusLogItem"%>
<%@ page import="com.atrosys.model.UniSubStatus"%>
<%@ page import="com.atrosys.util.Util" %>
<%@ page import="com.google.gson.Gson"%><%@ page import="java.util.Date"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");



    List<UniStatusLog> uniStatusLogs = UniStatusLogDAO.findUniStatusLogByUniNationalId(Long.valueOf(request.getParameter("id")));
    List<UniStatusLogItem> myResponse = new LinkedList<>();
    UniStatusLogItem responseItem;

    for (UniStatusLog data:uniStatusLogs ) {
        responseItem = new UniStatusLogItem();
        responseItem.setDate(Util.convertGregorianToJalali(new Date(data.getTimeStamp().getTime())));
        if (data.getApprovalId()!=null) {
            University operatorUni = UniversityDAO.findUniByUniNationalId(data.getApprovalId());
            responseItem.setApproval(operatorUni.getUniName() + " (" + operatorUni.getUniNationalId() + ")");
        }else if(data.getApprovalAdminId()!=null) {
            Admin admin = AdminDAO.findAdminByid(data.getApprovalAdminId());
            UserRole role = UserRoleDAO.findUserRoleById(admin.getRoleId());
            PersonalInfo info = PersonalInfoDAO.findPersonalInfoByNationalId(role.getNationalId());
            responseItem.setApproval(info.combineName() + " (" + info.getUsername() + ")");
        } else {
            responseItem.setApproval("نامشخص");
        }

        if (data.getUniStatus()!=null){
            responseItem.setUniStatus(UniStatus.fromValue(data.getUniStatus()).getFaStr());
        }
        if (data.getUniSubStatus()!=null) {
            responseItem.setUniSubStatus(UniSubStatus.fromValue(data.getUniSubStatus()).getFaStr());
        }
        responseItem.setUniNationalId(data.getUniNationalId().toString());
        responseItem.setMessage(data.getMessage());

        myResponse.add(responseItem);
    }

    String json = new Gson().toJson(myResponse);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
