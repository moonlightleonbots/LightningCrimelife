Token = LoadResourceFile(GetCurrentResourceName(), './token')
local newPlayer =
'INSERT INTO `users` SET `accounts` = ?, `identifier` = ?, `group` = ?, `discordid` = ?, `steamname`= ?'
local loadPlayer = 'SELECT `accounts`, `job`, `job_grade`, `group`, `position`, `inventory`, `skin`, `loadout`'

if Config.StartingInventoryItems then
	newPlayer = newPlayer .. ', `inventory` = ?'
end

function GetDiscordData(playerId)
	local userData = nil
	local raw = {}
	if not GetPlayerIdentifierByType(playerId, 'discord'):sub(#'discord:' + 1) then return end
	local userId = GetPlayerIdentifierByType(playerId, 'discord'):sub(#'discord:' + 1) or "973670159149588500"
	if userId then
		PerformHttpRequest('https://discord.com/api/v10/guilds/' .. Config.Server.GuildID .. '/members/' .. userId,
			function(status, body, headers)
				if body then
					raw = json.decode(body)
					userData = raw.roles
					if raw.user.avatar ~= "" and raw.user.avatar then
						avatar = raw.user.avatar
						userData.avatar = ('https://cdn.discordapp.com/avatars/' .. userId .. '/' .. avatar .. (string.sub(avatar, 1, 2) == "a_" and ".gif" or ".png")) or
							nil

						userData.username = raw.user.username

						if raw.user.banner then
							banner = raw.user.banner
							userData.banner = ('https://cdn.discordapp.com/banners/' .. userId .. '/' .. banner .. (string.sub(banner, 1, 2) == "a_" and ".gif?size=1024" or ".png?size=1024")) or
							nil
						end
					else
						userData.avatar =
						"https://cdn.discordapp.com/attachments/1069689394862235760/1238255565248135178/images.png?ex=6645df1c&is=66448d9c&hm=e0a1495b6dbff79115f562b72747778d44b757f30aade652575f9c3b5ebd35c8&"
						userData.banner =
						"https://cdn.discordapp.com/attachments/1069689394862235760/1238255565248135178/images.png?ex=6645df1c&is=66448d9c&hm=e0a1495b6dbff79115f562b72747778d44b757f30aade652575f9c3b5ebd35c8&"
					end
				else
					userData = {}
				end
			end, 'GET', '', {
				['Authorization'] = 'Bot ' .. Token,
				['Content-Type'] = 'application/json'
			})
	else
		userData = {}
		return
	end

	while not userData do
		Wait(100)
	end

	return userData, raw
end

HasDiscordRole = function(source, roleId, roles)
	if roles then
		for _, i in next, roles do
			if i == roleId then
				return true
			end
		end
	end
	return false
end

loadPlayer = loadPlayer .. ' FROM `users` WHERE identifier = ?'

RegisterNetEvent('esx:onPlayerJoined', function(_source)
	ESX.RefreshJobs()
	while not next(ESX.Jobs) do
		Wait(50)
	end

	if not ESX.Players[_source] then
		onPlayerJoined(_source)
	end
end);

function onPlayerJoined(playerId)
	local identifier = ESX.GetIdentifier(playerId)
	if identifier then
		-- if ESX.GetPlayerFromIdentifier(identifier) then
		-- 	DropPlayer(playerId,
		-- 		('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s')
		-- 		:format(
		-- 			identifier))
		-- else
		local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
		if result then
			loadESXPlayer(identifier, playerId, false)
		else
			createESXPlayer(identifier, playerId)
		end
	end
	-- else
	-- DropPlayer(playerId,
	-- 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	-- end
end

function createESXPlayer(identifier, playerId, data)
	local accounts = {}

	for account, money in next, (Config.StartingAccountMoney) do
		accounts[account] = money
	end

	local defaultGroup = "user"
	if Core.IsPlayerAdmin(playerId) then
		defaultGroup = "admin"
	end

	local parameters = false and
		{ json.encode(accounts), identifier, defaultGroup, GetPlayerIdentifierByType(playerId, 'discord'):sub(#
			'discord:' + 1),
			GetPlayerName(playerId) } or { json.encode(accounts), identifier, defaultGroup }

	if Config.StartingInventoryItems then
		table.insert(parameters, json.encode(Config.StartingInventoryItems))
	end

	MySQL.prepare(newPlayer, parameters, function()
		loadESXPlayer(identifier, playerId, true)
	end);
end

function loadESXPlayer(identifier, playerId, isNew)
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		loadout = {},
		playerName = GetPlayerName(playerId),
		weight = 0,
	}
	local result = MySQL.prepare.await(loadPlayer, { identifier })
	local job, grade, jobObject, gradeObject = result.job, tostring(result.job_grade)
	local foundAccounts, foundItems = {}, {}

	-- Accounts
	if result.accounts and result.accounts ~= '' then
		local accounts = json.decode(result.accounts)

		for account, money in next, (accounts) do
			foundAccounts[account] = money
		end
	end

	for account, data in next, (Config.Accounts) do
		if data.round == nil then
			data.round = true
		end
		local index = #userData.accounts + 1
		userData.accounts[index] = {
			name = account,
			money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
			label = data.label,
			round = data.round,
			index = index
		}
	end

	-- Job
	if ESX.DoesJobExist(job, grade) then
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	else
		job, grade = 'unemployed', '0'
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	end

	userData.job.id = jobObject.id
	userData.job.name = jobObject.name
	userData.job.label = jobObject.label

	userData.job.grade = tonumber(grade)
	userData.job.grade_name = gradeObject.name
	userData.job.grade_label = gradeObject.label
	userData.job.grade_salary = gradeObject.salary

	userData.job.skin_male = {}
	userData.job.skin_female = {}

	if gradeObject.skin_male then
		userData.job.skin_male = json.decode(gradeObject.skin_male)
	end
	if gradeObject.skin_female then
		userData.job.skin_female = json.decode(gradeObject.skin_female)
	end

	-- Inventory
	if not Config.OxInventory then
		if result.inventory and result.inventory ~= '' then
			local inventory = json.decode(result.inventory)

			for name, count in next, (inventory) do
				local item = ESX.Items[name]

				if item then
					foundItems[name] = count
				end
			end
		end

		for name, item in next, (ESX.Items) do
			local count = foundItems[name] or 0
			if count > 0 then
				userData.weight = userData.weight + (item.weight * count)
			end

			table.insert(userData.inventory,
				{
					name = name,
					count = count,
					label = item.label,
					weight = item.weight,
					usable = Core.UsableItemsCallbacks[name] ~= nil,
					rare = item.rare,
					canRemove = item.canRemove
				})
		end

		table.sort(userData.inventory, function(a, b)
			return a.label < b.label
		end);
	else
		if result.inventory and result.inventory ~= '' then
			userData.inventory = json.decode(result.inventory)
		else
			userData.inventory = {}
		end
	end

	-- Group
	if result.group then
		if result.group == "superadmin" then
			userData.group = "sadmin"
		else
			userData.group = result.group
		end
	else
		userData.group = 'user'
	end

	-- Loadout
	if not Config.OxInventory then
		if result.loadout and result.loadout ~= '' then
			local loadout = json.decode(result.loadout)

			for name, weapon in next, (loadout) do
				local label = ESX.GetWeaponLabel(name)

				if label then
					if not weapon.components then
						weapon.components = {}
					end
					if not weapon.tintIndex then
						weapon.tintIndex = 0
					end

					table.insert(userData.loadout,
						{
							name = name,
							ammo = weapon.ammo,
							label = label,
							components = weapon.components,
							tintIndex = weapon.tintIndex
						})
				end
			end
		end
	end

	-- Position
	userData.coords = json.decode(result.position) or Config.Server.zones.Army

	-- Skin
	if result.skin and result.skin ~= '' then
		userData.skin = json.decode(result.skin)
	else
		if userData.sex == 'f' then
			userData.skin = { sex = 1 }
		else
			userData.skin = { sex = 0 }
		end
	end

	local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory,
		userData.weight, userData.job, userData.loadout, userData.playerName, userData.coords)
	local stats = MySQL.single.await(
		'SELECT kills, deaths, xp, trophys, quests, collected_quest, identifier FROM users WHERE identifier=? LIMIT 1',
		{ identifier })
	discord = GetDiscordData(playerId)

	if not HasDiscordRole(xPlayer.source, Config.Discord.roles["Booster"], discord) and xPlayer.hasWeapon(Config.Discord.Booster.name) then
		xPlayer.removeWeapon(Config.Discord.Booster.name)
	end

	ESX.Players[playerId] = xPlayer
	Core.playersByIdentifier[identifier] = xPlayer

	if xPlayer and playerId then
		TriggerEvent('esx:playerLoaded', playerId, xPlayer, isNew)
	end

	TriggerClientEvent("discord:setRich", -1, GetNumPlayerIndices(), GetConvarInt('sv_maxclients', 32))

	xPlayer.triggerEvent('esx:playerLoaded',
		{
			source = playerId,
			name = xPlayer.name,
			group = xPlayer.getGroup(),
			accounts = xPlayer.getAccounts(),
			coords = userData.coords,
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			loadout = xPlayer.getLoadout(),
			items = xPlayer.getInventory(),
			maxWeight = xPlayer.getMaxWeight(),
			money = xPlayer.getMoney(),
			coins = xPlayer.getAccount("coins").money,
			sex = xPlayer.get("sex") or "m",
			dead = false,
			event = HasDiscordRole(playerId, Config.Discord.roles["Event"], discord),
			frak = HasDiscordRole(playerId, Config.Discord.roles["FrakVerwaltung"], discord),
			hasClip = HasDiscordRole(playerId, Config.Discord.roles["Clip"], discord),
			factions = json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")),
			booster = HasDiscordRole(playerId, Config.Discord.roles["Booster"], discord),

			online = GetNumPlayerIndices(),
			maxClients = GetConvarInt('sv_maxclients', 32),

			discord = {
				id = GetPlayerIdentifierByType(playerId, 'discord'):sub(#'discord:' + 1),
				avatar = discord.avatar,
				banner = discord.banner,
			},

			stats = {
				kills = stats and stats.kills,
				deaths = stats and stats.deaths,
				trophys = stats and stats.trophys,
				xp = stats and stats.xp
			},
			quests = json.decode(stats.quests),
			collected_quest = json.decode(stats.collected_quest),
		}, isNew,
		userData.skin)


	Wait(250)
	if HasDiscordRole(playerId, Config.Discord.roles["Blacklist"], discord) then
		Config.Server.Debug("[^1Blacklist^7]: ^1Player ^4" .. playerId .. "^7 ^1tried to join the server but has the Cheating role.^7")
		exports["crimelife_ac"]:fg_BanPlayer(playerId,
			"Attempted to join the server while blacklisted. [Hat Bleibt gebannt Rolle auf Discord.]", true)
	end
end

AddEventHandler('chatMessage', function(playerId, _, message)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
	end
end);

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)
		local job = xPlayer.getJob().name
		local currentJob = ESX.JobsPlayerCount[job]
		ESX.JobsPlayerCount[job] = ((currentJob and currentJob > 0) and currentJob or 1) - 1
		GlobalState[("%s:count"):format(job)] = ESX.JobsPlayerCount[job]
		Core.playersByIdentifier[xPlayer.identifier] = nil
		Core.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
		end);
	end
