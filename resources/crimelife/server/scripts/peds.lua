ESX.RegisterServerCallback('PlayerData:getskin', function(source, cb, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb(nil, nil)
        return
    end

    MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(users)
        if users and users[1] then
            local user, skin = users[1]
            local jobSkin = {
                skin_male   = xPlayer.job.skin_male,
                skin_female = xPlayer.job.skin_female
            }

            if user and user.skin then
                skin = json.decode(user.skin)
            end
            cb(skin, jobSkin)
        else
            cb(nil, nil)
        end
    end);
end);