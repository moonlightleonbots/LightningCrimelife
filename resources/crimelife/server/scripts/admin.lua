local warns = {}

ESX.RegisterServerCallback('admin:getPlayers', function(src, cb)
    cb(ESX.Players)
end)

RegisterNetEvent("admin:warnPlayer", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then return end

    if not warns[data.source] then
        warns[data.source] = 0
    end

    warns[data.source] = warns[data.source] + 1

    Config.HUD.announce({
        title = "Verwarnung " .. warns[data.source] .. "/3",
        text = "Spieler " ..
            GetPlayerName(data.source) ..
            " wurde von " .. xPlayer.name .. " verwarnt mit dem Grund: " .. data.reason .. ".",
        time = 10000
    }, -1)

    if warns[data.source] >= 3 then
        DropPlayer(data.source,
            "🛡️ Du wurdest von Lightning Crimelife gekickt, \n\nGrund: 3/3 Verwarnungen\n\nVon: " ..
            xPlayer.name .. " [" .. xPlayer.source .. "] ")
    end
end)


RegisterNetEvent("admin:KickPlayer", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then return end

    Config.HUD.announce({
        title = "Spieler Kick",
        text = "Spieler " ..
            GetPlayerName(data.source) ..
            " wurde von " .. xPlayer.name .. " Geklickt mit dem Grund: " .. data.reason .. ".",
        time = 10000
    }, -1)

    DropPlayer(data.source,
        "🛡️ Du wurdest von Lightning Crimelife gekickt, \n\nGrund: " ..
        data.reason .. "\n\nVon: " .. xPlayer.name .. " [" .. xPlayer.source .. "] ")
end)
