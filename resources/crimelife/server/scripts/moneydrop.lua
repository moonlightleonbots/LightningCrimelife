RegisterCommand("moneydrop", function(s)
    local xPlayer = ESX.GetPlayerFromId(s)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if Config.pvp.MoneyDrops.isActive then
        return
    end

    if not Config.pvp.MoneyDrops.isActive then
        Config.pvp.MoneyDrops.isActive = true
        if s == 0 or xPlayer and hasRole then
            Config.pvp.MoneyDrops.currentZone = Config.pvp.MoneyDrops.zones[math.random(#Config.pvp.MoneyDrops.zones)]
            TriggerClientEvent("moneydrop:draw", -1, Config.pvp.MoneyDrops.currentZone)
            Config.HUD.announce({
                title = 'Moneydrop',
                text = 'es wurde ein Moneydrop erschaffen, schaue auf die Map um die Location genauer zu sehen!',
                time = 20000
            }, -1)

            Logs({
                title = 'Moneydrop Erstellt',
                message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '**  \nJson String von der Zone: \n ```' .. json.encode(Config.pvp.MoneyDrops.currentZone) .. '``` .',
                webhook =
                "https://discord.com/api/webhooks/1312210800110342145/j15Ur9QjanyDaqqNMxPkehCLAW67urWUN_Wu1lBS8hnY6W9zUMipUD8i0ZrtDZ5lQ9KE",
            })
        end
    end
end, false)

RegisterServerEvent("moneydrop:pickup", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if Config.pvp.MoneyDrops.isActive then
        Config.pvp.MoneyDrops.isActive = false
        if xPlayer.source == id then
            xPlayer.addMoney(Config.pvp.MoneyDrops.win)
            Config.HUD.announce({
                title = 'Moneydrop',
                text = 'Der Spieler <span style="color: rgb(' ..
                Config.Server.color.r ..
                ', ' ..
                Config.Server.color.g ..
                ', ' ..
                Config.Server.color.b .. ');">' .. xPlayer.name .. '</span> hat den Moneydrop erfolgreich eingenommen!',
                time = 10000,
            }, -1)

            Logs({
                title = 'Moneydrop Claimed',
                message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '**  \nJson String von der Zone: \n ```' .. json.encode(Config.pvp.MoneyDrops.currentZone) .. '``` .',
                webhook =
                "https://discord.com/api/webhooks/1312211034328662106/hP7Qkf-yR_jANA5JzkytrqGV7FMfYI0Fbt0-S78RUepf9sjZ2NXKJskCDoOXS60EXgY6",
            })
        end
    end
end);

RegisterServerEvent("moneydrop:markerStatus")
AddEventHandler("moneydrop:markerStatus", function(status)
    TriggerClientEvent("moneydrop:markerStatus:client", -1, status)
end);
