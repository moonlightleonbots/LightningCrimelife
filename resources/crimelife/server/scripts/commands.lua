

RegisterCommand("announce", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local message = table.concat(args, " ")

    if exports[GetCurrentResourceName()]:Perms()[xPlayer.getGroup()].perms["announce"] then
        Config.HUD.announce({
            title = "ADMINISTRATIVE ANKÜNDIGUNG",
            text = message,
            time = 15000
        }, -1)

        Logs({
            title = 'Announce',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' .. xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier ..
                '**  \nNachricht: **' .. message .. '** .',
            webhook =
            "https://discord.com/api/webhooks/1312210558170431611/gjvkRdyPKOJOdTLZeJGAPpTbSjjZsglbYhk6oF5iHyfqKaNOp2W2uvVh4dgSsKeZhueB",
        })
    else
        Config.HUD.Notify({
            title = "ANNOUNCE",
            text = "Du hast keine Berechtigung für diesen Befehl",
            type = "error",
            time = 5000
        }, xPlayer.source)
    end
end, false)

RegisterCommand('goto', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xSource = ESX.GetPlayerFromId(args[1])
    if not xPlayer then
        Config.Server.Debug("^1Dieser command ist nur ingame benutzbar")
        return
    end
    if xPlayer.getGroup() == 'user' then
        return
    end
    if xSource then
        local pcoords = GetEntityCoords(GetPlayerPed(args[1]))
        SetEntityCoords(GetPlayerPed(source), pcoords)
    end
end, false)

RegisterCommand('bring', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xSource = ESX.GetPlayerFromId(args[1])
    if not xPlayer then
        Config.Server.Debug("^1Dieser command ist nur ingame benutzbar")
        return
    end
    if xPlayer.getGroup() == 'user' then
        return
    end
    if xSource then
        local pcoords = GetEntityCoords(GetPlayerPed(source))
        SetEntityCoords(GetPlayerPed(args[1]), pcoords)
    end
end, false)

RegisterCommand('supcall', function(source, args)
    if source == 0 then
        return
            Config.Server.Debug("Dieser Command geht nur Ingame")
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local group = xPlayer.getGroup()
        if group ~= "user" then
            if args[1] ~= nil then
                TriggerClientEvent('support:callPlayer', args[1], source)
                Config.HUD.Notify({
                    title = "SYSTEM",
                    text = "Spieler erfolgreich in den Support gerufen",
                    type = "success",
                    time = 5000
                }, xPlayer.source)
            else
                Config.HUD.Notify({
                    title = "SYSTEM",
                    text = "Keine ID Angegeben",
                    type = "error",
                    time = 5000
                }, xPlayer.source)
            end
        else
            Config.HUD.Notify({
                title = "SYSTEM",
                text = "Dazu hast du keine Rechte",
                type = "error",
                time = 5000
            }, xPlayer.source)
        end
    else
        if args[1] ~= nil then
            TriggerClientEvent('support:callPlayer', args[1], source)
            Config.HUD.Notify({
                title = "SYSTEM",
                text = "Spieler erfolgreich in den Support gerufen",
                type = "success",
                time = 5000
            }, xPlayer.source)
        else
            Config.HUD.Notify({
                title = "SYSTEM",
                text = "Keine ID Angegeben",
                type = "error",
                time = 5000
            }, xPlayer.source)
        end
    end
end, false)

RegisterServerEvent('support:accept', function(src)
    local source = source
    if src == -1 then
        return
    end
    Config.HUD.Notify({
        title = "SYSTEM",
        text = "Spieler hat die Support anfrage angenommen",
        type = "success",
        time = 5000
    }, src)
end);

RegisterCommand("giveall", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local winType = tostring(args[1])
    local win = tostring(args[2])
    local count = tonumber(args[3])
    local announceText

    if source == 0 or xPlayer and exports[GetCurrentResourceName()]:Perms()[xPlayer.getGroup()].perms["giveall"] then
        if winType == "item" and (not win or not count) then
            return Config.HUD.Notify({
                title = "Give All",
                text = "Bitte geben Sie den Itemnamen und eine Anzahl an. Beispiel: /giveall item ITEMNAME ANZAHL",
                type = "error",
                time = 2500
            }, xPlayer.source)
        end

        Wait(500)
        if winType == "money" then
            announceText =
            'Es sind wiedermal die Gönnerhosen an.<br>es gab einen Giveall von <span style="color: var(--serverColor);">' ..
            win .. '$</span>'
        elseif winType == "item" then
            announceText =
            'Es sind wiedermal die Gönnerhosen an.<br>es gab einen Giveall von <span style="color: var(--serverColor);">' ..
            count .. 'x</span> ' .. win .. ''
        elseif winType == "weapon" then
            announceText =
            'Es sind wiedermal die Gönnerhosen an.<br>es gab einen Giveall von einer <span style="color: var(--serverColor);">' ..
            win .. '</span> '
        elseif winType == "coins" then
            announceText =
            'Es sind wiedermal die Gönnerhosen an.<br>es gab einen Giveall von <span style="color: var(--serverColor);">' ..
            count .. ' Coins kauft euch im Gamemenu unter Cases ein Case</span>'
        end
        Wait(500)

        Config.HUD.announce({
            title = 'GIVEALL',
            text = announceText,
            time = 12000
        }, -1)

        for _, xPlayers in next, ESX.Players do
            if xPlayers then
                if winType == "money" then
                    xPlayers.addMoney(win)
                elseif winType == "item" then
                    xPlayers.addInventoryItem(win, count)
                    updateInventory(xPlayers)
                elseif winType == "weapon" and not xPlayers.hasWeapon(win:upper()) then
                    xPlayers.addWeapon(win:upper(), 250)
                    loadoutUpdate(xPlayers)
                elseif winType == "coins" then
                    xPlayer.addAccountMoney("coins", count)
                end
            end
        end
    end
end, false)