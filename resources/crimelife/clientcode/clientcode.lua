-----------------------------------------------------------------------------
-----------------------------------UTILS-------------------------------------
-----------------------------------------------------------------------------

local PrivateLobbies = {}
openUI = true
local isEmoting = false
local lastWeapon = nil
local BWP = nil
local Quests = {}
local existingBlips = {}
local invites = {
    toggle = false,
    faction = nil,
    id = nil
}

local killzone = {
    toggle = false,
    curZone = nil,
    joined = false,
    inZone = false,

    points = 0,
    time = "00:00",
}

local Event = {}
local canMarkerDraw = false
local canEventBubbleDraw = false
local warImMarker = false
local EventKickReason = "Event Ausschluss"
local eventData = {
    toggle = false,
    name = nil,
    position = vec3(0, 0, 0)
}

Owners = {};
Attacks = {};
Blips = {};

hudForce = false
Jobs = nil;
CurrentAttack = false;
isinMatch = false

exports("bottomText", function()
    return Utils.BottomText
end);

exports('PlayerData', function()
    return Config.PlayerData.isIn;
end);

local function deleteAllPeds()
    local pedCount = 0
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
            pedCount = pedCount + 1
        end
    end
    Config.Server.Debug(string.format("Deleted %d peds.", pedCount))
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        deleteAllPeds()
    end
end);

CreateThread(function()
    while true do
        Wait(10000)

        SendNUIMessage({
            a = "pvpBanner"
        })

        Wait(29 * 60000)
    end
end);

function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)
    end);
end

local function Text(x, y, z, text, r, g, b, scale, font)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    SetTextScale(scale or 1, scale or 1)
    SetTextFont(font or 7)
    SetTextProportional(3)
    SetTextColour(r, g, b, 255)
    SetTextEntry("STRING")
    SetTextCentre(3)
    AddTextComponentString(text)

    DrawText(_x, _y)
end

local function DisableControlActions()
    local controls = { 24, 45, 69, 92, 140, 141, 142, 257, 263, 264, 331, 344 }
    for _, control in next, (controls) do
        DisableControlAction(0, control, true)
    end
end

local duty = {
    inDuty = false,

    clothes = {
        ["pl"]          = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 2,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 2,
                ['shoes_1'] = 78,
                ['shoes_2'] = 2,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 2,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 2,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 2,
                ['shoes_1'] = 82,
                ['shoes_2'] = 2,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 2,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["manager"]     = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 11,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 11,
                ['shoes_1'] = 78,
                ['shoes_2'] = 11,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 11,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 2,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 2,
                ['shoes_1'] = 82,
                ['shoes_2'] = 2,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 2,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["teamleitung"] = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 0,
                ['shoes_1'] = 78,
                ['shoes_2'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 0,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 0,
                ['shoes_1'] = 82,
                ['shoes_2'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 0,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["sadmin"]      = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 0,
                ['shoes_1'] = 78,
                ['shoes_2'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 0,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 0,
                ['shoes_1'] = 82,
                ['shoes_2'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 0,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["admin"]       = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 3,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 3,
                ['shoes_1'] = 78,
                ['shoes_2'] = 3,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 3,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 3,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 3,
                ['shoes_1'] = 82,
                ['shoes_2'] = 3,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 3,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["mod"]         = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 4,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 4,
                ['shoes_1'] = 78,
                ['shoes_2'] = 4,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 4,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 4,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 4,
                ['shoes_1'] = 82,
                ['shoes_2'] = 4,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 4,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            },
        },

        ["support"]     = {
            male = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 287,
                ['torso_2'] = 5,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 114,
                ['pants_2'] = 5,
                ['shoes_1'] = 78,
                ['shoes_2'] = 5,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 5,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0

            },

            female = {
                ['tshirt_1'] = 14,
                ['tshirt_2'] = 0,
                ['torso_1'] = 300,
                ['torso_2'] = 5,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 8,
                ['pants_1'] = 121,
                ['pants_2'] = 5,
                ['shoes_1'] = 82,
                ['shoes_2'] = 5,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['mask_1'] = 135,
                ['mask_2'] = 5,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0,
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['hair_1'] = 0,
                ['hair_2'] = 0
            }
        }
    }
}

exports("GetSettings", function()
    return Config.Server.Settings
end);

exports("GetKillzone", function()
    return killzone
end);

RegisterNuiCallback("close", function()
    if Config.Server.Settings.hud then
        hudForce = false
        SendNUIMessage({
            a = "hud:toggle",
            toggle = true
        })
    end


    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(1)
end);

RegisterNetEvent("group:update", function(group)
    Config.PlayerData.group = group
end);

RegisterNetEvent("loadout:update", function(loadout)
    Config.PlayerData.loadout = loadout
end);

RegisterNetEvent("inventory:update", function(inventory)
    Config.PlayerData.items = inventory
end);

CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end

    local data = GetResourceKvpString('LCL_Settings')

    Config.Server.Settings = data and json.decode(data) or Config.Server.Settings
    Wait(1000)

    SetWeatherTypePersist(Config.Server.Settings.weather)
    SetWeatherTypeNowPersist(Config.Server.Settings.weather)
    SetWeatherTypeNow(Config.Server.Settings.weather)
    SetOverrideWeather(Config.Server.Settings.weather)

    NetworkOverrideClockTime(tonumber(Config.Server.Settings.time), 0, 0)

    ExecuteCommand("cycleproximity")

    local lastFastLoop = 0
    local lastMediumLoop = 0
    local lastSlowLoop = 0
    local lastVerySlowLoop = 0

    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)

    if Config.Server.Settings.funk.toggle then
        ExecuteCommand("funkjoin " .. Config.Server.Settings.funk.number)
    end

    while true do
        local now = GetGameTimer()

        if now - lastFastLoop >= 2500 then
            local playerPed = PlayerPedId()

            ClearPedBloodDamage(playerPed)
            local coords = GetEntityCoords(playerPed)
            ClearAreaOfProjectiles(coords.x, coords.y, coords.z, 1.0, 0)
            SetPedInfiniteAmmo(PlayerPedId(), true)

            SetPedCanLosePropsOnDamage(playerPed, false)
            SetPlayerCanUseCover(PlayerId(), false)
            StatSetInt('MP0_STAMINA', 100, true)
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            SetPedUsingActionMode(playerPed, false, -1, 0)
            SetPlayerTargetingMode(3)
            DisableIdleCamera(true)
            DisablePlayerVehicleRewards(PlayerId())
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            ReplaceHudColourWithRgba(116, Config.Server.color.r, Config.Server.color.g, Config.Server.color.b, 255)

            local vehicle = GetVehiclePedIsUsing(playerPed)
            if vehicle ~= 0 then
                SetPedConfigFlag(playerPed, 35, false)
                SetPedConfigFlag(playerPed, -32, false)
            end
            lastFastLoop = now
        end

        if now - lastMediumLoop >= 500 then
            local playerPed = PlayerPedId()

            if IsPedInAnyVehicle(playerPed, false) or IsPedFalling(playerPed) then
                SetPedCanRagdoll(playerPed, true)
                Wait(10000)
            else
                SetPedCanRagdoll(playerPed, false)
            end

            lastMediumLoop = now
        end

        if now - lastSlowLoop >= 1000 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 then
                local health = GetVehicleBodyHealth(vehicle)
                if health < 50 then
                    DeleteVehicle(vehicle)
                end
            end

            lastSlowLoop = now
        end

        if now - lastVerySlowLoop >= 300000 then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()

            lastVerySlowLoop = now
        end
        Wait(1000)
    end
end);

RegisterCommand("id", function()
    Config.HUD.Notify({
        title = "System",
        text = "Deine ID: " .. GetPlayerServerId(PlayerId()) .. "",
        time = 5000,
        type = "info"
    })
end, false);

-----------------------------------------------------------------------------

----------------------------------SAFEZONE-----------------------------------

-----------------------------------------------------------------------------

CreateThread(function()
    repeat
        Wait()
    until Config.Server.safezone

    for k, v in next, Config.Server.safezone.zones do
        local blip = AddBlipForRadius(v.position, v.radius)
        SetBlipAlpha(blip, 170)
        SetBlipColour(blip, 2)
    end

    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for k, v in next, Config.Server.safezone.zones do
            local dist = #(coords - v.position)

            if dist < v.radius + 15 then
                sleep = 1
                DrawGlowSphere(v.position.x, v.position.y, v.position.z, v.radius, Config.Server.color.r,
                    Config.Server.color.g,
                    Config.Server.color.b, 0.15, true, true)
            end

            if dist <= v.radius and not Config.Server.safezone.toggle then
                Config.Server.safezone.toggle = true
                SetEntityInvincible(ped, true)
            elseif dist >= v.radius and Config.Server.safezone.toggle then
                Config.Server.safezone.toggle = false

                if not duty.inDuty then
                    SetEntityInvincible(ped, false)
                end
            end

            if dist < v.radius then
                Config.Server.safezone.toggle = true
                if not Config.Server.safezone.toggle2 then
                    Config.Server.safezone.toggle2 = true
                end
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                DisableControlActions()
                for key, marker in next, v.marker do
                    sleep = 1
                    local dist = #(coords - marker.marker.position)

                    if dist < 10 then
                        Text(marker.marker.position.x, marker.marker.position.y, marker.marker.position.z + 1.0,
                            marker.name, 255, 255, 255, 0.3)
                    end

                    if dist < 2 then
                        exports[GetCurrentResourceName()]:showE(marker.name)
                    end

                    if dist < 1.5 and IsControlJustReleased(0, 38) then
                        if marker.event == "pvp:request" then
                            TriggerServerEvent("pvp:request")
                        elseif marker.event == "battlepass:request" then
                            TriggerServerEvent("battlepass:request")
                        elseif marker.event == "scoreboard:request" then
                            TriggerServerEvent("scoreboard:request")
                        else
                            TriggerEvent(marker.event)
                        end
                    end

                    Utils.marker({
                        type = 22,
                        position = marker.marker.position,
                        size = marker.marker.size,
                        color = marker.marker.color
                    })

                    Utils.marker({
                        type = 27,
                        position = vec3(marker.marker.position.x, marker.marker.position.y,
                            marker.marker.position.z - 0.9),
                        size = vec3(1.5, 1.5, 1.5),
                        color = marker.marker.color
                    })
                end
                break
            end

            if not Config.Server.safezone.toggle and Config.Server.safezone.toggle2 then
                Config.Server.safezone.toggle2 = false
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            end
        end

        Wait(sleep)
    end
end);

-----------------------------------------------------------------------------

----------------------------------SPAWNS-------------------------------------

-----------------------------------------------------------------------------

RegisterKeyMapping("spawnSelector", "Spawn Selector", "keyboard", "x")

RegisterCommand("spawnSelector", function()
    if Utils.CanDoStuff() and not isEmoting and not IsEntityDead(PlayerPedId()) then
        ToggleCamMode(true)
    end
end, false);

RegisterNetEvent("spawn:show", function()
    ToggleCamMode(true)
end);

-----------------------------------------------------------------------------

-----------------------------------HUD---------------------------------------

-----------------------------------------------------------------------------

RegisterKeyMapping('core_healing', 'Healing', 'keyboard', 'PAGEDOWN')

RegisterNetEvent('esx:playerLoaded', function(data)
    Config.PlayerData = data
    Config.PlayerData.money = data.money
    Config.PlayerData.coins = data.coins
    Config.PlayerData.stats = data.stats
    Quests = data.quests
    collected_quest = data.collected_quest

    if Config.PlayerData.job.name ~= "unemployed" then
        Playerjob = Config.PlayerData.job.label .. " - " .. Config.PlayerData.job.grade_label
    else
        Playerjob = "Keine Fraktion"
    end

    Wait(500)

    SendNUIMessage({
        a = "hud:load",
        data = {
            id = data.source,
            money = data.money,
            online = data.online,
            maxClients = data.maxClients,
            job = Playerjob,

            stats = {
                kills = data.stats.kills,
                deaths = data.stats.deaths,

                ligamax = Config.HUD.getLiga(data.stats.trophys).needed,
                trophys = data.stats.trophys,
                ligaicon = Config.HUD.getLiga(data.stats.trophys).icon,
            }
        }
    })

    ESX.SetTimeout(15000, function()
        CurrentAttack = false;
        CheckForActiveAttack();
    end);

    updateFactions(data.factions)
end);

RegisterNetEvent("stats:update", function(data)
    Config.PlayerData.stats.kills = data.kills
    Config.PlayerData.stats.deaths = data.deaths
    Config.PlayerData.stats.xp = data.xp
    Config.PlayerData.stats.trophys = data.trophys

    SendNUIMessage({
        a = "SetStats",
        kills = Config.PlayerData.stats.kills,
        deaths = Config.PlayerData.stats.deaths,

        ligamax = Config.HUD.getLiga(Config.PlayerData.stats.trophys).needed,
        trophys = Config.PlayerData.stats.trophys,
        ligaicon = Config.HUD.getLiga(Config.PlayerData.stats.trophys).icon,
    })
end);

local GetMinimapAnchor = function()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, ___ = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 15)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    return Minimap
end

CreateThread(function()
    while true do
        Wait(100)
        lastWeapon = GetSelectedPedWeapon(PlayerPedId())
        if not hudForce then
            SendNUIMessage({
                a = 'hud:toggle',
                toggle = not IsPauseMenuActive()
            })
        end

        SendNUIMessage({
            a = 'SetMap',
            left = math.ceil(GetMinimapAnchor().right_x * 100)
        })

        local drawWeapon = false
        if IsPedArmed(PlayerPedId(), 6) then
            local weaponHash = GetSelectedPedWeapon(PlayerPedId())
            local selectWeapon = Config.Server.hashToLabel[weaponHash]

            if selectWeapon and not drawWeapon then
                local _, ammoInClip = GetAmmoInClip(PlayerPedId(), weaponHash);
                local maxAmmoInClip = GetMaxAmmoInClip(PlayerPedId(), weaponHash, true)
                local weaponLabel = '' ..
                    selectWeapon ..
                    ' <span style="color: var(--color);"> - </span> ' .. ammoInClip .. '/' .. maxAmmoInClip .. ''

                drawWeapon = true
                SendNUIMessage {
                    a = "drawWeapon",
                    weapon = weaponLabel,
                    toggle = true
                }
            else
                drawWeapon = false
                SendNUIMessage {
                    a = "drawWeapon",
                    toggle = false
                }
            end
        else
            drawWeapon = false
            SendNUIMessage {
                a = "drawWeapon",
                toggle = false
            }
        end


        if IsPedInAnyVehicle(PlayerPedId(), false) then
            sleep = 90
            local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6)
            SendNUIMessage({
                a = 'ToggleSpeedo',
                bool = true,
                speed = speed
            })
        else
            SendNUIMessage({
                a = 'ToggleSpeedo',
                bool = false
            })
        end
    end
end);

RegisterNetEvent("feed:add", function(date)
    if Config.Server.Settings.killfeed then
        if #(date.killerpos - GetEntityCoords(PlayerPedId())) < 500 then
            SendNUIMessage({
                a = 'updateKillFeed',
                killer = date.killer,
                victim = date.killed
            })
        end
    end
end);

RegisterNetEvent("discord:setRich", function(players, maxPlayers)
    SetDiscordAppId('1291516394952724573')
    SetDiscordRichPresenceAsset('logo')
    SetDiscordRichPresenceAssetText('discord.gg/lightningcl')
    SetRichPresence("(" ..
        players ..
        " von " .. maxPlayers .. ")\n" .. GetPlayerName(PlayerId()) .. " [" .. GetPlayerServerId(PlayerId()) .. "]")

    SetDiscordRichPresenceAction(0, "Discord!", "https://discord.gg/lightningcl")
    SetDiscordRichPresenceAction(1, "FiveM!", "https://cfx.re/join/7a6pgr")

    SendNUIMessage({
        a = "updatePlayers",
        maxClients = maxPlayers,
        online = players,
    })
end);

RegisterNetEvent("killstreak:send", function(number)
    if Quests.streaks and not collected_quest.streaks and Quests.streaks < Config.Battlepass.quests["streaks"].streak then
        Quests.streaks = Quests.streaks + 1
        TriggerServerEvent("UpdateQuest", Quests)

        if Quests.streaks >= Config.Battlepass.quests.streaks.count then
            TriggerServerEvent("UpdateQuest", Quests)
        end
    end
end);

RegisterNetEvent('esx:setAccountMoney', function(account, type, money)
    Config.PlayerData.money = account.money
    if account.name == "money" then
        SendNUIMessage({
            a = "money",
            money = account.money,
        })
    end

    if account.name == "coins" then
        Config.PlayerData.coins = account.money
        SendNUIMessage({
            a = "coinsUpdate",
            coins = Config.PlayerData.coins,
        })
    end
end);

RegisterNetEvent("Notify", function(data)
    SendNUIMessage({
        a = "AddNotify",
        title = data.title or 'INFO',
        text = data.text,
        time = data.time or 3000,
        type = data.type or "info",
        icon = data.type or 'info'
    })
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end);

RegisterNetEvent("announce", function(data)
    SendNUIMessage({
        a = 'AddAnnounce',
        title = data.title or 'ANNOUNCE',
        text = data.text,
        time = data.time or 6000
    })

    PlaySoundFrontend(-1, "Dropped", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 1)
end);

RegisterNetEvent("progress", function(toggle, time)
    SendNUIMessage { a = 'Bar', time = time, toggle = toggle }
end);

IsAnimated = false

exports("IsAnimated", function()
    return IsAnimated
end);

RegisterCommand("core_healing", function()
    if IsNuiFocused() then
        return
    end
    if not IsEntityDead(PlayerPedId()) and not openAnimation then
        if not IsAnimated then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                local cancelled = false
                ClearPedTasksImmediately(PlayerPedId())
                Utils.loadAnimDict('anim@heists@narcotics@funding@gang_idle')
                TaskPlayAnim(PlayerPedId(), "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01", 4.0, -4.0,
                    -1, 1, 0, false, false, false)
                TriggerEvent('progress', true, 4000)
                IsAnimated = true

                CreateThread(function()
                    while IsAnimated do
                        Wait(0)

                        if IsControlJustPressed(0, 38) then
                            IsAnimated = false
                            cancelled = true
                            TriggerEvent('progress', false)
                            ClearPedTasks(PlayerPedId())
                            used = false
                            Config.HUD.Notify({
                                title = 'Heal ',
                                text = "Dein Healing wurde abgebrochen!",
                                time = 5000,
                                type = 'error'
                            })
                        end
                    end
                end);
                Wait(4000)
                if not cancelled then
                    ClearPedTasks(PlayerPedId())
                    SetPedArmour(PlayerPedId(), 100)
                    SetEntityHealth(PlayerPedId(), 200)
                    IsAnimated = false
                end
            else
                Config.HUD.Notify({
                    title = 'Heal ',
                    text = "Du kannst im Auto keine Schutzweste ziehen!",
                    time = 5000,
                    type = 'error'
                })
            end
        end
    end
end, false);

RegisterNuiCallback("Notify", function(data)
    return Config.HUD.Notify(data)
end);

RegisterKeyMapping("cycleproximity", "Sprachreichweite", "keyboard", "y")

local currRange = 0
local drawing = false
local fadeIn = false
local fadeOut = false
local hideTime2 = 0
local alpha = 100
local maxAlpha = 255
local hideTime = 0
VoiceRanges = {
    {
        range = 2.5,
    },
    {
        range = 8.0,
    },
    {
        range = 16.0,
    },
}

AddEventHandler('pma-voice:setTalkingMode', function(range)
    if range == 1 then
        voice = 2.5
        Config.HUD.Notify({
            title = 'Voice',
            text = 'Sprachreichweite auf 2.5 Meter gesetzt',
            time = 5000,
            type = 'success'
        })
    elseif range == 2 then
        voice = 8.0
        Config.HUD.Notify({
            title = 'Voice',
            text = 'Sprachreichweite auf 8.0 Meter gesetzt',
            time = 5000,
            type = 'success'
        })
    elseif range == 3 then
        voice = 16.0
        Config.HUD.Notify({
            title = 'Voice',
            text = 'Sprachreichweite auf 16.0 Meter gesetzt',
            time = 5000,
            type = 'success'
        })
    end

    change = true

    CreateThread(function()
        while change do
            Wait(1500)
            change = false
        end
    end);
    hideTime = 200
    hideTime2 = 60
    changeRangeSmoothly(voice)
end);

function changeRangeSmoothly(range)
    local target = range
    local step = (target - currRange) / 10
    local duration = 100

    for i = 1, 10 do
        currRange = currRange + step
        drawCircle()
        Wait(duration / 10)
    end

    currRange = target
    drawCircle()
end

function drawCircle()
    if drawing then return end

    drawing = true
    fadeIn = true

    CreateThread(function()
        while hideTime > 0 do
            Wait(0)
            hideTime = hideTime - 1
        end

        fadeIn = false
        fadeOut = true

        while hideTime2 > 0 do
            Wait(0)
            hideTime2 = hideTime2 - 1
        end

        drawing = false
    end);

    CreateThread(function()
        while drawing do
            if fadeIn then
                alpha = math.min(alpha + 5, maxAlpha)
            elseif fadeOut then
                alpha = math.max(alpha - 5, 0)
            end

            local pos = GetEntityCoords(PlayerPedId())
            DrawMarker(1, pos.x, pos.y, pos.z - 0.7, 0, 0, 0, 0, 0, 0, currRange * 2, currRange * 2, 0.5,
                Config.Server.color.r,
                Config.Server.color.g, Config.Server.color.b, alpha, false, false)

            if not fadeIn and alpha == 0 then
                fadeOut = false
            end

            Wait(0)
        end
    end);
end

-----------------------------------------------------------------------------

---------------------------------CAR CLEAR-----------------------------------

-----------------------------------------------------------------------------

RegisterNetEvent('carclear:delete', function()
    Config.HUD.Notify({
        title = 'Car Clear',
        text = 'Alle Leeren Autos gelöscht',
        time = 5000,
        type = 'success'
    })

    local allVehicles = GetGamePool("CVehicle")

    for i = 1, #allVehicles do
        local vehicle = allVehicles[i]

        local driver = GetPedInVehicleSeat(vehicle, -1)

        if not DoesEntityExist(driver) then
            SetEntityAsMissionEntity(vehicle, true, true)

            DeleteEntity(vehicle)
        end
    end

    ClearHdArea()
    ClearAllBrokenGlass()
    ClearPedBloodDamage(PlayerPedId())
end);

-----------------------------------------------------------------------------
------------------------------------FPS--------------------------------------
-----------------------------------------------------------------------------

CreateThread(function()
    while true do
        local f1 = GetFrameCount()

        Wait(1000)

        local f2 = GetFrameCount()

        local fps = (f2 - f1 - 1)

        SendNUIMessage({
            a = 'fps:draw',
            toggle = Config.Server.Settings.fps.show,
            fps = fps .. 'fps'
        })
    end
end);

-----------------------------------------------------------------------------
------------------------------SPRACH INDIKATOR-------------------------------
-----------------------------------------------------------------------------

CreateThread(function()
    while true do
        local sleep = 100

        if Config.Server.Settings.speak then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for _, player in next, (GetActivePlayers()) do
                if player ~= PlayerId() then
                    if NetworkIsPlayerTalking(player) then
                        local otherCoords = GetEntityCoords(GetPlayerPed(player))
                        local distance = #(playerCoords - otherCoords)

                        if distance <= 30.0 and IsEntityVisible(GetPlayerPed(player)) then
                            sleep = 0
                            DrawMarker(2, otherCoords.x, otherCoords.y, otherCoords.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
                                -0.1, -0.1, -0.1, Config.Server.color.r, Config.Server.color.g, Config.Server.color.b,
                                255, false, false, 2,
                                false,
                                false, false, false)
                            DrawMarker(27, otherCoords.x, otherCoords.y, otherCoords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
                                0.8, 0.8, 1.0, Config.Server.color.r, Config.Server.color.g, Config.Server.color.b, 120,
                                false, false, 2,
                                false,
                                false, false, false)
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end);

-----------------------------------------------------------------------------
---------------------------------GAMECONFIG----------------------------------
-----------------------------------------------------------------------------

local render_distance_enabled = false
local render_distance = 5.0
local shadow_enabled = false
local shadow_shit = 5.0

CreateThread(function()
    while true do
        if Config.Server.Settings.freeze then
            NetworkOverrideClockTime(tonumber(Config.Server.Settings.time), 0, 0)
        end

        Wait(5000)
    end
end);

local function startShadowThread()
    CreateThread(function()
        while shadow_enabled do
            Wait(0)
            CascadeShadowsSetCascadeBoundsScale(shadow_shit)
        end
    end);
end

function startRenderThread()
    CreateThread(function()
        while render_distance_enabled do
            Wait(0)
            SetLightsCutoffDistanceTweak(render_distance)
            OverrideLodscaleThisFrame(render_distance)
        end
    end);
end

RegisterNuiCallback("settingsAction", function(data)
    if data.action == "fps_show_toggle" then
        Config.Server.Settings.fps.show = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    elseif data.action == "fps_boost" then
        Config.Server.Settings.fps.boost = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))

        if data.toggle then
            SetTimecycleModifier('yell_tunnel_nodirect')
            render_distance_enabled = true
            render_distance = 0.7
            startRenderThread()
            startShadowThread()
        else
            render_distance_enabled = false
            SetTimecycleModifier()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
        end
    elseif data.action == "hud_toggle" then
        if data.toggle then
            hudForce = false
        else
            hudForce = true
        end

        Config.Server.Settings.hud = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
        SendNUIMessage({
            a = "hud:toggle",
            toggle = data.toggle
        })
    elseif data.action == "feed_toggle" then
        Config.Server.Settings.killfeed = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    elseif data.action == "killmarker_toggle" then
        Config.Server.Settings.killmarker = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    elseif data.action == "speak_toggle" then
        Config.Server.Settings.speak = data.toggle
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    end
end);

RegisterNuiCallback("changeTime", function(time)
    Config.Server.Settings.time = time
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    NetworkOverrideClockTime(tonumber(time), 0, 0)
end);

RegisterNuiCallback("setWeather", function(weather)
    Config.Server.Settings.weather = weather
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))

    SetWeatherTypePersist(Config.Server.Settings.weather)
    SetWeatherTypeNowPersist(Config.Server.Settings.weather)
    SetWeatherTypeNow(Config.Server.Settings.weather)
    SetOverrideWeather(Config.Server.Settings.weather)
end);

RegisterNuiCallback("freezeTime", function(toggle)
    Config.Server.Settings.freeze = toggle
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
end);

RegisterNuiCallback("changeFunkAnimation", function(data)
    Config.Server.Settings.funk.animation.animdict = data.animdict
    Config.Server.Settings.funk.animation.anim = data.anim
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
end);

RegisterNuiCallback("FunkSoundToggle", function(boolean)
    Config.Server.Settings.funk.sound = boolean
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
end);

-----------------------------------------------------------------------------

