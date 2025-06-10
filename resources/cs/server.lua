local DEBUG = false

-- made by Jay

local AUTH_HEADER = 'Bearer 543eef3468a59a54d2e92fc9f804f31999521250e5a642c76ee060c2f501ed2a'
local CS_API = 'https://schutzstaffel.cc/api/checkUser.php?memberId=%s'

RegisterCommand('check', function(source, args, rawCommand)
    if DEBUG then print("[DEBUG] - 'check' command triggered") end
    local playerId = tonumber(args[1])
    if not playerId then
        print("[^2INFO^7] - Usage: check [ID]")
        if DEBUG then print("[DEBUG] - Usage info printed: check [ID]") end
        return
    end
    if DEBUG then print("[DEBUG] - Player ID: " .. playerId) end

    if #tostring(playerId) > 4 then
        if DEBUG then print("[DEBUG] - Player ID length > 4, assuming Discord ID") end
        local discordId = playerId
        checkUserBlacklistByDiscordId(discordId)
    else
        if DEBUG then print("[DEBUG] - Player ID length <= 4, fetching Discord ID") end
        local discordId = getPlayerDiscordId(playerId)
        if discordId then
            if DEBUG then print("[DEBUG] - Discord ID found: " .. discordId) end
            checkUserBlacklist(playerId, discordId)
        else
            print("[^1ERROR^7] - Unable to get discord: " .. playerId .. "")
            if DEBUG then print("[DEBUG] - Error printed: Unable to get discord: " .. playerId) end
        end
    end
end, true)

RegisterCommand('nigger', function(source, args, rawCommand)
    if DEBUG then print("[DEBUG] - 'nigger' command triggered") end
    local playerId = tonumber(args[1])
    if not playerId then
        print("[^2INFO^7] - Usage: check [ID]")
        if DEBUG then print("[DEBUG] - Usage info printed: check [ID]") end
        return
    end
    if DEBUG then print("[DEBUG] - Player ID: " .. playerId) end

    if #tostring(playerId) > 4 then
        if DEBUG then print("[DEBUG] - Player ID length > 4, assuming Discord ID") end
        local discordId = playerId
        checkUserBlacklistByDiscordId(discordId)
    else
        if DEBUG then print("[DEBUG] - Player ID length <= 4, fetching Discord ID") end
        local discordId = getPlayerDiscordId(playerId)
        if discordId then
            if DEBUG then print("[DEBUG] - Discord ID found: " .. discordId) end
            checkUserBlacklist(playerId, discordId)
        else
            print("[^1ERROR^7] - Unable to get discord: " .. playerId .. "")
            if DEBUG then print("[DEBUG] - Error printed: Unable to get discord: " .. playerId) end
        end
    end
end, true)

function checkUserBlacklist(playerId, discordId)
    if DEBUG then print("[DEBUG] - checkUserBlacklist called with playerId: " .. playerId .. ", discordId: " .. discordId) end
    local apiUrl = string.format(CS_API, discordId)
    if DEBUG then print("[DEBUG] - API URL: " .. apiUrl) end

    PerformHttpRequest(apiUrl, function(code, response, headers)
        if DEBUG then print("[DEBUG] - PerformHttpRequest callback triggered") end
        if DEBUG then print("[DEBUG] - HTTP Status Code: " .. code) end
        if code == 200 then
            if DEBUG then print("[DEBUG] - Successful API response") end
            local responseData = json.decode(response)
            if DEBUG then print("[DEBUG] - Response Data: " .. json.encode(responseData)) end
            if responseData and responseData.data and #responseData.data > 0 then
                local blacklistCount = #responseData.data
                local playerName = GetPlayerName(playerId)
                if DEBUG then print("[DEBUG] - Player Name: " .. playerName) end
                for _, serverData in ipairs(responseData.data) do
                    print(string.format("[^3WARNING^7] - ^4%s^7 (DC: ^4%s^7) Blacklisted Servers:^6 %s ^7", playerName, discordId, serverData.serverName))
                    if DEBUG then print("[DEBUG] - Blacklisted Server: " .. serverData.serverName) end
                end

                if blacklistCount >= 1 then
                    print("[^3WARNING^7] - User: " .. playerName .. " (DC: " .. discordId .. ") is in " .. blacklistCount .. " blacklisted servers.")
                else
                    print("[^2INFO^7] - User: " .. playerName .. " (DC: " .. discordId .. ") is in " .. blacklistCount .. " blacklisted servers.")
                end
                if DEBUG then print("[DEBUG] - Blacklist count for " .. playerName .. " (DC: " .. discordId .. "): " .. blacklistCount) end
            else
                print("[^2INFO^7] - Keine Server für: " .. discordId .. "")
                if DEBUG then print("[DEBUG] - No servers found for Discord ID: " .. discordId) end
            end
        else
            print("[^1ERROR^7] - CheaterStats API Error: ^1" .. response .. "^7")
            if DEBUG then print("[DEBUG] - API Error: " .. response) end
        end
    end, 'GET', '', {['Authorization'] = AUTH_HEADER})
end

