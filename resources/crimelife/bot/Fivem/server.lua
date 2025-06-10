local res = GetCurrentResourceName()

ExecuteCommand("add_ace group.PermissionsBypass command allow");

ExecuteCommand("add_principal resource." .. res .. " group.PermissionsBypass");

local jsonFile = LoadResourceFile(GetCurrentResourceName(), 'bot/config.json')
local jsonified = json.decode(jsonFile)

for k, permissionObject in next, (jsonified.IN_GAME_PERMISSIONS.PERMISSIONS) do
    for i, permissionValue in next, (permissionObject) do
        ExecuteCommand("add_ace group.superPermissions " .. permissionValue .. " allow")
    end
end

RegisterNetEvent("FG_Aimbot:BanPlayerLicense", function(license)
    if source ~= "" then return end
    local id = GetIDByLicense(license)
    exports[jsonified.FIVEGUARD_RESOURCE_NAME]:fg_BanPlayer(id, "Possible Aimbot Detected [8] - Guck Logs", true)
end);

RegisterNetEvent("FG_Silent:BanPlayerLicense", function(license)
    if source ~= "" then return end
    local id = GetIDByLicense(license)
    exports[jsonified.FIVEGUARD_RESOURCE_NAME]:fg_BanPlayer(id, "Possible Silent or Magic Bullets Detected [8] - Guck Logs", true)
end);


-- PCA, Cheating und Modding FG Ban
-- RegisterNetEvent("FG_PCA:BanPlayerLicense", function(license)
--     if source ~= "" then return end
--     local id = GetIDByLicense(license)
--     exports[jsonified.FIVEGUARD_RESOURCE_NAME]:fg_BanPlayer(id, "PCA Ban - txAdmin", true)
-- end);

-- RegisterNetEvent("FG_Modding:BanPlayerLicense", function(license)
--     if source ~= "" then return end
--     local id = GetIDByLicense(license)
--     exports[jsonified.FIVEGUARD_RESOURCE_NAME]:fg_BanPlayer(id, "Modding Ban - txAdmin", true)
-- end);

-- RegisterNetEvent("FG_Cheating:BanPlayerLicense", function(license)
--     if source ~= "" then return end
--     local id = GetIDByLicense(license)
--     exports[jsonified.FIVEGUARD_RESOURCE_NAME]:fg_BanPlayer(id, "Cheating Ban - txAdmin", true)
-- end);

-- WaveShield
RegisterNetEvent("WS_Unban:WaveShieldExports", function(banId, reason, from)
    print(('[^2INFO^7] >> [^6DISCORD_WS^7] >> Unban request received from: ^6%s^7 with reason: ^6%s^7'):format(from, reason))
    exports["WaveShield"]:unbanPlayer(banId, reason, from)
end);

function GetIDByLicense(license)
    for index, id in next, (GetPlayers()) do
        if GetPlayerIdentifierByType(id, "license") == license then
            return id
        end
    end
end