------------------------------------SHOP-------------------------------------

-----------------------------------------------------------------------------

local function buyKillEffect(data)
    Config.Server.Settings.killeffect.particleDictionary = data.particleDictionary
    Config.Server.Settings.killeffect.particleName = data.particleName
    SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
end

RegisterNuiCallback("buy", function(name)
    TriggerServerEvent("buy", name)
end);

RegisterNuiCallback("sell", function(name)
    TriggerServerEvent("sell", name)
end);

RegisterNuiCallback("buyItem", function(name)
    TriggerServerEvent("buyItem", name)
end);

RegisterNuiCallback("buy_effect", function(name)
    if Config.PlayerData.money >= Config.Server.shop["KILLEFFECTS"][name].price then
        ESX.TriggerServerCallback('canBuyEffect', function(toggle)
            if toggle then
                buyKillEffect({
                    particleDictionary = Config.Server.shop["KILLEFFECTS"][name].data.particleDictionary,
                    particleName = Config.Server.shop["KILLEFFECTS"][name].data.particleName
                })

                Config.HUD.Notify({
                    title = 'Shop',
                    text = 'Du hast den Kill Effect ' .. name .. ' gekauft!',
                    time = 5000,
                    type = 'success'
                })
            end
        end, name)
    else
        Config.HUD.Notify({
            title = 'Shop',
            text = 'Du hast nicht genug Geld!',
            time = 5000,
            type = 'error'
        })
    end
end);

RegisterNuiCallback("sell_effect", function(name)
    local Effect = {
        price = Config.Server.shop["KILLEFFECTS"][name].price,
        particleDictionary = Config.Server.shop["KILLEFFECTS"][name].data.particleDictionary,
        particleName = Config.Server.shop["KILLEFFECTS"][name].data.particleName,
    }

    local Player = {
        particleDictionary = Config.Server.Settings.killeffect.particleDictionary,
        particleName = Config.Server.Settings.killeffect.particleName,
    }

    if Effect.particleDictionary == Player.particleDictionary and Effect.particleName == Player.particleName then
        TriggerServerEvent("sell_effect", name)

        Config.Server.Settings.killeffect.particleDictionary = ""
        Config.Server.Settings.killeffect.particleName = ""
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))

        Config.HUD.Notify({
            title = 'Shop',
            text = 'Du hast den Kill Effect ' .. name .. ' verkauft!',
            time = 5000,
            type = 'success'
        })
    end
end);

RegisterNuiCallback("buyCase", function(data)
    TriggerServerEvent("buyCase", data)
end);

-----------------------------------------------------------------------------

--------------------------------DEATH SYSTEM---------------------------------

-----------------------------------------------------------------------------

removeDeathScreen = function()
    SendNUIMessage({
        a = "deathscreen",
        toggle = false,
    })
end

local Respawn = function(coords, toggle)
    removeDeathScreen()
    Utils.ScreenFade(500)

    SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0, true, false)
    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
    NetworkSetFriendlyFireOption(true)

    ClearPedTasksImmediately(PlayerPedId())
    NetworkSetFriendlyFireOption(true)
    RefillAmmoInstantly(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    RefillAmmoInstantly(PlayerPedId())

    if toggle then
        Utils.setWeapon(lastWeapon)
    end

    CreateThread(Utils.SpawnProtection)

    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)
end

function CreateKillCam(id)
    local attackEntity = GetPlayerPed(GetPlayerFromServerId(id))
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    AttachCamToEntity(cam, attackEntity, 0.0, 2.8, 0.6, true)
    SetCamFov(cam, 75.0)
    PointCamAtEntity(cam, attackEntity, 0.0, 0.0, 0.0, true)
    RenderScriptCams(true, true, 350, true, true)

    Wait(2500)

    SetCamActive(cam, false)
    RenderScriptCams(false, true, 200, false, false)
    DestroyAllCams(true)
    cam = nil
end

RegisterNetEvent("player:revive", function(coords)
    Respawn(coords, true)
end);

RegisterCommand("die", function()
    SetEntityHealth(PlayerPedId(), 0)
end, false);

RegisterNetEvent("deathscreen:show", function(table)
    CreateThread(function()
        CreateKillCam(tonumber(table.id))
    end);

    Config.PlayerData.stats.deaths += 1

    SendNUIMessage({
        a = "deathscreen",
        toggle = true,
        data = table
    })
end);

function KillEffectPlayer(entity)
    if Config.Server.Settings.killmarker then
        local particleDictionary = Config.Server.Settings.killeffect.particleDictionary
        local particleName = Config.Server.Settings.killeffect.particleName

        if not HasNamedPtfxAssetLoaded(particleDictionary) then
            RequestNamedPtfxAsset(particleDictionary)
            while not HasNamedPtfxAssetLoaded(particleDictionary) do
                Wait(1)
            end
        end

        SetPtfxAssetNextCall(particleDictionary)
        local ptfx = StartParticleFxLoopedOnEntity(particleName, entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, false, false,
            false)
        RemoveNamedPtfxAsset(particleDictionary)
        CreateThread(function()
            Wait(2000)
            StopParticleFxLooped(ptfx, 0)
        end);
    end
end

RegisterNetEvent("killer:showStreak", function(data)
    if Config.Server.Settings.killmarker then
        SendNUIMessage({
            a = 'showKillerUI',
            money = data.money,
            midrolled = data.midrolled,

            killer = {
                name = data.killer.name,
                points = data.killer.points
            },
            deathplayer = {
                name = data.deathplayer.name,
                points = data.deathplayer.points
            }
        })
    end

    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)

    KillEffectPlayer(GetPlayerPed(GetPlayerFromServerId(data.deathplayer.id)))
end);

-----------------------------------------------------------------------------

-------------------------------------PVP-------------------------------------

-----------------------------------------------------------------------------

local pvp = {
    ffa = {
        private = false,
        isIn = false,
        zone = "",
        stats = {}
    },

    gungame = {
        isIn = false,
        zone = "",
        currentIndex = 1
    },
}

exports("GetPVP", function()
    return pvp
end);

local GetFFARespawn = function(zone)
    if pvp.ffa.isIn then
        for k, v in next, (Config.pvp.ffa) do
            if k == zone then
                local spawns = v.spawns
                local spawncount = #spawns
                if spawncount > 0 then
                    local spawn = math.random(1, spawncount)
                    local coords = spawns[spawn]
                    return coords
                end
            end
        end
    end
end

local GetGungameRespawn = function(zone)
    if pvp.gungame.isIn then
        for k, v in next, (Config.pvp.gungame) do
            if k == zone then
                local spawns = v.spawns
                local spawncount = #spawns
                if spawncount > 0 then
                    local spawn = math.random(1, spawncount)
                    local coords = spawns[spawn]
                    return coords
                end
            end
        end
    end
end

RegisterCommand("quitffa", function()
    if not IsEntityDead(PlayerPedId()) then
        if pvp.ffa.isIn then
            TriggerServerEvent("pvp:leaveFFA", pvp.ffa.zone, pvp.ffa.stats.kills, pvp.ffa.stats.deaths)

            SendNUIMessage({
                a = "ffa:statsUpdate",

                data = {
                    kills = Config.PlayerData.stats.kills,
                    deaths = Config.PlayerData.stats.deaths,
                }
            })

            TriggerServerEvent("setDimension", 0)
            TriggerServerEvent("RestoreLoadout")

            ToggleCamMode(true)

            pvp.ffa.zone = ""
            pvp.ffa.isIn = false
        end

        if pvp.gungame.isIn then
            TriggerServerEvent("pvp:leaveGunGame", pvp.gungame.zone)


            TriggerServerEvent("setDimension", 0)
            TriggerServerEvent("RestoreLoadout")

            ToggleCamMode(true)

            pvp.gungame.currentIndex = 1
            pvp.gungame.isIn = false
            pvp.gungame.zone = ""
        end
    end
end, false);

-- FFA
CreateThread(function()
    while true do
        if pvp.ffa.isIn then
            Wait(0)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 74, true)
            DisableControlAction(0, 74, true)
            for k, v in next, (Config.pvp.ffa) do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local dist = #(playerCoords - vec3(v.middle.x, v.middle.y, v.middle.z))
                if k == pvp.ffa.zone then
                    local currentTime = GetGameTimer()
                    local r = math.floor(math.sin(currentTime / 4000) * 127 + 128)
                    local g = math.floor(math.sin(currentTime / 4000 + 2) * 127 + 128)
                    local b = math.floor(math.sin(currentTime / 4000 + 4) * 127 + 128)
                    DrawGlowSphere(v.middle.x, v.middle.y, v.middle.z, v.size, r, g, b, 0.5, true, true)

                    if dist > v.size + 1.0 then
                        Respawn(GetFFARespawn(pvp.ffa.zone), true)
                    end
                end
            end
        else
            Wait(2500)
        end
    end
end);

RegisterNetEvent("ffa:updateStats", function(kills, deaths)
    pvp.ffa.stats.kills = kills
    pvp.ffa.stats.deaths = deaths

    SendNUIMessage({
        a = "ffa:statsUpdate",
        data = {
            kills = pvp.ffa.stats.kills,
            deaths = pvp.ffa.stats.deaths,
        }
    })
end);

RegisterNuiCallback("ffaJoin", function(name)
    pvp.ffa.isIn = true
    pvp.ffa.zone = name

    if Quests.ffajoin and not collected_quest.ffajoin and Quests.ffajoin < Config.Battlepass.quests["ffajoin"].count then
        Quests.ffajoin = Quests.ffajoin + 1
        TriggerServerEvent("UpdateQuest", Quests)
    end

    TriggerServerEvent("pvp:joinFFA", name)
    TriggerServerEvent("setDimension", 1)
    Respawn(GetFFARespawn(name), true)

    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)
end);

RegisterNuiCallback("createFFALobby", function(data)
    TriggerServerEvent("pvp:createFFALobby", data)
end)

RegisterNUICallback('JoinPrivateFFA', function(data)
    TriggerServerEvent('framework:joinPrivateFFA', data)
end)

RegisterNetEvent("ffa:update:points", function()
    if not pvp.ffa.private then
        if pvp.ffa.isIn then
            pvp.ffa.stats.kills += 1
            SendNUIMessage({
                a = "ffa:statsUpdate",
                data = {
                    kills = pvp.ffa.stats.kills,
                    deaths = pvp.ffa.stats.deaths,
                }
            })
        end
    end
end);

RegisterNetEvent('framework:sendPrivateLobbies', function(lobbies)
    PrivateLobbies = lobbies
end)

RegisterNetEvent('framework:joinPrivateLobby', function(source)
    local lobby = PrivateLobbies[tonumber(source)]
    if lobby then
        for k, v in next, (PrivateLobbies) do
            if tonumber(k) == tonumber(source) then
                pvp.ffa.isIn = true;
                pvp.ffa.private = true;
                pvp.ffa.zone = v.zone;

                TriggerServerEvent('setDimension', tonumber(k))

                Respawn(GetFFARespawn(v.zone), true)

                Config.HUD.Notify({
                    title = 'PVP',
                    text = "Du hast die Lobby " .. v.name .. " betreten",
                    time = 5000,
                    type = 'success'
                })
                SetNuiFocus(false, false)
                break;
            end
        end
    end
end)

RegisterNetEvent('framework:leavePrivateLobby', function(id)
    if pvp.ffa.isIn then
        TriggerServerEvent("pvp:leaveFFA", pvp.ffa.zone)

        SendNUIMessage({
            a = "ffa:statsUpdate",
            data = {
                kills = Config.PlayerData.stats.kills,
                deaths = Config.PlayerData.stats.deaths,
            }
        })

        TriggerServerEvent("setDimension", 0)
        TriggerServerEvent("RestoreLoadout")

        ToggleCamMode(true)

        pvp.ffa.zone = "";
        pvp.ffa.isIn = false;
        pvp.ffa.private = false;

        Config.HUD.Notify({
            title = 'PVP',
            text = "Du wurdest aus der Lobby geworfen, weil sie geschlossen wurde.",
            time = 5000,
            type = 'information'
        })
    end
end)

RegisterCommand('closelobby', function()
    TriggerServerEvent('framework:closeLobby')
end, false)

-- GUNGAME
RegisterNuiCallback("gungameJoin", function(name)
    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)
    pvp.gungame.isIn = true
    pvp.gungame.currentIndex = 1
    pvp.gungame.zone = name

    if Quests.gungamejoin and not collected_quest.gungamejoin and Quests.gungamejoin < Config.Battlepass.quests["gungamejoin"].count then
        Quests.gungamejoin = Quests.gungamejoin + 1
        TriggerServerEvent("UpdateQuest", Quests)
    end

    TriggerServerEvent("pvp:joinGunGame", name)
    TriggerServerEvent("setDimension", 2)
    Respawn(GetGungameRespawn(name), true)

    RemoveAllPedWeapons(PlayerPedId(), true)
    Wait(250)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.pvp.gungameLevels[pvp.gungame.currentIndex]), 999, false, true)
end);

CreateThread(function()
    while true do
        if pvp.gungame.isIn then
            Wait(0)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 74, true)
            DisableControlAction(0, 74, true)
            for k, v in next, (Config.pvp.gungame) do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local dist = #(playerCoords - vec3(v.middle.x, v.middle.y, v.middle.z))
                if k == pvp.gungame.zone then
                    local currentTime = GetGameTimer()
                    local r = math.floor(math.sin(currentTime / 4000) * 127 + 128)
                    local g = math.floor(math.sin(currentTime / 4000 + 2) * 127 + 128)
                    local b = math.floor(math.sin(currentTime / 4000 + 4) * 127 + 128)
                    DrawGlowSphere(v.middle.x, v.middle.y, v.middle.z, v.size, r, g, b, 0.5, true, true)

                    if dist > v.size + 1.0 then
                        Respawn(GetGungameRespawn(pvp.gungame.zone), true)
                    end
                end
            end
        else
            Wait(2500)
        end
    end
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle == 0 then
        DeleteEntity(vehicle)
    end

    if data and data.killerServerId then
        TriggerServerEvent("quests:playerKilled", data.killerServerId)
    end

    warImMarker = false
    canEventBubbleDraw = false
    isInMarker = false
    rotation = nil

    if Utils.CanDoStuff() then
        Wait(2500)

        Respawn(Config.Server.Settings.dauermap, true)
    end

    if pvp.ffa.isIn and not pvp.ffa.private then
        pvp.ffa.stats.deaths += 1
        SendNUIMessage({
            a = "ffa:statsUpdate",
            data = {
                kills = pvp.ffa.stats.kills,
                deaths = pvp.ffa.stats.deaths,
            }
        })
        if data then
            TriggerServerEvent("ffa:addKill", data.killerServerId)
        end

        Wait(2500)
        Respawn(GetFFARespawn(pvp.ffa.zone), true)
    end

    if pvp.gungame.isIn then
        if pvp.gungame.currentIndex > 1 then
            RemoveAllPedWeapons(PlayerPedId(), true)
        end

        if data then
            TriggerServerEvent("gungame:updatePoints", data.killerServerId)
        end

        Wait(2500)
        Respawn(GetGungameRespawn(pvp.gungame.zone), true)
        Wait(100)
        if pvp.gungame.currentIndex > 1 then
            pvp.gungame.currentIndex = pvp.gungame.currentIndex - 1
            GiveWeaponToPed(PlayerPedId(),
                GetHashKey(Config.pvp.gungameLevels[pvp.gungame.currentIndex]), 999, false, true)
            Wait(50)
            Utils.setWeapon(Config.pvp.gungameLevels[pvp.gungame.currentIndex])
        end
    end

    if killzone.inZone then
        local spawn = returnRandomKillzoneSpawn()

        Wait(2500)
        Respawn(spawn, true)
    end
end);

RegisterNetEvent("gungame:update:points", function()
    if pvp.gungame.isIn then
        local maxCount = #Config.pvp.gungameLevels

        if pvp.gungame.currentIndex < maxCount then
            pvp.gungame.currentIndex = pvp.gungame.currentIndex + 1
            RemoveAllPedWeapons(PlayerPedId(), true)
            Wait(50)
            GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.pvp.gungameLevels[pvp.gungame.currentIndex]), 999, false,
                true)

            CreateThread(function()
                DisplayBoughtScaleform(Config.Server.hashToLabel
                    [GetHashKey(Config.pvp.gungameLevels[pvp.gungame.currentIndex])])
            end)
        else
            TriggerServerEvent("gungame:addWin", GetPlayerServerId(PlayerId()))
            ExecuteCommand("quitffa")

            Config.HUD.Notify({
                title = "PVP",
                text = "Du hast das GunGame gewonnen!",
                time = 5000,
                type = "success"
            })
        end
    end
end);

-----------------------------------------------------------------------------
---------------------------------HANDSUP-------------------------------------
-----------------------------------------------------------------------------

local dict = "missminuteman_1ig_2"
local anim = "handsup_enter"
local handsup = false

RegisterKeyMapping('handsup', "Hands Up", "keyboard", "h")

RegisterCommand('handsup', function()
    if Utils.CanDoStuff() then
        local ped = PlayerPedId()
        if not IsAnimated then
            if not handsup then
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(100)
                end

                TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                ClearPedTasks(ped)
                handsup = false
            end
        end
    end
end, false);

-----------------------------------------------------------------------------
-----------------------------------Q PEAK------------------------------------
-----------------------------------------------------------------------------

RegisterKeyMapping('-core:crouchen', "Q Peak", "keyboard", "q")

local function playerCrouchen()
    if (DoesEntityExist(PlayerPedId())) and not (IsEntityDead(PlayerPedId())) and (IsPedOnFoot(PlayerPedId())) then
        hatDieKnieAufmBoden = not hatDieKnieAufmBoden
        if hatDieKnieAufmBoden then
            if not IsPauseMenuActive() then
                RequestAnimSet('move_ped_crouched')

                while not HasAnimSetLoaded('move_ped_crouched') do
                    Wait(100)
                end

                SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 0.2)
            end
        else
            ResetPedMovementClipset(PlayerPedId(), 0)
            ClearPedTasks(PlayerPedId())
        end
    end
end

RegisterCommand('-core:crouchen', function()
    playerCrouchen()
end, false);

-----------------------------------------------------------------------------
----------------------------------ANTI VDM-----------------------------------
-----------------------------------------------------------------------------

CreateThread(function()
    while true do
        local allVehs = GetGamePool("CVehicle")
        local allPeds = GetGamePool("CPed")
        local pPed = PlayerPedId()
        local c = GetEntityCoords(pPed)
        local closestDist = 3000000000000
        local clostestEnt = 0

        if IsPedInAnyVehicle(pPed, true) then
            for _, veh in next, (allVehs) do
                if GetEntityAlpha(veh) == 254 then
                    ResetEntityAlpha(veh)
                    SetEntityNoCollisionEntity(pPed, veh, true)
                    SetEntityNoCollisionEntity(veh, pPed, true)
                end
            end
            for _, ped in next, (allPeds) do
                local cp = GetEntityCoords(ped)
                local dist = #(cp - c)

                if dist <= closestDist then
                    closestDist = dist
                    clostestEnt = ped
                end

                if dist <= 40.0 then
                    if GetEntityAlpha(ped) ~= 254 then
                        SetEntityAlpha(ped, 254)
                    end
                    SetEntityNoCollisionEntity(pPed, ped, true)
                    SetEntityNoCollisionEntity(ped, pPed, true)
                else
                    if GetEntityAlpha(ped) == 254 then
                        ResetEntityAlpha(ped)
                        SetEntityNoCollisionEntity(pPed, ped, true)
                        SetEntityNoCollisionEntity(ped, pPed, true)
                    end
                end
            end
        else
            for _, veh in next, (allVehs) do
                local pedCoords = GetEntityCoords(veh)
                local dist = #(pedCoords - c)

                if dist <= closestDist and GetPedInVehicleSeat(veh, -1) ~= 0 then
                    closestDist = dist
                    clostestEnt = veh
                end

                if dist <= 40.0 then
                    if GetEntityAlpha(veh) ~= 254 then
                        SetEntityAlpha(veh, 254)
                    end
                    SetEntityNoCollisionEntity(pPed, veh, true)
                    SetEntityNoCollisionEntity(veh, pPed, true)
                else
                    if GetEntityAlpha(veh) == 254 then
                        ResetEntityAlpha(veh)
                        SetEntityNoCollisionEntity(pPed, veh, true)
                        SetEntityNoCollisionEntity(veh, pPed, true)
                    end
                end
            end
        end

        if closestDist <= 20.0 then
            if GetEntityAlpha(clostestEnt) ~= 254 then
                SetEntityAlpha(clostestEnt, 254)
            end
            SetEntityNoCollisionEntity(pPed, clostestEnt, true)
            SetEntityNoCollisionEntity(clostestEnt, pPed, true)

            Wait(0)
        else
            Wait(500)
        end
        Wait(0)
    end
end);

-----------------------------------------------------------------------------
----------------------------------INVENTORY----------------------------------
-----------------------------------------------------------------------------

RegisterNuiCallback("inventory", function(data)
    if data.action == "trash" then
        TriggerServerEvent("inventory:trash", data.name)
    elseif data.action == "attachment" then
        for k, v in next, ESX.GetWeaponList() do
            for k1, v1 in next, Config.PlayerData.loadout do
                if (v.name) == (data.name) and (v1.name) == (data.name) then
                    for k2, v2 in next, v.components do
                        local has = false
                        for k3, v3 in next, v1.components do
                            if (v2.name) == v3 then
                                has = true
                            end
                        end

                        if v2.price ~= nil then
                            if has then
                                price = ESX.Round(v2.price / 2)
                            else
                                price = v2.price
                            end
                        end

                        if price then
                            SendNUIMessage({
                                a = 'inventory:addAttachments',
                                weapon = (data.name),
                                name = (v2.name),
                                label = v2.label,
                                price = price,
                                has = has
                            })
                        end
                    end
                end
            end
        end
    elseif data.action == "attachment_drauf" then
        TriggerServerEvent("inventar:buyAttachment", data.name, data.attachment, data.label)
    elseif data.action == "attachment_weg" then
        TriggerServerEvent("inventar:sellAttachment", data.name, data.attachment, data.label)
    elseif data.action == "use-item" then
        TriggerServerEvent("inventory:use", data.name)
    elseif data.action == "weapontints" then
        local result = {}

        for tintName, tintValues in next, Config.factions.tints do
            if string.find(data.name, "_MK2") or string.find(data.name, "_mk2") then
                if tintValues.mk2 then
                    result[tintName] = {
                        label = tintValues.label,
                        value = tintValues.mk2
                    }
                end
            else
                if tintValues.normal then
                    result[tintName] = {
                        label = tintValues.label,
                        value = tintValues.normal
                    }
                end
            end
        end

        SendNUIMessage({
            a = 'addTints',
            tints = result,
            weapon = data.name
        })
    end
end);

-----------------------------------------------------------------------------
---------------------------------BATTLEPASS----------------------------------
-----------------------------------------------------------------------------

RegisterNuiCallback('collect', function(data)
    TriggerServerEvent('battlepass:collect', data);
end);

RegisterNuiCallback('collect_premium', function(data)
    TriggerServerEvent('battlepass:collect_premium', data);
end);

RegisterNuiCallback("changeMoneyToXp", function(data)
    TriggerServerEvent("battlepass:changeMoneyToXp", data)
end);

-- QUESTS
AddEventHandler("gameEventTriggered", function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[5]
        local a, bone = GetPedLastDamageBone(victim)

        if attacker == PlayerPedId() and bone == 31086 then
            if Quests.headshots and not collected_quest.headshots and Quests.headshots < Config.Battlepass.quests["headshots"].count then
                Quests.headshots = Quests.headshots + 1
                TriggerServerEvent("UpdateQuest", Quests)
            end
        end
    end
end);

RegisterNetEvent("quests:playerKilled", function()
    if not pvp.ffa.isIn then
        if Quests.kills and not collected_quest.kills and Quests.kills < Config.Battlepass.quests["kills"].count then
            Quests.kills = Quests.kills + 1
            TriggerServerEvent("UpdateQuest", Quests)
        end
    end

    if pvp.ffa.isIn then
        if Quests.ffa_kills and not collected_quest.ffa_kills and Quests.ffa_kills < Config.Battlepass.quests["ffa_kills"].count then
            Quests.ffa_kills = Quests.ffa_kills + 1
            TriggerServerEvent("UpdateQuest", Quests)
        end
    end
end);

RegisterNuiCallback("ClaimWinQuest", function(type)
    if type == "kills" then
        collected_quest.kills = true
    elseif type == "ffa_kills" then
        collected_quest.ffa_kills = true
    elseif type == "streaks" then
        collected_quest.streaks = true
    elseif type == "headshots" then
        collected_quest.headshots = true
    elseif type == "ffajoin" then
        collected_quest.ffajoin = true
    elseif type == "gungamejoin" then
        collected_quest.gungamejoin = true
    end

    TriggerServerEvent("claimQuest", type)
end);

-----------------------------------------------------------------------------
--------------------------------ADMIN SYSTEM---------------------------------
-----------------------------------------------------------------------------

local lastSkin = nil
local weaponToCheck = "weapon_marksmanpistol"

RegisterKeyMapping("a", "Aduty", "keyboard", "F9")
RegisterKeyMapping('noclip', 'Toggle Noclip', 'keyboard', 'F10')

function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

RegisterNetEvent("event:updateData", function(data)
    eventData.toggle = data.toggle
    eventData.name = data.name
end);

local EventSafezone = vec3(0, 0, 0)

RegisterNetEvent("event:safezone:open", function(coords, radius)
    if not type(coords) == "vector3" or not type(radius) == "number" then return end

    EventSafezone = vector3(coords.x, coords.y, coords.z)
    if canMarkerDraw then return end
    canMarkerDraw = true

    if radius and tonumber(radius) > 0 then
        eventData.position = EventSafezone

        CreateThread(function()
            while canMarkerDraw do
                local sleep = 500

                if canMarkerDraw and eventData and vec3(eventData.position.x, eventData.position.y, eventData.position.z) then
                    local dist = #(GetEntityCoords(PlayerPedId()) - vec3(eventData.position.x, eventData.position.y, eventData.position.z))

                    if dist < radius + 0.1 + 10.0 then
                        sleep = 1
                        DrawGlowSphere(coords.x, coords.y, coords.z, radius + 0.1, Config.Server.color.r,
                            Config.Server.color.g,
                            Config.Server.color.b, 0.25, true, true)

                        if dist < radius and not isInMarker then
                            isInMarker = true
                            SetEntityInvincible(PlayerPedId(), true)
                            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                        elseif dist > radius and isInMarker then
                            isInMarker = false
                            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                            SetEntityInvincible(PlayerPedId(), false)
                        end
                    end
                end
                Wait(sleep)
            end
        end);
    end
end);

RegisterNetEvent("event:safezone:close", function()
    canMarkerDraw = false
    SetEntityInvincible(PlayerPedId(), false)
end);

