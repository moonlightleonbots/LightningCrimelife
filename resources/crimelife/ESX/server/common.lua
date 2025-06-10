ESX = {}
ESX.Players = {}
ESX.Jobs = {}
ESX.JobsPlayerCount = {}
ESX.Items = {}
Core = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}

Core.vehicleTypesByModel = {}

exports('getSharedObject', function()
	return ESX
end);

local function StartDBSync()
	CreateThread(function()
		local interval <const> = 10 * 60 * 1000
		while true do
			Wait(interval)
			Core.SavePlayers()
		end
	end);
end

MySQL.ready(function()
	Core.DatabaseConnected = true
	if not Config.OxInventory then
		local items = MySQL.query.await('SELECT * FROM items')
		for _, v in next, (items) do
			ESX.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
		end
	else
		TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
			if ref then
				ESX.Items = ref()
			end
		end);

		AddEventHandler('ox_inventory:itemList', function(items)
			ESX.Items = items
		end);

		while not next(ESX.Items) do
			Wait(0)
		end
	end

	ESX.RefreshJobs()

	StartDBSync()
end);

RegisterNetEvent("esx:ReturnVehicleType", function(Type, Request)
	if Core.ClientCallbacks[Request] then
		Core.ClientCallbacks[Request](Type)
		Core.ClientCallbacks[Request] = nil
	end
end);
