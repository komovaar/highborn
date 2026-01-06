util.AddNetworkString("highborn_whitelist_set")
util.AddNetworkString("highborn_whitelist_get")

hook.Add("playerCanChangeTeam", "highborn_whitelist", function(ply, team, force)
    if force then return true, "Job change was forced!" end
    local jobname = team.GetName(team)
    return false, HIGHBORN_WHITELIST_ERRMESSAGE
end)

hook.Add("PlayerInitialSpawn", "highborn_whitelist", function(ply, transition)
    local job = sql.QueryValue("SELECT job FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID()))
    if job then
        ply:changeTeam(tonumber(job), true, true)
    end
end)

hook.Add("InitPostEntity", "highborn_whitelist", function()
    sql.Query("CREATE TABLE IF NOT EXISTS highborn_whitelist( steamid TEXT, job INT )")
end)

net.Receive("highborn_whitelist_set", function(len, ply)
    -- if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
    local steamid = net.ReadString()

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end
  
    local job = net.ReadInt(17)
    local res = sql.Query("INSERT INTO highborn_whitelist(steamid, job) VALUES(" .. sql.SQLStr(steamid) .. ", " ..sql.SQLStr(job).. ")")
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("Successfully inserted new whitelist for user " .. steamid)
    end

    local targetPly = nil
    for k, v in pairs(player.GetAll()) do
        if v:SteamID() == steamid then
            targetPly = v
            print(job)
            targetPly:changeTeam(job, true, true)
            break
        end
    end
    hook.Run("HighbornWhitelistUpdate", ply, targetPly, steamid, job)
end)

net.Receive("highborn_whitelist_get", function(len, ply)
    -- if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
    local steamid = net.ReadString()
    print("Enblaed")

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end

    net.Start("highborn_whitelist_get")
    net.WriteString(steamid)
    net.Send(ply)
end)

print("[Highborn] Whitelist server loaded")
