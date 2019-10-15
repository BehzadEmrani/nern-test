var tableContainer = $("#tableContainer");
var nameFilter = $("#nameFilter");
var stateFilter = $("#stateFilter");
var cityFilter = $("#cityFilter");
var serviceFilter = $("#serviceFilter");
var subServiceFilter = $("#subServiceFilter");
var situationFilter =$("#situationFilter");
var subCode = tableContainer.attr("sub-code");

function getTableData(delta) {
    var customerTable = document.getElementById("customerTable");
    var pageNo = customerTable ? Number(customerTable.getAttribute("page")) + delta : 1;
    if(delta==0)
        pageNo=1;
    tableContainer.html("");
    var xmlHttp = new XMLHttpRequest();
    var fName = nameFilter.val() != "" ? nameFilter.val() : "-1";
    var fCity = cityFilter.val() != "" ? cityFilter.val() : "-1";
    var fState = stateFilter.val() != "" ? stateFilter.val() : "-1";
    var fService = serviceFilter.val();
    var fsituation = situationFilter.val() != "" ? situationFilter.val() : "-1";
    var fSubService = subServiceFilter.val() != null ? subServiceFilter.val() : "-1";
    var url = "requested-service-form-fragment.jsp?page=" + pageNo + "&uni-name="+ fName +
        "&city=" + fCity + "&state=" + fState + "&service=" + fService + "&subservice=" + fSubService + "&status=" + fsituation;

    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
            tableContainer.html(this.responseText);
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
}
getTableData(0);

// function getUniData(nationalId) {
//     $("#infoModalBody").html("");
//     $('#infoModal').modal('show');
//     var xmlHttp = new XMLHttpRequest();
//     var url = "manage-uni-info-fragment.jsp?sub-code=" + subCode + "&id=" + nationalId;
//     xmlHttp.onreadystatechange = function () {
//         if (this.readyState == 4 && this.status == 200)
//             $("#infoModalBody").html(this.responseText);
//     };
//     xmlHttp.open("GET", url, true);
//     xmlHttp.send();
// }

function getMapData(nationalId) {
    $("#mapIframe").attr("src", "../map/show-map-by-id.jsp?sub-code=" + subCode + "&id=" + nationalId);
    $('#mapModal').modal('show');
}

function getLogData(nationalId) {
    $("#logIframe").attr("src", "show-uni-state-log.jsp?id=" + nationalId);
    $('#logModal').modal('show');
}