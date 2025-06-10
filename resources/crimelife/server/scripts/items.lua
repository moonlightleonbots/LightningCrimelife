ESX.RegisterUsableItem("xpboost", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not PlayerBoost[xPlayer.source] then
        PlayerBoost[xPlayer.source] = true
        Config.HUD.Notify({
            title = "Inventar",
            text = "Du hast deinen 25 Minuten XP-Boost aktiviert du bekommst nun pro Kill 2x so viel XP",
            type = "success",
            time = 7500
        }, xPlayer.source)

        ESX.SetTimeout(25 * 60000, function()
            PlayerBoost[xPlayer.source] = false

            Config.HUD.Notify({
                title = "Inventar",
                text = "Dein XP-Boost ist nun Zuende",
                type = "success",
                time = 7500
            }, xPlayer.source)
        end);
    end
end);

ESX.RegisterUsableItem("moneyboost", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not MoneyBoost[xPlayer.source] then
        MoneyBoost[xPlayer.source] = true
        Config.HUD.Notify({
            title = "Inventar",
            text = "Du hast deinen 25 Minuten Money-Boost aktiviert du bekommst nun pro Kill 2x so viel Geld",
            type = "success",
            time = 7500
        }, xPlayer.source)

        ESX.SetTimeout(25 * 60000, function()
            MoneyBoost[xPlayer.source] = false
            Config.HUD.Notify({
                title = "Inventar",
                text = "Dein Moneyboost ist nun Zuende",
                type = "success",
                time = 7500
            }, xPlayer.source)
        end);
    end
end);

AddEventHandler("playerDropped", function()
    local source = source
    if PlayerBoost[source] then
        PlayerBoost[source] = false
    end
    if MoneyBoost[source] then
        MoneyBoost[source] = false
    end
end);