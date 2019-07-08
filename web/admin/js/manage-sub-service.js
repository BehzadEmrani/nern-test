var sampleTr = document.getElementById("sample-tr");
var slaTable = document.getElementById("sla-table");
function updateTrByNo(tr, trNo) {
    tr.setAttribute("no", trNo);
    $(tr.getElementsByTagName("button")[0]).attr("onclick", 'removeTrByNo(' + trNo + ')');
    var cInputs = tr.getElementsByClassName("pr-c");
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
    slaTable.appendChild(newTr);
    return newTr;
}
function addNewPrRow() {
    var tableTrs = slaTable.getElementsByTagName("tr");
    var lTr = tableTrs[tableTrs.length - 1];
    var newTrNo = Number(lTr.getAttribute("no")) + 1;
    $("#pr-tr-no").attr("value", newTrNo + 1);
    return addNewTrByNo(newTrNo);
}
function removeTrByNo(trNo) {
    $("#sla-table > tr[no=" + trNo + "]").remove();
    var slaSize = $("#sla-table > tr").length;
    $("#pr-tr-no").attr("value", slaSize);
    var trs = $("#sla-table > tr[no!='-1']");
    for (var i = 0; i < trs.length; i++) {
        updateTrByNo(trs[i], i);
    }
}

if (slaTable.getAttribute("json") != "") {
    var parametersJson = eval('(' + slaTable.getAttribute("json") + ')');
    for (var i = 0; i < parametersJson.length; i++) {
        var subParameter = parametersJson[i];
        var newTr = addNewPrRow();
        var trNo = newTr.getAttribute("no");
        document.getElementsByName("pr-name-" + trNo)[0].value = subParameter["faName"];
        document.getElementsByName("pr-unit-" + trNo)[0].value = subParameter["unitVal"];
        document.getElementsByName("pr-sla-B-" + trNo)[0].value = subParameter["bronzeValue"];
        document.getElementsByName("pr-sla-S-" + trNo)[0].value = subParameter["silverValue"];
        document.getElementsByName("pr-sla-G-" + trNo)[0].value = subParameter["goldValue"];
        document.getElementsByName("pr-sla-D-" + trNo)[0].value = subParameter["diamondValue"];
    }
} else {
    addNewPrRow();
}

var catSelect = document.getElementById("cat-select");
var serviceSelect = document.getElementById("service-select");
var servicesJson = eval('(' + serviceSelect.getAttribute("json") + ')');
catSelect.onchange = function () {
    var catIndex = catSelect.selectedIndex;
    var servicesAr = servicesJson[catIndex];
    $('#service-select > option').remove();
    for (var i = 0; i < servicesAr.length; i++) {
        var service = servicesAr[i];
        var option = document.createElement("option");
        option.text = service['faStr'];
        option.value = service['id'];
        serviceSelect.add(option);
    }
};
catSelect.onchange();

if ($("#service-select").attr("selected-index") != "") {
    var selectedServiceId = $("#service-select").attr("selected-index");
    $("#service-select").val(selectedServiceId);
}
