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
    ply:SetNWString("HighbornRank", row.rank or "")

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
    local query = sql.Query("CREATE TABLE IF NOT EXISTS highborn_whitelist(steamid TEXT, job INT, rank TEXT CHECK(LENGTH(rank) <= 12), can_stunstick INT DEFAULT 0, can_ground_light INT DEFAULT 0, can_ground_heavy INT DEFAULT 0, can_air_light INT DEFAULT 0, can_air_heavy INT DEFAULT 0)")
    if query == false then
            ErrorNoHaltWithStack(sql.LastError())
        else
            print("[Highborn] Successfully create whitelist table for user ")
        end
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
    local canGL = net.ReadBool() and 1 or 0
    local canGH = net.ReadBool() and 1 or 0
    local canAL = net.ReadBool() and 1 or 0
    local canAH = net.ReadBool() and 1 or 0
    local spawn = net.ReadBool()
    local query = sql.Query("DELETE FROM highborn_whitelist WHERE steamid = "..sql.SQLStr(steamid))

    if query == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Highborn] Successfully deleted old whitelist for user " .. steamid)
    end

    local res = sql.Query(
        "INSERT INTO highborn_whitelist(steamid, job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy) VALUES(" .. sql.SQLStr(steamid) .. ", " ..sql.SQLStr(job).. ", " .. SQLStr(rank) .. ", " .. SQLStr(can_stunstick) .. ", " .. SQLStr(canGL) .. ", " .. SQLStr(canGH) .. ", " .. SQLStr(canAL) .. ", " .. SQLStr(canAH) .. ")"
    )
        if res == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Highborn] Successfully inserted new whitelist for user " .. steamid)
    end

    local targetPly = nil
    for _, v in pairs(player.GetAll()) do
        if v:SteamID() == steamid then
            targetPly = v
            targetPly:SetNWString("HighbornRank", rank)
            targetPly:SetNWBool("HighbornCanGL", canGL == 1)
            targetPly:SetNWBool("HighbornCanGH", canGH == 1)
            targetPly:SetNWBool("HighbornCanAL", canAL == 1)
            targetPly:SetNWBool("HighbornCanAH", canAH == 1)
            
            targetPly:changeTeam(job, true, true)

            if can_stunstick == 1 then 
                for _, swep in ipairs(stunstick_weapons) do
                    targetPly:Give(swep)
                end
            end
            break
        end
    end

    print(spawn)
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
        "SELECT job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
    )
    print(row)
    if not row then return end

    local job = tonumber(row.job)
    local rank = row.rank
    local can_stunstick = tobool(tonumber(row.can_stunstick))
    local canGL = tobool(tonumber(row.can_ground_light))
    local canGH = tobool(tonumber(row.can_ground_heavy))
    local canAL = tobool(tonumber(row.can_air_light))
    local canAH = tobool(tonumber(row.can_air_heavy))

    net.Start("highborn_whitelist_get")
        net.WriteString(steamid)
        net.WriteInt(job, 17)
        net.WriteString(rank)
        net.WriteBool(can_stunstick)
        net.WriteBool(canGL)
        net.WriteBool(canGH)
        net.WriteBool(canAL)
        net.WriteBool(canAH)
    net.Send(ply)
end)

print("[Highborn] Whitelist server loaded")

end

hook.Add("CanPlayerEnterVehicle", "highborn_whitelist_vehicles", function (ply, veh)
    if not IsValid(veh) then return end

    local class = veh:GetClass()
    local isAir = veh:GetMoveType() == MOVETYPE_FLY or class:find("air") or class:find("heli") 
    local isHeavy = veh:GetMaxHealth() > 1000 or class:find("tank") or class:find("apc")

    if isAir then
        if isHeavy and not ply:GetNWBool("HighbornCanAH", false) then
            DarkRP.notify(ply, 1, 4, "You are not allowed to use heavy air vehicles.")
            return false
        elseif not isHeavy and not ply:GetNWBool("HighbornCanAL", false) then
            DarkRP.notify(ply, 1, 4, "You are not allowed to use light air vehicles.")
            return false
        end
    else
        if isHeavy and not ply:GetNWBool("HighbornCanGH", false) then
            DarkRP.notify(ply, 1, 4, "You are not allowed to use heavy ground vehicles.")
            return false
        elseif not isHeavy and not ply:GetNWBool("HighbornCanGL", false) then
            DarkRP.notify(ply, 1, 4, "You are not allowed to use light ground vehicles.")
            return false
        end
    end
end)