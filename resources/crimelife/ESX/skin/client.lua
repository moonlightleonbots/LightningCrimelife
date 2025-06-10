lastSkin, playerLoaded, cam, isCameraActive = nil, false, nil, false
local firstSpawn, zoomOffset, camOffset, heading, skinLoaded = true, 0.0, 0.0, 90.0, false
local isCameraActive2 = false

function OpenMenu(submitCb, cancelCb, restrict)
    local playerPed = PlayerPedId()

    TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);
    TriggerEvent('skinchanger:getData', function(components, maxVals)
        local elements = {}
        local _components = {}

        -- Restrict menu
        if restrict == nil then
            for i = 1, #components, 1 do
                _components[i] = components[i]
            end
        else
            for i = 1, #components, 1 do
                local found = false

                for j = 1, #restrict, 1 do
                    if components[i].name == restrict[j] then
                        found = true
                    end
                end

                if found then
                    table.insert(_components, components[i])
                end
            end
        end
        -- Insert elements
        for i = 1, #_components, 1 do
            local value = _components[i].value
            local componentId = _components[i].componentId

            if componentId == 0 then
                value = GetPedPropIndex(playerPed, _components[i].componentId)
            end

            local data = {
                label = _components[i].label,
                name = _components[i].name,
                value = value,
                min = _components[i].min,
                textureof = _components[i].textureof,
                zoomOffset = _components[i].zoomOffset,
                camOffset = _components[i].camOffset,
                type = 'slider'
            }

            for k, v in next, (maxVals) do
                if k == _components[i].name then
                    data.max = v
                    break
                end
            end

            table.insert(elements, data)
        end

        CreateSkinCam()
        zoomOffset = _components[1].zoomOffset
        camOffset = _components[1].camOffset

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
            title = 'Skin Menü',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);

            submitCb(data, menu)
            DeleteSkinCam()
            FreezeEntityPosition(PlayerPedId(), false)
        end, function(data, menu)
            menu.close()
            DeleteSkinCam()
            TriggerEvent('skinchanger:loadSkin', lastSkin)
            FreezeEntityPosition(PlayerPedId(), false)

            if cancelCb ~= nil then
                cancelCb(data, menu)
            end
        end, function(data, menu)
            local skin, components, maxVals

            TriggerEvent('skinchanger:getSkin', function(getSkin) skin = getSkin end);

            zoomOffset = data.current.zoomOffset
            camOffset = data.current.camOffset

            if skin[data.current.name] ~= data.current.value then
                -- Change skin element
                TriggerEvent('skinchanger:change', data.current.name, data.current.value)

                -- Update max values
                TriggerEvent('skinchanger:getData', function(comp, max)
                    components, maxVals = comp, max
                end);

                local newData = {}

                for i = 1, #elements, 1 do
                    newData = {}
                    newData.max = maxVals[elements[i].name]

                    if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
                        newData.value = 0
                    end

                    menu.update({ name = elements[i].name }, newData)
                end

                menu.refresh()
            end
        end, function(data, menu)
            FreezeEntityPosition(PlayerPedId(), false)
            DeleteSkinCam()
        end);
    end);
end

local function offsetPosition(x, y, z, distance)
    local object = {
        x = x + math.sin(-z * math.pi / 180) * distance,
        y = y + math.cos(-z * math.pi / 180) * distance
    }

    return object
end

local function CreationCamHead(coords, heading)
    DestroyCam(cam, true)

    if coords ~= nil then
        SetEntityCoordsNoOffset(PlayerPedId(), coords)
    end

    if heading ~= nil then
        SetEntityHeading(PlayerPedId(), heading)
    end

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')

    local player = {
        position = GetEntityCoords(PlayerPedId())
    }

    local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.50, 0.0)
    local offset = offsetPosition(player.position.x, player.position.y, GetEntityHeading(PlayerPedId()), 2.10)
    local targetPositionFly = vector3(offset.x, offset.y, player.position.z + 0.5)
    local targetPositionPoint = vector3(player.position.x, player.position.y, player.position.z + 0.3)

    if targetPositionPoint == nil then
        return
    end

    SetCamCoord(cam, targetPositionFly)
    PointCamAtCoord(cam, targetPositionPoint)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 500, true, true)
