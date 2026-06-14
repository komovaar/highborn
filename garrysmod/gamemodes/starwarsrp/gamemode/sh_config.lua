SWRP = SWRP or {}
SWRP.Config = SWRP.Config or {}

SWRP.Config.DefaultJobCategory = "Republic"
SWRP.Config.DefaultModel = "models/ct_trp/pm_ct_trp.mdl"
SWRP.Config.DefaultHands = "models/ct_trp/pm_ct_trp_arms.mdl"
SWRP.Config.DefaultLoadout = {}
SWRP.Config.DefaultCharacterName = "Clone Recruit"
SWRP.Config.StartingMoney = 0

SWRP.Config.Developers = {
    ["STEAM_0:0:496687453"] = true,
    ["76561198953640634"] = true
}

SWRP.Config.Models = {
    CloneTrooper = "models/ct_trp/pm_ct_trp.mdl",
    CloneMedic = "models/ct_medic/pm_ct_medic.mdl",
    CloneHeavy = "models/ct_heavy/pm_ct_heavy.mdl",
    NavalCrewman = "models/naval_crew/pm_naval_crewman.mdl"
}

SWRP.Config.Loadouts = {
    Recruit = {},
    Trooper = {"rw_sw_dc15s"},
    Medic = {"rw_sw_dc15s"},
    Heavy = {"rw_sw_dc15a", "rw_sw_dc17"},
    Naval = {}
}

if prop and prop.config then
    prop.config.set("defaultJobCategory", SWRP.Config.DefaultJobCategory)
end

function SWRP.CanUseDevCommand(ply)
    if not IsValid(ply) then return false end
    if ply:IsAdmin() or ply:IsSuperAdmin() then return true end

    return SWRP.Config.Developers[ply:SteamID()] == true
        or SWRP.Config.Developers[ply:SteamID64()] == true
end
