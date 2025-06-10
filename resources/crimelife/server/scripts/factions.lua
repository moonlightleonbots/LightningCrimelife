local function getgradeLabel(job, grade)
    local jobs = ESX.GetJobs()
    if not next(jobs) then
        repeat
            jobs = ESX.GetJobs()
            Wait(100)
        until next(jobs)
    end
    if jobs[job] and jobs[job].grades[grade] then
        return jobs[job].grades[tostring(grade)].label
    end
end

CreateThread(function()
    Wait(2500)
    for i, v in next, json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")) or {} do
        Config.factions.fractions[v.name] = v
    end
end);

local function CheckMemberCount(faction)
    local online = ESX.GetExtendedPlayers('job', faction)
    local identifiers = {}
    for _, member in next, (online) do
        identifiers[#identifiers + 1] = member.identifier
    end

    local offlineMembers = #(MySQL.query.await('SELECT * FROM users WHERE job=? AND identifier NOT IN (?)', { faction, '\'' .. table.concat(identifiers, '\', \'') .. '\'' }) or {})
    return offlineMembers
end

RegisterNetEvent("setNewTint", function(tint, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.hasWeapon(weapon) then
        xPlayer.setWeaponTint(weapon, tint)
    end
end);

ESX.RegisterServerCallback('factionmenu:get', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = xPlayer.getJob().name

    TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. society, function(store)
        local labels = {}
        for i = 1, store.count('dressing'), 1 do
            local entry = store.get('dressing', i)
            table.insert(labels, entry.label)
        end

        local factionMembers = {}
        local onlineMembers = ESX.GetExtendedPlayers("job", society)
        for _, xPlayer in next, (onlineMembers) do
            factionMembers[xPlayer.identifier] = {
                name = GetPlayerName(xPlayer.source),
                id = xPlayer.source,
                identifier = xPlayer.identifier,
                status = "online",
                grade_label = xPlayer.job.grade_label,
            }
        end

        local online = ESX.GetExtendedPlayers("job", society)
        local identifiers = {}
        for _, member in next, (online) do
            identifiers[#identifiers + 1] = member.identifier
        end

        MySQL.Async.fetchAll('SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC', {
            ['@job'] = society
        }, function(result)
            for _, row in next, (result) do
                local identifier = row.identifier

                if not factionMembers[identifier] then
                    factionMembers[identifier] = {
                        identifier = identifier,
                        name = row.steamname,
                        status = "offline",
                        grade_label = getgradeLabel(society, tostring(row.job_grade))
                    }
                end
            end
            cb({
                members = factionMembers,
                dressing = labels,
                count = #online ..
                    "/" ..
                    #(MySQL.query.await('SELECT * FROM users WHERE job=? AND identifier NOT IN (?)', { society, '\'' .. table.concat(identifiers, '\', \'') .. '\'' }) or {})
            })
        end);
    end);
end);

ESX.RegisterServerCallback('factionmenu:getClothing', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = xPlayer.getJob().name

    TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. society, function(store)
        local labels = {}
        for i = 1, store.count('dressing'), 1 do
            local entry = store.get('dressing', i)
            table.insert(labels, entry.label)
        end

        cb(labels)
    end);
end);

RegisterNetEvent('faction:uprank', function(identifier)
    local spieler = ESX.GetPlayerFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local newGrade = 0
    if spieler then
        if spieler.source == xPlayer.source then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du kannst dich selber nicht Befördern',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if spieler.job.grade == 2 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du kannst ihn nicht auf Leader Befördern',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if xPlayer.job.grade == 2 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du hast nicht die Berechtigung',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if xPlayer.job.grade_name == "boss" then
            newGrade = tonumber(spieler.job.grade) + 1
            spieler.setJob(xPlayer.job.name, newGrade)
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du hast ' .. spieler.name .. ' Befördert',
                time = 5000,
                type = 'success'
            }, xPlayer.source)
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du hast von ' .. GetPlayerName(xPlayer.source) .. ' eine Beförderung bekommen',
                time = 5000,
                type = 'success'
            }, spieler.source)
        end
    else
        local job_grade = MySQL.scalar.await('SELECT job_grade FROM users WHERE identifier = ?', {
            identifier
        })

        if not job_grade then
        end

        if xPlayer.job.grade and job_grade == 3 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'ihr habt beide den gleichen rang',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        elseif xPlayer.job.grade_name == "boss" then
            if job_grade == 2 then
                Config.HUD.Notify({
                    title = 'FRAKTION ',
                    text = 'Du kannst Spieler maximal auf Rang 4 Befördern',
                    time = 5000,
                    type = 'error'
                }, xPlayer.source)
            else
                newGrade = job_grade + 1
                MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
                    xPlayer.job.name, newGrade, identifier
                })
            end
        end
    end
end);

