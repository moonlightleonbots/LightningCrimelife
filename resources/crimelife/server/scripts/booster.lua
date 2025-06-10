RegisterCommand("booster", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(source, Config.Discord.roles["Booster"], data)

    if data then
        if role then
            if not xPlayer.hasWeapon(Config.Discord.Booster.name) then
                Config.HUD.Notify({
                    title = "BOOSTER",
                    text = "Du hast durch dein Boost eine " .. Config.Discord.Booster.label .. "  erhalten erhalten",
                    type = "success",
                    time = 5000
                }, xPlayer.source)

                xPlayer.addWeapon(Config.Discord.Booster.name, 250)
                loadoutUpdate(xPlayer)
            else
                Config.HUD.Notify({
                    title = "BOOSTER",
                    text = "Du hast bereits eine " .. Config.Discord.Booster.label .. " ",
                    type = "info",
                    time = 5000
                }, xPlayer.source)
            end
        else
            Config.HUD.Notify({
                title = "BOOSTER",
                text = "Du hast den Discord Server nicht Boosted",
                type = "error",
                time = 5000
            }, xPlayer.source)
        end
    end
end, false)