end

function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamCoord(cam, GetEntityCoords(playerPed))
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 0.0)
end

function CreateSkinCam2()
    TriggerServerEvent("setDimension", math.random(2, 199999))
    isCameraActive2 = true
    CreationCamHead(vector3(-811.7537, 175.1988, 76.7453), 111.3889)
    Wait(250)
    hudForce = true
    SendNUIMessage({
        a = "hud:toggle",
        toggle = false
    })
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

function DeleteSkinCam2()
    isCameraActive = false
    isCameraActive2 = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil

    Wait(100)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
        TriggerServerEvent("RestoreLoadout")
    end);

    Wait(250)
    CreateThread(function()
        DoScreenFadeOut(750)
        while not IsScreenFadedOut() do
            Wait(0)
        end
    end);
    TriggerServerEvent("setDimension", 0)

    Wait(1200)
    SendNUIMessage({
        a = "firstJoin"
    })
    Wait(100)
    SetNuiFocus(true, true)
end

CreateThread(function()
    local sleep = 500
    while true do
        if isCameraActive then
            sleep             = 3

            local playerPed   = PlayerPedId()
            local coords      = GetEntityCoords(playerPed)

            local angle       = heading * math.pi / 180.0
            local theta       = {
                x = math.cos(angle),
                y = math.sin(angle)
            }

            local pos         = {
                x = coords.x + (zoomOffset * theta.x),
                y = coords.y + (zoomOffset * theta.y)
            }

            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end

            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }

            local posToLook = {
                x = coords.x + (zoomOffset * thetaToLook.x),
                y = coords.y + (zoomOffset * thetaToLook.y)
            }

            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
            exports[GetCurrentResourceName()]:showE('A UND D ZUM DREHEN', ".")
        else
            sleep = 500
        end

        Wait(sleep)
    end
end);

CreateThread(function()
    while true do
        Wait(0)

        if isCameraActive or isCameraActive2 then
            DisableControlAction(0, 8, true)
            DisableControlAction(0, 9, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 59, true)
            DisableControlAction(0, 72, true)
            DisableControlAction(0, 71, true)
            DisableControlAction(0, 77, true)
            DisableControlAction(0, 78, true)

            if IsDisabledControlPressed(0, 34) then -- Numpad 4
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 1.9)
            end

            if IsDisabledControlPressed(0, 35) then -- Numpad 6
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 1.9)
            end
        else
            Wait(500)
        end
    end
end);

function OpenSaveableMenu(submitCb, cancelCb, restrict)
    TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);
    FreezeEntityPosition(PlayerPedId(), true)

    OpenMenu(function(data, menu)
        menu.close()
        DeleteSkinCam()

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx_skin:save', skin)
            TriggerServerEvent("RestoreLoadout")
            SetPedInfiniteAmmo(PlayerPedId(), true)
            Wait(125)
            FreezeEntityPosition(PlayerPedId(), false)

            if submitCb ~= nil then
                submitCb(data, menu)
            end
        end);
    end, cancelCb, restrict)
end

function OpenSaveableMenu2(submitCb, cancelCb, restrict)
    TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);

    openUI = false

    SendNUIMessage({
        a = "noExit"
    })

    OpenMenu2(function(data, menu)
        menu.close()
        DeleteSkinCam2()

        if submitCb ~= nil then
            submitCb(data, menu)
        end
    end, cancelCb, restrict)
end

AddEventHandler('esx:onPlayerSpawn', function()
    CreateThread(function()
        while not playerLoaded do
            Wait(100)
        end

        if firstSpawn then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    TriggerEvent('skinchanger:loadSkin', { sex = 0 })
                    Wait(100)
                    skinLoaded = true
                    TriggerEvent("esx_skin:openSaveableMenu")
                else
                    TriggerEvent('skinchanger:loadSkin', skin)
                    Wait(100)
                    skinLoaded = true
                end
            end);

            firstSpawn = false
        end
    end);
