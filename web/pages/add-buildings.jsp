<%@ page import="com.atrosys.dao.*" %>
<%@ page import="com.atrosys.entity.*" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page import="com.atrosys.model.UniSessionInfo" %>
<%@ page import="com.atrosys.model.UniStatus" %>
<%@ page import="com.atrosys.model.UserRoleType" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    UserRoleType userRoleType = UserRoleType.fromSubSystemCode(subSystemCode);
    UniSessionInfo uniSessionInfo = new UniSessionInfo(session, userRoleType);
    if (!uniSessionInfo.isSubSystemLoggedIn()) {
        response.sendError(401);
        return;
    }
    University university = uniSessionInfo.getUniversity();
    UniStatus uniStatus = UniStatus.fromValue(university.getUniStatus());
    if (uniStatus.getValue() <UniStatus.REGISTER_COMPLETED.getValue()) {
        response.sendError(403);
        return;
    }

    Agent primaryAgent = AgentDAO.findUniPrimaryAgentByUniId(university.getUniNationalId());
    primaryAgent.setIntroCert(null);
    PersonalInfo personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(primaryAgent.getNationalId());
    String primaryAgentJson = new Gson().toJson(primaryAgent).replaceAll("\"", "'");
    String personalInfoJson = new Gson().toJson(personalInfo).replaceAll("\"", "'");

    SubsBuilding changingSubsBuilding = null;

    boolean isEdit = "edit".equals(request.getParameter("action"));
    boolean isSendEdit = "edit-building".equals(request.getParameter("action"));
    boolean isSendNew = "send-building".equals(request.getParameter("action"));
    boolean isSendRemove = "delete".equals(request.getParameter("action"));


    if (isEdit || isSendEdit || isSendRemove)
        changingSubsBuilding = SubsBuildingDAO.findSubsBuildingById(
                Long.valueOf(request.getParameter("id")));

    if (isSendRemove)
        SubsBuildingDAO.delete(changingSubsBuilding.getId());

    if (isSendNew || isSendEdit) {
        if (isSendNew)
            changingSubsBuilding = new SubsBuilding();
        changingSubsBuilding.setBuildingName(request.getParameter("building-name"));
        changingSubsBuilding.setCityId(Long.valueOf(request.getParameter("city-id")));
        changingSubsBuilding.setAddress(request.getParameter("address"));
        changingSubsBuilding.setPostalCode(request.getParameter("postal-code"));
        changingSubsBuilding.setMapLocLat(Double.valueOf(request.getParameter("lat")));
        changingSubsBuilding.setMapLocLng(Double.valueOf(request.getParameter("lng")));
        changingSubsBuilding.setFirstTel(request.getParameter("building-tel-1"));
        changingSubsBuilding.setSecondTel(request.getParameter("building-tel-2"));
        changingSubsBuilding.setFax(request.getParameter("building-fax"));
        changingSubsBuilding.setTelecomName(request.getParameter("telecom-center-name"));
        changingSubsBuilding.setHaveFiber(Boolean.valueOf(request.getParameter("have-fiber")));
        changingSubsBuilding.setUniId(university.getUniNationalId());
        if (changingSubsBuilding.getHaveFiber()) {
            changingSubsBuilding.setFiberCoreCount(Integer.valueOf(request.getParameter("fiber-core-count")));
            changingSubsBuilding.setHaveFreeFiber(Boolean.valueOf(request.getParameter("have-free-core")));
            if (changingSubsBuilding.getHaveFreeFiber()) {
                changingSubsBuilding.setFreeFiberCoreCount(Integer.valueOf(request.getParameter("free-fiber-core-count")));
            }
            changingSubsBuilding.setFirstFosContract(request.getParameter("fos-1"));
            changingSubsBuilding.setSecondFosContract(request.getParameter("fos-2"));
            changingSubsBuilding.setDistanceToTelecom(null);
        } else {
            changingSubsBuilding.setDistanceToTelecom(request.getParameter("telecom-center-distance"));
            changingSubsBuilding.setFiberCoreCount(null);
            changingSubsBuilding.setHaveFreeFiber(null);
            changingSubsBuilding.setFreeFiberCoreCount(null);
        }
        if (Boolean.valueOf(request.getParameter("use-primary-agent"))) {
            changingSubsBuilding.setAgentId(primaryAgent.getAgentId());
        } else {
            Agent newAgent = new Agent();
            PersonalInfo newPersonalInfo = new PersonalInfo();
            newPersonalInfo.setFname(request.getParameter("agent-fname"));
            newPersonalInfo.setLname(request.getParameter("agent-lname"));
            newPersonalInfo.setNationalId(Long.valueOf(request.getParameter("agent-national-code")));
            newAgent.setUniNationalId(newPersonalInfo.getNationalId());
            newAgent.setPrimary(false);
            newAgent.setAgentPos(request.getParameter("agent-pos"));
            newAgent.setSupportEmail(request.getParameter("agent-email"));
            newAgent.setTelNo(request.getParameter("agent-tel"));
            newAgent.setFaxNo(request.getParameter("agent-fax"));
            newAgent.setMobileNo(request.getParameter("agent-mob"));
            PersonalInfoDAO.save(newPersonalInfo);
            AgentDAO.save(newAgent);
            changingSubsBuilding.setAgentId(newAgent.getAgentId());
        }
        SubsBuildingDAO.save(changingSubsBuilding);
    }
    List<SubsBuilding> subsBuildingList = SubsBuildingDAO.findSubsBuildingsByUniId(university.getUniNationalId());

    City selectedCity = null;
    State selectedState = null;
    if (changingSubsBuilding != null) {
        selectedCity = CityDAO.findCityById(changingSubsBuilding.getCityId());
        selectedState = StateDAO.findStateById(selectedCity.getStateId());
    }

    Agent editAgent = null;
    PersonalInfo editPersonalInfo = null;
    boolean editAgentIsPrimary = true;
    if (isEdit) {
        editAgent = AgentDAO.findAgentById(changingSubsBuilding.getAgentId());
        editAgent.setIntroCert(null);
        editPersonalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(editAgent.getNationalId());
        editAgentIsPrimary = editAgent.getNationalId().equals(primaryAgent.getNationalId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.css">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <style>
        label + input {
            margin-left: 10px;
        }

        .mapCon {
            text-align: right;
            position: inherit;
            right: auto;
            top: auto;
            width: auto;
            height: 260px;
            padding-bottom: 0;
        }

        h4 {
            margin-right: 20px;
        }

        input[name=have-free-core] {
            margin-right: 10px;
        }

        input[type=text]:disabled {
            background: #ccc;
        }
    </style>
</head>
<body>
<form id="send-building" method="post" action="add-buildings.jsp" onsubmit=" return validateForm('#send-building');">
    <%if (isEdit) {%>
    <input type="hidden" name="action" value="edit-building">
    <%} else {%>
    <input type="hidden" name="action" value="send-building">
    <%}%>
    <%if (isEdit) {%>
    <input type="hidden" name="id" value="<%=changingSubsBuilding.getId()%>">
    <%}%>
    <input type="hidden" name="sub-code" value="<%=subSystemCode.getValue()%>">
    <div class="formBox">
        <h3>مشخصات ساختمان ها</h3>
        <h4>مشخصات عمومی</h4>
        <div class="formBox">
            <div class="formRow">
                <div class="formItem">
                    <label>نام ساختمان :</label>
                    <input class="formInput notEmptyInput" name="building-name"
                           maxlength="30"
                           style="width: 200px;"
                           value="<%=isEdit?changingSubsBuilding.getBuildingName():""%>"
                           type="text">
                </div>
                <div class="formItem">
                    <label>استان :</label>
                    <select id="state-select">
                        <%for (State state : StateDAO.findAllStates()) {%>
                        <option value="<%=state.getStateId()%>"
                                <%=isEdit && state.getStateId().equals(selectedState.getStateId()) ? "selected" : ""%>><%=state.getName()%>
                        </option>
                        <%}%>
                    </select>
                </div>
                <div class="formItem">
                    <label>شهر :</label>
                    <select id="city-select"
                            name="city-id" <%=isEdit ? "selected-index=" + selectedCity.getCityId() : ""%>>
                    </select>
                </div>
            </div>
            <div class="formRow">
                <div class="formItem">
                    <label>نشانی دقیق :</label>
                    <input class="formInput notEmptyInput" name="address"
                           maxlength="200"
                           style="width: 500px;"
                           value="<%=isEdit?changingSubsBuilding.getAddress():""%>"
                           type="text">
                </div>
                <div class="formItem">
                    <label>کدپستی :</label>
                    <input class="formInput numberInput" name="postal-code"
                           maxlength="10"
                           style="width: 200px;"
                           value="<%=isEdit?changingSubsBuilding.getPostalCode():""%>"
                           type="text">
                </div>
                <div class="mapCon">
                    <label>موقعیت دقیق روي نقشه:</label>
                    <div class="mapChoose" <%=isEdit ? " lat='" + changingSubsBuilding.getMapLocLat()
                            + "' lng='" + changingSubsBuilding.getMapLocLng() + "' " : ""%>
                         lat-input-id="lat" lng-input-id="lng"></div>
                    <input type="hidden" name="lat" id="lat">
                    <input type="hidden" name="lng" id="lng">
                </div>
            </div>
            <br>
            <br>
            <div class="formRow">
                <div class="formItem">
                    <label>تلفن۱ :</label>
                    <input class="formInput numberInput" name="building-tel-1"
                           maxlength="11" minlength="3"
                           style="width: 200px;"
                           value="<%=isEdit?changingSubsBuilding.getFirstTel():""%>"
                           type="text">
                </div>
                <div class="formItem">
                    <label>تلفن۲ :</label>
                    <input class="formInput numberInput" name="building-tel-2"
                           maxlength="11" minlength="0"
                           style="width: 200px"
                           value="<%=isEdit?changingSubsBuilding.getSecondTel():""%>"
                           type="text">
                </div>
                <div class="formItem">
                    <label>دورنگار :</label>
                    <input class="formInput numberInput" name="building-fax"
                           maxlength="11" minlength="3"
                           style="width: 200px"
                           value="<%=isEdit?changingSubsBuilding.getFax():""%>"
                           type="text">
                </div>
            </div>
        </div>
        <br>
        <h4>مشخصات ارتباطی</h4>
        <div class="formBox">
            <div class="formRow">
                <label>نام مرکز مخابراتی مربوطه(آبونه) :</label>
                <input class="formInput notEmptyInput" name="telecom-center-name"
                       maxlength="30" minlength="1"
                       style="width: 200px"
                       value="<%=isEdit?changingSubsBuilding.getTelecomName():""%>"
                       type="text">
            </div>
            ‌<br>
            <p style="margin: 0;">آیا فیبرنوری تا مرکز مخابراتی دارد؟</p>
            <div class="formBox" style="margin-top:0;" id="have-fiber-y-box">
                <%boolean haveFiber = changingSubsBuilding != null ? changingSubsBuilding.getHaveFiber() : true;%>
                <input type="radio" name="have-fiber" value="true" <%=isEdit?(haveFiber?"checked":""):"checked"%>>
                <label>بله</label>
                <div class="formRow">
                    <div class="formItem">
                        <label>تعداد core فیبر نوری :</label>
                        <input class="formInput numberInput" name="fiber-core-count"
                               maxlength="2" minlength="1"
                               style="width: 50px"
                               value="<%=isEdit&&haveFiber?changingSubsBuilding.getFiberCoreCount():""%>"
                               type="text">
                    </div>
                    <div class="formItem" style="margin-left: 10px">
                        <%boolean haveFreeCore = changingSubsBuilding != null ? changingSubsBuilding.getHaveFiber() && changingSubsBuilding.getHaveFreeFiber() : true;%>
                        <label>آیا فیبر‌نوری تا مرکز core آزاد دارد؟</label>
                        <input type="radio" name="have-free-core"
                               value="true" <%=isEdit?(haveFreeCore?"checked":""):""%>>
                        <label>بله</label>
                        <input type="radio" name="have-free-core"
                               value="false"<%=isEdit?(!haveFreeCore?"checked":""):"checked"%>>
                        <label>خیر</label>
                    </div>
                    <div class="formItem">
                        <label>تعداد core آزاد :</label>
                        <input class="formInput numberInput" name="free-fiber-core-count"
                               maxlength="2" minlength="1"
                               style="width: 50px"
                               value="<%=haveFreeCore&&isEdit?changingSubsBuilding.getFreeFiberCoreCount():""%>"
                               type="text">
                    </div>
                </div>
                <div class="formRow">
                    <div class="formItem">
                        <label>شماره قرارداد اول دسترسی فیبر(FOS):</label>
                        <input class="formInput" name="fos-1"
                               maxlength="30"
                               style="width: 200px"
                               value="<%=isEdit&&haveFiber?changingSubsBuilding.getFirstFosContract():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>شماره قرارداد دوم دسترسی فیبر(FOS):</label>
                        <input class="formInput" name="fos-2"
                               maxlength="30"
                               style="width: 200px"
                               value="<%=isEdit&&haveFiber?changingSubsBuilding.getSecondFosContract():""%>"
                               type="text">
                    </div>
                </div>
            </div>
            <div class="formBox" id="have-fiber-n-box">
                <input type="radio" name="have-fiber" value="false" <%=isEdit?(!haveFiber?"checked":""):""%>>
                <label>خیر</label>
                <div class="formRow">
                    <div class="formItem">
                        <label>فاصله تقریبی تا مرکز مخابراتی(کیلومتر) :</label>
                        <input class="formInput" name="telecom-center-distance"
                               maxlength="30" minlength="1"
                               style="width: 200px"
                               value="<%=isEdit&&!changingSubsBuilding.getHaveFiber()?changingSubsBuilding.getDistanceToTelecom():""%>"
                               type="text">
                    </div>
                </div>
            </div>
        </div>
        <br>
        <h4>مشخصات تحویل گیرنده سرویس</h4>
        <div class="formBox">
            <div class="formRow">
                <input type="radio" name="use-primary-agent" value="true" <%=editAgentIsPrimary?"checked":""%>>
                <label>نماینده تام الاختیار</label>
            </div>
            <div class="formRow">
                <input type="radio" name="use-primary-agent" value="false"<%=!editAgentIsPrimary?"checked":""%>>
                <label>شخص دیگر</label>
            </div>
            <div class="formBox" style="margin-top: 0;" id="agent-box" agentJson="<%=primaryAgentJson%>"
                 personalJson="<%=personalInfoJson%>">
                <div class="formRow">
                    <div class="formItem">
                        <label>نام :</label>
                        <input class="formInput persianInput" name="agent-fname"
                               maxlength="30" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editPersonalInfo.getFname():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>نام خانوادگی :</label>
                        <input class="formInput persianInput" name="agent-lname"
                               maxlength="30" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editPersonalInfo.getLname():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>کدملی :</label>
                        <input class="formInput numberInput" name="agent-national-code"
                               maxlength="10"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editPersonalInfo.getNationalId():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>سمت :</label>
                        <input class="formInput persianInput" name="agent-pos"
                               maxlength="10" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editAgent.getAgentPos():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>ایمیل :</label>
                        <input class="formInput emailInput" name="agent-email"
                               maxlength="‌60"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editAgent.getSupportEmail():""%>"
                               type="text">
                    </div>
                </div>
                <div class="formRow">
                    <div class="formItem">
                        <label>تلفن :</label>
                        <input class="formInput numberInput" name="agent-tel"
                               maxlength="11" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editAgent.getTelNo():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>دورنگار :</label>
                        <input class="formInput numberInput" name="agent-fax"
                               maxlength="11" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editAgent.getFaxNo():""%>"
                               type="text">
                    </div>
                    <div class="formItem">
                        <label>موبایل :</label>
                        <input class="formInput numberInput" name="agent-mob"
                               maxlength="11" minlength="1"
                               style="width: 200px"
                               value="<%=!editAgentIsPrimary&&isEdit?editAgent.getMobileNo():""%>"
                               type="text">
                    </div>
                </div>
            </div>
        </div>
        <br>
        <div class="formRow" style=" display: table; width: 100%;">
            <input type="submit" value="تایید" class="btn btn-primary formBtn"
                   style="margin-right: 10px;float: left">
            <%if (isEdit) {%>
            <a class="btn btn-primary formBtn" href="add-buildings.jsp?sub-code=<%=subSystemCode.getValue()%>"
               style="margin-right: 10px;float: left">لغو</a>
            <%}%>
        </div>
    </div>
</form>
<div class="formBox">
    <table class="fixed-table table table-striped">
        <thead>
        <tr style="background: #337ab7;color: white;">
            <th style="width:30px">ردیف</th>
            <th>نام</th>
            <th>آدرس</th>
            <th>عملیات ها</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < subsBuildingList.size(); i++) {
                SubsBuilding subsBuildingTable = subsBuildingList.get(i);
        %>
        <tr>
            <td style="width:30px">
                <%=i + 1%>
            </td>
            <td>
                <%=subsBuildingTable.getBuildingName()%>
            </td>
            <td>
                <%=subsBuildingTable.getAddress()%>
            </td>
            <td>
                <a href="#" data-toggle="modal"
                   data-target="#removeModal<%=subsBuildingTable.getId()%>">
                    <img src="../images/delete.png" style="width: 30px">
                </a>
                <%--<a href="add-buildings.jsp?action=edit&id=<%=subsBuildingTable.getId()%>&sub-code=<%=subSystemCode.getValue()%>">--%>
                <%--<img src="../images/edit-dis.png" style="width: 30px">--%>
                <%--</a>--%>
                <a>
                <img src="../images/edit-dis.png" style="width: 30px">
                </a>
                <!-- Modal -->
                <div class="modal fade infoModal" id="removeModal<%=subsBuildingTable.getId()%>" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4>آیا مایل به حذف "<%=subsBuildingTable.getAddress()%>" هستید؟</h4>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">خیر</button>
                                <a href="add-buildings.jsp?action=delete&id=<%=subsBuildingTable.getId()%>&sub-code=<%=subSystemCode.getValue()%>"
                                   style="float: left;" class="btn btn-default">بله</a>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        <% }%>
        </tbody>
    </table>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
<script src="js/add-buildings.js"></script>
<script type="text/javascript" src="https://static.neshan.org/api/web/v1/openlayers/v4.6.5.js?callback=initMaps" defer
        async></script>
</body>
</html>