RegisterNetEvent('faction:derank', function(identifier)
    local spieler = ESX.GetPlayerFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local newGrade = 0
    if spieler then
        if spieler.source == xPlayer.source then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du kannst dich selber nicht Deranken',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if spieler.job.grade == 1 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Der Spieler ist Bereits auf rang 1!',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if xPlayer.job.grade == 3 then
            newGrade = tonumber(spieler.job.grade) - 1
            spieler.setJob(xPlayer.job.name, newGrade)
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Derank: ' .. spieler.name .. '.',
                time = 5000,
                type = 'success'
            }, xPlayer.source)
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du hast von ' .. GetPlayerName(xPlayer.source) .. ' eine Degradierung bekommen!',
                time = 5000,
                type = 'info'
            }, spieler.source)
        end
    else
        local job_grade = MySQL.scalar.await('SELECT job_grade FROM users WHERE identifier = ? LIMIT 1', {
            identifier
        })

        newGrade = job_grade - 1

        if xPlayer.job.grade and job_grade == 3 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'ihr habt beide den gleichen rang',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        elseif xPlayer.job.grade == 3 then
            if job_grade == 1 then
                Config.HUD.Notify({
                    title = 'FRAKTION ',
                    text = 'Der Spieler ist bereits Rang 1',
                    time = 5000,
                    type = 'error'
                }, xPlayer.source)
            else
                MySQL.update.await(
                    "UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?",
                    { xPlayer.job.name, newGrade, identifier }
                )
            end
        end
    end
end);

RegisterNetEvent('faction:kick', function(identifier)
    local spieler = ESX.GetPlayerFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if spieler then
        if spieler.source == xPlayer.source then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du kannst dich nicht selber aus der Fraktion entlassen',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        end

        if xPlayer.job.grade == 2 and spieler.job.grade_name == "boss" then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text =
                'Du kannst kein Leader von deiner Fraktion Kicken sollte es ein Leader sein der NICHT in deine Fraktion gehört komm bitte in den Support der Discordlink wurde in deiner Zwischenablage Kopiert!',
                time = 10000,
                type = 'error'
            }, xPlayer.source)
        end

        if xPlayer.job.grade == 3 then
            spieler.setJob('unemployed', 0)
            MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
                'unemployed', 0, identifier
            })
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Du wurdest aus der Fraktion entlassen!',
                time = 5000,
                type = 'error'
            }, spieler.source)
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'Frakkick: ' .. spieler.name .. '.',
                time = 5000,
                type = 'success'
            }, xPlayer.source)
        end
    else
        local job_grade = MySQL.scalar.await('SELECT job_grade FROM users WHERE identifier = ? LIMIT 1', {
            identifier
        })

        if xPlayer.job.grade and job_grade == 3 then
            Config.HUD.Notify({
                title = 'FRAKTION ',
                text = 'ihr habt beide den gleichen rang',
                time = 5000,
                type = 'error'
            }, xPlayer.source)
        elseif xPlayer.job.grade == 3 then
            MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
                'unemployed', 0, identifier
            })
        end
    end
end);

RegisterNetEvent("chat:send", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = xPlayer.getJob().name

    for k, v in next, ESX.Players do
        if v.job.name == society then
            TriggerClientEvent('esx:showAdvancedNotification', v.source, 'Frakchat',
                xPlayer.name .. '[' .. xPlayer.getJob().label .. ']', message, "CHAR_ARTHUR", 1)
            if v.source == xPlayer.source then
                TriggerClientEvent("chat:receiveMessage:you", xPlayer.source, xPlayer.name, message)
            else
                TriggerClientEvent("chat:receiveMessage", v.source, xPlayer.name, message)
            end
        end
    end
end);

bwp = {}

RegisterCommand("invite", function(source, args)
    local player = tonumber(args[1])
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
    local count = CheckMemberCount(xPlayer.getJob().name)

    if xPlayer.source ~= xTarget.source then
        if xTarget.getJob().name ~= xPlayer.getJob().name then
            if count < 20 and player and xPlayer.getJob().grade_name == "boss" then
                TriggerClientEvent("faction:invite", player, xPlayer.source,
                    xPlayer.name .. " [" .. xPlayer.source .. "]",
                    xPlayer.getJob().name)
            end
        else
            Config.HUD.Notify({
                title = "Fraktion",
                text = "Dieser Spieler ist Bereits in deiner Fraktion.",
                type = "error",
                time = 3500
            }, xPlayer.source)
        end
    else
        Config.HUD.Notify({
            title = "Fraktion",
            text = "Du kannst dich nicht selber Inviten.",
            type = "error",
            time = 3500
        }, xPlayer.source)
    end
end, false)

RegisterCommand("bwp", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if next(bwp) ~= nil then
        Config.HUD.Notify({
            title = "Fraktion",
            text = "Es gibt bereits eine laufende Bewerbungsphase.",
            type = "error",
            time = 3500
        }, xPlayer.source)
        return
    end
    if not bwp[xPlayer.getJob().name] then
        bwp[xPlayer.getJob().name] = true
        TriggerClientEvent("bwp:open", -1, xPlayer.getJob().name)

        Config.HUD.Notify({
            title = "Fraktion",
            text = "Bewerbungsphase wurde Aktiviert.",
            type = "success",
            time = 3500
        }, xPlayer.source)

        Config.HUD.announce({
            title = "Fraktion",
            text = "Die Fraktion " ..
                xPlayer.getJob().label ..
                " hat eine Bewerbungsphase eröffnet Ihr Könnt euch Über das F6 Menü hin Teleportieren - KEINE ANGRIFFE ERLAUBT (GANGWAR).",
            time = 20000
        }, -1)

        ESX.SetTimeout(5 * 60 * 1000, function()
            Config.HUD.announce({
                title = "Fraktion",
                text = "Die Bewerbungsphase von " ..
                    xPlayer.getJob().label ..
                    " ist nun zuende ihr dürft die Fraktion nun angreifen.",
                time = 20000
            }, -1)

            bwp[xPlayer.getJob().name] = nil
            TriggerClientEvent("bwp:close", -1)
        end);
    end
end, false)