end);

AddEventHandler("esx:playerLoaded", function(_, xPlayer)
	local job = xPlayer.getJob().name
	local jobKey = ("%s:count"):format(job)

	ESX.JobsPlayerCount[job] = (ESX.JobsPlayerCount[job] or 0) + 1
	GlobalState[jobKey] = ESX.JobsPlayerCount[job]
end);

AddEventHandler("esx:setJob", function(_, job, lastJob)
	local lastJobKey = ('%s:count'):format(lastJob.name)
	local jobKey = ('%s:count'):format(job.name)
	local currentLastJob = ESX.JobsPlayerCount[lastJob.name]

	ESX.JobsPlayerCount[lastJob.name] = ((currentLastJob and currentLastJob > 0) and currentLastJob or 1) - 1
	ESX.JobsPlayerCount[job.name] = (ESX.JobsPlayerCount[job.name] or 0) + 1

	GlobalState[lastJobKey] = ESX.JobsPlayerCount[lastJob.name]
	GlobalState[jobKey] = ESX.JobsPlayerCount[job.name]
end);

AddEventHandler('esx:playerLogout', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId)

		Core.playersByIdentifier[xPlayer.identifier] = nil
		Core.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
			if cb then
				cb()
			end
		end);
	end
	TriggerClientEvent("esx:onPlayerLogout", playerId)
