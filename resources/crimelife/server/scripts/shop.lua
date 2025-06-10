RegisterNetEvent("buy", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    local label = Config.Server.shop["WEAPONS"][name].label
    local price = Config.Server.shop["WEAPONS"][name].price

    if not xPlayer.hasWeapon(name) then
        if money >= price then
            Config.HUD.Notify({
                title = "Shop",
                text = "Du hast dir die " .. label .. " gekauft.",
                type = "success",
                time = 5000
            }, xPlayer.source)

            xPlayer.removeMoney(price)
            xPlayer.addWeapon(name, 250)
            loadoutUpdate(xPlayer)
        else
            Config.HUD.Notify({
                title = "Shop",
                text = "Du hast nicht genug geld um dir die " ..
                    label .. " zu kaufen dir fehlen  " .. money - price .. "$  .",
                type = "error",
                time = 5000
            }, xPlayer.source)
        end
    end
end);

RegisterNetEvent("sell", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local label = Config.Server.shop["WEAPONS"][name].label
    local price = Config.Server.shop["WEAPONS"][name].price

    if xPlayer.hasWeapon(name) then
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast die waffe " .. label .. " für den Halben Preis (" .. price .. ") Verkauft.",
            type = "info",
            time = 5000
        }, xPlayer.source)

        xPlayer.addMoney(price)
        xPlayer.removeWeapon(name)
        loadoutUpdate(xPlayer)
    else
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast nicht die waffe " .. label .. " um sie zu verkaufen.",
            type = "error",
            time = 5000
        }, xPlayer.source)
    end
end);

RegisterNetEvent("buyItem", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    local price = Config.Server.shop["ITEMS"][name].price

    if money >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(name, 1)
        updateInventory(xPlayer)
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast dir " .. Config.Server.shop["ITEMS"][name].label .. " gekauft.",
            type = "success",
            time = 5000
        }, xPlayer.source)
    else
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast nicht genug geld um dir " .. Config.Server.shop["ITEMS"][name].label .. " zu kaufen.",
            type = "error",
            time = 5000
        }, xPlayer.source)
    end
end);

ESX.RegisterServerCallback("canBuyEffect", function(s, cb, index)
    local xPlayer = ESX.GetPlayerFromId(s)
    local price = Config.Server.shop["KILLEFFECTS"][index].price
    local label = Config.Server.shop["KILLEFFECTS"][index]

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb(true)
    else
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast nicht genug geld um dir den Killeffekt " .. label .. " zu kaufen.",
            type = "error",
            time = 5000
        }, xPlayer.source)
        cb(false)
    end
end);

RegisterNetEvent("sell_effect", function(index)
    local price = Config.Server.shop["KILLEFFECTS"][index].price
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addMoney(price / 2)
end)

RegisterNetEvent("buyCase", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coins = xPlayer.getAccount("coins").money

    local Case = {
        name = data.name,
        price = tonumber(data.price),
    }

    if coins >= Case.price then
        xPlayer.removeAccountMoney("coins", Case.price)
        TriggerClientEvent("openCase", xPlayer.source, data.index, xPlayer.getAccount("coins").money)
    else
        Config.HUD.Notify({
            title = "Shop",
            text = "Du hast nicht genug Coins um dir " .. Case.name .. " zu kaufen.",
            type = "error",
            time = 5000
        }, xPlayer.source)
    end
end)
