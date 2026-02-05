WeaponTraderConfig = {}

WeaponTraderConfig.MainColor = Color(80,140,220)

WeaponTraderConfig.BlockedJobs = {
    TEAM_CITIZEN,
    TEAM_MEDIC,
}


WeaponTraderConfig.Weapons = {
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

BodygroupTraderConfig = BodygroupTraderConfig or {}

BodygroupTraderConfig.PricePerLevel = 1000

-- запрещённые профессии (по желанию)
BodygroupTraderConfig.BlockedJobs = {
    ["Citizen"] = true
}
