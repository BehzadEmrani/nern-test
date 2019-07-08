var maps = [];
function initMaps() {
    //markerMaps
    var mapShowEl = $(".mapShow");
    mapShowEl.each(function (index, item) {
        var coordinates = ol.proj.fromLonLat([Number($(item).attr("lng")), Number($(item).attr("lat"))]);
        $(item).attr("id", "olMap" + index);
        var map = new ol.Map({
            target: "olMap" + index,
            key: '92c963c181a6f92a0ecf752432e6658c540c820c',
            view: new ol.View({
                center: coordinates,
                zoom: 17
            })
        });
        var markerIcon = new ol.geom.Point(coordinates);
        var iconFeature = new ol.Feature({
            geometry: markerIcon
        });
        var iconStyle = new ol.style.Style({
            image: new ol.style.Icon(({
                anchor: [0.5, 1],
                anchorXUnits: 'fraction',
                anchorYUnits: 'fraction',
                size: [24, 40],
                opacity: 1,
                src: '/images/marker-48.png'
            }))
        });

        iconFeature.setStyle(iconStyle);

        var vectorSource = new ol.source.Vector({
            features: [iconFeature]
        });
        var layer = new ol.layer.Vector({
            source: vectorSource
        });
        map.addLayer(layer);
        maps.push(maps);
    });

    //chooseMaps
    var mapChooseEl = $(".mapChoose");
    mapChooseEl.each(function (index, item) {
        var markerIcon = null;
        var centerLoc = null;
        $(item).attr("id", "olcMap" + index);

        if ($(item).attr("lat") == null)
            centerLoc = ol.proj.fromLonLat([51.338076, 35.699756]);
        else
            centerLoc = ol.proj.fromLonLat([Number($(item).attr("lng")), Number($(item).attr("lat"))]);

        var map = new ol.Map({
            target: "olcMap" + index,
            key: '92c963c181a6f92a0ecf752432e6658c540c820c',
            view: new ol.View({
                center: centerLoc,
                zoom: 11
            })
        });
        map.setMapType('neshan');
        maps.push(map);
        map.on('click', function (evt) {
            var coordinates = evt.coordinate;
            if (markerIcon == null) {
                markerIcon = new ol.geom.Point(evt.coordinate);
                var iconFeature = new ol.Feature({
                    geometry: markerIcon
                });
                var iconStyle = new ol.style.Style({
                    image: new ol.style.Icon(({
                        anchor: [0.5, 1],
                        anchorXUnits: 'fraction',
                        anchorYUnits: 'fraction',
                        size: [24, 40],
                        opacity: 1,
                        src: '/images/marker-48.png'
                    }))
                });

                iconFeature.setStyle(iconStyle);

                var vectorSource = new ol.source.Vector({
                    features: [iconFeature]
                });
                var layer = new ol.layer.Vector({
                    source: vectorSource
                });
                map.addLayer(layer);
            } else {
                markerIcon.setCoordinates(evt.coordinate);
            }
            var latLonCoord = ol.proj.transform(evt.coordinate, 'EPSG:3857', 'EPSG:4326');

            var latId = "#" + $(item).attr("lat-input-id");
            var lngId = "#" + $(item).attr("lng-input-id");
            $(latId).val(latLonCoord[1]);
            $(lngId).val(latLonCoord[0]);
        });
    });
}

function dropDown() {
    var x = document.getElementById("topnav");
    if (x.className === "topnav") {
        x.className += " responsive";
    } else {
        x.className = "topnav";
    }
}

function langDropDown() {
    var x = document.getElementById("langGP");
    if (x.className === "lanGroup") {
        x.className = "langResponsive";
    }
    else {
        x.className = "lanGroup"
    }
}

var isOpen = true;

function toggleNav() {
    if (isOpen)
        closeNav();
    else
        openNav();
    isOpen = !isOpen;
}

function openNav() {
    var x = document.getElementById("sideNav");
    x.style.width = "260px";
    width = document.getElementById('mainFrame').offsetWidth;
    if (width > 768) {
        document.getElementById("mainFrame").style.marginRight = "270px";
    } else {
        x.style.borderLeft = "1px solid black";
    }
}

function closeNav() {
    var x = document.getElementById("sideNav");
    x.style.width = "0";
    x.style.borderLeft = "";
    document.getElementById("mainFrame").style.marginRight = "0";
}

