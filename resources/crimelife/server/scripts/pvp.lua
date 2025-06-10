PVP = {
    FFA = {
        players = {},
        toggle = {},
        zone = {}
    },

    GUNGAME = {
        players = {},
        toggle = {},
        zone = {}
    },
}

CreateThread(function()
    for k, v in next, Config.pvp.ffa do
        PVP.FFA.players[k] = 0
    end

    for k, v in next, Config.pvp.gungame do
        PVP.GUNGAME.players[k] = 0
    end
end);

RegisterNetEvent("pvp:request", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("pvp:open", xPlayer.source, {
        ffa = {
            players = PVP.FFA.players
        },

        gungame = {
            players = PVP.GUNGAME.players
        },
    })
end);

-- FFA
RegisterNetEvent("pvp:joinFFA", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not PVP.FFA.toggle[xPlayer.source] then
        local stats = MySQL.single.await(
            'SELECT ffa_kills, ffa_deaths, identifier FROM users WHERE identifier=? LIMIT 1', { xPlayer.identifier })
        TriggerClientEvent("ffa:updateStats", xPlayer.source, stats.ffa_kills, stats.ffa_deaths)

        PVP.FFA.players[name] += 1
        PVP.FFA.toggle[xPlayer.source] = true
        PVP.FFA.zone[xPlayer.source] = name

        Config.HUD.Notify({
            title = "PVP",
            text = "Du bist dem FFA beigetreten! du kannst mit dem command /quitffa die Lobby Verlassen",
            type = "success",
            time = 5000
        }, xPlayer.source)
    end
end);

RegisterNetEvent("pvp:leaveFFA", function(name, kills, deaths)
    local xPlayer = ESX.GetPlayerFromId(source)

    if PVP.FFA.toggle[xPlayer.source] then
        PVP.FFA.players[name] -= 1
        PVP.FFA.toggle[xPlayer.source] = false
        PVP.FFA.zone[xPlayer.source] = nil

        MySQL.Async.execute(
            'UPDATE users SET ffa_kills = @ffa_kills, ffa_deaths = @ffa_deaths WHERE identifier = @identifier',
            { ['@identifier'] = xPlayer.identifier, ['@ffa_kills'] = kills, ['@ffa_deaths'] = deaths })

        Config.HUD.Notify({
            title = "PVP",
            text = "Du hast den FFA verlassen!",
            type = "success",
            time = 5000
        }, xPlayer.source)
    end
end);

RegisterNetEvent("ffa:addKill", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer and xPlayer.source and PVP.FFA.toggle[xPlayer.source] then
        TriggerClientEvent("ffa:update:points", xPlayer.source)
    end
end);

-- GUNGAME
RegisterNetEvent("pvp:joinGunGame", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not PVP.GUNGAME.toggle[xPlayer.source] then
        PVP.GUNGAME.players[name] += 1
        PVP.GUNGAME.toggle[xPlayer.source] = true
        PVP.GUNGAME.zone[xPlayer.source] = name

        Config.HUD.Notify({
            title = "PVP",
            text = "Du bist dem GunGame beigetreten! du kannst mit dem command /quitffa die Lobby Verlassen",
            type = "success",
            time = 5000
        }, xPlayer.source)
    end
end);

RegisterNetEvent("pvp:leaveGunGame", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if PVP.GUNGAME.toggle[xPlayer.source] then
        PVP.GUNGAME.players[name] -= 1
        PVP.GUNGAME.toggle[xPlayer.source] = false
        PVP.GUNGAME.zone[xPlayer.source] = nil

        Config.HUD.Notify({
            title = "PVP",
            text = "Du hast den GunGame verlassen!",
            type = "success",
            time = 5000
        }, xPlayer.source)
    end
end);

RegisterNetEvent("gungame:updatePoints", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer and xPlayer.source and PVP.GUNGAME.zone[xPlayer.source] then
        TriggerClientEvent("gungame:update:points", xPlayer.source)
    end
end);

