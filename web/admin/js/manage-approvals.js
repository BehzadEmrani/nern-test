var changedForEdit = false;
$("select[name=sub-code]")[0].onchange = function sendSubTypeReq() {
    $("select[name=sub-type]>option").remove();
    var url = "../../api/get-subsystem-types-by-sub-code.jsp?sub-code=" + $("select[name=sub-code]>option:selected").val();
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            subTypeReq(myArr);
        }
    };
    xmlHttp.open("GET", url, true);
    xmlHttp.send();
    function subTypeReq(arr) {
        var fOption = document.createElement("option");
        fOption.text = "همه انواع";
        fOption.value = "-1";
        $("select[name=sub-type]").append(fOption);
        if (arr)
            arr.forEach(function (type) {
                var tOption = document.createElement("option");
                tOption.text = type["faStr"];
                tOption.value = type["value"];
                $("select[name=sub-type]").append(tOption);
            });
        var selectedIndex = $("select[name=sub-type]").attr("selected-index");
        if (!changedForEdit) {
            $("select[name=sub-type]").val(selectedIndex);
            changedForEdit = true;
        }
        if (!$("select[name=sub-type]").val())
            $("select[name=sub-type]").val("-1");
    }
};
$("select[name=sub-code]")[0].onchange();