CreateThread(function()
    while true do
        if duty.inDuty then
            SetEntityInvincible(PlayerPedId(), true)
        end
        Wait(500)
    end
end);

local setDuty = function(group)
    TriggerEvent('skinchanger:getSkin', function(skin)
        lastSkin = skin
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, duty.clothes[group].male)
        elseif skin.sex == 1 then
            TriggerEvent('skinchanger:loadClothes', skin, duty.clothes[group].female)
        end

        SetEntityInvincible(PlayerPedId(), true)
    end);
end;

local resetDuty = function()
    TriggerEvent('skinchanger:loadSkin', lastSkin)
    SetEntityInvincible(PlayerPedId(), false)
end;

Event.openMainmenu = function()
    local elements = {}

    table.insert(elements, { label = "Verwaltung" })
    table.insert(elements, { label = "Bubble" })
    table.insert(elements, { label = "Rückerstattung" })
    table.insert(elements, { label = "Safezone" })
    table.insert(elements, { label = "Ankündigungen" })
    table.insert(elements, { label = "MoneyDrop Starten" })
    table.insert(elements, { label = "Killzone" })

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Verwaltung" then
            Event.openVerwaltung()
        elseif data.current.label == "Bubble" then
            Event.Bubble()
        elseif data.current.label == "Rückerstattung" then
            Event.refundMenu()
        elseif data.current.label == "Safezone" then
            Event.safezone()
        elseif data.current.label == "Ankündigungen" then
            Event.announce()
        elseif data.current.label == "MoneyDrop Starten" then
            ExecuteCommand("moneydrop")
        elseif data.current.label == "Killzone" then
            Event.KillzoneMenu()
        end
    end, function(data, menu)
        menu.close()
    end);
end;

Event.KillzoneMenu = function()
    local elements = {}

    table.insert(elements, { label = "Starten" })
    table.insert(elements, { label = "Stoppen" })

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Starten" then
            ExecuteCommand("killzone start")
        elseif data.current.label == "Stoppen" then
            ExecuteCommand("killzone stop")
        end
    end, function(data, menu)
        menu.close()
        Event.openMainmenu()
    end);
end;

Event.WeaponRefund = function()
    local elements = {}

    for k, v in next, Config.admin.weaponstorefund do
        table.insert(elements, { label = v.label, data = v.name })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_weapon_refund', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'event_weapon_amount', {
            title = 'ID'
        }, function(mdata, menu)
            local amount = tonumber(mdata.value)
            if amount and amount > 0 then
                TriggerServerEvent("event:weaponrefund", amount, data.current.data)
                menu.close()
            else
                Config.HUD.Notify({
                    title = "EVENT",
                    text = "Ungültige Anzahl eingegeben.",
                    type = "error",
                    time = 5000
                })
            end
        end, function(mdata, menu)
            menu.close()
            Wait(50)
            Event.openMainmenu()
        end);
    end, function(data, menu)
        menu.close()
        Event.openMainmenu()
    end);
end;

Event.ItemsRefund = function()
    local elements = {}

    for k, v in next, Config.admin.itemstorefund do
        table.insert(elements, { label = v.label, data = v.name })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_weapon_refund', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'event_weapon_amount', {
            title = 'ID'
        }, function(mdata, menu)
            local amount = tonumber(mdata.value)
            if amount and amount > 0 then
                TriggerServerEvent("event:ItemsRefund", amount, data.current.data)
                menu.close()
            else
                Config.HUD.Notify({
                    title = "EVENT",
                    text = "Ungültige Anzahl eingegeben.",
                    type = "error",
                    time = 5000
                })
            end
        end, function(mdata, menu)
            menu.close()
            Wait(50)
            Event.openMainmenu()
        end);
    end, function(data, menu)
        menu.close()
        Event.openMainmenu()
    end);
end;

Event.refundMenu = function()
    local elements = {
        { label = "Geld" },
        { label = "Waffen" },
        { label = "Items" }
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_refund_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Geld" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'event_money_id', {
                title = 'Spieler-ID'
            }, function(mdata, amenu)
                local playerID = tonumber(mdata.value)
                amenu.close()
                if playerID then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'event_money_amount', {
                        title = 'Betrag'
                    }, function(adata, amenu)
                        local money = tonumber(adata.value)
                        if money and money > 0 then
                            TriggerServerEvent("event:refund", playerID, money)
                            amenu.close()
                            Wait(50)
                            Event.refundMenu()
                        else
                            Config.HUD.Notify({
                                title = "EVENT",
                                text = "Ungültiger Betrag eingegeben.",
                                type = "error",
                                time = 5000
                            })
                        end
                    end, function(adata, amenu)
                        amenu.close()
                        Wait(50)
                        Event.openMainmenu()
                    end);
                else
                    Config.HUD.Notify({
                        title = "EVENT",
                        text = "Ungültige Spieler-ID eingegeben.",
                        type = "error",
                        time = 5000
                    })
                end
            end, function(mdata, amenu)
                amenu.close()
                Wait(50)
                Event.openMainmenu()
            end);
        elseif data.current.label == "Waffen" then
            Event.WeaponRefund()
        elseif data.current.label == "Items" then
            Event.ItemsRefund()
        end
    end, function(data, menu)
        menu.close()
        Wait(50)
        Event.openMainmenu()
    end);
end;

Event.announce = function()
    local elements = {}

    table.insert(elements, { label = "Eigene Schreiben", action = "announce:self:send" })
    table.insert(elements, { label = "-----------------------" })
    table.insert(elements, { label = "3, 2, 1, GO!", action = "announce:send" })

    for k, v in next, Config.admin.announce do
        table.insert(elements, { label = v.name, action = "announce:send", data = v.label })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.action == "announce:self:send" then
            ESX.UI.Menu.Open('dialog', 'event_announce', 'amount', {
                title = 'Announce'
            }, function(mdata, menu)
                if mdata.value then
                    ExecuteCommand("eventann " .. mdata.value)
                    menu.close();
                end
            end, function(mdata, menu)
                Event.openMainmenu()
            end);
        elseif data.current.action == "announce:send" then
            if data.current.label == "3, 2, 1, GO!" then
                ExecuteCommand("eventann 3")
                Wait(1000)
                ExecuteCommand("eventann 2")
                Wait(1000)
                ExecuteCommand("eventann 1")
                Wait(1000)
                ExecuteCommand("eventann GOOO")
            else
                ExecuteCommand("eventann " .. data.current.data)
            end
        end
    end, function(data, menu)
        Event.openMainmenu()
    end);
end;

Event.safezone = function()
    local elements = {}

    table.insert(elements, { label = "Erstellen" })
    table.insert(elements, { label = "Entfernen" })

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Erstellen" then
            ESX.UI.Menu.Open('dialog', 'event_safezone', 'amount', {
                title = 'Radius'
            }, function(mdata, menu)
                if tonumber(mdata.value) and mdata.value > 0 then
                    TriggerServerEvent("event:safezone:open", tonumber(mdata.value))
                    menu.close();
                end
            end, function(mdata, menu)
                menu.close();
            end);
        elseif data.current.label == "Entfernen" then
            TriggerServerEvent("event:safezone:close")
        end
    end, function(data, menu)
        Event.openMainmenu()
    end);
end;

Event.openVerwaltung = function()
    local elements = {}

    table.insert(elements, { label = "Starten" })
    table.insert(elements, { label = "Teleport stoppen" })

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Verwaltung Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Starten" then
            ESX.UI.Menu.Open('dialog', 'event_start', 'amount', {
                title = 'Name Eingeben'
            }, function(mdata, menu)
                if not eventData.toggle and not eventData.name then
                    eventData.name = mdata.value
                    TriggerServerEvent("event:open", eventData.name)
                    menu.close()
                else
                    Config.HUD.Notify({
                        title = "EVENT",
                        text = "Es läuft bereits ein Event",
                        type = "error",
                        time = 5000
                    })
                end
            end, function(mdata, menu)
                menu.close();
            end);
        elseif data.current.label == "Teleport stoppen" then
            eventData = {}
            TriggerServerEvent("event:close")
        end
    end, function(data, menu)
        Event.openMainmenu()
    end);
end;

Event.BubbleCreate = function()
    ESX.UI.Menu.Open('dialog', 'event_rotation', 'amount', {
        title = 'ROTATION/DAMAGE - JA / NEIN'
    }, function(rotation, rotation_menu)
        if rotation.value then
            BubbleRotation = rotation.value
            rotation_menu.close()

            ESX.UI.Menu.Open('dialog', 'event_size', 'amount', {
                title = 'Radius'
            }, function(size, size_menu)
                if size.value then
                    TriggerServerEvent("event:bubble", tonumber(size.value), BubbleRotation)
                    size_menu.close()
                end
            end, function(size, menu)
                menu.close();
            end);
        end
    end, function(rotation, menu)
        Event.Bubble()
    end);
end;

Event.Bubble = function()
    local elements = {}

    table.insert(elements, { label = "Erstellen" })
    table.insert(elements, { label = "Entfernen" })

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
        title    = 'Event Menü',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.label == "Erstellen" then
            Event.BubbleCreate()
        elseif data.current.label == "Entfernen" then
            TriggerServerEvent("event:bubble:close")
        end
    end, function(data, menu)
        Event.openMainmenu()
    end);
end;

RegisterCommand("eventmenu", function()
    if Config.PlayerData.event then
        Event.openMainmenu()
    end
end, false);

RegisterCommand("event", function()
    if eventData.toggle and eventData.name then
        SendNUIMessage({
            a = "eventRoles",
        })
        Wait(100)
        SetNuiFocus(true, true)
    end
end, false);

RegisterCommand("a", function()
    if Config.PlayerData.group ~= "user" then
        if not duty.inDuty then
            duty.inDuty = true
            setDuty(Config.PlayerData.group)

            Config.HUD.Notify({
                title = 'Aduty',
                text = 'Aduty aktiviert',
                type = 'info',
                time = 5000,
            })
        elseif duty.inDuty then
            duty.inDuty = false
            resetDuty()

            Config.HUD.Notify({
                title = 'Aduty',
                text = 'Aduty deaktiviert',
                type = 'info',
                time = 5000,
            })
        end
    end
end, false);

RegisterCommand('noclip', function()
    if duty.inDuty then
        noclip = not noclip
        NoclipSpeed = 1
        Config.HUD.Notify({
            title = 'Noclip',
            text = noclip and 'Noclip aktiviert' or 'Noclip deaktiviert',
            type = 'info',
            time = 5000,
        })

        local GetEntityCoords = GetEntityCoords
        local SetEntityVisible = SetEntityVisible
        local SetEntityCollision = SetEntityCollision
        local SetEntityVelocity = SetEntityVelocity
        local IsDisabledControlJustPressed = IsDisabledControlJustPressed
        local SetEntityCoordsNoOffset = SetEntityCoordsNoOffset
        SetEntityVisible(PlayerPedId(), not noclip, not noclip)
        SetEntityCollision(PlayerPedId(), not noclip, not noclip)

        while noclip do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped, true)
            local x, y, z = coords.x, coords.y, coords.z
            local dx, dy, dz = GetCamDirection()

            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

            if IsDisabledControlJustPressed(0, 21) then -- Geschwindigkeit erhöhen
                oldSpeed = NoclipSpeed
                NoclipSpeed = NoclipSpeed * 5
            end

            if IsDisabledControlJustReleased(0, 21) then -- Geschwindigkeit zurücksetzen
                NoclipSpeed = oldSpeed
            end

            if IsDisabledControlPressed(0, 32) then -- Vorwärts
                x = x + NoclipSpeed * dx
                y = y + NoclipSpeed * dy
                z = z + NoclipSpeed * dz
            end

            if IsDisabledControlPressed(0, 31) then -- Rückwärts
                x = x - NoclipSpeed * dx
                y = y - NoclipSpeed * dy
                z = z - NoclipSpeed * dz
            end

            if IsDisabledControlPressed(0, 34) then -- Nach links (A)
                x = x - NoclipSpeed * dy
                y = y + NoclipSpeed * dx
            end

            if IsDisabledControlPressed(0, 35) then -- Nach rechts (D)
                x = x + NoclipSpeed * dy
                y = y - NoclipSpeed * dx
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
            Wait(0) -- Glatteres Noclip durch kleinere Wartezeit
        end

        SetEntityVisible(PlayerPedId(), not noclip, not noclip)
        SetEntityCollision(PlayerPedId(), not noclip, not noclip)
    else
        Config.HUD.Notify({
            title = 'Noclip',
            text = 'Noclip nicht verfügbar du musst im Aduty sein!',
            type = 'error',
            time = 5000,
        })
    end
end, false);

RegisterCommand("car", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    if Config.PlayerData.group ~= "user" then
        if args and args[1] then
            ESX.Game.SpawnVehicle(args[1], playerCoords, playerHeading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

                SetVehicleModKit(vehicle, 0)

                for i = 0, 49 do
                    local modCount = GetNumVehicleMods(vehicle, i)
                    if modCount > 0 then
                        SetVehicleMod(vehicle, i, modCount - 1, false)
                    end
                end

                ToggleVehicleMod(vehicle, 20, true)
                SetVehicleTyresCanBurst(vehicle, false)
                SetVehicleWindowTint(vehicle, 1)
                SetVehicleColours(vehicle, 12, 12)
                SetVehicleExtraColours(vehicle, 70, 141)

                SetVehicleMod(vehicle, 16, 4, false)
                SetVehicleMod(vehicle, 12, 2, false)
                SetVehicleMod(vehicle, 11, 3, false)
                SetVehicleMod(vehicle, 15, 3, false)
            end);
        else
            Config.HUD.Notify({
                title = "Admin",
                text = "Du musst ein Fahrzeug angeben!",
                type = "error",
                time = 2500
            })
        end
    end
end, false);

RegisterNuiCallback("acceptRules", function()
    if eventData.toggle and eventData.name then
        TriggerServerEvent("event:join")
        SetNuiFocus(false, false)
    end
end);

RegisterNetEvent("event:bubble", function(coords, size, rotation)
    if canEventBubbleDraw then return end
    canEventBubbleDraw = true

    CreateThread(function()
        while canEventBubbleDraw do
            local sleep = 500

            local dist = #(GetEntityCoords(PlayerPedId()) - coords)

            if dist < size + 10.0 then
                sleep = 1
                local currentTime = GetGameTimer()
                local r = math.floor(math.sin(currentTime / 4000) * 127 + 128)
                local g = math.floor(math.sin(currentTime / 4000 + 2) * 127 + 128)
                local b = math.floor(math.sin(currentTime / 4000 + 4) * 127 + 128)
                DrawGlowSphere(coords.x, coords.y, coords.z, size + 0.1, r, g, b, 0.5, true, true)

                if dist < size and not isInMarker then
                    warImMarker = true
                    isInMarker = true
                elseif dist > size and isInMarker then
                    isInMarker = false
                end
            end

            Wait(sleep)
        end
    end);

    CreateThread(function()
        while rotation == "ja" or rotation == "JA" do
            if canEventBubbleDraw and not isInMarker and warImMarker then
                ApplyDamageToPed(PlayerPedId(), 15, false)
            end

            if size == 10.0 then return end
            size = size - 0.3
            Wait(500)
        end
    end);
end);

RegisterNetEvent("event:bubble:close", function()
    canEventBubbleDraw = false
    isInMarker = false
    rotation = nil
end);

AddEventHandler("gameEventTriggered", function(eventName, eventData)
    if eventName ~= "CEventNetworkEntityDamage" then
        return
    end

    local target = eventData[1]
    local source = eventData[2]
    local currentWeapon = GetSelectedPedWeapon(PlayerPedId())

    if source == PlayerPedId() and IsEntityDead(target) and currentWeapon == GetHashKey(weaponToCheck) then
        local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
        TriggerServerEvent("adminpanel:kickPlayer", targetServerId, EventKickReason)
    end
end);

-----------------------------------------------------------------------------
---------------------------------MONEY DROP----------------------------------
-----------------------------------------------------------------------------

local markerVisible = true
local markerCoords = nil

RegisterNetEvent("moneydrop:draw", function(coords)
    Wait(1000)
    blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 605)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Moneydrop')
    EndTextCommandSetBlipName(blip)

    markerCoords = coords
    markerVisible = true

    while true do
        local sleep = 500
        local dist = #(GetEntityCoords(PlayerPedId()) - vec3(markerCoords.x, markerCoords.y, markerCoords.z))
        if dist <= 50 and markerVisible then
            sleep = 1
            Utils.marker({
                type = 29,
                position = markerCoords,
                color = Config.Server.color,
                size = vec3(1.4, 1.4, 1.4)
            })
            if dist <= 1.5 then
                markerVisible = false
                TriggerServerEvent("moneydrop:pickup", GetPlayerServerId(PlayerId()))
                RemoveBlip(blip)
                TriggerServerEvent("moneydrop:markerStatus", false)
            end
        end
        Wait(sleep)
    end
end);

RegisterNetEvent("moneydrop:markerStatus:client", function(status)
    markerVisible = status
    RemoveBlip(blip)
end);

-----------------------------------------------------------------------------
------------------------------------CARRY------------------------------------
-----------------------------------------------------------------------------

local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    personCarrying = {
        animDict = "missfinale_c2mcs_1",
        anim = "fin_c2_mcs_1_camman",
        flag = 49,
    },
    personCarried = {
        animDict = "nm",
        anim = "firemans_carry",
        attachX = 0.27,
        attachY = 0.15,
        attachZ = 0.63,
        flag = 33,
    }
}

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in next, (players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords - playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
    if closestDistance ~= -1 and closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end;

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    return animDict
end;

RegisterCommand("carry", function(source, args)
    local playerPed = PlayerPedId()

    if Config.PlayerData.group ~= "user" then
        if not carry.InProgress then
            local closestPlayer = GetClosestPlayer(3)
            if closestPlayer then
                local targetSrc = GetPlayerServerId(closestPlayer)
                if targetSrc ~= -1 then
                    carry.InProgress = true
                    carry.targetSrc = targetSrc
                    TriggerServerEvent("CarryPeople:sync", targetSrc)
                    ensureAnimDict(carry.personCarrying.animDict)
                    carry.type = "carrying"
                else
                    Config.HUD.Notify({
                        title = "Admin",
                        text = "Kein Spieler in der Nähe Gefunden!",
                        type = "error",
                        time = 2500
                    })
                end
            else
                Config.HUD.Notify({
                    title = "Admin",
                    text = "Kein Spieler in der Nähe Gefunden!",
                    type = "error",
                    time = 2500
                })
            end
        else
            if carry.type == "carrying" then
                carry.InProgress = false
                ClearPedSecondaryTask(playerPed)
                DetachEntity(playerPed, true, false)
                TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
                carry.targetSrc = -1
            else
                if Config.PlayerData.group ~= "user" then
                    carry.InProgress = false
                    ClearPedSecondaryTask(playerPed)
                    DetachEntity(playerPed, true, false)
                    TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
                    carry.targetSrc = -1
                else
                    Config.HUD.Notify({
                        title = "Admin",
                        text = "Du wirst getragen und kannst den Carry nicht beenden!",
                        type = "error",
                        time = 2500
                    })
                end
            end
        end
    else
        Config.HUD.Notify({
            title = "Admin",
            text = "Du hast keine Berechtigung, diesen Befehl zu verwenden!",
            type = "error",
            time = 2500
        })
    end
end, false);

RegisterNetEvent("CarryPeople:syncTarget", function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    carry.InProgress = true
    ensureAnimDict(carry.personCarried.animDict)
    AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY,
        carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
    carry.type = "beingcarried"
end);

RegisterNetEvent("CarryPeople:cl_stop", function()
    carry.InProgress = false
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    carry.type = ""
end);

CreateThread(function()
    while true do
        if carry.InProgress then
            if carry.type == "beingcarried" then
                if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
                    TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000,
                        carry.personCarried.flag, 0, false, false, false)
                end
            elseif carry.type == "carrying" then
                if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
                    TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0,
                        100000, carry.personCarrying.flag, 0, false, false, false)
                end
            end
        end
        Wait(500)
    end
end);

-----------------------------------------------------------------------------
------------------------------------CHAT-------------------------------------
-----------------------------------------------------------------------------

RegisterKeyMapping('chat', 'chat', 'keyboard', 'T')

RegisterCommand('chat', function()
    if Utils.CanOpenUI() then
        if IsNuiFocused() then return end
        Wait(100)
        SetNuiFocus(true, true)
        SendNUIMessage({ a = 'OpenChat' })
    end
end, false);

RegisterNuiCallback('chat', function(data, cb)
    SetNuiFocus(false, false)

    if data.message:sub(1, 1) ~= '/' then
        SendNUIMessage({
            action = "Notify",
            title = "Fehler",
            text = "Befehle müssen mit '/' beginnen.",
            type = "error",
            time = 7500,
        })
        cb("OK")
        return
    end

    ExecuteCommand(data.message:sub(2))
    cb("OK")
end);

-----------------------------------------------------------------------------
------------------------------------FUNK-------------------------------------
-----------------------------------------------------------------------------
RegisterKeyMapping("funkmenu_open_keybin", "Funk Menü", "keyboard", "F2")

RegisterCommand("funkmenu_open_keybin", function()
    if Utils.CanOpenUI() then
        Wait(100)
        SetNuiFocus(true, true)
        SendNUIMessage({
            a = "funk:toggle",
            settings = Config.Server.Settings.funk
        })
    end
end, false);

RegisterCommand("funkjoin", function(source, args, rawCommand)
    local channel = args[1]
    if channel then
        funk = true
        TriggerEvent("ali:channel", tonumber(channel))
        Config.HUD.Notify({
            title = 'Funk ',
            text = 'Du bist dem Funk ' .. channel .. ' Beigetreten !',
            time = 5000,
            type = 'success'
        })
    else
        Config.HUD.Notify({
            title = 'Funk ',
            text = 'Geben Sie einen Funkkanal ein, den Sie betreten möchten!',
            time = 5000,
            type = 'error'
        })
    end
end, false);

RegisterCommand("funkleave", function()
    TriggerEvent("ali:channel", 0)
    funk = false
    Config.HUD.Notify({
        title = 'Funk ',
        text = 'Du hast den Funk Verlassen !',
        time = 5000,
        type = 'error'
    })
end, false);

RegisterNuiCallback("funk", function(data)
    if data.type == "join" then
        ExecuteCommand("funkjoin " .. tonumber(data.input))

        Config.Server.Settings.funk.toggle = true
        Config.Server.Settings.funk.number = tonumber(data.input)
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    end

    if data.type == "leave" then
        ExecuteCommand("funkleave")

        Config.Server.Settings.funk.toggle = false
        Config.Server.Settings.funk.number = 0
        SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
    end

    ExecuteCommand("funkmenu_open_keybin")
end);

-----------------------------------------------------------------------------
----------------------------------KILLZONE-----------------------------------
-----------------------------------------------------------------------------

local canDrawZoneSphere = false

returnRandomKillzoneSpawn = function()
    if killzone.curZone and killzone.curZone.spawns then
        local spawns = killzone.curZone.spawns
        local randomIndex = math.random(1, #spawns)
        return spawns[randomIndex]
    end
    return nil
end;

RegisterNetEvent("killzone:UpdateTime", function(time)
    local minutes = math.floor(time / 60)
    local seconds = time % 60

    local minutesStr = (minutes < 10) and ("0" .. minutes) or tostring(minutes)
    local secondsStr = (seconds < 10) and ("0" .. seconds) or tostring(seconds)

    killzone.time = minutesStr .. ":" .. secondsStr
end);

RegisterNetEvent("killzone:open", function(config, time)
    if not killzone.toggle then
        killzone.toggle = true
        killzone.time = time
        killzone.curZone = config

        CreateThread(function()
            if canDrawZoneSphere then return end

            canDrawZoneSphere = true

            while canDrawZoneSphere do
                local sleep = 500
                if killzone.toggle and killzone.curZone and killzone.curZone.position then
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    local dist = #(coords - killzone.curZone.position)

                    if killzone.joined then
                        if dist < killzone.curZone.radius + 25.0 then
                            sleep = 1

                            local currentTime = GetGameTimer()
                            local r = math.floor(math.sin(currentTime / 4000) * 127 + 128)
                            local g = math.floor(math.sin(currentTime / 4000 + 2) * 127 + 128)
                            local b = math.floor(math.sin(currentTime / 4000 + 4) * 127 + 128)
                            DrawGlowSphere(killzone.curZone.position.x, killzone.curZone.position.y,
                                killzone.curZone.position.z, killzone.curZone.radius, r, g, b, 0.5, true, true)

                            if dist < killzone.curZone.radius and not killzone.inZone then
                                killzone.inZone = true
                                SetEntityInvincible(ped, false)
                                TriggerServerEvent("setDimension", Config.pvp.killzone.dimension.inZone)
                            elseif dist > killzone.curZone.radius and killzone.inZone then
                                killzone.inZone = false
                                SetEntityInvincible(ped, true)
                                TriggerServerEvent("setDimension", Config.pvp.killzone.dimension.entry)
                            end

                            for k, v in next, killzone.curZone.spawns do
                                local leaveDist = #(coords - vec3(v.x, v.y, v.z))

                                if leaveDist < 15.0 then
                                    Utils.marker({
                                        type = 0,
                                        position = vec3(v.x, v.y, v.z),
                                        size = vec3(0.5, 0.5, 0.5),
                                        color = Config.Server.color
                                    })

                                    if leaveDist < 2 then
                                        exports[GetCurrentResourceName()]:showE("Um die " ..
                                            killzone.curZone.name .. " zu Verlassen")
                                    end

                                    if IsControlJustReleased(0, 38) then
                                        ToggleCamMode(true)
                                        killzone.inZone = false
                                        killzone.joined = false
                                        SetEntityInvincible(ped, false)
                                        Wait(125)
                                        TriggerServerEvent("setDimension", 0)
                                        TriggerServerEvent("killzone:leave")
                                    end
                                end
                            end
                        end
                    end
                end
                Wait(sleep)
            end
        end);
    end
end);

RegisterNetEvent("killzone:close", function()
    if killzone.toggle then
        killzone.toggle = false
        killzone.curZone = nil
        killzone.points = 0
        killzone.inZone = false
        SetEntityInvincible(PlayerPedId(), false)
        TriggerServerEvent("setDimension", 0)

        if killzone.joined then
            killzone.joined = false
            ToggleCamMode(true)
        end
    end
end);

RegisterNetEvent("killzone:updatePoints", function(points)
    killzone.points = points
end);

CreateThread(function()
    while true do
        local sleep = 500
        if killzone.joined then
            sleep = 1
            Utils.BottomText("~r~Zeit Verbleibend:~w~ " ..
                killzone.time .. "\n~r~" .. killzone.points .. "~w~ Punkte")
        end
        Wait(sleep)
    end
end);

-----------------------------------------------------------------------------

-----------------------------------F6 MENÜ-----------------------------------

-----------------------------------------------------------------------------

function KleidungAnpassen()
    ESX.TriggerServerCallback('GetDressing', function(data)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'outfits_menu', {
            title    = 'KLEIDUNGS MENÜ',
            align    = 'top-left',
            elements = data,
        }, function(data, menu)
            selectClothing(data.current.label, data.current.skin)
        end, function(_, menu)
            menu.close()
        end);
    end);
