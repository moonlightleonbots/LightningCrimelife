CachedPlayer = {}
local Perms = {
    ["support"] = {
        label = "Supporter",
        roleid = Config.Discord.roles["Support"],

        perms = {
            ["refund"] = false,
            ["job"] = false,
            ["money"] = false,
            ["announce"] = false,
            ["giveall"] = false,
            ["moneyboost"] = false,
        }
    },

    ["mod"] = {
        label = "Moderation",
        roleid = Config.Discord.roles["Moderator"],

        perms = {
            ["refund"] = false,
            ["job"] = false,
            ["money"] = false,
            ["announce"] = false,
            ["giveall"] = false,
            ["moneyboost"] = false,
        }
    },

    ["admin"] = {
        label = "Administration",
        roleid = Config.Discord.roles["Admin"],

        perms = {
            ["refund"] = false,
            ["job"] = true,
            ["money"] = false,
            ["announce"] = false,
            ["giveall"] = false,
            ["moneyboost"] = false,
        }
    },

    ["sadmin"] = {
        label = "Super Administration",
        roleid = Config.Discord.roles["Super Admin"],

        perms = {
            ["refund"] = false,
            ["job"] = true,
            ["money"] = false,
            ["announce"] = false,
            ["giveall"] = false,
            ["moneyboost"] = false,
        }
    },

    ["teamleitung"] = {
        label = "Teamleitung",
        roleid = Config.Discord.roles["Teamleitung"],

        perms = {
            ["refund"] = true,
            ["job"] = true,
            ["money"] = true,
            ["announce"] = true,
            ["giveall"] = true,
            ["moneyboost"] = false,
        }
    },

    ["manager"] = {
        label = "Manager",
        roleid = Config.Discord.roles["Manager"],

        perms = {
            ["refund"] = true,
            ["job"] = true,
            ["money"] = true,
            ["announce"] = true,
            ["giveall"] = true,
            ["moneyboost"] = true,
        }
    },

    ["pl"] = {
        label = "Projektleitung",
        roleid = Config.Discord.roles["pl"],

        perms = {
            ["refund"] = true,
            ["job"] = true,
            ["money"] = true,
            ["announce"] = true,
            ["giveall"] = true,
            ["moneyboost"] = true,
        }
    },
}

exports("Perms", function()
    return Perms
end);

exports("CachedPlayer", function(identifier)
    return CachedPlayer[identifier]
end);

function loadoutUpdate(xPlayer)
    if not xPlayer and xPlayer.getLoadout() then return end
    TriggerClientEvent("loadout:update", xPlayer.source, xPlayer.getLoadout())
end

function updateInventory(xPlayer)
    if not xPlayer and xPlayer.getInventory() then return end
    TriggerClientEvent("inventory:update", xPlayer.source, xPlayer.getInventory())
