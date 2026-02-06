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

-- =========================================
-- НАСТРОЙКИ
-- =========================================
BodygroupTraderConfig.CurrencySymbol = "$"

-- Как определить VIP
BodygroupTraderConfig.IsVIP = function(ply)
    return ply:IsUserGroup("vip") or ply:IsUserGroup("supervip")
end

-- =========================================
-- КОНФИГ МОДЕЛЕЙ
-- =========================================
BodygroupTraderConfig.Models = {

    ["models/aussiwozzi/cgi/base/212th_trooper.mdl"] = {

        -- =============================
        -- ШЛЕМ
        -- =============================
        helmet = {
            id = 1, -- ID бодигрупы в модели
            name = "Шолом",
            price = 500,
            vip = false,
            options = {
                [0] = "Без шолома",
                [1] = "В шоломі",
            }
        },

        -- =============================
        -- БРОНЯ (VIP)
        -- =============================
        armor = {
            id = 4,
            name = "Наплечник",
            price = 1200,
            vip = false,
            options = {
                [0] = "Без броні",
                [1] = "Легка броня",
            }
        },

        -- =============================
        -- РЮКЗАК
        -- =============================
        backpack = {
            id = 5,
            name = "Кама",
            price = 300,
            vip = false,
            options = {
                [0] = "Немає",
                [1] = "Малий рюкзак",
            }
        }
    },

    -- =====================================
    -- ДРУГА МОДЕЛЬ
    -- =====================================
    ["models/Humans/Group01/female_02.mdl"] = {

        hair = {
            id = 1,
            name = "Зачіска",
            price = 250,
            vip = false,
            options = {
                [0] = "Коротке волосся",
                [1] = "Довге волосся",
                [2] = "Хвіст"
            }
        }
    }
}
