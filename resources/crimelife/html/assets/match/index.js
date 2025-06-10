let matchIndex = 1;
let rounds = 0

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case '1vs1Modal': {
                matches = i.matches

                if (i.boolean) {
                    $('.match__container').fadeIn(125);
                    document.getElementById('match__slider').value = 1;
                    $(".match__rounds").text("RUNDEN: " + 1);

                    if (i.id) {
                        $(".match__idContainer").val(i.id);
                    }

                    nextMatch()
                } else {
                    denyMatch()
                    $('.match__container').fadeOut(125);
                }

                break;
            }

            case 'match:lose': {
                $('.match__loser').fadeIn();
                $('.match__loserScore').fadeIn();
                $('.match__loserScore').text(i.loserkills + " - " + i.winnerkills);

                setTimeout(() => {
                    $('.match__loser').fadeOut();
                    $('.match__loserScore').fadeOut();
                }, 3500);
                break;
            }

            case 'match:loadWaiter': {
                $('.match__slider').fadeOut();
                $('.match__rounds').fadeOut();
                $('.match__mapItem').fadeOut();
                $('.match__idContainer').fadeOut();

                setTimeout(() => {
                    $('.match__waitingforAnswer').fadeIn();
                    $('.match__container').css("height", "25vmin");
                    $('.match__request1vs1').fadeOut();
                    $('.match__deny1vs1').fadeIn();
                    startCountdown(60, $('.match__waitingforAnswer span'));
                }, 50);
                break;
            }

            case 'match:win': {
                $('.match__winner').fadeIn();
                $('.match__winnerScore').fadeIn();
                $('.match__winnerScore').text(i.winnerkills + " - " + i.loserkills);

                setTimeout(() => {
                    $('.match__winner').fadeOut();
                    $('.match__winnerScore').fadeOut();
                }, 3500);
                break;
            }

            case 'match:showReady': {
                $('.match__ready').fadeIn();

                setTimeout(() => {
                    $('.match__ready').fadeOut();
                }, 4500);
                break;
            }
        }
    });
});

function nextMatch() {
    matchIndex = (matchIndex % Object.keys(matches).length) + 1;
    const currentMatch = matches[matchIndex];

    $(".match__currentZoneName").text(currentMatch.map);
    document.getElementById("match__currentZoneImage").src = 'img/ffa/' + currentMatch.map + '.png';
}

function changeMatchRounds(r) {
    rounds = r;
    $(".match__rounds").text("RUNDEN: " + rounds);
}

let countdownInterval;

function requestMatch() {
    const MatchTarget = $(".match__idContainer").val();

    $.post(`https://${GetParentResourceName()}/requestMatch`, JSON.stringify({
        target: MatchTarget,
        matchIndex: matchIndex,
        rounds: rounds
    }))
}

function startCountdown(seconds, element) {
    let remaining = seconds;
    element.text(`Läuft in ${remaining} Sekunden ab`);

    clearInterval(countdownInterval);

    countdownInterval = setInterval(() => {
        remaining--;
        if (remaining > 0) {
            element.text(`Läuft in ${remaining} Sekunden ab`);
        } else {
            denyMatch()
        }
    }, 1000);
}

function denyMatch() {
    const MatchTarget = $(".match__idContainer").val();
    clearInterval(countdownInterval);

    $('.match__slider').fadeIn();
    $('.match__rounds').fadeIn();
    $('.match__mapItem').fadeIn();
    $('.match__idContainer').fadeIn();

    setTimeout(() => {
        $('.match__waitingforAnswer').fadeOut();
        $('.match__container').css("height", "44vmin");
        $('.match__request1vs1').fadeIn();
        $('.match__deny1vs1').fadeOut();
        document.getElementById('match__slider').value = 1;
        $(".match__rounds").text("RUNDEN: " + 1);

    }, 50);

    $.post(`https://${GetParentResourceName()}/denyMatch`, JSON.stringify(MatchTarget));
}