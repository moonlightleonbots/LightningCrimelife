local tx = {
    name = "TX Admin",

    webhooks = {
        -- seperate channels.
        Revoke =
        "https://discord.com/api/webhooks/1304490367751688212/OpwQKiM_xY_VPkY-zjvqbsFn8MqiEgP8dKcEy-R7TaBNzsJgBFKdBBamvJMTA018uxyY",
        Ban =
        "https://discord.com/api/webhooks/1304129707339419689/s0u1wONa-CU7PgC1yEk0JFZK_A4y9EHMxRnbjLUWyFNVXkUPRpiQsPS9WQ5DNg0XAR0F",
        Warn =
        "https://discord.com/api/webhooks/1304489007509536852/93_e7ZWnl08S1vkXRzk1L_XRGfFb4cvepoApLkSheJg7bsC3IUGOY5DBZbQw1XY7ypBV",
        Heal =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
        Whitelist =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
        Kick =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
        Announce =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
        Restart =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
        DM =
        "https://discord.com/api/webhooks/1304489175869034640/M1qBbIcf8kNKAyZmQcKk6TOaqKIATFgkGI0z5mip8JgrTRvlvzvnB0-IKhvi4MN1-Ubs",
    }
}

-- [ Announcement logs ]
AddEventHandler('txAdmin:events:announcement', function(eventData)
    local author = eventData.author
    local msg = eventData.message

    if author == 'txAdmin' then
        Config.HUD.announce({
            title = 'TXADMIN ANKÜNDIGUNG',
            text = msg,
            time = 12000,
        }, -1)
    else
        Config.HUD.announce({
            title = 'TXADMIN ANKÜNDIGUNG von ' .. author .. '',
            text = msg,
            time = 12000,
        }, -1)
    end

    Log({
        wb = tx.webhooks.Announce,
        message = author .. ' hat eine Ankündigung gemacht: ' .. msg,
    })
end);

-- [ Restart logs ]
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 500 then
        Log({
            wb = tx.webhooks.Restart,
            message = "Der Server wird in 10 Minuten Neu Gestartet"
        })
        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 10 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining == 300 then
        Log({
            wb = tx.webhooks.Restart,
            message = "Der Server wird in 5 Minuten Neu Gestartet"
        })
        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 5 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining == 240 then
        Log({
            wb = tx.webhooks.Restart,
            message = "Der Server wird in 4 Minuten Neu Gestartet"
        })
        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 4 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining == 180 then
        Log({
            wb = tx.webhooks.Restart,
            message = "Der Server wird in 3 Minuten Neu Gestartet"
        })
        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 3 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining == 120 then
        Log({
            wb = tx.webhooks.Restart,
            message = "Der Server wird in 2 Minuten Neu Gestartet"
        })
        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 2 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining == 60 then
        Log({
            wb = tx.webhooks.Restart,
            message = 'Der Server wird in 1 Minuten Restartet.',
        })

        Config.HUD.announce({
            title = 'Server Restart',
            text = 'Der Server wird in 1 Minuten Restartet 😥',
            time = 5000,
        }, -1)
    elseif eventData.secondsRemaining < 10 then
        Log({
            wb = tx.webhooks.Restart,
            message = 'Der Server wird jetzt Restartet.',
        })
    end
end);

-- [ DM logs ]
AddEventHandler('txAdmin:events:playerDirectMessage', function(eventData)
    Log({
        wb = tx.webhooks.DM,
        message = '**' ..
            eventData.author ..
            '** hat **' ..
            GetPlayerName(eventData.target) .. '** eine DM geschickt. Inhalt: **' .. eventData.message .. '**',
    })
end);

-- [ Revoke logs ]
AddEventHandler('txAdmin:events:actionRevoked', function(eventData)
    local action = "Unknown"
    if eventData.actionType == 'ban' then
        action = "Ban"
    elseif eventData.actionType == 'warn' then
        action = "Warn"
    end

    Log({
        wb = tx.webhooks.Revoke,
        message = eventData.revokedBy .. ' hat ' .. action .. ' zurückgenommen.',
    })
end);

