var inpvp = false
var inCaseWinningPage = false
var inanimation = false
var cooldown = false
var XP_FromMoney = 0

const currentCase = {
    name: "",
    index: 0,
    price: 0
};

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'coinsUpdate': {
                $('#settings-coins').text(new Intl.NumberFormat("de-DE").format(i.coins) + "$");
                break;
            }

            case 'case:showWin': {
                if (!inCaseWinningPage) {
                    inCaseWinningPage = true
                    inanimation = true

                    const classesToRemove = ["bronze", "silber", "platin", "gold", "diamond", "elite"];

                    $('.main__header__items').hide();
                    $('#current-case-img').addClass('nitro-animation');
                    $('.current-case').hide();
                    $('.case-buy').hide();
                    $('.case-price').hide();

                    setTimeout(() => {
                        $('.current-case').text("WÄHLE DEIN CASE AUS");
                        $('#current-case-img').removeClass('nitro-animation');

                        $('.current-case').hide();
                        $('.cases__chose').hide();
                        $('.case-buy').hide();
                        $('.case-price').hide();
                        $('#current-case-img').hide();

                        $('.case-preview').css("left", "50%").css("transform", "translateX(-50%)");

                        $('.win-icon').fadeIn();
                        $('.win-reward').fadeIn();
                        $('.case-claim').fadeIn();

                        setTimeout(() => {
                            $('.current-case').removeClass(classesToRemove.join(' '));
                            $('.case-price').removeClass(classesToRemove.join(' '));
                            $('.case-buy').removeClass(classesToRemove.join(' '));
                        }, 200);

                        $('.case-win-header').show()
                        $('.case-win').show()

                        currentCase.name = "";
                        currentCase.price = 0;
                        currentCase.index = 1;

                        if (i.type == "money") {
                            $('.case-win').text(new Intl.NumberFormat("de-DE").format(i.money) + "$");
                            $('.win-reward').attr("src", `img/weapons/money.png`);
                        }

                        if (i.type == "items") {
                            $('.case-win').text(i.itemCount + "x " + i.reward);
                            $('.win-reward').attr("src", `img/weapons/${i.reward}.png`);
                        }

                        setTimeout(() => {
                            inanimation = false
                        }, 500);
                    }, 2000);
                }
                break;
            }

            case 'mainmenu:open': {
                $('.win-icon').hide();
                $('.case-preview').css("left", "0").css("transform", "translateX(0)");
                $('.win-reward').hide();
                $('.case-claim').hide();
                $('.case-win-header').hide()
                $('.case-win').hide()

                $('.main__container').fadeIn(125);

                $('#settings-coins').text(new Intl.NumberFormat("de-DE").format(i.coins));

                if (i.isin) {
                    $('.main__header__item').removeClass('select');
                    $('#main__First_page').addClass('select');

                    $('.main__container .main__wrapper').fadeOut(200);
                    $('.main__container .main__loading').fadeIn(200);

                    setTimeout(() => {
                        $('.main__container .main__loading').fadeOut(200);
                    }, 750);

                    setTimeout(() => {
                        $('#main__shop').fadeIn(250);
                    }, 850);
                    inpvp = true
                    $('#main__pvp__item').hide()
                } else {
                    inpvp = false
                    $('#main__pvp__item').show()
                }

                requestShop();
                requestSettings();
                break;
            }

            case 'inventory:addAttachments': {
                $('.inventory-attachments-append').empty();

                setTimeout(() => {
                    $('.inventory-attachments-append').append(`
                        <div class="inventory-attachments-item">
                            <span>${i.label}</span>
                            <button style="padding-left: 3vmin; padding-right: 3vmin;" onclick="inventory('${i.has ? 'attachment_weg' : 'attachment_drauf'}', '${i.weapon}', '${i.label}', '${i.name}')">${i.has ? 'VERKAUFEN' : 'KAUFEN'}</button>
                        </div>
                    `);
                }, 100);
                break;
            }

            case 'addTints': {
                $('.inventory-skins-append').empty();

                setTimeout(() => {
                    for ([tintName, value] of Object.entries(i.tints))
                        $('.inventory-skins-append').append(`
                            <div class="inventory-skins-item">
                                <span>${value.label}</span>
                                <button style="padding-left: 3vmin; padding-right: 3vmin;" onclick="setNewTint('${value.value}', '${i.weapon}')">BENUTZEN</button>
                            </div>
                        `);
                }, 100);
                break;
            }

            case 'pvpBanner': {
                $('.pvpBanner').show();

                setTimeout(() => {
                    $('.pvpBanner').css("animation", "pvpBannerFadeOut 0.5s");

                    setTimeout(() => {
                        $('.pvpBanner').hide();
                    }, 500);
                }, 4500);
                break;
            }

            case 'ffa:statsUpdate': {
                var data = i.data

                $('#kills-val').text(data.kills)
                $('#deaths-val').text(data.deaths)
                $("#kd-val").text(data.kills > 0 ? data.deaths > 0 ? (data.kills / data.deaths).toFixed(2) : `${data.kills}.0` : "0.0");
                break;
            }
        }
    });
});