RegisterCommand("bwpclose", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if bwp[xPlayer.getJob().name] then
        bwp[xPlayer.getJob().name] = nil
        TriggerClientEvent("bwp:close", -1)
        Config.HUD.Notify({
            title = "Fraktion",
            text = "Bewerbungsphase wurde Beendet.",
            type = "success",
            time = 3500
        }, xPlayer.source)
    end
end, false)

-----------------
---- GANGWAR ----
-----------------

Webhook = {
    URL = {
        updates =
        "https://discord.com/api/webhooks/1303470612093599765/vSeaixUbI6AhNHMAz7kWr07moFvEwoOgFCJcXvwfvbDGftkptF3_yUznpMIBjiUfXcrn"
    },
};

local SQL =
[[CREATE TABLE IF NOT EXISTS `gangwar` (
    `name` varchar(255) DEFAULT NULL,
    `owner` varchar(255) DEFAULT NULL,
    `last_attack` int(255) DEFAULT 0
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;]];

Owners = {};
Attacks = {};
Players = {};
AdminsInGW = {};
Blocked = {};
Jobs = ESX.Jobs;

exports('GetPlayers', function()
    return Players;
end);

exports('GetPlayer', function(source)
    return Players[source];
end);

exports('IsInGW', function(source)
    return Players[source] and Players[source].isIn;
end);

MySQL.query(SQL, {}, function(result)
    for _, zone in next, (Config.pvp.gangwar.Zones) do
        local inserted = MySQL.single.await(
            'SELECT owner, last_attack FROM gangwar WHERE name=? LIMIT 1',
            { zone.name }
        );

        if not inserted then
            MySQL.insert.await('INSERT INTO gangwar (name) VALUES (?)', { zone.name });
        end

        Owners[zone.name] = inserted and inserted.owner or nil;
        Attacks[zone.name] = false;
    end

    TriggerClientEvent('gangwar:UpdateOwners', -1, Owners);
    TriggerClientEvent('gangwar:UpdateAllAttacks', -1, Attacks);
end);

ESX.RegisterServerCallback('gangwar:GetData', function(_, cb)
    cb({
        owners = Owners,
        attacks = Attacks
    });
end);

function GetJobLabel(job)
    if not job then
      return 'Unbesetzt';
    end
  
    local jobs = ESX.GetJobs();
  
    if not next(jobs) then
      repeat
        jobs = ESX.GetJobs();
        Wait(100);
      until next(jobs);
    end
  
    return jobs[job].label;
  end

RegisterNetEvent('gangwar:StartAttack', function(zoneIndex, zone)
    local source = source;

    local xPlayer = ESX.GetPlayerFromId(source);
    local job = xPlayer.getJob();

    if Blocked[zone.name] then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Dieses Gebiet kann derzeit nicht angegriffen werden.',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if not Owners[zone.name] then
        MySQL.update('UPDATE gangwar SET owner=? WHERE name=?', { job.name, zone.name }, function()
            Owners[zone.name] = job.name;
            TriggerClientEvent('gangwar:UpdateOwners', -1, Owners);
        end);
        return;
    end

    if Attacks[zone.name] then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Dieses Gebiet wird bereits angegriffen.',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if Config.pvp.gangwar.Blacklist.Jobs[job.name] or job.grade < Config.pvp.gangwar.Permissions.start then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Du bist nicht befugt ein Gangwar zu starten.',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if Owners[zone.name] == job.name then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Du kannst nicht dein eigenes Gebiet angreifen.',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    local cooldown = MySQL.scalar.await(
        'SELECT last_attack FROM gangwar WHERE name=? LIMIT 1',
        { zone.name }
    );

    if cooldown and cooldown + Config.pvp.gangwar.Time.afterAttack * 60 > os.time() then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Du musst noch ' ..
                math.floor((cooldown + Config.pvp.gangwar.Time.afterAttack * 60 - os.time()) / 60) ..
                ' Minuten warten',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if Config.pvp.gangwar.IsJobInAttack(job.name) then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Deine Fraktion ist bereits in einem Gangwar',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if Config.pvp.gangwar.IsJobInAttack(Owners[zone.name]) then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Die Fraktion die du angreifen willst ist bereits in einem Gangwar',
            type = 'error',
            time = 5000
        }, source)
        return;
    end

    if Config.pvp.gangwar.Permissions.players > 0 then
        local defenderCount = ESX.GetExtendedPlayers("job", Owners[zone.name]);
        local attackerCount = ESX.GetExtendedPlayers("job", job.name);

        if #attackerCount < Config.pvp.gangwar.Permissions.players or #defenderCount < Config.pvp.gangwar.Permissions.players then
            Config.HUD.Notify({
                title = "Gangwar",
                text = "Es müssen mindestens " ..
                    Config.pvp.gangwar.Permissions.players .. " Spieler pro Fraktion online sein",
                type = "error",
                time = 5000
            }, source)
            return;
        end
    end

    Attacks[zone.name] = {
        zone = zone,
        zoneIndex = zoneIndex,
        dim = zoneIndex + 100 + math.random(1, 9999),
        time = Config.pvp.gangwar.Time.gangwar * 60,
        attacker = {
            name = job.name,
            label = GetJobLabel(job.name),
            color = Config.factions.fractions[job.name] and
                Config.pvp.gangwar.RGBtoString(Config.factions.fractions[job.name].color) or 'rgb(255, 255, 255)',
            points = Config.pvp.gangwar.Points.start,
        },
        defender = {
            name = Owners[zone.name] or "NOT FOUND",
            label = GetJobLabel(Owners[zone.name]),
            color = Config.factions.fractions[Owners[zone.name]] and
                Config.pvp.gangwar.RGBtoString(Config.factions.fractions[Owners[zone.name]].color) or
                'rgb(255, 255, 255)',
            points = 0,
        }
    };

    local xPlayers = ESX.GetExtendedPlayers("job", Attacks[zone.name].defender.name);
    for _, FPlayer in next, (xPlayers) do
        if FPlayer.job.name == job.name or FPlayer.job.name == Owners[zone.name] then
            Config.pvp.gangwar.Announce(FPlayer.source,
                'Dein Gangwar Gebiet ' ..
                zone.name .. ' wird von ' .. GetJobLabel(job.name) .. ' angegriffen schreibe /joingw um es zu Betreten');
        end
    end

    local xPlayers = ESX.GetExtendedPlayers("job", Attacks[zone.name].attacker.name);
    for _, FPlayer1 in next, (xPlayers) do
        if FPlayer1.job.name == Attacks[zone.name].attacker.name then
            Config.pvp.gangwar.Announce(FPlayer1.source,
                "Deine Fraktion hat ein Gangwar gegen " ..
                Attacks[zone.name].defender.name .. "  | schreibe /joingw um es zu Betreten");
        end
    end

    sendgwwebhook("Gangwar angegriffen",
        "Die Fraktion " ..
        Attacks[zone.name].defender.label ..
        " wird von der Fraktion " .. Attacks[zone.name].attacker.name .. " angegriffen",
        0xffff00, Config.Discord.designs.banner.gangwar.start)

    TriggerClientEvent('gangwar:UpdateAttacks', -1, zone.name, Attacks[zone.name]);
    JoinGangwar(source);
    StartTimer(zone.name);
