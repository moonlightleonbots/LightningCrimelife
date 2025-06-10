ESX.RegisterServerCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end);
	else
		cb()
	end
end);

ESX.RegisterServerCallback('SmallTattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		table.insert(tattooList, tattoo)

		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(tattooList),
			['@identifier'] = xPlayer.identifier
		})

		Config.HUD.Notify({
			title = "Tattoo",
			text = "Du hast das Tattoo gekauft!",
			type = "info",
			time = 5000
		}, source)
		cb(true)
	else
		Config.HUD.Notify({
			title = "Tattoo",
			text = "Du hast nicht genug Geld dabei!",
			type = "info",
			time = 5000
		}, source)
		cb(false)
	end
end);


RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function(tattooList)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerId = source

	MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
		['@tattoos'] = json.encode(tattooList),
		['@identifier'] = xPlayer.identifier
	})
end);

RegisterServerEvent('heli:spotlight_s')
AddEventHandler('heli:spotlight_s', function(state)
	local serverID = source
	TriggerClientEvent('heli:spotlight', -1, serverID, state)
end);
