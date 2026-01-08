if SERVER then

util.AddNetworkString("highborn_whitelist_set")
util.AddNetworkString("highborn_whitelist_get")
stunstick_weapons = {"stunstick", "unarrest_stick", "arrest_stick"}




hook.Add("PlayerLoadout", "highborn_whitelist_autojob", function(ply)
    if ply._WhitelistApplied then return end
    ply._WhitelistApplied = true
    
    local row = sql.QueryRow(
        "SELECT job, can_stunstick, rank FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
    )

    if not row then 
        local res = sql.Query("INSERT INTO highborn_whitelist(steamid, job, rank, can_stunstick) VALUES(" .. sql.SQLStr(ply:SteamID()) .. ", " ..sql.SQLStr("1").. ", " .. SQLStr("TRP") .. ", " .. SQLStr("0") .. ")")
        if res == false then
            ErrorNoHaltWithStack(sql.LastError())
        else
            print("[Highborn] Successfully inserted new whitelist for user " .. ply:SteamID())
            row = res
        end
    end

    local jobID = tonumber(row.job)
    if jobID and ply:Team() ~= jobID then
        ply:changeTeam(jobID, true, true)
    end

    local can_stunstick = tonumber(row.can_stunstick) == 1
    if can_stunstick then
        for _, swep in ipairs(stunstick_weapons) do
            ply:Give(swep)
        end
    end

    local rank = row.rank or ""
end)

hook.Add("InitPostEntity", "highborn_whitelist", function()
    sql.Query("CREATE TABLE IF NOT EXISTS highborn_whitelist(steamid TEXT, job INT, rank TEXT CHECK(LENGTH(rank) <= 3), can_stunstick INT DEFAULT 0)")
end)

net.Receive("highborn_whitelist_set", function(len, ply)
    if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
    local steamid = net.ReadString()

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end
  
    local job = net.ReadInt(17)
    local rank = net.ReadString()
    local can_stunstick = net.ReadInt(11)
    
    local query = sql.Query("DELETE FROM highborn_whitelist WHERE steamid = "..sql.SQLStr(steamid))
    if query == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Highborn] Successfully deleted old whitelist for user " .. steamid)
    end

    local res = sql.Query("INSERT INTO highborn_whitelist(steamid, job, rank, can_stunstick) VALUES(" .. sql.SQLStr(steamid) .. ", " ..sql.SQLStr(job).. ", " .. SQLStr(rank) .. ", " .. SQLStr(can_stunstick) .. ")")
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
    print("server get")

    if not (steamid:find("^STEAM_%d:%d:%d+$")) then
        DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
        return
    end

    local row = sql.QueryRow(
        "SELECT job, rank, can_stunstick FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
    )

    if not row then return end

    local job = tonumber(row.job)
    local rank = row.rank
    local can_stunstick = tobool(tonumber(row.can_stunstick))

    net.Start("highborn_whitelist_get")
        net.WriteString(steamid)
        net.WriteInt(job, 17)
        net.WriteString(rank)
        net.WriteBool(can_stunstick)
    net.Send(ply)
end)

print("[Highborn] Whitelist server loaded")

end