end);

RegisterNetEvent('gangwar:JoinAttack', function()
    JoinGangwar(source);
end);

RegisterNetEvent('esx:onPlayerDeath', function(data)
    local xPlayer = ESX.GetPlayerFromId(source);

    if not Players[xPlayer.source] or not Players[xPlayer.source].isIn then
        return;
    end

    local victimJob = xPlayer.getJob();
    local victimSide = Players[xPlayer.source].side;
    local zone = Players[xPlayer.source].zone;
    Players[xPlayer.source].streak = 0;

    if data.killerServerId then
        local killer = data.killerServerId;
        local killerName = GetPlayerName(killer);
        local xKiller = ESX.GetPlayerFromId(killer);
        local killerJob = xKiller.getJob();
        local killerSide = Players[xKiller.source].side;
        local prop = killerJob.name == victimJob.name and 'teamKill' or 'kill'

        Attacks[zone][killerSide].points += Config.pvp.gangwar.Points[prop];

        if prop == "teamKill" then
            Config.HUD.Notify({
                title = "TEAMKILL",
                text = "Du hast " .. GetPlayerName(xPlayer.source) .. " getötet und verlierst " ..
                    Config.pvp.gangwar.Points.teamKill .. " Gangwar Punkt",
                type = "error",
                time = 5000
            }, killer)
        end

        TriggerClientEvent('gangwar:UpdateScore', -1, zone, killerSide, Attacks[zone][killerSide].points);
        if prop == 'kill' then
            Players[xKiller.source].kills += 1;
            Players[xKiller.source].streak += 1;
            Players[xPlayer.source].deaths += 1;
            TriggerClientEvent("gangwar:updateStats", killer, Players[xKiller.source].kills,
                Players[xKiller.source].deaths)
            TriggerClientEvent("gangwar:updateStats", xPlayer.source, Players[xPlayer.source].kills,
                Players[xPlayer.source].deaths)
            if Config.pvp.gangwar.Points.win > 0 and Attacks[zone][killerSide].points >= Config.pvp.gangwar.Points.win then
                EndAttack(zone);
            end
        end
    end

    TriggerClientEvent('gangwar:ShowFirework', -1, zone, GetEntityCoords(GetPlayerPed(source)));

    if Attacks[zone].zone[victimSide].spawn then
        local spawn = Attacks[zone].zone[victimSide].spawn;
        if Players[xPlayer.source] and Players[xPlayer.source].isIn then
            ---@diagnostic disable-next-line: missing-parameter
            TriggerClientEvent("ReviveGW", source, spawn)
        end
    end
end);

AddEventHandler('playerDropped', function()
    local source = source;
    if not source then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source);

    if not source then
        return;
    end

    if not xPlayer then
        return;
    end

    if Players[xPlayer.source] and Players[xPlayer.source].isIn then
        Players[xPlayer.source].isIn = false;
    end
end);