function itemSelected(pr1) {
    var x = document.getElementById('mainFrame').offsetWidth;
    if (x <= 768) {
        closeNav();
    }
    if (pr1 instanceof MouseEvent)
        highLightSelectedByElement(pr1.target);
    else if (pr1)
        highLightSelected(pr1);
}

function highLightSelected(link) {
    var iframeEl = document.getElementById("iframe");
    if (iframeEl) {
        var iframeLink = iframeEl.getAttribute("src");
        if (link)
            iframeLink = link;
        var subs = document.getElementsByClassName("sub");
        var headers = document.getElementsByClassName("collapse-header");
        for (var i = 0; i < headers.length; i++) {
            var header = headers[i];
            if (header.getAttribute("href") == iframeLink)
                header.parentElement.classList.add("selectedLinkHeader");
            else
                header.parentElement.classList.remove("selectedLinkHeader");
        }
        for (var i = 0; i < subs.length; i++) {
            var sub = subs[i];
            if (sub.getAttribute("href") == iframeLink) {
                sub.classList.add("selectedLink");
                sub.parentElement.previousElementSibling.classList.add("selectedLinkHeader");
            }
            else
                sub.classList.remove("selectedLink");
        }
    }
}

function highLightSelectedByElement(clickedEl) {
    var subs = document.getElementsByClassName("sub");
    var headers = document.getElementsByClassName("collapse-header");
    for (var k = 0; k < headers.length; k++) {
        var header = headers[k];
        header.parentElement.classList.remove("selectedLinkHeader");
    }
    for (var l = 0; l < subs.length; l++) {
        var sub = subs[l];
        sub.classList.remove("selectedLink");
    }
    clickedEl.classList.add("selectedLink");
}

highLightSelected();

if (document.getElementById("sideNav") != null) {
    document.body.onload = function () {
        width = document.body.offsetWidth;
        var id = document.body.id;
        if (width <= 768) {
            closeNav();
        }
    };
}


var formStatusAr = {};

function validateForm(id) {
    if (id == "#send-form") {
        var internalDiv = document.getElementById("internal-code-div");
        var nationalDiv = document.getElementById("uni-national-id-div");
        var bothDiv = document.getElementById("both-div");
        var internalInput, nationalInput;
        if (internalDiv) {
            if (internalDiv.style.display == "none" && bothDiv.style.display == "none")
                delete formStatusAr["internal-code"];
            else
                formStatusAr["internal-code"] = false;
        }
        if (nationalDiv) {
            if (nationalDiv.style.display == "none" && bothDiv.style.display == "none")
                delete formStatusAr["uni-national-id"];
            else
                formStatusAr["uni-national-id"] = false;
        }
    }
    if (!formValid) {
        var $inputs = $(id + ' :input');
        $inputs.each(function () {
            if (formStatusAr[$(this)[0].name] != undefined)
                if ($(this)[0].id != "select-state" && $(this)[0].id != "select-city")
                    if ($(this)[0].onchange) {
                        $(this)[0].onchange();
                    }
        });
    }
    var formValid = true;
    $.each(formStatusAr, function (key, value) {
        if ($(id + " input[name=" + key + "]").length > 0) {
            if (!value) {
                formValid = false;
            }
        }
    });
    if (id == "#send-form") {
        var select1 = document.getElementById("select-type");
        var selectValid = true;
        if (select1.options[select1.selectedIndex].value == "" && select1.getAttribute("isEdit") == undefined)
            selectValid = false;
        if (selectValid) {
            select1.style.borderColor = "green";
        } else {
            select1.style.borderColor = "red";
        }
        if (!selectValid)
            formValid = false;
    }
    if (id == "#send-pre-data") {
        var select2 = document.getElementById("select-source");
        var selectValid = true;
        if (!select2.options[select2.selectedIndex].value)
            selectValid = false;
        if (selectValid) {
            select2.style.borderColor = "green";
        } else {
            select2.style.borderColor = "red";
        }
        if (!selectValid)
            formValid = false;
    }
    if (id == "#uni-info") {
        var citySelect1 = document.getElementById("select-state");
        var stateSelect1 = document.getElementById("select-city");
        var selectArr = [citySelect1, stateSelect1];
        for (var i = 0; i < selectArr.length; i++) {
            var select1 = selectArr[i];
            var selectValid = true;
            if (!select1.options[select1.selectedIndex].value)
                selectValid = false;
            if (selectValid) {
                select1.style.borderColor = "green";
            } else {
                select1.style.borderColor = "red";
            }
        }
        if (!selectValid)
            formValid = false;
    }
    if (document.getElementById("password")) {
        var passInput = document.getElementById("password");
        var rePassInput = document.getElementById("re-password");
        if (rePassInput.value == passInput.value) {
            passInput.style.borderColor = "green";
            $("#password").popover('hide');
        } else {
            formValid = false;
            passInput.style.borderColor = "red";
            $("#password").popover({
                html: true,
                trigger: 'focus',
                placement: 'top',
                content: "<p>تکرار رمز عبور با رمز عبور یکسان نیست.</p>"
            });
            $("#password").popover('show');
        }
    }

    return formValid;
}

