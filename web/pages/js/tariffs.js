var serviceSelect = $("#service-select")[0];
var subServiceSelect = $("#sub-service-select")[0];
var serviceFormSampleRow = $("#sample-service-form-pr-row")[0];
var serviceFormTBody = $("#service-form-tbody")[0];
var submitBtn = $("input[type=submit]");
serviceSelect.onchange = function () {
    var xmlhttp = new XMLHttpRequest();
    var serviceId = serviceSelect.value;
    var url = "../../api/get-sub-service-by-service-id.jsp?service-id=" + serviceId;
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            servicesReceived(myArr);
        }
    };
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
    function servicesReceived(arr) {
        subServiceSelect.innerHTML = "";
        for (var j = 0; j < arr.length; j++) {
            var subService = arr[j];
            var tOption = document.createElement("option");
            tOption.text = subService["faName"];
            tOption.value = subService["id"];
            tOption.setAttribute("approveTypeVal", subService["approveTypeVal"]);
            tOption.setAttribute("approveSessionNo", subService["approveSessionNo"]);
            tOption.setAttribute("exclusiveTerms", subService["exclusiveTerms"]);
            tOption.setAttribute("slaMeasurement", subService["slaMeasurement"]);
            tOption.setAttribute("otherCostTitle", subService["otherCostTitle"]);
            subServiceSelect.add(tOption);
        }
        subServiceSelect.onchange();
    }
};
serviceSelect.onchange();
var unitsAr = eval('(' + $("#sla-parameters").attr("units") + ')');