// MAINMENÜ
const changeMainMenuPage = (item, page) => {
    if (cooldown) return

    if (!cooldown) {
        cooldown = true
        if (page == 'battlepass') {
            requestBattlepass();
        }

        if (page == 'pvp') {
            requestPVP();
        }

        if (page == 'inventory') {
            requestInventory();
        }

        if (page == "shop") {
            requestShop();
        }

        if (page == "settings") {
            requestSettings();
        }

        if (page == "scoreboard") {
            requestScoreboard();
        }

        if (page == "factionlist") {
            $.post(`https://${GetParentResourceName()}/OpenFactionlist`);
            closeAll()
        }

        if (page == "cases") {
            setTimeout(() => {
                const classesToRemove = ["bronze", "silber", "platin", "gold", "diamond", "elite"];

                $('.current-case').removeClass(classesToRemove.join(' '));
                $('.case-price').removeClass(classesToRemove.join(' '));
                $('.case-buy').removeClass(classesToRemove.join(' '));

                $('.current-case').text("WÄHLE DEIN CASE AUS");
                $('#current-case-img').fadeOut();
                $('.case-buy').fadeOut();
                $('.case-price').fadeOut();

                $('.win-icon').fadeOut();
                $('.case-preview').css("left", "0").css("transform", "translateX(0)");
                $('.win-reward').fadeOut();
                $('.case-claim').fadeOut();
                $('.case-win-header').hide()
                $('.case-win').hide()

                currentCase.name = "";
                currentCase.price = 0;
                currentCase.index = 1;
            }, 400);
        }

        if (page !== "factionlist") {
            $('.main__header__item').removeClass('select');
            $(item).addClass('select');

            $('.main__container .main__wrapper').fadeOut(200);
            $('.main__container .main__loading').fadeIn(200);

            setTimeout(() => {
                $('.main__container .main__loading').fadeOut(200);
            }, 750);

            setTimeout(() => {
                $('#main__' + page).fadeIn(250);
            }, 850);
        }


        setTimeout(() => {
            cooldown = false
        }, 1000);

    }
}

