var stateSelect = document.getElementById("state-select");
var citySelect = document.getElementById("city-select");
var telecomSelect = document.getElementById("telecom-select");
var equipTypeSelect = document.getElementById("type-select");
var equipSelect = document.getElementById("equip-select");
var parentSelect = document.getElementById("parent-select");

var parentSelectedIndexSelected = parentSelect.getAttribute("selected-index") == "";
equipSelect.onchange = function () {
    $(parentSelect).find("option").remove();
    $.getJSON("../api/get-parent-equip-by-telecom-id-and-equip-id.jsp?telecom-id=" + telecomSelect.value+"&equip-id="+equipSelect.value, function (dataAr) {
        for (var i = 0; i < dataAr.length; i++) {
            var data = dataAr[i];
            var option = $('<option/>');
            option.attr({'value': data["equipmentId"]}).text(data["equipmentTypeName"]+"[شماره اموال:"+data["equipmentName"]+"]");
            $(parentSelect).append(option);
        }
        if(dataAr.length==0){
            var option = $('<option/>');
            option.attr({'value': -1}).text("-");
            $(parentSelect).append(option);
        }
        if (!parentSelectedIndexSelected) {
            parentSelectedIndexSelected = true;
            $(parentSelect).val(parentSelect.getAttribute("selected-index"))
        }
    });
};

var equipSelectedIndexSelected = equipSelect.getAttribute("selected-index") == "";
equipTypeSelect.onchange = function () {
    $(equipSelect).find("option").remove();
    var dataAr=JSON.parse($(equipTypeSelect).attr("json"));
    for (var i = 0; i < dataAr.length; i++) {
        var data = dataAr[i];
        if (data["equipmentTypeId"]==equipTypeSelect.value) {
            var option = $('<option/>');
            option.attr({'value': data["equipmentId"]}).text(data["equipmentName"]);
            $(equipSelect).append(option);
        }
    }
    if (!equipSelectedIndexSelected) {
        equipSelectedIndexSelected = true;
        $(equipSelect).val(equipSelect.getAttribute("selected-index"))
    }
    equipSelect.onchange();
};

var equipTypeSelectedIndexSelected = equipTypeSelect.getAttribute("selected-index") == "";
telecomSelect.onchange = function () {
    $(equipTypeSelect).find("option").remove();
    $.getJSON("../api/get-installable-equip-by-telecom-id.jsp?telecom-id=" + telecomSelect.value, function (dataAr) {
        $(equipTypeSelect).attr("json", JSON.stringify(dataAr));
        for (var i = 0; i < dataAr.length; i++) {
            var data = dataAr[i];
            var isNewType = true;
            var typeOptions = $(equipTypeSelect).find("option");
            for (var j = 0; j < typeOptions.length; j++)
                if (typeOptions[j].value==data["equipmentTypeId"])
                    isNewType = false;
            if (isNewType) {
                var option = $('<option/>');
                option.attr({'value': data["equipmentTypeId"]}).text(data["equipmentTypeName"]);
                $(equipTypeSelect).append(option);
            }
        }
        if (!equipTypeSelectedIndexSelected) {
            equipTypeSelectedIndexSelected = true;
            $(equipTypeSelect).val(equipTypeSelect.getAttribute("selected-index"))
        }
        equipTypeSelect.onchange();
    });
};


var telecomSelectedIndexSelected = telecomSelect.getAttribute("selected-index") == "";
citySelect.onchange = function () {
    $(telecomSelect).find("option").remove();
    $.getJSON("../api/get-telecom-by-city-id.jsp?city-id=" + citySelect.value, function (dataAr) {
        for (var i = 0; i < dataAr.length; i++) {
            var data = dataAr[i];
            var option = $('<option/>');
            option.attr({'value': data["id"]}).text(data["name"]);
            $(telecomSelect).append(option);
        }
        if (!telecomSelectedIndexSelected) {
            telecomSelectedIndexSelected = true;
            $(telecomSelect).val(telecomSelect.getAttribute("selected-index"))
        }
        telecomSelect.onchange();
    });
};


var citySelectedIndexSelected = citySelect.getAttribute("selected-index") == "";
stateSelect.onchange = function () {
    $(citySelect).find("option").remove();
    $.getJSON("../api/get-city-by-state-id.jsp?state-id=" + stateSelect.value, function (dataAr) {
        for (var i = 0; i < dataAr.length; i++) {
            var data = dataAr[i];
            var option = $('<option/>');
            option.attr({'value': data["cityId"]}).text(data["name"]);
            $(citySelect).append(option);
        }
        if (!citySelectedIndexSelected) {
            citySelectedIndexSelected = true;
            $(citySelect).val(citySelect.getAttribute("selected-index"))
        }
        citySelect.onchange();
    });
};
stateSelect.onchange();


// var equipSelectedIndexSelected = equipTypeSelect.getAttribute("selected-index") == "";
// equipTypeSelect.onchange = function () {
//     $(equipSelect).find("option").remove();
//     $.getJSON("../api/get-installable-equip-by-telecom-id.jsp?telecom-id=" + telecomSelect.value, function (dataAr) {
//         for (var i = 0; i < dataAr.length; i++) {
//             var data = dataAr[i];
//             var option = $('<option/>');
//             option.attr({'value': data["id"]}).text(data["name"]);
//             $(telecomSelect).append(option);
//         }
//         if (!telecomSelectedIndexSelected) {
//             equipTypeSelectedIndexSelected = true;
//             $(equipTypeSelect).val(equipTypeSelect.getAttribute("selected-index"))
//         }
//     });
// };
