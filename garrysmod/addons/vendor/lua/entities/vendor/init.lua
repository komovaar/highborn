net.Receive("WeaponTrader.Buy", function(_, ply)
    local weaponClass = net.ReadString()

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        if wep.class == weaponClass then

            if not weapons.Get(weaponClass) then
                ply:ChatPrint("❌ Оружие не существует")
                return
            end

            local money = ply:getDarkRPVar("money") or 0
            if money < wep.price then
                ply:ChatPrint("❌ Недостаточно денег")
                return
            end

            -- защита от повторной покупки
            local exists = sql.QueryRow("SELECT 1 FROM perma_weapons WHERE steamid = " ..
                sql.SQLStr(ply:SteamID()) .. " AND weapon = " .. sql.SQLStr(weaponClass))
            if exists then
                ply:ChatPrint("⚠️ Это оружие уже куплено")
                return
            end

            ply:addMoney(-wep.price)

            sql.Query("INSERT INTO perma_weapons VALUES (" ..
                sql.SQLStr(ply:SteamID()) .. ", " ..
                sql.SQLStr(weaponClass) .. ")")

            -- ВЫДАЁМ СРАЗУ
            timer.Simple(0.1, function()
                if IsValid(ply) then
                    ply:Give(weaponClass)
                    ply:SelectWeapon(weaponClass)
                end
            end)

            ply:ChatPrint("✅ Оружие куплено навсегда")
            return
        end
    end
end)