-- [ Kick logs ]
AddEventHandler('txAdmin:events:playerKicked', function(eventData)
    local steamid = "Not Found"
    local license = "Not Found"
    local discord = "Not Found"
    local ip      = "Not Found"

    for k, v in next, GetPlayerIdentifiers(eventData.target) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v:gsub('ip:', ''):gsub('ip:', '')
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end

    Log({
        wb = tx.webhooks.Kick,
        message = eventData.author ..
            ' hat ' ..
            eventData.target ..
            ' gekickt. Grund: ' ..
            eventData.reason ..
            '\n***Spieler Data:*** \nSteam ID: ' ..
            steamid .. '\nLicense: ' .. license .. '\nDiscord: ' .. discord .. '\nIP Address: ' .. ip,
    })
end);

-- [ Ban logs - Doesn't work for offline bans ]
AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    Config.HUD.announce({
        title = 'TxAdmin',
        text = 'Der Spieler ' ..
            eventData.targetName .. ' wurde von ' .. eventData.author .. ' gebannt. Grund: ' .. eventData.reason,
        time = 12000,
    }, -1)

    Log({
        wb = tx.webhooks.Ban,
        message = eventData.author .. ' hat ' .. eventData.targetName .. ' gebannt. Grund: ' .. eventData.reason,
    })
end);

-- [ Warn logs ]

AddEventHandler('txAdmin:events:playerWarned', function(eventData)
    local steamid = "Not Found"
    local license = "Not Found"
    local discord = "Not Found"
    local ip      = "Not Found"

    Config.HUD.announce({
        title = 'TxAdmin',
        text = 'Der Spieler ' ..
            eventData.targetName .. ' wurde von ' .. eventData.author .. ' verwarnt. Grund: ' .. eventData.reason,
        time = 10000,
    }, -1)

    Log({
        wb = tx.webhooks.Warn,
        message = '**' ..
            eventData.author ..
            '** hat **' ..
            eventData.targetName ..
            '** verwarnt. Grund: **' ..
            eventData.reason ..
            '**',
    })
end);

-- [ Heal logs ]
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    Author = GetPlayerName(eventData.id)
    Log({
        wb = tx.webhooks.Heal,
        message = Author .. ' wurde geheilt.',
    })
end);

-- [ Server shutdown logs ]
AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)
    Log({
        wb = tx.webhooks.Heal,
        message = 'Der Server wird von **' ..
            eventData.author ..
            '** in **' .. eventData.delay .. '** Millisekunden heruntergefahren. Grund: **' .. eventData.message .. '**',
    })
end);

-- [ Whitelist logs ]
AddEventHandler('txAdmin:events:whitelistPlayer', function(eventData)
    local text = ''
    if eventData.action == "added" then
        text = 'Der Spieler **' ..
            eventData.playerName .. '** wurde von **' .. eventData.adminName .. '** zur Whitelist **hinzugefügt**.'
    elseif eventData.action == "removed" then
        text = 'Der Spieler **' ..
            eventData.playerName .. '** wurde von **' .. eventData.adminName .. '** von der Whitelist **entfernt**.'
    end

    Log({
        wb = tx.webhooks.Whitelist,
        message = text,
    })
end);

function Log(data)
    local embed = {
        color = 16711680,
        title = tx.name,
        description = data.message,
        footer = {
            text = os.date("%x %X %p"),
            icon_url = Config.Discord.designs.logo,
        },
    }
    PerformHttpRequest(data.wb, nil, 'POST', json.encode({
        username = tx.name,
        embeds = { embed },
        avatar_url = Config.Discord.designs.logo,
    }), { ['Content-Type'] = 'application/json' })
end
