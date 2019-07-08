var sampleTr = document.getElementById("sample-tr");
var slaTable = document.getElementById("sla-table");
var catSelect = document.getElementById("cat-select");
var serviceSelect = document.getElementById("service-select");
var subServiceSelect = document.getElementById("sub-service-select");
var catSelectParam = document.getElementById("cat-select-param");
var serviceSelectParam = document.getElementById("service-select-param");
var subServiceSelectParam = document.getElementById("sub-service-select-param");
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

var servicesJson = eval('(' + serviceSelect.getAttribute("json") + ')');
var subServicesJson = eval('(' + subServiceSelect.getAttribute("json") + ')');
serviceSelect.onchange = function () {
    var serviceCatIndex = catSelect.selectedIndex;
    var serviceIndex = serviceSelect.selectedIndex;
    var subServicesAr = subServicesJson[serviceCatIndex][serviceIndex];
    $('#sub-service-select > option').remove();
    for (var i = 0; i < subServicesAr.length; i++) {
        var subService = subServicesAr[i];
        var option = document.createElement("option");
        option.text = subService['faStr'];
        option.value = subService['id'];
        subServiceSelect.add(option);
    }
};
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
    serviceSelect.onchange();
};
catSelect.onchange();

if ($("#service-select").attr("selected-index") != "") {
    var selectedServiceId = $("#service-select").attr("selected-index");
    $("#service-select").val(selectedServiceId);
    serviceSelect.onchange();
}

if ($("#sub-service-select").attr("selected-index") != "") {
    var selectedSubServiceId = $("#sub-service-select").attr("selected-index");
    $("#sub-service-select").val(selectedSubServiceId);
}

subServiceSelect.onchange = function () {
    var subServiceObject = subServicesJson[catSelect.selectedIndex][serviceSelect.selectedIndex][subServiceSelect.selectedIndex];
    var otherCostStr = subServiceObject['otherCostTitle'];
    if (otherCostStr != "") {
        $("#other-cost").css("display", "block");
        $("#other-cost > span").text(otherCostStr);
    } else {
        $("#other-cost").css("display", "none");
    }
};
subServiceSelect.onchange();

if (slaTable.getAttribute("json") != "") {
    var parametersJson = eval('(' + slaTable.getAttribute("json") + ')');
    for (var i = 0; i < parametersJson.length; i++) {
        var subParameter = parametersJson[i];
        var newTr = addNewPrRow();
        var trNo = newTr.getAttribute("no");
        document.getElementsByName("pr-code-" + trNo)[0].value = subParameter["code"];
        document.getElementsByName("pr-spec-" + trNo)[0].value = subParameter["specs"];
        document.getElementsByName("pr-deposit-" + trNo)[0].value = subParameter["deposit"];
        document.getElementsByName("pr-warranty-" + trNo)[0].value = subParameter["warranty"];
        document.getElementsByName("pr-initial-cost-" + trNo)[0].value = subParameter["initialCost"];
        document.getElementsByName("pr-periodic-payment-" + trNo)[0].value = subParameter["periodicPayment"];
        document.getElementsByName("pr-other-cost-" + trNo)[0].value = subParameter["otherCost"];
    }
} else {
    addNewPrRow();
}

serviceSelectParam.onchange = function () {
    var serviceCatIndex = catSelectParam.selectedIndex - 1;
    var serviceIndex = serviceSelectParam.selectedIndex - 1;
    $('#sub-service-select-param > option').remove();
    if (serviceIndex != -1) {
        var subServicesAr = subServicesJson[serviceCatIndex][serviceIndex];
        var optionAll = document.createElement("option");
        optionAll.text = "همه زیر خدمات";
        optionAll.value = "-1";
        subServiceSelectParam.add(optionAll);
        for (var i = 0; i < subServicesAr.length; i++) {
            var subService = subServicesAr[i];
            var option = document.createElement("option");
            option.text = subService['faStr'];
            option.value = subService['id'];
            subServiceSelectParam.add(option);
        }
    }
};
catSelectParam.onchange = function () {
    var catIndex = catSelectParam.selectedIndex - 1;
    $('#service-select-param > option').remove();
    if (catIndex != -1) {
        var servicesAr = servicesJson[catIndex];
        var optionAll = document.createElement("option");
        optionAll.text = "همه خدمات";
        optionAll.value = "-1";
        serviceSelectParam.add(optionAll);
        for (var i = 0; i < servicesAr.length; i++) {
            var service = servicesAr[i];
            var option = document.createElement("option");
            option.text = service['faStr'];
            option.value = service['id'];
            serviceSelectParam.add(option);
        }
    }
    serviceSelectParam.onchange();
};
catSelectParam.onchange();