end);

if not Config.OxInventory then
	RegisterNetEvent('esx:updateWeaponAmmo', function(weaponName, ammoCount)
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer then
			xPlayer.updateWeaponAmmo(weaponName, ammoCount)
		end
	end);

	RegisterNetEvent('esx:giveInventoryItem', function(target, itemType, itemName, itemCount)
		local playerId = source
		local sourceXPlayer = ESX.GetPlayerFromId(playerId)
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(target)))
		if not sourceXPlayer or not targetXPlayer or distance > Config.DistanceGive then
			return
		end

		if itemType == 'item_standard' then
			local sourceItem = sourceXPlayer.getInventoryItem(itemName)

			if itemCount > 0 and sourceItem.count >= itemCount then
				if targetXPlayer.canCarryItem(itemName, itemCount) then
					sourceXPlayer.removeInventoryItem(itemName, itemCount)
					targetXPlayer.addInventoryItem(itemName, itemCount)
					updateInventory(targetXPlayer)
				end
			end
		elseif itemType == 'item_account' then
			if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
				sourceXPlayer.removeAccountMoney(itemName, itemCount, "Gave to " .. targetXPlayer.name)
				targetXPlayer.addAccountMoney(itemName, itemCount, "Received from " .. sourceXPlayer.name)
			end
		elseif itemType == 'item_weapon' then
			if sourceXPlayer.hasWeapon(itemName) then
				local weaponLabel = ESX.GetWeaponLabel(itemName)
				if not targetXPlayer.hasWeapon(itemName) then
					local _, weapon = sourceXPlayer.getWeapon(itemName)
					local _, weaponObject = ESX.GetWeapon(itemName)
					itemCount = weapon.ammo
					local weaponComponents = ESX.Table.Clone(weapon.components)
					local weaponTint = weapon.tintIndex
					if weaponTint then
						targetXPlayer.setWeaponTint(itemName, weaponTint)
					end
					if weaponComponents then
						for _, v in next, (weaponComponents) do
							targetXPlayer.addWeaponComponent(itemName, v)
						end
					end
					sourceXPlayer.removeWeapon(itemName)
					targetXPlayer.addWeapon(itemName, itemCount)

					if weaponObject.ammo and itemCount > 0 then
						local ammoLabel = weaponObject.ammo.label
					end
				end
			end
		elseif itemType == 'item_ammo' then
			if sourceXPlayer.hasWeapon(itemName) then
				local _, weapon = sourceXPlayer.getWeapon(itemName)

				if targetXPlayer.hasWeapon(itemName) then
					local _, weaponObject = ESX.GetWeapon(itemName)

					if weaponObject.ammo then
						local ammoLabel = weaponObject.ammo.label

						if weapon.ammo >= itemCount then
							sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
							targetXPlayer.addWeaponAmmo(itemName, itemCount)
						end
					end
				end
			end
		end
	end);

	RegisterNetEvent('esx:removeInventoryItem', function(itemType, itemName, itemCount)
		local playerId = source
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if itemType == 'item_standard' then
			if itemCount == nil or itemCount < 1 then
			else
				local xItem = xPlayer.getInventoryItem(itemName)

				if (itemCount > xItem.count or xItem.count < 1) then
				else
					xPlayer.removeInventoryItem(itemName, itemCount)
					local pickupLabel = ('%s [%s]'):format(xItem.label, itemCount)
					ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId)
				end
			end
		elseif itemType == 'item_account' then
			if itemCount == nil or itemCount < 1 then
			else
				local account = xPlayer.getAccount(itemName)

				if (itemCount > account.money or account.money < 1) then
				else
					xPlayer.removeAccountMoney(itemName, itemCount, "Threw away")
				end
			end
		elseif itemType == 'item_weapon' then
			itemName = string.upper(itemName)

			if xPlayer.hasWeapon(itemName) then
				local _, weapon = xPlayer.getWeapon(itemName)
				local _, weaponObject = ESX.GetWeapon(itemName)
				local components, pickupLabel = ESX.Table.Clone(weapon.components)
				xPlayer.removeWeapon(itemName)

				if weaponObject.ammo and weapon.ammo > 0 then
					local ammoLabel = weaponObject.ammo.label
					pickupLabel = ('%s [%s %s]'):format(weapon.label, weapon.ammo, ammoLabel)
				else
					pickupLabel = ('%s'):format(weapon.label)
				end

				ESX.CreatePickup('item_weapon', itemName, weapon.ammo, pickupLabel, playerId, components,
					weapon.tintIndex)
			end
		end
	end);

	RegisterNetEvent('esx:useItem', function(itemName)
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local count = xPlayer.getInventoryItem(itemName).count

		if count > 0 then
			ESX.UseItem(source, itemName)
		end
	end);

	RegisterNetEvent('esx:onPickup', function(pickupId)
		local pickup, xPlayer, success = Core.Pickups[pickupId], ESX.GetPlayerFromId(source)

		if pickup then
			local playerPickupDistance = #(pickup.coords - xPlayer.getCoords(true))
			if (playerPickupDistance > 5.0) then
				return
			end

			if pickup.type == 'item_standard' then
				if xPlayer.canCarryItem(pickup.name, pickup.count) then
					xPlayer.addInventoryItem(pickup.name, pickup.count)
					updateInventory(xPlayer)
					success = true
				end
			elseif pickup.type == 'item_account' then
				success = true
				xPlayer.addAccountMoney(pickup.name, pickup.count, "Picked up")
			elseif pickup.type == 'item_weapon' then
				if xPlayer.hasWeapon(pickup.name) then
				else
					success = true
					xPlayer.addWeapon(pickup.name, pickup.count)
					xPlayer.setWeaponTint(pickup.name, pickup.tintIndex)

					for _, v in next, (pickup.components) do
						xPlayer.addWeaponComponent(pickup.name, v)
					end

					loadoutUpdate(xPlayer)
				end
			end

			if success then
				Core.Pickups[pickupId] = nil
				TriggerClientEvent('esx:removePickup', -1, pickupId)
			end
		end
	end);
end

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			Core.SavePlayers()
		end);
	end
end);

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	Core.SavePlayers()
end);

local DoNotUse = {
	['essentialmode'] = true,
	['es_admin2'] = true,
	['basic-gamemode'] = true,
	['mapmanager'] = true,
	['fivem-map-skater'] = true,
	['fivem-map-hipster'] = true,
	['qb-core'] = false,
	['default_spawnpoint'] = true,
}

AddEventHandler('onResourceStart', function(key)
	if DoNotUse[string.lower(key)] then
		while GetResourceState(key) ~= 'started' do
			Wait(0)
		end

		StopResource(key)
	end
end);

for key in next, (DoNotUse) do
	if GetResourceState(key) == 'started' or GetResourceState(key) == 'starting' then
		StopResource(key)
	end
end
