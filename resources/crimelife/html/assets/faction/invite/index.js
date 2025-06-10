$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'faction:invite': {
                $('.invite').fadeIn(125)
                $('.invite-faction').html(`Fraktion: <span style="color: purple; font-family: Gilroy-Regular;">${i.faction}</span>`)
                $('.invite-name').html(`Inviter: ${i.name}`)
                break;
            }
        }
    });
});

function acceptInvite() {
    $.post(`https://${GetParentResourceName()}/acceptInvite`);
    closeAll()
}

function denyInvite() {
    $.post(`https://${GetParentResourceName()}/denyInvite`);
    closeAll()
}