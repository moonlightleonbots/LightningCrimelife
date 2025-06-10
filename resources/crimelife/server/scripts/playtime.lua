ESX.RegisterServerCallback("playtime:giveReward", function(source, cb, type, count, item)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type == "money" then
        xPlayer.addMoney(tonumber(count))
    elseif type == "item" then
        xPlayer.addInventoryItem(item, tonumber(count))
        updateInventory(xPlayer)
    elseif type == "xp" then
        CachedPlayer[xPlayer.identifier].xp = CachedPlayer[xPlayer.identifier].xp + tonumber(count);
    end
end);