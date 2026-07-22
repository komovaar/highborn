--[[---------------------------------------------------------------------------
/givevip <name> <days>
Grant temporary VIP to a player. Days may be fractional (0.5 = 12 hours).
Passing 0 revokes it. Superadmin only.
---------------------------------------------------------------------------]]

DarkRP.declareChatCommand{
    command = "givevip",
    description = "Grant temporary VIP to a player.",
    delay = 1.5,
    tableArgs = true
}

if CLIENT then return end

local function GiveVIP(ply, args)
    if not ply:IsSuperAdmin() then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("unable", "givevip", ""))
        return ""
    end

    local target = DarkRP.findPlayer(args[1])
    local days = tonumber(args[2])

    if not target then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(args[1])))
        return ""
    end

    if not days or days < 0 then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ">=0"))
        return ""
    end

    local steamid = target:SteamID()

    if days == 0 then
        if not HighbornVIP.Revoke(steamid) then
            DarkRP.notify(ply, 1, 4, target:Nick() .. " has no temporary VIP.")
            return ""
        end

        DarkRP.notify(ply, 0, 4, "Removed VIP from " .. target:Nick() .. ".")
        DarkRP.notify(target, 1, 4, "Your VIP has been removed.")
        DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") removed VIP from " .. target:Nick() .. " (" .. steamid .. ")")

        return ""
    end

    HighbornVIP.Grant(steamid, math.Round(days * 86400))

    local left = string.NiceTime(HighbornVIP.GetTimeLeft(steamid))
    DarkRP.notify(ply, 0, 4, "Gave VIP to " .. target:Nick() .. " (" .. left .. " left).")
    DarkRP.notify(target, 0, 4, "You have been given VIP for " .. left .. ".")
    DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") gave " .. days .. " day(s) of VIP to " .. target:Nick() .. " (" .. steamid .. ")")

    return ""
end
DarkRP.defineChatCommand("givevip", GiveVIP, 0.2)