RegisterCommand('quitgw', function(source)
    local xPlayer = ESX.GetPlayerFromId(source);

    if Players[xPlayer.source] and Players[xPlayer.source].isIn then
        local attack = Attacks[Players[xPlayer.source].zone]
        local zone = attack.zone;
        local dist = #(GetEntityCoords(GetPlayerPed(source)) - zone.center);

        if dist > zone.radius.x then
            Players[xPlayer.source].isIn = false;
            SetPlayerRoutingBucket(source,
                Config.factions.fractions[attack[Players[xPlayer.source].side].name] and
                Config.factions.fractions[attack[Players[xPlayer.source].side].name].bucket or 0);
            ---@diagnostic disable-next-line: missing-parameter

            local factionSpawn = Config.factions.fractions[xPlayer.job.name].positions.respawn
            SetEntityCoords(GetPlayerPed(source), factionSpawn.x, factionSpawn.y, factionSpawn.z, false, false, false,
                false);

            TriggerClientEvent('gangwar:LeftGangwar', source, true);
        else
            Config.HUD.Notify({
                title = 'Gangwar',
                text = 'Das kannst du nur außerhalb der Zone!',
                type = 'error',
                time = 5000
            }, source)
        end
    elseif AdminsInGW[source] then
        AdminsInGW[source] = nil;

        SetPlayerRoutingBucket(source, 0);
        TriggerClientEvent('gangwar:LeftGangwar', source, true);
    end
end, false);

RegisterCommand('stopgw', function(source, args)
    if not args[1] then
        return;
    end

    local xPlayer = ESX.GetPlayerFromId(source);

    if source == 0 or Config.pvp.gangwar.Permissions.stop[xPlayer.getGroup()] then
        if not Attacks[args[1]] then
            return;
        end

        Attacks[args[1]].admin = true;

        EndAttack(args[1]);
    end
end, false);

RegisterCommand('gwstats', function(source)
    local data = Players[ESX.GetPlayerFromId(source).source];
    if data.isIn then
        Config.HUD.Notify({
            title = 'Gangwar',
            text = 'Kills: ' .. data.kills .. ' | Deaths: ' .. data.deaths,
            type = 'info',
            time = 5000
        }, source)
    end
end, false);

function sendgwwebhook(title, message, color, img)
    local embed = {
        color = color or 16711680,
        title = title,
        description = message,
        footer = {
            text = os.date("%x %X %p"),
            icon_url = Config.Discord.designs.logo
        },
        image = {
            url = img
        }
    }
    PerformHttpRequest(Webhook.URL.updates, nil, 'POST', json.encode({
        username = 'LIGHTNING',
        embeds = { embed },
        avatar_url = Config.Discord.designs.logo
    }), { ['Content-Type'] = 'application/json' })
end

function JoinGangwar(source)
    local xPlayer = ESX.GetPlayerFromId(source);
    local job = xPlayer.getJob();

    local zone = Config.pvp.gangwar.IsJobInAttack(job.name);

    if zone then
        local attack = Attacks[zone];
        local side = Config.pvp.gangwar.GetSide(attack.attacker.name, job.name);

        if not Players[xPlayer.source] then
            Players[xPlayer.source] = {
                source = xPlayer.source,
                name = GetPlayerName(source),
                isIn = false,
                kills = 0,
                streak = 0,
                deaths = 0,
                side = side,
                zone = zone,
            };
        end

        TriggerClientEvent("gangwar:updateStats", xPlayer.source, 0, 0)

        Players[xPlayer.source].isIn = true;
        Players[xPlayer.source].streak = 0;
        SetPlayerRoutingBucket(source, attack.dim);

        local spawn = attack.zone[side].spawn;
        ---@diagnostic disable-next-line: missing-parameter
        SetEntityCoords(GetPlayerPed(source), spawn.x, spawn.y, spawn.z);

        TriggerClientEvent('gangwar:JoinedGangwar', source);
    end
end

