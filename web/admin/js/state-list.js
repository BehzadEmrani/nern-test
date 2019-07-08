var tableContainer = $("#tableContainer");
function getTableData(delta) {
    var customerTable = document.getElementById("customerTable");
    var pageNo = customerTable ? Number(customerTable.getAttribute("page")) + delta : 1;
    if(delta==0)
        pageNo=1;
    tableContainer.html("");
    var xmlHttp = new XMLHttpRequest();
    var subCode=$("#tableContainer")[0].getAttribute("sub-code");
    var url = "state-list-fragment.jsp?page=" + pageNo;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
            tableContainer.html(this.responseText);
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
}
getTableData(0);

function getUniData(nationalId,subCode) {
    $("#infoModalBody").html("");
    $('#infoModal').modal('show');
    var xmlHttp = new XMLHttpRequest();
    var url = "manage-uni-info-fragment.jsp?sub-code=0&id=" + nationalId;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
            $("#infoModalBody").html(this.responseText);
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
}

function getMapData(nationalId,subCode) {
    $("#mapIframe").attr("src", "../map/show-map-by-id.jsp?sub-code=0&id=" + nationalId);
    $('#mapModal').modal('show');
}