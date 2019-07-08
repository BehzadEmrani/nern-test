var sampleTr = document.getElementById("sample-tr");
var parameterTable = document.getElementById("parameter-table");

function updateTrByNo(tr, trNo) {
    tr.setAttribute("no", trNo);
    $(tr.getElementsByTagName("button")[0]).attr("onclick", 'removeTrByNo(' + trNo + ')');
    var cInputs = tr.getElementsByClassName("parameter-c");
    for (var i = 0; i < cInputs.length; i++) {
        var cInput = cInputs[i];
        cInput.setAttribute("name", cInput.getAttribute("name").substring(0, cInput.getAttribute("name").lastIndexOf("-") + 1) + trNo);
    }
}
function addNewTrByNo(trNo) {
    var newTr = sampleTr.cloneNode(true);
    updateTrByNo(newTr, trNo);
    newTr.removeAttribute("style");
    newTr.removeAttribute("id");
    var newTrTds = newTr.getElementsByTagName("td");
    $(newTrTds[0].getElementsByTagName("button")[0]).attr("onclick", 'removeTrByNo(' + trNo + ')');
    parameterTable.appendChild(newTr);
    return newTr;
}
function addNewPrRow() {
    var tableTrs = parameterTable.getElementsByTagName("tr");
    var lTr = tableTrs[tableTrs.length - 1];
    var newTrNo = Number(lTr.getAttribute("no")) + 1;
    $("#parameter-tr-no").attr("value", newTrNo + 1);
    var newTr = addNewTrByNo(newTrNo);
    $(newTr).find("select:first").change(function () {
        $(this).parent().parent().find("label").html($(this).find("option:selected").attr("unit"));
    });
    $(newTr).find("select:first").change();
    return newTr;
}
function removeTrByNo(trNo) {
    $("#parameter-table > tr[no=" + trNo + "]").remove();
    var parametersSize = $("#parameter-table > tr").length;
    $("#parameter-tr-no").attr("value", parametersSize);
    var trs = $("#parameter-table > tr[no!='-1']");
    for (var i = 0; i < trs.length; i++) {
        updateTrByNo(trs[i], i);
    }
}

if (parameterTable.getAttribute("json") != "") {
    var parametersJson = eval('(' + parameterTable.getAttribute("json") + ')');
    for (var i = 0; i < parametersJson.length; i++) {
        var parameter = parametersJson[i];
        var newTr = addNewPrRow();
        var trNo = newTr.getAttribute("no");
        $("select[name=parameter-" + trNo + "]").val(parameter["equipmentParameterId"]);
        $("select[name=parameter-" + trNo + "]").change();
        $("input[name=amount-" + trNo + "]").val(parameter["amount"]);
    }
} else {
    addNewPrRow();
}
///

var portSampleTr = document.getElementById("port-sample-tr");
var portTable = document.getElementById("port-table");
function updatePortTrByNo(tr, trNo, isNew) {
    tr.setAttribute("no", trNo);
    var cInputs = tr.getElementsByClassName("port-c");
    $(tr).find("button").attr("onclick", 'removePortTrByNo(' + trNo + ')');
    var selectInput=$(tr).find("select");
    selectInput.attr("name", selectInput.attr("name").substring(0, selectInput.attr("name").lastIndexOf("-") + 1) + trNo);
    for (var i = 0; i < cInputs.length; i++) {
        var cInput = cInputs[i];
        if (isNew) {
            if (i == 0)
                cInput.value = trNo + 1;
            else if (i == 1)
                cInput.value = 0;
        }
        cInput.setAttribute("name", cInput.getAttribute("name").substring(0, cInput.getAttribute("name").lastIndexOf("-") + 1) + trNo);
    }
}
function addNewPortTrByNo(trNo) {
    var newTr = portSampleTr.cloneNode(true);
    updatePortTrByNo(newTr, trNo,true);
    newTr.removeAttribute("style");
    newTr.removeAttribute("id");
    var newTrTds = newTr.getElementsByTagName("td");

    $(newTrTds[0].getElementsByTagName("button")[0]).attr("onclick", 'removePortTrByNo(' + trNo + ')');
    portTable.appendChild(newTr);
    return newTr;
}
function addNewPortRow() {
    var tableTrs = portTable.getElementsByTagName("tr");
    var lTr = tableTrs[tableTrs.length - 1];
    var newTrNo = Number(lTr.getAttribute("no")) + 1;
    $("#port-tr-no").attr("value", newTrNo + 1);
    var newTr = addNewPortTrByNo(newTrNo);
    return newTr;
}
function removePortTrByNo(trNo) {
    $("#port-table > tr[no=" + trNo + "]").remove();
    var portsSize = $("#port-table > tr").length;
    $("#port-tr-no").attr("value", portsSize);
    var trs = $("#port-table > tr[no!='-1']");
    for (var i = 0; i < portsSize; i++) {
        updatePortTrByNo(trs[i], i,false);
    }
}

