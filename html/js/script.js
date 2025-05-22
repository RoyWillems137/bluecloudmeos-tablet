OpenPoliceTablet = function() {
    TabletOpen = true;
    $('.police-tablet').show(250);
}

CloseTablet = function() {
    TabletOpen = false;
    $('.police-tablet').hide(250);
    $.post(`https://${GetParentResourceName()}/CloseTablet`, JSON.stringify({}))
}

$(function () {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "OpenPoliceTablet":
                OpenPoliceTablet()
                break;
        }
    });
    window.onkeydown = function(e) {
        var e = e || window.event;
        if (e.keyCode === 27) {
            CloseTablet();
        }
    };
});


