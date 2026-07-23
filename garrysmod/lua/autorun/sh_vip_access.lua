HighbornVIP = HighbornVIP or {}

-- Permanent VIPs, hardcoded.
HighbornVIP.SteamIDs = HighbornVIP.SteamIDs or {}
HighbornVIP.SteamIDs["STEAM_0:0:594545981"] = true
HighbornVIP.SteamIDs["STEAM_0:0:686106078"] = true

-- Temporary VIPs granted in game, steamid -> expiry (os.time).
HighbornVIP.Temp = HighbornVIP.Temp or {}

function HighbornVIP.IsVIP(ply)
    if not IsValid(ply) then
        return false
    end

    return ply:IsUserGroup("vip")
        or HighbornVIP.SteamIDs[ply:SteamID()] == true
        or ply:GetNWBool("hb_vip_temp", false)
end

if CLIENT then return end

local dataFile = "highborn_vip.json"

local function save()
    file.Write(dataFile, util.TableToJSON(HighbornVIP.Temp, true))
end

local function load()
    local contents = file.Read(dataFile, "DATA")

    if not contents then
        -- Create the file on first run so it is visible and editable on disk.
        save()
        return
    end

    HighbornVIP.Temp = util.JSONToTable(contents) or {}
end
load()

-- Seconds left on a temporary VIP, or 0 when there is none.
function HighbornVIP.GetTimeLeft(steamid)
    local expiry = HighbornVIP.Temp[steamid]
    if not expiry then return 0 end

    return math.max(0, expiry - os.time())
end

local function refresh(ply)
    ply:SetNWBool("hb_vip_temp", HighbornVIP.GetTimeLeft(ply:SteamID()) > 0)
end

function HighbornVIP.Grant(steamid, seconds)
    local from = math.max(os.time(), HighbornVIP.Temp[steamid] or 0)
    HighbornVIP.Temp[steamid] = from + seconds
    save()

    local ply = player.GetBySteamID(steamid)
    if IsValid(ply) then refresh(ply) end

    return HighbornVIP.Temp[steamid]
end

function HighbornVIP.Revoke(steamid)
    if not HighbornVIP.Temp[steamid] then return false end

    HighbornVIP.Temp[steamid] = nil
    save()

    local ply = player.GetBySteamID(steamid)
    if IsValid(ply) then refresh(ply) end

    return true
end

hook.Add("PlayerInitialSpawn", "HighbornVIP.Refresh", refresh)

-- Drop expired entries and keep the networked flag of online players in sync.
timer.Create("HighbornVIP.Expire", 60, 0, function()
    local expired = false

    for steamid, expiry in pairs(HighbornVIP.Temp) do
        if expiry <= os.time() then
            HighbornVIP.Temp[steamid] = nil
            expired = true
        end
    end

    if not expired then return end

    save()

    for _, ply in ipairs(player.GetAll()) do
        refresh(ply)
    end
end)

--[[---------------------------------------------------------------------------
Console commands. These work from the server console and from a superadmin's
client console, independently of the DarkRP chat pipeline.

    highborn_givevip <steamid> <days>   -- 0 days revokes
    highborn_viplist
---------------------------------------------------------------------------]]
concommand.Add("highborn_givevip", function(ply, _, args)
    -- ply is NULL when the command comes from the server console.
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    local function reply(msg)
        if IsValid(ply) then ply:PrintMessage(HUD_PRINTCONSOLE, msg) end
        print("[HighbornVIP] " .. msg)
    end

    local steamid = args[1]
    local days = tonumber(args[2])

    if not steamid or not steamid:match("^STEAM_%d:%d:%d+$") then
        reply("Usage: highborn_givevip STEAM_0:0:000000 <days>   (0 days removes VIP)")
        return
    end

    if not days or days < 0 then
        reply("Invalid days: " .. tostring(args[2]))
        return
    end

    if days == 0 then
        reply(HighbornVIP.Revoke(steamid) and ("Removed VIP from " .. steamid) or (steamid .. " has no temporary VIP."))
        return
    end

    HighbornVIP.Grant(steamid, math.Round(days * 86400))
    reply("Gave VIP to " .. steamid .. " (" .. string.NiceTime(HighbornVIP.GetTimeLeft(steamid)) .. " left)")
end)

concommand.Add("highborn_viplist", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    local function reply(msg)
        if IsValid(ply) then ply:PrintMessage(HUD_PRINTCONSOLE, msg) end
        print("[HighbornVIP] " .. msg)
    end

    reply("Permanent VIPs:")
    for steamid in pairs(HighbornVIP.SteamIDs) do
        reply("  " .. steamid)
    end

    reply("Temporary VIPs:")
    if table.IsEmpty(HighbornVIP.Temp) then
        reply("  (none)")
        return
    end

    for steamid in pairs(HighbornVIP.Temp) do
        reply("  " .. steamid .. " - " .. string.NiceTime(HighbornVIP.GetTimeLeft(steamid)) .. " left")
    end
end)