$('body').on('keypress', 'input.persianInput', function (e) {
    // backspace, delete, tab, escape, enter
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
        // Ctrl+A
        ( ( e.charCode == 65 || e.charCode == 97 ) && e.ctrlKey === true ) ||
        // home, end, left, right
        ( e.keyCode >= 35 && e.keyCode <= 39 )) {
        return;
    }

    if (-1 == $.inArray(String.fromCharCode(e.charCode), ['‌', ' ', 'آ', 'ا', 'ب', 'پ', 'ت', 'ث', 'ج', 'چ', 'ح', 'خ',
            'د', 'ذ', 'ر', 'ز', 'ژ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ک', 'گ', 'ل', 'م', 'ن', 'و', 'ه', 'ی', 'ي', 'ك', 'ئ', 'ؤ', 'ة'])) {
        e.preventDefault();
        $(this).popover({
            html: true,
            trigger: 'focus',
            placement: 'top',
            content: "<p>تنها کاراکتر های فارسی مجاز است!</p>"
        });
        $(this)[0]["data-content"] = "<p>تنها کاراکتر های فارسی مجاز است!</p>";
        $(this).popover('show');
    } else {
        $(this).popover('hide');
    }

});

$('body').on('keypress', 'input.addressInput', function (e) {

    if (-1 == $.inArray(String.fromCharCode(e.charCode), ['‌', ' ', 'آ', 'ا', 'ب', 'پ', 'ت', 'ث', 'ج', 'چ', 'ح', 'خ',
            'د', 'ذ', 'ر', 'ز', 'ژ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ک', 'گ', 'ل', 'م', 'ن', 'و', 'ه', 'ی', 'ي', 'ك', 'ئ', 'ؤ', 'ة'
            , '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹', '۰', '-', 'ـ', '-', '_', '+', '/', '،', '؛', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'])) {
        e.preventDefault();
        $(this).popover({
            html: true,
            trigger: 'focus',
            placement: 'top',
            content: "<p>کاراکتر های انگلیسی غیر مجاز است!</p>"
        });
        $(this)[0]["data-content"] = "<p>کاراکتر های انگلیسی غیر مجاز است!</p>";
        $(this).popover('show');
    } else {
        $(this).popover('hide');
    }

});

$("input.persianInput").each(function () {
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
                placement: 'top',
                content: "<p>لطفا به این قسمت را کامل کنید</p>"
            });
            $(this).popover('show');
        }
    }
});

$("input.addressInput").each(function () {
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
                placement: 'top',
                content: "<p>لطفا به این قسمت را کامل کنید</p>"
            });
            $(this).popover('show');
        }
    }
});

$('body').on('keypress', 'input.numberInput', function (e) {
    // backspace, delete, tab, escape, enter
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
        // Ctrl+A
        ( ( e.charCode == 65 || e.charCode == 97 ) && e.ctrlKey === true ) ||
        // home, end, left, right
        ( e.keyCode >= 35 && e.keyCode <= 39 )) {
        return;
    }

    if (-1 == $.inArray(String.fromCharCode(e.charCode),
            ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'
                , '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹', '۰',
                '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٨', '٩', '٠'])) {
        e.preventDefault();
    }

});

$(".mapChoose").each(function (index, item) {
    var latId = "#" + $(item).attr("lat-input-id");
    var lngId = "#" + $(item).attr("lng-input-id");
    var latEl = $(latId);
    formStatusAr[latEl.attr("name")] = false;
    latEl[0].onchange= function () {
        var isMapValid = latEl.val() != "";
        formStatusAr[latEl.attr("name")] = isMapValid;
        if (isMapValid) {
            item.style.borderColor = "green";
            $(item).popover('hide');
        } else {
            item.style.borderColor = "red";
            $(item).popover({
                html: true,
                trigger: 'maual',
                placement: 'top',
                content: "<p>لطفا موقعیت مورد نظر را روی نقشه مشخص کنید.</p>"
            });
            $(item).popover('show');
        }
    };
});

