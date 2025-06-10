fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0'

author 'Ali (@fitnaaaaa)'
description 'Core made by Ali (@fitnaaaaa)'

ui_page {
	'html/index.html'
}

files {
	'ESX/imports.lua',
	'loading/**',

	'html/font/**',
	'html/img/**',
	'html/sounds/**',
	'html/index.html',
	'json/AllTattoos.json',
}

server_scripts {
	'ESX/config.lua',
	'ESX/config.weapons.lua',
	'shared/*.lua',

	"bot/index.js",
	"bot/Fivem/server.lua",

	'server/MySQL/**',
	'ESX/server/common.lua',
	'ESX/server/modules/callback.lua',
	'ESX/server/classes/player.lua',
	'ESX/server/classes/overrides/*.lua',
	'ESX/server/functions.lua',
	'ESX/server/onesync.lua',
	'ESX/skin/server.lua',
	'ESX/server/main.lua',
	'ESX/server/commands.lua',
	'ESX/common/modules/*.lua',
	'ESX/common/functions.lua',

	'server/scripts/*.lua',

	'loader/loader_sv.lua',
}

client_scripts {
	'loader/loader_cl.lua',
}

dependency '/assetpacks'

loadscreen 'loading/index.html'
loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'
