HighbornVIP = HighbornVIP or {}

HighbornVIP.SteamIDs = HighbornVIP.SteamIDs or {}
HighbornVIP.SteamIDs["STEAM_0:0:594545981"] = true
HighbornVIP.SteamIDs["STEAM_0:0:686106078"] = true

function HighbornVIP.IsVIP(ply)
    if not IsValid(ply) then
        return false
    end

    return ply:IsUserGroup("vip")
        or HighbornVIP.SteamIDs[ply:SteamID()] == true
end
