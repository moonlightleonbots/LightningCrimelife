local pickups = {}
local newSpawned = false

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			DoScreenFadeIn(0)
			TriggerServerEvent('esx:onPlayerJoined', GetPlayerServerId(PlayerId()))
			break
		end
	end
end);

RegisterNetEvent("esx:requestModel", function(model)
	ESX.Streaming.RequestModel(model)
end);

local skyCam = nil
local currentCamIndex = 1
local isCamModeActive = false

local function StartTeleportCam(position, heading)
	if skyCam then
		DestroyCam(skyCam, false)
	end

	skyCam = CreateCamWithParams(
		'DEFAULT_SCRIPTED_CAMERA',
		position.x, position.y, position.z,
		0.0,
		0.0,
		heading,
		70.0,
		false,
		2
	)

	SetCamActive(skyCam, true)
	RenderScriptCams(true, false, 0, true, false)
end

local function UpdateCamera()
	local camData = Config.Server.cams[currentCamIndex]
	if camData then
		SetEntityCoords(PlayerPedId(), camData.position.x, camData.position.y, camData.position.z + 150.0)
		StartTeleportCam(camData.position, camData.position[4])

		SendNUIMessage({
			a = "joincam:updateLocation",
			location = camData.name
		})
	end
end

local lastCoords = nil

function ToggleCamMode(state)
	local ped = PlayerPedId()
	lastCoords = GetEntityCoords(ped)

	hudForce = true
	SendNUIMessage({
		a = "hud:toggle",
		toggle = false
	})

	if state and not isCamModeActive then
		isCamModeActive = true
		openUI = false
		SendNUIMessage({
			a = "joinCamMode",
			toggle = true
		})
		UpdateCamera()
		FreezeEntityPosition(ped, true)
		SetEntityVisible(ped, false, false)
	elseif not state and isCamModeActive then
		SendNUIMessage({
			a = "joinCamMode",
			toggle = false
		})
		local camData = Config.Server.cams[currentCamIndex]
		EndTeleport(camData.spawn)
	end
end

---@param coords table
function EndTeleport(coords)
	if isCamModeActive then
		local ped = PlayerPedId()

		local cam = CreateCamWithParams(
			'DEFAULT_SCRIPTED_CAMERA',
			coords.x,
			coords.y,
			coords.z,
			7.0,
			0.0,
			10.3177,
			90.0,
			false,
			2
		);

		FreezeEntityPosition(ped, true);
		SetEntityVisible(ped, false, false);

		SetCamActive(skyCam, true);
		RenderScriptCams(true, false, 0, true, false);

		SetEntityVisible(ped, true, false);
		FreezeEntityPosition(ped, false);

		CreateThread(function()
			while DoesCamExist(skyCam) do
				Wait(0);
				DisableAllControlActions(0);
			end
		end);

		SetCamActiveWithInterp(cam, skyCam, 3000, 1, 1);
		---@diagnostic disable-next-line: missing-parameter

		Wait(2900);

		RenderScriptCams(false, false, 0, true, false);
		DestroyCam(skyCam, false);
		DestroyCam(cam, false);
		skyCam = nil;

		SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
		isCamModeActive = false
		hudForce = false
		newSpawned = false
		openUI = true
	end
end

CreateThread(function()
	while true do
		local sleep = 500

		if isCamModeActive then
			sleep = 1
			if IsControlJustPressed(0, 175) then
				currentCamIndex = currentCamIndex + 1
				if currentCamIndex > #Config.Server.cams then
					currentCamIndex = 1
				end
				UpdateCamera()
			end

			if IsControlJustPressed(0, 34) then
				currentCamIndex = currentCamIndex + 1
				if currentCamIndex > #Config.Server.cams then
					currentCamIndex = 1
				end
				UpdateCamera()
			end

			if IsControlJustPressed(0, 174) then
				currentCamIndex = currentCamIndex - 1
				if currentCamIndex < 1 then
					currentCamIndex = #Config.Server.cams
				end
				UpdateCamera()
			end

			if IsControlJustPressed(0, 35) then
				currentCamIndex = currentCamIndex - 1
				if currentCamIndex < 1 then
					currentCamIndex = #Config.Server.cams
				end
				UpdateCamera()
			end

			if IsControlJustPressed(0, 191) then
				TriggerServerEvent("setDimension", 0)
				local camData = Config.Server.cams[currentCamIndex]
				if camData then
					if Join and playerSkin then
						TriggerEvent('skinchanger:loadSkin', playerSkin, function()
							FreezeEntityPosition(PlayerPedId(), false)
						end);
						Join = false
						playerSkin = nil
					end

					ToggleCamMode(false)
					CreateThread(Utils.SpawnProtection)

					Config.Server.Settings.dauermap = camData.spawn
					SetResourceKvp('LCL_Settings', json.encode(Config.Server.Settings))
				end
			end

			if not newSpawned then
				if IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) then
					SendNUIMessage({
						a = "joinCamMode",
						toggle = false
					})
					EndTeleport(lastCoords)
					lastCoords = nil
					isCamModeActive = false
				end
			end
		end

		Wait(sleep)
	end
