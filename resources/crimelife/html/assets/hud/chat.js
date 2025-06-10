const messages = [];
var messageIndex = -1;

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.a) {
            case 'OpenChat': {
                $('.chat').fadeIn(125);
                $('.chat').focus();
                break;
            }
        }
    });

    $(document).keydown(function (e) {
        if ($('.chat').is(':visible')) {
            switch (e.keyCode) {
                case 13: {
                    const message = $('.chat').val();
                    if (message.trim().length > 0) {
                        $.post(
                            `https://${GetParentResourceName()}/chat`,
                            JSON.stringify({
                                message: message,
                            }),
                        );
                        messages.push(message);
                        $('.chat').val('');
                        $('.chat').fadeOut(125);
                    } else {
                        closeAll()
                    }
                    e.preventDefault();
                    break;
                }

                case 38: // up
                    if (messages[0] && messageIndex != messages.length - 1) {
                        messageIndex++;
                        $('.chat').val(
                            messages[messages.length - 1 - messageIndex],
                        );
                    }
                    break;

                case 40: // down
                    if (messages[0] && messageIndex - 1 > -1) {
                        messageIndex--;
                        $('.chat').val(
                            messages[messages.length - 1 - messageIndex],
                        );
                    } else {
                        messageIndex = -1;
                        $('.chat').val('');
                    }
                    break;

            }
        }
    });
});