end;

function selectClothing(label, _skin)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Outfit_menu', {
        title    = 'AUSWAHL',
        align    = 'top-left',
        elements = {
            { label = 'Anziehen', value = _skin },
            { label = 'Löschen' }
        },
    }, function(data, menu)
        if data.current.label == 'Anziehen' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, {
                    skin = data.current.value.skin,
                    arms = data.current.value.arms,
                    hair_1 = data.current.value.hair_1,
                    tshirt_1 = data.current.value.tshirt_1,
                    tshirt_2 = data.current.value.tshirt_2,
                    torso_1 = data.current.value.torso_1,
                    torso_2 = data.current.value.torso_2,
                    pants_1 = data.current.value.pants_1,
                    pants_2 = data.current.value.pants_2,
                    shoes_1 = data.current.value.shoes_1,
                    shoes_2 = data.current.value.shoes_2,
                    mask_1 = data.current.value.mask_1,
                    mask_2 = data.current.value.mask_2,
                    hair_color_1 = data.current.value.hair_color_1,
                    hair_color_2 = data.current.value.hair_color_2,
                    helmet_1 = data.current.value.helmet_1,
                    helmet_2 = data.current.value.helmet_2,
                    glasses_1 = data.current.value.glasses_1,
                    glasses_2 = data.current.value.glasses_2,
                    watches_1 = data.current.value.watches_1,
                    watches_2 = data.current.value.watches_2,
                    bags_1 = data.current.value.bags_1,
                    bags_2 = data.current.value.bags_2,
                    chain_1 = data.current.value.chain_1,
                    bproof_1 = data.current.value.bproof_1,
                    bproof_2 = data.current.value.bproof_2,
                    chain_2 = data.current.value.chain_2
                });
                TriggerEvent('skinchanger:getSkin', function(newSkin)
                    TriggerServerEvent('esx_skin:save', newSkin);
                end);
            end);
        else
            TriggerServerEvent('DeleteOutfit', label)
            ESX.UI.Menu.CloseAll()
            Wait(100)
            KleidungAnpassen()
        end
        menu.close()
    end, function(_, menu)
        menu.close()
    end);
end;

local KleidungChange = function()
    TriggerEvent('esx_skin:openSaveableMenu', function()
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_save', {
            title = 'NAME DES OUTFITS'
        }, function(mdata, menu)
            local name = mdata.value
            if name then
                TriggerEvent('skinchanger:getSkin', function(currentSkin)
                    TriggerServerEvent("SaveNewOutfit", name, currentSkin)
                end);
                menu.close()
            else
                Config.HUD.Notify({
                    title = "SYSTEM",
                    text = "Geben sie ein Namen ein.",
                    type = "error",
                    time = 5000
                })
            end
        end, function(mdata, menu)
            menu.close()
        end);
    end);
end;

function OpenF6Menu()
    local elements = {}

    table.insert(elements, { label = "Kleidung ändern", value = 'kleidung-change' })
    table.insert(elements, { label = "Kleidung anpassen", value = 'kleidung-anpassen' })

    if Config.PlayerData.job.name ~= "unemployed" then
        table.insert(elements, { label = "Fraktion", value = 'faction' })
    end


    if killzone.toggle or eventData.toggle and eventData.name then
        table.insert(elements, { label = "---------------" })
    end

    if killzone.toggle then
        table.insert(elements, { label = "KILLZONE", value = 'killzone-join' })
    end

    if eventData.toggle and eventData.name then
        table.insert(elements, { label = "EVENT: " .. eventData.name, value = 'event-join' })
    end

    if BWP then
        table.insert(elements, { label = "BWP: " .. BWP, value = 'bwpjoin' })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
        title    = 'USERMENU',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'kleidung-change' then
            KleidungChange()
        elseif data.current.value == 'kleidung-anpassen' then
            KleidungAnpassen()
        elseif data.current.value == 'bwpjoin' then
            ExecuteCommand("bwpjoin")
        elseif data.current.value == 'killzone-join' then
            if not killzone.joined then
                killzone.joined = true
                local spawn = returnRandomKillzoneSpawn()
                SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z)
                SetEntityHeading(PlayerPedId(), spawn[4])
                TriggerServerEvent("setDimension", Config.pvp.killzone.dimension.entry)
                TriggerServerEvent("killzone:join", GetPlayerServerId(PlayerId()))
                SetEntityInvincible(PlayerPedId(), true)
            end
        elseif data.current.value == 'event-join' then
            ExecuteCommand("event")
        elseif data.current.value == 'faction' then
            ESX.TriggerServerCallback('factionmenu:get', function(data)
                factionMenuESX(data, Config.PlayerData.job)
            end);
        end
    end, function(data, menu)
        menu.close()
    end);
end;

RegisterKeyMapping("f6", "Kleidungs Menü", "keyboard", "F6");

RegisterCommand("f6", function()
    if Utils.CanOpenUI() then
        OpenF6Menu()
    end
end, false);

-----------------------------------------------------------------------------
-------------------------------FACTION SYSTEM--------------------------------
-----------------------------------------------------------------------------

local factionClothingIndices = {}

openCareatorMenu = function()
    SendNUIMessage({
        a = "faction:creator:open",
        factions = Config.factions.table
    })
    Wait(100)
    SetNuiFocus(true, true)
end;

spawnVehicle = function(spawn, name)
    ESX.Game.DeleteVehicle(lastVehicle)
    SetEntityCoords(PlayerPedId(), spawn.x, spawn.y,
        spawn.z, true, false, false, false)
    Wait(100)
    ESX.Game.SpawnVehicle(name, spawn, spawn[4],
        function(spawnedVehicle)
            SetVehicleEngineOn(spawnedVehicle, true, true)
            SetVehRadioStation(spawnedVehicle, "OFF")
            TaskWarpPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)
            lastVehicle = spawnedVehicle
        end);
end;

openGarage = function(spawn)
    local elements = {}

    for k, v in next, Config.pvp.gangwar.vehicles do
        table.insert(elements, { label = v.label, name = v.name })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
        title    = 'Gangwar Garage',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        spawnVehicle(spawn, data.current.name)
        menu.close()
    end, function(data, menu)
        menu.close()
    end);
end;

openFactionMenu = function()
    ESX.TriggerServerCallback('factionmenu:get', function(data)
        SendNUIMessage({
            a = "factionmenu:open",
            data = data
        })
        Wait(100)
        SetNuiFocus(true, true)
    end);
end;


factionMenuESX = function(factionData, job)
    local elements = {}

    table.insert(elements, { label = "Menü", value = 'menu' })
    table.insert(elements, { label = "Kleidung", value = 'clothes' })

    if job.grade_name == "boss" then
        table.insert(elements, { label = "Invite Geben", value = 'invite' })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
        title    = 'FRAKTION',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'menu' then
            openFactionMenu(factionData)
        elseif data.current.value == 'clothes' then
            openFactionClothing(factionData.dressing)
        elseif data.current.value == 'invite' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3 then
                ExecuteCommand("invite " .. GetPlayerServerId(closestPlayer) .. "")
            end
        end
    end, function(data, menu)
        menu.close()
        OpenF6Menu()
    end);
end;

function openFactionClothing(dressing)
    local elements = {}

    if Config.PlayerData.job.grade_name == "boss" then
        table.insert(elements, { label = "+ Erstellen", value = 'create' })
    end

    if dressing and #dressing > 0 then
        for i = 1, #dressing, 1 do
            if factionClothingIndices[i] == nil then
                factionClothingIndices[i] = 1
            end

            if Config.PlayerData.job.grade_name ~= "boss" then
                table.insert(elements, { label = dressing[i], value = 'anziehen', number = i })
            end

            if Config.PlayerData.job.grade_name == "boss" then
                table.insert(elements, { label = dressing[i], value = 'anziehen-boss', number = i })
            end
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
        title    = 'KLEIDUNG',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'create' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_save', {
                title = 'NAME DES OUTFITS'
            }, function(mdata, menu)
                local outfit = mdata.value
                if outfit then
                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerServerEvent("ali_fraksystem:saveKleidung", Config.PlayerData.job.name, outfit, skin)
                    end);
                    menu.close()
                    Wait(50)
                    ESX.TriggerServerCallback('factionmenu:getClothing', function(factionData)
                        openFactionClothing(factionData)
                    end);
                else
                    Config.HUD.Notify({
                        title = "SYSTEM",
                        text = "Geben sie ein Namen ein.",
                        type = "error",
                        time = 5000
                    })
                end
            end, function(mdata, menu)
                menu.close()
            end);
        elseif data.current.value == "anziehen" then
            TriggerEvent("skinchanger:getSkin", function(skin)
                ESX.TriggerServerCallback("ali_fraksystem:getPlayerOutfit", function(clothes)
                    TriggerEvent("skinchanger:loadClothes", skin, clothes)
                    TriggerEvent("esx_skin:setLastSkin", skin)
                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerServerEvent("esx_skin:save", skin)
                        TriggerServerEvent('RestoreLoadout')
                    end);
                    Config.HUD.Notify({
                        title = 'FRAKTION ',
                        text = 'Du hast erfolgreich dein Fraktions Outfit angezogen!',
                        time = 5000,
                        type = 'success'
                    })
                end, data.current.number, Config.PlayerData.job.name)
            end);
        elseif data.current.value == "anziehen-boss" then
            openFactionClothingEditor(data.current.number)
        end
    end, function(data, menu)
        ESX.TriggerServerCallback('factionmenu:get', function(data)
            factionMenuESX(data, Config.PlayerData.job)
        end);
    end);
end;

function openFactionClothingEditor(number)
    local elements = {}

    table.insert(elements, { label = "Anziehen", value = 'anziehen' })
    table.insert(elements, { label = "Löschen", value = 'delete' })
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
        title    = 'USERMENU',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'anziehen' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                ESX.TriggerServerCallback("ali_fraksystem:getPlayerOutfit", function(clothes)
                    TriggerEvent("skinchanger:loadClothes", skin, clothes)
                    TriggerEvent("esx_skin:setLastSkin", skin)
                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerServerEvent("esx_skin:save", skin)
                        TriggerServerEvent('RestoreLoadout')
                    end);
                    Config.HUD.Notify({
                        title = 'FRAKTION ',
                        text = 'Du hast erfolgreich dein Fraktions Outfit angezogen!',
                        time = 5000,
                        type = 'success'
                    })
                end, number, Config.PlayerData.job.name)
                Wait(50)
                ESX.TriggerServerCallback('factionmenu:getClothing', function(factionData)
                    openFactionClothing(factionData)
                end);
            end);
        elseif data.current.value == 'delete' then
            TriggerServerEvent("ali_fraksystem:deleteOutfit", number, Config.PlayerData.job.name)
            Wait(50)
            ESX.TriggerServerCallback('factionmenu:getClothing', function(factionData)
                openFactionClothing(factionData)
            end);
        end
    end, function(data, menu)
        Wait(50)
        ESX.TriggerServerCallback('factionmenu:getClothing', function(factionData)
            openFactionClothing(factionData)
        end);
    end);
end;

updateFactions = function(data)
    local newFactions = data
    Config.factions.table = data

    for name, blipData in next, (existingBlips) do
        if not newFactions[name] then
            RemoveBlip(blipData.blip)
            existingBlips[name] = nil
        end
    end

    for k1, v1 in next, Config.factions.table do
        Config.factions.fractions[v1.name] = v1

        local blip = AddBlipForCoord(v1.positions.respawn.x, v1.positions.respawn.y, v1.positions.respawn.z)
        SetBlipSprite(blip, 475)
        SetBlipScale(blip, 1.1)
        SetBlipColour(blip, v1.blipcolor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v1.label)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, true)
        existingBlips[v1.name] = { blip = blip, colour = v1.blipcolor }
    end
end;

RegisterKeyMapping("factionmenu", "Fraktionsmenü öffnen", "keyboard", "F5")

RegisterCommand("factionmenu", function()
    if Config.PlayerData.job.name ~= "unemployed" and Utils.CanOpenUI() then
        openFactionMenu()
    end
end, false);

RegisterNuiCallback("OpenFactionlist", function()
    ExecuteCommand("factionlist")
end)

RegisterCommand("factionlist", function()
    ESX.TriggerServerCallback("factionList", function(data)
        SendNUIMessage({
            a = "factionlist-append",
            data = data
        })

        SetNuiFocus(true, true)
    end)
end, false)

RegisterCommand("creator", function()
    if Config.PlayerData.frak then
        openCareatorMenu()
    end
end, false);

RegisterCommand('tc', function(source, args, group)
    TriggerServerEvent('teamchat:server', table.concat(args, " "))
end, false);

CreateThread(function()
    Wait(3000)
    repeat
        Wait(100)
    until ESX.IsPlayerLoaded()

    CreateThread(function()
        while true do
            local sleep = 500

            for k, v in next, Config.factions.table do
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local currentFaction = Config.PlayerData.job.name

                if Config.PlayerData.job.name ~= "unemployed" and v.name == currentFaction then
                    local dists = {
                        respawn = #(coords - vec3(v.positions.respawn.x, v.positions.respawn.y, v.positions.respawn.z)),
                        tpToHood = #(coords - vec3(-2249.8572, 3215.5715, 32.8102)),
                    }

                    if dists.tpToHood < 15 then
                        sleep = 1
                        Utils.marker({
                            type = 30,
                            position = vec3(-2249.8572, 3215.5715, 32.8102),
                            size = vec3(0.9, 0.9, 0.9),
                            color = { r = v.color.r, g = v.color.g, b = v.color.b }
                        })

                        if dists.tpToHood < 2 then
                            exports[GetCurrentResourceName()]:showE('HOOD TELEPORT')
                        end

                        if dists.tpToHood < 2 and IsControlJustPressed(0, 38) then
                            SetEntityCoords(PlayerPedId(),
                                vec3(v.positions.respawn.x, v.positions.respawn.y, v.positions.respawn.z))
                        end
                    end

                    if dists.respawn < 10 then
                        sleep = 1
                        Utils.marker({
                            type = 36,
                            position = vec3(v.positions.respawn.x,
                                v.positions.respawn.y,
                                v.positions.respawn.z),
                            size = vec3(0.9, 0.9, 0.9),
                            color = Config.factions.fractions[currentFaction].color
                        })

                        if dists.respawn < 2 then
                            exports[GetCurrentResourceName()]:showE('FRAKTIONS GARAGE')
                        end

                        if dists.respawn < 1.3 and IsControlJustPressed(0, 38) then
                            SendNUIMessage({
                                a = "openGarage",
                                vehicles = Config.pvp.gangwar.vehicles
                            })
                            Wait(100)
                            SetNuiFocus(true, true)
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end);
end);

-- NUI CALLBACKS
RegisterNuiCallback("chatSendMessage", function(message)
    TriggerServerEvent("chat:send", message)
end);

RegisterNuiCallback("uprank", function(identifier)
    TriggerServerEvent("faction:uprank", identifier)
    Wait(250)
    openFactionMenu()
end);

RegisterNuiCallback("derank", function(identifier)
    TriggerServerEvent("faction:derank", identifier)
    Wait(250)
    openFactionMenu()
end);

RegisterNuiCallback("kick", function(identifier)
    TriggerServerEvent("faction:kick", identifier)
    Wait(250)
    openFactionMenu()
end);

RegisterNuiCallback("faction:clearGW", function()
    TriggerServerEvent("gw:clear")
end);

RegisterNuiCallback("parkOut", function(name)
    local currentFaction = Config.PlayerData.job.name
    local parkout = Config.factions.fractions[currentFaction].positions.garage_parkout

    ESX.Game.SpawnVehicle(name, vec3(parkout.x, parkout.y, parkout.z), parkout.heading, function(veh)
        SetVehicleNumberPlateText(veh, Config.PlayerData.job.label)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleEngineOn(veh, true, true)

        Utils.TuneVehicle(veh)

        Wait(500)
        SetVehicleCustomPrimaryColour(veh, Config.factions.fractions[currentFaction].color.r,
            Config.factions.fractions[currentFaction].color.g, Config.factions.fractions[currentFaction].color.b)
        SetVehicleCustomSecondaryColour(veh, Config.factions.fractions[currentFaction].color.r,
            Config.factions.fractions[currentFaction].color.g, Config.factions.fractions[currentFaction].color.b)
    end);
end);

RegisterNuiCallback("setNewTint", function(data)
    TriggerServerEvent("setNewTint", data.tint, data.weapon)
end);

RegisterNuiCallback("getCurrentCoords", function(data)
    local coords = GetEntityCoords(PlayerPedId())
    local message = {
        a = "InputCoords",
        type = data.type,
        input = data.input
    }

    if data.type == "vec3" then
        message.coords = " " .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. " "
    elseif data.type == "vec4" then
        local heading = GetEntityHeading(PlayerPedId())
        message.coords = " " .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ", " .. heading .. " "
    end

    SendNUIMessage(message)
end);

RegisterNuiCallback("faction:create", function(data)
    TriggerServerEvent("faction:create", data)
end);

RegisterNuiCallback("acceptInvite", function()
    if invites.toggle then
        if invites.faction and invites.id then
            TriggerServerEvent("faction:invite:accept", invites.id, invites.faction)
        end

        invites.toggle = false
        invites.id = nil
        invites.faction = nil
    end
end);

RegisterNuiCallback("denyInvite", function()
    if invites.toggle then
        if invites.faction and invites.id then
            TriggerServerEvent("faction:invite:deny", invites.id, invites.faction)
        end

        invites.toggle = false
        invites.id = nil
        invites.faction = nil
    end
end);

RegisterNuiCallback("faction:delete", function(name)
    TriggerServerEvent("faction:delete", name)
end);

RegisterNuiCallback("faction:kickall", function(name)
    TriggerServerEvent("faction:kickall", name)
end);

RegisterNuiCallback("joinBWP", function()
    ExecuteCommand("bwpjoin")
end);

-- EVENTS
RegisterNetEvent("faction:reloadMenu", function()
    openCareatorMenu()
end);

RegisterNetEvent("chat:receiveMessage", function(author, message)
    SendNUIMessage({
        a = "chat:receiveMessage",
        author = author,
        message = message
    })
end);

RegisterNetEvent("chat:receiveMessage:you", function(author, message)
    SendNUIMessage({
        a = "chat:receiveMessage:you",
        author = author,
        message = message
    })
end);

RegisterNetEvent("factions:update", function(table)
    updateFactions(table)
end);

RegisterNetEvent("faction:invite", function(id, name, faction)
    invites.toggle = true
    invites.id = id
    invites.faction = faction
    SetNuiFocus(true, true)
    SendNUIMessage {
        a = "faction:invite",
        name = name,
        faction = faction
    }
end);

RegisterNetEvent("bwp:open", function(faction)
    BWP = faction
end);

RegisterNetEvent("bwp:close", function()
    BWP = nil
end);

RegisterCommand("bwpjoin", function()
    if BWP then
        SetEntityCoords(PlayerPedId(),
            vec3(Config.factions.fractions[BWP].positions.respawn.x, Config.factions.fractions[BWP].positions.respawn.y,
                Config.factions.fractions[BWP].positions.respawn.z))
    end
end, false);

-----------------------------------------------------------------------------

----------------------------------GANGWAR------------------------------------

-----------------------------------------------------------------------------

RefreshBlips = function()
    if not Jobs or not next(Jobs) then
        Jobs = Config.factions.table;
    end

    for _, blip in next, (Blips) do
        RemoveBlip(blip);
    end

    Blips = {};

    for _, zone in next, (Config.pvp.gangwar.Zones) do
        local blip = AddBlipForCoord(zone.center.x, zone.center.y, zone.center.z);
        SetBlipSprite(blip, 630);
        SetBlipScale(blip, 0.9);
        if Owners[zone.name] and Config.factions.fractions[Owners[zone.name]] then
            SetBlipColour(blip,
                Config.factions.fractions[Owners[zone.name]] and Config.factions.fractions[Owners[zone.name]].blipcolor or
                0);
        else
            SetBlipColour(blip, 0);
        end
        SetBlipAsShortRange(blip, true);
        BeginTextCommandSetBlipName('STRING');
        AddTextComponentString(zone.name ..
            (Config.factions.fractions[Owners[zone.name]] and ' | ' .. Config.factions.fractions[Owners[zone.name]].label or ''));
        EndTextCommandSetBlipName(blip);
        Blips[#Blips + 1] = blip;
    end
end;

ToggleWeapons = function(weapons, bool)
    for _, weapon in next, (weapons) do
        SetCanPedEquipWeapon(PlayerPedId(), joaat(weapon), bool);
    end
end;

CheckForActiveAttack = function()
    if Config.PlayerData and not Config.PlayerData.job then
        repeat
            Wait(100);
        until (Config.PlayerData.job and Config.PlayerData.job.name)
    end

    if CurrentAttack then
        return;
    end

    local zone = Config.pvp.gangwar.IsJobInAttack(Config.PlayerData.job.name);

    if not zone then
        return;
    end

    CurrentAttack = Attacks[zone];

    local color = Config.factions.fractions[Config.PlayerData.job.name] and
        Config.factions.fractions[Config.PlayerData.job.name].color or { r = 255, g = 255, b = 255 };
    local startJob = Config.PlayerData.job;

    while Attacks[zone] and CurrentAttack and Config.PlayerData.job.name == startJob.name do
        local sleep = 1000;

        if Config.PlayerData.isIn then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false);
            local isNotInVeh = veh == 0;

            ToggleWeapons(Config.pvp.gangwar.Blacklist.Weapons.vehicle, isNotInVeh);
            ToggleWeapons(Config.pvp.gangwar.Blacklist.Weapons.normal, false);

            if not isNotInVeh and GetVehicleNumberPlateText(veh) ~= Config.PlayerData.job.name then
                SetVehicleNumberPlateText(veh, Config.PlayerData.job.name);
                SetVehicleCustomPrimaryColour(veh, color.r, color.g, color.b);
                SetVehicleCustomSecondaryColour(veh, color.r, color.g, color.b);
                SetVehicleNumberPlateText(veh, Config.PlayerData.job.name);
                SetVehicleNumberPlateTextIndex(veh, 1);
            end
        end

        Wait(sleep);
    end
end;

RegisterCommand("joingw", function()
    if Utils.CanDoStuff() then
        TriggerServerEvent('gangwar:JoinAttack');
    end
end, false);

CreateThread(function()
    Wait(5000)
    repeat
        Wait(100);
    until ESX.IsPlayerLoaded() and Config.PlayerData.job

    Wait(1000);

    local dataPromise = promise.new();

    ESX.TriggerServerCallback('gangwar:GetData', function(data)
        Owners = data.owners;
        Attacks = data.attacks;
        RefreshBlips();
        dataPromise:resolve();
    end);

    Citizen.Await(dataPromise);

    while true do
        local sleep = 1000;

        if Config.pvp.gangwar.Blacklist.Jobs[Config.PlayerData.job.name] or Config.PlayerData.job.grade < Config.pvp.gangwar.Permissions.start then
            goto continue;
        end

        for zoneIndex, zone in next, (Config.pvp.gangwar.Zones) do
            if Owners[zone.name] ~= Config.PlayerData.job.name then
                local dist = #(GetEntityCoords(PlayerPedId()) - zone.center);

                if dist < 10 then
                    sleep = 0;
                    local color = Config.factions.fractions[Owners[zone.name]] and
                        Config.factions.fractions[Owners[zone.name]].color or
                        { r = 255, g = 255, b = 255 };

                    DrawMarker(4, zone.center.x, zone.center.y, zone.center.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0,
                        color.r, color.g, color.b, 100, false, true, 2, false, false, false, false);

                    if dist < 2 then
                        exports[GetCurrentResourceName()]:showE('GANGWAR ANGREIFEN')
                    end

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('gangwar:StartAttack', zoneIndex, zone);
                    end
                end
            end
        end

        ::continue::

        Wait(sleep);
    end
end);

CreateThread(function()
    Wait(2500)
    while true do
        local sleep = 500
        if Config.PlayerData.isIn then
            sleep = 0
            Utils.BottomText("Kills: ~r~" .. playerKills .. "~w~ Tode: ~r~" .. playerDeaths)
        end
        Wait(sleep)
    end
end);

exports('GetActiveGangwar', function()
    return CurrentAttack;
end);

exports('GetInGangwar', function()
    return Config.PlayerData.isIn;
end);

RegisterNetEvent('esx:setJob', function(job)
    Config.PlayerData.job = job

    CurrentAttack = false;
    CheckForActiveAttack();

    if Config.PlayerData.job.name ~= "unemployed" then
        Playerjob = Config.PlayerData.job.label .. " - " .. Config.PlayerData.job.grade_label
    else
        Playerjob = "Keine Fraktion"
    end

    SendNUIMessage({
        a = "hud:updateJob",
        job = Playerjob
    })
end);

RegisterNetEvent('gangwar:UpdateOwners', function(owners)
    Owners = owners;
    RefreshBlips();
end);

RegisterNetEvent('gangwar:UpdateScore', function(zone, side, points)
    if Config.PlayerData.isIn then
        if Attacks and Attacks[zone][side] then
            Attacks[zone][side].points = points;

            if Config.PlayerData.isIn and Config.PlayerData.curZone == zone then
                SendNUIMessage({
                    a = "updateGW",
                    data = {
                        att = Attacks[zone].attacker.label,
                        def = Attacks[zone].defender.label,
                        defpoints = Attacks[zone].defender.points,
                        attpoints = Attacks[zone].attacker.points
                    }
                });
            end
        end
    end
end);

