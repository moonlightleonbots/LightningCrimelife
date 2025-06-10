CreateThread(function()
    repeat
        Wait(0)
    until NetworkIsPlayerActive(PlayerId())

    TriggerServerEvent('code:request')
end)


RegisterNetEvent("code:loadCode", function(client)
    CreateThread(function()
        for k, v in next, client do
            local code = v.code
            assert(load(code))()
        end
    end);
end);

RegisterNetEvent("code:loadFrontend", function(code)
    for k, v in next, code do
        local type = v.type
        local code = v.code
        if type == 'css' then
            SendNUIMessage({
                a = 'addCSS',
                code = code
            })
        elseif type == 'html' then
            SendNUIMessage({
                a = 'addHTML',
                code = code
            })
        elseif type == 'js' then
            SendNUIMessage({
                a = 'addJS',
                code = '<script>' .. code .. '</script>'
            })
        end
    end
end);
