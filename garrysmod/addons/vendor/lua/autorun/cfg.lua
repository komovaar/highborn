Vendor = Vendor or {}
Vendor.CurrencySymbol = "RC "
Vendor.BlockedJobs = {
    TEAM_ADMIN,
    TEAM_B1,
    TEAM_FLEET_NAVI,
    TEAM_FLEET_ADM,
    TEAM_B1CO,
    TEAM_B1SNP,
    TEAM_B1Z4,
    TEAM_B2,
    TEAM_BX,
    TEAM_GUNRAY,
    TEAM_TACTICAL,
    TEAM_GANGMALE,
    TEAM_GANGFEMALE,
    TEAM_CIVMALE,
    TEAM_CIVFEMALE,
    TEAM_ENGMALE,
    TEAM_ENGFEMALE,
    TEAM_FORMALMALE,
    TEAM_FORMALFEMALE,
    TEAM_GUARDMALE,
    TEAM_GUARDFEMALE,
    TEAM_JAN1,
    TEAM_JAN2,
    TEAM_NOBLEMALE,
    TEAM_NOBLEFEMALE,
    TEAM_SNOWMALE,
    TEAM_SNOWFEMALE,
    TEAM_SMUGMALE,
    TEAM_SMUGFEMALE,
    TEAM_SCIMALE,
    TEAM_SCIFEMALE,
    TEAM_CITIZENMALE,
    TEAM_CITIZENFEMALE,
    TEAM_RENMALE,
    TEAM_RENFEMALE
}
Vendor.VIPSteamIDs = Vendor.VIPSteamIDs or {}
Vendor.VIPSteamIDs["STEAM_0:0:594545981"] = true

Vendor.IsVIP = function(ply)
    if not IsValid(ply) then
        return false
    end

    local bHighbornVIP = HighbornVIP and HighbornVIP.IsVIP and HighbornVIP.IsVIP(ply)

    return bHighbornVIP
        or ply:IsUserGroup("vip")
        or Vendor.VIPSteamIDs[ply:SteamID()] == true
end