RegisterNetEvent('gangwar:JoinedGangwar', function()
    if not Config.PlayerData.job then
        return
    end

    if not CurrentAttack then
        return;
    end

    Config.PlayerData.isIn = true;
    Config.PlayerData.curZone = CurrentAttack.zone.name;
    local attack = CurrentAttack;
    local startJob = Config.PlayerData.job;
    Config.PlayerData.side = Config.pvp.gangwar.GetSide(attack.attacker.name, Config.PlayerData.job.name);
    local zone = attack.zone;
    local jobColor = Config.factions.fractions[Config.PlayerData.job.name] and
        Config.factions.fractions[Config.PlayerData.job.name].color or
        { r = 255, g = 255, b = 255 };
    local garage = zone[Config.PlayerData.side].spawn;
    local pos = GetEntityCoords(PlayerPedId())

    SendNUIMessage({
        a = "updateGW",
        data = {
            att = attack.attacker.label,
            def = attack.defender.label,
            defpoints = attack.defender.points,
            attpoints = attack.attacker.points,
        }
    });

    ToggleWeapons(Config.pvp.gangwar.Blacklist.Weapons.normal, false);
    NetworkSetFriendlyFireOption(true);

    while Attacks[attack.zone.name] and startJob.name == Config.PlayerData.job.name and Config.PlayerData.isIn do
        Wait(0);
        DrawGlowSphere(zone.center.x, zone.center.y, zone.center.z, zone.radius.x, jobColor.r, jobColor.g, jobColor.b,
            0.25,
            true, true)
        if zone then
            local distance = #(GetEntityCoords(PlayerPedId()) - vec3(zone.center.x, zone.center.y, zone.center.z))
            if distance <= zone.scale then
                if not Config.PlayerData.isInZone then
                    Config.PlayerData.isInZone = true
                    TriggerServerEvent("setDimension", 1)
                end
            elseif Config.PlayerData.isInZone then
                Config.PlayerData.isInZone = false
                TriggerServerEvent("setDimension", 0)
            end
        end

        local garageDist = #(GetEntityCoords(PlayerPedId()) - garage);

        if garageDist < 10 then
            DrawMarker(36, garage.x, garage.y, garage.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0,
                jobColor.r, jobColor.g, jobColor.b, 100, false, false, 2, false, false, false, false);

            if garageDist < 2 then
                exports[GetCurrentResourceName()]:showE('GANGWAR GARAGE')
            end

            if garageDist < 1.3 and IsControlJustPressed(0, 38) then
                openGarage(zone[Config.PlayerData.side].vehicleSpawn)
            end
        end
    end
end);

RegisterNetEvent('gangwar:LeftGangwar', function(doNotReset)
    if doNotReset == nil then
        CurrentAttack = false;

        Config.PlayerData.wasIn = Config.PlayerData.isIn;
        Config.PlayerData.lastZone = Config.PlayerData.curZone;

        Config.PlayerData.curZone = '';
        Config.PlayerData.side = 'attacker';
    end

    Config.PlayerData.isIn = false;
    Config.PlayerData.isInZone = false

    SendNUIMessage({
        a = "ToggleScore",
        data = false
    });

    TriggerServerEvent("setDimension", 0)
    ToggleWeapons(Config.pvp.gangwar.Blacklist.Weapons.normal, true);

    local factionSpawn = Config.factions.fractions[Config.PlayerData.job.name].positions.respawn;
    SetEntityCoords(PlayerPedId(), factionSpawn.x, factionSpawn.y, factionSpawn.z, false, false, false, false)
end);

RegisterNetEvent('gangwar:ShowScoreboard', function(zone, scoreBoard)
    if Config.PlayerData.wasIn and Config.PlayerData.lastZone == zone then
        Wait(100)
        SetNuiFocus(true, true);
        SendNUIMessage({
            a = "OpenScoreboard",
            data = scoreBoard
        });
        TriggerServerEvent("setDimension", 0)
    end
end);

RegisterNetEvent('gangwar:UpdateAttacks', function(zoneName, attack)
    Attacks[zoneName] = attack;
    CheckForActiveAttack();
end);

RegisterNetEvent('gangwar:UpdateAllAttacks', function(attacks)
    Attacks = attacks;
    CheckForActiveAttack();
end);

RegisterNetEvent('gangwar:ShowFirework', function(zone, pos)
    if Config.PlayerData.isIn and Config.PlayerData.curZone == zone then
        local dict = 'scr_indep_fireworks';

        if not HasNamedPtfxAssetLoaded(dict) then
            RequestNamedPtfxAsset(dict);
            repeat
                Wait(0);
            until HasNamedPtfxAssetLoaded(dict)
        end

        UseParticleFxAssetNextCall(dict);
        StartNetworkedParticleFxNonLoopedAtCoord('scr_indep_firework_starburst', pos.x, pos.y, pos.z, 0.0, 0.0, 0.0,
            2.5, false, false, false);
    end
end);

RegisterNetEvent("ReviveGW", function(spawn)
    Wait(3000)
    removeDeathScreen()

    Respawn(spawn, true)

    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)

    Utils.setWeapon(lastWeapon)
    CreateThread(Utils.SpawnProtection)
end);

RegisterNetEvent("gangwar:updateStats", function(kills, deaths)
    playerKills = kills or 0
    playerDeaths = deaths or 0
    NetworkSetFriendlyFireOption(true);
end);

RegisterNetEvent('gangwar:UpdateTime', function(zoneName, time)
    if CurrentAttack and CurrentAttack.zone.name == zoneName then
        SendNUIMessage({
            a = "SetTime",
            data = { time = time }
        });
    end
end);

-----------------------------------------------------------------------------

--------------------------------LUCKY WHEEL----------------------------------

-----------------------------------------------------------------------------

local _wheel, _base, _lights1, _lights2, _arrow1, _arrow2 = nil, nil, nil, nil, nil, nil
local model1 = GetHashKey('vw_prop_vw_luckywheel_02a')
local model2 = GetHashKey('vw_prop_vw_luckywheel_01a')
local m1a = GetHashKey('vw_prop_vw_luckylight_off')
local m1b = GetHashKey('vw_prop_vw_luckylight_on')
local m2a = GetHashKey('vw_prop_vw_jackpot_off')
local m2b = GetHashKey('vw_prop_vw_jackpot_on')
local WheelPos = vec4(-2275.5845, 3223.6245, 32.0, 106.7244)
local _isRolling = false

CreateThread(function()
    while true do
        local sleep = 1500
        if (#(GetEntityCoords(PlayerPedId()) - vec3(WheelPos.x, WheelPos.y, WheelPos.z)) < 1.7) and not _isRolling then
            exports[GetCurrentResourceName()]:showE("GLÜCKSRAD DREHEN")

            sleep = 1
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('getItemCount', function() end, "token")
            end
        end
        Wait(sleep)
    end
end);

CreateThread(function()
    RequestScriptAudioBank('DLC_VINEWOOD\\CASINO_GENERAL', false)
    CreateThread(function()
        for index, model in next, ({ model1, model2, m1a, m1b, m2a, m2b }) do
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
        end
        ClearArea(WheelPos.x, WheelPos.y, WheelPos.z, 5.0, true, false, false, false)
        _wheel = CreateObject(model1, WheelPos.x, WheelPos.y, WheelPos.z, false, false, true)
        SetEntityHeading(_wheel, WheelPos.w)
        SetModelAsNoLongerNeeded(model1)
        _base = CreateObject(model2, WheelPos.x, WheelPos.y, WheelPos.z - 0.26, false, false, true)
        SetEntityHeading(_base, WheelPos.w)
        SetModelAsNoLongerNeeded(_base)
        _lights1 = CreateObject(m1a, WheelPos.x, WheelPos.y, WheelPos.z + 0.35, false, false, true)
        SetEntityHeading(_lights1, WheelPos.w)
        SetModelAsNoLongerNeeded(_lights1)
        _lights2 = CreateObject(m1b, WheelPos.x, WheelPos.y, WheelPos.z + 0.35, false, false, true)
        SetEntityVisible(_lights2, false, 0)
        SetEntityHeading(_lights2, WheelPos.w)
        SetModelAsNoLongerNeeded(_lights2)
        _arrow1 = CreateObject(m2a, WheelPos.x, WheelPos.y, WheelPos.z + 2.5, false, false, true)
        SetEntityHeading(_arrow1, WheelPos.w)
        SetModelAsNoLongerNeeded(_arrow1)
        _arrow2 = CreateObject(m2b, WheelPos.x, WheelPos.y, WheelPos.z + 2.5, false, false, true)
        SetEntityVisible(_arrow2, false, 0)
        SetEntityHeading(_arrow2, WheelPos.w)
        SetModelAsNoLongerNeeded(_arrow2)
        h = GetEntityRotation(_wheel)
    end);
end);

RegisterNetEvent('wheel:roll_Animation', function()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        ensureAnimDict(lib)
        local _movePos = GetObjectOffsetFromCoords(GetEntityCoords(_base), GetEntityHeading(_base), -0.9, -0.8, -1.0)
        TaskGoStraightToCoord(playerPed, _movePos.x, _movePos.y, _movePos.z, 1.0, 3000, GetEntityHeading(_base), 0.0)
        local _isMoved = false
        while not _isMoved do
            local coords = GetEntityCoords(PlayerPedId())
            if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                _isMoved = true
            end
            Wait(0)
        end
        SetEntityHeading(playerPed, GetEntityHeading(_base))
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
            Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 3) do
            Wait(0)
            DisableAllControlActions(0)
        end
    end
end);

RegisterNetEvent('wheel:selectWin', function(s, p)
    Wait(1000)
    SetEntityVisible(_lights1, false, 0)
    SetEntityVisible(_lights2, true, 0)
    local j = 360
    if s == GetPlayerServerId(PlayerId()) then
        PlaySoundFromEntity(-1, 'Spin_Start', _wheel, 'dlc_vw_casino_lucky_wheel_sounds', 1, 1)
    end
    for i = 1, 1100, 1 do
        SetEntityRotation(_wheel, h.x, j + 0.0, h.z, 0, false)
        if i < 50 then
            j = j - 1.5
        elseif i < 100 then
            j = j - 2.0
        elseif i < 150 then
            j = j - 2.5
        elseif i > 1060 then
            j = j - 0.3
        elseif i > 1030 then
            j = j - 0.6
        elseif i > 1000 then
            j = j - 0.9
        elseif i > 970 then
            j = j - 1.2
        elseif i > 940 then
            j = j - 1.5
        elseif i > 910 then
            j = j - 1.8
        elseif i > 880 then
            j = j - 2.1
        elseif i > 850 then
            j = j - 2.4
        elseif i > 820 then
            j = j - 2.7
        else
            j = j - 3.0
        end
        if i == 850 then j = 360 end
        if j > 360 then j = j + 0 end
        if j < 0 then j = j + 360 end
        Wait(0)
    end
    Wait(300)
    SetEntityVisible(_arrow1, false, 0)
    SetEntityVisible(_arrow2, true, 0)
    local t = true
    for i = 1, 15, 1 do
        Wait(200)
        SetEntityVisible(_lights1, t, 0)
        SetEntityVisible(_arrow2, t, 0)
        t = not t
        SetEntityVisible(_lights2, t, 0)
        SetEntityVisible(_arrow1, t, 0)
        if i == 5 then
            if s == GetPlayerServerId(PlayerId()) then
                TriggerServerEvent('wheel:giveWin')
            end
        end
    end
    Wait(1000)
    SetEntityVisible(_lights1, true, 0)
    SetEntityVisible(_lights2, false, 0)
    SetEntityVisible(_arrow1, true, 0)
    SetEntityVisible(_arrow2, false, 0)
    TriggerServerEvent('wheel:activeRolling_sv')
end);

RegisterNetEvent('wheel:accecAllToRoll', function()
    _isRolling = false
end);

-----------------------------------------------------------------------------

------------------------------------PEDS-------------------------------------

-----------------------------------------------------------------------------

local function SetOrClearPedProp(ped, propIndex, drawableId, textureId)
    if drawableId == -1 then
        ClearPedProp(ped, propIndex)
    else
        SetPedPropIndex(ped, propIndex, drawableId, textureId, true)
    end
end

