Token = LoadResourceFile(GetCurrentResourceName(), '../crimelife/token')

ESX.RegisterServerCallback('Menu:GetPlayerData', function(s, cb, target)
    local xTarget = ESX.GetPlayerFromId(target)
    MySQL.query('SELECT kills, deaths, trophys, xp FROM users WHERE identifier=?', { xTarget.identifier }, function(r)
        local dcId = GetPlayerIdentifierByType(target, 'discord')
        local userId = dcId and dcId:sub(#'discord:' + 1) or '973670159149588500'
        PerformHttpRequest('https://discord.com/api/v10/guilds/1302105599097704528/members/' .. userId,
            function(code, data, headers)
                if code == 200 then
                    local user = json.decode(data)
                    cb({
                        kills = r[1].kills,
                        deaths = r[1].deaths,
                        trophies = r[1].trophys,
                        rank = Config.HUD.getLiga(r[1].trophys).label,
                        name = user.user.username,
                        dcid = userId,
                        xp = r[1].xp,
                        level = Config.Battlepass.GetLevel(r[1].xp).level,
                    })
                else
                    cb({
                        kills = r[1].kills,
                        deaths = r[1].deaths,
                        name = 'N/A',
                        dcid = 'N/A',
                        trophies = r[1].trophys,
                        rank = Config.HUD.getLiga(r[1].trophys).label,
                        xp = r[1].xp,
                        level = Config.Battlepass.GetLevel(r[1].xp).level,
                    })
                end
            end, 'GET', '', {
                Authorization = 'Bot ' .. Token
            })
    end);
end);

RegisterNetEvent("ali:copyOutfit:request", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if id then
        local xTarget = ESX.GetPlayerFromId(id)
        if xTarget and xTarget.source then
            TriggerClientEvent("ali:copyOutfit:client", xTarget.source, xPlayer.name, xPlayer.source)
        end
    end
end);

RegisterNetEvent("ali:copyOutfit:server:accept", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xRequester = ESX.GetPlayerFromId(id)

    if xRequester then
        MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(users)
            if users[1].skin then
                TriggerClientEvent("ali:copyOutfit:client:accept", xRequester.source, json.decode(users[1].skin))
            end
        end);
    end
end);

RegisterNetEvent("ali:deny:copy", function(id)
    Config.HUD.Notify({
        title = "Copy Outfit",
        text = "Die anfrage um ein Outfit zu kopieren wurde abgelehnt.",
        type = "error",
        time = 5000
    }, id)
end);
