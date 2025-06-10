local eventData = {
    toggle = false,
    name = nil,
    position = nil,
}

RegisterCommand("eventann", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        local message = table.concat(args, " ")
        Config.HUD.announce({
            title = "Event Ankündigung",
            text = message,
            time = 10000
        }, -1)

        Logs({
            title = 'Event Announce',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' .. xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier ..
                '**  \nNachricht: **' .. message .. '** .',
            webhook =
            "https://discord.com/api/webhooks/1312210330411077734/ptr_4EFr35JfR-zf9IgAmPhtplHa3o_Bu3LSgJzncWtR1JtYOBjZBKvDaJzO7DQIbxFB",
        })
    end
end, false)

RegisterNetEvent("event:open", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        if not eventData.toggle then
            eventData.toggle = true
            eventData.name = name
            eventData.position = xPlayer.getCoords(true)

            Wait(250)
            TriggerClientEvent("event:updateData", -1, eventData)

            Logs({
                title = 'Event Eröffnet',
                message = 'Spieler: **' ..
                    xPlayer.name ..
                    ' [' ..
                    xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier .. '**  \nName: **' ..
                    eventData.name .. '** .',
                webhook =
                "https://discord.com/api/webhooks/1312206095883964426/PR2tcww0xsgmvW8wnxNhuGmEEPsXQeJ5KqNFIor6oqax7KOvKUpbUX6JY6WpUvuPnxjt",
            })

            Config.HUD.Notify({
                title = "Event",
                text = "Ein Event wurde gestartet: " .. eventData.name,
                type = "success",
                time = 2500
            }, xPlayer.source)

            Config.HUD.announce({
                title = "Event",
                text = "Ein Event Namens " ..
                    eventData.name .. " wurde gestartet. Über das F6 Menü könnt ihr euch teleportieren.",
                time = 15000
            }, -1)
        else
            Config.HUD.Notify({
                title = "Event",
                text = "Es läuft bereits ein Event.",
                type = "error",
                time = 2500
            }, xPlayer.source)
        end
    end
end);

RegisterNetEvent("event:close", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        if eventData.toggle then
            Config.HUD.Notify({
                title = "Event",
                text = "Das Event wurde beendet.",
                type = "success",
                time = 2500
            }, xPlayer.source)

            Config.HUD.announce({
                title = "Event",
                text = "Der Teleport zum Event: " .. eventData.name .. " wurde Administrativ Gestopt.",
                time = 5000
            }, -1)

            Logs({
                title = 'Event Geschlossen',
                message = 'Spieler: **' ..
                    xPlayer.name ..
                    ' [' ..
                    xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier .. '**  \nName: **' ..
                    eventData.name .. '** .',
                webhook =
                "https://discord.com/api/webhooks/1312206635891949608/ddPRmOzzYE74dI7MVKzZ0YuWeMDp-wp1462qQwMpuAiVcbhdtwQEBz49l1cpxZk2zg0_",
            })

            eventData.toggle = false
            eventData.name = nil
            eventData.position = nil
            TriggerClientEvent("event:updateData", -1, eventData)
        end
    end
end);

RegisterNetEvent("event:join", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if eventData.toggle and eventData.name then
        xPlayer.setCoords(eventData.position)
        Config.HUD.Notify({
            title = "Event",
            text = "Du wurdest zum Event teleportiert.",
            type = "success",
            time = 2500
        }, xPlayer.source)

        Logs({
            title = 'Event Betreten',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' .. xPlayer.source ..
                ']**\nIdentifier: **' .. xPlayer.identifier .. '**  **\nName: **' .. eventData.name .. '** .',
            webhook =
            "https://discord.com/api/webhooks/1312206584859983972/UeXhORZ343v6-CE_uO9MjjOdL7YGs2sQY8aTgyIWq2TgsJ5KBVp2t6jcO7HBz99YvYIh",
        })
    else
        Config.HUD.Notify({
            title = "Event",
            text = "Es läuft kein Event.",
            type = "error",
            time = 2500
        }, xPlayer.source)
    end
end);

