var uniStateSelect = document.getElementById("uni-status-select");
var subStatusSelect = document.getElementById("sub-status-select");
var subsJson = eval('(' + subStatusSelect.getAttribute("json") + ')');
uniStateSelect.onchange = function () {
    var subsAr;
    var uniStatus = uniStateSelect.value;
    if (uniStatus == "2") {
        subsAr = subsJson[0];
    } else if (uniStatus == "1002") {
        subsAr = subsJson[1];
    }
    $('#sub-status-select').children('option').remove();
    for (var i = 0; i < subsAr.length; i++) {
        var subStatus = subsAr[i];
        var option = document.createElement("option");
        option.text = subStatus['faStr'];
        option.value = subStatus['value'];
        subStatusSelect.add(option);
    }
};
uniStateSelect.onchange();