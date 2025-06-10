var notifyCount = 1

function HelpNotification(enable, btn, message) {
    if (enable) {
        $(".helpNotify").empty();
        $(".helpNotify").append(`
            <div class="helpIcon">
                <span>${btn}</span>
            </div>
            <span>${message}</span>
        `);
        $(".helpNotify").fadeIn(125);
    } else {
        $(".helpNotify").fadeOut(125);
    }
}

const addSpeed = (speed) => {
    if (speed === 0) return (speed = '000');
    else if (speed.toString().length <= 1) return '00' + speed;
    else if (speed.toString().length <= 2) return '0' + speed;
    return speed;
};

const updateSpeedBar = (currentSpeed, maxSpeed) => {
    const bars = document.querySelectorAll(".hud-kmh-bar-fill");
    let percentage = (currentSpeed / maxSpeed) * 100;

    // Wenn die aktuelle Geschwindigkeit Null ist, setzen wir die Prozentzahl auf Null
    if (currentSpeed === 0) {
        percentage = 0;
    }

    const barsToFill = (9 / 100) * percentage;
    const wholeBarsToFill = Math.floor(barsToFill);
    const restBarsToFill = barsToFill - wholeBarsToFill;

    bars.forEach((bar, index) => {
        if (index < wholeBarsToFill) {
            bar.style.width = "100%";
            bar.style.border = "1px solid var(--hud-speedo-fill-border)";
        } else if (index === wholeBarsToFill && restBarsToFill > 0) {
            bar.style.width = `${restBarsToFill * 100}%`;
            bar.style.border = "1px solid var(--hud-speedo-fill-border)";
        } else {
            bar.style.width = "0";
            bar.style.border = "none";
        }
    });
}

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'SetMap': {
                document.getElementById("hud-bottom-stats").style.left = `${i.left}%`;
                break;
            }
            case 'AddNotify': {
                notifyCount++;

                const element = $(`
					<div class="hud-notifcation-box">
						<div class="hud-notifcation-head">
						<div class="hud-notifcation-title hud-${i.type}">${i.title}</div>
						</div>
						<div class="hud-notification-text">
							${i.text}
						</div>
			
						<div class="hud-notification-progressbar">
							<div id="notify-id-${notifyCount}" class="hud-notification-progressbar-fill hud-${i.type}-progressbar"></div>
						</div>
					</div>
				`).appendTo('.hud-notification-container');
                $(`#notify-id-${notifyCount}`).animate({
                    width: '100%',
                }, i.time - 250);

                setTimeout(() => {
                    element.fadeOut(250)
                }, i.time - 250);

                break;
            }
            case 'updateKillFeed': {
                const killFeedItem = $(`
                    <div class="hud-killfeed-item">
                        <div class="hud-killfeed-killer">
                            <span id="killer">${i.killer}</span>
                        </div>
            
                        <div class="hud-killfeed-middle">
                            <i class="fa-solid fa-gun"></i>
                        </div>
            
                        <div class="hud-killfeed-killed">
                            <span id="killed">${i.victim}</span>
                        </div>
                    </div>
                `);

                killFeedItem.appendTo('.hud-killfeed');

                setTimeout(() => {
                    killFeedItem.css('animation', 'fadeOutFromLeft 0.5s ease-in-out forwards');
                    setTimeout(() => {
                        killFeedItem.hide();
                    }, 500);
                }, 4000);

                break;
            }
            case 'AddAnnounce': {
                notifyCount++;
                const element =
                    $(` <div class="hud-top-announcement-box">
						<div class="hud-announcement-head">
							<div class="hud-announcement-title">${i.title}</div>
							<svg class=hud-announcement-design fill=none viewBox="0 0 92 12"xmlns=http://www.w3.org/2000/svg><mask height=12 id=mask0_528_2 maskUnits=userSpaceOnUse style=mask-type:alpha width=92 x=0 y=0><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 0 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 6.50848 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 13.0169 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 19.5254 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 26.0338 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 32.5423 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 39.0508 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 45.5592 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 52.0677 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 58.5762 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 65.0846 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 71.5931 11.4756)"width=12 /><rect fill=red height=3 transform="matrix(0.292372 -0.956305 1 0 78.1015 11.4756)"width=12 /><rect fill=#D9D9D9 height=3 transform="matrix(0.292372 -0.956305 1 0 84.61 11.4756)"width=12 /></mask><g mask=url(#mask0_528_2)><ellipse cx=45.5 cy=6 fill=url(#announce-fill-bg-${notifyCount}) rx=15 ry=60.5 transform="rotate(-90 45.5 6)"/></g><defs><radialGradient cx=0 cy=0 gradientTransform="translate(45.5 7.47561) rotate(73.53) scale(52.9076 70.3034)"gradientUnits=userSpaceOnUse id=announce-fill-bg-${notifyCount} r=1><stop class=hud-config-announcement-design stop-color=#ff0000 /><stop offset=1 stop-opacity=0 /></radialGradient></defs></svg>
						</div>
			
						<div class="hud-announcement-text">
							${i.text}
						</div>
			
					<div class="hud-announcement-progressbar">
						<div id="announce-id-${notifyCount}" class="hud-announcement-progressbar-fill"></div>
					</div>
				</div>`).appendTo('.hud-top-center')

                $(`#announce-id-${notifyCount}`).animate({
                    width: '100%',
                }, i.time - 250);

                setTimeout(() => {
                    element.fadeOut(300);
                    setTimeout(() => element.remove(), 300);
                }, i.time);
                break;
            }
            case 'ToggleSpeedo': {
                if (i.bool) {
                    $('.hud-speedo-container').fadeIn();
                    $('.hud-bottom-kmh-text').text(addSpeed(i.speed));
                    updateSpeedBar(i.speed, 350)
                } else $('.hud-speedo-container').fadeOut();
                break;
            }
            case 'Bar': {
                if (i.toggle) {
                    $('.hud-bottom-center').fadeIn(125);
                } else {
                    $('.hud-bottom-center').fadeOut(125);
                }

                const prog = $('.hud-progressbar-fill');
                if (i.time == 0) {
                    prog.stop();
                    $('.hud-progressbar-percentage').text('ABGEBROCHEN');
                    prog.css({
                        background: '#FF3030',
                        boxShadow: '0 0 1vh #FF3030',
                    });
                    $('.hud-bottom-center').fadeOut(550);
                    setTimeout(() => {
                        prog.css('width', 0);
                        $('.hud-progressbar-percentage').text('');
                    }, 550);
                } else
                    prog.stop()
                        .css({
                            width: 0,
                            background: '#FFF',
                            boxShadow: '0 0 1vh rgba(255, 255, 255, 1)',
                        })
                        .animate(
                            { width: '100%' },
                            {
                                duration: i.time,
                                progress: (event, progress) =>
                                    $('.hud-progressbar-percentage').text(
                                        `${Math.floor(progress * 100)} %`,
                                    ),
                                complete: () => {
                                    prog.stop();
                                    $('.hud-progressbar-percentage').text('FERTIG');
                                    prog.css({
                                        background: '#A1F438',
                                        boxShadow: '0 0 1vh #A1F438',
                                    });
                                    $('.hud-bottom-center').fadeOut(550);
                                    setTimeout(() => {
                                        prog.css('width', 0);
                                        $('.hud-progressbar-percentage').text('');
                                    }, 550);
                                },
                            },
                        );
                break;
            }

            case 'hud:load': {
                data = i.data

                $('#playerId').html(`ID <span style="color: #fff;" id="playerId">${data.id}</span>`)
                $('#playerJob').html(data.job)
                $('#player-count').html(`<span style="color: var(--color);">${data.online}</span>/${data.maxClients} SPIELER`)
                $("#player-money").text(new Intl.NumberFormat("de-DE").format(data.money) + "$");

                // STATS
                stats = i.data.stats

                $('#liga-val').html(`${stats.trophys}/<span style="color: rgba(255, 255, 255, 0.5);">${stats.ligamax} Trophäen</span>`)
                document.getElementById("liga-img").src = 'img/ranks/' + stats.ligaicon + '.png';

                $('#kills-val').text(stats.kills)
                $('#deaths-val').text(stats.deaths)
                $("#kd-val").text(stats.kills > 0 ? stats.deaths > 0 ? (stats.kills / stats.deaths).toFixed(2) : `${stats.kills}.0` : "0.0");
                break;
            }

            case 'hud:updateJob': {
                $('#playerJob').html(i.job)
                break;
            }

            case 'SetStats': {
                var kd = i.kills / i.deaths;

                $('#liga-val').html(`${i.trophys}/<span style="color: rgba(255, 255, 255, 0.5);">${i.ligamax} Trophäen</span>`)
                document.getElementById("liga-img").src = 'img/ranks/' + i.ligaicon + '.png';

                $('#kills-val').text(i.kills)
                $('#deaths-val').text(i.deaths)
                $('#kd-val').text(kd.toFixed(2));
                break;
            }

            case 'updatePlayers': {
                $('#player-count').html(`<span style="color: var(--color);">${i.online}</span>/${i.maxClients} SPIELER`)
                break;
            }

            case 'drawWeapon': {

                if (i.toggle) {
                    $('#drawWeapon_item').fadeIn(500)
                    $('#drawWeapon').html(i.weapon)
                } else {
                    $('#drawWeapon_item').fadeOut(500)
                }

                break;
            }

            case 'mute': {
                if (i.toggle) {
                    $('#muteIcon').show(170)
                } else {
                    $('#muteIcon').hide(170)
                }
                break;
            }

            case 'hud:toggle': {
                if (i.toggle) {
                    $('.hud').fadeIn(125)
                } else {
                    $('.hud').fadeOut(125)
                }
                break;
            }

            case 'money': {
                $("#player-money").text(new Intl.NumberFormat("de-DE").format(i.money) + "$");
                break;
            }

            case 'eventRoles': {
                inEventRules = true
                $('.rules').fadeIn(125)
                break;
            }

            case 'enablepress': {
                HelpNotification(i.enable, i.btn, i.message);
            }

            case 'joincam:updateLocation': {
                $('#joinCamMapLocation').text(i.location)
                break;
            }

            case 'joinCamMode': {
                if (i.toggle) {
                    $('.joinCam').fadeIn(125)
                    inSpawn = true
                } else {
                    $('.joinCam').fadeOut(125)
                    inSpawn = false
                }
                break;
            }
        }
    });
});

function openRulesContainer() {
    $('.rules').fadeOut(125)
    $('.rulesContainer').fadeIn(125)
}

function acceptEventRules() {
    inEventRules = false
    $('.rulesContainer').fadeOut(125)
    $.post(`https://${GetParentResourceName()}/acceptRules`);
}

function startTime() {
    const today = new Date();
    let h = today.getHours();
    let m = today.getMinutes();
    let day = today.getDate();
    let month = today.getMonth() + 1;
    let year = today.getFullYear();
    // $("#time").text(checkTime(h) + ":" + checkTime(m));
    $("#hud-time").text(checkTime(h) + ":" + checkTime(m));
    if (day < 10) {
        day = "0" + day;
    }
    if (month < 10) {
        month = "0" + month;
    }
    // $("#date").text(day + "." + month + "." + year)
    $("#hud-date").text(day + "." + month + "." + year)

    setTimeout(startTime, 60 * 1000);
}

function checkTime(i) {
    if (i < 10) {
        i = "0" + i;
    }
    return i;
}

startTime();