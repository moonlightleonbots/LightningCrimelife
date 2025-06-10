local function fetchBattlepassData(xPlayer)
    return {
        PLAYER_DATA = MySQL.single.await('SELECT xp, collected, collected_premium FROM users WHERE identifier=? LIMIT 1',
            { xPlayer.identifier }),
        LEVEL_DATA = Config.Battlepass.GetLevel(CachedPlayer[xPlayer.identifier].xp),
        premium = CachedPlayer[xPlayer.identifier].premium or false,
    }
end

local function getPlace(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local result = MySQL.Sync.fetchScalar(
        "SELECT COUNT(*) + 1 FROM users WHERE kills > (SELECT kills FROM users WHERE identifier = @identifier)",
        { ["@identifier"] = xPlayer.identifier })
    return result or 0
end

local function fetchScoreboardData(xPlayer)
    local Scoreboard = {
        stats = {},
        battlepass = {},
        liga = {},
        ffa = {},
        midrolls = {},
        self = {
            name = xPlayer.name .. " [" .. xPlayer.source .. "]",
            dcName = CachedPlayer[xPlayer.identifier].dc.username,
            xp = CachedPlayer[xPlayer.identifier].xp,
            maxXP = Config.Battlepass.GetLevel(CachedPlayer[xPlayer.identifier].xp).max,
            avatar = CachedPlayer[xPlayer.identifier].dc.avatar,
            place = getPlace(xPlayer.source),
        },
    }

    local results = MySQL.query.await(
        'SELECT steamname, kills, deaths, xp, trophys, ffa_kills, ffa_deaths, midrolls FROM users ORDER BY xp DESC LIMIT 25',
        {})

    if results and #results > 0 then
        table.sort(results, function(a, b) return a.trophys > b.trophys end)
        for place, stat in ipairs(results) do
            table.insert(Scoreboard.liga, {
                place = place,
                name = stat.steamname,
                trophys = stat.trophys,
                liga = Config.HUD.getLiga(stat.trophys).label,
            })
        end

        table.sort(results, function(a, b) return a.xp > b.xp end)
        for place, stat in ipairs(results) do
            table.insert(Scoreboard.battlepass, {
                place = place,
                name = stat.steamname,
                xp = stat.xp,
                level = Config.Battlepass.GetLevel(stat.xp).level,
            })
        end

        table.sort(results, function(a, b) return a.ffa_kills > b.ffa_kills end)
        for place, stat in ipairs(results) do
            table.insert(Scoreboard.ffa, {
                place = place,
                name = stat.steamname,
                kills = stat.ffa_kills,
                deaths = stat.ffa_deaths,
            })
        end

        table.sort(results, function(a, b) return a.kills > b.kills end)
        for place, stat in ipairs(results) do
            table.insert(Scoreboard.stats, {
                place = place,
                name = stat.steamname,
                kills = stat.kills,
                deaths = stat.deaths,
            })
        end

        table.sort(results, function(a, b) return a.midrolls > b.midrolls end)
        for place, stat in ipairs(results) do
            table.insert(Scoreboard.midrolls, {
                place = place,
                name = stat.steamname,
                midrolls = stat.midrolls,
            })
        end
    end

    return Scoreboard
end

ESX.RegisterServerCallback('mainmenu:GetBattlepass', function(src, cb, param1, param2)
    local xPlayer = ESX.GetPlayerFromId(src)
    local battlepass = fetchBattlepassData(xPlayer)

    cb({
        level = battlepass.LEVEL_DATA.level,
        collected = json.decode(battlepass.PLAYER_DATA.collected),
        collected_premium = json.decode(battlepass.PLAYER_DATA.collected_premium),
        rewards = Config.Battlepass.Levels,
        premium = battlepass.premium,
    })
end)

ESX.RegisterServerCallback('mainmenu:GetPVP', function(src, cb, param1, param2)
    cb({
        ffa = {
            players = PVP.FFA.players,
        },

        gungame = {
            players = PVP.GUNGAME.players,
        },
    })
end)

ESX.RegisterServerCallback('mainmenu:getScoreboard', function(src, cb, param1, param2)
    local xPlayer = ESX.GetPlayerFromId(src)

    CreateThread(function()
        cb(fetchScoreboardData(xPlayer))
    end)
end)

ESX.RegisterServerCallback('cases:reward', function(src, cb, winType, amount, name)
    local xPlayer = ESX.GetPlayerFromId(src)

    if winType == "money" then
        xPlayer.addMoney(amount)
    elseif winType == "item" then
        xPlayer.addInventoryItem(name, amount)
        updateInventory(xPlayer)
    elseif winType == "PREMIUM" then
        CachedPlayer[xPlayer.identifier].premium = true
    end
end)

RegisterCommand("premium", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local hasRole = HasDiscordRole(xPlayer.source, Config.Discord.roles["Event"], data)

    if xPlayer then
        if hasRole then
            if tonumber(args[1]) > 0 then
                local Target = ESX.GetPlayerFromId(args[1])

                if Target and Target.source then
                    if args[2] == "add" then
                        CachedPlayer[Target.identifier].premium = true
                        Config.HUD.Notify({
                            title = "Premium",
                            text = "Du hast dein Premium erhalten!",
                            type = "error",
                            time = 2500,
                        }, Target.source)
                    elseif args[2] == "remove" then
                        CachedPlayer[Target.identifier].premium = false
                        Config.HUD.Notify({
                            title = "Premium",
                            text = "Du hast dein Premium verloren!",
                            type = "error",
                            time = 2500,
                        }, Target.source)
                    end
                end
            end
        end
    end
end, false)
