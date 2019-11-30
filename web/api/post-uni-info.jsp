<%--suppress ALL --%>
<%@ page import="com.atrosys.dao.*"%>
<%@ page import="com.atrosys.entity.Agent"%>
<%@ page import="com.atrosys.entity.PersonalInfo"%>
<%@ page import="com.atrosys.entity.University"%>
<%@ page import="com.atrosys.model.UniInfoItem"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT, UPDATE, OPTIONS");
    response.addHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");

    request.setCharacterEncoding("UTF-8");

    StringBuilder sb = new StringBuilder();
    BufferedReader reader = request.getReader();
    try {
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append('\n');
        }
    } finally {
        reader.close();
    }


//    List<UniInfoItem> list = new Gson().fromJson(sb.toString(),new TypeToken<List<UniInfoItem>>(){}.getType());

    UniInfoItem newInfo = new Gson().fromJson(sb.toString(), UniInfoItem.class);

//    UniInfoItem oldInfo = list.get(0);
//    UniInfoItem newInfo = list.get(1);

//    University oldUni = UniversityDAO.findUniByUniNationalId(oldInfo.getUniNationalId());
//    Agent oldAgent = AgentDAO.findAgentByNationalId(oldInfo.getAgentNationalId());
//    PersonalInfo oldPerson = PersonalInfoDAO.findPersonalInfoByNationalId(oldInfo.getAgentNationalId());

    University newUni = UniversityDAO.findUniByUniNationalId(newInfo.getUniNationalId());
    Agent newAgent = AgentDAO.findAgentByNationalId(newInfo.getAgentNationalId());
    PersonalInfo newPerson = PersonalInfoDAO.findPersonalInfoByNationalId(newInfo.getAgentNationalId());

    String msg= "";

    if (StateDAO.isStateNameNew(newInfo.getState())) {
        msg="استان انتخاب شده پیدا نشد";
    } else if (CityDAO.isCityNameNew(newInfo.getCity())) {
        msg="شهر انتخاب شده پیدا نشد";
    } else if (!CityDAO.isCityInState(StateDAO.findIdByStateName(newInfo.getState()), CityDAO.findIdByCityName(newInfo.getCity()))){
        msg="در استان انتخاب شده شهری با این نام پیدا نشد";
    } else {
        newUni.setUniName(newInfo.getUniName());
        newUni.setEcoCode(newInfo.getUniEcoCode());
        newUni.setTopManagerName(newInfo.getUniTopManagerName());
        newUni.setTopManagerPos(newInfo.getUniTopManagerPos());
        newUni.setSignatoryName(newInfo.getUniSignatoryName());
        newUni.setSignatoryPos(newInfo.getUniSignatoryPos());
        newUni.setSignatoryNationalId(newInfo.getUniSignatoryNationalId());
        newUni.setStateId(StateDAO.findIdByStateName(newInfo.getState()));
        newUni.setCityId(CityDAO.findIdByCityName(newInfo.getCity()));
        newUni.setAddress(newInfo.getUniAddress());
        newUni.setPostalCode(newInfo.getUniPostalCode());
        newUni.setTeleNo(newInfo.getUniTelNo());
        newUni.setFaxNo(newInfo.getUniFaxNo());
        newUni.setSiteAddress(newInfo.getUniWebsite());
        newUni.setUniPublicEmail(newInfo.getUniEmail());

        newPerson.setFname(newInfo.getAgentFname());
        newPerson.setLname(newInfo.getAgentLname());

        newAgent.setAgentPos(newInfo.getAgentPos());
        newAgent.setTelNo(newInfo.getAgentTeleNo());
        newAgent.setMobileNo(newInfo.getAgentMobileNo());
        newAgent.setFaxNo(newInfo.getUniFaxNo());


        UniversityDAO.save(newUni);
        PersonalInfoDAO.save(newPerson);
        AgentDAO.save(newAgent);
        msg="OK";
    }


//    long id = Long.valueOf(request.getParameter("id"));
//    University university = UniversityDAO.findUniByUniNationalId(id);
//    Agent agent = AgentDAO.findUniPrimaryAgentByUniId(id);
//    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(agent.getNationalId());
//    HashMap<String,String> myResponse = new HashMap<>();
//
//    myResponse.put("uniNationalId", university.getUniNationalId().toString());
//    myResponse.put("uniName", university.getUniName());
//    myResponse.put("uniEcoCode", university.getEcoCode());
//    myResponse.put("uniTopManagerName",university.getTopManagerName());
//    myResponse.put("uniTopManagerPos", university.getTopManagerPos());
//    myResponse.put("uniSignatoryName", university.getSignatoryName());
//    myResponse.put("uniSignatoryPos", university.getSignatoryPos());
//    myResponse.put("uniSignatoryNationalId", university.getSignatoryNationalId());
//    myResponse.put("State", StateDAO.findStateNameById(university.getStateId()));
//    myResponse.put("City", CityDAO.findCityNameById(university.getCityId()));
//    myResponse.put("uniAddress", university.getAddress());
//    myResponse.put("uniPostalCode", university.getPostalCode());
//    myResponse.put("uniTelNo", university.getTeleNo());
//    myResponse.put("uniFaxNo", university.getFaxNo());
//    myResponse.put("uniWebsite", university.getSiteAddress());
//    myResponse.put("uniEmail", university.getUniPublicEmail());
//    myResponse.put("uniRequestForm","crm.nren.ir/documents/uni-request-form.jsp?id="+university.getUniNationalId());
//    myResponse.put("agentFname", personalInfo.getFname());
//    myResponse.put("agentLname", personalInfo.getLname());
//    myResponse.put("agentNationalId",personalInfo.getNationalId().toString());
//    myResponse.put("agentPos", agent.getAgentPos());
//    myResponse.put("agentTeleNo", agent.getTelNo());
//    myResponse.put("agentMobileNo", agent.getMobileNo());
//    myResponse.put("agentFaxNo", agent.getFaxNo());
//
//    if (agent.getIntroCert()!=null) {
//        myResponse.put("agentIntroLetter","crm.nren.ir/documents/primary-agent-intro-cert.jsp?id="+university.getUniNationalId());
//    }
//
//    if (university.getSubscriptionExampleForm()!=null) {
//        myResponse.put("uniSubExample","crm.nren.ir/documents/get-sub-example.jspid="+university.getUniNationalId());
//    }
//
//    if (university.getSubscriptionForm()!=null) {
//        myResponse.put("uniSubForm","crm.nren.ir/documents/get-sub-form.jsp?id="+university.getUniNationalId());
//    }
//
//    if (university.getSubscriptionFormSigned()!=null) {
//        myResponse.put("uniSubFormSigned","crm.nren.ir/documents/get-signed-sub-form.jsp?id="+university.getUniNationalId());
//    }
//
//    if(university.getSubscriptionContractNo()!=null) {
//        myResponse.put("uniSubscriptionNumber", university.getSubscriptionContractNo());
//        myResponse.put("uniSubscriptionDate", Util.convertGregorianToJalali(university.getSubscriptionContractDate()));
//    }

    String json = new Gson().toJson(msg);
    response.setContentType("application/json");
    out.print(json);
    out.flush();
%>
