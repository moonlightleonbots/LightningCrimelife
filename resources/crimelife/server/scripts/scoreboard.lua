logs = {
    time = 60,
    toggle = false,

    webhooks = {
        ["killstreak"] =
        "https://discord.com/api/webhooks/1302324072499122187/9rw4FdqDnYHnrJ3xKlBtoS0rfGSPqI7IKpcstIL5EU40cahe3K3bn_nDVtuZGu_5Opb7",
        ["ffa"] =
        "https://discord.com/api/webhooks/1302395921304256592/KbL9CtfzdWX4AlIcV7vePLTDv5lGoZYlr4YI3tZ2f07bUggaAt7KsQr-suQiRtJSAWaW",
        ["gungame"] =
        "https://discord.com/api/webhooks/1302395753573912627/BrZLqKjvqeEsOyzhBf2QxbzYvmEEgUIgSZ5RSP8DbQ6vChl00eVVisn3K3s4_1Fqro61",
        ["gangkrieg"] =
        "https://discord.com/api/webhooks/1302395956561711174/VGfSIRxOgPxZAN2VWRv8todRkq4zb-a70fvvZYg5uXfkmF01-QxMOQnaDIOlejqirkCl",
        ["scoreboard"] =
        "https://discord.com/api/webhooks/1302327498268475442/4YdSt1aMJxD1OR1aILwWJqju78MhRYc6o0AK2V3sj579HuNLJVihPFbqRGz6XBqastLB",
        ["factionPoints"] =
        "https://discord.com/api/webhooks/1304995612978188362/ILv4tHN57ni9DiG6iXR2SiznKFXMOZ8YLwVl6NjZB4xvXGJVlX5xZyfNB_GAZVl1dDrG",

        ["factionlist"] =
        "https://discord.com/api/webhooks/1305002234425118741/yDsfjyf0wmNMZW62hTrlUitu5cvlz-FtrjIhmoUIjnSGt6Ih1OirCYQHktDBW_yY4nZR",

        ["midroll"] =
        "https://discord.com/api/webhooks/1312446776980148306/AG862n3EWE8RVCwTd1Or9Z79pq7shbLWXminmpsIl8Mdb4enO2NIpRXIgnNYplhXxa4o"
    }
}

function SendDashboard(message, name, wh, dashboardName, img)
    if logs.toggle then
        exports[GetCurrentResourceName()]:SendWebhook(wh, {
            username = name .. " ✮ Lightning Crimelife",
            content = '',
            embeds = { {
                color = 16711680,
                title = '',
                description = message,
                footer = {
                    text = "" .. name .. " ● " .. os.date("%X %x %p"),
                },
                image = {
                    url = img
                },
            } },
            avatar_url = Config.Discord.designs.logo
        }, dashboardName)
    end
end