end

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local discorid = GetPlayerIdentifierByType(source, 'discord'):sub(#'discord:' + 1)
    local identifier = xPlayer.getIdentifier()
    local data = GetDiscordData(source)
    local role = HasDiscordRole(source, Config.Discord.roles["XPBoost"], data)
    local stats = MySQL.single.await(
        'SELECT kills, deaths, xp, trophys, quests, collected_quest, midrolls, premium, identifier FROM users WHERE identifier=? LIMIT 1',
        { identifier })

    if data and role then
        PlayerBoost[source] = true
    else
        PlayerBoost[source] = false
    end

    local quests = json.decode(stats.quests)
    if not CachedPlayer[identifier] then
        CachedPlayer[identifier] = stats
        CachedPlayer[identifier].dc = data
        CachedPlayer[identifier].collected_quest = json.decode(stats.collected_quest)
        CachedPlayer[identifier].dcName = " <@" ..
            GetPlayerIdentifierByType(source, 'discord'):sub(#'discord:' + 1) .. "> "

        CachedPlayer[identifier].quests = {
            kills = quests.kills,
            ffa_kills = quests.ffa_kills,
            headshots = quests.headshots,
            gungamejoin = quests.gungamejoin,
            streaks = quests.streaks,
            ffajoin = quests.ffajoin,
        }

        if stats.premium == 1 then
            CachedPlayer[identifier].premium = true
        elseif stats.premium == 0 then
            CachedPlayer[identifier].premium = false
        end
    end

    local function updateStats()
        MySQL.query('SELECT kills, deaths, ffa_kills, ffa_deaths, discordid FROM users WHERE identifier=?',
            { identifier },
            function(r)
                if #r == 0 then
                    MySQL.update('UPDATE users SET steamname=?, kills=?, deaths=?, discordid=? WHERE identifier=?', {
                        xPlayer.name, 0, 0, 0, 0, discorid, identifier
                    })
                else
                    MySQL.update('UPDATE users SET steamname=?, discordid=? WHERE identifier=?', {
                        xPlayer.name, discorid, identifier
                    })
                end
            end);
    end

    Wait(2500)
    updateStats()
    SyncRole(source)
end);

SyncRole = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local data = CachedPlayer[xPlayer.identifier].dc
        local group = xPlayer.getGroup()
        local roleFound = false

        for k, v in next, Perms do
            if HasDiscordRole(xPlayer.source, v.roleid, data) then
                roleFound = true
                xPlayer.setGroup(k)
                Config.Server.Debug("Spieler: ^0" ..
                    xPlayer.name .. ' [' .. source .. '] ^0Wurde Gesynced mit der Rolle: ' .. v.label)
                break
            end
        end

        if not roleFound and group ~= "user" then
            xPlayer.setGroup("user")
            Config.Server.Debug("Die Rechte vom " .. xPlayer.name .. ' [' .. source .. '] wurden Zurückgesetzt')
        end
    end
end

local Save = function(identifier, id, callback)
    if CachedPlayer[identifier] then
        MySQL.update(
            'UPDATE users SET steamname=?, kills=?, deaths=?, trophys=?, midrolls=?, xp=?, quests=?, collected_quest=?, premium=? WHERE identifier=?',
            {
                GetPlayerName(id),
                CachedPlayer[identifier].kills,
                CachedPlayer[identifier].deaths,
                CachedPlayer[identifier].trophys,
                CachedPlayer[identifier].midrolls,
                CachedPlayer[identifier].xp,
                json.encode(CachedPlayer[identifier].quests),
                json.encode(CachedPlayer[identifier].collected_quest),
                CachedPlayer[identifier].premium,
                identifier
            },
            function(rowsChanged)
                if callback then
                    callback(rowsChanged)
                end
            end
        )
    end
end

local function handlePlayerDrop(source)
    local identifier = ESX.GetIdentifier(source)
    if not identifier then
        Config.Server.Debug("Identifier vom Spieler " ..
            GetPlayerName(source) .. " [" .. source .. "] konnte nicht gefunden werden.")
        return
    end

    kills[source] = nil
    playerKills[source] = nil
    Save(identifier, source, function() end);

    TriggerClientEvent("discord:setRich", -1, GetNumPlayerIndices(), GetConvarInt('sv_maxclients', 32))
end

AddEventHandler('playerDropped', function(reason) handlePlayerDrop(source) end);

-------------------
---- CAR CLEAR ----
-------------------

CreateThread(function()
    while true do
        Wait(5 * 60000)
        TriggerClientEvent("carclear:delete", -1)
    end
end);

RegisterNetEvent('RestoreLoadout', function(Source)
    local s = source;
    local xPlayer = ESX.GetPlayerFromId(s);
    local Loadout = xPlayer.getLoadout();
    local Ped = GetPlayerPed(s);

    RemoveAllPedWeapons(Ped, false);

    if #Loadout > 0 then
        for _, Weapon in next, (Loadout) do
            local WeaponHash = GetHashKey(Weapon.name);
            GiveWeaponToPed(Ped, WeaponHash, Weapon.ammo, true, false);

            xPlayer.setWeaponTint(Weapon.name, Weapon.tintIndex)

            if Weapon.components and #Weapon.components > 0 then
                for __, WeaponComponent in next, (Weapon.components) do
                    local componentHash = ESX.GetWeaponComponent(Weapon.name, WeaponComponent).hash
                    GiveWeaponComponentToPed(Ped, WeaponHash, componentHash);
                end
            end

            loadoutUpdate(xPlayer)
        end
    end
end);

RegisterNetEvent('setDimension', function(dimension)
    local source = source

    SetPlayerRoutingBucket(source, dimension)

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

    if vehicle > 0 then
        SetEntityRoutingBucket(vehicle, dimension)
    end
end);

AddEventHandler("explosionEvent", function(sender, exp)
    CancelEvent()
end);

local GroupLabels = {
    ["pl"] = "Projektleitung",
    ["teamleitung"] = "Teamleitung",
    ["manager"] = "Manager",
    ["sadmin"] = "Super Admin",
    ["admin"] = "Admin",
    ["mod"] = "Moderator",
    ["support"] = "Supporter",
    ["user"] = "Spieler",
}

function GetGroupLabel(group)
    local label = GroupLabels[group]
    return label or "Unbekannte Gruppe"
end

RegisterServerEvent('teamchat:server', function(msg)
    local xPlayer = ESX.GetPlayerFromId(source)
    for _, xPlayers in next, ESX.Players do
        if xPlayers.getGroup() ~= "user" then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, xPlayer.name,
                GetGroupLabel(xPlayer.getGroup()), msg, "CHAR_ARTHUR", 1)
        end
    end
end);

RegisterNetEvent("mute:toggle", function(toggle)
    MumbleSetPlayerMuted(source, toggle)
end)
