<%@ page import="com.atrosys.dao.AdminDAO"%>
<%@ page import="com.atrosys.dao.AdminStateListRoleDAO"%>
<%@ page import="com.atrosys.dao.UniversityDAO"%>
<%@ page import="com.atrosys.dao.UserRoleDAO"%>
<%@ page import="com.atrosys.entity.Admin"%><%@ page import="com.atrosys.entity.AdminStateListRole"%><%@ page import="com.atrosys.model.SubSystemCode"%><%@ page import="com.atrosys.model.UniApiRecord"%><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.LinkedList"%><%@ page import="java.util.List"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");
    SubSystemCode subSystemCode;
    if (request.getParameter("sub-code") != null) {
        subSystemCode = SubSystemCode.fromValue(Integer.parseInt(request.getParameter("sub-code")));
    } else {
        subSystemCode = null;
    }
    List<UniApiRecord> tableRecords = new LinkedList<>();

    if(request.getParameter("id")==null) {
        if (subSystemCode == null) {
            response.sendError(404);
        } else {
            tableRecords = UniversityDAO.filterApiResponse(subSystemCode.getValue(), -1, (long) -1);
        }
    } else {
        long id = Long.parseLong(request.getParameter("id"));
        Admin admin = AdminDAO.findAdminByRoleId(UserRoleDAO.findUserRolesByNationalId(id).get(0).getRoleId());
        List<AdminStateListRole> listRoles = AdminStateListRoleDAO.findAdminStateListRoleByAdminId(admin.getId());
        for (AdminStateListRole stateRole: listRoles) {
            int subCode;
            if (subSystemCode == null) {
                subCode = -1;
            } else {
                subCode = subSystemCode.getValue();
            }
            List<UniApiRecord> stateRecords = UniversityDAO.filterApiResponse(subCode, -1, stateRole.getStateId());
            tableRecords.addAll(stateRecords);
        }
    }


    String json = new Gson().toJson(tableRecords);
    response.setContentType("application/json");
    out.print(json);
    out.flush();

%>
