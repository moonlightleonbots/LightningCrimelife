local Debug = false;
local Resource = GetCurrentResourceName();
local SavedIds = json.decode(LoadResourceFile(Resource, 'json/save.json'));

local HandleHTTPResponse = function(StatusCode, ResultData, ResultHeaders, Error, CustomId)
  if StatusCode == 200 or StatusCode == 204 then
    ResultData = ResultData and json.decode(ResultData);

    if ResultData and ResultData.id then
      SavedIds[CustomId] = ResultData.id;
      SaveResourceFile(Resource, 'json/save.json', json.encode(SavedIds), -1);
    end
  else
    Config.Server.Debug('Status Code: '..StatusCode);
    Config.Server.Debug('^1Webhook Error: '.. (Error or 'N/A')..'^0');
  end
end;

local SendWebhook = function(Webhook, Data, CustomId)
  if CustomId then
    if SavedIds[CustomId] then
      Webhook = Webhook..'/messages/'..SavedIds[CustomId];
    end

    PerformHttpRequest(Webhook..'?wait=true', function(StatusCode, ResultData, ResultHeaders, Error)
      HandleHTTPResponse(StatusCode, ResultData, ResultHeaders, Error, CustomId);
    end, (SavedIds[CustomId] and 'PATCH' or 'POST'), json.encode(Data), {['Content-Type'] = 'application/json'});
  else
    PerformHttpRequest(
      Webhook,
      HandleHTTPResponse,
      'POST',
      json.encode(Data),
      {['Content-Type'] = 'application/json'}
    );
  end
end;

exports('SendWebhook', SendWebhook);