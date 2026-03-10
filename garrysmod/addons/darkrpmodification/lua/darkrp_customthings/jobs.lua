--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]
TEAM_CADET = DarkRP.createJob("Клон Кадет", {
    color = Color(250, 250, 250),
    model = {"models/cadet_green/pm_training_cadet_domino.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CT",
    command="cdt",
})

TEAM_TRP = DarkRP.createJob("Клон Рекрут", {
    color = Color(250, 250, 250),
    model = {"models/ct_trp/pm_ct_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CT",
    command="trp"
})

TEAM_CO = DarkRP.createJob("Клон Командир", {
    color = Color(250, 250, 250),
    model = {"models/ct_cmd/pm_ct_cmd.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CT",
    command="co",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(2, 2) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
    end
})

TEAM_212PVT = DarkRP.createJob("212 | Клон Рядовий", {
    color = Color(255, 128, 0),
    model = {"models/212th_trp/pm_212th_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212pvt"
})

TEAM_212SGT = DarkRP.createJob("212 | Клон Сержант", {
    color = Color(255, 128, 0),
    model = {"models/212th_nco/pm_212th_nco.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212sgt"
})

TEAM_212LT = DarkRP.createJob("212 | Клон Лейтенант", {
    color = Color(255, 128, 0),
    model = {"models/212th_xo/pm_212th_xo.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212lt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(2, 1) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
    end
})

TEAM_212CMD = DarkRP.createJob("212 | Клон Командир", {
    color = Color(255, 128, 0),
    model = {"models/212th_co/pm_212th_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212cmd",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(2, 0) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 0) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 2) -- binos
    end
})

TEAM_212MED = DarkRP.createJob("212 | Клон Медик", {
    color = Color(255, 128, 0),
    model = {"models/212th_medic/pm_212th_medic.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212med",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(4, 3) -- backpack
    end
})

TEAM_212PIL = DarkRP.createJob("212 | Клон Пілот", {
    color = Color(255, 128, 0),
    model = {"models/212th_pilot/pm_212th_pilot.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212pil"
})

TEAM_FLEET_ADM = DarkRP.createJob("Республіканський Флот | Адмірал", {
    color = Color(0, 76, 153),
    model = {"models/naval_admiral/pm_naval_admiral.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Fleet",
    command="fleet_adm"
})

TEAM_FLEET_CMD = DarkRP.createJob("Республіканський Флот | Клон Командир", {
    color = Color(0, 76, 153),
    model = {"models/ct_arc/pm_ct_arc.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Fleet",
    command="fleet_cmd",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(2, 1) -- belt
        ply:SetBodygroup(3, 4) -- backpack
        ply:SetBodygroup(4, 1) -- kama
        ply:SetBodygroup(5, 1) -- forearms
        ply:SetBodygroup(6, 1) -- pauldron
        ply:SetBodygroup(7, 2) -- antena
    end
})

TEAM_FLEET_NAVI = DarkRP.createJob("Республіканський Флот | Клон Офіцер Навігації", {
    color = Color(0, 76, 153),
    model = {"models/naval_officer/pm_naval_officer.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Fleet",
    command="fleet_navi"
})

TEAM_91PVT = DarkRP.createJob("91 | Клон Рядовий", {
    color = Color(153, 0, 0),
    model = {"models/swiftsquadron/91strecon_swift/pm_91strecon_swift.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91pvt"
})

TEAM_91SGT = DarkRP.createJob("91 | Клон Сержант", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1nco.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91sgt"
})

TEAM_91LT = DarkRP.createJob("91 | Клон Лейтенант", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1ofc.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91lt"
})

TEAM_91CMD = DarkRP.createJob("91 | Клон Командир", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1neyo.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91cmd"
})

TEAM_91MED = DarkRP.createJob("91 | Клон Медик", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_medic/pm_91strecon_medic.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91med"
})

TEAM_91PIL = DarkRP.createJob("91 | Клон Пілот", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1plt.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91pil"
})

TEAM_91ARF = DarkRP.createJob("91 | Клон ARF", {
    color = Color(153, 0, 0),
    model = {"models/lightning/91strecon_arf/pm_91strecon_arf.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91arf"
})



--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CADET
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
-- DarkRP.addHitmanTeam(TEAM_MOB)
