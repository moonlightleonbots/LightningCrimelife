$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'updateGW': {
                var data = i.data
                $('.gangwar').fadeIn(125);
                $('#gwLeftFaction').text(data.att);
                $('#gwLeftPoints').text(data.attpoints);

                $('#gwRightFaction').text(data.def);
                $('#gwRightPoints').text(data.defpoints);
                break;
            }

            case 'OpenScoreboard': {
                var scoreboard = i.data
                $('.gangwar').fadeOut(125);

                $('.gangwarScoreboard').fadeIn(125)
                $('#GWS-RIGHTFACTION').empty()
                $('#GWS-LEFTFACTION').empty()

                $('#GWS-LEFTFACTIONPOINTS').text(scoreboard.attacker.points + " Punkte")
                $('#GWS-LEFTFACTIONNAME').text(scoreboard.attacker.label)
                function berechnePlatzierungenUndSortiere(players) {
                    let sortedPlayers = Object.entries(players).sort(([, a], [, b]) => b.kills - a.kills);

                    sortedPlayers.forEach(([key, player], index) => {
                        player.place = index + 1;
                    });

                    return sortedPlayers;
                }

                let sortedAttackerPlayers = berechnePlatzierungenUndSortiere(scoreboard.attacker.players);
                for (const [key, data] of sortedAttackerPlayers) {
                    $('#GWS-LEFTFACTION').append(`
                        <div class="GWS-factionItem">
                            <span class="GWS-place" style="color: rgb(255, 255, 255)">${data.place}</span>
                            <span class="GWS-name" style="color: rgb(255, 255, 255)">[${data.source}] ${data.name}</span>

                            <div class="factionItemLeft">
                                <span>${data.kills}</span>
                                <span>${data.deaths}</span>
                                <span>${data.kills > 0 ? data.deaths > 0 ? (data.kills / data.deaths).toFixed(2) : `${data.kills}.0` : "0.0"}</span>
                            </div>
                        </div>
                    `);
                }

                let sortedDefenderPlayers = berechnePlatzierungenUndSortiere(scoreboard.defender.players);
                for (const [key, data] of sortedDefenderPlayers) {
                    $('#GWS-RIGHTFACTION').append(`
                        <div class="GWS-factionItem">
                            <span class="GWS-place" style="color: rgb(255, 255, 255)">${data.place}</span>
                            <span class="GWS-name" style="color: rgb(255, 255, 255)">[${data.source}] ${data.name}</span>

                            <div class="factionItemLeft">
                                <span>${data.kills}</span>
                                <span>${data.deaths}</span>
                                <span>${data.kills > 0 ? data.deaths > 0 ? (data.kills / data.deaths).toFixed(2) : `${data.kills}.0` : "0.0"}</span>
                            </div>
                        </div>
                    `);
                }

                $('#GWS-RIGHTFACTIONPOINTS').text(scoreboard.defender.points + " Punkte");
                $('#GWS-RIGHTFACTIONNAME').text(scoreboard.defender.label);
                break;
            }

            case 'SetTime': {
                var data = i.data
                let timer = data.time, minutes, seconds;

                minutes = parseInt((timer / 60).toString(), 10);
                seconds = parseInt((timer % 60).toString(), 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                $('#GWTIME').text(minutes + ":" + seconds);
                break;
            }

            case 'ToggleScore': {
                $('.gangwar').fadeOut(125);
                break;
            }
        }
    });
});