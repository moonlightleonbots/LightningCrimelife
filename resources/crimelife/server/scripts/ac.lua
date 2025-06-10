local killsCheck = {}
local deathcount = {}

CreateThread(function()
    while true do
        Wait(4000)
        killsCheck = {}
        deathcount = {}
    end
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    if source and data and data.killerServerId then
        local xPlayer = ESX.GetPlayerFromId(source)

        if not deathcount[xPlayer.source] then
            deathcount[xPlayer.source] = 0
        end

        deathcount[xPlayer.source] = deathcount[xPlayer.source] + 1

        if deathcount[xPlayer.source] == 3 then
            exports["crimelife_ac"]:fg_BanPlayer(xPlayer.source, 'Susano (killplayer) Exploit [trigger]', true)
        end
    end
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    if source and data and data.killerServerId then
        local xPlayer = ESX.GetPlayerFromId(source)

        local killer = data.killerServerId
        if not killsCheck[killer] then
            killsCheck[killer] = 0
        end

        killsCheck[killer] = killsCheck[killer] + 1

        if killsCheck[killer] == 5 then
            exports["crimelife_ac"]:fg_BanPlayer(killer, 'Last Ride or Tryed to Kill all.', true)
        end
    end
end);

RegisterNetEvent("fg:ban:core", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    exports["crimelife_ac"]:fg_BanPlayer(
        xPlayer.source,
        data.violation,
        data.send_to_logs
    )
end);