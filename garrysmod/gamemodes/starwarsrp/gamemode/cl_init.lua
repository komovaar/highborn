hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "DarkRP"
GM.Author = "By Harry, FPtje Falco et al."

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")
GM.DarkRP = BaseClass

hook.Add("PostDrawViewModel", "ForceArmsModel", function(vm, ply, weapon)
    local hands = ply:GetHands()
    if not IsValid(hands) then return end

    if hands:GetModel() ~= "models/ct_trp/pm_ct_trp_arms.mdl" then
        hands:SetModel("models/ct_trp/pm_ct_trp_arms.mdl")
    end
end)

hook.Add("SpawnMenuOpen", "RestrictQMenu", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return false end
    if not ply:IsAdmin() then
        return false
    end
end)

hook.Add("OnContextMenuOpen", "BlockContextMenu", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return false end
    if not ply:IsAdmin() then
        return false
    end
end)

hook.Add( "ChatText", "hide_joinleave", function( index, name, text, typ )
	if ( typ == "joinleave" ) then return true end
end )