PlayerBoost = {}
MoneyBoost = {}
kills = {}
local boostActive = false
local baseReward = 15
local DeathMultiplier = 2
local GlobalMoneyBoost = 1

local streaks = {
    [3] = {
        boost = 2,
        toggle = true
    },

    [5] = {
        boost = 2.5,
        toggle = true
    },

    [7] = {
        boost = 2.5,
        toggle = true
    },
}

local midrolls = {
    [3] = {
        boost = 2,
        toggle = true
    },

    [5] = {
        boost = 2.5,
        toggle = true
    },

    [7] = {
        boost = 2.5,
        toggle = true
    },
}


local function isInSpecialMode(player)
    if PVP.FFA.toggle[player.source] or PVP.GUNGAME.toggle[player.source] or MoneyBoost[player.source] or player.job.name ~= "unemployed" then
        return true
    end
    return false
end

local function calculateReward(killer)
    local reward = baseReward
    local killCount = kills[killer.source]

    if streaks[killCount] and streaks[killCount].toggle then
        TriggerClientEvent("killstreak:send", killer.source, killCount)
        killer.addAccountMoney("coins", 10)
        reward = reward * streaks[killCount].boost
    end

    if midrolls[killCount] and midrolls[killCount].toggle then
        reward = reward * midrolls[killCount].boost
    end

    if isInSpecialMode(killer) then
        reward = reward * DeathMultiplier
    end

    return ESX.Math.Round(reward * GlobalMoneyBoost)
end

local GetMultiplier = function(battlepasskills)
    local _multiplier = 1;
    for min, multiplier in next, Config.Battlepass.multiplier do
        if min <= battlepasskills then
            _multiplier = multiplier;
        end
    end
    return _multiplier;
end;

playerKills = {}

