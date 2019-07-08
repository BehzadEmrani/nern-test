var stateSelect = $("#state-select")[0];
var citySelect = $("#city-select")[0];
var setCityFTime = false;
stateSelect.onchange = function () {
    if (stateSelect.options[stateSelect.selectedIndex].value)
        stateSelect.style.borderColor = "green";
    else
        stateSelect.style.borderColor = "red";
    var xmlHttp = new XMLHttpRequest();
    var stateId = stateSelect.options[stateSelect.selectedIndex].value;
    var url = "../../api/get-city-by-state-id.jsp?state-id=" + stateId;
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            myFunction(myArr);
        }
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
    function myFunction(arr) {
        citySelect.innerHTML = "";
        for (var i = 0; i < arr.length; i++) {
            var y = arr[i];
            var option = document.createElement("option");
            option.text = y.name;
            option.value = y.cityId;
            option.setAttribute("lat", y["lat"]);
            option.setAttribute("lng", y["lng"]);
            option.setAttribute("zoom", y["zoom"]);
            citySelect.add(option);
        }
        if ($(citySelect).attr("selected-index") != undefined && !setCityFTime) {
            setCityFTime = true;
            $(citySelect).val($(citySelect).attr("selected-index"));
        }
        citySelect.onchange();
    }
};

citySelect.onchange = function () {
    if (citySelect.options[citySelect.selectedIndex])
        citySelect.style.borderColor = "green";
    else
        citySelect.style.borderColor = "red";

    var selctedOption = citySelect.options[citySelect.selectedIndex];
    maps[0].panTo(new google.maps.LatLng(selctedOption.getAttribute("lat"), selctedOption.getAttribute("lng")));
    maps[0].setZoom(parseInt(selctedOption.getAttribute("zoom")));
};

stateSelect.onchange();

var haveFreeCoreInputs = $("input[name=have-free-core]");
var freeCoreCountInputs = $("input[name=free-fiber-core-count],[name=fos-1],[name=fos-2]");
haveFreeCoreInputs.change(function () {
    if ($("input[name=have-free-core]:checked").val() == "true") {
        freeCoreCountInputs.prop("disabled", false);
        freeCoreCountInputs.each(function () {
            if (this.name != "fos-2") {
                var inputElement = $(this)[0];
                var inputName = inputElement.name;
                formStatusAr[inputName] = false;
                inputElement.onchange = function () {
                    var isInputValid = inputElement.value != "";
                    formStatusAr[inputName] = isInputValid;
                    if (isInputValid) {
                        inputElement.style.borderColor = "green";
                        $(this).popover('hide');
                    } else {
                        inputElement.style.borderColor = "red";
                        $(this).popover({
                            html: true,
                            trigger: 'focus',
                            placement: 'bottom',
                            content: "<p>این قسمت باید تکمیل شود!</p>"
                        });
                        $(this).popover('show');
                    }
                }
            }
        });
    } else {
        freeCoreCountInputs.prop("disabled", true);
        freeCoreCountInputs.each(function () {
            this.onchange = null;
            delete formStatusAr[this.name];
            this.style.borderColor = "black";
            $(this).popover('hide');
        });
    }
});
haveFreeCoreInputs.first().change();

