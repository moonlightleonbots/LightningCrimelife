$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'showKillerUI': {
                $(".killstreak").fadeIn(125)
                $('.killed-money').fadeIn(125)
                $('.killed-player').fadeIn(125)

                if (i.midrolled) {
                    $('.killed-player').text(`${i.deathplayer.name} Midrolled`)
                    sound = new Audio('././sounds/midroll.mp3');
                    sound.volume = 1.0;
                    sound.play();
                } else {
                    $('.killed-player').text(`${i.deathplayer.name} Getötet`)
                }

                $('.killed-money').text(`+${i.money} $`)

                document.getElementById('me').textContent = i.killer.name
                document.getElementById('points_me').textContent = i.killer.points

                document.getElementById('enemy').textContent = i.deathplayer.name
                document.getElementById('points_enemy').textContent = i.deathplayer.points


                setTimeout(() => {
                    $(".killstreak").fadeOut(125)
                    $('.killed-money').fadeOut(125)
                    $('.killed-player').fadeOut(125)
                }, 2500);
                break;
            }
        }
    });
});
