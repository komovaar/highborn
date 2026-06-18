prop = prop or {}
prop.config = prop.config or {}

prop.config.defaultJobCategory = "Republic"
prop.config.defaultModel = "models/ct_trp/pm_ct_trp.mdl"
prop.config.defaultHands = "models/ct_trp/pm_ct_trp_arms.mdl"
prop.config.defaultLoadout = {}
prop.config.defaultCharacterName = "Clone Recruit"
prop.config.defaultCallsign = "Recruit"
prop.config.maxCharacters = 1
prop.config.startingMoney = 0
prop.config.salaryInterval = 300
prop.config.jailDefaultDuration = 300
prop.config.jailPosition = nil
prop.config.jailPositions = {}

prop.config.models = {
    CloneTrooper = "models/ct_trp/pm_ct_trp.mdl",
    CloneMedic = "models/ct_medic/pm_ct_medic.mdl",
    CloneHeavy = "models/ct_heavy/pm_ct_heavy.mdl",
    NavalCrewman = "models/naval_crew/pm_naval_crewman.mdl"
}

prop.config.loadouts = {
    Recruit = {},
    Trooper = {"rw_sw_dc15s"},
    Medic = {"rw_sw_dc15s"},
    Heavy = {"rw_sw_dc15a", "rw_sw_dc17"},
    Naval = {}
}

prop.config.salaries = {
    Recruit = 0,
    Trooper = 100,
    Medic = 125,
    Heavy = 140,
    Naval = 115
}

if prop and prop.config then
    prop.config.set("defaultJobCategory", prop.config.defaultJobCategory)
end