end);

RegisterNuiCallback("spawn", function()
	TriggerServerEvent("setDimension", 0)
	local camData = Config.Server.cams[currentCamIndex]
	if camData then
		if Join and playerSkin then
			TriggerEvent('skinchanger:loadSkin', playerSkin, function()
				FreezeEntityPosition(PlayerPedId(), false)
			end);
			Join = false
			playerSkin = nil
		end

		ToggleCamMode(false)
		CreateThread(Utils.SpawnProtection)
	end
end);

RegisterNuiCallback("openSpawn", function()
	ToggleCamMode(true)
	SetNuiFocus(false, false)
	openUI = true
	DoScreenFadeIn(750)
end);

RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew, skin)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
	local ped = PlayerPedId()

	SetCanAttackFriendly(ped, true, false)
	NetworkSetFriendlyFireOption(true)
	ClearPlayerWantedLevel(ped)
	SetMaxWantedLevel(0)

	exports.crimelife:spawnPlayer({
		x = ESX.PlayerData.coords.x,
		y = ESX.PlayerData.coords.y,
		z = ESX.PlayerData.coords.z + 0.25,
		heading = ESX.PlayerData.coords.heading,
		model = GetHashKey("mp_m_freemode_01"),
		skipFade = false
	}, function()
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

		if isNew then
			TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu2)
		elseif skin then
			if xPlayer.hasClip then
				CreateThread(function()
					local displayTime = 15000
					local typeSpeed = 50
					local text =
					"Du hast eine Permanente Aufnahmepflicht. Denke daran, NUR mit AMD oder NVIDIA wird Geclippt!"
					local currentIndex = 0
					local startTime = GetGameTimer()
					local isTyping = true
					local displayText = ""

					local maxTime = 15000
					local loopStartTime = GetGameTimer()

					while true do
						Wait(0)

						if GetGameTimer() - loopStartTime >= maxTime then
							break
						end

						if isTyping then
							if currentIndex < #text then
								if GetGameTimer() - startTime >= typeSpeed then
									currentIndex = currentIndex + 1
									displayText = string.sub(text, 1, currentIndex)
									startTime = GetGameTimer()
								end
							else
								isTyping = false
								startTime = GetGameTimer()
							end
						else
							if GetGameTimer() - startTime >= displayTime then
								isTyping = true
								currentIndex = 0
								displayText = ""
								startTime = GetGameTimer()
							end
						end

						Utils.BottomText(displayText)
					end
				end);
			end

			Wait(1000)
			newSpawned = true
			Join = true
			playerSkin = skin
			ToggleCamMode(true)
		end
	end);
end);

RegisterNetEvent('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end);

local function onPlayerSpawn()
	ESX.SetPlayerData('ped', PlayerPedId())
	ESX.SetPlayerData('dead', false)
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('esx:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('esx:onPlayerDeath', function()
	ESX.SetPlayerData('ped', PlayerPedId())
	ESX.SetPlayerData('dead', true)
end);

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Wait(100)
	end
	TriggerEvent('esx:restoreLoadout')
	Wait(250)
	SetPedInfiniteAmmo(PlayerPedId(), true)
end);

