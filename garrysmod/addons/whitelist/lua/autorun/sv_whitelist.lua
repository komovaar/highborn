if SERVER then

util.AddNetworkString("highborn_whitelist_set")
util.AddNetworkString("highborn_whitelist_get")
stunstick_weapons = {"stunstick", "unarrest_stick", "arrest_stick"}

hook.Add("PlayerLoadout", "highborn_whitelist_autojob", function(ply)
    if ply._WhitelistApplied then return end
    ply._WhitelistApplied = true

    local job = sql.QueryValue(
        "SELECT job FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
    )
    local can_stunstick = sql.QueryValue(
        "SELECT can_stunstick FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
    )

    if job then
        local jobID = tonumber(job)
        if ply:Team() ~= jobID then
            ply:changeTeam(jobID, true, true)
        end
    end
    if can_stunstick then 
        for swep in stunstick_weapons do
            ply:Give(swep)
        end
    end
end)

hook.Add("InitPostEntity", "highborn_whitelist", function()
    sql.Query("CREATE TABLE IF NOT EXISTS highborn_whitelist(steamid TEXT, job INT, can_stunstick INT DEFAULT 0)")
end)b  

net.Receive("highborn_whitelist_set", function(len, ply)
    if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
    local steamid = net.ReadString()

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end
  
    local job = net.ReadInt(17)
    local can_stunstick = net.ReadInt(11)
    
    local query = sql.Query("DELETE FROM highborn_whitelist WHERE steamid = "..sql.SQLStr(steamid))
    if query == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Highborn] Successfully deleted old whitelist for user " .. steamid)
    end

    local res = sql.Query("INSERT INTO highborn_whitelist(steamid, job, can_stunstick) VALUES(" .. sql.SQLStr(steamid) .. ", " ..sql.SQLStr(job).. ", " .. SQLStr(can_stunstick) .. ")")
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Highborn] Successfully inserted new whitelist for user " .. steamid)
    end

    local targetPly = nil
    for _, v in pairs(player.GetAll()) do
        if v:SteamID() == steamid then
            targetPly = v
            targetPly:changeTeam(job, true, true)
            if can_stunstick == 1 then 
                for _, swep in ipairs(stunstick_weapons) do
                    targetPly:Give(swep)
                end
            end
            break
        end
    end

    local spawn = net.ReadBool()
    if spawn then 
        targetPly:Spawn()
    end
    hook.Run("HighbornWhitelistUpdate", ply, targetPly, steamid, job)
end)

net.Receive("highborn_whitelist_get", function(len, ply)
    if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
    local steamid = net.ReadString()

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end

    local can_stunstick = sql.QueryValue(
        "SELECT can_stunstick FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
    )

    net.Start("highborn_whitelist_get")
    net.WriteString(steamid)
    net.WriteBool(tobool(can_stunstick))
    
    net.Send(ply)
end)

print("[Highborn] Whitelist server loaded")

end