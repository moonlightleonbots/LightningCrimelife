MySQL.ready(function()
    MySQL.query([[ALTER TABLE `users`
ADD COLUMN IF NOT EXISTS `xp` INT(255) DEFAULT 0,
ADD COLUMN IF NOT EXISTS `quests` LONGTEXT DEFAULT '{"ffa_kills": 0, "kills": 0, "headshots": 0, "streaks": 0, "ffajoin": 0, "gungamejoin": 0}',
ADD COLUMN IF NOT EXISTS `collected_quest` LONGTEXT DEFAULT '{"kills": false, "ffa_kills": false, "streaks": false, "ffajoin": false, "headshots": false, "gungamejoin": false}',
ADD COLUMN IF NOT EXISTS `collected` LONGTEXT DEFAULT '{}';
]], {}, function()
        local reseted = false;
        CreateThread(function()
            while true do
                Wait(1000 * 60)
                if os.date('%H:%M') == "00:00" then
                    if not reseted then
                        reseted = true
                        MySQL.Async.execute([[
                            UPDATE users
                            SET collected_quest = JSON_SET(collected_quest,
                                '$.kills', false,
                                '$.ffa_kills', false,
                                '$.streaks', false,
                                '$.ffajoin', false,
                                '$.gungamejoin', false,
                                '$.headshots', false)
                            WHERE 1;
                        ]])

                        MySQL.Async.execute([[
                            UPDATE users
                            SET quests = JSON_SET(quests,
                                '$.kills', 0,
                                '$.ffa_kills', 0,
                                '$.streaks', 0,
                                '$.ffajoin', 0,
                                '$.gungamejoin', 0,
                                '$.headshots', 0)
                            WHERE 1;
                        ]])
                    end
                end

                if os.date('%H:%M') == "00:01" then
                    reseted = false
                end
            end
        end);

        RegisterNetEvent("battlepass:collect", function(data)
            local xPlayer = ESX.GetPlayerFromId(source);
            local collected = json.decode(MySQL.scalar.await('SELECT collected FROM users WHERE identifier=? LIMIT 1', {
                xPlayer.identifier
            }));
            local ITEM_DATA = Config.Battlepass.Levels[data.index]["free"];
            collected[tostring(data.index)] = true;
            MySQL.update('UPDATE users SET collected=? WHERE identifier=?', {
                json.encode(collected),
                xPlayer.identifier
            }, function()
                if ITEM_DATA.reward.type == 'boost' then
                    xPlayer.addInventoryItem(ITEM_DATA.reward.data, 1);
                    updateInventory(xPlayer)
                elseif ITEM_DATA.reward.type == 'weapon' then
                    xPlayer.addWeapon(ITEM_DATA.reward.data, 30);
                    loadoutUpdate(xPlayer)
                elseif ITEM_DATA.reward.type == 'money' then
                    xPlayer.addMoney(ITEM_DATA.reward.data);
                end
            end);
        end);

        RegisterNetEvent("battlepass:collect_premium", function(data)
            local xPlayer = ESX.GetPlayerFromId(source);
            local collected_premium = json.decode(MySQL.scalar.await(
            'SELECT collected_premium FROM users WHERE identifier=? LIMIT 1', {
                xPlayer.identifier
            }));
            local ITEM_DATA = Config.Battlepass.Levels[data.index]["premium"];
            collected_premium[tostring(data.index)] = true;
            MySQL.update('UPDATE users SET collected_premium=? WHERE identifier=?', {
                json.encode(collected_premium),
                xPlayer.identifier
            }, function()
                if ITEM_DATA.reward.type == 'boost' then
                    xPlayer.addInventoryItem(ITEM_DATA.reward.data, 1);
                    updateInventory(xPlayer)
                elseif ITEM_DATA.reward.type == 'weapon' then
                    xPlayer.addWeapon(ITEM_DATA.reward.data, 30);
                    loadoutUpdate(xPlayer)
                elseif ITEM_DATA.reward.type == 'money' then
                    xPlayer.addMoney(ITEM_DATA.reward.data);
                end
            end);
        end);

        RegisterNetEvent("battlepass:changeMoneyToXp", function(data)
            local s = source;
            local xPlayer = ESX.GetPlayerFromId(s);

            local moneyTheyPayd = tonumber(data.money);
            local xpTheyGet = tonumber(data.xp);

            if xPlayer.getMoney() >= moneyTheyPayd then
                Config.HUD.Notify({
                    title = "Battlepass",
                    text = "Du Hast erfolgreich " .. moneyTheyPayd .. " für " .. xpTheyGet .. " XP getauscht",
                    type = "success",
                    time = 5000,
                }, xPlayer.source)

                CachedPlayer[xPlayer.identifier].xp = CachedPlayer[xPlayer.identifier].xp + xpTheyGet;
                TriggerClientEvent("stats:update", xPlayer.source, CachedPlayer[xPlayer.identifier])
                xPlayer.removeMoney(moneyTheyPayd);
            end
        end);

        RegisterNetEvent("UpdateQuest", function(data)
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.identifier then
                CachedPlayer[xPlayer.identifier].quests = data
            end
        end);

        RegisterNetEvent("quests:playerKilled", function(s)
            TriggerClientEvent("quests:playerKilled", s)
        end);

        local claimed = false
        RegisterNetEvent('claimQuest', function(collected_quest)
            local s = source
            local Prices = Config.Server.Prices;
            local xPlayer = ESX.GetPlayerFromId(s)
            local array = math.random(1, #Prices)

            if claimed then
                return Config.HUD.Notify({
                    title = 'Lucky Wheel',
                    text = 'Du hast bereits einen Preis beansprucht',
                    type = "error",
                    time = 5000
                }, s)
            end

            if not claimed then
                CachedPlayer[xPlayer.identifier].collected_quest = collected_quest

                claimed = true
                if Prices[array].type == 'money' then
                    xPlayer.addMoney(Prices[array].count)

                    Config.HUD.Notify({
                        title = 'Lucky Wheel',
                        text = 'Du Hast ' .. Prices[array].count .. '$ gewonnen',
                        type = "success",
                        time = 5000
                    }, s)
                    Wait(250)
                    claimed = false
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
                    Wait(250)
                    claimed = false
                elseif Prices[array].type == 'item' then
                    xPlayer.addInventoryItem(Prices[array].name, Prices[array].count)
                    updateInventory(xPlayer)

                    Config.HUD.Notify({
                        title = 'Lucky Wheel',
                        text = 'Du Hast ' .. Prices[array].count .. 'x ' ..
                            ESX.GetItemLabel(Prices[array].name) .. ' gewonnen',
                        type = "success",
                        time = 5000
                    }, s)
                    Wait(250)
                    claimed = false
                end
            end
        end);
    end);
end);