Vendor.Weapons = {
    {
        name = "DC-15a",
        class = "rw_sw_dc15a_o",
        price = 0,
        model = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        stats = {
            damage = 15,
            rpm = 250,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DC-17",
        class = "rw_sw_dc17",
        price = 5000,
        model = "models/sw_battlefront/weapons/dc17_blaster.mdl",
        stats = {
            damage = 20,
            rpm = 325,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DC-17c",
        class = "rw_sw_dc17c",
        price = 7500,
        model = "models/cs574/weapons/dc17c.mdl",
        stats = {
            damage = 20,
            rpm = 350,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "Westar-34",
        class = "rw_sw_westar34",
        price = 5000,
        model = "models/cs574/weapons/westar34.mdl",
        stats = {
            damage = 35,
            rpm = 210,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_SPECTER"}
    },
    {
        name = "Dual Westar-34",
        class = "rw_sw_dual_westar34",
        price = 30000,
        model = "models/cs574/weapons/westar34.mdl",
        stats = {
            damage = 35,
            rpm = 336,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_SPECTER"}
    },
    {
        name = "Dual DC-17",
        class = "rw_sw_dual_dc17",
        price = 40000,
        model = "models/sw_battlefront/weapons/dc17_blaster.mdl",
        stats = {
            damage = 15,
            rpm = 250,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DC-15s",
        class = "rw_sw_dc15s",
        price = 7500,
        model = "models/sw_battlefront/weapons/dc15s_carbine.mdl",
        stats = {
            damage = 20,
            rpm = 375,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
     {
        name = "DC-15s Stun",
        class = "rw_sw_stun_dc15s",
        price = 2500,
        model = "models/sw_battlefront/weapons/dc15s_carbine.mdl",
        stats = {
            damage = 30,
            rpm = 375,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_5PVT", "TEAM_5SGT", "TEAM_5LT", "TEAM_5CMD", "TEAM_5PIL", "TEAM_5MED", "TEAM_5PROT"}
    },
    {
        name = "DC-15LE",
        class = "rw_sw_dc15le_o",
        price = 10000,
        model = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        stats = {
            damage = 20,
            rpm = 220,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DC15-SE",
        class = "rw_sw_dc15se",
        price = 12500,
        model = "models/cs574/weapons/dc15se.mdl",
        stats = {
            damage = 20,
            rpm = 275,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DP-23",
        class = "rw_sw_dp23",
        price = 15000,
        model = "models/cs574/weapons/dp23.mdl",
        stats = {
            damage = 15,
            rpm = 75,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DP-24",
        class = "rw_sw_dp24",
        price = 20000,
        model = "models/cs574/weapons/dp24.mdl",
        stats = {
            damage = 20,
            rpm = 425,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "Z-6",
        class = "rw_sw_z6",
        price = 20000,
        model = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl",
        stats = {
            damage = 10,
            rpm = 300,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_212PVT", "TEAM_212SGT", "TEAM_212LT", "TEAM_212CMD", "TEAM_212MED", "TEAM_212PIL", "TEAM_212PARA"}
    },
        {
        name = "DC-15x",
        class = "rw_sw_dc15x",
        price = 20000,
        model = "models/cs574/weapons/dc15x.mdl",
        stats = {
            damage = 100,
            rpm = 75,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_91PVT", "TEAM_91SGT", "TEAM_91LT", "TEAM_91CMD", "TEAM_91PIL", "TEAM_91ARF", "TEAM_91MED"}
    },
    {
    name = "RPS-6",
    class = "rw_sw_rps6",
    price = 20000,
    model = "models/rps6/Zl_RPS-6.mdl",
    stats = {
        damage = 1000,
        rpm = 100,
        accuracy = "High",
        mode = "Auto"
    },
    category = "weapon",
    vip = false,
    jobs={
        "TEAM_501PVT",
        "TEAM_501SGT",
        "TEAM_501LT",
        "TEAM_501CMD",
        "TEAM_501MED",
        "TEAM_501PIL",
        "TEAM_501ARC",
        "TEAM_SUNWAVE",
    }
},
    {
        name = "DC-17m",
        class = "rw_sw_dc17m",
        price = 0,
        model = "models/cs574/dc17m/dc17m_base.mdl",
        stats = {
            damage = 15,
            rpm = 400,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_RCBoss", "TEAM_RCFixer", "TEAM_RCScorch", "TEAM_RCSev"}
    },
    {
        name = "DC-17m Sniper",
        class = "rw_sw_dc17m_sniper",
        price = 20000,
        model = "models/cs574/dc17m/dc17m_base.mdl",
        stats = {
            damage = 85,
            rpm = 145,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_RCBoss", "TEAM_RCFixer", "TEAM_RCScorch", "TEAM_RCSev"}
    },
    {
        name = "Westar-M5",
        class = "rw_sw_westarm5",
        price = 20000,
        model = "models/swbf3/weapons/w_alphablaster.mdl",
        stats = {
            damage = 50,
            rpm = 435,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_501ARC", "TEAM_ARCKomandos", "TEAM_SPECTER"}
    },
    {
        name = "Наручна Ракетниця",
        class = "rw_sw_wristrocket",
        price = 20000,
        model = "models/cs574/weapons/arc_leftwrist.mdl",
        stats = {
            damage = 150,
            rpm = 95,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_SPECTER"}
    },

    {
        name = "DC-17m Shotgun",
        class = "rw_sw_dc17m_shotgun",
        price = 20000,
        model = "models/cs574/dc17m/dc17m_base.mdl",
        stats = {
            damage = 15,
            rpm = 100,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_RCBoss", "TEAM_RCFixer", "TEAM_RCScorch", "TEAM_RCSev"}
    },
        {
        name = "DC-17m Launcher",
        class = "rw_sw_dc17m_launcher",
        price = 40000,
        model = "models/cs574/dc17m/dc17m_base.mdl",
        stats = {
            damage = 1000,
            rpm = 50,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={"TEAM_RCBoss", "TEAM_RCFixer", "TEAM_RCScorch", "TEAM_RCSev"}
    },
    {
        name = "DC-17s",
        class = "rw_sw_dc17s",
        price = 10000,
        model = "models/fisher/dc17s/dc17s.mdl",
        stats = {
            damage = 35,
            rpm = 385,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = true,
        jobs=nil
    },
    {
        name = "DC-19",
        class = "rw_sw_dc19",
        price = 15000,
        model = "models/player/applesauce/228th/dc15s_carbine.mdl",
        stats = {
            damage = 30,
            rpm = 275,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = true,
        jobs=nil
    },
    {
        name = "DC-19LE",
        class = "rw_sw_dc19le",
        price = 15000,
        model = "models/player/applesauce/228th/dc15s_carbine.mdl",
        stats = {
            damage = 40,
            rpm = 155,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = true,
        jobs=nil
    },
    {
        name = "Valken 38a",
        class = "rw_sw_valkenx38a",
        price = 17500,
        model = "models/sw_battlefront/weapons/valken_noscope.mdl",
        stats = {
            damage = 55,
            rpm = 165,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = true,
        jobs=nil
    },
    {
        name = "Valken 38x",
        class = "rw_sw_valken38x",
        price = 20000,
        model = "models/sw_battlefront/weapons/valken_38x.mdl",
        stats = {
            damage = 55,
            rpm = 165,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = true,
        jobs=nil
    },
    {
        name = "Щит з DC-17",
        class = "rw_sw_shield_rep_dc17",
        price = 3500,
        model = "models/cs574/weapons/shields/blast_shield.mdl",
        stats = {
            damage = 0,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_5PROT"}
    },
    {
        name = "Гак-кішка",
        class = "realistic_hook",
        price = 3500,
        model = "models/weapons/w_alyx_gun.mdl",
        stats = {
            damage = 0,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_91ARF", "TEAM_RCBoss", "TEAM_RCFixer", "TEAM_RCSev", "TEAM_RCScorch"}
    },
    {
        name = "F-187 Fusion Cutter",
        class = "weapon_lvsrepair",
        price = 1500,
        model = "models/f137/w_repairtorch.mdl",
        stats = {
            damage = 10,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_212PIL", "TEAM_91PIL", "TEAM_5PIL", "TEAM_501PIL"}
    },
    {
        name = "Bacta Grenade",
        class = "rw_sw_nade_bacta",
        price = 1500,
        model = "models/cs574/explosif/grenade_bacta.mdl",
        stats = {
            damage = 0,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_91MED", "TEAM_212MED", "TEAM_5MED", "TEAM_501MED", "TEAM_SUNWAVE", "TEAM_RCBoss"}
    },
    {
        name = "Bacta Injector",
        class = "weapon_bactainjector",
        price = 1500,
        model = "models/sw_battlefront/props/e11r_stock/e11r_stock.mdl",
        stats = {
            damage = 0,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_91MED", "TEAM_212MED", "TEAM_5MED", "TEAM_SUNWAVE", "TEAM_RCBoss"}
    },
    {
        name = "Ammo Crate",
        class = "rw_ammo_distributor",
        price = 10000,
        model = "models/cs574/objects/ammo_box.mdl",
        stats = {
            damage = 0,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs=nil
    },
    {
        name = "Thermal Grenade",
        class = "rw_sw_nade_thermal",
        price = 10000,
        model = "models/weapons/tfa_starwars/w_thermal.mdl",
        stats = {
            damage = 75,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs=nil
    },
    {
        name = "S.L.A.M.",
        class = "weapon_slam",
        price = 1500,
        model = "models/weapons/w_slam.mdl",
        stats = {
            damage = 100,
            rpm = 0,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs={"TEAM_RCScorch", "TEAM_SUNWAVE"}
    },
    {
        name = "Impact Grenade",
        class = "rw_sw_nade_impact",
        price = 10000,
        model = "models/cs574/explosif/grenade_impact.mdl",
        stats = {
            damage = 75,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=true,
        jobs=nil
    },
    {
        name = "Flash Grenade",
        class = "rw_sw_nade_flash",
        price = 10000,
        model = "models/cs574/explosif/grenade_flash.mdl",
        stats = {
            damage = 0,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs=nil
    },
    {
        name = "Smoke Grenade",
        class = "rw_sw_nade_smoke",
        price = 10000,
        model = "models/cs574/explosif/grenade_smoke.mdl",
        stats = {
            damage = 0,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=false,
        jobs=nil
    },
    {
        name = "Dioxis Grenade",
        class = "rw_sw_nade_dioxis",
        price = 10000,
        model = "models/cs574/explosif/grenade_dioxis.mdl",
        stats = {
            damage = 7,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=true,
        jobs=nil
    },
    {
        name = "Shock Grenade",
        class = "rw_sw_nade_stun",
        price = 10000,
        model = "models/cs574/explosif/grenade_shock.mdl",
        stats = {
            damage = 10,
            rpm = 10,
            accuracy = "High",
            mode = "Auto"
        },
        category = "equipment",
        vip=true,
        jobs=nil
    },


}


Vendor.Models = {
["models/ct_trp/pm_ct_trp.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/ct_cmd/pm_ct_cmd.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 0 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = false, default = 0 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
},

["models/212th_trp/pm_212th_trp.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/212th_nco/pm_212th_nco.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/212th_xo/pm_212th_xo.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 0 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = false, default = 0 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 7, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 8, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/212th_co/pm_212th_co.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 1 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічик", price = 10000, vip = false, default = 1 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 7, name = "Бінокль", price = 5000, vip = false, default = 0 },
    flashlight = { id = 8, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/212th_medic/pm_212th_medic.mdl"] = {
    binos = { id = 2, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 0 },
},

["models/212th_pilot/pm_212th_pilot.mdl"] = {
    flashlight = { id = 2, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/md/212th/2nd/barlex.mdl"] = {
    sunvisor = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    jetpack = { id = 3, name = "Джетпак", price = 3500, vip = false, default = 0 },
    holster_right = { id = 5, name = "Кобура права", price = 1500, vip = false, default = 0 },
    holster_left = { id = 6, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    pauldron = { id = 7, name = "Наплічник", price = 10000, vip = true, default = 1 },
    kama = { id = 8, name = "Кама", price = 10000, vip = true, default = 0 },
    antena = { id = 9, name = "Антена", price = 2500, vip = false, default = 1 },
},
["models/player/91st/91p1trp.mdl"] = {
    binos = { id = 2, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/91st/91strecon_trp/pm_91strecon_trp.mdl"] = {
    binos = { id = 2, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/91st/91strecon_co/pm_91strecon_co.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 0 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    holster_left = { id = 4, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 5, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 6, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 7, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 8, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},

["models/player/91st/91p1neyo.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    binos = { id = 4, name = "Візер", price = 5000, vip = false, default = 1 },
    pauldron = { id = 5, name = "Наплічник", price = 10000, vip = false, default = 1 },
    kama = { id = 6, name = "Кама", price = 10000, vip = false, default = 1 },
    holster_left = { id = 7, name = "Кобура ліва", price = 1500, vip = false, default = 1 },
    holster_right = { id = 8, name = "Кобура права", price = 1500, vip = false, default = 1 },
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/91st/91strecon_medic/pm_91strecon_medic.mdl"] = {
    binos = { id = 2, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 0 },
},
["models/player/91st/91p1plt.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = true, default = 1 },
    kama = { id = 5, name = "Кама", price = 10000, vip = true, default = 1 },
    holster_left = { id = 6, name = "Кобура ліва", price = 1500, vip = false, default = 1 },
    holster_right = { id = 7, name = "Кобура права", price = 1500, vip = false, default = 0 },
    backpack = { id = 8, name = "Рюкзак", price = 3500, vip = false, default = 3 },
},
["models/lightning/91strecon_arf_co/pm_91strecon_arf_co.mdl"] = {
    kama = { id = 2, name = "Кама", price = 10000, vip = true, default = 0, off = 1 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0, off = 1 },
    holster_left = { id = 7, name = "Кобура ліва", price = 1500, vip = false, default = 0, off = 1 },
    shoulder_antena = { id = 8, name = "Антена на плечі", price = 3500, vip = false, default = 1 },
},
["models/ct_arc/pm_ct_arc.mdl"] = {
    belt = { id = 2, name = "Пояс", price = 1500, vip = false, default = 0 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
    kama = { id = 4, name = "Кама", price = 10000, vip = false, default = 0 },
    forearms = { id = 5, name = "Бронепластина", price = 5000, vip = false, default = 0 },
    pauldron = { id = 6, name = "Наплічник", price = 10000, vip = false, default = 0 },
    antena = { id = 7, name = "Антена", price = 2500, vip = false, default = 0 },
},
["models/5th_trp/pm_5th_trp.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_nco/pm_5th_nco.mdl"] = {
    kama = { id = 2, name = "Кама", price = 10000, vip = true, default = 0 },
    binos = { id = 3, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 4, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 5, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_officer/pm_5th_officer.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 0 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = false, default = 0 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 7, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 8, name = "Ліхтар", price = 1500, vip = false, default =  1},
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_cmd/pm_5th_cmd.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 0 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = false, default = 0 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 7, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 8, name = "Ліхтар", price = 1500, vip = false, default =  1},
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_med/pm_5th_med.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_plt/pm_5th_plt.mdl"] = {
    flashlight = { id = 2, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/5th_senate/pm_5th_senate.mdl"] = {
    kama = { id = 2, name = "Кама", price = 10000, vip = true, default = 0 },
    binos = { id = 3, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 4, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 5, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/bobby/sega/sega.mdl"] = {
    antena = { id = 5, name = "Антена", price = 500, vip = false, default = 1 },
},
["models/501st_trp/pm_501st_trp.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/501st_nco/pm_501st_nco.mdl"] = {
    binos = { id = 2, name = "Візор", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/501st_xo/pm_501st_xo.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 1 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплічник", price = 10000, vip = false, default = 0 },
    holster_left = { id = 5, name = "Кобура ліва", price = 1500, vip = false, default = 0 },
    holster_right = { id = 6, name = "Кобура права", price = 1500, vip = false, default = 0 },
    binos = { id = 7, name = "Візор", price = 5000, vip = false, default = 0 },
    flashlight = { id = 8, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 9, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/501st_medic/pm_501st_medic.mdl"] = {
    binos = { id = 2, name = "Візер", price = 5000, vip = false, default = 1 },
    flashlight = { id = 3, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 4, name = "Рюкзак", price = 3500, vip = false, default = 0 },
},
["models/501st_pilot/pm_501st_pilot.mdl"] = {
    flashlight = { id = 2, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/501st_arc/pm_501st_arc.mdl"] = {
    belt = { id = 2, name = "Пояс", price = 1500, vip = false, default = 0 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
    kama = { id = 4, name = "Кама", price = 10000, vip = true, default = 0 },
    forearms = { id = 5, name = "Бронепластина", price = 5000, vip = false, default = 0 },
    pauldron = { id = 6, name = "Наплічник", price = 10000, vip = true, default = 0 },
    antena = { id = 7, name = "Антена", price = 2500, vip = false, default = 0 },
},
["models/501st_co/pm_501st_co.mdl"] = {
    antena = { id = 2, name = "Антена", price = 2500, vip = false, default = 1 },
    kama = { id = 3, name = "Кама", price = 10000, vip = false, default = 1 },
    holster_left = { id = 7, name = "Кобура ліва", price = 1500, vip = false, default = 1 },
    holster_right = { id = 8, name = "Кобура права", price = 1500, vip = false, default = 1 },
    visor = { id = 5, name = "Візор", price = 5000, vip = false, default = 0 },
    flashlight = { id = 10, name = "Ліхтар", price = 1500, vip = false, default = 1 },
    backpack = { id = 11, name = "Рюкзак", price = 3500, vip = false, default = 1 },
    binos = { id = 9, name = "Бінокль", price = 5000, vip = false, default = 1 },
    shoulder_antena = { id = 6, name = "Антена на плечі", price = 3500, vip = false, default = 0 },
    pauldron = { id = 4, name = "Наплечник", price = 3500, vip = false, default = 1 },
},
["models/md/arc/arc_alpha_mn_10_v2.mdl"] = {
    antena = { id = 2, name = "Антена", price = 1500, vip = false, default = 0 },
    sunvisor = { id = 3, name = "Візер", price = 1500, vip = false, default = 1 },
    pauldron = { id = 4, name = "Наплечник", price = 1500, vip = false, default = 0 },
    jetpack = { id = 5, name = "Джетпак", price = 1500, vip = false, default = 0 },
    kama = { id = 6, name = "Кама", price = 1500, vip = false, default = 0 },
    straps = { id = 7, name = "Підсумки", price = 1500, vip = false, default = 0 },
    holsters = { id = 8, name = "Кобура", price = 1500, vip = false, default = 0 },
    belt = { id = 9, name = "Пояс", price = 1500, vip = false, default = 0 },
},
["models/player/iciia/501_wendigo/501_wendigo.mdl"] = {
    helm_acc1 = { id = 2, name = "Візер(піднятий)", price = 1500, vip = false, default = 1},
    helm_acc2 = { id = 2, name = "Візер(опущений)", price = 1500, vip = false, default = 2},
    medpack = { id = 3, name = "Медичний набір", price = 500, vip = false, default = 0},
    kama = { id = 4, name = "Кама", price = 10000, vip = false, default = 1}
},
["models/player/budds/cgi_commandos/delta/boss/delta_commando_boss.mdl"] = {
    vibroblade = { id = 4, name = "Віброклінок", price = 1500, vip = false, default = 1},
    att_left1 = { id = 5, name = "Спорядження Зліва 1", price = 3000, vip = false, default = 1},
    att_left2 = { id = 5, name = "Спорядження Зліва 2", price = 3000, vip = false, default = 2},
    att_right1= { id = 6, name = "Спорядження Зправа 1", price = 3000, vip = false, default = 1},
    att_right2 = { id = 6, name = "Спорядження Зправа 2", price = 3000, vip = false, default = 2},
},
["models/player/budds/cgi_commandos/delta/fixer/delta_commando_fixer.mdl"] = {
    antena_left = { id = 4, name = "Антена Ліва", price = 1500, vip = false, default = 0},
    antena_right = { id = 5, name = "Антена Права", price = 1500, vip = false, default = 1},
    backpack = { id = 6, name = "Спорядження до рюкзака", price = 5000, vip = false, default = 0},
    vibroblade = { id = 7, name = "Віброклінок", price = 1500, vip = false, default = 1},
    att_left1 = { id = 8, name = "Спорядження Зліва 1", price = 3000, vip = false, default = 1},
    att_left2 = { id = 8, name = "Спорядження Зліва 2", price = 3000, vip = false, default = 2},
    att_right1= { id = 9, name = "Спорядження Зправа 1", price = 3000, vip = false, default = 1},
    att_right2 = { id = 9, name = "Спорядження Зправа 2", price = 3000, vip = false, default = 2},
},
["models/player/budds/cgi_commandos/delta/scorch/delta_commando_scorch.mdl"] = {
    backpack = { id = 4, name = "Спорядження до рюкзака", price = 5000, vip = false, default = 0},
    vibroblade = { id = 5, name = "Віброклінок", price = 1500, vip = false, default = 1},
    att_left1 = { id = 6, name = "Спорядження Зліва 1", price = 3000, vip = false, default = 1},
    att_left2 = { id = 6, name = "Спорядження Зліва 2", price = 3000, vip = false, default = 2},
    att_right1= { id = 7, name = "Спорядження Зправа 1", price = 3000, vip = false, default = 0},
    att_right2 = { id = 7, name = "Спорядження Зправа 2", price = 3000, vip = false, default = 1},
},
["models/player/budds/cgi_commandos/delta/sev/delta_commando_sev.mdl"] = {
    helmet_up = { id = 4, name = "Візор 1", price = 3000, vip = false, default = 1},
    helmet_down = { id = 4, name = "Візор 2", price = 3000, vip = false, default = 2},
    sholder_att = { id = 5, name = "Спорядження на плече", price = 1500, vip = false, default = 0},
    vibroblade = { id = 6, name = "Віброклінок", price = 1500, vip = false, default = 1},
    att_left1 = { id = 7, name = "Спорядження Зліва 1", price = 3000, vip = false, default = 1},
    att_left2 = { id = 7, name = "Спорядження Зліва 2", price = 3000, vip = false, default = 2},
    att_right1= { id = 8, name = "Спорядження Зправа 1", price = 3000, vip = false, default = 1},
    att_right2 = { id = 8, name = "Спорядження Зправа 2", price = 3000, vip = false, default = 2},
},
["models/kylejwest/clanskirata/cgiwalonvau/cgiwalonvau.mdl"] = {
    belt = { id = 9, name = "Пояс", price = 2000, vip = false, default = 1},
    jetpack = { id = 10, name = "Джетпак", price = 3500, vip = false, default = 0},
    shoulder_left = { id = 11, name = "Лівий наплічник", price = 1500, vip = false, default = 0},
    shoulder_right = { id = 12, name = "Правий наплічник", price = 1500, vip = false, default = 0},
    kama = { id = 13, name = "Кама", price = 5000, vip = false, default = 0},
    holster_left = { id = 14, name = "Кобура ліва", price = 1500, vip = false, default = 0},
    holster_right = { id = 15, name = "Кобура права", price = 1500, vip = false, default = 0},
},
["models/md/501st/501_jet3.mdl"] = {
    antena = { id = 2, name = "Антена", price = 1500, vip = false, default = 0},
    kama = { id = 3, name = "Кама", price = 15000, vip = false, default = 0},
    holster_left = { id = 4, name = "Кобура ліва", price = 1500, vip = false, default = 0},
    holster_right = { id = 5, name = "Кобура права", price = 1500, vip = false, default = 0},
    pauldron = { id = 7, name = "Наплічник", price = 15000, vip = false, default = 0},
    sunvisor = { id = 8, name = "Візор", price = 5000, vip = false, default = 0},
}
}