$('input[type=radio][name=sla-type]').change(function () {
    var selectedSla = this.value;
    $("#sla-parameters>div").each(function () {
        if (selectedSla == 1) {
            this.getElementsByTagName("span")[0].innerText = this.getAttribute("bronzeValue")
                + " " + unitsAr[Number(this.getAttribute("unitVal"))];
        } else if (selectedSla == 2) {
            this.getElementsByTagName("span")[0].innerText = this.getAttribute("silverValue")
                + " " + unitsAr[Number(this.getAttribute("unitVal"))];
        } else if (selectedSla == 3) {
            this.getElementsByTagName("span")[0].innerText = this.getAttribute("goldValue")
                + " " + unitsAr[Number(this.getAttribute("unitVal"))];
        } else if (selectedSla == 4) {
            this.getElementsByTagName("span")[0].innerText = this.getAttribute("diamondValue")
                + " " + unitsAr[Number(this.getAttribute("unitVal"))];
        }
    });

    $("#service-form-tbody>tr").remove();
    function sendServiceFormPrReq() {
        var xmlHttp = new XMLHttpRequest();
        var subServiceId = subServiceSelect.value;
        var payType = $('input[type=radio][name=pay-type]:checked').val();
        var subsDuration = $('input[type=radio][name=subs-duration]:checked').val();
        var payPeriod = $('input[type=radio][name=pay-period]:checked').val();
        var slaType = $('input[type=radio][name=sla-type]:checked').val();
        var url = "../../api/get-service-form-parameters.jsp?sub-service-id=" + subServiceId + "&pay-type=" + payType
            + "&subs-duration=" + subsDuration + "&pay-period=" + payPeriod + "&sla-type=" + slaType;
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var myArr = JSON.parse(this.responseText);
                serviceFormPrReceived(myArr);
            }
        };
        xmlHttp.open("GET", url, true);
        xmlHttp.send();
        function serviceFormPrReceived(arr) {
            for (var j = 0; j < arr.length; j++) {
                var serviceFormParameter = arr[j];
                var newTr = serviceFormSampleRow.cloneNode(true);
                newTr.id = "";
                newTr.style.display = "";
                $(newTr).find(">.selectTd>input").val(serviceFormParameter["id"]);
                $(newTr).find(">.codeTd").text(serviceFormParameter["code"]);
                $(newTr).find(">.specsTd").text(serviceFormParameter["specs"]);
                $(newTr).find(">.depositTd").text(accounting.formatNumber(serviceFormParameter["deposit"]));
                $(newTr).find(">.warrantyTd").text(accounting.formatNumber(serviceFormParameter["warranty"]));
                $(newTr).find(">.initialCostTd").text(accounting.formatNumber(serviceFormParameter["initialCost"]));
                $(newTr).find(">.periodicPaymentTd").text(accounting.formatNumber(serviceFormParameter["periodicPayment"]));
                $(newTr).find(">.otherCostTd").text(accounting.formatNumber(serviceFormParameter["otherCost"]));
                serviceFormTBody.appendChild(newTr);
            }
            var serviceFormRadio = $("input[name=service-form-parameter-id]");
            serviceFormRadio.change(function () {
                submitBtn.prop("disabled", serviceFormRadio.val() == undefined)
            });
        }
    }

    sendServiceFormPrReq();


    $("#other-terms").text("");
    function sendServiceFormTermsReq() {
        var xmlHttp = new XMLHttpRequest();
        var subServiceId = subServiceSelect.value;
        var payType = $('input[type=radio][name=pay-type]:checked').val();
        var subsDuration = $('input[type=radio][name=subs-duration]:checked').val();
        var payPeriod = $('input[type=radio][name=pay-period]:checked').val();
        var slaType = $('input[type=radio][name=sla-type]:checked').val();
        var url = "../../api/get-service-form.jsp?sub-service-id=" + subServiceId + "&pay-type=" + payType
            + "&subs-duration=" + subsDuration + "&pay-period=" + payPeriod + "&sla-type=" + slaType;
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var obj = JSON.parse(this.responseText);
                serviceFormTermsReceived(obj);
            }
        };
        xmlHttp.open("GET", url, true);
        xmlHttp.send();
        function serviceFormTermsReceived(obj) {
            $("#other-terms").text(obj["otherTerms"]);
        }
    }

    sendServiceFormTermsReq();

    $("#service-form-combine").text("");
    function sendServiceFormCombineReq() {
        var xmlHttp = new XMLHttpRequest();
        var subServiceId = subServiceSelect.value;
        var payType = $('input[type=radio][name=pay-type]:checked').val();
        var subsDuration = $('input[type=radio][name=subs-duration]:checked').val();
        var payPeriod = $('input[type=radio][name=pay-period]:checked').val();
        var slaType = $('input[type=radio][name=sla-type]:checked').val();
        var url = "../../api/get-service-form-combine.jsp?sub-service-id=" + subServiceId + "&pay-type=" + payType
            + "&subs-duration=" + subsDuration + "&pay-period=" + payPeriod + "&sla-type=" + slaType;
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var str = this.responseText;
                serviceFormCombineReceived(str);
            }
        };
        xmlHttp.open("GET", url, true);
        xmlHttp.send();
        function serviceFormCombineReceived(str) {
            $("#service-form-combine").text(str);
        }
    }

    sendServiceFormCombineReq();
});
$('input[type=radio][name=pay-period]').change(function () {
    $("input[name=sla-type]").prop("disabled", true);

    var xmlHttp = new XMLHttpRequest();
    var subServiceId = subServiceSelect.value;
    var payType = $('input[type=radio][name=pay-type]:checked').val();
    var subsDuration = $('input[type=radio][name=subs-duration]:checked').val();
    var payPeriod = $('input[type=radio][name=pay-period]:checked').val();
    var url = "../../api/get-exists-service-for-sla-type.jsp?" +
        "sub-service-id=" + subServiceId + "&pay-type=" + payType + "&subs-duration=" + subsDuration + "&pay-period=" + payPeriod;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            existSlaTypeReceived(myArr);
        }
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
    function existSlaTypeReceived(arr) {
        $("input[name=sla-type]").each(function () {
            $(this).prop("disabled", !arr[$(this).val()])
        });
        if ($("input[name=sla-type]:checked").val() != undefined) {
            $('input[type=radio][name=sla-type]').first().change();
        }
    }
});

