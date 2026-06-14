SWRP = SWRP or {}
SWRP.Teams = SWRP.Teams or {}

prop.team.list = {}
prop.team.defaultID = nil

local cloneRecruitID, reason = prop.team.register("Clone Recruit", {
    description = "Default Republic trooper role.",
    category = SWRP.Config.DefaultJobCategory,
    color = Color(220, 220, 220),
    model = SWRP.Config.DefaultModel,
    weapons = SWRP.Config.DefaultLoadout,
    default = true
})

assert(cloneRecruitID, "Failed to register Clone Recruit team: " .. tostring(reason))

SWRP.Teams.CloneRecruit = cloneRecruitID
