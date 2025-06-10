local killzone = {
    toggle = false,
    curZone = nil,
    admin = false,
    time = 3 * 60,
    players = {}
}

local lastWinner = nil

local function endZone()
    local webhookMessage
    local webhook

    if killzone.toggle then
        TriggerClientEvent("killzone:close", -1)

        local annText
        if killzone.admin then
            annText = "Die Killzone wurde Administrativ beendet!"
            webhookMessage = 'Die Killzone wurde Administrativ beendet!'
            webhook =
            "https://discord.com/api/webhooks/1312212301218189434/Mi_UHickm3blDLWZufjz-ZGz11HGr3aEGi6DBNLoAolzcuiZBUWjg2u9C6meYCI1YYeN"
        else
            local sortedPlayers = {}

            for playerId, playerData in next, killzone.players do
                table.insert(sortedPlayers, { id = playerId, points = playerData.points, name = playerData.name })
            end

            table.sort(sortedPlayers, function(a, b)
                return a.points > b.points
            end);

            if #sortedPlayers > 0 then
                local winner = sortedPlayers[1]
                local xPlayer = ESX.GetPlayerFromId(winner.id)
                if xPlayer then
                    lastWinner = { name = xPlayer.name, id = xPlayer.source, identifier = xPlayer.identifier }

                    webhookMessage = 'Gewinner: **' .. xPlayer.name ..
                        ' [' .. xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier .. '**'
                    webhook =
                    "https://discord.com/api/webhooks/1312212185690148884/seA4TERctWJXJ80d8xE6jClaWiLlEvVRYV45jSV43opzj-m-oyJuvQxVTGMDawGwZsD7"
                    xPlayer.addMoney(Config.pvp.MoneyDrops.win)
                    Config.HUD.Notify({
                        title = "KILLZONE GEWINNER",
                        text = "Du hast die Killzone gewonnen und 10000$ erhalten!",
                        type = "success",
                        time = 5000
                    }, xPlayer.source)
                else
                    webhookMessage = 'Es konnte kein Gewinner gefunden werden!'
                end

                annText = 'Die Killzone wurde beendet! und es gab ein Gewinner namens <span style="color: rgb(' ..
                    Config.Server.color.r .. ', ' .. Config.Server.color.g .. ', ' .. Config.Server.color.b .. ');">' ..
                    (lastWinner and lastWinner.name or "Unbekannt") .. '</span>'
            end
        end

        Config.HUD.announce({
            title = "KILLZONE BEENDET",
            text = annText,
            time = 25000
        }, -1)

        Logs({
            title = 'KILLZONE GESCHLOSSEN',
            message = webhookMessage .. ' \nJson String von der Zone: \n ```' .. json.encode(killzone) .. '```',
            webhook = webhook,
        })

        killzone.curZone = nil
        killzone.admin = false
        killzone.time = 3 * 60

        Wait(10000)
        if #killzone.players > 0 then
            killzone.players = {}
        end

        Wait(10 * 60000)
        killzone.toggle = false
    end
end


local StartTimer = function()
    while killzone.toggle and killzone.time > 0 do
        Wait(1000);

        killzone.time -= 1;

        TriggerClientEvent('killzone:UpdateTime', -1, killzone.time);

        if killzone.time == 0 then
            endZone();
            break;
        end
    end
end

RegisterCommand("killzone", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        if args[1] == "start" then
            if not killzone.toggle then
                local randomIndex = math.random(1, #Config.pvp.killzone.zones)
                local config = Config.pvp.killzone.zones[randomIndex]

                killzone.toggle = true
                killzone.curZone = config
                killzone.name = config.name
                TriggerClientEvent("killzone:open", -1, config)

                Logs({
                    title = 'KILLZONE ERSTELLT',
                    message = 'Spieler: **' ..
                        xPlayer.name ..
                        ' [' ..
                        xPlayer.source ..
                        ']**\nIdentifier: **' ..
                        xPlayer.identifier ..
                        '**  \nJson String von der Zone: \n ```' .. json.encode(killzone.curZone) .. '``` .',
                    webhook =
                    "https://discord.com/api/webhooks/1312211328093524078/ZoXsXWh9d84XVXAd4m-uqqdaxowVgj5fFMshyeRdIN_o71MAml-yhRlPnJy5X2lJx-kh",
                })

                Config.HUD.announce({
                    title = "KILLZONE ERÖFFNUNG",
                    text = "Es wurde eine Killzone beim " ..
                        config.name .. " eröffnet du kannst über das F6 Menü die Killzone Betreten viel Spaß!",
                    time = 25000
                }, -1)

                StartTimer()
            end
        elseif args[1] == "stop" then
            killzone.admin = true
            endZone()
        else
            if xPlayer then
                Config.HUD.Notify({
                    title = "KILLZONE FEHLER",
                    text = "Verwende /killzone start oder /killzone stop",
                    type = "error",
                    time = 2500,
                }, xPlayer.source)
            elseif source == 0 then
                Config.Server.Debug("Verwende /killzone start oder /killzone stop")
            end
        end
    end
end, false)

RegisterNetEvent("killzone:join", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)

    if killzone.toggle then
        if not killzone.players[xPlayer.source] then
            killzone.players[xPlayer.source] = {
                name = xPlayer.name,
                points = 0,
            }

            Config.HUD.Notify({
                title = "KILLZONE",
                text = "Du bist der Killzone beigetreten!",
                type = "success",
                time = 5000
            }, xPlayer.source)
        end
    end
end);

RegisterNetEvent("killzone:leave", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if killzone.toggle then
        if killzone.players[xPlayer.source] then
            killzone.players[xPlayer.source] = nil

            Config.HUD.Notify({
                title = "KILLZONE",
                text = "Du hast die Killzone verlassen!",
                type = "success",
                time = 5000
            }, xPlayer.source)
        end
    end
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    if killzone.toggle then
        if data and data.killerServerId then
            local xTarget = ESX.GetPlayerFromId(data.killerServerId)
            local xPlayer = ESX.GetPlayerFromId(source)

            if killzone.players[xTarget.source] then
                killzone.players[xTarget.source].points = (killzone.players[xTarget.source].points or 0) + 1
                TriggerClientEvent("killzone:updatePoints", xTarget.source, killzone.players[xTarget.source].points)
            end

            if killzone.players[xPlayer.source] then
                killzone.players[xPlayer.source].points = (killzone.players[xPlayer.source].points or 0) - 1
                TriggerClientEvent("killzone:updatePoints", xPlayer.source, killzone.players[xPlayer.source].points)
            end
        end
    end
end);