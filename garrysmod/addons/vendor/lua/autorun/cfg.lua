Vendor = Vendor or {}
Vendor.CurrencySymbol = "RC "
Vendor.BlockedJobs = {
    TEAM_CITIZEN,
    TEAM_MEDIC,
}
Vendor.IsVIP = function(ply)
    return ply:IsUserGroup("vip")
end

Vendor.Weapons = {
    {
        name = "AK-47",
        class = "rw_sw_dc15s",
        price = 10,
        model = "models/sw_battlefront/weapons/2019/dc15s_base1.mdl",
        stats = {
            damage = 35,
            rpm = 600,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon"
    },
    {
        name = "M4A1",
        class = "rw_sw_dc15a",
        price = 15,
        model = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        stats = {
            damage = 35,
            rpm = 600,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon"
    },
    {
        name = "M5",
        class = "rw_sw_westarm5",
        price = 5,
        model = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        stats = {
            damage = 35,
            rpm = 600,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon"
    },
    {
        name = "DC17-s",
        class = "rw_sw_dc17s",
        price = 2000,
        model = "models/fisher/dc17s/dc17s.mdl",
        stats = {
            damage = 35,
            rpm = 600,
            accuracy = "High",
            mode = "Auto"
        },
        category = "weapon"
    }
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
            vip = false,
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
