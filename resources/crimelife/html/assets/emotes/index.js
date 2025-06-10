var selectedEmote = 0

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'emoteRad':
                selectedEmote = 0
                $('.emoterad').fadeIn(125);
                break;
        }
    });
});

$('.rad1').mouseover(function () {
    selectedEmote = 1;
});
$('.rad2').mouseover(function () {
    selectedEmote = 2;
});
$('.rad3').mouseover(function () {
    selectedEmote = 3;
});
$('.rad4').mouseover(function () {
    selectedEmote = 4;
});
$('.rad5').mouseover(function () {
    selectedEmote = 5;
});
$('.rad6').mouseover(function () {
    selectedEmote = 6;
})
$('.rad7').mouseover(function () {
    selectedEmote = 7;
});
$('.rad8').mouseover(function () {
    selectedEmote = 8;
});

window.onkeyup = function (e) {
    if (!$('.chat').is(':visible')) {
        if ($('.emoterad').is(':visible')) {
            if (e.key.toLowerCase() === "b") {
                closeAll()
                if (selectedEmote > 0) {
                    $.post(`https://${GetParentResourceName()}/emote`, JSON.stringify(selectedEmote));
                }
            }
        }
    }
}