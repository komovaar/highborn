GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

hook.Add("PostDrawViewModel", "SWRP.ForceArmsModel", function(vm, ply)
    local hands = ply:GetHands()
    if not IsValid(hands) then return end

    if hands:GetModel() ~= "models/ct_trp/pm_ct_trp_arms.mdl" then
        hands:SetModel("models/ct_trp/pm_ct_trp_arms.mdl")
    end
end)

hook.Add("SpawnMenuOpen", "SWRP.RestrictQMenu", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return false end
    if not ply:IsAdmin() then return false end
end)

hook.Add("OnContextMenuOpen", "SWRP.BlockContextMenu", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return false end
    if not ply:IsAdmin() then return false end
end)

hook.Add("ChatText", "SWRP.HideJoinLeave", function(index, name, text, typ)
    if typ == "joinleave" then return true end
end)

hook.Add("HUDDrawTargetID", "SWRP.HideTargetID", function()
    return false
end)
