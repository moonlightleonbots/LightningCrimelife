local hasRolled = false
local deathcooldown = false

AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= "CEventNetworkEntityDamage" then return end
	local victim, sender, victimDied = data[1], data[2], data[4]
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
	local playerPed = PlayerPedId()
	if NetworkGetPlayerIndexFromPed(victim) == player then
		if victimDied and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim)) then
			if not deathcooldown then
				deathcooldown = true
				SetTimeout(1000, function() deathcooldown = false end);
				local killerEntity = GetPedSourceOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)
				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId))
				else
					PlayerKilled()
				end
			end
		else
			local a, bone = GetPedLastDamageBone(victim)
			if bone == 31086 then
				local killerClientId = NetworkGetPlayerIndexFromPed(sender)
				PlayerKilledByPlayer(GetPlayerServerId(killerClientId))
				SetEntityHealth(victim, 0)
			end
		end
	end
end);

function PlayerKilledByPlayer(killerServerId)
	local data = { killedByPlayer = true, killerServerId = killerServerId, hasRolled = hasRolled and hasRolled or false }
	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled()
	local data = { killedByPlayer = false }
	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

AddEventHandler('populationPedCreating', function() CancelEvent() end);

CreateThread(function()
	local i = 0
	while true do
		if GetIsTaskActive(PlayerPedId(), 3) then
			hasRolled = true
		else
			if hasRolled then
				if i >= 2 then
					hasRolled = false
					i = 0
				else
					i = i + 1
				end
			end
		end
		Wait(100)
	end
end);