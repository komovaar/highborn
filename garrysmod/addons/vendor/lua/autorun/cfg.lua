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
        price = 2000,
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
        price = 2000,
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
        price = 0,
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
        name = "DC-17s",
        class = "rw_sw_dc17s",
        price = 2000,
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
        name = "DC-15s",
        class = "rw_sw_dc15s",
        price = 15,
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
        price = 5,
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
        price = 2000,
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
        price = 2000,
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
        price = 2000,
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
        price = 2000,
        model = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl",
        stats = {
            damage = 10,
            rpm = 300,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs={TEAM_212PARA}
    },
        {
        name = "DC-15x",
        class = "rw_sw_dc15x",
        price = 2000,
        model = "models/cs574/weapons/dc15x.mdl",
        stats = {
            damage = 85,
            rpm = 75,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon",
        vip = false,
        jobs=nil
    },
    {
        name = "DC-19",
        class = "rw_sw_dc19",
        price = 2000,
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
        price = 2000,
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
        price = 2000,
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
        price = 2000,
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
    ["models/212th_trp/pm_212th_trp.mdl"] = {
        armor = {
            id = 4,
            name = "Наплечник",
            price = 1200,
            vip = false,
            default = 1,
        },
        kama = {
            id = 3,
            name = "Кама",
            price = 300,
            vip = false,
            default = 1,
        },
        backpack = {
            id = 5,
            name = "Кама",
            price = 300,
            vip = true,
            default = 1,
        },
        jetpack = {
            id = 4,
            name = "Джетпак",
            price = 300,
            vip = false,
            default = 3,
        }
    },
        ["models/212th_co/pm_212th_co.mdl"] = {
        armor = {
            id = 4,
            name = "Наплечник",
            price = 1200,
            vip = false,
            default = 1,
        },
        kama = {
            id = 3,
            name = "Кама",
            price = 300,
            vip = false,
            default = 1,
        },
        backpack = {
            id = 5,
            name = "Кама",
            price = 300,
            vip = true,
            default = 1,
        },
        jetpack = {
            id = 4,
            name = "Джетпак",
            price = 300,
            vip = false,
            default = 3,
        }
    }
}