// SCOREBOARD
const requestScoreboard = () => {
    $.post('https://crimelife/mainmenu:requestScoreboard', JSON.stringify({}), function (callback) {
        if (callback) {
            const ffa = callback.ffa;
            const battlepass = callback.battlepass;
            const liga = callback.liga;
            const stats = callback.stats;
            const midrolls = callback.midrolls;
            const factions = callback.factions;
            const self = callback.self;

            $('.scoreboard-header').empty();
            $('#scoreboard_ffa_append').empty();
            $('#scoreboard_main_append').empty();
            $('#scoreboard_liga_append').empty();
            $('#scoreboard__midrolls_append').empty();
            $('#scoreboard_battlepass_append').empty();
            $('#scoreboard_factions_append').empty();

            const xpPercentage = (self.xp / self.maxXP) * 100;

            $('.scoreboard-header').append(`
                <div class="scoreboard-profile-image">
                    <img src="${self.avatar}">
                </div>
        
                <span class="scoreboard-profile-name">${self.name}</span>
                <span class="scoreboard-profile-discord-name">@${self.dcName}</span>
        
                <div class="scoreboard-battlepass-item">
                    <span class="scoreboard-battlepass-score">Du Bist auf dem <span style="color: var(--color);">${self.place}.</span>
                        Platz</span>
        
                    <span class="scoreboard-battlepass-exp"><span style="color: var(--color);">${self.xp}</span> / ${self.maxXP} EXP</span>
                    <div class="scoreboard-battlepass-bar-container">
                        <div class="scoreboard-battlepass-bar" style="width: ${xpPercentage}%;"></div>
                    </div>
                </div>

                                <div class="scoreboard-liga-wrapper">
                    <div class="liga-line">
                        <span>BRONZE</span>

                        <div class="liga-line-item">
                            <img src="img/ranks/bronze1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/bronze2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/bronze3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/bronze4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/bronze5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/bronze6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>IRON</span>

                        <div class="liga-line-item">
                            <img src="img/ranks/iron1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/iron2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/iron3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/iron4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/iron5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/iron6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>GOLD</span>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/gold6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>PLATINUM</span>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/platin6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>DIAMOND</span>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/diamond6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>MASTER</span>
                        <div class="liga-line-item">
                            <img src="img/ranks/master1.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/master2.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/master3.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/master4.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/master5.png">
                        </div>
                        <div class="liga-line-item">
                            <img src="img/ranks/master6.png">
                        </div>
                    </div>
                    <div class="liga-line">
                        <span>GRANDMASTER</span>
                        <div class="liga-line-item">
                            <img src="img/ranks/grandmaster.png">
                        </div>
                    </div>
                </div>
            `);


            for ([kex, value] of Object.entries(ffa)) {
                $('#scoreboard_ffa_append').append(`
                    <div class="scoreboard-append-item">
                        <span>${value.place}</span>
                        <span>${value.name}</span>
                        <span>${value.kills}</span>
                        <span>${value.kills > 0 ? value.deaths > 0 ? (value.kills / value.deaths).toFixed(2) : `${value.kills}.0` : "0.0"}</span>
                    </div>
                `)
            }

            for ([kex, value] of Object.entries(stats)) {
                $('#scoreboard_main_append').append(`
                    <div class="scoreboard-append-item">
                        <span>${value.place}</span>
                        <span>${value.name}</span>
                        <span>${value.kills}</span>
                        <span>${value.kills > 0 ? value.deaths > 0 ? (value.kills / value.deaths).toFixed(2) : `${value.kills}.0` : "0.0"}</span>
                    </div>
                `)
            }

            for ([kex, value] of Object.entries(liga)) {
                $('#scoreboard_liga_append').append(`
                    <div class="scoreboard-append-item">
                        <span>${value.place}</span>
                        <span>${value.name}</span>
                        <span>${value.trophys}</span>
                        <span>${value.liga}</span>
                    </div>
                `)
            }

            for ([kex, value] of Object.entries(midrolls)) {
                $('#scoreboard__midrolls_append').append(`
                    <div class="scoreboard-append-item">
                        <span>${value.place}</span>
                        <span>${value.name}</span>
                            <span style="right: 1.7vmin; text-align: right;  display: flex; align-items: center; justify-content: flex-end;">${value.midrolls}</span>
                    </div>
                `)
            }

            for ([kex, value] of Object.entries(battlepass)) {
                $('#scoreboard_battlepass_append').append(`
                    <div class="scoreboard-append-item">
                        <span>${value.place}</span>
                        <span>${value.name}</span>
                        <span>${value.xp}</span>
                        <span>${value.level}</span>
                    </div>
                `)
            }
        }
    });
}
const changeScoreboardPage = (item, page) => {
    $('.scoreboard-all-header-item').removeClass('select');
    $(item).addClass('select');

    $('.scoreboard-all-second-container').fadeOut(200);
    $('#scoreboard_' + page).fadeIn(200);
}