$("input.numberInput").each(function () {
    var inputElement = $(this)[0];
    var inputName = inputElement.name;
    formStatusAr[inputName] = false;
    inputElement.onchange = function () {
        var isNumberValid = false;
        var maxLength = inputElement.maxLength;
        var minLength = parseInt(inputElement.getAttribute("minLength"));
        if (!isNaN(minLength)) {
            isNumberValid = inputElement.value.length >= minLength && inputElement.value.length <= maxLength;
        } else {
            isNumberValid = inputElement.value.length == maxLength;
        }
        formStatusAr[inputName] = isNumberValid;
        if (isNumberValid) {
            inputElement.style.borderColor = "green";
            $(this).popover('hide');
        } else {
            inputElement.style.borderColor = "red";
            $(this).popover({
                html: true,
                trigger: 'focus',
                placement: 'top',
                content: "<p>تعداد ارقام وارد شده کم است!</p>"
            });
            $(this).popover('show');
        }
    }
});

var fileInputs = document.getElementsByClassName("formFileInput");
var fileInputTxts = document.getElementsByClassName("formFileInputTxt");
var fileInputBtns = document.getElementsByClassName("formFileInputBtn");

function fileInputAddListener(fileInput, fileInputTxt, fileInputBtn, inputName) {
    formStatusAr[inputName] = false;
    fileInputBtn.onclick = function () {
        fileInput.click();
    };
    fileInput.onchange = function (evt) {
        if (!fileInput.disabled) {
            var fileName = "";
            if (evt != undefined) {
                fileName = evt.target.files[0].name;
            } else {
                fileName = fileInputTxt.value;
            }
            fileInputTxt.value = fileName;
            var isFileSelected = fileInput.value != "";
            var re = /(?:\.([^.]+))?$/;
            var isFilePdf = re.exec(fileName)[1] == "pdf";
            if (!isFilePdf) {
                isFilePdf = fileInput.accept == ".png,.jpg";
            }
            if (isFileSelected && isFilePdf) {
                fileInputTxt.style.borderColor = "green";
                $(".formFileInputBtn").popover('hide');
            } else if (isFileSelected && !isFilePdf) {
                fileInputTxt.style.borderColor = "red";
                $(".formFileInputBtn").popover({
                    html: true,
                    trigger: 'focus',
                    placement: 'top',
                    content: "<p>تنها فایل ها با پسوند pdf مجاز است.</p>"
                });
                $(".formFileInputBtn").popover('show');
            } else {
                fileInputTxt.style.borderColor = "red";
                $(".formFileInputBtn").popover({
                    html: true,
                    trigger: 'focus',
                    placement: 'top',
                    content: "<p>فایل مورد نظر را انتخاب کنید!</p>"
                });
                $(".formFileInputBtn").popover('show');
            }
            formStatusAr[inputName] = isFileSelected && isFilePdf;
        } else
            formStatusAr[inputName] = true;
    }
}

for (var i = 0; i < fileInputs.length; i++) {
    fileInputAddListener(fileInputs[i], fileInputTxts[i], fileInputBtns[i], fileInputs[i].name);
}

function isYearLeap(year) {
    var a = 0.025;
    var b = 266;
    var leapDays0, leapDays1;
    var frac0, frac1;
    if (year > 0) {
        leapDays0 = ((year + 38) % 2820) * 0.24219 + a;
        leapDays1 = ((year + 39) % 2820) * 0.24219 + a;
    } else if (year < 0) {
        leapDays0 = ((year + 39) % 2820) * 0.24219 + a;
        leapDays1 = ((year + 40) % 2820) * 0.24219 + a;
    } else return false;
    frac0 = parseInt((leapDays0 - parseInt(leapDays0) ) * 1000);
    frac1 = parseInt((leapDays1 - parseInt(leapDays1) ) * 1000);

    return frac0 <= b && frac1 > b;
}

var dateYears = document.getElementsByClassName("dateYear");
var dateMonths = document.getElementsByClassName("dateMon");
var dateDays = document.getElementsByClassName("dateDay");