local function getTopPlayers(players)
    table.sort(players, function(a, b)
        return a.kills > b.kills
    end);

    local topPlayers = {}
    for i = 1, math.min(5, #players) do
        local player = players[i]
        table.insert(topPlayers,
            string.format("**[#%d]** %s » `%d Kills / %d Tode`", i, player.name, player.kills, player.deaths))
    end
    return topPlayers
end

function EndAttack(zoneName)
    local attack = Attacks[zoneName]
    local winner = 'attacker'
    local scoreBoard = {
        attacker = {
            name = attack.attacker.name,
            label = attack.attacker.label,
            color = attack.attacker.color,
            points = attack.attacker.points,
            players = {}
        },
        defender = {
            name = attack.defender.name,
            label = attack.defender.label,
            color = attack.defender.color,
            points = attack.defender.points,
            players = {}
        }
    }
    local annText = ''

    for source, data in next, (Players) do
        if data.zone == zoneName then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                local source = xPlayer.source

                if data.isIn then
                    SetPlayerRoutingBucket(source, 0)
                    TriggerClientEvent('gangwar:LeftGangwar', source)
                end

                if data.side == winner then
                    xPlayer.addAccountMoney("coins", 50)
                  end

                table.insert(scoreBoard[data.side].players, {
                    source = data.source,
                    name = data.name,
                    kills = data.kills,
                    deaths = data.deaths,
                })
            end

            Players[source] = nil
        end
    end

    if attack.admin then
        annText = 'Der Angriff auf die Zone ' .. zoneName .. ' wurde administrativ beendet!'
    else
        winner = attack.attacker.points > attack.defender.points and 'attacker' or 'defender'
        local pointsText = string.format(
            "**Punktestand:** \n" .. attack.attacker.label .. ": `%d` \n" .. attack.defender.label .. ": `%d`",
            attack.attacker.points, attack.defender.points)

        local top5Attacker = getTopPlayers(scoreBoard.attacker.players)
        local top5Defender = getTopPlayers(scoreBoard.defender.players)
        annText = string.format('Die Fraktion %s hat das Gangwar gegen die Fraktion %s %s', attack[winner].label, attack[winner == 'attacker' and 'defender' or 'attacker'].label, 'gewonnen')
        local newtext = "# **Gangwar vorbei** \n" .. annText .. "\n\n" .. pointsText .. "\n\n"
        local webhooktext = newtext ..
            "**TOP 5 SPIELER [" .. attack.attacker.label .. "]**\n" .. table.concat(top5Attacker, "\n") .. "\n\n" ..
            "**TOP 5 SPIELER [" .. attack.defender.label .. "]**\n" .. table.concat(top5Defender, "\n")

        MySQL.update.await('UPDATE jobs SET gwpunkte=gwpunkte+? WHERE name=?',
            { attack.attacker.points, attack.attacker.name });
        MySQL.update.await('UPDATE jobs SET gwpunkte=gwpunkte+? WHERE name=?',
            { attack.defender.points, attack.defender.name });

        if attack.attacker.points > attack.defender.points then
            MySQL.update('UPDATE gangwar SET owner=?, last_attack=UNIX_TIMESTAMP() WHERE name=?',
                { attack.attacker.name, zoneName }, function() end);

            MySQL.update('UPDATE gangwar SET owner=? WHERE name=?',
                { attack.attacker.name, zoneName }, function()
                    Owners[zoneName] = attack.attacker.name
                    TriggerClientEvent('gangwar:UpdateOwners', -1, Owners)
                    sendgwwebhook("", webhooktext, 0x59ff00, Config.Discord.designs.banner.gangwar.win)
                end);
        else
            MySQL.update.await('UPDATE gangwar SET last_attack=UNIX_TIMESTAMP() WHERE name=?', { zoneName });
            annText = string.format('Die Fraktion %s konnte das Gangwar gebiet %s von %s %s', attack.attacker.label,
                zoneName,
                attack.defender.label, 'nicht einnehmen')
            sendgwwebhook("", webhooktext, 0xff0000, Config.Discord.designs.banner.gangwar.lose)
        end
    end

    Config.pvp.gangwar.Announce(-1, annText)
    TriggerClientEvent('gangwar:ShowScoreboard', -1, zoneName, scoreBoard)
    Attacks[zoneName] = false
    TriggerClientEvent('gangwar:UpdateAttacks', -1, zoneName, Attacks[zoneName])
end

function StartTimer(zoneName)
    while Attacks[zoneName] and Attacks[zoneName].time > 0 do
        Wait(1000);

        if not Attacks[zoneName] then
            break;
        end

        Attacks[zoneName].time -= 1;

        TriggerClientEvent('gangwar:UpdateTime', -1, zoneName, Attacks[zoneName].time);

        if Attacks[zoneName].time == 0 then
            if Config.pvp.gangwar.Time.overtime > 0 and Attacks[zoneName].attacker.points == Attacks[zoneName].defender.points then
                Attacks[zoneName].time += Config.pvp.gangwar.Time.overtime;

                TriggerClientEvent('gangwar:UpdateTime', -1, zoneName, Attacks[zoneName].time);
            else
                EndAttack(zoneName);
                break;
            end
        end
    end
end

RegisterNetEvent("faction:invite:accept", function(bossid, faction)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xBoss = ESX.GetPlayerFromId(bossid)

    xPlayer.setJob(faction, 1)
    Config.HUD.Notify({
        title = "Fraktion",
        text = "Der Spieler " .. xPlayer.name .. " [" .. xPlayer.source .. "] hat die Einladung angenommen.",
        type = "success",
        time = 3500
    }, xBoss.source)

    Config.HUD.Notify({
        title = "Fraktion",
        text = "Du hast die einladung von " ..
            xBoss.name .. " [" .. xBoss.source .. "] zu " .. faction .. " angenommen.",
        type = "success",
        time = 3500
    }, xPlayer.source)
end);

RegisterNetEvent("faction:invite:deny", function(bossid, faction)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xBoss = ESX.GetPlayerFromId(bossid)

    Config.HUD.Notify({
        title = "Fraktion",
        text = "Der Spieler " .. xPlayer.name .. " [" .. xPlayer.source .. "] hat die Einladung abgelehnt.",
        type = "error",
        time = 3500
    }, xBoss.source)

    Config.HUD.Notify({
        title = "Fraktion",
        text = "Du hast die einladung von " ..
            xBoss.name .. " [" .. xBoss.source .. "] zu " .. faction .. " abgelehnt.",
        type = "error",
        time = 3500
    }, xPlayer.source)
end);

function updateFactions(xPlayer, faction)
    local factionsFile = LoadResourceFile(GetCurrentResourceName(), "json/factions.json")
    local data = json.decode(factionsFile) or {}

    data = data or {}
    table.insert(data, faction)

    SaveResourceFile(GetCurrentResourceName(), "json/factions.json", json.encode(data), -1)
    Wait(250)
    ESX.RefreshJobs()
    TriggerEvent('esx_datastore:refreshDatastore')
    TriggerClientEvent("factions:update", -1,
        json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")))
    TriggerClientEvent("faction:reloadMenu", xPlayer.source)

    for i, v in next, json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")) or {} do
        Config.factions.fractions[v.name] = v
    end
end

RegisterNetEvent("faction:create", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data2 = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data2)

    if not role then return end

    faction = {}
    local jobGrades = {
        { grade = 1, name = "member", label = "Member" },
        { grade = 2, name = "boss",   label = "Co. Boss" },
        { grade = 3, name = "boss",   label = "Boss" },
    }

    MySQL.query('SELECT * FROM datastore WHERE name=?', {
        "society_" .. data.name
    }, function(r)
        if #r < 1 then
            MySQL.insert(
                'INSERT INTO datastore (name, label, shared) VALUES (?, ?, ?)',
                {
                    "society_" .. data.name,
                    data.label,
                    1,
                })
        end
    end);

    MySQL.query('SELECT * FROM datastore_data WHERE name=?', {
        "society_" .. data.name
    }, function(r)
        if #r < 1 then
            MySQL.insert(
                'INSERT INTO datastore_data (name, owner, data) VALUES (?, ?, ?)',
                {
                    "society_" .. data.name,
                    nil,
                    "{}",
                })
        end
    end);

    MySQL.query('SELECT * FROM jobs WHERE name=?', {
        data.name
    }, function(r)
        if #r < 1 then
            MySQL.insert(
                'INSERT INTO jobs (name, label) VALUES (?, ?)',
                {
                    data.name,
                    data.label,
                })
        end
    end);

    for _, gradeData in next, (jobGrades) do
        MySQL.query('SELECT * FROM job_grades WHERE job_name=?', { data.name }, function(r)
            if #r < 3 then
                MySQL.insert(
                    'INSERT INTO job_grades (job_name, grade, name, label) VALUES (?, ?, ?, ?)',
                    {
                        data.name,
                        gradeData.grade,
                        gradeData.name,
                        gradeData.label,
                    })
            end
        end);
        Wait(50)
    end

    local faction = {
        name = data.name,
        label = data.label,
        color = data.color,
        blipcolor = tonumber(data.blipcolor),
        positions = {
            respawn = data.respawn,
            garage_parkout = data.spawnpoint
        }
    }

    Config.Server.Debug("Die Fraktion ^5" .. data.label .. "^0 wurde Erstellt von ^5" .. xPlayer.name .. "^0")
    updateFactions(xPlayer, faction)
end);

RegisterNetEvent("faction:delete", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data2 = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data2)

    if role then
        local factionsFile = LoadResourceFile(GetCurrentResourceName(), "json/factions.json")
        local data = json.decode(factionsFile) or {}
        data = data or {}

        for i, v in next, data do
            if v.name == name then
                table.remove(data, i)
                SaveResourceFile(GetCurrentResourceName(), "json/factions.json", json.encode(data), -1)
                Wait(500)
                TriggerClientEvent("factions:update", -1,
                    json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")))
                MySQL.Async.execute("DELETE FROM jobs WHERE name = @name", { ['@name'] = name })
                MySQL.Async.execute("DELETE FROM job_grades WHERE job_name = @job_name", { ['@job_name'] = name })
                MySQL.Async.execute("DELETE FROM datastore WHERE name = @name", { ['@name'] = "society_" .. name })
                MySQL.Async.execute("DELETE FROM datastore_data WHERE name = @name", { ['@name'] = "society_" .. name })
                Config.Server.Debug("Die Fraktion ^5" .. name .. "^0 wurde gelöscht")
                TriggerClientEvent("faction:reloadMenu", xPlayer.source)
                break
            end
        end
    end
end);

RegisterNetEvent("faction:update:server", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data2 = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data2)

    if role then
        TriggerClientEvent("factions:update", -1,
            json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")))
        TriggerClientEvent("faction:reloadMenu", xPlayer.source)

        for i, v in next, json.decode(LoadResourceFile(GetCurrentResourceName(), "json/factions.json")) or {} do
            Config.factions.fractions[v.name] = v
        end
    end
end);

RegisterNetEvent("faction:kickall", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data2 = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data2)

    if role then
        MySQL.Async.execute('UPDATE datastore_data SET data = "{}" WHERE name = @name',
            { ['@name'] = "society_" .. name },
            function(rowsChanged) end);
        for k, xPlayer in next, (ESX.Players) do
            if xPlayer.job.name == name then
                xPlayer.setJob("unemployed", 0)
            end
        end
        MySQL.Async.fetchAll('SELECT * FROM users', {}, function(result)
            for k2, v2 in next, (result) do
                if v2.job == name then
                    MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier',
                        { ['@grade'] = '0', ['@identifier'] = v2.identifier, ['@job'] = 'unemployed' },
                        function(rowsChanged) end);
                end
            end
        end);
    end
