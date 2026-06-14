local republic = SWRP.Config.DefaultJobCategory
local models = SWRP.Config.Models
local loadouts = SWRP.Config.Loadouts

SWRP.RegisterJob("CloneRecruit", "Clone Recruit", {
    description = "Default Republic trooper role.",
    category = republic,
    color = Color(220, 220, 220),
    model = SWRP.Config.DefaultModel,
    weapons = SWRP.Config.DefaultLoadout,
    default = true
})

SWRP.RegisterJob("CloneTrooper", "Clone Trooper", {
    description = "Standard Republic infantry role.",
    category = republic,
    color = Color(220, 220, 220),
    model = models.CloneTrooper,
    weapons = loadouts.Trooper
})

SWRP.RegisterJob("CloneMedic", "Clone Medic", {
    description = "Republic medical support role.",
    category = republic,
    color = Color(160, 220, 255),
    model = models.CloneMedic,
    weapons = loadouts.Medic
})

SWRP.RegisterJob("CloneHeavy", "Clone Heavy", {
    description = "Republic heavy infantry role.",
    category = republic,
    color = Color(255, 210, 120),
    model = models.CloneHeavy,
    weapons = loadouts.Heavy
})

SWRP.RegisterJob("NavalCrewman", "Naval Crewman", {
    description = "Republic fleet crew role.",
    category = republic,
    color = Color(120, 180, 255),
    model = models.NavalCrewman,
    weapons = loadouts.Naval
})