var haveFiberInputs = $("input[name=have-fiber]");
var fiberYInputs = $("#have-fiber-y-box").find("input[name!=have-fiber]");
var fiberNInputs = $("#have-fiber-n-box").find("input[name!=have-fiber]");
haveFiberInputs.change(function () {
    if ($("input[name=have-fiber]:checked").val() == "true") {
        fiberNInputs.prop("disabled", true);
        fiberNInputs.each(function () {
            this.onchange = null;
            delete formStatusAr[this.name];
            this.style.borderColor = "black";
            $(this).popover('hide');
        });
        fiberYInputs.prop("disabled", false);
        fiberYInputs.each(function () {
            if (this.name != "fos-2") {
                var inputElement = $(this)[0];
                var inputName = inputElement.name;
                formStatusAr[inputName] = false;
                inputElement.onchange = function () {
                    var isInputValid = inputElement.value != "";
                    formStatusAr[inputName] = isInputValid;
                    if (isInputValid) {
                        inputElement.style.borderColor = "green";
                        $(this).popover('hide');
                    } else {
                        inputElement.style.borderColor = "red";
                        $(this).popover({
                            html: true,
                            trigger: 'focus',
                            placement: 'bottom',
                            content: "<p>این قسمت باید تکمیل شود!</p>"
                        });
                        $(this).popover('show');
                    }
                }
            }
        });
    } else {
        fiberYInputs.prop("disabled", true);
        fiberYInputs.each(function () {
            this.onchange = null;
            delete formStatusAr[this.name];
            this.style.borderColor = "black";
            $(this).popover('hide');
        });
        fiberNInputs.prop("disabled", false);
        fiberNInputs.each(function () {
            var inputElement = $(this)[0];
            var inputName = inputElement.name;
            formStatusAr[inputName] = false;
            inputElement.onchange = function () {
                var isInputValid = inputElement.value != "";
                formStatusAr[inputName] = isInputValid;
                if (isInputValid) {
                    inputElement.style.borderColor = "green";
                    $(this).popover('hide');
                } else {
                    inputElement.style.borderColor = "red";
                    $(this).popover({
                        html: true,
                        trigger: 'focus',
                        placement: 'bottom',
                        content: "<p>این قسمت باید تکمیل شود!</p>"
                    });
                    $(this).popover('show');
                }
            }
        });
    }
    haveFreeCoreInputs.first().change();
});
haveFiberInputs.first().change();

var agentBox = $("#agent-box");
var agentBoxInputs = agentBox.find("input");
var agentObj = eval('(' + agentBox.attr("agentJson") + ')');
var personalObj = eval('(' + agentBox.attr("personalJson") + ')');
var UserPrimaryInputs = $("input[name=use-primary-agent]");
UserPrimaryInputs.change(function () {
    if ($("input[name=use-primary-agent]:checked").val() == "true") {
        agentBoxInputs.prop("disabled", true);
        agentBoxInputs.each(function () {
            this.onchange = null;
            delete formStatusAr[this.name];
            this.style.borderColor = "black";
            $(this).popover('hide');
            if (this.name == "agent-fname") {
                this.value = personalObj["fname"];
            } else if (this.name == "agent-lname") {
                this.value = personalObj["lname"];
            } else if (this.name == "agent-national-code") {
                this.value = personalObj["nationalId"];
            } else if (this.name == "agent-pos") {
                this.value = agentObj["agentPos"];
            } else if (this.name == "agent-email") {
                this.value = agentObj["supportEmail"];
            } else if (this.name == "agent-tel") {
                this.value = agentObj["telNo"];
            } else if (this.name == "agent-fax") {
                this.value = agentObj["faxNo"];
            } else if (this.name == "agent-mob") {
                this.value = agentObj["mobileNo"];
            }
        });
    } else {
        agentBoxInputs.prop("disabled", false);
        agentBoxInputs.val("");
        agentBoxInputs.each(function () {
            var inputElement = $(this)[0];
            var inputName = inputElement.name;
            formStatusAr[inputName] = false;
            inputElement.onchange = function () {
                var isInputValid = inputElement.value != "";
                formStatusAr[inputName] = isInputValid;
                if (isInputValid) {
                    inputElement.style.borderColor = "green";
                    $(this).popover('hide');
                } else {
                    inputElement.style.borderColor = "red";
                    $(this).popover({
                        html: true,
                        trigger: 'focus',
                        placement: 'bottom',
                        content: "<p>این قسمت باید تکمیل شود!</p>"
                    });
                    $(this).popover('show');
                }
            }
        });
    }
});
UserPrimaryInputs.first().change();
