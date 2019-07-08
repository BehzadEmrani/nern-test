var tableContainer = $("#tableContainer");
var nationalFilter = $("#nationalFilter");
var nameFilter = $("#nameFilter");
var stateFilter = $("#stateFilter");
var cityFilter = $("#cityFilter");
var typeFilter = $("#typeFilter");
var statusFilter = $("#statusFilter");

function getTableData(delta) {
    var customerTable = document.getElementById("customerTable");
    var pageNo = customerTable ? Number(customerTable.getAttribute("page")) + delta : 1;
    if(delta==0)
        pageNo=1;
    tableContainer.html("");
    var xmlHttp = new XMLHttpRequest();
    var fNationalId = nationalFilter.val() != "" ? nationalFilter.val() : "-1";
    var fName = nameFilter.val() != "" ? nameFilter.val() : "-1";
    var fCity = cityFilter.val() != "" ? cityFilter.val() : "-1";
    var fState = stateFilter.val() != "" ? stateFilter.val() : "-1";
    var fType = typeFilter.val().split('&')[1];
    var fSubCode = typeFilter.val().split('&')[0];
    var fStatus = statusFilter.val();
    var url = "manage-uni-fragment-medicals.jsp?sub-code=" + fSubCode + "&page=" + pageNo + "&national-id=" + fNationalId + "&uni-name="
        + fName + "&city=" + fCity + "&state=" + fState + "&type=" + fType + "&status=" + fStatus;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
            tableContainer.html(this.responseText);
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
}
getTableData(0);

function getUniData(nationalId) {
    $("#infoModalBody").html("");
    $('#infoModal').modal('show');
    var xmlHttp = new XMLHttpRequest();
    var url = "manage-uni-info-fragment.jsp?id=" + nationalId;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
            $("#infoModalBody").html(this.responseText);
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
}

function getMapData(nationalId) {
    $("#mapIframe").attr("src", "../map/show-map-by-id.jsp?id=" + nationalId);
    $('#mapModal').modal('show');
}

function getLogData(nationalId) {
    $("#logIframe").attr("src", "show-uni-state-log.jsp?id=" + nationalId);
    $('#logModal').modal('show');
}