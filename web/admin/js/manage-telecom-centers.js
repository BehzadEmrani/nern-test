var marker = false; ////Has the user plotted their location marker?
var
    mapT;
function initTelMap() {
    // Listen for any clicks on the map.
    //The center location of our map.
    var centerOfMap = new google.maps.LatLng(31.8, 50.65);
    //Map options.
    var options = {
        center: centerOfMap, //Set center.
        zoom: 6, //The zoom value.
        fullscreenControl: true
    };

    //Create the map object.
    mapT = new google.maps.Map(document.getElementById('mapTel'), options);
    //Listen for any clicks on the map.
    google.maps.event.addListener(mapT, 'click', function (event) {
        //Get the location that the user clicked.
        var clickedLocation = event.latLng;
        //If the marker hasn't been added.
        if (marker === false) {
            //Create the marker.
            marker = new google.maps.Marker({
                position: clickedLocation,
                map: mapT,
                draggable: true //make it draggable
            });
            //Listen for drag events!
            google.maps.event.addListener(marker, 'dragend', function (event) {
                markerLocation();
            });
        } else {
            //Marker has already been added, so just change its location.
            marker.setPosition(clickedLocation);
        }
        //Get the marker's location.
        markerLocation();
    });
    var lat1=document.getElementById('mapTel').getAttribute("lat");
    if (lat1&&lat1!="null") {
        var posisionLatLng1 = {
            lat: parseFloat(document.getElementById('mapTel').getAttribute("lat")),
            lng: parseFloat(document.getElementById('mapTel').getAttribute("lng"))
        };
        marker = new google.maps.Marker({
            position: posisionLatLng1,
            map: mapT,
            draggable: true //make it draggable
        });
        marker.setPosition(posisionLatLng1);
        markerLocation();
    }
}
function markerLocation() {
    //Get location.
    var currentLocation = marker.getPosition();
    //Add lat and lng values to a field that we can save.
    document.getElementById('telLat').value = currentLocation.lat(); //latitude
    document.getElementById('telLng').value = currentLocation.lng(); //longitude
}

///
var sampleTr = document.getElementById("sample-tr");
var preFixTable = document.getElementById("pre-fix-table");
var stateSelect = document.getElementById("state-select");
var citySelect = document.getElementById("city-select");

function updateTrByNo(tr, trNo) {
    tr.setAttribute("no", trNo);
    $(tr.getElementsByTagName("button")[0]).attr("onclick", 'removeTrByNo(' + trNo + ')');
    var cInputs = tr.getElementsByClassName("pre-fix-c");
    for (var i = 0; i < cInputs.length; i++) {
        var cInput = cInputs[i];
        cInput.name = cInput.name.substring(0, cInput.name.lastIndexOf("-") + 1) + trNo;
    }
}
function addNewTrByNo(trNo) {
    var newTr = sampleTr.cloneNode(true);
    updateTrByNo(newTr, trNo);
    newTr.removeAttribute("style");
    newTr.removeAttribute("id");
    var newTrTds = newTr.getElementsByTagName("td");
    $(newTrTds[0].getElementsByTagName("button")[0]).attr("onclick", 'removeTrByNo(' + trNo + ')');
    preFixTable.appendChild(newTr);
    return newTr;
}
function addNewPrRow() {
    var tableTrs = preFixTable.getElementsByTagName("tr");
    var lTr = tableTrs[tableTrs.length - 1];
    var newTrNo = Number(lTr.getAttribute("no")) + 1;
    $("#pre-fix-tr-no").attr("value", newTrNo + 1);
    return addNewTrByNo(newTrNo);
}
function removeTrByNo(trNo) {
    $("#pre-fix-table > tr[no=" + trNo + "]").remove();
    var preFixSize = $("#pre-fix-table > tr").length;
    $("#pre-fix-tr-no").attr("value", preFixSize);
    var trs = $("#pre-fix-table > tr[no!='-1']");
    for (var i = 0; i < trs.length; i++) {
        updateTrByNo(trs[i], i);
    }
}

if (preFixTable.getAttribute("json") != "") {
    var preFixesJson = eval('(' + preFixTable.getAttribute("json") + ')');
    for (var i = 0; i < preFixesJson.length; i++) {
        var preFix = preFixesJson[i];
        var newTr = addNewPrRow();
        var trNo = newTr.getAttribute("no");
        document.getElementsByName("pre-fix-" + trNo)[0].value = preFix["preFixNo"];
    }
} else {
    addNewPrRow();
}

var citySelectedIndexSelected = citySelect.getAttribute("selected-index")=="";
stateSelect.onchange = function () {
    $(citySelect).find("option").remove();
    $.getJSON("../api/get-city-by-state-id.jsp?state-id=" + stateSelect.value, function (dataAr) {
        for (var i = 0; i < dataAr.length; i++) {
            var data = dataAr[i];
            var option = $('<option/>');
            option.attr({ 'value': data["cityId"] }).text(data["name"]);
            $(citySelect).append(option);
        }
        if (!citySelectedIndexSelected) {
            citySelectedIndexSelected = true;
            $(citySelect).val(citySelect.getAttribute("selected-index"))
        }
    });
};
stateSelect.onchange();
