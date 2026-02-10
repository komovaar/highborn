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
        class = "rw_sw_dc15a",
        price = 10,
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
        model = "models/weapons/w_dc15a.mdl",
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
        model = "models/weapons/w_dc15a.mdl",
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
        backpack = {
            id = 6,
            name = "Кама",
            price = 300,
            vip = false,
            options = {
                [0] = "Немає",
                [1] = "Кама",
            }
        }
    }
}