local function Skin(playerPed, skin)
    if skin ~= nil then
        local character = skin
        SetPedHeadBlendData(playerPed, character['face'], character['face'], character['face'], character['skin'],
            character['skin'], character['skin'], 1.0, 1.0, 1.0, true)
        SetPedHairColor(playerPed, character['hair_color_1'], character['hair_color_2'])
        SetPedHeadOverlay(playerPed, 3, character['age_1'], (character['age_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 0, character['blemishes_1'], (character['blemishes_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 1, character['beard_1'], (character['beard_2'] / 10) + 0.0)
        SetPedEyeColor(playerPed, character['eye_color'], 0, 1)
        SetPedHeadOverlay(playerPed, 2, character['eyebrows_1'], (character['eyebrows_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 4, character['makeup_1'], (character['makeup_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 8, character['lipstick_1'], (character['lipstick_2'] / 10) + 0.0)
        SetPedComponentVariation(playerPed, 2, character['hair_1'], character['hair_2'], 2)
        SetPedHeadOverlayColor(playerPed, 1, 1, character['beard_3'], character['beard_4'])
        SetPedHeadOverlayColor(playerPed, 2, 1, character['eyebrows_3'], character['eyebrows_4'])
        SetPedHeadOverlayColor(playerPed, 4, 1, character['makeup_3'], character['makeup_4'])
        SetPedHeadOverlayColor(playerPed, 8, 1, character['lipstick_3'], character['lipstick_4'])
        SetPedHeadOverlay(playerPed, 5, character['blush_1'], (character['blush_2'] / 10) + 0.0)
        SetPedHeadOverlayColor(playerPed, 5, 2, character['blush_3'])
        SetPedHeadOverlay(playerPed, 6, character['complexion_1'], (character['complexion_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 7, character['sun_1'], (character['sun_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 9, character['moles_1'], (character['moles_2'] / 10) + 0.0)
        SetPedHeadOverlay(playerPed, 10, character['chest_1'], (character['chest_2'] / 10) + 0.0)
        SetPedHeadOverlayColor(playerPed, 10, 1, character['chest_3'])
        SetPedHeadOverlay(playerPed, 11, character['bodyb_1'], (character['bodyb_2'] / 10) + 0.0)

        SetOrClearPedProp(playerPed, 2, character['ears_1'], character['ears_2'])
        SetPedComponentVariation(playerPed, 8, character['tshirt_1'], character['tshirt_2'], 2)
        SetPedComponentVariation(playerPed, 11, character['torso_1'], character['torso_2'], 2)
        SetPedComponentVariation(playerPed, 3, character['arms'], character['arms_2'], 2)
        SetPedComponentVariation(playerPed, 10, character['decals_1'], character['decals_2'], 2)
        SetPedComponentVariation(playerPed, 4, character['pants_1'], character['pants_2'], 2)
        SetPedComponentVariation(playerPed, 6, character['shoes_1'], character['shoes_2'], 2)
        SetPedComponentVariation(playerPed, 1, character['mask_1'], character['mask_2'], 2)
        SetPedComponentVariation(playerPed, 9, character['bproof_1'], character['bproof_2'], 2)
        SetPedComponentVariation(playerPed, 5, character['bags_1'], character['bags_2'], 2)
        SetOrClearPedProp(playerPed, 0, character['helmet_1'], character['helmet_2'])
        SetOrClearPedProp(playerPed, 1, character['glasses_1'], character['glasses_2'])
        SetOrClearPedProp(playerPed, 6, character['watches_1'], character['watches_2'])
        SetOrClearPedProp(playerPed, 7, character['bracelets_1'], character['bracelets_2'])
    end
end

CreateThread(function()
    local pedModel = GetHashKey("mp_m_freemode_01")
    RequestModel(pedModel)

    while not HasModelLoaded(pedModel) do
        Wait(1)
    end

    while true do
        local sleep = false

        for _, member in next, (Config.Server.ScorePeds.Highteam) do
            if member.position then
                local dist = #(GetEntityCoords(PlayerPedId()) - vec3(member.position.x, member.position.y, member.position.z))
                if Config.Server.safezone.toggle then
                    sleep = true

                    if not member.Loaded then
                        member.Ped = CreatePed(4, pedModel, member.position.x, member.position.y, member.position.z,
                            member.position.w, false, true)
                        FreezeEntityPosition(member.Ped, true)
                        SetEntityInvincible(member.Ped, true)
                        SetBlockingOfNonTemporaryEvents(member.Ped, true)

                        TaskStartScenarioInPlace(member.Ped, member.scenario, 0, true)

                        if not member.skinData then
                            ESX.TriggerServerCallback('PlayerData:getskin', function(skin)
                                member.skinData = skin
                                Skin(member.Ped, skin)
                            end, member.identifier)
                        else
                            Skin(member.Ped, member.skinData)
                        end

                        member.Loaded = true
                    end

                    if dist < 15 then
                        Text(member.position.x, member.position.y, member.position.z + member.texthigh, member.name, 255,
                            255, 255, 0.3)
                    end
                else
                    if member.Ped then
                        DeleteEntity(member.Ped)
                        member.Ped = nil
                        member.Loaded = false
                    end
                end
            end
        end

        if not sleep then
            Wait(200)
            for _, member in next, (Config.Server.ScorePeds.Highteam) do
                DeleteEntity(member.Ped)
                member.Ped = nil
                member.Loaded = false
            end
        end

        Wait(0)
    end
end);

-----------------------------------------------------------------------------
------------------------------------IPL--------------------------------------
-----------------------------------------------------------------------------

local CAYO_LOADED = false
local CAYO_COORDS = vec(4782.1, -5128.2)
local CAYO_RADIUS = 2000.0
local scenariosGroup = {
    "WORLD_VEHICLE_ATTRACTOR",
    "WORLD_VEHICLE_AMBULANCE",
    "WORLD_VEHICLE_BICYCLE_BMX",
    "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
    "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
    "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
    "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
    "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
    "WORLD_VEHICLE_BICYCLE_ROAD",
    "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
    "WORLD_VEHICLE_BIKER",
    "WORLD_VEHICLE_BOAT_IDLE",
    "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
    "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
    "WORLD_VEHICLE_BROKEN_DOWN",
    "WORLD_VEHICLE_BUSINESSMEN",
    "WORLD_VEHICLE_HELI_LIFEGUARD",
    "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
    "WORLD_VEHICLE_CONSTRUCTION_SOLO",
    "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
    "WORLD_VEHICLE_DRIVE_PASSENGERS",
    "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
    "WORLD_VEHICLE_DRIVE_SOLO",
    "WORLD_VEHICLE_FARM_WORKER",
    "WORLD_VEHICLE_FIRE_TRUCK",
    "WORLD_VEHICLE_EMPTY",
    "WORLD_VEHICLE_MARIACHI",
    "WORLD_VEHICLE_MECHANIC",
    "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
    "WORLD_VEHICLE_PARK_PARALLEL",
    "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
    "WORLD_VEHICLE_PASSENGER_EXIT",
    "WORLD_VEHICLE_POLICE_BIKE",
    "WORLD_VEHICLE_POLICE_CAR",
    "WORLD_VEHICLE_POLICE",
    "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
    "WORLD_VEHICLE_QUARRY",
    "WORLD_VEHICLE_SALTON",
    "WORLD_VEHICLE_SALTON_DIRT_BIKE",
    "WORLD_VEHICLE_SECURITY_CAR",
    "WORLD_VEHICLE_STREETRACE",
    "WORLD_VEHICLE_TOURBUS",
    "WORLD_VEHICLE_TOURIST",
    "WORLD_VEHICLE_TANDL",
    "WORLD_VEHICLE_TRACTOR",
    "WORLD_VEHICLE_TRACTOR_BEACH",
    "WORLD_VEHICLE_TRUCK_LOGS",
    "WORLD_VEHICLE_TRUCKS_TRAILERS",
    "WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
    "ALAMO_PLANES",
    "ARMENIAN_CATS",
    "ARMY_GUARD",
    "ARMY_HELI",
    "ATTRACT_PAP",
    "BLIMP",
    "CHINESE2_HILLBILLIES",
    "Chinese2_Lunch",
    "Cinema_Downtown",
    "Cinema_Morningwood",
    "Cinema_Textile",
    "City_Banks",
    "Countryside_Banks",
    "DEALERSHIP",
    "FIB_GROUP_1",
    "FIB_GROUP_2",
    "GRAPESEED_PLANES",
    "Grapeseed_Planes",
    "KORTZ_SECURITY",
    "LOST_BIKERS",
    "LSA_Planes",
    "MOVIE_STUDIO_SECURITY",
    "MP_POLICE",
    "Observatory_Bikers",
    "POLICE_POUND1",
    "POLICE_POUND2",
    "POLICE_POUND3",
    "POLICE_POUND4",
    "POLICE_POUND5",
    "PRISON_TOWERS",
    "QUARRY",
    "Rampage1",
    "SANDY_PLANES",
    "SCRAP_SECURITY",
    "SEW_MACHINE",
    "SOLOMON_GATE",
    "Triathlon_1",
    "Triathlon_1_Start",
    "Triathlon_2",
    "Triathlon_2_Start",
    "Triathlon_3",
    "Triathlon_3_Start",
}
local scenarioTypes = {
    "WORLD_VEHICLE_EMPTY",
    "WORLD_HUMAN_COP_IDLES",
    "WORLD_VEHICLE_SALTON",
    "WORLD_VEHICLE_MECHANIC",
    "WORLD_VEHICLE_STREETRACE",
    "WORLD_VEHICLE_POLICE_CAR",
    "WORLD_VEHICLE_BUSINESSMEN",
    "WORLD_VEHICLE_POLICE_BIKE",
    "WORLD_VEHICLE_SALTON_DIRT_BIKE",
    "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
    "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
    "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
    "WORLD_BOAR_GRAZING",
    "WORLD_CAT_SLEEPING_GROUND",
    "WORLD_CAT_SLEEPING_LEDGE",
    "WORLD_COW_GRAZING",
    "WORLD_COYOTE_HOWL",
    "WORLD_COYOTE_REST",
    "WORLD_COYOTE_WANDER",
    "WORLD_COYOTE_WALK",
    "WORLD_CHICKENHAWK_FEEDING",
    "WORLD_CHICKENHAWK_STANDING",
    "WORLD_CORMORANT_STANDING",
    "WORLD_CROW_FEEDING",
    "WORLD_CROW_STANDING",
    "WORLD_DEER_GRAZING",
    "WORLD_DOG_BARKING_ROTTWEILER",
    "WORLD_DOG_BARKING_RETRIEVER",
    "WORLD_DOG_BARKING_SHEPHERD",
    "WORLD_DOG_SITTING_ROTTWEILER",
    "WORLD_DOG_SITTING_RETRIEVER",
    "WORLD_DOG_SITTING_SHEPHERD",
    "WORLD_DOG_BARKING_SMALL",
    "WORLD_DOG_SITTING_SMALL",
    "WORLD_VEHICLE_AMBULANCE",
    "WORLD_VEHICLE_BICYCLE_BMX",
    "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
    "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
    "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
    "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
    "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
    "WORLD_VEHICLE_BICYCLE_ROAD",
    "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
    "WORLD_VEHICLE_BIKER",
    "WORLD_VEHICLE_BOAT_IDLE",
    "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
    "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
    "WORLD_VEHICLE_BROKEN_DOWN",
    "WORLD_VEHICLE_BUSINESSMEN",
    "WORLD_VEHICLE_HELI_LIFEGUARD",
    "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
    "WORLD_VEHICLE_CONSTRUCTION_SOLO",
    "WORLD_VEHICLE_DRIVE_PASSENGERS",
    "WORLD_VEHICLE_FARM_WORKER",
    "WORLD_VEHICLE_FIRE_TRUCK",
    "WORLD_VEHICLE_POLICE_BIKE",
    "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
    "PROP_BIRD_IN_TREE"
}

for i = 1, #scenariosGroup do SetScenarioGroupEnabled(scenariosGroup[i], false) end
for i = 1, #scenarioTypes do SetScenarioTypeEnabled(scenarioTypes[i], false) end

local function LoadCayo()
    Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", true)
    Citizen.InvokeNative(0x5E1460624D194A38, true)
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
    Citizen.InvokeNative(0x53797676AD34A9AA, false)
    SetScenarioGroupEnabled("Heist_Island_Peds", true)
    SetAudioFlag("PlayerOnDLCHeist4Island", true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
end

local function UnloadCayo()
    Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", false)
    Citizen.InvokeNative(0x5E1460624D194A38, false)
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
    Citizen.InvokeNative(0x53797676AD34A9AA, true)
    SetScenarioGroupEnabled("Heist_Island_Peds", false)
    SetAudioFlag("PlayerOnDLCHeist4Island", false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", false, false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", true, false)
end

local function CheckCayo()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if not CAYO_LOADED and #(CAYO_COORDS - coords.xy) < CAYO_RADIUS then
        LoadCayo()
        CAYO_LOADED = true
    elseif CAYO_LOADED and #(CAYO_COORDS - coords.xy) >= CAYO_RADIUS then
        UnloadCayo()
        CAYO_LOADED = false
    end
end

CreateThread(function()
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RequestIpl("dt1_05_hc_remove")
    RequestIpl("dt1_05_hc_remove_lod")
    RemoveIpl("dt1_05_hc_end")
    RemoveIpl("dt1_05_hc_req")
    RemoveIpl("ba_case4_forsale")
    RemoveIpl("ba_case4_dixon")
    RemoveIpl("ba_case4_madonna")
    RemoveIpl("ba_case4_solomun")
    RemoveIpl("ba_case4_taleofus")
    RemoveIpl("ba_barriers_case4")
    RequestIpl("gabz_pillbox_milo_")
    RequestIpl("gabz_mrpd_milo_")
    RequestIpl("coronertrash")
    RequestIpl("Coroner_Int_On")
    RequestIpl("chop_props")
    RemoveIpl("hei_bi_hw1_13_door")
    RequestIpl("v_rockclub")
    RequestIpl("rc12b_fixed")
    RemoveIpl("rc12b_destroyed")
    RemoveIpl("rc12b_default")
    RemoveIpl("rc12b_hospitalinterior_lod")
    RemoveIpl("rc12b_hospitalinterior")
    RemoveIpl("v_carshowroom")
    RemoveIpl("shutter_open")
    RemoveIpl("shutter_closed")
    RemoveIpl("DES_StiltHouse_imapend")
    RequestIpl("DES_stilthouse_rebuild")
    RemoveIpl("csr_inMission")
    RequestIpl("v_carshowroom")
    RequestIpl("shr_int")
    RequestIpl("shr_int_lod")
    RequestIpl("shutter_closed")
    RequestIpl("FINBANK")
    RemoveIpl("facelobbyfake")
    RequestIpl("facelobby")
    RemoveIpl("CS1_02_cf_offmission")
    RequestIpl("CS1_02_cf_onmission1")
    RequestIpl("CS1_02_cf_onmission2")
    RequestIpl("CS1_02_cf_onmission3")
    RequestIpl("CS1_02_cf_onmission4")
    RequestIpl("des_farmhouse")
    RequestIpl("des_farmhs_endimap")
    RequestIpl("des_farmhs_end_occl")
    RequestIpl("des_farmhs_startimap")
    RequestIpl("des_farmhs_start_occl")
    RequestIpl("farm")
    RequestIpl("farm_props")
    RequestIpl("farm_int")
    RequestIpl("farmint")
    RemoveIpl("farm_burnt")
    RemoveIpl("farm_burnt_props")
    RemoveIpl("des_farmhs_endimap")
    RemoveIpl("des_farmhs_end_occl")
    RequestIpl("FIBlobby")
    RemoveIpl("FIBlobbyfake")
    RequestIpl("FBI_colPLUG")
    RequestIpl("FBI_repair")
    RemoveIpl("id2_14_during_door")
    RemoveIpl("id2_14_during2")
    RemoveIpl("id2_14_on_fire")
    RemoveIpl("id2_14_post_no_int")
    RemoveIpl("id2_14_pre_no_int")
    RequestIpl("id2_14_during1")
    RemoveIpl("TrevorsMP")
    RemoveIpl("TrevorsTrailer")
    RequestIpl("TrevorsTrailerTidy")
    RemoveIpl("TrevorsTrailerTrash")
    RequestIpl("dt1_03_gr_closed")
    RequestIpl("dt1_21_prop_lift")
    RequestIpl("dt1_21_prop_lift_on")
    RemoveIpl("DT1_03_Shutter")
    RequestIpl("yogagame")
    RequestIpl("v_tunnel_hole")
    RequestIpl("V_Michael")
    RequestIpl("V_Michael_Garage")
    RequestIpl("V_Michael_FameShame")
    RequestIpl("V_Michael_JewelHeist")
    RequestIpl("V_Michael_plane_ticket")
    RequestIpl("V_Michael_Scuba")
    RemoveIpl("smboat")
    RequestIpl("hei_yacht_heist")
    RequestIpl("hei_yacht_heist_Bar")
    RequestIpl("hei_yacht_heist_Bedrm")
    RequestIpl("hei_yacht_heist_Bridge")
    RequestIpl("hei_yacht_heist_DistantLights")
    RequestIpl("hei_yacht_heist_enginrm")
    RequestIpl("hei_yacht_heist_LODLights")
    RequestIpl("hei_yacht_heist_Lounge")
    RequestIpl("cargoship")
    RemoveIpl("sp1_10_fake_interior")
    RemoveIpl("sp1_10_fake_interior_lod")
    RequestIpl("sc1_01_newbill")
    RequestIpl("hw1_02_newbill")
    RequestIpl("hw1_emissive_newbill")
    RequestIpl("sc1_14_newbill")
    RequestIpl("dt1_17_newbill")
    RequestIpl("SC1_01_OldBill")
    RequestIpl("SC1_30_Keep_Closed")
    RequestIpl("refit_unload")
    RequestIpl("post_hiest_unload")
    RequestIpl("occl_meth_grp1")
    RequestIpl("Michael_premier")
    RemoveIpl("DT1_05_HC_REMOVE")
    RemoveIpl("jewel2fake")
    RemoveIpl("bh1_16_refurb")
    RemoveIpl("ch1_02_closed")
    RemoveIpl("scafstartimap")
    RequestIpl("scafendimap")
    RemoveIpl("bh1_16_doors_shut")
    RequestIpl("ferris_finale_anim")
    RequestIpl("ferris_finale_anim_lod")
    RequestIpl("CS2_06_TriAf02")
    RequestIpl("CS3_07_MPGates")
    RequestIpl("CS4_08_TriAf02")
    RequestIpl("CS4_04_TriAf03")
    RequestIpl("AP1_04_TriAf01")
    RequestIpl("gr_case0_bunkerclosed")
    RequestIpl("gr_case1_bunkerclosed")
    RequestIpl("gr_case2_bunkerclosed")
    RequestIpl("gr_case3_bunkerclosed")
    RequestIpl("gr_case4_bunkerclosed")
    RequestIpl("gr_case5_bunkerclosed")
    RequestIpl("gr_case6_bunkerclosed")
    RequestIpl("gr_case7_bunkerclosed")
    RequestIpl("gr_case9_bunkerclosed")
    RequestIpl("gr_case10_bunkerclosed")
    RequestIpl("gr_case11_bunkerclosed")
    RequestIpl("cs5_4_trains")
    RequestIpl("chophillskennel")
    RequestIpl("bnkheist_apt_dest")
    RequestIpl("bnkheist_apt_norm")
    RequestIpl("redcarpet")
    RemoveIpl("hei_sm_16_interior_v_bahama_milo_")
    RequestIpl("cs3_05_water_grp1")
    RequestIpl("cs3_05_water_grp1_lod")
    RequestIpl("cs3_05_water_grp2")
    RequestIpl("cs3_05_water_grp2_lod")
    RequestIpl("canyonriver01")
    RequestIpl("canyonriver01_lod")
    RequestIpl("railing_start")
    RemoveIpl("canyonriver01_traincrash")
    RemoveIpl("railing_end")
    RequestIpl("bh1_47_joshhse_unburnt")
    RequestIpl("bh1_47_joshhse_unburnt_lod")
    RequestIpl("bkr_bi_hw1_13_int")
    RequestIpl("CanyonRvrShallow")
    RequestIpl("methtrailer_grp1")
    RequestIpl("lr_cs6_08_grave_closed")
    RequestIpl("bkr_bi_id1_23_door")
    RequestIpl("ch1_02_open")
    RequestIpl("sp1_10_real_interior")
    RequestIpl("sp1_10_real_interior_lod")
    RequestIpl("Carwash_with_spinners")
    RemoveIpl("apa_v_mp_h_01_a")
    RemoveIpl("apa_v_mp_h_06_b")
    RemoveIpl("apa_v_mp_h_08_c")
    RemoveIpl("ex_dt1_02_office_01c")
    RemoveIpl("ex_dt1_11_office_01b")
    RemoveIpl("ex_sm_13_office_01a")
    RemoveIpl("ex_sm_15_office_02b")
    RequestIpl("ex_sm_13_office_02a")
    RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo")
    RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware02_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware03_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware04_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware05_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo")
    RemoveIpl("bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo")
    RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo")
    RemoveIpl("ex_exec_warehouse_placement_interior_1_int_warehouse_s_dlc_milo")
    RemoveIpl("ex_exec_warehouse_placement_interior_0_int_warehouse_m_dlc_milo")
    RemoveIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo")
    RemoveIpl("imp_impexp_interior_placement_interior_1_impexp")
    RemoveIpl("imp_impexp_interior_placement")
    RemoveIpl("imp_impexp_interior_placement_interior_0_impexp_int_01_milo_")
    RemoveIpl("imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_")
    RemoveIpl("imp_impexp_interior_placement_interior_2_imptexp_mod_int_01_milo_")
    RemoveIpl("imp_impexp_interior_placement_interior_3_impexp_int_02_milo_")
    RequestIpl("ch3_rd2_bishopschickengraffiti")
    RequestIpl("cs5_04_mazebillboardgraffiti")
    RequestIpl("cs5_roads_ronoilgraffiti")
    RequestIpl("ba_barriers_case0")
    RequestIpl("ba_case0_forsale")
    RequestIpl("ba_case0_dixon")
    RequestIpl("ba_case0_madonna")
    RequestIpl("ba_case0_solomun")
    RequestIpl("ba_case0_taleofus")
    RequestIpl("ba_barriers_case1")
    RequestIpl("ba_case1_forsale")
    RequestIpl("ba_case1_dixon")
    RequestIpl("ba_case1_madonna")
    RequestIpl("ba_case1_solomun")
    RequestIpl("ba_case1_taleofus")
    RequestIpl("ba_barriers_case2")
    RequestIpl("ba_case2_forsale")
    RequestIpl("ba_case2_dixon")
    RequestIpl("ba_case2_madonna")
    RequestIpl("ba_case2_solomun")
    RequestIpl("ba_case2_taleofus")
    RequestIpl("ba_barriers_case3")
    RequestIpl("ba_case3_forsale")
    RequestIpl("ba_case3_dixon")
    RequestIpl("ba_case3_madonna")
    RequestIpl("ba_case3_solomun")
    RequestIpl("ba_case3_taleofus")
    RequestIpl("ba_barriers_case5")
    RequestIpl("ba_case5_forsale")
    RequestIpl("ba_case5_dixon")
    RequestIpl("ba_case5_madonna")
    RequestIpl("ba_case5_solomun")
    RequestIpl("ba_case5_taleofus")
    RequestIpl("ba_barriers_case6")
    RequestIpl("ba_case6_forsale")
    RequestIpl("ba_case6_dixon")
    RequestIpl("ba_case6_madonna")
    RequestIpl("ba_case6_solomun")
    RequestIpl("ba_case6_taleofus")
    RequestIpl("ba_barriers_case7")
    RequestIpl("ba_case7_forsale")
    RequestIpl("ba_case7_dixon")
    RequestIpl("ba_case7_madonna")
    RequestIpl("ba_case7_solomun")
    RequestIpl("ba_case7_taleofus")
    RequestIpl("ba_barriers_case8")
    RequestIpl("ba_case8_forsale")
    RequestIpl("ba_case8_dixon")
    RequestIpl("ba_case8_madonna")
    RequestIpl("ba_case8_solomun")
    RequestIpl("ba_case8_taleofus")
    RequestIpl("ba_barriers_case9")
    RequestIpl("ba_case9_forsale")
    RequestIpl("ba_case9_dixon")
    RequestIpl("ba_case9_madonna")
    RequestIpl("ba_case9_solomun")
    RequestIpl("ba_case9_taleofus")
    RequestIpl("gr_grdlc_yacht_lod")
    RequestIpl("gr_grdlc_yacht_placement")
    RequestIpl("gr_heist_yacht2")
    RequestIpl("gr_heist_yacht2_bar")
    RequestIpl("gr_heist_yacht2_bar_lod")
    RequestIpl("gr_heist_yacht2_bedrm")
    RequestIpl("gr_heist_yacht2_bedrm_lod")
    RequestIpl("gr_heist_yacht2_bridge")
    RequestIpl("gr_heist_yacht2_bridge_lod")
    RequestIpl("gr_heist_yacht2_enginrm")
    RequestIpl("gr_heist_yacht2_enginrm_lod")
    RequestIpl("gr_heist_yacht2_lod")
    RequestIpl("gr_heist_yacht2_lounge")
    RequestIpl("gr_heist_yacht2_lounge_lod")
    RequestIpl("gr_heist_yacht2_slod")
    RequestIpl("ex_dt1_02_office_02b")
    RequestIpl("ex_dt1_11_office_02c")
    RequestIpl("ex_sm_15_office_01a")
    -- Aircraft
    RequestIpl("hei_carrier")
    RequestIpl("hei_carrier_DistantLights")
    RequestIpl("hei_Carrier_int1")
    RequestIpl("hei_Carrier_int2")
    RequestIpl("hei_Carrier_int3")
    RequestIpl("hei_Carrier_int4")
    RequestIpl("hei_Carrier_int5")
    RequestIpl("hei_Carrier_int6")
    RequestIpl("hei_carrier_LODLights")
end);

CreateThread(function()
    UnloadCayo()
    while true do
        Wait(1000)
        CheckCayo()
    end
end);

CreateThread(function()
    local islandMap = GetHashKey("h4_fake_islandx")
    local contextHash = GetHashKey("MAP_CanZoom")
    while true do
        local paused = IsPauseMenuActive()
        local isFullMap = false
        if paused then
            isFullMap = PauseMenuIsContextActive(contextHash)
            if isFullMap and not IsControlPressed(2, 217) then
                SetRadarAsExteriorThisFrame()
                SetRadarAsInteriorThisFrame(islandMap, vec(4700.0, -5145.0), 0, 0)
            end
        end
        Wait((paused and isFullMap) and 0 or 1000)
    end
end);

CreateThread(function()
    while true do
        Wait(7500)
        StopFireInRange(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y,
            GetEntityCoords(PlayerPedId()).z, 10.0)

        for k, v in next, (GetGamePool('CVehicle')) do
            if GetEntitySpeed(v) >= 3.0 then
                SetEntityNoCollisionEntity(PlayerPedId(), v, true)
            end
        end
    end
end);

-----------------------------------------------------------------------------
------------------------------------TATOO------------------------------------
-----------------------------------------------------------------------------

RequestStreamedTextureDict("CommonMenu")

JayMenu = {}

-- Options
JayMenu.debug = false

-- Local variables
local menus = {}
local keys = {
    up = 172,
    down = 173,
    left = 174,
    right = 175,
    select = 201,
    back = 177,
    mup = 181,
    mdown = 180,
}

local optionCount = 0

local currentKey = nil
local currentDesc = nil

local currentMenu = nil

local menuWidth = 0.23

local titleHeight = 0.09
local titleYOffset = 0.02
local titleScale = 1.0

local buttonHeight = 0.038
local buttonFont = 0
local buttonScale = 0.365
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005

local continuity = {}

local function HudColourToTable(r, g, b, a) return { r, g, b, a or 255 } end

local function setMenuProperty(id, property, value)
    if id and menus[id] then
        menus[id][property] = value
    end
end

local function isMenuVisible(id)
    if id and menus[id] then
        return menus[id].visible
    else
        return false
    end
end

local function setMenuVisible(id, visible, holdCurrent)
    if id and menus[id] then
        setMenuProperty(id, 'visible', visible)

        if visible then
            if id ~= currentMenu and isMenuVisible(currentMenu) then
                setMenuVisible(currentMenu, false, true)
            else
                setMenuProperty(id, 'currentOption', 1)
            end

            currentMenu = id
        end
    end
end


function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
    BeginTextCommandDisplayText("STRING")
    if color then
        SetTextColour(color[1], color[2], color[3], color[4])
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextFont(font)
    SetTextScale(scale, scale)

    if shadow then
        SetTextDropShadow(2, 2, 0, 0, 0)
    end

    if menus[currentMenu] then
        if center then
            SetTextCentre(center)
        elseif alignRight then
            SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
            SetTextRightJustify(true)
        end
    end
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function getLineHeight(text, font, color, scale, center, shadow, alignRight)
    BeginTextCommandLineCount("STRING")
    if color then
        SetTextColour(color[1], color[2], color[3], color[4])
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextFont(font)
    SetTextScale(scale, scale)

    if shadow then
        SetTextDropShadow(2, 2, 0, 0, 0)
    end

    if menus[currentMenu] then
        SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
        if center then
            SetTextCentre(center)
        elseif alignRight then
            SetTextRightJustify(true)
        end
    end
    AddTextComponentSubstringPlayerName(text)
    return GetTextScreenLineCount(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
end

function drawRect(x, y, width, height, color)
    DrawRect(x, y, width, height, color[1], color[2], color[3], color[4])
end

function drawSprite(textDict, sprite, x, y, scale, color)
    if HasStreamedTextureDictLoaded(textDict) then
        DrawSprite(textDict, sprite, x, y, 0.0265, 0.05, 0, color[1], color[2], color[3], color[4])
    else
        RequestStreamedTextureDict(textDict, false)
    end
end

local headerTXT = CreateRuntimeTxd('Menu_Cock_Tattoo')
local headerDUI = CreateDui(Config.Discord.designs.banner, 611, 344)
local duiHANDLE = GetDuiHandle(headerDUI)
local function drawTitle()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + menuWidth / 2
        local y = menus[currentMenu].y + titleHeight / 2

        if menus[currentMenu].titleFont == "!sprite!" then
            local color = menus[currentMenu].titleBackgroundColor
            local textDict, sprite = table.unpack(menus[currentMenu].titleColor)
            RequestStreamedTextureDict(textDict, false)
            HasStreamedTextureDictLoaded(textDict)
            DrawSprite(textDict, sprite, x, y, menuWidth, titleHeight, 0, color[1], color[2], color[3], color[4])
        elseif menus[currentMenu].titleFont == "~sprite~" then
            local color = menus[currentMenu].titleBackgroundColor
            local textDict, sprite = table.unpack(menus[currentMenu].titleColor)
            RequestStreamedTextureDict(textDict, false)
            HasStreamedTextureDictLoaded(textDict)
            DrawSprite(textDict, sprite, x, y, menuWidth, titleHeight, 0, color[1], color[2], color[3], color[4])
            drawText(menus[currentMenu].title, x, y - titleHeight / 2 + titleYOffset, 1, { 255, 255, 255, 255 },
                titleScale, true)
        else
            if HasStreamedTextureDictLoaded("CommonMenu") then
                SetUiLayer(0)
                DrawSprite("Menu_Cock_Tattoo", "MenuHeader_CockCock_Tattoo", x, y, menuWidth, titleHeight, 0.0, 255, 255,
                    255, 255, 0)
            end
            --drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
            drawText(menus[currentMenu].title, x, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont,
                menus[currentMenu].titleColor, titleScale, true)
        end

        local x, y, color, textDict, sprite = nil
    end
end

local function drawSubTitle()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + (menuWidth / 2)
        local y = menus[currentMenu].y + (titleHeight + buttonHeight / 2)
        local subtitle = menus[currentMenu].subTitle

        --local subTitleColor = { r = menus[currentMenu].titleBackgroundColor.r, g = menus[currentMenu].titleBackgroundColor.g, b = menus[currentMenu].titleBackgroundColor.b, a = 255 }
        --local subTitleColor = {255, 255, 255, 255}

        drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
        if subtitle:find("|") then
            drawText(subtitle:sub(1, subtitle:find("|") - 1), menus[currentMenu].x + buttonTextXOffset,
                y - buttonHeight / 2 + buttonTextYOffset, buttonFont, false, buttonScale, false)
            drawText(subtitle:sub(subtitle:find("|") + 1), menus[currentMenu].x + menuWidth,
                y - buttonHeight / 2 + buttonTextYOffset, buttonFont, false, buttonScale, false, false, true)
        else
            drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset,
                y - buttonHeight / 2 + buttonTextYOffset, buttonFont, false, buttonScale, false)
            drawText(tostring(menus[currentMenu].currentOption) .. ' / ' .. tostring(optionCount),
                menus[currentMenu].x + menuWidth, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, false,
                buttonScale, false, false, true)
        end

        local x, y, subTitleColor = nil
    end
end

local function drawDescription()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + menuWidth / 2
        local menuHeight = buttonHeight *
            (((optionCount <= menus[currentMenu].maxOptionCount) and optionCount or menus[currentMenu].maxOptionCount + 1) + 1)

        local lines = getLineHeight(currentDesc, buttonFont, menus[currentMenu].menuTextColor, buttonScale, false, true)

        local descriptionHeight = lines * (buttonTextYOffset * 5) + buttonTextYOffset * 2
        local descriptionY = descriptionHeight / 2

        local y = menus[currentMenu].y + titleHeight + menuHeight + descriptionHeight / 2 + buttonTextYOffset
        local dividerY = y - descriptionHeight / 2 + buttonTextYOffset / 2

        if HasStreamedTextureDictLoaded("CommonMenu") then
            SetUiLayer(0)

            DrawRect(x, dividerY, menuWidth, buttonTextYOffset, 0, 0, 0, 255)
            DrawSprite("CommonMenu", "Gradient_Bgd", x, y, menuWidth, descriptionHeight, 0.0, 255, 255, 255, 220, 0)

            drawText(currentDesc, menus[currentMenu].x + buttonTextXOffset, y - descriptionY + buttonTextYOffset,
                buttonFont, menus[currentMenu].menuTextColor, buttonScale, false, true)
        else
            RequestStreamedTextureDict("CommonMenu")
        end

        x, y, menuHeight = nil
    end
end

local function drawMenuBackground()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + menuWidth / 2
        local menuHeight = buttonHeight *
            ((optionCount <= menus[currentMenu].maxOptionCount) and optionCount or menus[currentMenu].maxOptionCount)
        local y = menus[currentMenu].y + titleHeight + buttonHeight + menuHeight / 2

        if HasStreamedTextureDictLoaded("CommonMenu") then
            SetUiLayer(0)
            DrawSprite("CommonMenu", "Gradient_Bgd", x, y, menuWidth, menuHeight, 0.0, 255, 255, 255, 255, 0)
        else
            RequestStreamedTextureDict("CommonMenu")
        end

        local x, y, menuHeight = nil
    end
end

local function drawArrows()
    local x = menus[currentMenu].x + menuWidth / 2
    local menuHeight = buttonHeight * (menus[currentMenu].maxOptionCount + 1)
    local y = menus[currentMenu].y + titleHeight + menuHeight + buttonHeight / 2

    if HasStreamedTextureDictLoaded("CommonMenu") then
        local colour = menus[currentMenu].subTitleBackgroundColor
        drawRect(x, y, menuWidth, buttonHeight, { colour[1], colour[2], colour[3], 182 })
        DrawSprite("CommonMenu", "shop_arrows_upanddown", x, y, 0.0265, 0.05, 0.0, 255, 255, 255, 255, 0)
    else
        RequestStreamedTextureDict("CommonMenu")
    end

    local x, menuHeight, y, color = nil
end

local function drawButton(text, subText)
    local x = menus[currentMenu].x + menuWidth / 2
    local multiplier = nil

    if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
        multiplier = optionCount
    elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
        multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end

    if multiplier then
        local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
        local backgroundColor = nil
        local textColor = nil
        local subTextColor = nil
        local shadow = false

        if menus[currentMenu].currentOption == optionCount and text ~= "" then
            backgroundColor = menus[currentMenu].menuFocusBackgroundColor
            textColor = menus[currentMenu].menuFocusTextColor
            subTextColor = menus[currentMenu].menuFocusTextColor
        else
            backgroundColor = menus[currentMenu].menuBackgroundColor
            textColor = menus[currentMenu].menuTextColor
            subTextColor = menus[currentMenu].menuSubTextColor
            shadow = true
        end

        if text ~= "!!separator!!" then
            if menus[currentMenu].currentOption == optionCount and HasStreamedTextureDictLoaded("CommonMenu") then
                SetUiLayer(1)
                DrawSprite("CommonMenu", "Gradient_Nav", x, y, menuWidth, buttonHeight, 0.0, 255, 255, 255, 255, 0)
            end
            --drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
            drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset,
                buttonFont, textColor, buttonScale, false, shadow)

            if subText then
                drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset,
                    buttonFont, subTextColor, buttonScale, false, shadow, true)
            end
        end
    end

    local x, y, backgroundColor, textColor, subTextColor, shadow, multiplier = nil
end

local function drawDisabledButton(text, subText)
    local x = menus[currentMenu].x + menuWidth / 2
    local multiplier = nil

    if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
        multiplier = optionCount
    elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
        multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end

    if multiplier then
        local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
        local backgroundColor = menus[currentMenu].menuBackgroundColor
        local textColor = HudColourToTable(GetHudColour(5))
        local subTextColor = HudColourToTable(GetHudColour(5))
        local shadow = false

        --[[if menus[currentMenu].currentOption == optionCount and HasStreamedTextureDictLoaded("CommonMenu") then
            SetUiLayer(1)
            DrawSprite("CommonMenu", "Gradient_Nav", x, y, menuWidth, buttonHeight, 0.0, 255, 255, 255, 255, 0)
        end]]
        --drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
        drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont,
            textColor, buttonScale, false, shadow)

        if subText then
            drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset,
                buttonFont, subTextColor, buttonScale, false, shadow, true)
        end
    end

    local x, y, backgroundColor, textColor, subTextColor, shadow, multiplier = nil
end

local function drawSpriteButton(text, textDict, sprite, focusSprite)
    local x = menus[currentMenu].x + menuWidth / 2
    local multiplier = nil

    if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
        multiplier = optionCount
    elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
        multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end

    if multiplier then
        local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
        local backgroundColor = nil
        local textColor = nil
        local subTextColor = nil
        local shadow = false

        if menus[currentMenu].currentOption == optionCount then
            backgroundColor = menus[currentMenu].menuFocusBackgroundColor
            textColor = menus[currentMenu].menuFocusTextColor
            subTextColor = menus[currentMenu].menuFocusTextColor
        else
            backgroundColor = menus[currentMenu].menuBackgroundColor
            textColor = menus[currentMenu].menuTextColor
            subTextColor = menus[currentMenu].menuSubTextColor
            shadow = true
        end

        if menus[currentMenu].currentOption == optionCount and HasStreamedTextureDictLoaded("CommonMenu") then
            SetUiLayer(1)
            DrawSprite("CommonMenu", "Gradient_Nav", x, y, menuWidth, buttonHeight, 0.0, 255, 255, 255, 255, 0)
        end

        drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont,
            textColor, buttonScale, false, shadow)

        if textDict and sprite then
            if focusSprite then
                if menus[currentMenu].currentOption == optionCount then
                    SetUiLayer(2)
                    drawSprite(textDict, focusSprite, menus[currentMenu].x + menuWidth - buttonTextXOffset * 2,
                        y - buttonHeight / 2 + (buttonTextYOffset * 3.75), buttonScale,
                        menus[currentMenu].menuSubTextColor)
                else
                    SetUiLayer(2)
                    drawSprite(textDict, sprite, menus[currentMenu].x + menuWidth - buttonTextXOffset * 2,
                        y - buttonHeight / 2 + (buttonTextYOffset * 3.75), buttonScale, subTextColor)
                end
            else
                SetUiLayer(2)
                drawSprite(textDict, sprite, menus[currentMenu].x + menuWidth - buttonTextXOffset * 2,
                    y - buttonHeight / 2 + (buttonTextYOffset * 3.75), buttonScale, subTextColor)
            end
        end
    end

    local x, y, backgroundColor, textColor, subTextColor, shadow, multiplier = nil
end

local function stopConflictingInputs()
    -- isolates menu navigation buttons and stops jumping, weapon selection and opening of the pause menu

    for _, key in next, (keys) do
        SetInputExclusive(0, key)
    end
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 38, true)
    DisableControlAction(0, 200, true)
end

-- API
function JayMenu.CreateMenu(id, title, closeCallback)
    -- Default settings
    menus[id] = {}
    menus[id].title = title
    menus[id].subTitle = 'INTERACTION MENU'

    menus[id].visible = false

    menus[id].previousMenu = nil

    menus[id].aboutToBeClosed = false

    -- Top left corner
    menus[id].x = 0.0145
    menus[id].y = 0.075

    menus[id].currentOption = 1
    menus[id].maxOptionCount = 12
    --https://cdn.discordapp.com/attachments/943333042896904232/984204252048162926/jhgjhgjhgjhgjhg.png
    menus[id].titleFont = 1
    menus[id].titleColor = { 255, 255, 255, 255 }
    menus[id].titleBackgroundColor = { 255, 255, 255, 255 }

    menus[id].menuTextColor = { 255, 255, 255, 255 }
    menus[id].menuSubTextColor = { 255, 255, 255, 255 }
    menus[id].menuFocusTextColor = { 0, 0, 0, 255 }
    menus[id].menuFocusBackgroundColor = { 245, 245, 245, 255 }
    menus[id].menuBackgroundColor = { 0, 0, 0, 160 }

    menus[id].subTitleBackgroundColor = { menus[id].menuBackgroundColor[1], menus[id].menuBackgroundColor[2], menus[id]
        .menuBackgroundColor[3], 255 }

    menus[id].buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" } --https://pastebin.com/0neZdsZ5

    menus[id].closeCallback = closeCallback or function() return true end
end

function JayMenu.CreateSubMenu(id, parent, subTitle, closeCallback)
    if menus[parent] then
        JayMenu.CreateMenu(id, menus[parent].title)

        -- Well it's copy constructor like :)
        if subTitle then
            setMenuProperty(id, 'subTitle', string.upper(subTitle))
        else
            setMenuProperty(id, 'subTitle', string.upper(menus[parent].subTitle))
        end

        setMenuProperty(id, 'previousMenu', parent)

        setMenuProperty(id, 'x', menus[parent].x)
        setMenuProperty(id, 'y', menus[parent].y)
        setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)
        setMenuProperty(id, 'titleFont', menus[parent].titleFont)
        setMenuProperty(id, 'titleColor', menus[parent].titleColor)
        setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)
        setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)
        setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)
        setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)
        setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)
        setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)
        setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor)
        setMenuProperty(id, 'closeCallback', closeCallback or function() return true end);
    end
