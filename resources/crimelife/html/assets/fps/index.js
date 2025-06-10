$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'fps:draw': {
                if (i.toggle) {
                    $('.fps').fadeIn(125);
                    $('.fps span').text(i.fps);
                } else {
                    $('.fps').fadeOut(125);
                    setTimeout(() => {
                        $('.fps span').text("N/A");
                    }, 500);
                }
                break;
            }
        }
    });
});