end);

RegisterNetEvent("faction:kick", function(name, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data2 = CachedPlayer[xPlayer.identifier].dc
    local role = HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data2)

    if role then
        if target then
            local xTarget = ESX.GetPlayerFromId(target)

            if xTarget then
                if xTarget.job.name == name then
                    xTarget.setJob("unemployed", 0)
                end
                MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier',
                    { ['@grade'] = '0', ['@identifier'] = xTarget.identifier, ['@job'] = 'unemployed' },
                    function(rowsChanged) end);
            else
                MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier',
                    { ['@grade'] = '0', ['@identifier'] = xTarget.identifier, ['@job'] = 'unemployed' },
                    function(rowsChanged) end);
            end
        end
    end
end);

RegisterCommand("bringfrak", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier] and CachedPlayer[xPlayer.identifier].dc
    local role = data and HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data)
    local coords = GetEntityCoords(GetPlayerPed(xPlayer.source))

    if not role then
        Config.HUD.Notify({
            title = "Error",
            text = "You do not have permission to use this command.",
            type = "error",
            time = 2500
        }, xPlayer.source)
        return
    end

    if not args[1] then
        Config.HUD.Notify({
            title = "Error",
            text = "Please specify a faction.",
            type = "error",
            time = 2500
        }, xPlayer.source)
        return
    end

    local targetFaction = tostring(args[1])

    for _, v in next, (ESX.GetPlayers()) do
        local targetPlayer = ESX.GetPlayerFromId(v)

        if targetPlayer and targetPlayer.job.name == targetFaction then
            local factionPed = GetPlayerPed(targetPlayer.source)
            SetEntityCoords(factionPed, coords.x, coords.y, coords.z, false, false, false, true)
        end
    end
