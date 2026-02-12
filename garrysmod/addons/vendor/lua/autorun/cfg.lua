Vendor = Vendor or {}
Vendor.CurrencySymbol = "RC "
Vendor.BlockedJobs = {
    TEAM_CITIZEN,
    TEAM_MEDIC,
}
Vendor.IsVIP = function(ply)
    return ply:IsUserGroup("vip") or ply:IsUserGroup("supervip")
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
    ["models/aussiwozzi/cgi/base/212th_trooper.mdl"] = {
        armor = {
            id = 5,
            name = "Наплечник",
            price = 1200,
            vip = false,
            options = {
                [0] = "Без броні",
                [1] = "Наплечник",
            }
        },
        kama = {
            id = 6,
            name = "Кама",
            price = 300,
            vip = false,
            options = {
                [0] = "Немає",
                [1] = "Кама",
            }
        },
        backpack = {
            id = 14,
            name = "Кама",
            price = 300,
            vip = false,
            options = {
                [0] = "Немає",
                [1] = "Рюкзак",
            }
        }
    }
}
