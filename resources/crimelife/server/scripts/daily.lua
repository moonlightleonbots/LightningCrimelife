RegisterCommand("daily", function(source)
    local s = source
    local xPlayer = ESX.GetPlayerFromId(s)
    local last_daily = MySQL.scalar.await('SELECT last_daily FROM users WHERE identifier=?', { xPlayer.identifier })
    local wait_time = 24 * 60 * 60

    local diff = os.difftime(os.time(), last_daily)

    if diff >= wait_time then
        MySQL.update('UPDATE users SET last_daily=UNIX_TIMESTAMP() WHERE identifier=?', { xPlayer.identifier })
        local reward = ""

        local money = Config.pvp.MoneyDrops.win
        xPlayer.addMoney(money)
        reward = "Du hast $" .. money .. " bekommen."
        reward = reward .. " Du kannst wieder in 24 Stunden Uhr kommen, um deine nächste Belohnung abzuholen."

        Config.HUD.Notify({
            title = "Tägliche Belohnung",
            text = reward,
            type = "success",
            time = 5000
        }, xPlayer.source)
    else
        local next_available = os.date("%X", last_daily + wait_time)

        Config.HUD.Notify({
            title = 'DailyReward',
            text = "Du hast deine tägliche Belohnung bereits erhalten. Bitte warte bis " ..
                next_available .. " um deine nächste Belohnung abzuholen.",
            time = 5000,
            type = "error"
        }, xPlayer.source)
    end
end, false)
