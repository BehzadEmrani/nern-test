$("#building-select").change(function () {
        $("input[type=submit]").prop("disabled",$("#building-select").val()==undefined)
});
$("#building-select").change();