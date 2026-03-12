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
    command="trp",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- antena
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
    end
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
    command="212pvt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- facial hair
    end
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
    command="212sgt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- facial hair
    end
    
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
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 1) -- anetna
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 0) -- binos
        ply:SetBodygroup(8, 0) -- flashlight
        ply:SetBodygroup(9, 0) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
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
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- anetna
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 0) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 2) -- binos
        ply:SetBodygroup(8, 0) -- flashlight
        ply:SetBodygroup(9, 0) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
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
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 3) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- facial hair
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
    command="212pil",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- flashlight
        ply:SetBodygroup(3, 0) -- backpack
        ply:SetBodygroup(4, 0) -- hair
        ply:SetBodygroup(5, 0) -- fhair
    end
})

TEAM_212PARA = DarkRP.createJob("212 | Клон Параджай", {
    color = Color(255, 128, 0),
    model = {"models/md/212th/2nd/barlex.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    command="212para",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- sunvisor
        ply:SetBodygroup(3, 1) -- backpack
        ply:SetBodygroup(4, 0) -- barc
        ply:SetBodygroup(5, 1) -- holster right
        ply:SetBodygroup(6, 1) -- holster left
        ply:SetBodygroup(7, 0) -- pauldron
        ply:SetBodygroup(8, 1) -- kama
        ply:SetBodygroup(9, 0) -- shoulder antena
    end
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
    command="fleet_adm",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- head
        ply:SetBodygroup(2, 6) -- hair
        ply:SetBodygroup(3, 2) -- fhair
        ply:SetBodygroup(4, 0) -- gasmask
        ply:SetBodygroup(5, 0) -- medals
        ply:SetBodygroup(6, 0) -- rank
        ply:SetBodygroup(7, 0) -- pistol left
        ply:SetBodygroup(8, 0) -- pistol right
        ply:SetSkin(1)
    end
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
    command="fleet_navi",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- head
        ply:SetBodygroup(2, 0) -- hair
        ply:SetBodygroup(3, 0) -- fhair
        ply:SetBodygroup(4, 1) -- medals
        ply:SetBodygroup(5, 1) -- rank
        ply:SetBodygroup(6, 0) -- re-breather
        ply:SetBodygroup(7, 0) -- pistol left
        ply:SetBodygroup(8, 0) -- pistol right
    end
})

TEAM_91PVT = DarkRP.createJob("91 | Клон Рядовий", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91pvt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
    end
})

TEAM_91SGT = DarkRP.createJob("91 | Клон Сержант", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_trp/pm_91strecon_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91sgt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
    end
})

TEAM_91LT = DarkRP.createJob("91 | Клон Лейтенант", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_co/pm_91strecon_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91lt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 1) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- holster left
        ply:SetBodygroup(5, 1) -- holstering right
        ply:SetBodygroup(6, 0) -- binos
        ply:SetBodygroup(7, 0) -- flashlight
        ply:SetBodygroup(8, 0) -- backpack
        ply:SetBodygroup(9, 0) -- hair
        ply:SetBodygroup(10, 0) -- fhair
    end
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
    command="91cmd",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- antenna
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- visor
        ply:SetBodygroup(5, 0) -- pauldron
        ply:SetBodygroup(6, 0) -- kama
        ply:SetBodygroup(7, 0) -- holster left
        ply:SetBodygroup(8, 0) -- hoslter right
        ply:SetBodygroup(9, 4) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
    end
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
    command="91med",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 3) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
    end
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
    command="91pil",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- antenna
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- pauldron
        ply:SetBodygroup(5, 0) -- kama
        ply:SetBodygroup(6, 0) -- holster left
        ply:SetBodygroup(7, 2) -- hoslter right     
        ply:SetBodygroup(8, 0) -- backpack
        ply:SetBodygroup(9, 0) -- hair
        ply:SetBodygroup(10, 0) -- fhair
    end
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
    command="91arf",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- backpack
        ply:SetBodygroup(3, 0) -- hair
        ply:SetBodygroup(4, 0) -- fhair
    end
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