end, false)

RegisterNetEvent("gw:clear", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = CachedPlayer[xPlayer.identifier] and CachedPlayer[xPlayer.identifier].dc
    local role = data and HasDiscordRole(xPlayer.source, Config.Discord.roles["FrakVerwaltung"], data)

    if xPlayer and role then
        MySQL.Async.execute("UPDATE gangwar SET OWNER = NULL, last_attack = 0", {}, function(affectedRows)
            if affectedRows > 0 then
                for _, zone in next, (Config.pvp.gangwar.Zones) do
                    local inserted = MySQL.single.await(
                        'SELECT owner, last_attack FROM gangwar WHERE name=? LIMIT 1',
                        { zone.name }
                    );

                    if not inserted then
                        MySQL.insert.await('INSERT INTO gangwar (name) VALUES (?)', { zone.name });
                    end

                    Owners[zone.name] = inserted and inserted.owner or nil;
                    Attacks[zone.name] = false;
                end

                TriggerClientEvent('gangwar:UpdateOwners', -1, Owners);
                TriggerClientEvent('gangwar:UpdateAllAttacks', -1, Attacks);
            end
        end);
    end
end);

RegisterCommand('frakleave', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer or xPlayer.getJob().name == 'unemployed' or xPlayer.getJob().grade == 3 then
        return
    end

    xPlayer.setJob('unemployed', 0)

    Config.HUD.Notify({
        title = "Fraktion",
        text = "Du hast deine aktuelle Fraktion verlassen.",
        type = "success",
        time = 3500
    }, xPlayer.source)
end, false)

ESX.RegisterServerCallback('ali_fraksystem:getKleidung', function(source, cb, frak)
    TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. frak, function(store)
        local labels = {}
        for i = 1, store.count('dressing'), 1 do
            local entry = store.get('dressing', i)
            table.insert(labels, entry.label)
        end
        cb(labels)
    end);
end);

RegisterServerEvent('ali_fraksystem:saveKleidung', function(frak, label, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().grade_name == "boss" then
        TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. frak, function(store)
            local dressing = store.get('dressing')
            if dressing == nil then
                dressing = {}
            end
            table.insert(dressing, { label = label, skin = skin })
            store.set('dressing', dressing)
        end);
    end
end);

RegisterServerEvent('ali_fraksystem:deleteOutfit', function(label, frak)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().grade_name == "boss" then
        TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. frak, function(store)
            local dressing = store.get('dressing')
            if dressing == nil then
                dressing = {}
            end
            label = label
            table.remove(dressing, label)
            store.set('dressing', dressing)
        end);
    end
end);

ESX.RegisterServerCallback('ali_fraksystem:getPlayerOutfit', function(source, cb, num, frak)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getSharedDataStore', "society_" .. frak, function(store)
        local outfit = store.get('dressing', num)
        cb(outfit.skin)
    end);
end);

ESX.RegisterServerCallback('factionList', function(src, cb)
    local factionsFile = LoadResourceFile(GetCurrentResourceName(), "json/factions.json")
    local factionsData = json.decode(factionsFile) or {}
    local factions = {}

    for _, faction in pairs(factionsData) do
        local factionName = faction.name
        local factionLabel = faction.label

        local isInAttack = Config.pvp.gangwar.IsJobInAttack(factionName)
        
        local canAttack = not isInAttack and 
            #ESX.GetExtendedPlayers("job", factionName) >= Config.pvp.gangwar.Permissions.players

        table.insert(factions, {
            label = factionLabel,
            online = #ESX.GetExtendedPlayers("job", factionName),
            offline = MySQL.scalar.await('SELECT COUNT(*) FROM users WHERE job = ?', { factionName }),
            canattack = canAttack,
            bwp = bwp and bwp[factionName] or false,
        })
    end

    cb(factions)
end)

