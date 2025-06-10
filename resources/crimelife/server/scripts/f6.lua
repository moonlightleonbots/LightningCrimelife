ESX.RegisterServerCallback('GetDressing', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        if store then
            local count  = store.count('dressing')
            local labels = {}
            for i = 1, count, 1 do
                local entry = store.get('dressing', i)
                table.insert(labels, entry)
            end
            cb(labels)
        end
    end);
end);

RegisterServerEvent('SaveNewOutfit', function(label, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing')
        if dressing == nil then
            dressing = {}
        end
        table.insert(dressing, {
            label = label,
            skin  = skin
        })
        store.set('dressing', dressing)
    end);
end);

RegisterServerEvent('DeleteOutfit', function(label)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing')
        if dressing == nil then
            dressing = {}
        end

        for _, entry in next, (dressing) do
            if entry.label == label then
                table.remove(dressing, _)
                break
            end
        end

        store.set('dressing', dressing)
    end);
end);
