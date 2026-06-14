SWRP = SWRP or {}
SWRP.Config = SWRP.Config or {}

SWRP.Config.DefaultJobCategory = "Republic"
SWRP.Config.DefaultModel = "models/ct_trp/pm_ct_trp.mdl"
SWRP.Config.DefaultHands = "models/ct_trp/pm_ct_trp_arms.mdl"
SWRP.Config.DefaultLoadout = {}

if prop and prop.config then
    prop.config.set("defaultJobCategory", SWRP.Config.DefaultJobCategory)
end
