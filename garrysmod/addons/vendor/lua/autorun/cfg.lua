Vendor = Vendor or {}
Vendor.CurrencySymbol = "RC "
Vendor.BlockedJobs = {
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
Vendor.IsVIP = function(ply)
    return ply:IsUserGroup("vip")
end

Vendor.Weapons = {
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
        class = "rw_sw_dc17",
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
        name = "DC-15a",
        class = "rw_sw_dc17c",
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
            damage = 10,
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
        jobs={TEAM_212PVT, TEAM_212SGT, TEAM_212LT, TEAM_212CMD, TEAM_212MED, TEAM_212PIL, TEAM_212PARA}
    },
        {
        name = "DC-15x",
        class = "rw_sw_dc15x",
        price = 20000,
        model = "models/cs574/weapons/dc15x.mdl",
        stats = {
            damage = 85,
            rpm = 75,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={TEAM_91PVT, TEAM_91SGT, TEAM_91LT, TEAM_91CMD, TEAM_91PIL, TEAM_91ARF, TEAM_91MED}
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
        class = "rw_sw_valkenx38a",
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
["models/lightning/91strecon_arf/pm_91strecon_arf.mdl"] = {
    backpack = { id = 2, name = "Рюкзак", price = 3500, vip = false, default = 1 },
},
["models/ct_arc/pm_ct_arc.mdl"] = {
    belt = { id = 2, name = "Пояс", price = 1500, vip = false, default = 1 },
    backpack = { id = 3, name = "Рюкзак", price = 3500, vip = false, default = 1 },
    kama = { id = 4, name = "Кама", price = 10000, vip = false, default = 1 },
    forearms = { id = 5, name = "Бронепластина", price = 5000, vip = false, default = 1 },
    pauldron = { id = 6, name = "Наплічник", price = 10000, vip = false, default = 1 },
    antena = { id = 7, name = "Антена", price = 2500, vip = false, default = 2 },
},
}


