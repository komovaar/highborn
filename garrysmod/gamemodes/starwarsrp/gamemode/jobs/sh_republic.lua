local republic = "republic"
local models = prop.config.models
local loadouts = prop.config.loadouts
local salaries = prop.config.salaries

prop.registerJob("CloneRecruit", "Clone Recruit", {
    description = "Default Republic trooper role.",
    category = republic,
    color = Color(220, 220, 220),
    model = prop.config.defaultModel,
    weapons = prop.config.defaultLoadout,
    salary = salaries.Recruit,
    default = true
})

prop.registerJob("CloneTrooper", "Clone Trooper", {
    description = "Standard Republic infantry role.",
    category = republic,
    color = Color(220, 220, 220),
    model = models.CloneTrooper,
    weapons = loadouts.Trooper,
    salary = salaries.Trooper
})

prop.registerJob("CloneMedic", "Clone Medic", {
    description = "Republic medical support role.",
    category = republic,
    color = Color(160, 220, 255),
    model = models.CloneMedic,
    weapons = loadouts.Medic,
    salary = salaries.Medic
})

prop.registerJob("CloneHeavy", "Clone Heavy", {
    description = "Republic heavy infantry role.",
    category = republic,
    color = Color(255, 210, 120),
    model = models.CloneHeavy,
    weapons = loadouts.Heavy,
    salary = salaries.Heavy
})

prop.registerJob("NavalCrewman", "Naval Crewman", {
    description = "Republic fleet crew role.",
    category = republic,
    color = Color(120, 180, 255),
    model = models.NavalCrewman,
    weapons = loadouts.Naval,
    salary = salaries.Naval
})