$('input[type=radio][name=subs-duration]').change(function () {
    $("input[name=pay-period]").prop("disabled", true);
    $("input[name=sla-type]").prop("disabled", true);

    var xmlHttp = new XMLHttpRequest();
    var subServiceId = subServiceSelect.value;
    var payType = $('input[type=radio][name=pay-type]:checked').val();
    var subsDuration = $('input[type=radio][name=subs-duration]:checked').val();
    var url = "../../api/get-exists-service-for-pay-period.jsp?" +
        "sub-service-id=" + subServiceId + "&pay-type=" + payType + "&subs-duration=" + subsDuration;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            existPayPeriodReceived(myArr);
        }
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
    function existPayPeriodReceived(arr) {
        $("input[name=pay-period]").each(function () {
            $(this).prop("disabled", !arr[$(this).val()])
        });
        if ($("input[name=pay-period]:checked").val() != undefined) {
            $('input[type=radio][name=pay-period]').first().change();
        }
    }
});
$('input[type=radio][name=pay-type]').change(function () {
    $("input[name=subs-duration]").prop("disabled", true);
    $("input[name=pay-period]").prop("disabled", true);
    $("input[name=sla-type]").prop("disabled", true);

    var xmlHttp = new XMLHttpRequest();
    var subServiceId = subServiceSelect.value;
    var payType = $('input[type=radio][name=pay-type]:checked').val();
    var url = "../../api/get-exists-service-for-subs-duration.jsp?sub-service-id=" + subServiceId + "&pay-type=" + payType;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            existSubsDurationReceived(myArr);
        }
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
    function existSubsDurationReceived(arr) {
        $("input[name=subs-duration]").each(function () {
            $(this).prop("disabled", !arr[$(this).val()])
        });
        if ($("input[name=subs-duration]:checked").val() != undefined) {
            $('input[type=radio][name=subs-duration]').first().change();
        }
    }
});
subServiceSelect.onchange = function () {
    $("#sub-service-name").text($(subServiceSelect).find(">option:selected").text());
    var approveType = $("#sub-service-select>option:selected")[0].getAttribute("approveTypeVal");
    var exclusiveTerms = $("#sub-service-select>option:selected")[0].getAttribute("exclusiveTerms");
    var otherCostTitle = $("#sub-service-select>option:selected")[0].getAttribute("otherCostTitle");
    $("#other-costs").text(otherCostTitle != "" ? otherCostTitle : "سایر هزینه ها");
    $("#sla-measurement").text($("#sub-service-select>option:selected").attr("slaMeasurement"));
    if (approveType == 1) {
        $("#approve-type-1").prop('checked', true);
        $("#approve-type-2").prop('checked', false);
        $("#approve-session-no-1").text($("#sub-service-select>option:selected").attr("approveSessionNo"));
        $("#approve-session-no-2").text("...");
    } else {
        $("#approve-type-1").prop('checked', false);
        $("#approve-type-2").prop('checked', true);
        $("#approve-session-no-2").text($("#sub-service-select>option:selected").attr("approveSessionNo"));
        $("#approve-session-no-1").text("...");
    }
    $("#exclusive-terms").text(exclusiveTerms);

    function sendSubServiceParametersReq() {
        var xmlHttp = new XMLHttpRequest();
        var subServiceId = subServiceSelect.value;
        var url = "../../api/get-sub-service-parameters.jsp?sub-service-id=" + subServiceId;
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var myArr = JSON.parse(this.responseText);
                subServiceParametersReceived(myArr);
            }
        };
        xmlHttp.open("GET", url, true);
        xmlHttp.send();
        function subServiceParametersReceived(arr) {
            $("#sla-parameters")[0].innerHTML = "";
            for (var j = 0; j < arr.length; j++) {
                var subServicePr = arr[j];
                var tDiv = document.createElement("div");
                tDiv.classList.add("formItem");
                tDiv.style.width = "50%";
                tDiv.innerText = subServicePr["faName"] + " : ";
                var tSpan = document.createElement("span");
                tDiv.setAttribute("bronzeValue", subServicePr["bronzeValue"]);
                tDiv.setAttribute("silverValue", subServicePr["silverValue"]);
                tDiv.setAttribute("goldValue", subServicePr["goldValue"]);
                tDiv.setAttribute("diamondValue", subServicePr["diamondValue"]);
                tDiv.setAttribute("unitVal", subServicePr["unitVal"]);
                $("#sla-parameters")[0].appendChild(tDiv);
                tDiv.appendChild(tSpan);
            }
        }
    }

    sendSubServiceParametersReq();

    function sendExistPayTypeReq() {
        $("input[name=pay-type]").prop("disabled", true);
        $("input[name=subs-duration]").prop("disabled", true);
        $("input[name=pay-period]").prop("disabled", true);
        $("input[name=sla-type]").prop("disabled", true);

        var xmlHttp = new XMLHttpRequest();
        var subServiceId = subServiceSelect.value;
        var url = "../../api/get-exists-service-for-pay-type.jsp?sub-service-id=" + subServiceId;
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var myArr = JSON.parse(this.responseText);
                existPayTypeReceived(myArr);
            }
        };
        xmlHttp.open("GET", url, true);
        xmlHttp.send();
        function existPayTypeReceived(arr) {
            $("input[name=pay-type]").each(function () {
                $(this).prop("disabled", !arr[$(this).val()])
            });
            if ($("input[name=pay-type]:checked").val() != undefined) {
                $('input[type=radio][name=pay-type]').first().change();
            }
        }
    }

    sendExistPayTypeReq();
};
