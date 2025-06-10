local RequestId = 0
local serverRequests = {}

local clientCallbacks = {}

---@param eventName string
---@param callback function
---@param ... any
ESX.TriggerServerCallback = function(eventName, callback, ...)
	serverRequests[RequestId] = callback

	TriggerServerEvent('esx:triggerServerCallback', eventName, RequestId, GetInvokingResource() or "unknown", ...)

	RequestId = RequestId + 1
end

RegisterNetEvent('esx:serverCallback', function(requestId, invoker, ...)
	if not serverRequests[requestId] then
		return Config.Server.Debug(("^1Error^7: Callback with id %s does not exist"):format(requestId))
	end

	serverRequests[requestId](...)
	serverRequests[requestId] = nil
end);

---@param eventName string
---@param callback function
ESX.RegisterClientCallback = function(eventName, callback)
	clientCallbacks[eventName] = callback
end

RegisterNetEvent('esx:triggerClientCallback', function(eventName, requestId, invoker, ...)
	clientCallbacks[eventName](function(...)
		TriggerServerEvent('esx:clientCallback', requestId, invoker, ...)
	end, ...)
end);