end

function JayMenu.CurrentMenu()
    return currentMenu
end

function JayMenu.MenuTable()
    return menus
end

function JayMenu.OpenMenu(id)
    if id and menus[id] then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        setMenuVisible(id, true)
    end
end

function JayMenu.IsMenuOpened(id)
    return isMenuVisible(id)
end

function JayMenu.IsAnyMenuOpened()
    for id, _ in next, (menus) do
        if isMenuVisible(id) then return true end
    end

    return false
end

function JayMenu.IsAnyMenuWithTitleOpened(subtitle)
    for id, v in next, (menus) do
        if isMenuVisible(id) then
            if v.title == subtitle then
                return true
            end
        end
    end

    return false
end

function JayMenu.IsMenuAboutToBeClosed()
    if menus[currentMenu] then
        return menus[currentMenu].aboutToBeClosed
    else
        return false
    end
end

function JayMenu.IsThisMenuAboutToBeClosed(id)
    if menus[id] then
        return menus[id].aboutToBeClosed
    else
        return false
    end
end

function JayMenu.CloseMenu()
    if menus[currentMenu] then
        if menus[currentMenu].aboutToBeClosed then
            menus[currentMenu].aboutToBeClosed = false
            setMenuVisible(currentMenu, false)
            PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            optionCount = 0
            currentMenu = nil
            currentKey = nil
            currentDesc = nil

            -- keep continuity
            if continuity.lastPedWeapon then
                SetCurrentPedWeapon(PlayerPedId(), continuity.lastPedWeapon, true)
            end

            continuity = {}

            CreateThread(function()
                while IsDisabledControlPressed(0, 200) or IsDisabledControlJustReleased(0, 200) do
                    Wait(0)
                    DisableControlAction(0, 200, true)
                end
            end);
        else
            if menus[currentMenu].closeCallback() then
                menus[currentMenu].aboutToBeClosed = true
            end
        end
    end
end

function JayMenu.Button(text, subText)
    local buttonText = text
    if subText then
        buttonText = '{ ' .. tostring(buttonText) .. ', ' .. tostring(subText) .. ' }'
    end

    if menus[currentMenu] then
        optionCount = optionCount + 1

        local isCurrent = menus[currentMenu].currentOption == optionCount

        drawButton(text, subText)

        if isCurrent then
            if text == "!!separator!!" then
                if IsDisabledControlPressed(0, keys.up) then
                    menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
                elseif IsDisabledControlPressed(0, keys.down) then
                    menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
                end
            elseif currentKey == keys.select then
                if text ~= "" then
                    PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name,
                        menus[currentMenu].buttonPressedSound.set, true)
                end
                return true, isCurrent
            elseif currentKey == keys.left or currentKey == keys.right then
                if text ~= "" then PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) end
            end
        end

        return false, isCurrent
    else
        return false
    end

    local buttonText, isCurrent = nil
end

function JayMenu.DisabledButton(text, subText)
    local buttonText = text
    if subText then
        buttonText = '{ ' .. tostring(buttonText) .. ', ' .. tostring(subText) .. ' }'
    end

    if menus[currentMenu] then
        optionCount = optionCount + 1

        local isCurrent = menus[currentMenu].currentOption == optionCount

        drawDisabledButton(text ~= "!!separator!!" and text or "", subText)

        if isCurrent then
            if IsDisabledControlPressed(0, 172) then
                menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
            elseif IsDisabledControlPressed(0, 173) then
                menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
            end
        end

        return false, isCurrent
    else
        return false
    end

    local buttonText, isCurrent = nil
end

function JayMenu.SpriteButton(text, textDict, sprite, focusSprite)
    local buttonText = text

    if menus[currentMenu] then
        optionCount = optionCount + 1

        local isCurrent = menus[currentMenu].currentOption == optionCount

        drawSpriteButton(text, textDict, sprite, focusSprite)

        if isCurrent then
            if currentKey == keys.select then
                PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name,
                    menus[currentMenu].buttonPressedSound.set, true)
                return true, isCurrent
            elseif currentKey == keys.left or currentKey == keys.right then
                PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
        end

        return false, isCurrent
    else
        return false, isCurrent
    end

    local buttonText, isCurrent = nil
end

function JayMenu.SpriteMenuButton(text, textDict, sprite, focusSprite, id)
    if menus[id] then
        local clicked, hovered = JayMenu.SpriteButton(text, textDict, sprite, focusSprite)
        if clicked then
            setMenuVisible(currentMenu, false)
            setMenuVisible(id, true, true)
        end
        return clicked, hovered
    end

    local clicked, hovered = nil
end

function JayMenu.ComboBox(text, items, currentIndex, selectedIndex, callback, displaycb)
    local itemsCount = #items
    local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)
    local getDisplayText = displaycb or (function(t) return tostring(t or "") end);
    local selectedItem = getDisplayText(items[currentIndex])

    if itemsCount > 1 and isCurrent then
        selectedItem = '← ' .. selectedItem .. ' →'
    end

    if JayMenu.Button(text, selectedItem) then
        selectedIndex = currentIndex
        callback(currentIndex, selectedIndex)
        return true, isCurrent
    elseif isCurrent then
        if currentKey == keys.left then
            if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
        elseif currentKey == keys.right then
            if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
        end
    else
        currentIndex = selectedIndex
    end

    callback(currentIndex, selectedIndex)
    -- local itemsCount,isCurrent,getDisplayText,selectedItem = nil
    return false, isCurrent
end

function JayMenu.MenuButton(text, id, secondtext)
    if menus[id] then
        local clicked, hovered = JayMenu.Button(text, (secondtext and secondtext or "→"))
        if clicked then
            setMenuVisible(currentMenu, false)
            setMenuVisible(id, true, true)

            return true, true
        end

        return false, hovered
    end

    return false, false
end

function JayMenu.SwitchMenu(id)
    setMenuVisible(currentMenu, false)
    setMenuVisible(id, true, true)
end

function JayMenu.SetDescription(text)
    currentDesc = tostring(text)
end

function JayMenu.CheckBox(text, bool, callback)
    --[[local checked = '~r~Off'
    if bool then
        checked = '~g~On'
    end]]

    local sprite = bool and "shop_box_tick" or "shop_box_blank"
    local focusSprite = bool and "shop_box_tickb" or "shop_box_blankb"

    if JayMenu.SpriteButton(text, "commonmenu", sprite, focusSprite) then
        bool = not bool
        callback(bool)

        return true
    end

    local sprite, focusSprite = nil
    return false
end

function JayMenu.Display()
    if isMenuVisible(currentMenu) and not IsPauseMenuActive() then
        stopConflictingInputs()

        if menus[currentMenu].aboutToBeClosed then
            JayMenu.CloseMenu()
        else
            ClearAllHelpMessages()

            drawTitle()
            drawSubTitle()
            if currentDesc then
                drawDescription()
            end
            drawMenuBackground()
            if optionCount > menus[currentMenu].maxOptionCount then
                drawArrows()
            end

            currentKey = nil
            currentDesc = nil

            if IsDisabledControlJustPressed(0, keys.down) or IsDisabledControlJustPressed(0, keys.mdown) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                if menus[currentMenu].currentOption < optionCount then
                    menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
                else
                    menus[currentMenu].currentOption = 1
                end
            elseif IsDisabledControlJustPressed(0, keys.up) or IsDisabledControlJustPressed(0, keys.mup) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                if menus[currentMenu].currentOption > 1 then
                    menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
                else
                    menus[currentMenu].currentOption = optionCount
                end
            elseif IsDisabledControlJustPressed(0, keys.left) then
                currentKey = keys.left
            elseif IsDisabledControlJustPressed(0, keys.right) then
                currentKey = keys.right
            elseif IsDisabledControlJustPressed(0, keys.select) then
                currentKey = keys.select
            elseif IsDisabledControlJustPressed(0, keys.back) then
                if menus[menus[currentMenu].previousMenu] then
                    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    menus[currentMenu].closeCallback()
                    setMenuVisible(menus[currentMenu].previousMenu, true)
                else
                    JayMenu.CloseMenu()
                end
            end

            optionCount = 0
        end
    end
end

function JayMenu.SetMenuWidth(id, width)
    setMenuProperty(id, 'width', width)
end

function JayMenu.SetMenuX(id, x)
    setMenuProperty(id, 'x', x)
end

function JayMenu.SetMenuY(id, y)
    setMenuProperty(id, 'y', y)
end

function JayMenu.SetMenuMaxOptionCountOnScreen(id, count)
    setMenuProperty(id, 'maxOptionCount', count)
end

function JayMenu.SetTitleColor(id, r, g, b, a)
    setMenuProperty(id, 'titleColor', { r, g, b, a or menus[id].titleColor[4] })
end

function JayMenu.SetTitleBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, 'titleBackgroundColor', { r, g, b, a or menus[id].titleBackgroundColor[4] })
end

function JayMenu.UseSpriteAsBackground(id, textDict, sprite, r, g, b, a, stillDrawText)
    if stillDrawText then setMenuProperty(id, 'titleFont', "~sprite~") else setMenuProperty(id, 'titleFont', "!sprite!") end
    setMenuProperty(id, 'titleColor', { textDict, sprite })
    setMenuProperty(id, 'titleBackgroundColor', { r, g, b, a or menus[id].titleBackgroundColor[4] })
end

function JayMenu.SetSubTitle(id, text)
    setMenuProperty(id, 'subTitle', string.upper(text))
end

function JayMenu.SetMenuBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, 'menuBackgroundColor', { r, g, b, a or menus[id].menuBackgroundColor[4] })
end

function JayMenu.SetMenuTextColor(id, r, g, b, a)
    setMenuProperty(id, 'menuTextColor', { r, g, b, a or menus[id].menuTextColor[4] })
end

function JayMenu.SetMenuSubTextColor(id, r, g, b, a)
    setMenuProperty(id, 'menuSubTextColor', { r, g, b, a or menus[id].menuSubTextColor[4] })
end

function JayMenu.SetMenuFocusColor(id, r, g, b, a)
    setMenuProperty(id, 'menuFocusColor', { r, g, b, a or menus[id].menuFocusColor[4] })
end

function JayMenu.SetMenuButtonPressedSound(id, name, set)
    setMenuProperty(id, 'buttonPressedSound', { ['name'] = name, ['set'] = set })
end

local currentTattoos = {}
local opacity = 1
local scaleType = nil
local scaleString = ""
local show = true

function DrawTattoo(collection, name)
    local maxCount = 0
    ClearPedDecorations(PlayerPedId())

    for k, v in next, (currentTattoos) do
        if v.Count ~= nil then
            for i = 1, v.Count do
                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                maxCount = maxCount + 1
            end
        else
            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
            maxCount = maxCount + 1
        end
    end

    if maxCount <= 60 then
        for i = 1, opacity do
            SetPedDecoration(PlayerPedId(), collection, name)
        end
    end
end

function GetNaked()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 252,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 15,
                ['pants_1'] = 21,
                ['pants_2'] = 0,
                ["mask_1"] = 0,
                ['bproof_1'] = 0,
                ["bproof_2"] = 0,
                ["mask_2"] = 0,
                ["helmet_1"] = -1,
                ["helmet_2"] = 0
            })
        else
            TriggerEvent('skinchanger:loadClothes', skin, {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 15,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 15,
                ['pants_1'] = 15,
                ['bproof_1'] = 0,
                ["bproof_2"] = 0,
                ['pants_2'] = 0,
                ["mask_1"] = 0,
                ["mask_2"] = 0,
                ["helmet_1"] = -1,
                ["helmet_2"] = 0
            })
        end
    end);
end

function ResetSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end);

    ClearPedDecorations(PlayerPedId())

    for k, v in next, (currentTattoos) do
        if v.Count ~= nil then
            for i = 1, v.Count do
                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
            end
        else
            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
        end
    end
end

function ReqTexts(text, slot)
    RequestAdditionalText(text, slot)
    while not HasAdditionalTextLoaded(slot) do
        Wait(0)
    end
end

function OpenTattooShop()
    JayMenu.OpenMenu("tattoo")
    FreezeEntityPosition(PlayerPedId(), true)
    GetNaked()
    ReqTexts("TAT_MNU", 9)
end

function CloseTattooShop()
    ClearAdditionalText(9, 1)
    FreezeEntityPosition(PlayerPedId(), false)
    EnableAllControlActions(0)
    opacity = 1
    ResetSkin()
    return true
end

function ButtonPress()
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function IsMenuOpen()
    return (JayMenu.IsMenuOpened('tattoo') or string.find(tostring(JayMenu.CurrentMenu() or ""), "ZONE_"))
end

function BuyTattoo(collection, name, label, price)
    local maxCount = 0

    for k, v in next, (currentTattoos) do
        if v.Count ~= nil then
            for i = 1, v.Count do
                maxCount = maxCount + 1
            end
        else
            maxCount = maxCount + 1
        end
    end

    if maxCount <= 60 then
        ESX.TriggerServerCallback('SmallTattoos:PurchaseTattoo', function(success)
            if success then
                table.insert(currentTattoos, { collection = collection, nameHash = name, Count = opacity })
            end
        end, currentTattoos, price, { collection = collection, nameHash = name, Count = opacity }, GetLabelText(label))
    else
        Config.HUD.Notify({
            title = 'Information',
            text = 'Du hast zu viele Tattoos/Stärke!',
            type = 'info',
            time = 5000,
        })
    end
end

function RemoveTattoo(name, label)
    for k, v in next, (currentTattoos) do
        if v.nameHash == name then
            table.remove(currentTattoos, k)
        end
    end

    TriggerServerEvent("SmallTattoos:RemoveTattoo", currentTattoos)
    Config.HUD.Notify({
        title = 'Information',
        text = 'Tattoo: ' .. GetLabelText(label) .. ' Entfernt!',
        type = 'info',
        time = 5000,
    })
end

function CreateScale(sType)
    if scaleString ~= sType and sType == "Control" then
        scaleType = setupScaleform2("instructional_buttons", "Stärke Ändern", { 90, 89 }, "Tätowieren/Entfernen", 191)
        scaleString = sType
    end
end

CreateThread(function()
    JayMenu.CreateMenu("tattoo", " ", function()
        return CloseTattooShop()
    end);
    JayMenu.SetSubTitle('tattoo', "Kategorien")

    for k, v in next, (Config.Server.Tatoo.TattooCats) do
        JayMenu.CreateSubMenu(v[1], "tattoo", v[2])
        JayMenu.SetSubTitle(v[1], v[2])
    end

    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local CanSleep, inRange = true, false
        if not IsMenuOpen() then
            for k, v in next, (Config.Server.Tatoo.Shops) do
                local distance = #(coords - vec3(v.x, v.y, v.z))

                if distance < 10 then
                    CanSleep, inRange = false, true
                    Text(v.x, v.y, v.z + 1.0, "TATOOWIERER", 255, 255, 255, 0.3)

                    Utils.marker({
                        type = 22,
                        position = vec3(v.x, v.y, v.z),
                        size = vec3(0.9, 0.9, 0.9),
                        color = Config.Server.color
                    })

                    Utils.marker({
                        type = 27,
                        position = vec3(v.x, v.y,
                            v.z - 0.9),
                        size = vec3(1.5, 1.5, 1.5),
                        color = Config.Server.color
                    })
                end

                if distance < 2.5 then
                    CanSleep, inRange = false, true

                    exports[GetCurrentResourceName()]:showE("TATOOWIERER")

                    if not IsPedInAnyVehicle(PlayerPedId(), false) then
                        if JayMenu.IsMenuOpened('tattoo') then
                        end

                        DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)

                        if IsControlJustPressed(0, 38) then
                            OpenTattooShop()
                        end
                    end
                end
            end
        end

        if IsMenuOpen() then
            DisableAllControlActions(0)
            EnableControlAction(1, 1, true)
            EnableControlAction(1, 2, true)
            CanSleep = false
        end

        if JayMenu.IsMenuOpened('tattoo') then
            CanSleep = false
            for k, v in next, (Config.Server.Tatoo.TattooCats) do
                JayMenu.MenuButton(v[2], v[1])
            end
            ClearPedDecorations(PlayerPedId())
            for k, v in next, (currentTattoos) do
                if v.Count ~= nil then
                    for i = 1, v.Count do
                        SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                    end
                else
                    SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                end
            end
            JayMenu.Display()
        end
        for k, v in next, (Config.Server.Tatoo.TattooCats) do
            if JayMenu.IsMenuOpened(v[1]) then
                CreateScale("Control")
                CanSleep = false
                DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
                if IsDisabledControlJustPressed(0, 90) then
                    ButtonPress()
                    if opacity == 10 then
                        opacity = 10
                    else
                        opacity = opacity + 1
                    end
                end
                if IsDisabledControlJustPressed(0, 89) then
                    ButtonPress()
                    if opacity == 1 then
                        opacity = 1
                    else
                        opacity = opacity - 1
                    end
                end
                for _, tattoo in next, (Config.Server.Tatoo.AllTattooList) do
                    if tattoo.Zone == 'ZONE_DEGRADE' and string.find(tattoo.Name, '_M_') then
                        tattoo.HashNameMale = GetHashKey(tattoo.Name)
                    elseif tattoo.Zone == 'ZONE_DEGRADE' and string.find(tattoo.Name, '_F_') then
                        tattoo.HashNameFemale = GetHashKey(tattoo.Name)
                    end
                    if tattoo.Zone == v[1] then
                        if GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') then
                            if tattoo.HashNameMale ~= '' then
                                local found = false
                                local count = 0
                                for k, v in next, (currentTattoos) do
                                    if v.nameHash == tattoo.HashNameMale then
                                        found = true
                                        count = v.Count
                                        break
                                    end
                                end
                                if found then
                                    local clicked, hovered = JayMenu.SpriteButton(
                                        GetLabelText(tattoo.Name) .. ' Stärke: ' .. count, "commonmenu",
                                        "shop_tattoos_icon_a", "shop_tattoos_icon_b")
                                    if clicked then
                                        RemoveTattoo(tattoo.HashNameMale, tattoo.Name)
                                    end
                                else
                                    if tattoo.Zone == 'ZONE_DEGRADE' and string.find(tattoo.Name, '_M_') then
                                        local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                            math.ceil(tattoo.Price / 20)
                                        local clicked, hovered = JayMenu.Button('Haar Übergang',
                                            "~HUD_COLOUR_GREENDARK~$" .. price)
                                        if clicked then
                                            BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
                                        elseif hovered then
                                            DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
                                        end
                                    end
                                    if GetLabelText(tattoo.Name) ~= 'NULL' then
                                        if tattoo.Zone ~= 'ZONE_DEGRADE' then
                                            local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                                math.ceil(tattoo.Price / 20)
                                            local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name),
                                                "~HUD_COLOUR_GREENDARK~$" .. price)
                                            if clicked then
                                                BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
                                            elseif hovered then
                                                DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
                                            end
                                        end
                                    else
                                        if tattoo.Zone ~= 'ZONE_DEGRADE' then
                                            local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                                math.ceil(tattoo.Price / 20)
                                            local clicked, hovered = JayMenu.Button('Haar Übergang',
                                                "~HUD_COLOUR_GREENDARK~$" .. price)
                                            if clicked then
                                                BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
                                            elseif hovered then
                                                DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if tattoo.HashNameFemale ~= '' then
                                local found = false
                                local count = 0
                                for k, v in next, (currentTattoos) do
                                    if v.nameHash == tattoo.HashNameFemale then
                                        found = true
                                        count = v.Count
                                        break
                                    end
                                end
                                if found then
                                    local clicked, hovered = JayMenu.SpriteButton(
                                        GetLabelText(tattoo.Name) .. ' Stärke: ' .. count, "commonmenu",
                                        "shop_tattoos_icon_a", "shop_tattoos_icon_b")
                                    if clicked then
                                        RemoveTattoo(tattoo.HashNameFemale, tattoo.Name)
                                    end
                                else
                                    if tattoo.Zone == 'ZONE_DEGRADE' and string.find(tattoo.Name, '_F_') then
                                        local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                            math.ceil(tattoo.Price / 20)
                                        local clicked, hovered = JayMenu.Button('Haar Übergang',
                                            "~HUD_COLOUR_GREENDARK~$" .. price)
                                        if clicked then
                                            BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
                                        elseif hovered then
                                            DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
                                        end
                                    end
                                    if GetLabelText(tattoo.Name) ~= 'NULL' then
                                        if tattoo.Zone ~= 'ZONE_DEGRADE' then
                                            local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                                math.ceil(tattoo.Price / 20)
                                            local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name),
                                                "~HUD_COLOUR_GREENDARK~$" .. price)
                                            if clicked then
                                                BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
                                            elseif hovered then
                                                DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
                                            end
                                        end
                                    else
                                        if tattoo.Zone ~= 'ZONE_DEGRADE' then
                                            local price = math.ceil(tattoo.Price / 20) == 0 and 100 or
                                                math.ceil(tattoo.Price / 20)
                                            local clicked, hovered = JayMenu.Button('Haar Übergang',
                                                "~HUD_COLOUR_GREENDARK~$" .. price)
                                            if clicked then
                                                BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
                                            elseif hovered then
                                                DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                JayMenu.Display()
            end
        end

        if not show and inRange then
            show = true
        elseif show and not inRange then
            show = false
        end

        if CanSleep then
            Wait(500)
        end
    end
end);

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

