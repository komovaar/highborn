AddCSLuaFile("swrp_f4menu/cl_menu.lua")
AddCSLuaFile("swrp_f4menu/cl_profile.lua")
AddCSLuaFile("swrp_f4menu/cl_roster.lua")
AddCSLuaFile("swrp_f4menu/cl_characters.lua")
AddCSLuaFile("swrp_f4menu/cl_calladmin.lua")
AddCSLuaFile("swrp_f4menu/cl_donate.lua")
AddCSLuaFile("swrp_f4menu/cl_quests.lua")

util.AddNetworkString("swrp_f4menu.RequestRoster")
util.AddNetworkString("swrp_f4menu.RosterData")
util.AddNetworkString("swrp_f4menu.RequestCharacters")
util.AddNetworkString("swrp_f4menu.CharacterList")
util.AddNetworkString("swrp_f4menu.SwitchCharacter")
util.AddNetworkString("swrp_f4menu.CallAdmin")

net.Receive("swrp_f4menu.RequestRoster", function(_, ply)
    local players = {}
    for _, p in ipairs(player.GetAll()) do
        local char = p.propCharacter
        local job  = char and prop.team.getByKey(char.data.team_key) or prop.team.get(p:Team())
        local col  = job and job.color or Color(220, 220, 220)
        table.insert(players, {
            nick     = p:Nick(),
            steamid  = p:SteamID(),
            name     = char and char.data.name     or "Unknown",
            callsign = char and char.data.callsign or "",
            job      = job  and job.name           or "Unknown",
            cr = col.r, cg = col.g, cb = col.b,
            level    = char and (tonumber(char.data.level) or 1) or 1,
        })
    end

    net.Start("swrp_f4menu.RosterData")
        net.WriteUInt(#players, 8)
        for _, p in ipairs(players) do
            net.WriteString(p.nick)
            net.WriteString(p.steamid)
            net.WriteString(p.name)
            net.WriteString(p.callsign)
            net.WriteString(p.job)
            net.WriteUInt(math.Clamp(p.cr, 0, 255), 8)
            net.WriteUInt(math.Clamp(p.cg, 0, 255), 8)
            net.WriteUInt(math.Clamp(p.cb, 0, 255), 8)
            net.WriteUInt(math.Clamp(p.level, 1, 255), 8)
        end
    net.Send(ply)
end)

net.Receive("swrp_f4menu.RequestCharacters", function(_, ply)
    local chars    = prop.characters.list(ply)
    local activeID = prop.data.get(ply, "active_character_id", "")

    net.Start("swrp_f4menu.CharacterList")
        net.WriteString(activeID)
        net.WriteUInt(math.min(#chars, 10), 8)
        for i = 1, math.min(#chars, 10) do
            local char = chars[i]
            local job  = prop.team.getByKey(char.data.team_key) or prop.team.getDefault()
            local mdl  = job and (type(job.model) == "string" and job.model or prop.config.defaultModel) or prop.config.defaultModel
            net.WriteString(char.id)
            net.WriteString(char.data.name     or "Unknown")
            net.WriteString(char.data.callsign or "")
            net.WriteString(job and job.name or "Unknown")
            net.WriteString(mdl)
        end
    net.Send(ply)
end)

net.Receive("swrp_f4menu.SwitchCharacter", function(_, ply)
    local id = net.ReadString()
    prop.characters.setActive(ply, id)
end)

net.Receive("swrp_f4menu.CallAdmin", function(_, ply)
    local reason = string.sub(net.ReadString(), 1, 256)
    if reason == "" then return end

    for _, admin in ipairs(player.GetAll()) do
        if admin:IsAdmin() then
            prop.chat.notify(admin, string.format("[Admin] %s (%s): %s", ply:Nick(), ply:SteamID(), reason))
        end
    end

    prop.log(string.format("[AdminCall] %s (%s): %s", ply:Nick(), ply:SteamID(), reason))
end)
