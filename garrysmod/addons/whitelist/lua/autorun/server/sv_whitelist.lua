whitelist = whitelist or {}

whitelist.stunstick_weapons = {
    "stunstick", 
    "unarrest_stick", 
    "arrest_stick", 
    "weapon_cuff_elastic"
}

whitelist.permissions = {
    heavy_air = "whitelist.can_ah",
    light_air = "whitelist.can_al",
    heavy_ground = "whitelist.can_gh",
    light_ground = "whitelist.can_gl"
}

whitelist.vehicles = {
    heavy_air = {
        lvs_repulsorlift_dropship = true,
        lvs_repulsorlift_gunship = true
    },
    light_air = {
        lvs_starfighter_vwing = true,
        lvs_starfighter_arc170 = true,
        lvs_starfighter_v19 = true,
    },
    heavy_ground = {
        lvs_fakehover_iftx = true,
        lvs_walker_atte = true,
    },
    light_ground = {
        lvs_fakehover_barc = true,
        lvs_fakehover_barc_medical = true,
    }
}

util.AddNetworkString("whitelist.set")
util.AddNetworkString("whitelist.get")

function whitelist.create_table()
    local query = sql.Query([[
        CREATE TABLE IF NOT EXISTS hb_whitelist(
            steamid TEXT PRIMARY KEY,
            job INTEGER,
            rank TEXT,
            can_stunstick INTEGER DEFAULT 0,
            can_ground_light INTEGER DEFAULT 0,
            can_ground_heavy INTEGER DEFAULT 0,
            can_air_light INTEGER DEFAULT 0,
            can_air_heavy INTEGER DEFAULT 0
        )
    ]])

    if query == false then
        ErrorNoHaltWithStack(sql.LastError())
    else
        print("[Whitelist] Table ready")
    end
end
hook.Add("Initialize", "whitelist.create_table", whitelist.create_table)

function whitelist.give_stunstick(ply)
    for _, wep in ipairs(whitelist.stunstick_weapons) do
        ply:Give(wep)
    end
end

hook.Add("PlayerLoadout", "whitelist.loadout", function(ply)
    timer.Simple(0, function()
        if not IsValid(ply) then return end

        local steamid = ply:SteamID()

        local row = sql.QueryRow(
            "SELECT * FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
        )

        if not row then
            sql.Query("INSERT INTO hb_whitelist(steamid, job, rank) VALUES(" ..
                sql.SQLStr(steamid) .. ", 0, " .. sql.SQLStr("CDT") .. ")"
            )

            row = sql.QueryRow(
                "SELECT * FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
            )
        end

        if not row then return end

        ply:SetNWString("whitelist.rank", row.rank or "")
        ply:SetNWBool("whitelist.can_gl", tonumber(row.can_ground_light) == 1)
        ply:SetNWBool("whitelist.can_gh", tonumber(row.can_ground_heavy) == 1)
        ply:SetNWBool("whitelist.can_al", tonumber(row.can_air_light) == 1)
        ply:SetNWBool("whitelist.can_ah", tonumber(row.can_air_heavy) == 1)

        local teamID = tonumber(row.job)
        if teamID and teamID ~= 0 and ply:Team() ~= teamID then
            ply:changeTeam(teamID, true, true)
        end

        if tonumber(row.can_stunstick) == 1 then
            whitelist.give_stunstick(ply)
        end
    end)
end)

net.Receive("whitelist.get", function(_, ply)
    if not whitelist.ranks[ply:GetUserGroup()] then return end

    local steamid = net.ReadString()

    if not steamid:match("^STEAM_%d:%d:%d+$") then return end

    local row = sql.QueryRow(
        "SELECT * FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
    )

    if not row then return end

    net.Start("whitelist.get")
        net.WriteString(steamid)
        net.WriteInt(tonumber(row.job) or 0, 17)
        net.WriteString(row.rank or "")
        net.WriteBool(tonumber(row.can_stunstick) == 1)
        net.WriteBool(tonumber(row.can_ground_light) == 1)
        net.WriteBool(tonumber(row.can_ground_heavy) == 1)
        net.WriteBool(tonumber(row.can_air_light) == 1)
        net.WriteBool(tonumber(row.can_air_heavy) == 1)
    net.Send(ply)
end)

net.Receive("whitelist.set", function(_, ply)
    if not whitelist.ranks[ply:GetUserGroup()] then return end

    local steamid = net.ReadString()
    if not steamid:match("^STEAM_%d:%d:%d+$") then return end

    local job = net.ReadInt(17)
    local rank = net.ReadString()

    local can_stunstick = net.ReadBool() and 1 or 0
    local can_gl = net.ReadBool() and 1 or 0
    local can_gh = net.ReadBool() and 1 or 0
    local can_al = net.ReadBool() and 1 or 0
    local can_ah = net.ReadBool() and 1 or 0
    local spawn = net.ReadBool()
    local temp = net.ReadBool()

    for _, v in ipairs(player.GetAll()) do
        if v:SteamID() == steamid then

            v:SetNWString("whitelist.rank", rank)
            v:SetNWBool("whitelist.can_gl", can_gl == 1)
            v:SetNWBool("whitelist.can_gh", can_gh == 1)
            v:SetNWBool("whitelist.can_al", can_al == 1)
            v:SetNWBool("whitelist.can_ah", can_ah == 1)

            if job ~= 0 then
                v:changeTeam(job, true, true)
            end

            if can_stunstick == 1 then
                whitelist.give_stunstick(v)
            end

            if spawn then
                v:Spawn()
            end

            break
        end
    end

    if not temp then
        local query = "INSERT OR REPLACE INTO hb_whitelist(steamid, job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy) VALUES (" ..
            sql.SQLStr(steamid) .. ", " ..
            job .. ", " ..
            sql.SQLStr(rank) .. ", " ..
            can_stunstick .. ", " ..
            can_gl .. ", " ..
            can_gh .. ", " ..
            can_al .. ", " ..
            can_ah .. ")"

        local result = sql.Query(query)

        if result == false then
            print("[Whitelist] SQL ERROR:", sql.LastError())
        else
            print("[Whitelist] Saved:", steamid)
        end
    end
end)

function whitelist.can_drive(ply, vehicle)
    if not IsValid(vehicle) then return end

    local class = vehicle:GetClass()

    for category, nwvar in pairs(whitelist.permissions) do
        local vehicles = whitelist.vehicles[category]

        if vehicles and vehicles[class] then
            if not ply:GetNWBool(nwvar, false) then
                return false
            end
        end
    end

    return true
end

hook.Add("LVS.CanPlayerDrive", "whitelist.can_drive", whitelist.can_drive)