// SHOP
const buy = (name) => {
    $.post(`https://${GetParentResourceName()}/buy`, JSON.stringify(name))
    setTimeout(() => {
        requestShop();
    }, 100);
}
const sell = (name) => {
    $.post(`https://${GetParentResourceName()}/sell`, JSON.stringify(name))
    setTimeout(() => {
        requestShop();
    }, 100);
}
const buyItem = (name) => {
    $.post(`https://${GetParentResourceName()}/buyItem`, JSON.stringify(name))
    setTimeout(() => {
        requestShop();
    }, 100);
}
const buy_effect = (key) => {
    $.post(`https://${GetParentResourceName()}/buy_effect`, JSON.stringify(key))
    setTimeout(() => {
        requestShop();
    }, 100);
}
const sell_effect = (key) => {
    $.post(`https://${GetParentResourceName()}/sell_effect`, JSON.stringify(key))
    setTimeout(() => {
        requestShop();
    }, 100);
}
const requestShop = () => {
    $.post('https://crimelife/mainmenu:requestShop', JSON.stringify({}), function (callback) {
        if (callback) {
            weapons = callback.weapons;
            loadout = callback.loadout;
            items = callback.items;
            effects = callback.effects;
            particleDictionary = callback.particleDictionary;
            particleName = callback.particleName;
            cases = callback.cases;

            $('#shop__killeffects').empty();
            $('#shop__weapons').empty();
            $('#shop__items').empty();
            $('.cases-append').empty();

            for (const [key, value] of Object.entries(effects)) {
                const isBuyedEffect = particleDictionary === value.data.particleDictionary && particleName === value.data.particleName;

                $('#shop__killeffects').append(`
                        <div class="shop-item">
                            <span>${key}</span>
                            <span>${new Intl.NumberFormat("de-DE").format(value.price)}$</span>
                            <img src="${value.img}">
                            <button class="${isBuyedEffect ? 'sell' : 'buy'}" onclick="${isBuyedEffect ? 'sell_effect' : 'buy_effect'}('${key}')">  ${isBuyedEffect ? 'VERKAUFEN' : 'KAUFEN'}</button>
                        </div>
                    `);

            }

            const sortedWeapons = Object.entries(weapons).sort((a, b) => a[1].price - b[1].price);
            for (const [key, value] of sortedWeapons) {
                const isInLoadout = loadout.some(weapon => {
                    return weapon.name === key;
                });

                $('#shop__weapons').append(`
                        <div class="shop-item">
                            <span>${value.label}</span>
                            <span>${new Intl.NumberFormat("de-DE").format(value.price)}$</span>
                            <img src="img/weapons/${key}.png">
                            <button class="${isInLoadout ? 'sell' : 'buy'}" onclick="${isInLoadout ? 'sell' : 'buy'}('${key}')"> ${isInLoadout ? 'VERKAUFEN' : 'KAUFEN'}
                        </div>
                    `);
            }

            for (const [key, data] of Object.entries(items)) {
                $('#shop__items').append(`
                        <div class="shop-item">
                            <span>${data.label}</span>
                            <span>${new Intl.NumberFormat("de-DE").format(data.price)}$</span>
                            <img src="img/weapons/${key}.png">
                            <button onclick="buyItem('${key}')">KAUFEN</button>
                        </div>
                    `);
            }

            const sortedCases = Object.values(cases).sort((a, b) => {
                const order = ["bronze", "silber", "gold", "platin", "diamond", "elite"];
                return order.indexOf(a.class) - order.indexOf(b.class);
            });

            sortedCases.forEach((data, index) => {
                $('.cases-append').append(`
                    <div class="cases-item ${data.class}">
                        <img src="img/cases/${data.class}case.png">
                        <span>${data.class}case</span>
                        <span>${data.price} COINS</span>
                        <button onclick="chooseCase(${index + 1}, '${data.class}', '${data.price}')">AUSWÄHLEN</button>
                    </div>
                `);
            });
        }
    });
}