if (portTable.getAttribute("json") != "") {
    var portsJson = eval('(' + portTable.getAttribute("json") + ')');
    for (var i = 0; i < portsJson.length; i++) {
        var port = portsJson[i];
        var newTr = addNewPortRow();
        var trNo = newTr.getAttribute("no");
        $("input[name=port-no-" + trNo+"]").val(port["portNo"]);
        $("select[name=port-unit-" + trNo+"]").val(port["unitVal"]);
        $("input[name=port-amount-" + trNo+"]").val(port["value"]);
    }
}

///
var typeSelect=$('#typeSelect');
var activePanel=$('#activePanel');
typeSelect.change(function () {
    if(typeSelect.val()=="3000"){
        activePanel.show();
    }else{
        activePanel.hide();
    }
});

typeSelect.change();
///

var parentSampleTr = document.getElementById("parent-sample-tr");
var parentTable = document.getElementById("parent-table");
function updateParentTrByNo(tr, trNo, isNew) {
    tr.setAttribute("no", trNo);
    var cInputs = tr.getElementsByClassName("parent-c");
    $(tr).find("button").attr("onclick", 'removeParentTrByNo(' + trNo + ')');
    var selectInput=$(tr).find("select");
    selectInput.attr("name", selectInput.attr("name").substring(0, selectInput.attr("name").lastIndexOf("-") + 1) + trNo);
    for (var i = 0; i < cInputs.length; i++) {
        var cInput = cInputs[i];
        if (isNew) {
            if (i == 0)
                cInput.value = trNo + 1;
            else if (i == 1)
                cInput.value = 0;
        }
        cInput.setAttribute("name", cInput.getAttribute("name").substring(0, cInput.getAttribute("name").lastIndexOf("-") + 1) + trNo);
    }
}
function addNewParentTrByNo(trNo) {
    var newTr = parentSampleTr.cloneNode(true);
    updateParentTrByNo(newTr, trNo,true);
    newTr.removeAttribute("style");
    newTr.removeAttribute("id");
    var newTrTds = newTr.getElementsByTagName("td");

    $(newTrTds[0].getElementsByTagName("button")[0]).attr("onclick", 'removeParentTrByNo(' + trNo + ')');
    parentTable.appendChild(newTr);
    return newTr;
}
function addNewParentRow() {
    var tableTrs = parentTable.getElementsByTagName("tr");
    var lTr = tableTrs[tableTrs.length - 1];
    var newTrNo = Number(lTr.getAttribute("no")) + 1;
    $("#parent-tr-no").attr("value", newTrNo + 1);
    var newTr = addNewParentTrByNo(newTrNo);
    return newTr;
}
function removeParentTrByNo(trNo) {
    $("#parent-table > tr[no=" + trNo + "]").remove();
    var parentsSize = $("#parent-table > tr").length;
    $("#parent-tr-no").attr("value", parentsSize);
    var trs = $("#parent-table > tr[no!='-1']");
    for (var i = 0; i < parentsSize; i++) {
        updateParentTrByNo(trs[i], i,false);
    }
}

if (parentTable.getAttribute("json") != "") {
    var parentsJson = eval('(' + parentTable.getAttribute("json") + ')');
    for (var i = 0; i < parentsJson.length; i++) {
        var parent = parentsJson[i];
        var newTr = addNewParentRow();
        var trNo = newTr.getAttribute("no");
        $("select[name=equip-type-" + trNo+"]").val(parent["parentId"]);
    }
}