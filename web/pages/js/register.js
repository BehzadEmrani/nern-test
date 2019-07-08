var stateSelect = document.getElementById("select-state");
var citySelect = document.getElementById("select-city");
var typeSelect = document.getElementById("select-type");

$("#request-form").popover({
    html: true,
    trigger: 'hover',
    placement: 'top',
    content: "<p>نمونه فرم درخواست عضویت را دریافت و در سربرگ موسسه خود قرار داده سپس فرم تکمیل شده را با فرمت pdf ضمیمه کنید</p>"
});
$("#request-form").popover('show');
setTimeout(function () {
    $("#request-form").popover('hide');
}, 2000);
var internalDiv = document.getElementById("internal-code-div");
var nationalDiv = document.getElementById("uni-national-id-div");
var bothDiv = document.getElementById("both-div");
var internalInput = internalDiv.getElementsByTagName("input")[0];
var nationalInput = nationalDiv.getElementsByTagName("input")[0];
var bothNational = document.getElementById("bNational");
var bothInternal = document.getElementById("bInternal");
typeSelect.onchange = function () {
    var sourceVal = this.options[this.selectedIndex].getAttribute("source");
    if (sourceVal == 0) {
        nationalDiv.style.display = "";
        internalDiv.style.display = "none";
        bothDiv.style.display = "none";
        nationalInput.name = "uni-national-id";
        internalInput.name = "";
        bothNational.name = "";
        bothInternal.name = "";
    } else if (sourceVal == 4) {
        internalDiv.style.display = "none";
        nationalDiv.style.display = "none";
        bothDiv.style.display = "";
        internalInput.name = "";
        nationalInput.name = "";
        bothNational.name = "uni-national-id";
        bothInternal.name = "internal-code";
    } else {
        internalDiv.style.display = "";
        nationalDiv.style.display = "none";
        bothDiv.style.display = "none";
        internalInput.name = "internal-code";
        nationalInput.name = "";
        bothNational.name = "";
        bothInternal.name = "";
    }
};

stateSelect.onchange = function () {
    if (stateSelect.options[stateSelect.selectedIndex].value)
        stateSelect.style.borderColor = "green";
    else
        stateSelect.style.borderColor = "red";
    var xmlhttp = new XMLHttpRequest();
    var stateId = stateSelect.options[stateSelect.selectedIndex].value;
    var pishCode = stateSelect.options[stateSelect.selectedIndex].getAttribute("pishCode");
    document.getElementById("pish-tel").value = pishCode;
    document.getElementById("pish-fax").value = pishCode;
    document.getElementById("a-pish-tel").value = pishCode;
    document.getElementById("a-pish-fax").value = pishCode;
    var url = "../../api/get-city-by-state-id.jsp?state-id=" + stateId;
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            myFunction(myArr);
        }
    };
    xmlhttp.open("GET", url, true);
    xmlhttp.send();

    function myFunction(arr) {
        citySelect.innerHTML = "<option value=\"\" disabled selected hidden>شهر مورد نظر را انتخاب کنید&nbsp;...</option>";
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
        if (citySelect.getAttribute("selected-id")) {
            var options1 = citySelect.options;
            for (var i = 0; i < options1.length; i++) {
                var option = options1[i];
                if (option.value == citySelect.getAttribute("selected-id"))
                    option.selected = "selected";
                citySelect.onchange();
            }
        }
    }
};

citySelect.onchange = function () {
    if (citySelect.options[citySelect.selectedIndex].value)
        citySelect.style.borderColor = "green";
    else
        citySelect.style.borderColor = "red";
    var selctedOption = citySelect.options[citySelect.selectedIndex];

    var map=maps[0];
    map.getView().setCenter(ol.proj.transform([Number(selctedOption.getAttribute("lng")),
        Number(selctedOption.getAttribute("lat"))], 'EPSG:4326', 'EPSG:3857'));
    map.getView().setZoom(selctedOption.getAttribute("zoom"));
};

if (stateSelect.getAttribute("selected-id")) {
    var options = stateSelect.options;
    for (var i = 0; i < options.length; i++) {
        var option = options[i];
        if (option.value == stateSelect.getAttribute("selected-id"))
            option.selected = "selected";
    }
    stateSelect.onchange();
}