// PVP
const requestPVP = () => {
    $.post('https://crimelife/mainmenu:requestPVP', JSON.stringify({}), function (callback) {
        if (callback) {
            ffa = callback.ffa;
            gungame = callback.gungame;
            maps = callback.maps;
            PrivateLobbies = callback.PrivateLobbies;

            $('#pvp_ffa').empty();
            $('#pvp_privatelobbys').empty();
            $('#pvp_gungame').empty();
            $('.ffa-create-dropdown').empty();

            for (const [key, value] of Object.entries(maps)) {
                $('.ffa-create-dropdown').append(`
                    <option value="${key}">${key}</option>
                `);
            }

            const sortedPlayers = Object.entries(ffa.players).sort(([, playerCountA], [, playerCountB]) => playerCountB - playerCountA);

            sortedPlayers.forEach(([ffa_map, playerCount]) => {
                if (ffa.maps[ffa_map]) {
                    const maxPlayers = ffa.maps[ffa_map].max;

                    $('#pvp_ffa').append(`
                        <div class="pvp-item">
                            <span>${ffa_map}</span>
                            <span>${playerCount}/${maxPlayers}</span>
                            <i class="fa-solid fa-arrow-pointer" onclick="ffaJoin('${ffa_map}')"></i>
                        </div>
                    `);
                }
            });

            $('#pvpPage-gungame').empty();
            const sortedGungamePlayers = Object.entries(gungame.players).sort(([, playerCountA], [, playerCountB]) => playerCountB - playerCountA);

            sortedGungamePlayers.forEach(([gungame_map, playerCount]) => {
                if (gungame.maps[gungame_map]) {
                    const maxPlayers = gungame.maps[gungame_map].max;

                    $('#pvp_gungame').append(`
                        <div class="pvp-item">
                            <span>${gungame_map}</span>
                            <span>${playerCount}/${maxPlayers}</span>
                            <i class="fa-solid fa-arrow-pointer" onclick="gungameJoin('${gungame_map}')"></i>
                        </div>
                    `);
                }
            });

            if (PrivateLobbies) {
                for ([_, i] of Object.entries(PrivateLobbies)) {
                    if (i && i.zone) {
                        $('#pvp_privatelobbys').append(`
                            <div class="pvp-item">
                                <span>${i.name}</span>
                                <span>${i.players}/${i.maxPlayers}</span>
                                <input type="text" placeholder="Passwort" id="passwortValueFFA">
                                <i class="fa-solid fa-arrow-pointer" onclick="JoinPrivateFFA('${i.source}', '${i.password}')"></i>
                            </div>
                        `);
                    }
                }
            }
        }
    });
}
const ffaJoin = (map) => {
    $.post(`https://${GetParentResourceName()}/ffaJoin`, JSON.stringify(map))
    closeAll()
}
const gungameJoin = (map) => {
    $.post(`https://${GetParentResourceName()}/gungameJoin`, JSON.stringify(map))
    closeAll()
}
const JoinPrivateFFA = (source, password) => {
    playClick()
    password = $('#passwortValueFFA').val()
    if (password === "") return;
    $.post(
        `https://${GetParentResourceName()}/JoinPrivateFFA`,
        JSON.stringify({ password: password, id: source })
    );
    closeAll()
}
const selectFFAMap = () => {
    const name = document.querySelector('.ffa-create-dropdown').value;
    document.getElementById("ffa-create-map").src = `img/ffa/${name}.png`;
};
const createFFALobby = () => {
    const name = $('#ffa-create-lobby-name').val()
    const password = $('#ffa-create-lobby-password').val()
    const map = $('.ffa-create-dropdown').val()

    if (name.length < 3) {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "FEHLER",
            text: "Der Name der Lobby muss mindestens 3 Zeichen lang sein",
            type: "error",
            time: 5000
        }))
        return
    }

    if (password.length < 3) {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "FEHLER",
            text: "Das Passwort der Lobby muss mindestens 3 Zeichen lang sein",
            type: "error",
            time: 5000
        }))
        return
    }

    if (map.length < 1) {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "FEHLER",
            text: "Du musst eine Map auswählen",
            type: "error",
            time: 5000
        }))
        return
    }

    $.post(`https://${GetParentResourceName()}/createFFALobby`, JSON.stringify({
        name: name,
        password: password,
        map: map
    }))
    closeAll()

    setTimeout(() => {
        $('.main__container').css("width", "140vmin").css("height", "80vmin")

        $('.main__container #main__pvp_create_lobby').fadeOut(400)
        $('.main__container .wrapper').fadeIn(400)
        $('.main__container #main__pvp').fadeIn(400)
        $('#ffa-create-lobby-name').val("")
        $('#ffa-create-lobby-password').val("")
    }, 500);
}
$(".pvp-create-ffa-lobby").click(function () {
    $('.main__container').css("width", "50vmin").css("height", "50vmin")

    $('.main__container .wrapper').fadeOut(400)
    $('.main__container #main__pvp').fadeOut(400)
    $('.main__container #main__pvp_create_lobby').fadeIn(400)
});
$(".ffa-create-deny-button").click(function () {
    $('.main__container').css("width", "140vmin").css("height", "80vmin")

    $('.main__container #main__pvp_create_lobby').fadeOut(400)
    $('.main__container .wrapper').fadeIn(400)
    $('.main__container #main__pvp').fadeIn(400)
});

