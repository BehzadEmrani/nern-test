function getMapData(address) {
    $("#mapIframe").attr("src",address);
    $('#mapModal').modal('show');
}