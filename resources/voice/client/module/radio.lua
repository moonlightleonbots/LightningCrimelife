local radioChannel = 0
local radioNames = {}
local disableRadioAnim = false

--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
---@param localPlyRadioName string the local players name
function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	local isRadioEnabled = radioEnabled and LocalPlayer.state.disableRadio == 0
	if isRadioEnabled then
		handleRadioAndCallInit()
	end

	sendUIMessage({
		radioChannel = radioChannel,
		radioEnabled = isRadioEnabled
	})
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end

RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	radioData[plySource] = enabled
	-- if we don't have radioEnabled don't actually set them as talking (we still want the state to enable people talking later)
	if not radioEnabled or LocalPlayer.state.disableRadio ~= 0 then
		return logger.info(
			"[radio] Ignoring setTalkingOnRadio. radioEnabled: %s disableRadio: %s", radioEnabled,
			LocalPlayer.state.disableRadio)
	end
	-- If we're on a call we don't want to toggle their voice disabled this will break calls.
	if not callData[plySource] then
		toggleVoice(plySource, enabled, 'radio')
	end
	playMicClicks(enabled)
end

RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	logger.info('[radio] %s joined radio %s %s', plySource, radioChannel,
		radioPressed and " while we were talking, adding them to targets" or "")
	if radioPressed then
		addVoiceTargets(radioData, callData)
	end
end

RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		sendUIMessage({
			radioChannel = 0,
			radioEnabled = radioEnabled
		})
		radioNames = {}
		radioData = {}
		addVoiceTargets(callData)
	else
		toggleVoice(plySource, false, 'radio')
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			addVoiceTargets(radioData, callData)
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end

RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

RegisterNetEvent('pma-voice:radioChangeRejected', function()
	logger.info("The server rejected your radio change.")
	radioChannel = 0
end);

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({ channel, "number" })
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
end

--- exports setRadioChannel
--- sets the local players current radio channel and updates the server
exports('setRadioChannel', setRadioChannel)
-- mumble-voip compatability
exports('SetRadioChannel', setRadioChannel)

--- exports removePlayerFromRadio
--- sets the local players current radio channel and updates the server
exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end);

--- exports addPlayerToRadio
--- sets the local players current radio channel and updates the server
---@param _radio number the channel to set the player to, or 0 to remove them.
exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end);

--- exports toggleRadioAnim
--- toggles whether the client should play radio anim or not, if the animation should be played or notvaliddance
exports('toggleRadioAnim', function()
	disableRadioAnim = not disableRadioAnim
	TriggerEvent('pma-voice:toggleRadioAnim', disableRadioAnim)
end);

exports("setDisableRadioAnim", function(shouldDisable)
	disableRadioAnim = shouldDisable
end);

-- exports disableRadioAnim
--- returns whether the client is undercover or not
exports('getRadioAnimState', function()
	return disableRadioAnim
end);

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed
--- but you can integrate the below state bag to your death resources.
--- LocalPlayer.state:set('isDead', true or false, false)
function isDead()
	if LocalPlayer.state.isDead then
		return true
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
	return false
end

function isRadioAnimEnabled()
	if
		GetConvarInt('voice_enableRadioAnim', 1) == 1
		and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1
			and IsPedInAnyVehicle(PlayerPedId(), false))
		and not disableRadioAnim then
		return true
	end
	return false
end

RegisterCommand('+radiotalk', function()
	local settings = exports["crimelife"]:GetSettings().funk

	if not exports["crimelife"]:IsAnimated() then
		if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
		if isDead() or LocalPlayer.state.disableRadio ~= 0 then return end
		if not radioPressed and radioEnabled then
			if radioChannel > 0 then
				logger.info('[radio] Start broadcasting, update targets and notify server.')
				addVoiceTargets(radioData, callData)
				TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
				radioPressed = true
				local shouldPlayAnimation = isRadioAnimEnabled()
				if shouldPlayAnimation then
					RequestAnimDict(settings.animation.animdict)
				end

				if settings.sound then
					playMicClicks(true)
				end

				CreateThread(function()
					TriggerEvent("pma-voice:radioActive", true)
					LocalPlayer.state:set("radioActive", true, true);
					local checkFailed = false
					while radioPressed do
						if radioChannel < 0 or not radioEnabled or isDead() or LocalPlayer.state.disableRadio ~= 0 then
							checkFailed = true
							break
						end
						if shouldPlayAnimation and HasAnimDictLoaded(settings.animation.animdict) then
							if not IsEntityPlayingAnim(PlayerPedId(), settings.animation.animdict, settings.animation.anim, 3) then
								TaskPlayAnim(PlayerPedId(), settings.animation.animdict, settings.animation.anim, 10.0,
									5.0, -1, 50, -1.5, false, false, false)
							end
						end
						SetControlNormal(0, 249, 1.0)
						SetControlNormal(1, 249, 1.0)
						SetControlNormal(2, 249, 1.0)
						Wait(0)
					end


					if checkFailed then
						logger.info("Canceling radio talking as the checks have failed.")
						ExecuteCommand("-radiotalk")
					end
					if shouldPlayAnimation then
						RemoveAnimDict(settings.animdict)
					end
				end);
			else
				logger.info("Player tried to talk but was not on a radio channel")
			end
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if not exports["crimelife"]:IsAnimated() then
		local settings = exports["crimelife"]:GetSettings().funk
		if (radioChannel > 0 or radioEnabled) and radioPressed then
			radioPressed = false
			MumbleClearVoiceTargetPlayers(voiceTarget)
			addVoiceTargets(callData)
			TriggerEvent("pma-voice:radioActive", false)
			LocalPlayer.state:set("radioActive", false, true);
			if settings.sound then
				playMicClicks(false)
			end
			if GetConvarInt('voice_enableRadioAnim', 1) == 1 then
				StopAnimTask(PlayerPedId(), settings.animation.animdict, settings.animation.anim, -1.5)
			end
			TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
		end
	end
end, false)

if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	radioChannel = _radioChannel
end

RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)


--- handles "radioEnabled" changing
---@param wasRadioEnabled boolean whether radio is enabled or not
function handleRadioEnabledChanged(wasRadioEnabled)
	if wasRadioEnabled then
		syncRadioData(radioData, "")
	else
		removePlayerFromRadio(playerServerId)
	end
end

--- adds the bit to the disableRadio bits
---@param bit number the bit to add
local function addRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal | bit
	LocalPlayer.state:set("disableRadio", curVal, true)
end
exports("addRadioDisableBit", addRadioDisableBit)

--- removes the bit from disableRadio
---@param bit number the bit to remove
local function removeRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal & (~bit)
	LocalPlayer.state:set("disableRadio", curVal, true)
end
exports("removeRadioDisableBit", removeRadioDisableBit)

RegisterNetEvent("ali:channel", function(channel)
	setRadioChannel(channel)
end);
