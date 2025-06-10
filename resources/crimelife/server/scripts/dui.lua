ESX.RegisterServerCallback('scoreboard:Load', function(src, cb)
    local stats = MySQL.Sync.fetchAll("SELECT steamname, kills, deaths, trophys FROM users ORDER BY kills DESC LIMIT 10", {})
    cb(stats)
end);