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
    PlayerLoadout = function(ply)
        ply:SetArmor(5)
        ply:SetMaxArmor(5)
    end
})

TEAM_TRP = DarkRP.createJob("Клон Рекрут", {
    color = Color(250, 250, 250),
    model = {"models/ct_trp/pm_ct_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CT",
    command="trp",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) 
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
        ply:SetArmor(10)
        ply:SetMaxArmor(10)
    end
})

TEAM_CO = DarkRP.createJob("Клон Командир", {
    color = Color(250, 250, 250),
    model = {"models/ct_cmd/pm_ct_cmd.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
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
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end
})

TEAM_212PVT = DarkRP.createJob("212 | Клон Рядовий", {
    color = Color(255, 128, 0),
    model = {"models/212th_trp/pm_212th_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 25,
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
        ply:SetArmor(20)
        ply:SetMaxArmor(20)
    end
})

TEAM_212SGT = DarkRP.createJob("212 | Клон Сержант", {
    color = Color(255, 128, 0),
    model = {"models/212th_nco/pm_212th_nco.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
    
})

TEAM_212LT = DarkRP.createJob("212 | Клон Лейтенант", {
    color = Color(255, 128, 0),
    model = {"models/212th_xo/pm_212th_xo.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 100,
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
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_212CMD = DarkRP.createJob("212 | Клон Командир", {
    color = Color(255, 128, 0),
    model = {"models/212th_co/pm_212th_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
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
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end
})

TEAM_212MED = DarkRP.createJob("212 | Клон Медик", {
    color = Color(255, 128, 0),
    model = {"models/212th_medic/pm_212th_medic.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_212PIL = DarkRP.createJob("212 | Клон Пілот", {
    color = Color(255, 128, 0),
    model = {"models/212th_pilot/pm_212th_pilot.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_212PARA = DarkRP.createJob("212 | Клон Параджай", {
    color = Color(255, 128, 0),
    model = {"models/md/212th/2nd/barlex.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_FLEET_ADM = DarkRP.createJob("Республіканський Флот | Адмірал", {
    color = Color(26, 125, 127),
    model = {"models/naval_admiral/pm_naval_admiral.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
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
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end
})

TEAM_FLEET_CMD = DarkRP.createJob("Республіканський Флот | Клон Командир", {
    color = Color(26, 125, 127),
    model = {"models/ct_arc/pm_ct_arc.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
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
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end
})

TEAM_FLEET_NAVI = DarkRP.createJob("Республіканський Флот | Клон Офіцер Навігації", {
    color = Color(26, 125, 127),
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
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end
})

TEAM_91PVT = DarkRP.createJob("91 | Клон Рядовий", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 25,
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
        ply:SetArmor(20)
        ply:SetMaxArmor(20)
    end
})

TEAM_91SGT = DarkRP.createJob("91 | Клон Сержант", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_trp/pm_91strecon_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_91LT = DarkRP.createJob("91 | Клон Лейтенант", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_co/pm_91strecon_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 100,
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
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_91CMD = DarkRP.createJob("91 | Клон Командир", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1neyo.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
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
        ply:SetBodygroup(9, 5) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end
})

TEAM_91MED = DarkRP.createJob("91 | Клон Медик", {
    color = Color(153, 0, 0),
    model = {"models/91st/91strecon_medic/pm_91strecon_medic.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_91PIL = DarkRP.createJob("91 | Клон Пілот", {
    color = Color(153, 0, 0),
    model = {"models/player/91st/91p1plt.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
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
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_91ARF = DarkRP.createJob("91 | Клон ARF", {
    color = Color(153, 0, 0),
    model = {"models/lightning/91strecon_arf_co/pm_91strecon_arf_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "91st",
    command="91arf",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 1) -- kama
        ply:SetBodygroup(3, 0) -- backpack
        ply:SetBodygroup(4, 0) -- hair
        ply:SetBodygroup(5, 0) -- fhair
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 1) -- holster left
        ply:SetBodygroup(8, 0) -- shoulder antenna
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_5PVT = DarkRP.createJob("5 | Клон Рядовий", {
    color = Color(26, 74, 127),
    model = {"models/5th_trp/pm_5th_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5pvt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hait
        ply:SetBodygroup(6, 0) -- fhair
        ply:SetArmor(20)
        ply:SetMaxArmor(20)
    end
})

TEAM_5SGT = DarkRP.createJob("5 | Клон Сержант", {
    color = Color(26, 74, 127),
    model = {"models/5th_nco/pm_5th_nco.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5sgt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1) -- kama
        ply:SetBodygroup(3, 0) -- binos
        ply:SetBodygroup(4, 0) -- flashlight
        ply:SetBodygroup(5, 0) -- backpack
        ply:SetBodygroup(6, 0) -- hair
        ply:SetBodygroup(7, 0) -- fhair
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_5LT = DarkRP.createJob("5 | Клон Лейтенант", {
    color = Color(26, 74, 127),
    model = {"models/5th_officer/pm_5th_officer.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5lt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 0) -- binos
        ply:SetBodygroup(8, 0) -- flashlight
        ply:SetBodygroup(9, 0) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_5CMD = DarkRP.createJob("5 | Клон Командир", {
    color = Color(26, 74, 127),
    model = {"models/5th_cmd/pm_5th_cmd.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5cmd",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1) -- antena
        ply:SetBodygroup(3, 1) -- kama
        ply:SetBodygroup(4, 1) -- pauldron
        ply:SetBodygroup(5, 1) -- holster left
        ply:SetBodygroup(6, 1) -- holster right
        ply:SetBodygroup(7, 0) -- binos
        ply:SetBodygroup(8, 0) -- flashlight
        ply:SetBodygroup(9, 0) -- backpack
        ply:SetBodygroup(10, 0) -- hair
        ply:SetBodygroup(11, 0) -- fhair
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end
})

TEAM_5MED = DarkRP.createJob("5 | Клон Медик", {
    color = Color(26, 74, 127),
    model = {"models/5th_med/pm_5th_med.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5med",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0) -- binos
        ply:SetBodygroup(3, 0) -- flashlight
        ply:SetBodygroup(4, 0) -- backpack
        ply:SetBodygroup(5, 0) -- hair
        ply:SetBodygroup(6, 0) -- fhair
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_5PIL = DarkRP.createJob("5 | Клон Пілот", {
    color = Color(26, 74, 127),
    model = {"models/5th_plt/pm_5th_plt.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5pil",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0) 
        ply:SetBodygroup(2, 0) -- flashlight
        ply:SetBodygroup(3, 0) -- backpack
        ply:SetBodygroup(4, 0) -- hair
        ply:SetBodygroup(5, 0) -- fhair
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_B1 = DarkRP.createJob("САД | B1", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b1_battledroid_pm.mdl"},
    description = "",
    weapons = {"rw_sw_e5"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b1",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- backpack
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_B1CO = DarkRP.createJob("САД | B1 Командир", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b1_battledroid_commander_pm.mdl"},
    description = "",
    weapons = {"rw_sw_e5"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b1co",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- backpack
        ply:SetArmor(70)
        ply:SetMaxArmor(70)
    end
})

TEAM_B1SNP = DarkRP.createJob("САД | B1 Снайпер", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b1_battledroid_pm.mdl"},
    description = "",
    weapons = {"rw_sw_e5s"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b1snp",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetBodygroup(2, 0) -- backpack
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_B1Z4 = DarkRP.createJob("САД | B1 з Z-4", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b1_battledroid_pm.mdl"},
    description = "",
    weapons = {"rw_sw_z4"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b1z4",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- helmet
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_B2 = DarkRP.createJob("САД | B2", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b2_battledroid_pm.mdl"},
    description = "",
    weapons = {"rw_sw_b2rp_blaster"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b2",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- base
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end
})

TEAM_B2CAN = DarkRP.createJob("САД | B2 з рокетницею", {
    color = Color(96, 96, 96),
    model = {"models/aussiwozzi/cgi/b1droids/b2_battledroid_cannon_pm.mdl"},
    description = "",
    weapons = {"rw_sw_b2rp_blaster", "rw_sw_b2rp_rocket"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="b2can",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetBodygroup(1, 0) -- base
        ply:SetArmor(50)
        ply:SetMaxArmor(50)

    end
})

TEAM_BX = DarkRP.createJob("САД | BX", {
    color = Color(96, 96, 96),
    model = {"models/bx/pm_droid_cis_bx.mdl"},
    description = "",
    weapons = {"rw_sw_e5bx"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="bx",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetArmor(40)
        ply:SetMaxArmor(40)

    end
})

TEAM_GUNRAY = DarkRP.createJob("КНС | Ганрей", {
    color = Color(96, 96, 96),
    model = {"models/player/nsn/gunray.mdl"},
    description = "",
    weapons = {"rw_sw_rg4d"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="gunray",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end
})

TEAM_TACTICAL = DarkRP.createJob("САД | Тактичний дроїд", {
    color = Color(96, 96, 96),
    model = {"models/player/swcw/std_auto.mdl"},
    description = "",
    weapons = {"rw_sw_e5"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    command="tactical",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) -- body
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_GANGMALE = DarkRP.createJob("Цивільні | Бандит", {
    color = Color(102, 255, 102),
    model = {"models/assassin/pm_civ_assassin_human_male.mdl"},
    description = "",
    weapons = {"rw_sw_e5"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="gangmale",
})

TEAM_GANGFEMALE = DarkRP.createJob("Цивільні | Бандитка", {
    color = Color(102, 255, 102),
    model = {"models/bandit/pm_civ_bandit_human_female.mdl"},
    description = "",
    weapons = {"rw_sw_e5"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="gangfemale",
})

TEAM_CIVMALE = DarkRP.createJob("Цивільні | Цивільний", {
    color = Color(102, 255, 102),
    model = {"models/dweller/pm_civ_dweller_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="civmale",
})

TEAM_CIVFEMALE = DarkRP.createJob("Цивільні | Цивільна", {
    color = Color(102, 255, 102),
    model = {"models/dweller/pm_civ_dweller_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="civfemale",
})

TEAM_ENGMALE = DarkRP.createJob("Цивільні | Інженер", {
    color = Color(102, 255, 102),
    model = {"models/engineer/pm_civ_engineer_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="engmale",
})

TEAM_ENGFEMALE = DarkRP.createJob("Цивільні | Інженерка", {
    color = Color(102, 255, 102),
    model = {"models/engineer/pm_civ_engineer_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="engfemale",
})

TEAM_FORMALMALE = DarkRP.createJob("Цивільні | Чоловік в офіційному одязі", {
    color = Color(102, 255, 102),
    model = {"models/formal/pm_civ_formal_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="formalmale",
})

TEAM_FORMALFEMALE = DarkRP.createJob("Цивільні | Жінка в офіційному одязі", {
    color = Color(102, 255, 102),
    model = {"models/formal/pm_civ_formal_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="formalfemale",
})

TEAM_GUARDMALE = DarkRP.createJob("Цивільні | Охоронець", {
    color = Color(102, 255, 102),
    model = {"models/guard/pm_civ_guard_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="guardmale",
})

TEAM_GUARDFEMALE = DarkRP.createJob("Цивільні | Охоронниця", {
    color = Color(102, 255, 102),
    model = {"models/guard/pm_civ_guard_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="guardfemale",
})

TEAM_JAN1 = DarkRP.createJob("Цивільні | Прибиральник 1", {
    color = Color(102, 255, 102),
    model = {"models/janitor/pm_civilian_janitor.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="jan1",
})

TEAM_JAN2 = DarkRP.createJob("Цивільні | Прибиральник 2", {
    color = Color(102, 255, 102),
    model = {"models/janitor/pm_civilian_maintenance.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="jan2",
})

TEAM_NOBLEMALE = DarkRP.createJob("Цивільні | Шляхетний чоловік", {
    color = Color(102, 255, 102),
    model = {"models/noble/pm_civ_noble_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="noblemale",
})

TEAM_NOBLEFEMALE = DarkRP.createJob("Цивільні | Шляхетна жінка", {
    color = Color(102, 255, 102),
    model = {"models/noble/pm_civ_noble_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="noblefemale",
})

TEAM_SNOWMALE = DarkRP.createJob("Цивільні | Чоловік в зимовому одязі", {
    color = Color(102, 255, 102),
    model = {"models/snowsuit/pm_civ_snowsuit_human_male.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="snowmale",
})

TEAM_SNOWFEMALE = DarkRP.createJob("Цивільні | Жінка в зимовому одязі", {
    color = Color(102, 255, 102),
    model = {"models/snowsuit/pm_civ_snowsuit_human_female.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="snowfemale",
})

TEAM_SMUGMALE = DarkRP.createJob("Цивільні | Розбійник", {
    color = Color(102, 255, 102),
    model = {"models/smuggler/pm_civ_smuggler_human_male.mdl"},
    description = "",
    weapons = {"rw_sw_rg4d"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="smugmale",
})

TEAM_SMUGFEMALE = DarkRP.createJob("Цивільні | Розбійниця", {
    color = Color(102, 255, 102),
    model = {"models/smuggler/pm_civ_smuggler_human_female.mdl"},
    description = "",
    weapons = {"rw_sw_rg4d"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="smugfemale",
})

TEAM_SCIMALE = DarkRP.createJob("Цивільні | Науковець", {
    color = Color(102, 255, 102),
    model = {"models/scientist/pm_civ_scientist_human_male.mdl"},
    description = "",
    weapons = {""},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="scimale",
})

TEAM_SCIFEMALE = DarkRP.createJob("Цивільні | Науковиця", {
    color = Color(102, 255, 102),
    model = {"models/scientist/pm_civ_scientist_human_female.mdl"},
    description = "",
    weapons = {""},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="scifemale",
})

TEAM_CITIZENMALE = DarkRP.createJob("Цивільні | Громадянин", {
    color = Color(102, 255, 102),
    model = {"models/resident/pm_civ_resident_human_male.mdl"},
    description = "",
    weapons = {""},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="citizenmale",
})

TEAM_CITIZENFEMALE = DarkRP.createJob("Цивільні | Громадянинка", {
    color = Color(102, 255, 102),
    model = {"models/resident/pm_civ_resident_human_female.mdl"},
    description = "",
    weapons = {""},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="citizenfemale",
})

TEAM_RENMALE = DarkRP.createJob("Цивільні | Повстанець", {
    color = Color(102, 255, 102),
    model = {"models/renegade/pm_civ_renegade_human_male.mdl"},
    description = "",
    weapons = {"rw_sw_se14c"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="renmale",
})

TEAM_RENFEMALE = DarkRP.createJob("Цивільні | Повстанка", {
    color = Color(102, 255, 102),
    model = {"models/renegade/pm_civ_renegade_human_female.mdl"},
    description = "",
    weapons = {"rw_sw_se14c"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    command="renfemale",
})

TEAM_RCSkoll = DarkRP.createJob("RC Shadow | Skoll", {
    color =  Color(70, 70, 70),
    model = {"models/sample/sample/rc/rc.mdl"},
    description = "",
    weapons = {"rw_sw_dc17m"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RC",
    command="rcskoll",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 1)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
        ply:SetExoSuit("katarn") -- ✅
        ply:SetNWFloat("exoarmor", 100)
        ply:SetNWFloat("exoenergy", 100)
    end
})

TEAM_RCShadow = DarkRP.createJob("RC Shadow | Shadow", {
    color = Color(70, 70, 70),
    model = {"models/sample/sample/rc/rc.mdl"},
    description = "",
    weapons = {"rw_sw_dc17m"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RC",
    command="rcshadow",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 1)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
        ply:SetExoSuit("katarn") -- ✅
        ply:SetNWFloat("exoarmor", 100)
        ply:SetNWFloat("exoenergy", 100)
    end
})

TEAM_RCRedhood = DarkRP.createJob("RC Shadow | Redhood", {
    color = Color(70, 70, 70),
    model = {"models/sample/sample/rc/rc.mdl"},
    description = "",
    weapons = {"rw_sw_dc17m"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RC",
    command="rcredhood",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 1)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
        ply:SetExoSuit("katarn") -- ✅
        ply:SetNWFloat("exoarmor", 100)
        ply:SetNWFloat("exoenergy", 100)
    end
})

TEAM_RCHowl = DarkRP.createJob("RC Shadow | Howl", {
    color = Color(70, 70, 70),
    model = {"models/sample/sample/rc/rc.mdl"},
    description = "",
    weapons = {"rw_sw_dc17m"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RC",
    command="rchowl",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 1)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
        ply:SetExoSuit("katarn") -- ✅
        ply:SetNWFloat("exoarmor", 100)
        ply:SetNWFloat("exoenergy", 100)
    end
})

TEAM_5PROT = DarkRP.createJob("5 | Клон Преторіанець", {
    color = Color(26, 74, 127),
    model = {"models/5th_senate/pm_5th_senate.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "5th",
    command="5prot",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1) -- kama
        ply:SetBodygroup(3, 0) -- binos
        ply:SetBodygroup(4, 0) -- flashlight
        ply:SetBodygroup(5, 0) -- backpack
        ply:SetBodygroup(6, 0) -- hair
        ply:SetBodygroup(7, 0) -- fhair
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_ADMIN = DarkRP.createJob("Адміністратор", {
    color = Color(92, 40, 97),
    model = {"models/naval_eng/pm_naval_eng.mdl"},
    description = "",
    weapons = {"gmod_tool", "weapon_physgun", "weapon_physcannon"},
    max = 100,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Other",
    command="admin",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0) 
        ply:SetBodygroup(1, 0)  
        ply:SetBodygroup(2, 0) 
        ply:SetBodygroup(3, 0) 
        ply:SetBodygroup(4, 0) 
        ply:SetBodygroup(5, 0) 
        ply:SetBodygroup(6, 0) 
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end
})

TEAM_SUNWAVE = DarkRP.createJob("501 | RC Санвейв", {
    color = Color(70, 70, 70),
    model = {"models/bobby/sega/sega.mdl"},
    description = "",
    weapons = {},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="sunwave",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 1) 
        ply:SetBodygroup(1, 1)
        ply:SetArmor(100) -- armor
        ply:SetMaxArmor(100)
    end
})

TEAM_501PVT = DarkRP.createJob("501 | Клон Рядовий", {
    color = Color(0, 102, 204),
    model = {"models/501st_trp/pm_501st_trp.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501pvt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetArmor(20)
        ply:SetMaxArmor(20)
    end
})

TEAM_501SGT = DarkRP.createJob("501 | Клон Сержант", {
    color = Color(0, 102, 204),
    model = {"models/501st_nco/pm_501st_nco.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501sgt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_501LT = DarkRP.createJob("501 | Клон Лейтенант", {
    color = Color(0, 102, 204),
    model = {"models/501st_xo/pm_501st_xo.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501lt",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 1)
        ply:SetBodygroup(4, 1)
        ply:SetBodygroup(5, 1)
        ply:SetBodygroup(6, 1)
        ply:SetBodygroup(7, 2)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetArmor(40)
        ply:SetMaxArmor(40)
    end
})

TEAM_501CMD = DarkRP.createJob("501 | Клон Командир", {
    color = Color(0, 102, 204),
    model = {"models/501st_co/pm_501st_co.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501cmd",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 1)
        ply:SetBodygroup(6, 1)
        ply:SetBodygroup(7, 2)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end
})

TEAM_501MED = DarkRP.createJob("501 | Клон Медик", {
    color = Color(0, 102, 204),
    model = {"models/501st_medic/pm_501st_medic.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501med",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 3)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_501PIL = DarkRP.createJob("501 | Клон Пілот", {
    color = Color(0, 102, 204),
    model = {"models/501st_pilot/pm_501st_pilot.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501pil",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetArmor(30)
        ply:SetMaxArmor(30)
    end
})

TEAM_501ARC = DarkRP.createJob("501 | Клон ARC", {
    color = Color(0, 102, 204),
    model = {"models/501st_arc/pm_501st_arc.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    command="501arc",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1)
        ply:SetBodygroup(3, 4)
        ply:SetBodygroup(4, 1)
        ply:SetBodygroup(5, 1)
        ply:SetBodygroup(6, 1)
        ply:SetBodygroup(7, 1)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end
})

TEAM_ARCKomandos = DarkRP.createJob("Клон ARC Командос", {
    color = Color(250, 250, 250),
    model = {"models/md/arc/arc_alpha_mn_10_v2.mdl"},
    description = "",
    weapons = {"rw_sw_dc15a_o"},
    max = 100,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CT",
    command="arckomandos",
    PlayerLoadout = function(ply)
        ply:SetBodygroup(0, 0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 1)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 1)
        ply:SetBodygroup(5, 1)
        ply:SetBodygroup(6, 1)
        ply:SetBodygroup(7, 1)
        ply:SetBodygroup(8, 1)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
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