RegisterNetEvent("gungame:addWin", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(id)

    if xPlayer.source == target.source and PVP.GUNGAME.toggle[target.source] then
        xPlayer.addAccountMoney("coins", Config.pvp.gungameWin)

        MySQL.update('UPDATE users SET gungamewins=gungamewins+? WHERE identifier=?', {
            1,
            xPlayer.identifier
        });
    end
end);

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer and xPlayer.source and PVP.FFA.toggle[xPlayer.source] then
        PVP.FFA.players[PVP.FFA.zone[xPlayer.source]] -= 1
        PVP.FFA.toggle[xPlayer.source] = false
        PVP.FFA.zone[xPlayer.source] = nil
    end

    if xPlayer and xPlayer.source and PVP.GUNGAME.toggle[xPlayer.source] then
        PVP.GUNGAME.players[PVP.GUNGAME.zone[xPlayer.source]] -= 1
        PVP.GUNGAME.toggle[xPlayer.source] = false
        PVP.GUNGAME.zone[xPlayer.source] = nil
    end
end);

-- PRIVATE

local PrivateLobbies = {}
local PrivatePlayers = {}
inPrivateLobby = {}

RegisterNetEvent('pvp:createFFALobby', function(data)
    local name, password, map = data.name, data.password, data.map
    if (PrivateLobbies[source]) then
        return;
    end
    local source = source
    PrivateLobbies[source] = {
        source = source,
        name = name,
        password = password,
        maxPlayers = Config.pvp.ffa[map].max,
        zone = map,
        players = 0
    }
    TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
    TriggerClientEvent('framework:joinPrivateLobby', source, source)
    if not inPrivateLobby[source] then
        inPrivateLobby[source] = true
    end
    TriggerEvent('framework:joinPrivateFFA', { id = source, password = password })
end)

RegisterNetEvent('framework:joinPrivateFFA', function(data)
    local s = source
    local id = data.id
    local password = data.password

    if (PrivateLobbies[tonumber(id)].password == password) then
        if (tonumber((PrivateLobbies[tonumber(id)].players + 1)) > tonumber(PrivateLobbies[tonumber(id)].maxPlayers)) then
            Config.HUD.Notify({
                title = 'System',
                text = 'Diese Lobby ist voll!',
                time = 5000,
                type = 'error'
            }, source)
            return;
        end
        PrivatePlayers[s] = id
        PrivateLobbies[tonumber(id)].players = PrivateLobbies[tonumber(id)].players + 1
        TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
        TriggerClientEvent('framework:joinPrivateLobby', s, id)
        if not inPrivateLobby[s] then
            inPrivateLobby[s] = true
        end
    else
        Config.HUD.Notify({
            title = 'System',
            text = 'falsches Passwort.',
            time = 5000,
            type = 'error'
        }, source)
    end
end)

RegisterNetEvent('framework:leavePrivateFFA', function(id)
    if (PrivateLobbies[tonumber(id)]) then
        PrivatePlayers[source] = nil
        PrivateLobbies[tonumber(id)].players = tonumber(PrivateLobbies[tonumber(id)].players) - 1
        TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
    end
end)

RegisterNetEvent('playerDropped', function()
    local s = source
    if (PrivatePlayers[s]) then
        PrivateLobbies[tonumber(PrivatePlayers[s])].players = tonumber(PrivateLobbies[tonumber(PrivatePlayers[s])]
            .players) - 1
        TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
    end
    for k, v in pairs(PrivateLobbies) do
        if (tonumber(k) == tonumber(s)) then
            PrivateLobbies[k] = nil
            TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
            for k1, v1 in pairs(PrivatePlayers) do
                if (tonumber(v1) == tonumber(k)) then
                    PrivatePlayers[k1] = nil
                    TriggerClientEvent('framework:leavePrivateLobby', k1)
                    if inPrivateLobby[k1] then
                        inPrivateLobby[k1] = false
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("framework:closeLobby", function()
    local s = source
    for k, v in pairs(PrivateLobbies) do
        if (tonumber(k) == s) then
            PrivateLobbies[k] = nil
            TriggerClientEvent('framework:sendPrivateLobbies', -1, PrivateLobbies)
            for k1, v1 in pairs(PrivatePlayers) do
                if (tonumber(v1) == tonumber(k)) then
                    PrivatePlayers[k1] = nil
                    TriggerClientEvent('framework:leavePrivateLobby', k1)
                    if inPrivateLobby[k1] then
                        inPrivateLobby[k1] = false
                    end
                end
            end
            Config.HUD.Notify({
                title = 'System',
                text = 'Lobby wurde geschlossen.',
                type = "error",
                time = 5000,
            }, source)
            TriggerClientEvent('framework:leavePrivateLobby', source)
        end
    end
end)
