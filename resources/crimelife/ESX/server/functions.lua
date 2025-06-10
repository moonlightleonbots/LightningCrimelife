function ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for _, v in next, (name) do
			ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if Core.RegisteredCommands[name] then
		if Core.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then
			suggestion.arguments = {}
		end
		if not suggestion.help then
			suggestion.help = ''
		end
	end

	Core.RegisteredCommands[name] = { group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion }

	RegisterCommand(name, function(playerId, args)
		local command = Core.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
		else
			local xPlayer, error = ESX.Players[playerId], nil

			if command.suggestion then
				if command.suggestion.validate then
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k, v in next, (command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then
									targetPlayer = playerId
								end

								if targetPlayer then
									local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									end
								end
							elseif v.type == 'string' then
								local newArg = tonumber(args[k])
								if not newArg then
									newArgs[v.name] = args[k]
								end
							elseif v.type == 'item' then
								if ESX.Items[args[k]] then
									newArgs[v.name] = args[k]
								end
							elseif v.type == 'weapon' then
								if ESX.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							elseif v.type == 'merge' then
								local lenght = 0
								for i = 1, k - 1 do
									lenght = lenght + string.len(args[i]) + 1
								end
								local merge = table.concat(args, " ")

								newArgs[v.name] = string.sub(merge, lenght)
							elseif v.type == 'coordinate' then
								local coord = tonumber(args[k]:match("(-?%d+%.?%d*)"))
								if (not coord) then
								else
									newArgs[v.name] = coord
								end
							end
						end

						--backwards compatibility
						if v.validate ~= nil and not v.validate then
							error = nil
						end

						if error then
							break
						end
					end

					args = newArgs
				end
			end

			if not error then
				cb(xPlayer or false, args, function(msg)
				end);
			end
		end
	end, true)

	if type(group) == 'table' then
		for _, v in next, (group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

function Core.SavePlayer(xPlayer, cb)
	local parameters <const> = {
		json.encode(xPlayer.getAccounts(true)),
		xPlayer.job.name,
		xPlayer.job.grade,
		xPlayer.group,
		json.encode(xPlayer.getCoords()),
		json.encode(xPlayer.getInventory(true)),
		json.encode(xPlayer.getLoadout(true)),
		xPlayer.identifier
	}

	MySQL.prepare(
		'UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ? WHERE `identifier` = ?',
		parameters,
		function(affectedRows)
			if affectedRows == 1 then
				TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
			end
			if cb then
				cb()
			end
		end
	)
end

function Core.SavePlayers(cb)
	local xPlayers <const> = ESX.Players
	if not next(xPlayers) then
		return
	end

	local startTime <const> = os.time()
	local parameters = {}

	for _, xPlayer in next, (ESX.Players) do
		parameters[#parameters + 1] = {
			json.encode(xPlayer.getAccounts(true)),
			xPlayer.job.name,
			xPlayer.job.grade,
			xPlayer.group,
			json.encode(xPlayer.getCoords()),
			json.encode(xPlayer.getInventory(true)),
			json.encode(xPlayer.getLoadout(true)),
			xPlayer.identifier
		}
	end

	MySQL.prepare(
		"UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ? WHERE `identifier` = ?",
		parameters,
		function(results)
			if not results then
				return
			end

			if type(cb) == 'function' then
				return cb()
			end
		end
	)
end

ESX.GetPlayers = GetPlayers

local function checkTable(key, val, player, xPlayers)
	for valIndex = 1, #val do
		local value = val[valIndex]
		if not xPlayers[value] then
			xPlayers[value] = {}
		end

		if (key == 'job' and player.job.name == value) or player[key] == value then
			xPlayers[value][#xPlayers[value] + 1] = player
		end
	end
end

function ESX.GetExtendedPlayers(key, val)
	local xPlayers = {}
	if type(val) == "table" then
		for _, v in next, (ESX.Players) do
			checkTable(key, val, v, xPlayers)
		end
	else
		for _, v in next, (ESX.Players) do
			if key then
				if (key == 'job' and v.job.name == val) or v[key] == val then
					xPlayers[#xPlayers + 1] = v
				end
			else
				xPlayers[#xPlayers + 1] = v
			end
		end
	end

	return xPlayers
end

function ESX.GetNumPlayers(key, val)
	if not key then
		return #GetPlayers()
	end

	if type(val) == "table" then
		local numPlayers = {}
		if key == "job" then
			for _, v in next, (val) do
				numPlayers[v] = (ESX.JobsPlayerCount[v] or 0)
			end
			return numPlayers
		end

		local filteredPlayers = ESX.GetExtendedPlayers(key, val)
		for i, v in next, (filteredPlayers) do
			numPlayers[i] = (#v or 0)
		end
		return numPlayers
	end

	if key == "job" then
		return (ESX.JobsPlayerCount[val] or 0)
	end

	return #ESX.GetExtendedPlayers(key, val)
end

function ESX.GetPlayerFromId(source)
	return ESX.Players[tonumber(source)]
end

function ESX.GetPlayerFromIdentifier(identifier)
	return Core.playersByIdentifier[identifier]
end

function ESX.GetIdentifier(playerId)
	local fxDk = GetConvarInt('sv_fxdkMode', 0)
	if fxDk == 1 then
		return "ESX-DEBUG-LICENCE"
	end

	local identifier = GetPlayerIdentifierByType(playerId, 'license')
	return identifier and identifier:gsub('license:', '')
end

---@param model string|number
---@param player number playerId
---@param cb function

function ESX.GetVehicleType(model, player, cb)
	model = type(model) == 'string' and joaat(model) or model

	if Core.vehicleTypesByModel[model] then
		return cb(Core.vehicleTypesByModel[model])
	end

	ESX.TriggerClientCallback(player, "esx:GetVehicleType", function(vehicleType)
		Core.vehicleTypesByModel[model] = vehicleType
		cb(vehicleType)
	end, model)
end

--- Create Job at Runtime
--- @param name string
--- @param label string
--- @param grades table
function ESX.CreateJob(name, label, grades)
	local parameters = {}
	local job = { name = name, label = label, grades = {} }

	for _, v in next, (grades) do
		job.grades[tostring(v.grade)] = { job_name = name, grade = v.grade, name = v.name, label = v.label, salary = v
		.salary, skin_male = {}, skin_female = {} }
		parameters[#parameters + 1] = { name, v.grade, v.name, v.label, v.salary }
	end

	MySQL.insert('INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)', { name, label })
	MySQL.prepare('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', parameters)

	ESX.Jobs[name] = job
end

function ESX.RefreshJobs()
	local Jobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in next, (jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in next, (jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		end
	end

	for _, v in next, (Jobs) do
		if ESX.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
		end
	end

	if not Jobs then
		-- Fallback data, if no jobs exist
		ESX.Jobs['unemployed'] = { label = 'Unemployed', grades = { ['0'] = { grade = 0, label = 'Unemployed', salary = 200, skin_male = {}, skin_female = {} } } }
	else
		ESX.Jobs = Jobs
	end
end

function ESX.RegisterUsableItem(item, cb)
	Core.UsableItemsCallbacks[item] = cb
end

function ESX.UseItem(source, item, ...)
	if ESX.Items[item] then
		local itemCallback = Core.UsableItemsCallbacks[item]

		if itemCallback then
			local success, result = pcall(itemCallback, source, item, ...)
		end
	end
end

function ESX.RegisterPlayerFunctionOverrides(index, overrides)
	Core.PlayerFunctionOverrides[index] = overrides
end

function ESX.SetPlayerFunctionOverride(index)
	Config.PlayerFunctionOverride = index
end

function ESX.GetItemLabel(item)
	if Config.OxInventory then
		item = exports.ox_inventory:Items(item)
		if item then
			return item.label
		end
	end

	if ESX.Items[item] then
		return ESX.Items[item].label
	end
end

function ESX.GetJobs()
	return ESX.Jobs
end

function ESX.GetUsableItems()
	local Usables = {}
	for k in next, (Core.UsableItemsCallbacks) do
		Usables[k] = true
	end
	return Usables
end

if not Config.OxInventory then
	function ESX.CreatePickup(itemType, name, count, label, playerId, components, tintIndex, coords)
		local pickupId = (Core.PickupId == 65635 and 0 or Core.PickupId + 1)
		local xPlayer = ESX.Players[playerId]
		coords = ((type(coords) == "vec3" or type(coords) == "vec4") and coords.xyz or xPlayer.getCoords(true))

		Core.Pickups[pickupId] = { type = itemType, name = name, count = count, label = label, coords = coords }

		if itemType == 'item_weapon' then
			Core.Pickups[pickupId].components = components
			Core.Pickups[pickupId].tintIndex = tintIndex
		end

		TriggerClientEvent('esx:createPickup', -1, pickupId, label, coords, itemType, name, components, tintIndex)
		Core.PickupId = pickupId
	end
end

function ESX.DoesJobExist(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

function Core.IsPlayerAdmin(playerId)
	if (IsPlayerAceAllowed(playerId, 'command') or GetConvar('sv_lan', '') == 'true') and true or false then
		return true
	end

	local xPlayer = ESX.Players[playerId]

	if xPlayer then
		if Config.AdminGroups[xPlayer.group] then
			return true
		end
	end

	return false
end