function yearOrMonthChanged(dateYearEl, dateMonthEl, dateDateEl) {
    var numberOfDays = 30;
    if (dateMonthEl.value == 12)
        numberOfDays = 29;
    if (dateMonthEl.value < 7)
        numberOfDays = 31;
    else if (isYearLeap(parseInt(dateYearEl.value)))
        numberOfDays = 30;
    var newDayDateValue = dateDateEl.getAttribute("current-date");
    var newDayDate = (newDayDateValue < 10 ? "0" + newDayDateValue : newDayDateValue);
    if (dateDateEl.value)
        newDayDate = dateDateEl.value;
    if (numberOfDays < newDayDate)
        newDayDate = numberOfDays;
    dateDateEl.innerHTML = "";
    for (var j = 1; j <= numberOfDays; j++) {
        var option = document.createElement("option");
        option.text = j;
        option.value = (j < 10 ? "0" + j : j);
        dateDateEl.add(option);
    }
    dateDateEl.value = newDayDate;
}

for (var i = 0; i < dateMonths.length; i++) {
    var dateYear = dateYears[i];
    var dateMonth = dateMonths[i];
    var dateDay = dateDays[i];
    dateMonth.onchange = function () {
        yearOrMonthChanged(dateYear, dateMonth, dateDay)
    };
    dateYear.onchange = function () {
        yearOrMonthChanged(dateYear, dateMonth, dateDay)
    };
    yearOrMonthChanged(dateYear, dateMonth, dateDay)
}

function validateEmail(input) {
    var email = input.value;
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var valid = re.test(email);
    return valid;
}

$("input.emailInput").each(function () {
    var inputElement = $(this)[0];
    var inputName = inputElement.name;
    formStatusAr[inputName] = false;
    inputElement.onchange = function () {
        var isEmailValid = validateEmail(inputElement);
        formStatusAr[inputName] = isEmailValid;
        if (isEmailValid) {
            inputElement.style.borderColor = "green";
            $(this).popover('hide');
        } else {
            inputElement.style.borderColor = "red";
            $(this).popover({
                html: true,
                trigger: 'focus',
                placement: 'bottom',
                title: "<p>فرمت ورودی اشتباه است!</p>",
                content: "<p>ایمیل می تواند شامل حروف انگلیسی و اعداد و کارکتر های !#$%&'*+-/=?^_`{|}~. باشد و فرمت آن به شکل: example@example.com است.</p>"
            });
            $(this).popover('show');
        }
    }
});

$("input.notEmptyInput").each(function () {
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

function validateSiteAddress(input) {
    var regexp = /(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g;
    var siteAddrValid = regexp.test(input);
    if (input.split('.').length < 2)
        siteAddrValid = false;
    return siteAddrValid;
}

$("input.domainInput").each(function () {
    var inputElement = $(this)[0];
    var inputName = inputElement.name;
    formStatusAr[inputName] = false;
    inputElement.onchange = function () {
        var isSiteAddressValid = validateSiteAddress(inputElement.value);
        formStatusAr[inputName] = isSiteAddressValid;
        if (isSiteAddressValid) {
            inputElement.style.borderColor = "green";
            $(this).popover('hide');
        } else {
            inputElement.style.borderColor = "red";
            $(this).popover({
                html: true,
                trigger: 'focus',
                placement: 'top',
                content: "<p>لطفا آدرس صحیح سایت را وارد نمایید!<br>آدرس صحیح به فرم زیر می باشد<br>www.example.com</p>"
            });
            $(this).popover('show');
        }
    }
});

function validateUsername(input) {
    return /^[a-zA-Z0-9.\-_$@*!]{3,30}$/.test(input);
}

$("input.userNameInput").each(function () {
    var inputElement = $(this)[0];
    var inputName = inputElement.name;
    formStatusAr[inputName] = false;
    inputElement.onchange = function () {
        var isSiteAddressValid = validateUsername(inputElement.value);
        formStatusAr[inputName] = isSiteAddressValid;
        if (isSiteAddressValid) {
            inputElement.style.borderColor = "green";
            $(this).popover('hide');
        } else {
            inputElement.style.borderColor = "red";
            $(this).popover({
                html: true,
                trigger: 'focus',
                placement: 'top',
                content: "<p>" +
                "نام کاربری صحیح شامل حروف انگلیسی٫اعداد و کاراکتر های مقابل است : -_$@*!" +
                "</p>"
            });
            $(this).popover('show');
        }
    }
});

var countUps = document.getElementsByClassName("countUp");
$.each(countUps, function (i) {
    var countUp = countUps[i];
    var maxNum = countUp.getAttribute("upTo");
    var tempNum = 0;
    var interval = 1000 / maxNum;

    function counter() {
        countUp.innerHTML = tempNum;
        tempNum++;
        if (maxNum >= tempNum)
            setTimeout(counter, interval);
    }

    counter();
});