// GAMECONFIG
const settingsAction = (action) => {
    playClick()

    if (event.target.checked) {
        $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
            action: action,
            toggle: true
        }))
    } else {
        $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
            action: action,
            toggle: false
        }))
    }
}
const setWeather = (icon, weather) => {
    $('.settings-weather-icon').removeClass('active')
    $('#' + icon).addClass('active')
    $.post(`https://${GetParentResourceName()}/setWeather`, JSON.stringify(weather))
}
const requestSettings = () => {
    $.post('https://crimelife/mainmenu:requestSettings', JSON.stringify({}), function (callback) {
        if (callback) {
            settings = callback

            if (settings.hud) {
                var hud_check = document.getElementById("hud_check");
                hud_check.checked = true;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "hud_toggle",
                    toggle: true
                }))

            } else {
                var hud_check = document.getElementById("hud_check");
                hud_check.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "hud_toggle",
                    toggle: false
                }))
            }

            if (settings.killfeed) {
                var killfeed_check = document.getElementById("killfeed_check");
                killfeed_check.checked = true;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "feed_toggle",
                    toggle: true
                }))
            } else {
                var killfeed_check = document.getElementById("killfeed_check");
                killfeed_check.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "feed_toggle",
                    toggle: false
                }))
            }

            if (settings.fps.show) {
                var fps_show_checked = document.getElementById("fps_show_checked");
                fps_show_checked.checked = true;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "fps_show_toggle",
                    toggle: true
                }))
            } else {
                var fps_show_checked = document.getElementById("fps_show_checked");
                fps_show_checked.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "fps_show_toggle",
                    toggle: false
                }))
            }

            if (settings.fps.boost) {
                var fps_boost_checked = document.getElementById("fps_boost_checked");
                fps_boost_checked.checked = true;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "fps_boost",
                    toggle: true
                }))
            } else {
                var fps_boost_checked = document.getElementById("fps_boost_checked");
                fps_boost_checked.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "fps_boost",
                    toggle: false
                }))
            }

            if (settings.killmarker) {
                var killmarker_checked = document.getElementById("killmarker_checked");
                killmarker_checked.checked = true;


                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "killmarker_toggle",
                    toggle: true
                }))
            } else {
                var killmarker_checked = document.getElementById("killmarker_checked");
                killmarker_checked.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "killmarker_toggle",
                    toggle: false
                }))

            }

            if (settings.speak) {
                var speak_check = document.getElementById("speak_check");
                speak_check.checked = true;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "speak_toggle",
                    toggle: true
                }))

            } else {
                var speak_check = document.getElementById("speak_check");
                speak_check.checked = false;

                $.post(`https://${GetParentResourceName()}/settingsAction`, JSON.stringify({
                    action: "speak_toggle",
                    toggle: false
                }))
            }

            if (settings.freeze) {
                var freeze_check = document.getElementById("freeze_check");
                freeze_check.checked = true;
            } else {
                var freeze_check = document.getElementById("freeze_check");
                freeze_check.checked = false;
            }

            if (settings.time) {
                document.getElementById('time_value').innerHTML = settings.time + ":00 UHR";
                document.getElementById('time-control').value = settings.time;
            }

            weather = settings.weather
            if (weather == "EXTRASUNNY") {
                $('.settings-weather-icon').removeClass('active')
                $('#weather1').addClass('active')
            } else if (weather == "XMAS") {
                $('.settings-weather-icon').removeClass('active')
                $('#weather2').addClass('active')
            } else if (weather == "RAIN") {
                $('.settings-weather-icon').removeClass('active')
                $('#weather3').addClass('active')
            }
        }
    });
}
const changeTime = (time) => {
    document.getElementById('time_value').innerHTML = time + ":00 UHR";
    $.post(`https://${GetParentResourceName()}/changeTime`, JSON.stringify(time))
}

const freezeTime = () => {
    $.post(`https://${GetParentResourceName()}/freezeTime`)
}

