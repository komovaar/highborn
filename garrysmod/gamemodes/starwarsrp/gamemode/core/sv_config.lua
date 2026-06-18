prop.config.developers = {
    ["STEAM_0:0:496687453"] = true,
    ["76561198953640634"] = true
}

function prop.canUseDevCommand(ply)
    if not IsValid(ply) then return false end
    if ply:IsAdmin() or ply:IsSuperAdmin() then return true end

    return prop.config.developers[ply:SteamID()] == true
        or prop.config.developers[ply:SteamID64()] == true
end
