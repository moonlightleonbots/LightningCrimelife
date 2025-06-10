local isRoll = false
local spinningPerson = 0
local Prices = Config.Server.Prices

RegisterNetEvent('wheel:giveWin', function()
    local s = source
    if spinningPerson == s then
        local xPlayer = ESX.GetPlayerFromId(s)
        isRoll = false
        local array = math.random(1, #Prices)
        if Prices[array].type == 'money' then
            xPlayer.addMoney(Prices[array].count)

            Config.HUD.Notify({
                title = 'Lucky Wheel',
                text = 'Spieler ' .. xPlayer.name .. ' hat ' .. Prices[array].count .. '$ gewonnen',
                type = "success",
                time = 5000
            }, s)
        elseif Prices[array].type == 'weapon' then
            xPlayer.addWeapon(Prices[array].name:upper(), 1)
            loadoutUpdate(xPlayer)
            Config.HUD.Notify({
                title = 'Lucky Wheel',
                text = 'Spieler ' ..
                    xPlayer.name .. ' hat ' .. ESX.GetWeaponLabel(Prices[array].name:upper()) .. ' gewonnen',
                type = "success",
                time = 5000
            }, s)
        elseif Prices[array].type == 'item' then
            xPlayer.addInventoryItem(Prices[array].name, Prices[array].count)
            updateInventory(xPlayer)

            Config.HUD.Notify({
                title = 'Lucky Wheel',
                text = 'Spieler ' .. xPlayer.name .. ' hat ' .. Prices[array].count .. 'x ' ..
                    ESX.GetItemLabel(Prices[array].name) .. ' gewonnen',
                type = "success",
                time = 5000
            }, s)
        end
        TriggerClientEvent('wheel:accecAllToRoll', -1)
    end
end);

RegisterServerEvent('wheel:activeRolling_sv', function()
    isRoll = false
end);

ESX.RegisterServerCallback('getItemCount', function(src, cb, name)
    local xPlayer = ESX.GetPlayerFromId(src)
    local count = xPlayer.getInventoryItem(name).count

    if count > 0 then
        cb(true)
        xPlayer.removeInventoryItem(name, 1)
        updateInventory(xPlayer)

        if not isRoll then
            isRoll = true
            spinningPerson = xPlayer.source
            local rnd = math.random(1, 1000)
            local price, priceIndex
            for index, data in next, (Prices) do
                if (rnd > data.probability.min) and (rnd <= data.probability.max) then
                    price = data
                    priceIndex = index
                    break
                end
            end
            TriggerClientEvent('wheel:roll_Animation', xPlayer.source, priceIndex)
            TriggerClientEvent('wheel:selectWin', -1, xPlayer.source, price)
        else
            Config.HUD.Notify({
                title = 'Lucky Wheel',
                text = 'Es wird bereits am Rad gedreht',
                type = "error",
                time = 5000
            }, xPlayer.source)
        end
    else
        cb(false)
        Config.HUD.Notify({
            title = 'Lucky Wheel',
            text = 'Du hast nicht genug ' .. ESX.GetItemLabel(name),
            type = "error",
            time = 5000
        }, src)
    end
end)
