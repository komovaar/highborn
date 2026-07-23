--[[---------------------------------------------------------------------------
/givevip <steamid|name> <days>
Grant temporary VIP to a player. Days may be fractional (0.5 = 12 hours).
Passing 0 revokes it. Superadmin only.

The target may be a SteamID (STEAM_0:0:..., works offline) or the (partial)
nickname of an online player.
---------------------------------------------------------------------------]]

DarkRP.declareChatCommand{
    command = "givevip",
    description = "Grant temporary VIP to a player (steamid or name).",
    delay = 1.5,
    tableArgs = true
}

if CLIENT then return end

-- Resolve the target argument to a SteamID and a display name.
-- Returns steamid, name or nil, errorMessage.
local function resolveTarget(arg)
    arg = tostring(arg or "")

    -- SteamID (STEAM_0:0:123) — works even when the player is offline.
    if arg:match("^STEAM_%d:%d:%d+$") then
        local ply = player.GetBySteamID(arg)
        return arg, IsValid(ply) and ply:Nick() or arg
    end

    -- SteamID64 (17 digits).
    if arg:match("^%d+$") and #arg >= 17 then
        local steamid = util.SteamIDFrom64(arg)
        local ply = player.GetBySteamID(steamid)
        return steamid, IsValid(ply) and ply:Nick() or steamid
    end

    -- Otherwise treat it as the nickname of an online player.
    local ply = DarkRP.findPlayer(arg)
    if not IsValid(ply) then
        return nil, DarkRP.getPhrase("could_not_find", arg)
    end

    return ply:SteamID(), ply:Nick()
end

local function GiveVIP(ply, args)
    if not ply:IsSuperAdmin() then
        DarkRP.notify(ply, 1, 4, "Тільки суперадмін може видавати VIP.")
        return ""
    end

    local full = table.concat(args, " ")

    -- A SteamID may end up split across tokens, so look for it in the whole
    -- argument string first and fall back to a nickname lookup.
    local rawID = full:upper():match("STEAM_%d:%d:%d+")
    local steamid, nameOrErr, days

    if rawID then
        local target = player.GetBySteamID(rawID)
        steamid = rawID
        nameOrErr = IsValid(target) and target:Nick() or rawID
        days = tonumber((full:upper():gsub("STEAM_%d:%d:%d+", "")):match("(%d+%.?%d*)"))
    else
        steamid, nameOrErr = resolveTarget(args[1])
        days = tonumber(args[2])
    end

    if not steamid then
        DarkRP.notify(ply, 1, 4, nameOrErr)
        return ""
    end

    if not days or days < 0 then
        DarkRP.notify(ply, 1, 4, "Вкажіть кількість днів (наприклад: /givevip " .. steamid .. " 7). 0 — забрати VIP.")
        return ""
    end

    local name = nameOrErr

    if days == 0 then
        if not HighbornVIP.Revoke(steamid) then
            DarkRP.notify(ply, 1, 4, name .. " не має тимчасового VIP.")
            return ""
        end

        DarkRP.notify(ply, 0, 4, "Забрано VIP у " .. name .. ".")
        DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") removed VIP from " .. name .. " (" .. steamid .. ")")

        local target = player.GetBySteamID(steamid)
        if IsValid(target) then DarkRP.notify(target, 1, 4, "Ваш VIP знято.") end

        return ""
    end

    HighbornVIP.Grant(steamid, math.Round(days * 86400))

    local left = string.NiceTime(HighbornVIP.GetTimeLeft(steamid))
    DarkRP.notify(ply, 0, 4, "Видано VIP гравцю " .. name .. " (залишилось " .. left .. ").")
    DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") gave " .. days .. " day(s) of VIP to " .. name .. " (" .. steamid .. ")")

    local target = player.GetBySteamID(steamid)
    if IsValid(target) then DarkRP.notify(target, 0, 4, "Вам видано VIP на " .. left .. ".") end

    return ""
end
DarkRP.defineChatCommand("givevip", GiveVIP, 0.2)
