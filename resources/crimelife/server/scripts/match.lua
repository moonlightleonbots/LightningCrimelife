local requests = {}
local matches = {}
local isMatch = {}
local roundCount = {}
local maxroundCount = {}
local matchKills = {}

local genId = function()
    local id = 0
    repeat
        id = math.random(00000, 99999)
    until not matches[id];
    return id
end

ESX.RegisterServerCallback("1vs1:requestMatch", function(s, cb, target, matchIndex, rounds)
    if isMatch[tonumber(target)] then
        return
            cb(
                {
                    toggle = false,
                    message = "Der Spieler ist bereits in einem 1vs1 Match."
                }
            )
    end

    if Players[tonumber(target)] then
        return
            cb(
                {
                    toggle = false,
                    message = "Der Spieler ist in einem Gangwar."
                }
            )
    end

    if PVP.FFA.toggle[tonumber(target)] then
        return
            cb(
                {
                    toggle = false,
                    message = "Der Spieler ist im FFA."
                }
            )
    end

    if not ESX.GetPlayerFromId(tonumber(target)) then
        return
            cb(
                {
                    toggle = false,
                    message = "Dieser Spieler ist nicht Online."
                }
            )
    end

    if tonumber(target) == s then
        return
            cb(
                {
                    toggle = false,
                    message = "Du kannst dich nicht selbst herausfordern."
                }
            )
    end

    if not isMatch[tonumber(target)] then
        cb(
            {
                toggle = true,
            }
        )

        local targetID = tonumber(target)
        local mapname = Config.pvp.matches[tostring(matchIndex)].map

        if not requests[targetID] then
            requests[targetID] = {
                requester = s,
                matchIndex = tostring(matchIndex),
                rounds = rounds
            }

            Config.HUD.Notify({
                title = "1VS1 ANFRAGE",
                text = "Du hast eine 1vs1 Anfrage auf der Map " .. mapname ..
                    " von " .. GetPlayerName(s) .. "[" .. s .. "] erhalten, benutze /accept um die Anfrage anzunehmen.",
                type = "success",
                time = 12500
            }, targetID)

            ESX.SetTimeout(60000, function()
                if requests[targetID] then
                    requests[targetID] = nil
                    Config.HUD.Notify({
                        title = "1VS1 ANFRAGE",
                        text = "Die 1vs1 Anfrage von " .. GetPlayerName(s) .. "[" .. s .. "] ist abgelaufen.",
                        type = "error",
                        time = 5000
                    }, s)
                end
            end);
        end
    end
end);

RegisterCommand("accept", function(source)
    local s = source

    if requests[s] then
        local matchId = genId()

        matches[matchId] = {
            [s] = requests[s].requester,
            [requests[s].requester] = s,

            matchIndex = requests[s].matchIndex,
            rounds = requests[s].rounds,
        }

        isMatch[s] = matchId
        matchKills[s] = 0
        matchKills[tonumber(requests[s].requester)] = 0

        roundCount[matchId] = 1
        isMatch[requests[s].requester] = matchId
        maxroundCount[matchId] = matches[matchId].rounds

        SetPlayerRoutingBucket(s, matchId)
        SetPlayerRoutingBucket(requests[s].requester, matchId)

        TriggerClientEvent("1vs1:acceptMatch", s, matches[matchId].matchIndex, 1)
        TriggerClientEvent("1vs1:acceptMatch", requests[s].requester, matches[matchId].matchIndex, 2)
        TriggerClientEvent("1vs1:removeUI", requests[s].requester)
        requests[s] = nil
    end
end, false);

RegisterNetEvent("match:deny", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if requests[tonumber(id)] then
        requests[tonumber(id)] = nil
        Config.HUD.Notify({
            title = "1VS1 ANFRAGE",
            text = "Die 1vs1 Anfrage wurde abgebrochen.",
            type = "error",
            time = 3500
        }, xPlayer.source)
    end
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    local s = source
    local killer = data.killerServerId
    if isMatch[s] and isMatch[killer] then
        local matchId = isMatch[s]
        if data and data.killerServerId then
            if matches[matchId] then
                matchKills[killer] = matchKills[killer] + 1

                if roundCount[matchId] < tonumber(maxroundCount[matchId]) then
                    roundCount[matchId] = roundCount[matchId] + 1
                    TriggerClientEvent("1vs1:acceptMatch", s, matches[matchId].matchIndex, 1)
                    TriggerClientEvent("1vs1:acceptMatch", killer, matches[matchId].matchIndex, 2)
                else
                    FinishMatch(s, killer, false)
                end
            end
        end
    end
end);

