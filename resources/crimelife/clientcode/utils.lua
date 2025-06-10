Utils = {}

Utils = {
    marker = function(table)
        DrawMarker(table.type, table.position.x, table.position.y, table.position.z, 0, 0, 0, 0, 0, 0, table.size.x,
            table.size.y, table.size.z, table.color.r, table.color.g, table.color.b, 100, 0, 0, 0, true, false, false,
            false)
    end,

    SpawnProtection = function()
        local keyPressed = false
        while not keyPressed do
            Wait(0)
            keyPressed = IsControlJustPressed(0, 32) or
                IsControlJustPressed(0, 33) or
                IsControlJustPressed(0, 34) or
                IsControlJustPressed(0, 35)

            SetLocalPlayerAsGhost(true)
            SetGhostedEntityAlpha(128)
            SetEntityAlpha(PlayerPedId(), 128, false)
        end

        ResetEntityAlpha(PlayerPedId())
        SetLocalPlayerAsGhost(false)
        NetworkSetFriendlyFireOption(true)
    end,

    TuneVehicle = function(veh)
        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 0, GetNumVehicleMods(veh, 0) - 1, false)
        SetVehicleWindowTint(veh, 1)
    end,

    BottomText = function(txt)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(txt)
        EndTextCommandDisplayText(0.5, 0.93)
    end,

    SideText = function(txt)
        SetTextFont(4)
        SetTextScale(0.0, 0.4)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(txt)
        EndTextCommandDisplayText(0.19, 0.94)
    end,

    CanDoStuff = function()
        if openUI and not isinMatch and not Config.PlayerData.isIn and not exports[GetCurrentResourceName()]:GetPVP().gungame.isIn and not exports[GetCurrentResourceName()]:GetPVP().ffa.isIn and not exports[GetCurrentResourceName()]:GetKillzone().inZone and not exports[GetCurrentResourceName()]:GetKillzone().joined and not openAnimation then
            return true
        end

        return false
    end,

    CanOpenUI = function()
        if openUI and not openAnimation then
            return true
        end

        return false
    end,

    loadAnimDict = function(dict)
        while (not HasAnimDictLoaded(dict)) do
            RequestAnimDict(dict)
            Wait(5)
        end
    end,

    setWeapon = function(name)
        SetCurrentPedWeapon(PlayerPedId(), name, true)
    end,

    ScreenFade = function(sleep)
        DoScreenFadeOut(sleep)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        DoScreenFadeIn(sleep)
    end
}