AddEventHandler('esx:onPlayerDeath', function(data)
    if source and data and data.killerServerId then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xKiller = ESX.GetPlayerFromId(data.killerServerId)

        if xKiller then
            local KillerPed = GetPlayerPed(xKiller.source)

            if not kills[xKiller.source] then kills[xKiller.source] = 0 end
            kills[xKiller.source] = kills[xKiller.source] + 1

            -- BATTLEPASS
            if PlayerBoost[xKiller.source] then
                XPREWARD = Config.Battlepass.xpPerKill * GetMultiplier(kills[xKiller.source]) * 2
                CachedPlayer[xKiller.identifier].xp = CachedPlayer[xKiller.identifier].xp +
                    Config.Battlepass.xpPerKill * GetMultiplier(kills[xKiller.source]) * 2
            else
                XPREWARD = Config.Battlepass.xpPerKill * GetMultiplier(kills[xKiller.source])
                CachedPlayer[xKiller.identifier].xp = CachedPlayer[xKiller.identifier].xp +
                    Config.Battlepass.xpPerKill * GetMultiplier(kills[xKiller.source])
            end

            -- STREAK UI UNTEN
            if not playerKills[xKiller.source] then playerKills[xKiller.source] = {} end
            if not playerKills[xKiller.source][xPlayer.source] then playerKills[xKiller.source][xPlayer.source] = 0 end
            if not playerKills[xPlayer.source] then playerKills[xPlayer.source] = {} end
            if not playerKills[xPlayer.source][xKiller.source] then playerKills[xPlayer.source][xKiller.source] = 0 end
            playerKills[xPlayer.source][xKiller.source] = playerKills[xPlayer.source][xKiller.source] + 1


            -- STATS
            if not PVP.FFA.toggle[xPlayer.source] then
                CachedPlayer[xPlayer.getIdentifier()].deaths = CachedPlayer[xPlayer.getIdentifier()].deaths + 1
                CachedPlayer[xPlayer.getIdentifier()].trophys = CachedPlayer[xPlayer.getIdentifier()].trophys -
                    Config.HUD.getLiga(CachedPlayer[xPlayer.getIdentifier()].trophys).death
                TriggerClientEvent("stats:update", xPlayer.source, CachedPlayer[xPlayer.identifier])
            end

            if not PVP.FFA.toggle[xKiller.source] then
                CachedPlayer[xKiller.getIdentifier()].kills = CachedPlayer[xKiller.getIdentifier()].kills + 1
                CachedPlayer[xKiller.getIdentifier()].trophys = CachedPlayer[xKiller.getIdentifier()].trophys + 1
                TriggerClientEvent("stats:update", xKiller.source, CachedPlayer[xKiller.identifier])
            end

            local reward = calculateReward(xKiller)
            xKiller.addMoney(reward)

            local xKillerNotify
            local xPlayrtNotify
            if data.hasRolled then
                xKiller.addAccountMoney("coins", 10)
                CachedPlayer[xKiller.getIdentifier()].midrolls = CachedPlayer[xKiller.getIdentifier()].midrolls + 1
                TriggerClientEvent('killer:showStreak', xKiller.source, {
                    money = reward,
                    midrolled = true,

                    killer = {
                        name = xKiller.name,
                        points = playerKills[xPlayer.source][xKiller.source] or 0
                    },
                    deathplayer = {
                        id = xPlayer.source,
                        name = xPlayer.name,
                        points = playerKills[xKiller.source][xPlayer.source] or 0
                    }
                })

                xPlayrtNotify = 'Du wurdest von ' ..
                    xKiller.name ..
                    ' [' ..
                    xKiller.source ..
                    '] <span style="color: rgb(' ..
                    Config.Server.color.r ..
                    ', ' ..
                    Config.Server.color.g ..
                    ', ' .. Config.Server.color.b .. ');">midrolled</span> Killstreak: ' .. (kills[xKiller.source] or 0)
                xKillerNotify = 'Du hast ' ..
                    xPlayer.name ..
                    ' [' ..
                    xPlayer.source ..
                    '] <span style="color: #4cf202;">midrolled</span> und erhälst ' ..
                    reward .. '$ Killstreak: ' .. (kills[xPlayer.source] or 0)
            else
                TriggerClientEvent('killer:showStreak', xKiller.source, {
                    money = reward,
                    midrolled = false,

                    killer = {
                        name = xKiller.name,
                        points = playerKills[xPlayer.source][xKiller.source] or 0
                    },
                    deathplayer = {
                        id = xPlayer.source,
                        name = xPlayer.name,
                        points = playerKills[xKiller.source][xPlayer.source] or 0
                    }
                })

                xPlayrtNotify = 'Du wurdest von ' ..
                    xKiller.name ..
                    ' [' ..
                    xKiller.source ..
                    '] <span style="color: rgb(' ..
                    Config.Server.color.r ..
                    ', ' ..
                    Config.Server.color.g ..
                    ', ' .. Config.Server.color.b .. ');">getötet</span> Killstreak: ' .. (kills[xKiller.source] or 0)
                xKillerNotify = 'Du hast ' ..
                    xPlayer.name ..
                    ' [' ..
                    xPlayer.source ..
                    '] <span style="color: #4cf202;">getötet</span> und erhälst ' ..
                    reward .. '$ Killstreak: ' .. (kills[xPlayer.source] or 0)
            end

            Config.HUD.Notify({
                title = "KILL",
                text = xKillerNotify,
                type = "success",
                time = 5000
            }, xKiller.source)

            kills[xPlayer.source] = 0

            Config.HUD.Notify({
                title = "DEATH",
                text = xPlayrtNotify,
                type = "error",
                time = 5000
            }, xPlayer.source)

            TriggerClientEvent('deathscreen:show', xPlayer.source, {
                id = xKiller.source,
                streak = kills[xPlayer.source] or 0,
                name = xKiller.name,
                kills = CachedPlayer[xKiller.identifier].kills,
                deaths = CachedPlayer[xKiller.identifier].deaths,
                avatar = CachedPlayer[xKiller.identifier].dc.avatar,
            })

            TriggerClientEvent("feed:add", -1, {
                killerpos = GetEntityCoords(KillerPed),
                killer = xKiller.name,
                killed = xPlayer.name,
            })
        end
    end
end);

RegisterCommand('moneyboost', function(s, args)
    if not args[1] then return end
    if not args[2] then return end
    local xPlayer = ESX.GetPlayerFromId(s)
    if s == 0 or xPlayer and exports[GetCurrentResourceName()]:Perms()[xPlayer.getGroup()].perms["moneyboost"] and not boostActive then
        GlobalMoneyBoost = tonumber(args[1])
        boostActive = true
        Config.HUD.announce({
            title = '' .. GlobalMoneyBoost .. 'x Moneyboost',
            text = 'Ein Moneyboost mit einem Multiplikator von ' ..
                GlobalMoneyBoost .. 'x ist bis ' .. args[2] .. ' Uhr aktiviert.',
            time = 10000,
        }, -1)

        CreateThread(function()
            while boostActive do
                if os.date('%H:%M') == tostring(args[2]) then
                    GlobalMoneyBoost = tonumber(1)
                    Config.HUD.announce({
                        title = 'MONEYBOOST',
                        text = 'Der Moneyboost von ' .. GlobalMoneyBoost .. 'x ist nun Zuende ',
                        time = 5000,
                    }, -1)
                    boostActive = false
                end
                Wait(500)
            end
        end)
    end
end, false)
