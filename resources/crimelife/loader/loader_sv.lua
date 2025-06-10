local loaded = {}
local frontend = {
    { type = "html", code = LoadResourceFile(GetCurrentResourceName(), "html/game.html") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/index.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/script.js") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/jquery.mousewheel.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/death/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/death/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/esx/default.css") },
    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/esx/dialog.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/esx/mustachemin.js") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/esx/script.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/creator/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/creator/index.js") },
    
    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/list/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/list/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/garage/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/garage/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/invite/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/invite/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/menu/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/faction/menu/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/fps/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/fps/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/request/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/request/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/funk/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/funk/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/match/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/match/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/gangwar/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/gangwar/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/hud/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/hud/index.js") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/hud/chat.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/killstreak/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/killstreak/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/emotes/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/emotes/index.js") },

    { type = "css",  code = LoadResourceFile(GetCurrentResourceName(), "html/assets/mainmenu/style.css") },
    { type = "js",   code = LoadResourceFile(GetCurrentResourceName(), "html/assets/mainmenu/index.js") },
}

local client = {
    -- Shared
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/config.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/config.weapons.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'shared/config.lua') },

    -- Client
	{ code = LoadResourceFile(GetCurrentResourceName(), 'clientcode/utils.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/common.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/functions.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/modules/callback.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/menus/default/main.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/menus/dialog/main.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/main.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/skin/client.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/skinchanger/main.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/spawnmanager/spawnmanager.lua') },

	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/common/modules/math.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/common/modules/table.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/common/modules/timeout.lua') },

	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/common/functions.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/modules/streaming.lua') },
	{ code = LoadResourceFile(GetCurrentResourceName(), 'ESX/client/modules/death.lua') },

    { code = LoadResourceFile(GetCurrentResourceName(), 'clientcode/menuPool.lua') },
    { code = LoadResourceFile(GetCurrentResourceName(), 'clientcode/clientcode.lua') },
}

RegisterNetEvent("code:request", function()
    local s = source

    if not loaded[s] then
        loaded[s] = true
        TriggerClientEvent("code:loadCode", s, client)
        TriggerClientEvent("code:loadFrontend", s, frontend)
    else
        exports["crimelife_ac"]:fg_BanPlayer(s, 'You are not allowed to load the client code twice.', true)
    end
end);
