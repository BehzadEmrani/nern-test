<%@ page import="com.atrosys.dao.*"%>
<%@ page import="com.atrosys.entity.Agent"%>
<%@ page import="com.atrosys.entity.PersonalInfo"%>
<%@ page import="com.atrosys.entity.University"%>
<%@ page import="com.atrosys.util.Util"%><%@ page import="com.google.gson.Gson"%><%@ page import="java.util.HashMap"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");


    long id = Long.valueOf(request.getParameter("id"));
    University university = UniversityDAO.findUniByUniNationalId(id);
    Agent agent = AgentDAO.findUniPrimaryAgentByUniId(id);
    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(agent.getNationalId());
    HashMap<String,String> myResponse = new HashMap<>();

    myResponse.put("uniNationalId", university.getUniNationalId().toString());
    myResponse.put("uniName", university.getUniName());
    myResponse.put("uniEcoCode", university.getEcoCode());
    myResponse.put("uniTopManagerName",university.getTopManagerName());
    myResponse.put("uniTopManagerPos", university.getTopManagerPos());
    myResponse.put("uniSignatoryName", university.getSignatoryName());
    myResponse.put("uniSignatoryPos", university.getSignatoryPos());
    myResponse.put("uniSignatoryNationalId", university.getSignatoryNationalId());
    myResponse.put("State", StateDAO.findStateNameById(university.getStateId()));
    myResponse.put("City", CityDAO.findCityNameById(university.getCityId()));
    myResponse.put("uniAddress", university.getAddress());
    myResponse.put("uniPostalCode", university.getPostalCode());
    myResponse.put("uniTelNo", university.getTeleNo());
    myResponse.put("uniFaxNo", university.getFaxNo());
    myResponse.put("uniWebsite", university.getSiteAddress());
    myResponse.put("uniEmail", university.getUniPublicEmail());
    myResponse.put("uniRequestForm","crm.nren.ir/documents/uni-request-form.jsp?id="+university.getUniNationalId());
    myResponse.put("agentFname", personalInfo.getFname());
    myResponse.put("agentLname", personalInfo.getLname());
    myResponse.put("agentNationalId",personalInfo.getNationalId().toString());
    myResponse.put("agentPos", agent.getAgentPos());
    myResponse.put("agentTeleNo", agent.getTelNo());
    myResponse.put("agentMobileNo", agent.getMobileNo());
    myResponse.put("agentFaxNo", agent.getFaxNo());

    if (agent.getIntroCert()!=null) {
        myResponse.put("agentIntroLetter","crm.nren.ir/documents/primary-agent-intro-cert.jsp?id="+university.getUniNationalId());
    }

    if (university.getSubscriptionExampleForm()!=null) {
        myResponse.put("uniSubExample","crm.nren.ir/documents/get-sub-example.jspid="+university.getUniNationalId());
    }

    if (university.getSubscriptionForm()!=null) {
        myResponse.put("uniSubForm","crm.nren.ir/documents/get-sub-form.jsp?id="+university.getUniNationalId());
    }

    if (university.getSubscriptionFormSigned()!=null) {
        myResponse.put("uniSubFormSigned","crm.nren.ir/documents/get-signed-sub-form.jsp?id="+university.getUniNationalId());
    }

    if(university.getSubscriptionContractNo()!=null) {
        myResponse.put("uniSubscriptionNumber", university.getSubscriptionContractNo());
        myResponse.put("uniSubscriptionDate", Util.convertGregorianToJalali(university.getSubscriptionContractDate()));
    }

    String json = new Gson().toJson(myResponse);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