// BATTLEPASS
const collect = (index) => {
    const element = $(`[item-count="${index}"]`);
    if (element.hasClass('unclaimed')) {
        $.post(
            `https://${GetParentResourceName()}/collect`,
            JSON.stringify({
                index: index,
            }),
        ).done((resp) => {
            if (resp.success) {
                element.removeClass('unclaimed');
                element.addClass('claimed');
            }
        });
    }

    setTimeout(() => {
        requestBattlepass();
    }, 100);
};
const collect_premium = (index) => {
    const element = $(`[item-count-premium="${index}"]`);
    if (element.hasClass('unclaimed')) {
        $.post(
            `https://${GetParentResourceName()}/collect_premium`,
            JSON.stringify({
                index: index,
            }),
        ).done((resp) => {
            if (resp.success) {
                element.removeClass('unclaimed');
                element.addClass('claimed');
            }
        });
    }

    setTimeout(() => {
        requestBattlepass();
    }, 100);
};
const BerechneXP = (value) => {
    if (value) {
        var xp = Math.round((parseInt(value) / 65000) * 100);

        $('#battlepass_xp_header').text("Du erhältst " + xp + " XP");
        XP_FromMoney = xp;
        MoneyForXp = value;
    } else {
        $('#battlepass_xp_header').text("// GELD ZU XP TAUSCHEN.");
        XP_FromMoney = 0;
    }
}
const changeMoneyToXp = () => {
    if (XP_FromMoney > 0) {
        $.post(`https://${GetParentResourceName()}/changeMoneyToXp`, JSON.stringify({ xp: XP_FromMoney, money: MoneyForXp }))

        setTimeout(() => {
            requestBattlepass();
        }, 100);
    } else {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "BATTLEPASS",
            text: "Geben sie ein Wie Viel geld sie in XP umwandeln möchten",
            type: "error",
            time: 5000
        }))
    }
}
const requestBattlepass = () => {
    $.post('https://crimelife/mainmenu:requestBattlepass', JSON.stringify({}), function (callback) {
        if (callback) {
            const level = callback.level;
            const rewards = callback.rewards;
            const premium = callback.premium;

            if (premium) {
                $('#battlepass-premium-container').empty();
                for (let i = 0; i < rewards.length; i++) {
                    const reward = rewards[i];
                    const displayIndex = parseInt(i) + 1;

                    $('#battlepass-premium-container').append(
                        `<div class="battlepass-item-premium ${callback.collected_premium[displayIndex + 1] ? 'unlocked claimed' : displayIndex + 1 <= level ? 'unlocked unclaimed' : 'locked'}" item-count-premium="${displayIndex + 1}" onclick="collect_premium(${displayIndex + 1})"">
                        
                            <div class="battlepass-level-premium">
                                <p>LEVEL ${displayIndex}</p>
                            </div>
                            <div class="batlepass-item-premium-container">
                                <img class="item-image" src="img/weapons/${reward.premium.reward.type}.png" 
                                     onerror="this.onerror=null;this.src='img/logo.png';" draggable="false">
                                <p>${reward.premium.label}</p>
                            </div>
                        </div>
                        `
                    );
                }

                $('.battlepass-premium-blur').hide();
                $('.battlepass-premium-blur-span').hide();
            } else {
                $('.battlepass-premium-blur').show();
                $('.battlepass-premium-blur-span').show();
            }

            // Free Pass-Container
            $('#battlepass-free-container').empty();
            for (let i = 0; i < rewards.length; i++) {
                const reward = rewards[i];
                const displayIndex = parseInt(i) + 1;

                $('#battlepass-free-container').append(
                    `<div class="battlepass-item ${callback.collected[displayIndex + 1] ? 'unlocked claimed' : displayIndex + 1 <= level ? 'unlocked unclaimed' : 'locked'}" item-count="${displayIndex + 1}" onclick="collect(${displayIndex + 1})"">
                        <div class="battlepass-level">
                            <p>LEVEL ${displayIndex}</p>
                        </div>
                        <div class="batlepass-item-container">
                            <img class="item-image" src="img/weapons/${reward.free.reward.type}.png" 
                                 onerror="this.onerror=null;this.src='img/logo.png';" draggable="false">
                            <p>${reward.free.label}</p>
                        </div>
                    </div>`
                );
            }

            $('.battlepass-quests-append').empty();
            const Quests = callback.Quests;
            const playerQuests = callback.playerQuests;
            const collected_quest = callback.collected_quest;

            for ([key, value] of Object.entries(Quests)) {
                const playerProgress = playerQuests[key] || 0;

                const isClaimed = collected_quest[key] === true;

                const progressPercent = Math.min((playerProgress / value.count) * 100, 100);
                const isCompleted = playerProgress >= value.count;

                const itemClass = isClaimed ? 'claimed' : (isCompleted ? 'collected' : '');

                let imgOrText = '';

                if (isClaimed) {
                    imgOrText = `<img src="img/battlepass/success.svg" alt="Claimed">`;
                } else if (isCompleted) {
                    imgOrText = `<span class="quest__claimHeader">Belohnung abholen</span>`;
                }

                const clickableClass = isClaimed ? 'disabled' : '';
                const actionAttr = isCompleted && !isClaimed ? 'data-action="complete"' : '';

                $('.battlepass-quests-append').append(`
                    <div class="quest-item ${itemClass} ${clickableClass}" data-key="${key}" ${actionAttr}">
                        <span>${value.title}</span>
                        <span>${value.label}</span>

                        <span>FORTSCHRITT: ${playerProgress} / ${value.count}</span>
                        <div class="quests-bar">
                            <div class="quests-inner" style="width: ${progressPercent}%;"></div>
                        </div>

                        ${imgOrText}
                    </div>
                `);
            }

            $('.battlepass-quests-append').on('click', '.quest-item', function () {
                const isActionable = $(this).data('action') === 'complete';
                if (isActionable) {
                    const key = $(this).data('key');
                    winQuest(key);
                }
            });
        }
    });
};
const winQuest = (key) => {
    $.post(`https://${GetParentResourceName()}/ClaimWinQuest`, JSON.stringify(key))

    setTimeout(() => {
        requestBattlepass();
    }, 100);
}

