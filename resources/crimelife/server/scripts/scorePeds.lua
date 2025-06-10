local PlayerPeds = {}
local PlayerMidrolls = {}

local function LoadPlayerStats()
    PlayerPeds = {}
    PlayerMidrolls = {}

    MySQL.query('SELECT steamname, kills, identifier FROM users ORDER BY kills DESC LIMIT 3', {}, function(stats)
        if #stats > 0 then
            for i, stat in next, stats do
                if stat then
                    local skinData = MySQL.scalar.await('SELECT skin FROM users WHERE identifier = ?',
                        { stat.identifier })
                    table.insert(PlayerPeds, {
                        skin = json.decode(skinData or "{}"),
                        name = stat.steamname,
                        kills = stat.kills,
                        rank = i
                    })
                end
            end
        end
    end);

    MySQL.query('SELECT steamname, midrolls, identifier FROM users ORDER BY midrolls DESC LIMIT 1', {},
        function(midrolls)
            if #midrolls > 0 then
                local midrollStat = midrolls[1]
                if midrollStat then
                    local skinData = MySQL.scalar.await('SELECT skin FROM users WHERE identifier = ?',
                        { midrollStat.identifier })
                    table.insert(PlayerMidrolls, {
                        skin = json.decode(skinData or "{}"),
                        name = midrollStat.steamname,
                        midrolls = midrollStat.midrolls,
                    })
                end
            end
        end);
end

CreateThread(LoadPlayerStats)

CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        LoadPlayerStats()
    end
end);

-- Spieler-Daten beim Beitritt senden
AddEventHandler('esx:playerLoaded', function(playerData)
    Wait(3500)

    if #PlayerPeds == 3 and #PlayerMidrolls == 1 then
        TriggerClientEvent('updatePeds', playerData, PlayerPeds, PlayerMidrolls)
    end
end);