AddEventHandler('esx:restoreLoadout', function()
	ESX.SetPlayerData('ped', PlayerPedId())

	if not Config.OxInventory then
		local ammoTypes = {}
		RemoveAllPedWeapons(ESX.PlayerData.ped, true)

		for _, v in next, (ESX.PlayerData.loadout) do
			local weaponName = v.name
			local weaponHash = joaat(weaponName)

			GiveWeaponToPed(ESX.PlayerData.ped, weaponHash, 0, false, false)
			SetPedWeaponTintIndex(ESX.PlayerData.ped, weaponHash, v.tintIndex)

			local ammoType = GetPedAmmoTypeFromWeapon(ESX.PlayerData.ped, weaponHash)

			for _, v2 in next, (v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
				GiveWeaponComponentToPed(ESX.PlayerData.ped, weaponHash, componentHash)
			end

			if not ammoTypes[ammoType] then
				AddAmmoToPed(ESX.PlayerData.ped, weaponHash, v.ammo)
				ammoTypes[ammoType] = true
			end
		end
	end
end);

AddStateBagChangeHandler('VehicleProperties', nil, function(bagName, _, value)
	if not value then
		return
	end

	local netId = bagName:gsub('entity:', '')
	local timer = GetGameTimer()
	while not NetworkDoesEntityExistWithNetworkId(tonumber(netId)) do
		Wait(0)
		if GetGameTimer() - timer > 10000 then
			return
		end
	end

	local vehicle = NetToVeh(tonumber(netId))
	local timer2 = GetGameTimer()
	while NetworkGetEntityOwner(vehicle) ~= PlayerId() do
		Wait(0)
		if GetGameTimer() - timer2 > 10000 then
			return
		end
	end

	ESX.Game.SetVehicleProperties(vehicle, value)
end);

RegisterNetEvent('esx:setAccountMoney', function(account)
	for i = 1, #(ESX.PlayerData.accounts) do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end

	ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end);

if not Config.OxInventory then
	RegisterNetEvent('esx:addInventoryItem', function(item, count)
		for k, v in next, (ESX.PlayerData.inventory) do
			if v.name == item then
				ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
				ESX.PlayerData.inventory[k].count = count
				break
			end
		end
	end);

	RegisterNetEvent('esx:removeInventoryItem', function(item, count)
		for k, v in next, (ESX.PlayerData.inventory) do
			if v.name == item then
				ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
				ESX.PlayerData.inventory[k].count = count
				break
			end
		end
	end);

	RegisterNetEvent('esx:removeWeaponComponent', function(weapon, weaponComponent)
		local componentHash = ESX.GetWeaponComponent(weapon, weaponComponent).hash
		RemoveWeaponComponentFromPed(ESX.PlayerData.ped, joaat(weapon), componentHash)
	end);
end

RegisterNetEvent('esx:setJob', function(Job)
	ESX.SetPlayerData('job', Job)
end);

if not Config.OxInventory then
	RegisterNetEvent('esx:createPickup', function(pickupId, label, coords, itemType, name, components, tintIndex)
		local function setObjectProperties(object)
			SetEntityAsMissionEntity(object, true, false)
			PlaceObjectOnGroundProperly(object)
			FreezeEntityPosition(object, true)
			SetEntityCollision(object, false, true)

			pickups[pickupId] = {
				obj = object,
				label = label,
				inRange = false,
				coords = coords
			}
		end

		if itemType == 'item_weapon' then
			local weaponHash = joaat(name)
			ESX.Streaming.RequestWeaponAsset(weaponHash)
			local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
			SetWeaponObjectTintIndex(pickupObject, tintIndex)

			for _, v in next, (components) do
				local component = ESX.GetWeaponComponent(name, v)
				GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
			end

			setObjectProperties(pickupObject)
		else
			ESX.Game.SpawnLocalObject('prop_money_bag_01', coords, setObjectProperties)
		end
	end);
end

if not Config.OxInventory then
	RegisterNetEvent('esx:removePickup', function(pickupId)
		if pickups[pickupId] and pickups[pickupId].obj then
			ESX.Game.DeleteObject(pickups[pickupId].obj)
			pickups[pickupId] = nil
		end
	end);
end

-- disable wanted level
if not Config.EnableWantedLevel then
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
end

RegisterNetEvent("esx:setWeaponTint", function(weapon, weaponTintIndex)
	SetPedWeaponTintIndex(PlayerPedId(), joaat(weapon), weaponTintIndex)
end);

RegisterNetEvent("esx:repairPedVehicle", function()
	local ped = ESX.PlayerData.ped
	local vehicle = GetVehiclePedIsIn(ped, false)
	SetVehicleEngineHealth(vehicle, 1000)
	SetVehicleEngineOn(vehicle, true, true)
	SetVehicleFixed(vehicle)
	SetVehicleDirtLevel(vehicle, 0)
end);

RegisterNetEvent("esx:freezePlayer", function(input)
	local player = PlayerId()
	if input == 'freeze' then
		SetEntityCollision(ESX.PlayerData.ped, false)
		FreezeEntityPosition(ESX.PlayerData.ped, true)
		SetPlayerInvincible(player, true)
	elseif input == 'unfreeze' then
		SetEntityCollision(ESX.PlayerData.ped, true)
		FreezeEntityPosition(ESX.PlayerData.ped, false)
		SetPlayerInvincible(player, false)
	end
end);

ESX.RegisterClientCallback("esx:GetVehicleType", function(cb, model)
	cb(ESX.GetVehicleType(model))
end);