// INVENTORY
const requestInventory = () => {
    $.post('https://crimelife/mainmenu:requestInventory', JSON.stringify({}), function (callback) {
        if (callback) {
            loadout = callback.loadout;
            items = callback.items;

            $('.inventory-weapons-append').empty();
            $('.inventory-items-append').empty();

            for ([key, value] of Object.entries(loadout)) {
                $('.inventory-weapons-append').append(`
                    <div class="inventory-weapons-item">
                        <span>${value.label}</span>

                        <button onclick="inventory('attachment', '${value.name}')">AUFSÄTZE</button>
                        <button onclick="inventory('weapontints', '${value.name}')">TARNUNG</button>
                        <button onclick ="Inventory_Weapon_Trash('${value.name}')">WEG WERFEN</button>
                    </div>
                `)
            }

            for ([key, data] of Object.entries(items)) {
                if (data.count > 0) {
                    $('.inventory-items-append').append(`
                        <div class="inventory-item">
                            <span>${data.count}x | ${data.label}</span>
                            <button style="padding-left: 3vmin; padding-right: 3vmin;" onclick="Inventory_Item_Share('${data.name}')">BENUTZEN</button>
                        </div>
                    `)
                }
            }
        }
    });
}
function setNewTint(tint, weapon) {
    $.post(`https://${GetParentResourceName()}/setNewTint`, JSON.stringify({ tint: tint, weapon: weapon }))
    $('.inventory-skins-append').empty();
    closeAll();
}
const inventory = (action, name, label, attachment) => {
    if (action === 'attachment_drauf' || action === 'attachment_weg') {
        setTimeout(() => {
            inventory('attachment', name)
        }, 100);
    }

    $.post(`https://${GetParentResourceName()}/inventory`, JSON.stringify({
        action: action,
        name: name,
        label: label,
        attachment: attachment
    }))
}

const chooseCase = (index, name, price) => {
    if (!inanimation) {
        currentCase.index = index;
        currentCase.name = name;
        currentCase.price = price;

        $('.win-icon').fadeOut();
        $('.win-reward').fadeOut();
        $('.case-claim').fadeOut();

        const classesToRemove = ["bronze", "silber", "platin", "gold", "diamond", "elite"];

        $('.current-case').removeClass(classesToRemove.join(' '));
        $('.case-price').removeClass(classesToRemove.join(' '));
        $('.case-buy').removeClass(classesToRemove.join(' '));

        $('.current-case').addClass(name);
        $('.case-buy').addClass(name);
        $('.case-price').addClass(name);

        $('.current-case').text(name + " CASE");
        $('#current-case-img').fadeIn();
        $('.current-case').fadeIn();
        $('.case-buy').fadeIn();

        $('.case-price').text(price + " COINS");
        $('.case-price').fadeIn();
        $('.cases__chose').fadeIn();
        $('.main__header__items').fadeIn();
        document.getElementById("current-case-img").src = `img/cases/${name}case.png`;
    }
};

const buyCurrentCase = () => {
    if (currentCase.name) {
        $.post(`https://${GetParentResourceName()}/buyCase`, JSON.stringify(currentCase));
    }
}

const claimCase = () => {
    const classesToRemove = ["bronze", "silber", "platin", "gold", "diamond", "elite"];

    $('.current-case').text("WÄHLE DEIN CASE AUS");

    $('.current-case').fadeIn();
    $('.cases__chose').fadeIn();
    $('.main__header__items').fadeIn();

    $('.win-icon').hide();
    $('.win-reward').hide();
    $('.case-claim').hide();
    $('.case-price').hide();
    $('.case-buy').hide();
    $('#current-case-img').hide();
    $('.case-win-header').hide()
    $('.case-win').hide()

    inCaseWinningPage = false

    $('.current-case').text("WÄHLE DEIN CASE AUS");

    $('.win-icon').hide();
    $('.win-reward').hide();
    $('.case-claim').hide();
    $('.case-preview').css("left", "0").css("transform", "translateX(0)");

    setTimeout(() => {
        $('.current-case').removeClass(classesToRemove.join(' '));
        $('.case-price').removeClass(classesToRemove.join(' '));
        $('.case-buy').removeClass(classesToRemove.join(' '));
    }, 200);

    currentCase.name = "";
    currentCase.price = 0;
}