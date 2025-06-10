Logs = function(data)
    local embed = {
        color = 0xff2f2f,
        title = data.title,
        description = data.message,
        footer = {
            text = os.date("%x %X %p"),
            icon_url = Config.Discord.designs.logo,
        },
        image = {
            url = Config.Discord.designs.banner.normal,
        }
    }
    PerformHttpRequest(data.webhook, nil, 'POST', json.encode({
        username = data.title,
        embeds = { embed },
        avatar_url = Config.Discord.designs.logo,
    }), { ['Content-Type'] = 'application/json' })
end