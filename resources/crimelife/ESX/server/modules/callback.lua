local serverCallbacks = {}

local clientRequests = {}
local RequestId = 0

---@param eventName string
---@param callback function
ESX.RegisterServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent('esx:triggerServerCallback', function(eventName, requestId, invoker, ...)
	local source = source

	serverCallbacks[eventName](source, function(...)
		TriggerClientEvent('esx:serverCallback', source, requestId, invoker, ...)
	end, ...)
end);

---@param player number playerId
---@param eventName string
---@param callback function
---@param ... any
ESX.TriggerClientCallback = function(player, eventName, callback, ...)
	clientRequests[RequestId] = callback

	TriggerClientEvent('esx:triggerClientCallback', player, eventName, RequestId, GetInvokingResource() or "unknown", ...)

	RequestId = RequestId + 1
end

RegisterNetEvent('esx:clientCallback', function(requestId, invoker, ...)
	clientRequests[requestId](...)
	clientRequests[requestId] = nil
end);