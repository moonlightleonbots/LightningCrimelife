$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'factionmenu:open': {
                const data = i.data
                $('.factionmenu').fadeIn(125)
                $('.factionMembersAppend').empty()
                $('.leftBottomHeader').text(data.count + " Online")

                for ([key, value] of Object.entries(data.members)) {
                    $('.factionMembersAppend').append(`
                            <div class="factionMemberItem ${value.status}">
                                <div class="factionMemberShadow"></div>
                                <i id="factionMemberIcon" class="fa-solid fa-user"></i>
                                <span>${value.name}</span>
                                <span>Rang: ${value.grade_label}</span>

                                <div class="factionMemberActionContainer">
                                    <i class="fa-regular fa-arrow-up" onclick="uprank('${value.identifier}')"></i>
                                    <i class="fa-regular fa-arrow-down" onclick="derank('${value.identifier}')"></i>
                                    <i class="fa-regular fa-trash" onclick="kick('${value.identifier}')"></i>
                                </div>
                            </div>
                        `)
                }

                break;
            }

            case 'chat:receiveMessage': {
                $('.chatAppend').append(`
                    <div class="chatItem">
                        <span>${i.author} <br></span>
                        <span>${i.message}</span>
                    </div>
                `)
                break;
            }

            case 'chat:receiveMessage:you': {
                $('.chatAppend').append(`
                    <div class="chatItem me">
                        <span>${i.author} <br></span>
                        <span>${i.message}</span>
                    </div>
                `)
                break;
            }
        }
    });
});

function chat_send() {
    const message = $('#faction_chatInput').val()
    if (message.length > 0) {
        $.post(`https://${GetParentResourceName()}/chatSendMessage`, JSON.stringify(message))
        $('#faction_chatInput').val('')
    }
}

function uprank(identifier) {
    $.post(`https://${GetParentResourceName()}/uprank`, JSON.stringify(identifier))
}

function derank(identifier) {
    $.post(`https://${GetParentResourceName()}/derank`, JSON.stringify(identifier))
}

function kick(identifier) {
    $.post(`https://${GetParentResourceName()}/kick`, JSON.stringify(identifier))
}