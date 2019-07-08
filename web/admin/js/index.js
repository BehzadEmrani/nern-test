// function loginIntoCacti(username, password) {
//     var form = new FormData();
//     form.append("action", "login");
//     form.append("login_username", "cra");
//     form.append("login_password", "1020304050cra");
//
//     var settings = {
//         "async": true,
//         "crossDomain": true,
//         "url": "http://172.20.1.242/index.php",
//         "method": "POST",
//         "processData": false,
//         "contentType": false,
//         "mimeType": "multipart/form-data",
//         "data": form
//     };
//
//     $.ajax(settings).done(function (response) {
//         console.log(response);
//         $("#iframe").attr('src', 'http://172.20.1.242/graph_view.php');
//     });
// }


function sendCactiLogin() {
    $("#iframe").attr('src', 'http://172.20.1.242/logout.php');
    $("#iframe")[0].onload = function () {
        $("#iframe")[0].onload = null;
        document.forms['auth_cacti1'].submit();
        // $("#iframe").attr('src', 'http://172.20.1.242/graph_view.php');
    };
}