function setupScaleform2(scaleform, message2, buttons, message3, button2)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, buttons[1], true))
    Button(GetControlInstructionalButton(2, buttons[2], true))
    ButtonMessage(message2)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, button2, true))
    ButtonMessage(message3)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function setupScaleform(scaleform, message, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

-----------------------------------------------------------------------------
-----------------------------------EMOTES------------------------------------
-----------------------------------------------------------------------------

RegisterKeyMapping('emotemenu', 'Emote Menu', 'keyboard', 'b')

RegisterCommand('emotemenu', function()
    local ped = PlayerPedId()
    if not IsNuiFocused() and not IsPedInAnyVehicle(ped, true) and not isCameraActive and Utils.CanOpenUI() and not show then
        SendNUIMessage({
            a = 'emoteRad',
            toggle = true,
        })
        Wait(100)
        SetNuiFocus(true, true)
    end
end, false)

local emotes = {
    [1] = {
        animDict = 'custom@dab',
        animName = "dab",
    },

    [2] = {
        animDict = 'custom@dancemoves',
        animName = "dancemoves",
    },

    [3] = {
        animDict = 'custom@disco_dance',
        animName = "disco_dance",
    },

    [4] = {
        animDict = 'custom@electroshuffle',
        animName = "electroshuffle",
    },

    [5] = {
        animDict = 'custom@floss',
        animName = "floss",
    },

    [6] = {
        animDict = 'custom@take_l',
        animName = "take_l",
    },

    [7] = {
        animDict = 'custom@toosie_slide',
        animName = "toosie_slide",
    },

    [8] = {
        animDict = 'custom@hitit',
        animName = "hitit",
    },
}

RegisterNuiCallback("emote", function(emote)
    SetNuiFocus(false, false)
    local playerPed = PlayerPedId()
    local animDict, animName
    isEmoting = true

    animDict = emotes[emote].animDict
    animName = emotes[emote].animName

    if animDict and animName then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

        CreateThread(function()
            while isEmoting do
                Wait(0)
                exports[GetCurrentResourceName()]:showE("um das Emote abzubrechen", "X")
                if IsControlJustPressed(0, 73) then
                    ClearPedTasks(playerPed)
                    isEmoting = false
                end
            end
        end);
    end
end);

-----------------------------------------------------------------------------
---------------------------------HELP NOTIFY---------------------------------
-----------------------------------------------------------------------------

exports('showE', function(m, btn)
    if not btn then btn = 'E' end
    timer = GetGameTimer()
    if not isOpene then
        isOpene = true
        SendNUIMessage({
            a = "enablepress",
            enable = true,
            message = m,
            btn = btn
        })
        CreateThread(function()
            while timer + 100 >= GetGameTimer() do Wait(100) end
            isOpene = false
            Wait(0)
            if not isOpene then
                SendNUIMessage({
                    a = "enablepress",
                    enable = false,
                    message = ''
                })
            end
        end);
    end
end);

-----------------------------------------------------------------------------
-------------------------------TOP KILLS PEDS--------------------------------
-----------------------------------------------------------------------------

local spawnedPeds = {}
local ModrollPeds = {}

function spawnPeds(peds)
    for _, spawnedPed in next, (spawnedPeds) do
        if spawnedPed.ped and DoesEntityExist(spawnedPed.ped) then
            DeleteEntity(spawnedPed.ped)
        end
    end
    spawnedPeds = {}

    Wait(500)

    CreateThread(function()
        while true do
            local sleep = 500

            local pedModel = GetHashKey("mp_m_freemode_01")
            RequestModel(pedModel)

            while not HasModelLoaded(pedModel) do
                Wait(1)
            end

            for _, pedData in next, (peds) do
                pedData.position = Config.Server.ScorePeds.Spawns[pedData.rank]

                if Config.Server.safezone.toggle then
                    sleep = 0

                    if not pedData.Loaded then
                        pedData.ped = CreatePed(4, pedModel, pedData.position.x, pedData.position.y, pedData.position.z,
                            pedData.position.w, false, true)
                        FreezeEntityPosition(pedData.ped, true)
                        SetEntityInvincible(pedData.ped, true)
                        SetBlockingOfNonTemporaryEvents(pedData.ped, true)

                        if pedData.rank == 1 then
                            if not HasAnimDictLoaded('rcmbarry') then
                                RequestAnimDict('rcmbarry')
                                repeat Wait(1) until HasAnimDictLoaded('rcmbarry')
                            end
                            TaskPlayAnim(pedData.ped, 'rcmbarry', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                        else
                            TaskStartScenarioInPlace(pedData.ped, pedData.scenario or 'WORLD_HUMAN_GUARD_STAND', 0, true)
                        end

                        if pedData.skin then
                            Skin(pedData.ped, pedData.skin)
                        end

                        pedData.Loaded = true

                        -- Füge das neue Ped zur Liste hinzu
                        table.insert(spawnedPeds, {
                            ped = pedData.ped,
                            Loaded = pedData.Loaded
                        })
                    end
                else
                    if pedData.ped then
                        if DoesEntityExist(pedData.ped) then
                            DeleteEntity(pedData.ped)
                            pedData.ped = nil
                            pedData.Loaded = false
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end);
end

local function spawnMidrollPed(peds)
    for _, spawnedPed in next, (ModrollPeds) do
        if spawnedPed.ped and DoesEntityExist(spawnedPed.ped) then
            DeleteEntity(spawnedPed.ped)
        end
    end
    ModrollPeds = {}

    Wait(500)

    CreateThread(function()
        while true do
            local sleep = 500

            local pedModel = GetHashKey("mp_m_freemode_01")
            RequestModel(pedModel)

            while not HasModelLoaded(pedModel) do
                Wait(1)
            end

            for _, pedData in next, (peds) do
                pedData.position = Config.Server.ScorePeds.midrollPed[1]

                if Config.Server.safezone.toggle then
                    sleep = 0

                    if not pedData.Loaded then
                        pedData.ped = CreatePed(4, pedModel, pedData.position.x, pedData.position.y, pedData.position.z,
                            pedData.position.w, false, true)
                        FreezeEntityPosition(pedData.ped, true)
                        SetEntityInvincible(pedData.ped, true)
                        SetBlockingOfNonTemporaryEvents(pedData.ped, true)

                        if pedData.rank == 1 then
                            if not HasAnimDictLoaded('rcmbarry') then
                                RequestAnimDict('rcmbarry')
                                repeat Wait(1) until HasAnimDictLoaded('rcmbarry')
                            end
                            TaskPlayAnim(pedData.ped, 'rcmbarry', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                        else
                            TaskStartScenarioInPlace(pedData.ped, pedData.scenario or 'WORLD_HUMAN_GUARD_STAND', 0, true)
                        end

                        if pedData.skin then
                            Skin(pedData.ped, pedData.skin)
                        end

                        pedData.Loaded = true

                        table.insert(ModrollPeds, {
                            ped = pedData.ped,
                            Loaded = pedData.Loaded
                        })
                    end
                else
                    if pedData.ped then
                        if DoesEntityExist(pedData.ped) then
                            DeleteEntity(pedData.ped)
                            pedData.ped = nil
                            pedData.Loaded = false
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end);
end

local function updatePedText(peds)
    CreateThread(function()
        while true do
            local sleep = 500
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, pedData in next, (peds) do
                if pedData.position then
                    local dist = #(playerCoords - vec3(pedData.position.x, pedData.position.y, pedData.position.z))

                    if dist < 15 then
                        sleep = 0
                        Text(-2266.6208, 3217.0803, 32.8102 + 2.0, Config.Server.ScorePeds.Texts.title, 255, 255, 255,
                            0.8)
                        Text(pedData.position.x, pedData.position.y, pedData.position.z + 1.2,
                            '[#<font color="#' ..
                            Config.Server.ScorePeds.Colors[pedData.rank] ..
                            '">' .. pedData.rank .. '</font>]~w~ ' .. pedData.name, 255, 255, 255, 0.4)
                        Text(pedData.position.x, pedData.position.y, pedData.position.z + 1.0,
                            Config.Server.ScorePeds.Texts.kills:format(pedData.kills), 255, 255, 255, 0.3)
                    end
                end
            end
            Wait(sleep)
        end
    end);
end

local function updateMidrollText(peds)
    CreateThread(function()
        while true do
            local sleep = 500
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, pedData in next, (peds) do
                if pedData.position then
                    local dist = #(playerCoords - vec3(pedData.position.x, pedData.position.y, pedData.position.z))

                    if dist < 15 then
                        sleep = 0
                        Text(pedData.position.x, pedData.position.y, pedData.position.z + 1.2, pedData.name, 255, 255,
                            255, 0.4)
                        Text(pedData.position.x, pedData.position.y, pedData.position.z + 1.0,
                            Config.Server.ScorePeds.Texts.midrolls:format(pedData.midrolls), 255, 255, 255, 0.3)
                    end
                end
            end
            Wait(sleep)
        end
    end);
end

RegisterNetEvent("updatePeds", function(peds, PlayerMidrolls)
    repeat
        Wait(100)
    until ESX.IsPlayerLoaded()

    spawnPeds(peds)
    spawnMidrollPed(PlayerMidrolls)

    updatePedText(peds)
    updateMidrollText(PlayerMidrolls)
end);

-----------------------------------------------------------------------------
-----------------------------------MATCH-------------------------------------
-----------------------------------------------------------------------------

local skyCam = nil
local startedCam = false

function StartMatchCam(center, radius, height, duration)
    if skyCam then
        DestroyCam(skyCam, false)
    end

    skyCam = CreateCamWithParams(
        'DEFAULT_SCRIPTED_CAMERA',
        center.x + radius,
        center.y + radius,
        center.z + height,
        -135.0,
        0.0,
        0.0,
        90.0,
        false,
        2
    )

    SetCamActive(skyCam, true)
    RenderScriptCams(true, false, 0, true, false)

    angle = 0.0
    startedCam = true

    CreateThread(function()
        while startedCam do
            if GetGameTimer() - GetGameTimer() < duration then
                angle = angle + 0.5
                if angle > 360 then angle = angle - 360 end

                local camX = center.x + math.cos(math.rad(angle)) * radius
                local camY = center.y + math.sin(math.rad(angle)) * radius

                SetCamCoord(skyCam, camX, camY, center.z + height)
                PointCamAtCoord(skyCam, center.x, center.y, center.z)
                Wait(10)
            end
        end
    end);

    while startedCam do
        if angle >= 160 then
            DoScreenFadeOut(1000)
            Wait(1000)

            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(skyCam, false)

            DoScreenFadeIn(1000)
            break
        end
        Wait(10)
    end

    angle = 0.0
    startedCam = false
end

RegisterCommand("1vs1", function()
    if not isinMatch then
        SendNUIMessage({
            a = "1vs1Modal",
            boolean = true,
            matches = Config.pvp.matches
        })
        Wait(100)
        SetNuiFocus(true, true)
    end
end, false);

RegisterNetEvent("1vs1:requestWithID", function(id)
    SendNUIMessage({
        a = "1vs1Modal",
        boolean = true,
        matches = Config.pvp.matches,
        id = id
    })
    Wait(100)
    SetNuiFocus(true, true)
end);

RegisterNuiCallback("requestMatch", function(data)
    ESX.TriggerServerCallback('1vs1:requestMatch', function(data2)
        if data2.toggle then
            SendNUIMessage({
                a = "match:loadWaiter"
            })
        else
            Config.HUD.Notify({
                title = '1vs1',
                text = data2.message,
                type = 'error',
                time = 5000,
            })
        end
    end, data.target, data and data.matchIndex or 1, data.rounds)
end);

RegisterNetEvent("1vs1:removeUI", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        a = "1vs1Modal",
        boolean = false,
    })
end);

RegisterNetEvent("1vs1:acceptMatch", function(matchIndex, posIndex)
    local middle = Config.pvp.matches[tostring(matchIndex)].middle
    local coords = Config.pvp.matches[tostring(matchIndex)].positions[posIndex]

    Respawn(coords, true)
    SetEntityHeading(PlayerPedId(), coords[4])
    FreezeEntityPosition(PlayerPedId(), true)
    removeDeathScreen()

    SendNUIMessage({
        a = "match:showReady",
    })

    StartMatchCam(vec3(middle.x, middle.y, middle.z + 10), 35.0, 1.0, 10000)

    NetworkSetFriendlyFireOption(false)
    SetEntityHealth(PlayerPedId(), 200)
    SetPedArmour(PlayerPedId(), 100)

    isinMatch = true
    local showCD = true
    local time = 3
    local scale = 0
    scale = SetCountdown(time, 255, 30, 30)
    PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', 1)
    CreateThread(function()
        while showCD do
            Wait(1000)
            if time > 1 then
                time = time - 1
                PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', 1)
                scale = SetCountdown(time, 255, 30, 30)
            elseif time == 1 then
                time = time - 1
                PlaySoundFrontend(-1, 'Oneshot_Final', 'MP_MISSION_COUNTDOWN_SOUNDSET', 1)
                scale = SetCountdown('GOOOOO', 255, 30, 30)
                NetworkSetFriendlyFireOption(true)
                FreezeEntityPosition(PlayerPedId(), false)
            else
                showCD = false
            end
        end
    end);
    CreateThread(function()
        while showCD do
            Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end);
end);

RegisterNuiCallback("denyMatch", function(id)
    TriggerServerEvent("match:deny", id)
end);

CallFunction = function(scaleform, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = { ... }
    for i = 1, #args do
        local arg = type(args[i])
        if arg == 'boolean' then
            ScaleformMovieMethodAddParamBool(args[i])
        elseif arg == 'number' then
            if not string.find(args[i], '%.') then
                ScaleformMovieMethodAddParamInt(args[i])
            else
                ScaleformMovieMethodAddParamFloat(args[i])
            end
        elseif arg == 'string' then
            ScaleformMovieMethodAddParamTextureNameString(args[i])
        end
    end
    EndScaleformMovieMethod()
end

SetCountdown = function(number, r, g, b)
    local scaleform_handle = RequestScaleformMovie('COUNTDOWN')
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Wait(0)
    end
    CallFunction(scaleform_handle, 'SET_MESSAGE', number, r, g, b, true)
    CallFunction(scaleform_handle, 'FADE_MP', number, r, g, b)
    return scaleform_handle
end

RegisterNetEvent("match:win", function(winnerkills, loserkills)
    SendNUIMessage({
        a = "match:win",
        winnerkills = winnerkills,
        loserkills = loserkills
    })

    isinMatch = false
    IsDead = false
    Respawn(Config.Server.Settings.dauermap, true)
    TriggerServerEvent("setDimension", 0)
end);

RegisterNetEvent("match:lose", function(winnerkills, loserkills)
    SendNUIMessage({
        a = "match:lose",
        winnerkills = winnerkills,
        loserkills = loserkills
    })

    isinMatch = false
    IsDead = false
    Respawn(Config.Server.Settings.dauermap, true)
    TriggerServerEvent("setDimension", 0)
end);

CreateThread(function()
    while true do
        Wait(500)
        for k, v in next, (GetGamePool('CPed')) do
            if v ~= PlayerPedId() and IsPedAPlayer(v) then
                SetEntityHealth(v, 199)
                SetPedArmour(v, 99)
            end
        end
    end
end);

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) or IsPedFalling(ped) or IsPedOnVehicle(ped) then
            SetPedCanRagdoll(ped, true)
            Wait(10000)
        else
            SetPedCanRagdoll(ped, false)
        end
        Wait(100)
    end
end);

local WhitelistedRessources = { ["crimelife"] = true, ["monitor"] = true }

CreateThread(function()
    while true do
        Wait(5000)
        for k, v in next, (GetGamePool('CVehicle')) do
            if WhitelistedRessources[GetEntityScript(v)] == nil then
                if GetPlayerServerId(PlayerId()) == GetPlayerServerId(NetworkGetEntityOwner(v)) then
                    if GetEntityScript(v) ~= nil then
                        TriggerServerEvent("fg:ban:core", {
                            violation = "Vehicle Spawn Ressource: " .. GetEntityScript(v),
                            send_to_logs = true,
                        })
                        DeleteEntity(v)
                    else
                        DeleteEntity(v)
                    end
                end
            end
        end
    end
end);

-----------------------------------------------------------------------------
-------------------------------ANTI AIMBOT-----------------------------------
-----------------------------------------------------------------------------

local aimTimer = 0

function PedMoving(ped)
    if IsPedWalking(ped) or IsPedSprinting(ped) or IsPedJumping(ped) then
        return true
    end
    return false
end

CreateThread(function()
    local ThreadSleep = 0
    while true do
        Wait(ThreadSleep)
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if IsPedArmed(PlayerPedId(), 6) or IsPedArmed(PlayerPedId(), 4) then
                ThreadSleep = 0
                local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
                local targetId = NetworkGetEntityOwner(targetPed)

                if aiming then
                    if targetId ~= -1 then
                        if PedMoving(targetPed) then
                            local targetServerId = GetPlayerServerId(targetId)
                            aimTimer = aimTimer + 1
                            if aimTimer >= 1000 then
                                TriggerServerEvent("fg:ban:core", {
                                    violation = "Aimbot detected: auf " .. targetServerId,
                                    send_to_logs = true,
                                })
                                Wait(60000)
                            end
                        end
                    end
                else
                    aimTimer = 0
                end
            else
                ThreadSleep = 250
            end
        else
            ThreadSleep = 500
        end
    end
end);

-----------------------------------------------------------------------------

--------------------------------ANTIPICKUP-----------------------------------

-----------------------------------------------------------------------------

CreateThread(function()
    while true do
        Wait(2500)
        for _, pickup in next, (GetGamePool('CPickup')) do
            if DoesPickupExist(pickup) then
                DeleteEntity(pickup)
            end
        end
    end
end);

CreateThread(function()
    while true do
        Wait(10000)
        local pickupList = { "PICKUP_AMMO_BULLET_MP", "PICKUP_AMMO_FIREWORK", "PICKUP_AMMO_FLAREGUN",
            "PICKUP_AMMO_GRENADELAUNCHER", "PICKUP_AMMO_GRENADELAUNCHER_MP", "PICKUP_AMMO_HOMINGLAUNCHER",
            "PICKUP_AMMO_MG", "PICKUP_AMMO_MINIGUN", "PICKUP_AMMO_MISSILE_MP", "PICKUP_AMMO_PISTOL", "PICKUP_AMMO_RIFLE",
            "PICKUP_AMMO_RPG", "PICKUP_AMMO_SHOTGUN", "PICKUP_AMMO_SMG", "PICKUP_AMMO_SNIPER", "PICKUP_ARMOUR_STANDARD",
            "PICKUP_CAMERA", "PICKUP_CUSTOM_SCRIPT", "PICKUP_GANG_ATTACK_MONEY", "PICKUP_HEALTH_SNACK",
            "PICKUP_HEALTH_STANDARD", "PICKUP_MONEY_CASE", "PICKUP_MONEY_DEP_BAG", "PICKUP_MONEY_MED_BAG",
            "PICKUP_MONEY_PAPER_BAG", "PICKUP_MONEY_PURSE", "PICKUP_MONEY_SECURITY_CASE", "PICKUP_MONEY_VARIABLE",
            "PICKUP_MONEY_WALLET", "PICKUP_PARACHUTE", "PICKUP_PORTABLE_CRATE_FIXED_INCAR",
            "PICKUP_PORTABLE_CRATE_UNFIXED", "PICKUP_PORTABLE_CRATE_UNFIXED_INCAR",
            "PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL", "PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW",
            "PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE", "PICKUP_PORTABLE_PACKAGE", "PICKUP_SUBMARINE",
            "PICKUP_VEHICLE_ARMOUR_STANDARD", "PICKUP_VEHICLE_CUSTOM_SCRIPT", "PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW",
            "PICKUP_VEHICLE_HEALTH_STANDARD", "PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW", "PICKUP_VEHICLE_MONEY_VARIABLE",
            "PICKUP_VEHICLE_WEAPON_APPISTOL", "PICKUP_VEHICLE_WEAPON_ASSAULTSMG", "PICKUP_VEHICLE_WEAPON_COMBATPISTOL",
            "PICKUP_VEHICLE_WEAPON_GRENADE", "PICKUP_VEHICLE_WEAPON_MICROSMG", "PICKUP_VEHICLE_WEAPON_MOLOTOV",
            "PICKUP_VEHICLE_WEAPON_PISTOL", "PICKUP_VEHICLE_WEAPON_PISTOL50", "PICKUP_VEHICLE_WEAPON_SAWNOFF",
            "PICKUP_VEHICLE_WEAPON_SMG", "PICKUP_VEHICLE_WEAPON_SMOKEGRENADE", "PICKUP_VEHICLE_WEAPON_STICKYBOMB",
            "PICKUP_WEAPON_ADVANCEDRIFLE", "PICKUP_WEAPON_APPISTOL", "PICKUP_WEAPON_ASSAULTRIFLE",
            "PICKUP_WEAPON_ASSAULTSHOTGUN", "PICKUP_WEAPON_ASSAULTSMG", "PICKUP_WEAPON_AUTOSHOTGUN", "PICKUP_WEAPON_BAT",
            "PICKUP_WEAPON_BATTLEAXE", "PICKUP_WEAPON_BOTTLE", "PICKUP_WEAPON_BULLPUPRIFLE",
            "PICKUP_WEAPON_BULLPUPSHOTGUN", "PICKUP_WEAPON_CARBINERIFLE", "PICKUP_WEAPON_COMBATMG",
            "PICKUP_WEAPON_COMBATPDW", "PICKUP_WEAPON_COMBATPISTOL", "PICKUP_WEAPON_COMPACTLAUNCHER",
            "PICKUP_WEAPON_COMPACTRIFLE", "PICKUP_WEAPON_CROWBAR", "PICKUP_WEAPON_DAGGER", "PICKUP_WEAPON_DBSHOTGUN",
            "PICKUP_WEAPON_FIREWORK", "PICKUP_WEAPON_FLAREGUN", "PICKUP_WEAPON_FLASHLIGHT", "PICKUP_WEAPON_GRENADE",
            "PICKUP_WEAPON_GRENADELAUNCHER", "PICKUP_WEAPON_GUSENBERG", "PICKUP_WEAPON_GOLFCLUB", "PICKUP_WEAPON_HAMMER",
            "PICKUP_WEAPON_HATCHET", "PICKUP_WEAPON_HEAVYPISTOL", "PICKUP_WEAPON_HEAVYSHOTGUN",
            "PICKUP_WEAPON_HEAVYSNIPER", "PICKUP_WEAPON_HOMINGLAUNCHER", "PICKUP_WEAPON_KNIFE", "PICKUP_WEAPON_KNUCKLE",
            "PICKUP_WEAPON_MACHETE", "PICKUP_WEAPON_MACHINEPISTOL", "PICKUP_WEAPON_MARKSMANPISTOL",
            "PICKUP_WEAPON_MARKSMANRIFLE", "PICKUP_WEAPON_MG", "PICKUP_WEAPON_MICROSMG", "PICKUP_WEAPON_MINIGUN",
            "PICKUP_WEAPON_MINISMG", "PICKUP_WEAPON_MOLOTOV", "PICKUP_WEAPON_MUSKET", "PICKUP_WEAPON_NIGHTSTICK",
            "PICKUP_WEAPON_PETROLCAN", "PICKUP_WEAPON_PIPEBOMB", "PICKUP_WEAPON_PISTOL", "PICKUP_WEAPON_PISTOL50",
            "PICKUP_WEAPON_POOLCUE", "PICKUP_WEAPON_PROXMINE", "PICKUP_WEAPON_PUMPSHOTGUN", "PICKUP_WEAPON_RAILGUN",
            "PICKUP_WEAPON_REVOLVER", "PICKUP_WEAPON_RPG", "PICKUP_WEAPON_SAWNOFFSHOTGUN", "PICKUP_WEAPON_SMG",
            "PICKUP_WEAPON_SMOKEGRENADE", "PICKUP_WEAPON_SNIPERRIFLE", "PICKUP_WEAPON_SNSPISTOL",
            "PICKUP_WEAPON_SPECIALCARBINE", "PICKUP_WEAPON_STICKYBOMB", "PICKUP_WEAPON_STUNGUN",
            "PICKUP_WEAPON_SWITCHBLADE", "PICKUP_WEAPON_VINTAGEPISTOL", "PICKUP_WEAPON_WRENCH",
            "PICKUP_WEAPON_RAYCARBINE" }
        for a = 1, #pickupList do
            ToggleUsePickupsForPlayer(PlayerId(), GetHashKey(pickupList[a]), false)
        end
        RemoveAllPickupsOfType(GetHashKey("PICKUP_ARMOUR_STANDARD"))
        RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_ARMOUR_STANDARD"))
        RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_SNACK"))
        RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_STANDARD"))
        RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD"))
        RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW"))
    end
end);

-----------------------------------------------------------------------------
--------------------------------LEFT PEAK------------------------------------
-----------------------------------------------------------------------------
local isLeftPeekEnabled = false
local leftPeekCam = nil
local transitionTime = 250
local fov = GetGameplayCamFov() - 5.0
local camFovs = {
    [0] = vec3(-0.444444444, -0.9, 0.7),
    [1] = vec3(-0.555555555, -1.5, 0.7),
    [2] = vec3(-0.666666666, -2.7, 0.7)
}

function toggleLeftPeek()
    local playerPed = PlayerPedId()

    if isLeftPeekEnabled then
        isLeftPeekEnabled = false

        if leftPeekCam then
            DestroyCam(leftPeekCam, false)
            RenderScriptCams(false, true, transitionTime, true, false)
            leftPeekCam = nil
        end

        ClearPedTasks(playerPed)
    else
        isLeftPeekEnabled = true

        local viewMode = GetFollowPedCamViewMode()

        if viewMode == 4 then return end

        defaultCamPos = camFovs[viewMode]

        updateLeftPeekCamera()
    end
end

function updateLeftPeekCamera()
    if not isLeftPeekEnabled then return end

    local playerPed = PlayerPedId()
    local camRotation = GetGameplayCamRot(2)
    local camOffset = GetOffsetFromEntityInWorldCoords(playerPed, defaultCamPos.x, defaultCamPos.y, defaultCamPos.z)

    if not leftPeekCam then
        leftPeekCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end

    SetCamFov(leftPeekCam, fov)
    SetCamCoord(leftPeekCam, camOffset.x, camOffset.y, camOffset.z)
    SetCamRot(leftPeekCam, camRotation.x, camRotation.y, camRotation.z, 2)
    SetCamActive(leftPeekCam, true)
    RenderScriptCams(true, true, transitionTime, true, false)

    ShowHudComponentThisFrame(14)
end

CreateThread(function()
    while true do
        Wait(0)

        if isLeftPeekEnabled and leftPeekCam then
            if IsPlayerFreeAiming(PlayerId()) then
                updateLeftPeekCamera()
            else
                toggleLeftPeek()
            end
        end
    end
end);

RegisterCommand("leftpeek", function()
    if IsPlayerFreeAiming(PlayerId()) then
        toggleLeftPeek()
    end
end, false)

RegisterKeyMapping("leftpeek", "Toggle Left Peek", "keyboard", "G")

-- Mainmenu
RegisterKeyMapping("mainmenu", "Game Menü", "keyboard", "f1")

RegisterNuiCallback("mainmenu:requestBattlepass", function(name, cb)
    ESX.TriggerServerCallback('mainmenu:GetBattlepass', function(data)
        cb({
            rewards = Config.Battlepass.Levels,
            level = data.level,
            premium = data.premium,

            Quests = Config.Battlepass.quests,
            playerQuests = Quests,
            collected_quest = collected_quest,

            collected = data.collected,
            collected_premium = data.collected_premium
        })
    end)
end)

RegisterNuiCallback("mainmenu:requestPVP", function(data, cb)
    ESX.TriggerServerCallback('mainmenu:GetPVP', function(data)
        cb({
            maps = Config.pvp.ffa,
            isin = pvp.ffa.isIn or pvp.gungame.isIn or Config.PlayerData.isIn,
            PrivateLobbies = PrivateLobbies,

            ffa = {
                maps = Config.pvp.ffa,
                players = data.ffa.players,
            },

            gungame = {
                maps = Config.pvp.gungame,
                players = data.gungame.players,
            },
        })
    end)
end)

RegisterNuiCallback("mainmenu:requestInventory", function(data, cb)
    cb({
        loadout = Config.PlayerData.loadout,
        items = Config.PlayerData.items,
    })
end)

RegisterNuiCallback("mainmenu:requestShop", function(data, cb)
    cb({
        loadout = Config.PlayerData.loadout,
        weapons = Config.Server.shop["WEAPONS"],
        items = Config.Server.shop["ITEMS"],
        effects = Config.Server.shop["KILLEFFECTS"],
        cases = Config.Server.shop["CASES"],

        particleDictionary = Config.Server.Settings.killeffect.particleDictionary,
        particleName = Config.Server.Settings.killeffect.particleName,
    })
end)

RegisterNuiCallback("mainmenu:requestSettings", function(data, cb)
    cb(Config.Server.Settings)
end)

RegisterNuiCallback("mainmenu:requestScoreboard", function(data, cb)
    ESX.TriggerServerCallback('mainmenu:getScoreboard', function(data)
        cb(data)
    end)
end)

RegisterNetEvent("openCase", function(index, coins)
    Config.PlayerData.coins = coins

    SendNUIMessage({
        a = "coinsUpdate",
        coins = Config.PlayerData.coins,
    })

    local rewards = Config.Server.shop["CASES"][tonumber(index)].rewards

    local rewardTypes = {}
    for k in pairs(rewards) do
        table.insert(rewardTypes, k)
    end

    local selectedType = rewardTypes[math.random(#rewardTypes)]
    local items
    local itemsCount = 1

    local selectedReward
    if selectedType == "money" then
        selectedReward = math.random(1000, 2000)
        ESX.TriggerServerCallback('cases:reward', function() end, "money", selectedReward)
    elseif selectedType == "items" then
        items = rewards.items
        local itemKeys = {}
        for itemKey in pairs(items) do
            table.insert(itemKeys, itemKey)
        end

        selectedItemKey = itemKeys[math.random(#itemKeys)]
        selectedReward = { [selectedItemKey] = items[selectedItemKey] }
        itemsCount = items[selectedItemKey]
        ESX.TriggerServerCallback('cases:reward', function() end, "item", itemsCount, selectedItemKey)
    elseif selectedType == "PREMIUM" then
        ESX.TriggerServerCallback('cases:reward', function() end, "PREMIUM")
    end

    SendNUIMessage({
        a = "case:showWin",
        money = selectedReward,
        type = selectedType,
        reward = selectedItemKey,
        itemCount = itemsCount
    })
end)

RegisterCommand("mainmenu", function()
    SendNUIMessage({
        a = "mainmenu:open",
        isin = pvp.ffa.isIn or pvp.gungame.isIn or Config.PlayerData.isIn,
        coins = Config.PlayerData.coins,
    })

    Wait(100)
    SetNuiFocus(true, true)
end, false);

-- MUTE
local mute = false

RegisterKeyMapping("mute", "Mute", "keyboard", "j")

RegisterCommand("mute", function()
    if not mute then
        mute = true
        SendNUIMessage({
            a = "mute",
            toggle = mute
        })
        TriggerServerEvent("mute:toggle", mute)

        Config.HUD.Notify({
            title = 'Mute',
            text = 'Du hast den Voicechat deaktiviert',
            type = 'success',
            time = 5000,
        })
    else
        mute = false
        SendNUIMessage({
            a = "mute",
            toggle = mute
        })
        TriggerServerEvent("mute:toggle", mute)

        Config.HUD.Notify({
            title = 'Mute',
            text = 'Du hast den Voicechat aktiviert',
            type = 'success',
            time = 5000,
        })
    end
end, false);

function DisplayBoughtScaleform(weaponName)
    local scaleform = RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
    local sec = 10

    BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

    ScaleformMovieMethodAddParamTextureNameString("NEUES LEVEL")
    ScaleformMovieMethodAddParamTextureNameString(weaponName)
    ScaleformMovieMethodAddParamInt(joaat(weaponName))
    ScaleformMovieMethodAddParamTextureNameString('')
    ScaleformMovieMethodAddParamInt(100)
    EndScaleformMovieMethod()

    PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)

    CreateThread(function()
        while sec > 0 do
            Wait(0)
            sec = sec - 0.01

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end