FinishMatch = function(s, killer, onlyOpp)
    local KillerIdentifier = ESX.GetIdentifier(killer)
    local SourceIdentifier = ESX.GetIdentifier(s)

    local matchId = isMatch[s]
    local sKills = matchKills[s]
    local oppKills = matchKills[killer]

    matches[matchId] = nil
    roundCount[matchId] = nil
    matchKills[s] = nil
    matchKills[killer] = nil
    local winner, loser, winnerKills, loserKills

    if sKills > oppKills then
        winner, loser = s, killer
        winnerKills = sKills
        loserKills = oppKills
    elseif oppKills > sKills then
        winner, loser = killer, s

        winnerKills = oppKills
        loserKills = sKills
    elseif oppKills == sKills then
        winner, loser = killer, s

        winnerKills = oppKills
        loserKills = sKills
    end

    local xWinner = ESX.GetPlayerFromId(winner)
    xWinner.addMoney(250)

    if not onlyOpp then
        isMatch[s] = nil
    end

    isMatch[killer] = nil
    local icon = Config.Discord.designs.logo

    local webhookUrl =
    "https://discord.com/api/webhooks/1308871834841907221/sbwrUtnUP6XJ3o17Qxmj-PeKMIxVbq34botg4axyUHjQ4mJ0NjHGW34ttrtiR-Ns8s9u"

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = "⚡ 1vs1 Match Ergebnis",
        avatar_url = icon,
        embeds = {
            {
                color = 16711680,
                title = "🏆 **1vs1 Match beendet!**",
                description = table.concat({
                    "> 🎉 Gewinner: " .. CachedPlayer[SourceIdentifier].dcName .. "",
                    "> 🔫 Kills: `" .. tostring(winnerKills) .. "`",
                    "\n",
                    "> 💔 Verlierer: " .. CachedPlayer[KillerIdentifier].dcName .. "",
                    "> 🔫 Kills: `" .. tostring(loserKills) .. "`",
                    "\n",
                    "> ✨ **Gut gespielt an beide Spieler!**"
                }, "\n"),
                footer = {
                    text = "1vs1 System ✮ Lightning Crimelife",
                    icon_url = icon
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }), { ['Content-Type'] = 'application/json' })

    Wait(500)
    TriggerClientEvent("match:win", winner, winnerKills, loserKills)
    TriggerClientEvent("match:lose", loser, winnerKills, loserKills)
end

RegisterCommand("quit1vs1", function(source)
    local s = source

    if isMatch[s] then
        local matchId = isMatch[s]
        if matches[matchId] then
            local opponent = matches[matchId][s]

            FinishMatch(s, opponent, false)

            Config.HUD.Notify({
                title = "1VS1 VERLASSEN",
                text = "Das 1vs1 wurde beendet.",
                type = "error",
                time = 3500
            }, s)

            Config.HUD.Notify({
                title = "1VS1 ABGESCHLOSSEN",
                text = "Dein Gegner hat das 1vs1 verlassen.",
                type = "info",
                time = 3500
            }, opponent)
        end
    else
        Config.HUD.Notify({
            title = "FEHLER",
            text = "Du bist in keinem 1vs1-Match.",
            type = "error",
            time = 3500
        }, s)
    end
end, false)

AddEventHandler("playerDropped", function(reason)
    local s = source

    if isMatch[s] then
        local matchId = isMatch[s]
        if matches[matchId] then
            local opponent = matches[matchId][s]

            FinishMatch(s, opponent, true)

            Config.HUD.Notify({
                title = "1VS1 ABGESCHLOSSEN",
                text = "Dein Gegner hat das Spiel verlassen.",
                type = "info",
                time = 3500
            }, opponent)
        end
    end
end);
