$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'deathscreen': {

                if (i.toggle) {
                    const table = i.data
                    $(".death").fadeIn(250);

                    $('.death-name').text(table.name)

                    $('#death-kills').text(table.kills)
                    $('#death-deaths').text(table.deaths)
                    $("#death-kd").text(table.kills > 0 ? table.deaths > 0 ? (table.kills / table.deaths).toFixed(2) : `${table.kills}.0` : "0.0");

                    document.getElementById("death-avatar").src = table.avatar;

                    var elem = document.getElementById("death_progress");
                    var val = Math.floor(2500 / 100);
                    var width = 0;
                    var id = setInterval(frame2, val);
                    function frame2() {
                        if (width >= 97) {
                            $(".death").fadeOut(250);
                        }

                        if (width >= 100) {
                            clearInterval(id);
                            width = 0;
                        } else {
                            width++;
                            elem.style.width = width + "%";
                        }
                    }

                } else {
                    $(".death").fadeOut(250);
                }
                break;
            }
        }
    });
});