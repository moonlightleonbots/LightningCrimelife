RegisterNetEvent("inventory:trash", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.source and xPlayer.hasWeapon(name) then
        Config.HUD.Notify({
            title = "Inventar",
            text = "Du hast " .. name .. " weggeworfen",
            type = "success",
            time = 5000
        }, xPlayer.source)

        xPlayer.removeWeapon(name)
        loadoutUpdate(xPlayer)
    end
end);

RegisterNetEvent("share", function(name, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(id)

    if xPlayer and xPlayer.source and xPlayer.hasWeapon(name) then
        if target and target.source then
            Config.HUD.Notify({
                title = "Inventar",
                text = "Du hast " .. name .. " an " .. target.name .. " gegeben",
                type = "success",
                time = 5000
            }, xPlayer.source)

            Config.HUD.Notify({
                title = "Inventar",
                text = "Du hast " .. name .. " von " .. xPlayer.name .. " erhalten",
                type = "success",
                time = 5000
            }, target.source)

            xPlayer.removeWeapon(name)
            target.addWeapon(name)

            xPlayer.removeWeapon(name)
            target.addWeapon(name, 255)

            loadoutUpdate(xPlayer)
            loadoutUpdate(target)

            if components == nil then
                components = {}
            end
            for i = 1, #components do
                target.addCurrentWeaponComponent(name, components[i])
            end
        end
    end
end);

RegisterNetEvent('inventar:buyAttachment', function(weapon, name, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = nil

    for k, v in next, ESX.GetWeaponList() do
        if (v.name) == (weapon) then
            for _, component in next, v.components do
                if component.name == name then
                    if xPlayer.hasWeaponComponent((weapon), name) then
                        price = ESX.Round(component.price / 2)
                    else
                        price = component.price
                    end
                    break
                end
            end
            break
        end
    end

    if price and xPlayer.getAccount("money").money >= price then
        xPlayer.removeAccountMoney("money", price)
        xPlayer.addWeaponComponent((weapon), name)
        loadoutUpdate(xPlayer)
        Config.HUD.Notify({
            title = 'Inventar',
            text = 'Du hast eine ' .. label .. ' gekauft!',
            time = 5000,
            type = 'success'
        }, xPlayer.source)
    else
        Config.HUD.Notify({
            title = 'Inventar',
            text = 'Du hast nicht genug Geld!',
            time = 5000,
            type = 'error'
        }, xPlayer.source)
    end
end);

RegisterNetEvent('inventar:sellAttachment', function(weapon, name, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.hasWeaponComponent(weapon, name) then
        local price = nil

        for k, v in next, ESX.GetWeaponList() do
            if (v.name) == (weapon) then
                for _, component in next, v.components do
                    if component.name == name then
                        if xPlayer.hasWeaponComponent((weapon), name) then
                            price = ESX.Round(component.price / 2)
                        else
                            price = component.price
                        end
                        break
                    end
                end
                break
            end
        end
        xPlayer.addAccountMoney("money", price)
        xPlayer.removeWeaponComponent((weapon), name)
        loadoutUpdate(xPlayer)
        Config.HUD.Notify({
            title = 'Inventar',
            text = 'Du hast einen ' .. name .. ' verkauft!',
            time = 5000,
            type = 'error'
        }, xPlayer.source)
    end
end);

RegisterNetEvent("inventory:trash-item", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventoryItem(name)

    if inventory.count > 0 then
        xPlayer.removeInventoryItem(name, 1)

        Config.HUD.Notify({
            title = "Inventar",
            text = "Du hast " .. name .. " weggeworfen",
            type = "success",
            time = 5000
        }, xPlayer.source)

        updateInventory(xPlayer)
    end
end);

RegisterNetEvent("inventory:use", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(name).count > 0 then
        ESX.UseItem(xPlayer.source, name)
        xPlayer.removeInventoryItem(name, 1)

        updateInventory(xPlayer)
    end
end);