RegisterNetEvent("event:refund", function(id, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(id)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        target.addMoney(money)
        Config.HUD.Notify({
            title = "EVENT",
            text = "Du hast dem Spieler " .. target.name .. " " .. money .. "$ gegeben",
            type = "success",
            time = 2500
        }, xPlayer.source)

        Config.HUD.Notify({
            title = "EVENT",
            text = "Du hast von " .. xPlayer.name .. " " .. money .. "$ erhalten",
            type = "success",
            time = 2500
        }, target.source)

        Logs({
            title = 'Geld Rückerstattung',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '**  \nCount: **' ..
                money ..
                '** \n\nGegeben an: **' ..
                target.name .. ' [' .. target.source .. ']**\nIdentifier: **' .. target.identifier .. '** .',
            webhook =
            "https://discord.com/api/webhooks/1312206819443343372/it1YDmaiytfYKUbcaav2NBQlbJvzZojmki5WDdoCmiuupnS3bNI4-Lc9x4Z2ro4PT1wE",
        })
    end
end);

RegisterNetEvent("event:weaponrefund", function(id, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(id)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        if not target.hasWeapon(weapon) then
            Config.HUD.Notify({
                title = "EVENT",
                text = "Du hast dem Spieler die Waffe " .. weapon .. " gegeben",
                type = "success",
                time = 2500
            }, xPlayer.source)
            Config.HUD.Notify({
                title = "EVENT",
                text = "Du hast die Waffe " .. weapon .. " erhalten",
                type = "success",
                time = 2500
            }, target.source)

            Logs({
                title = 'Waffe Rückerstattung',
                message = 'Spieler: **' ..
                    xPlayer.name ..
                    ' [' ..
                    xPlayer.source ..
                    ']**\nIdentifier: **' ..
                    xPlayer.identifier ..
                    '**  \nWaffe: **' ..
                    weapon ..
                    '** \n\nGegeben an: **' ..
                    target.name .. ' [' .. target.source .. ']**\nIdentifier: **' .. target.identifier .. '** .',
                webhook =
                "https://discord.com/api/webhooks/1312208033832763512/z8mPKJ6AJLef4wv3wC9rs7I3eRXBy7EMPMtQmd2kWKs5J2vpP8gk2dBsNnA5gCcUazCz",
            })

            target.addWeapon(weapon, 250)
            loadoutUpdate(target)
        else
            Config.HUD.Notify({
                title = "EVENT",
                text = "Dieser Spieler hat diese Waffe Bereits",
                type = "error",
                time = 2500
            }, xPlayer.source)
        end
    end
end);

RegisterNetEvent("event:ItemsRefund", function(id, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(id)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        Config.HUD.Notify({
            title = "EVENT",
            text = "Du hast dem Spieler das Item " .. item .. " gegeben",
            type = "success",
            time = 2500
        }, xPlayer.source)
        Config.HUD.Notify({
            title = "EVENT",
            text = "Du hast das Item " .. item .. " erhalten",
            type = "success",
            time = 2500
        }, target.source)

        Logs({
            title = 'Item Rückerstattung',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '**  \nItem: **' ..
                item ..
                '** \n\nGegeben an: **' ..
                target.name .. ' [' .. target.source .. ']**\nIdentifier: **' .. target.identifier .. '** .',
            webhook =
            "https://discord.com/api/webhooks/1312208033832763512/z8mPKJ6AJLef4wv3wC9rs7I3eRXBy7EMPMtQmd2kWKs5J2vpP8gk2dBsNnA5gCcUazCz",
        })

        target.addInventoryItem(item, count)
        updateInventory(target)
    end
end);

RegisterNetEvent("event:safezone:open", function(radius)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        TriggerClientEvent("event:safezone:open", -1, xPlayer.getCoords(true), radius)

        Logs({
            title = 'Safezone Erstellt',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '** \nGröße: **' ..
                radius ..
                '**\nCoords: **' ..
                vec3(xPlayer.getCoords(true).x, xPlayer.getCoords(true).y, xPlayer.getCoords(true).z) .. '**',
            webhook =
            "https://discord.com/api/webhooks/1312208210907631667/-QM3Wj0R3_r6fR2m0SS8f_ThoEjFIK1V-rxbwRmlRThwEq2-9lVd70EmRrrvmyOY9XYd",
        })
    end
end);

RegisterNetEvent("event:safezone:close", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        TriggerClientEvent("event:safezone:close", -1)

        Logs({
            title = 'Safezone Geschlossen',
            message = 'Spieler: **' ..
                xPlayer.name .. ' [' .. xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier .. '***',
            webhook =
            "https://discord.com/api/webhooks/1312208459596566609/emRfSI7sVnptNek5_003zUlloFONGOBBMeTJgjOqFiVG04QPp5JFVDb7xRQZC9MB2b6-",
        })
    end
end);

RegisterNetEvent("event:bubble", function(size, rotation, damage)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        TriggerClientEvent("event:bubble", -1, xPlayer.getCoords(true), size, rotation, damage)

        Logs({
            title = 'Bubble Erstellt',
            message = 'Spieler: **' ..
                xPlayer.name ..
                ' [' ..
                xPlayer.source ..
                ']**\nIdentifier: **' ..
                xPlayer.identifier ..
                '** \nRotation: **' ..
                tostring(rotation) ..
                '**\nGröße: **' ..
                size ..
                '**\nCoords: **' ..
                vec3(xPlayer.getCoords(true).x, xPlayer.getCoords(true).y, xPlayer.getCoords(true).z) .. '**',
            webhook =
            "https://discord.com/api/webhooks/1312209486886207488/xFN4jBSrxOz2qgktv-W5RFhebnrVigbwvEAUL-lwGdf-HcavD-ladrH7oPTneDjQFuvE",
        })
    end
end);

RegisterNetEvent("event:bubble:close", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if hasRole then
        TriggerClientEvent("event:bubble:close", -1)

        Logs({
            title = 'Bubble Geschlossen',
            message = 'Spieler: **' ..
                xPlayer.name .. ' [' .. xPlayer.source .. ']**\nIdentifier: **' .. xPlayer.identifier .. '**',
            webhook =
            "https://discord.com/api/webhooks/1312209694928146453/ZLHWAndk1udQVC9SdiUgBUahQnP0p9zmvK87hS5WDikLjCs0BwcFajxmTvxmIi0TLhCa",
        })
    end
end);