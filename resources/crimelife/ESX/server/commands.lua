ESX.RegisterCommand({ 'setcoords', 'tp' }, 'admin', function(xPlayer, args)
	xPlayer.setCoords({ x = args.x, y = args.y, z = args.z })
end, false, {
	help = ('command_setcoords'),
	validate = true,
	arguments = {
		{ name = 'x', help = ('command_setcoords_x'), type = 'coordinate' },
		{ name = 'y', help = ('command_setcoords_y'), type = 'coordinate' },
		{ name = 'z', help = ('command_setcoords_z'), type = 'coordinate' }
	}
})

ESX.RegisterCommand(
	"giveweapon",
	"admin",
	function(xPlayer, args, showError)
		if args.playerId.hasWeapon(args.weapon) then
			return showError(("command_giveweapon_hasalready"))
		end
		args.playerId.addWeapon(args.weapon, args.ammo)
		loadoutUpdate(xPlayer)
	end,
	true,
	{
		help = ("command_giveweapon"),
		validate = true,
		arguments = {
			{ name = "playerId", help = ("commandgeneric_playerid"),   type = "player" },
			{ name = "weapon",   help = ("command_giveweapon_weapon"), type = "weapon" },
			{ name = "ammo",     help = ("command_giveweapon_ammo"),   type = "number" },
		},
	}
)

ESX.RegisterCommand({ 'cardel', 'dv' }, 'admin', function(xPlayer, args)
	local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
	if DoesEntityExist(PedVehicle) then
		DeleteEntity(PedVehicle)
	end
	local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(xPlayer.source)),
		tonumber(args.radius) or 5.0)
	for i = 1, #Vehicles do
		local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
		if DoesEntityExist(Vehicle) then
			DeleteEntity(Vehicle)
		end
	end
end, false, {
	help = ('command_cardel'),
	validate = false,
	arguments = {
		{ name = 'radius', validate = false, help = ('command_cardel_radius'), type = 'number' }
	}
})

ESX.RegisterCommand({ 'fix', 'repair' }, 'admin', function(xPlayer, args, showError)
	local xTarget = args.playerId
	local ped = GetPlayerPed(xTarget.source)
	local pedVehicle = GetVehiclePedIsIn(ped, false)
	if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
		showError(('not_in_vehicle'))
		return
	end
	xTarget.triggerEvent("esx:repairPedVehicle")
end, true, {
	help = ('command_repair'),
	validate = false,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('setmoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(('command_giveaccountmoney_invalid'))
	end
	args.playerId.setAccountMoney(args.account, args.amount, "Government Grant")
end, true, {
	help = ('command_setaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'),          type = 'player' },
		{ name = 'account',  help = ('command_giveaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = ('command_setaccountmoney_amount'),   type = 'number' }
	}
})

ESX.RegisterCommand('givemoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(('command_giveaccountmoney_invalid'))
	end
	args.playerId.addAccountMoney(args.account, args.amount, "Government Grant")
end, true, {
	help = ('command_giveaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'),          type = 'player' },
		{ name = 'account',  help = ('command_giveaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = ('command_giveaccountmoney_amount'),  type = 'number' }
	}
})

ESX.RegisterCommand('removemoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(('command_removeaccountmoney_invalid'))
	end
	args.playerId.removeAccountMoney(args.account, args.amount, "Government Tax")
end, true, {
	help = ('command_removeaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'),            type = 'player' },
		{ name = 'account',  help = ('command_removeaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = ('command_removeaccountmoney_amount'),  type = 'number' }
	}
})

ESX.RegisterCommand({ 'clear', 'cls' }, 'user', function(xPlayer)
	xPlayer.triggerEvent('chat:clear')
end, false, { help = ('command_clear') })

ESX.RegisterCommand({ 'clearall', 'clsall' }, 'admin', function(xPlayer)
	TriggerClientEvent('chat:clear', -1)
end, true, { help = ('command_clearall') })

ESX.RegisterCommand("refreshjobs", 'admin', function()
	ESX.RefreshJobs()
end, true, { help = ('command_clearall') })

if not Config.OxInventory then
	ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args)
		for _, v in next, (args.playerId.inventory) do
			if v.count > 0 then
				args.playerId.setInventoryItem(v.name, 0)
			end
		end
		TriggerEvent('esx:playerInventoryCleared', args.playerId)
	end, true, {
		help = ('command_clearinventory'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
		}
	})

	ESX.RegisterCommand('clearloadout', 'admin', function(xPlayer, args)
		for i = #args.playerId.loadout, 1, -1 do
			args.playerId.removeWeapon(args.playerId.loadout[i].name)
		end
		TriggerEvent('esx:playerLoadoutCleared', args.playerId)
		loadoutUpdate(xPlayer)
	end, true, {
		help = ('command_clearloadout'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
		}
	})
end

ESX.RegisterCommand('setgroup', 'admin', function(xPlayer, args)
	if not args.playerId then args.playerId = xPlayer.source end
	if args.group == "superadmin" then
		args.group = "admin"
	end
	args.playerId.setGroup(args.group)
end, true, {
	help = ('command_setgroup'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' },
		{ name = 'group',    help = ('command_setgroup_group'),  type = 'string' },
	}
})

ESX.RegisterCommand(
	"setjob",
	"admin",
	function(xPlayer, args, showError)
		if not ESX.DoesJobExist(args.job, args.grade) then
			return showError(("command_setjob_invalid"))
		end

		args.playerId.setJob(args.job, args.grade)
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier, ['@job'] = args.job, ['@job_grade'] = args.grade })
	end,
	true,
	{
		help = ("command_setjob"),
		validate = true,
		arguments = {
			{ name = "playerId", help = ("commandgeneric_playerid"), type = "player" },
			{ name = "job",      help = ("command_setjob_job"),      type = "string" },
			{ name = "grade",    help = ("command_setjob_grade"),    type = "number" },
		},
	}
)

ESX.RegisterCommand('save', 'admin', function(_, args)
	Core.SavePlayer(args.playerId)
end, true, {
	help = ('command_save'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('saveall', 'admin', function()
	Core.SavePlayers()
end, true, { help = ('command_saveall') })

ESX.RegisterCommand('freeze', "admin", function(xPlayer, args)
	args.playerId.triggerEvent('esx:freezePlayer', "freeze")
end, true, {
	help = ('command_freeze'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('unfreeze', "admin", function(xPlayer, args)
	args.playerId.triggerEvent('esx:freezePlayer', "unfreeze")
end, true, {
	help = ('command_unfreeze'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = ('commandgeneric_playerid'), type = 'player' }
	}
})