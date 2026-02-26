hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "DerivedRP"
GM.Author = "By Harry, FPtje Falco et al."

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")

GM.DarkRP = BaseClass

hook.Add("PlayerSpawnProp", "BlockProps", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSENT", "BlockSents", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSWEP", "BlockSweps", function(ply)
    if not ply:IsAdmin() then return false end
end)