end);

AddEventHandler('esx_skin:resetFirstSpawn', function()
    firstSpawn = true
    skinLoaded = false
end);

AddEventHandler('esx_skin:playerRegistered', function()
    CreateThread(function()
        while not playerLoaded do
            Wait(100)
        end

        if firstSpawn then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                    Wait(100)
                    skinLoaded = true
                else
                    TriggerEvent('skinchanger:loadSkin', skin)
                    Wait(100)
                    skinLoaded = true
                end
            end);

            firstSpawn = false
        end
    end);
end);

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    playerLoaded = true
end);

AddEventHandler('esx_skin:getLastSkin', function(cb) cb(lastSkin) end);
AddEventHandler('esx_skin:setLastSkin', function(skin) lastSkin = skin end);

RegisterNetEvent('esx_skin:openMenu', function(submitCb, cancelCb)
    OpenMenu(submitCb, cancelCb, nil)
end);

RegisterNetEvent('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
    OpenMenu(submitCb, cancelCb, restrict)
end);

RegisterNetEvent('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
    OpenSaveableMenu(submitCb, cancelCb, nil)
end);

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
    OpenSaveableMenu(submitCb, cancelCb, restrict)
end);

RegisterNetEvent('esx_skin:requestSaveSkin', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:responseSaveSkin', skin)
    end);
end);

function OpenMenu2(submitCb, cancelCb, restrict)
    local playerPed = PlayerPedId()

    TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);
    TriggerEvent('skinchanger:getData', function(components, maxVals)
        local elements = {}
        local _components = {}

        -- Restrict menu
        if restrict == nil then
            for i = 1, #components, 1 do
                _components[i] = components[i]
            end
        else
            for i = 1, #components, 1 do
                local found = false

                for j = 1, #restrict, 1 do
                    if components[i].name == restrict[j] then
                        found = true
                    end
                end

                if found then
                    table.insert(_components, components[i])
                end
            end
        end
        -- Insert elements
        for i = 1, #_components, 1 do
            local value = _components[i].value
            local componentId = _components[i].componentId

            if componentId == 0 then
                value = GetPedPropIndex(playerPed, _components[i].componentId)
            end

            local data = {
                label = _components[i].label,
                name = _components[i].name,
                value = value,
                min = _components[i].min,
                textureof = _components[i].textureof,
                zoomOffset = _components[i].zoomOffset,
                camOffset = _components[i].camOffset,
                type = 'slider'
            }

            for k, v in next, (maxVals) do
                if k == _components[i].name then
                    data.max = v
                    break
                end
            end

            table.insert(elements, data)
        end

        CreateSkinCam2()
        zoomOffset = _components[1].zoomOffset
        camOffset = _components[1].camOffset

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
            title = 'Skin Menü',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end);
            submitCb(data, menu)
        end, function(data, menu)
            menu.close()
            TriggerEvent('skinchanger:loadSkin', lastSkin)
            if cancelCb ~= nil then
                cancelCb(data, menu)
            end
        end, function(data, menu)
            local skin, components, maxVals

            TriggerEvent('skinchanger:getSkin', function(getSkin) skin = getSkin end);

            zoomOffset = data.current.zoomOffset
            camOffset = data.current.camOffset

            if skin[data.current.name] ~= data.current.value then
                -- Change skin element
                TriggerEvent('skinchanger:change', data.current.name, data.current.value)

                -- Update max values
                TriggerEvent('skinchanger:getData', function(comp, max)
                    components, maxVals = comp, max
                end);

                local newData = {}

                for i = 1, #elements, 1 do
                    newData = {}
                    newData.max = maxVals[elements[i].name]

                    if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
                        newData.value = 0
                    end

                    menu.update({ name = elements[i].name }, newData)
                end

                menu.refresh()
            end
        end, function(data, menu)
        end);
    end);
end

RegisterCommand("skin", function()
    TriggerEvent("esx_skin:openSaveableMenu")
end, false)