MySQL.ready(function()
    while true do
        -- FFA
        CreateThread(function()
            MySQL.query('SELECT ffa_kills, ffa_deaths, discordid FROM users ORDER BY ffa_kills DESC LIMIT 25', {},
                function(stats)
                    local ffaText = '%s %s - %s Kills **(%s K/D)**\n\n'
                    if #stats > 0 then
                        local ffamsg = ''
                        for i, stat in next, (stats) do
                            local icon = ""
                            if i == 1 then
                                icon = ":first_place:"
                            elseif i == 2 then
                                icon = ":second_place:"
                            elseif i == 3 then
                                icon = ":third_place:"
                            else
                                icon = '`#' .. i .. '`'
                            end

                            if stat.discordid then
                                discordID = "<@" .. stat.discordid .. ">"
                            else
                                discordID = "NOT FOUND"
                            end

                            ffamsg = ffamsg ..
                                ffaText:format(icon, discordID, stat.ffa_kills,
                                    ('%02.2f'):format(stat.ffa_kills / stat.ffa_deaths))
                        end
                        SendDashboard(ffamsg, 'FFA', logs.webhooks["ffa"], 'ffa', Config.Discord.designs.banner.pvp.ffa)
                        Config.Server.Debug('Webhook ^5FFA^0 gesendet')
                    end
                end);
        end)

        -- GUNGAME
        MySQL.query('SELECT gungamewins, discordid FROM users ORDER BY gungamewins DESC LIMIT 25', {},
            function(stats)
                local gungameText = '%s %s - **(%s Wins)**\n\n'
                if #stats > 0 then
                    local gungamemsg = ''
                    for i, stat in next, (stats) do
                        local icon = ""
                        if i == 1 then
                            icon = ":first_place:"
                        elseif i == 2 then
                            icon = ":second_place:"
                        elseif i == 3 then
                            icon = ":third_place:"
                        else
                            icon = '`#' .. i .. '`'
                        end

                        if stat.discordid then
                            discordID = "<@" .. stat.discordid .. ">"
                        else
                            discordID = "NOT FOUND"
                        end

                        gungamemsg = gungamemsg .. gungameText:format(icon, discordID, stat.gungamewins)
                    end
                    SendDashboard(gungamemsg, 'Gungame', logs.webhooks["gungame"], 'gungame',
                        Config.Discord.designs.banner.pvp.gungame)
                    Config.Server.Debug('Webhook ^5Gungame^0 gesendet')
                end
            end);

        -- SCOREBOARD STATS
        MySQL.query('SELECT kills, deaths, discordid FROM users ORDER BY kills DESC LIMIT 25', {}, function(stats)
            local statsText = '%s %s - %s Kills **(%s K/D)**\n\n'
            if #stats > 0 then
                local statsMSG = ''
                for i, stat in next, (stats) do
                    local icon = ""
                    if i == 1 then
                        icon = ":first_place:"
                    elseif i == 2 then
                        icon = ":second_place:"
                    elseif i == 3 then
                        icon = ":third_place:"
                    else
                        icon = '`#' .. i .. '`'
                    end

                    if stat.discordid then
                        discordID = "<@" .. stat.discordid .. ">"
                    else
                        discordID = "NOT FOUND"
                    end

                    statsMSG = statsMSG .. statsText:format(icon, discordID, stat.kills,
                        ('%02.2f'):format(stat.kills / stat.deaths))
                end
                SendDashboard(statsMSG, 'Scoreboard', logs.webhooks["scoreboard"], 'scoreboard',
                    Config.Discord.designs.banner.dashboard)
                Config.Server.Debug('Webhook ^5Scoreboard^0 gesendet')
            end
        end);

        local factionsFile = LoadResourceFile(GetCurrentResourceName(), "json/factions.json")
        local data = json.decode(factionsFile) or {}

        -- FACTION LIST
        local description = ""
        local pendingQueries2 = 0
        for k, v in next, data do
            local online = ESX.GetExtendedPlayers("job", v.name)
            local ownerID = "NOT FOUND"

            pendingQueries2 = pendingQueries2 + 1

            MySQL.Async.fetchAll('SELECT discordid FROM users WHERE job = @job LIMIT 1', {
                ['@job'] = v.name
            }, function(ownerResult)
                if ownerResult and ownerResult[1] and ownerResult[1].discordid then
                    ownerID = "<@" .. ownerResult[1].discordid .. ">"
                end

                local xPlayers = #online
                local offlinePlayers = #ESX.GetPlayers() - xPlayers


                description = description ..
                    '**' ..
                    v.label ..
                    ':** ' ..
                    (ownerID == "NOT FOUND" and "NOT FOUND" or ownerID) ..
                    ' - **(' .. xPlayers .. '/' .. offlinePlayers .. ') Online**\n\n'

                pendingQueries2 = pendingQueries2 - 1

                if pendingQueries2 == 0 then
                    SendDashboard(description, 'Fraktionsliste', logs.webhooks["factionlist"], 'fraktionsliste',
                        Config.Discord.designs.banner.factions.list)
                    Config.Server.Debug('Webhook ^5Fraktionsliste^0 gesendet')
                end
            end);
        end

        -- GANGWAR PUNKTE
        MySQL.query('SELECT name, label, gwpunkte FROM jobs ORDER BY gwpunkte DESC LIMIT 25', {},
            function(factionStats)
                if factionStats then
                    local factionPointsText = '%s **%s** %s - **(%s Punkte)**\n\n'
                    local factionPointsMsg = ''
                    local factionData = {}
                    local pendingQueries = #factionStats

                    for i, faction in ipairs(factionStats) do
                        if faction.name ~= "unemployed" then
                            local isRelevant = false

                            for _, v in ipairs(data) do
                                if faction.name == v.name then
                                    isRelevant = true
                                    break
                                end
                            end

                            if isRelevant then
                                local alreadyProcessed = false

                                for _, existingFaction in ipairs(factionData) do
                                    if existingFaction.name == faction.name then
                                        alreadyProcessed = true
                                        break
                                    end
                                end

                                if not alreadyProcessed then
                                    local icon = ""
                                    if i == 1 then
                                        icon = ":first_place:"
                                    elseif i == 2 then
                                        icon = ":second_place:"
                                    elseif i == 3 then
                                        icon = ":third_place:"
                                    else
                                        icon = '`#' .. i .. '`'
                                    end

                                    MySQL.query('SELECT discordid FROM users WHERE job = @job LIMIT 1',
                                        { ['@job'] = faction.name },
                                        function(ownerResult)
                                            local ownerID = "NOT FOUND"
                                            if ownerResult and ownerResult[1] and ownerResult[1].discordid then
                                                ownerID = "<@" .. ownerResult[1].discordid .. ">"
                                            end

                                            table.insert(factionData, {
                                                icon = icon,
                                                label = faction.label,
                                                gwpunkte = faction.gwpunkte,
                                                ownerID = ownerID
                                            })

                                            pendingQueries = pendingQueries - 1
                                            if pendingQueries == 0 then
                                                table.sort(factionData, function(a, b)
                                                    return a.gwpunkte > b.gwpunkte
                                                end)

                                                for _, data in ipairs(factionData) do
                                                    factionPointsMsg = factionPointsMsg ..
                                                        factionPointsText:format(data.icon, data.label, data.ownerID,
                                                            data.gwpunkte)
                                                end

                                                SendDashboard(factionPointsMsg, 'Fraktionspunkte',
                                                    logs.webhooks["factionPoints"],
                                                    'fraktionspunkte', Config.Discord.designs.banner.factions.points)
                                                Config.Server.Debug('Webhook ^5Fraktionspunkte^0 gesendet')
                                            end
                                        end)
                                else
                                    pendingQueries = pendingQueries - 1
                                end
                            else
                                pendingQueries = pendingQueries - 1
                            end
                        else
                            pendingQueries = pendingQueries - 1
                        end
                    end
                end
            end)

        Wait(logs.time * 60000);
    end
end);