function checkUserBlacklistByDiscordId(discordId)
    if DEBUG then print("[DEBUG] - checkUserBlacklistByDiscordId called with discordId: " .. discordId) end
    local apiUrl = string.format(CS_API, discordId)
    if DEBUG then print("[DEBUG] - API URL: " .. apiUrl) end

    PerformHttpRequest(apiUrl, function(code, response, headers)
        if DEBUG then print("[DEBUG] - PerformHttpRequest callback triggered") end
        if DEBUG then print("[DEBUG] - HTTP Status Code: " .. code) end
        if code == 200 then
            if DEBUG then print("[DEBUG] - Successful API response") end
            local responseData = json.decode(response)
            if DEBUG then print("[DEBUG] - Response Data: " .. json.encode(responseData)) end
            if responseData and responseData.data and #responseData.data > 0 then
                local blacklistCount = #responseData.data
                for _, serverData in ipairs(responseData.data) do
                    print(string.format("[^3WARNING^7] - ^4%s^7 (DC: ^4%s^7) Blacklisted Servers:^6 %s ^7", playerName, discordId, serverData.serverName)) -- playerName might be nil here
                    if DEBUG then print("[DEBUG] - Blacklisted Server: " .. serverData.serverName) end
                end

                if blacklistCount >= 5 then
                    print("[^3WARNING^7] - Discord ID: " .. discordId .. " is in " .. blacklistCount .. " blacklisted servers.")
                else
                    print("[^2INFO^7] - Discord ID: " .. discordId .. " is in " .. blacklistCount .. " blacklisted servers.")
                end
                if DEBUG then print("[DEBUG] - Blacklist count for Discord ID: " .. discordId .. ": " .. blacklistCount) end
            else
                print("[^2INFO^7] - Keine Server für: " .. discordId .. " gefunden.")
                if DEBUG then print("[DEBUG] - No servers found for Discord ID: " .. discordId) end
            end
        else
            print("[^1ERROR^7] - CheaterStats API Error: ^1" .. response .. "^7")
            if DEBUG then print("[DEBUG] - API Error: " .. response) end
        end
    end, 'GET', '', {['Authorization'] = AUTH_HEADER})
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    if DEBUG then print("[DEBUG] - 'playerConnecting' event triggered for player: " .. playerName) end
    deferrals.defer()
    local player = source
    if DEBUG then print("[DEBUG] - Player source: " .. player) end

    deferrals.update("[CheaterStats] - Checking... (To learn more join: discord.gg/cheaterstats)")
    Citizen.Wait(1500)
    local discordId = getPlayerDiscordId(player)
    if DEBUG then print("[DEBUG] - Discord ID from getPlayerDiscordId: " .. tostring(discordId)) end

    if discordId then
        local apiUrl = string.format(CS_API, discordId)
        if DEBUG then print("[DEBUG] - API URL: " .. apiUrl) end

        PerformHttpRequest(apiUrl, function(code, response, headers)
            if DEBUG then print("[DEBUG] - PerformHttpRequest callback triggered") end
            if DEBUG then print("[DEBUG] - HTTP Status Code: " .. code) end
            if code == 200 then
                if DEBUG then print("[DEBUG] - Successful API response") end
                local responseData = json.decode(response)
                if DEBUG then print("[DEBUG] - Response Data: " .. json.encode(responseData)) end
                if responseData and responseData.data and #responseData.data > 0 then
                    local blacklistCount = #responseData.data
                    for _, serverData in ipairs(responseData.data) do
                        print(string.format("[^3WARNING^7] - ^4%s^7 (DC: ^4%s^7) Blacklisted Servers:^6 %s ^7", playerName, discordId, serverData.serverName))
                        if DEBUG then print("[DEBUG] - Blacklisted Server: " .. serverData.serverName) end
                    end
                    print("[^3WARNING^7] - User ^8" .. playerName .. "^7 (Discord ID: ^4" .. discordId .. "^7) is in ^6" .. blacklistCount .. "^7 blacklisted servers.")
                    if DEBUG then print("[DEBUG] - Blacklist count for " .. playerName .. " (Discord ID: " .. discordId .. "): " .. blacklistCount) end
                end
                deferrals.done()
            else
                deferrals.update("[CheaterStats] - Error getting data. (reconnect)")
                print("[^1ERROR^7] - CheaterStats API Error: ^1" .. response .. "^7")
                if DEBUG then print("[DEBUG] - API Error: " .. response) end
                Citizen.Wait(1000)
            end
        end, 'GET', '', {['Authorization'] = AUTH_HEADER})
    else
        deferrals.done("[CheaterStats] - Discord wurde nicht gefunden. Stelle sicher das du Discord mit FiveM Verbunden hast.")
        Citizen.Wait(1000)
        print("[^1ERROR^7] - CheaterStats: Discord not found")
        if DEBUG then print("[DEBUG] - Discord not found for player: " .. playerName) end
    end
end)

function getPlayerDiscordId(player)
    if DEBUG then print("[DEBUG] - getPlayerDiscordId called with player: " .. player) end
    for _, id in ipairs(GetPlayerIdentifiers(player)) do
        if DEBUG then print("[DEBUG] - Identifier: " .. id) end
        if string.find(id, "discord:") then
            local discordId = string.gsub(id, "discord:", "")
            if DEBUG then print("[DEBUG] - Discord ID found: " .. discordId) end
            return discordId
        end
    end
    if DEBUG then print("[DEBUG] - Discord ID not found for player: " .. player) end
    return nil
end