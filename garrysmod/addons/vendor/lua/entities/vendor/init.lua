net.Receive("WeaponTrader.Buy", function(_, ply)
    local weaponClass = net.ReadString()

    if IsBlockedJob(ply) then
        ply:ChatPrint("🚫 Ваша профессия не может использовать оружие")
        return
    end

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        if wep.class == weaponClass then

            local money = ply:getDarkRPVar("money") or 0
            if money < wep.price then
                ply:ChatPrint("❌ Недостаточно денег")
                return
            end

            ply:addMoney(-wep.price)

            sql.Query("INSERT INTO perma_weapons VALUES (" ..
                sql.SQLStr(ply:SteamID()) .. ", " ..
                sql.SQLStr(weaponClass) .. ")")

            timer.Simple(0.1, function()
                if IsValid(ply) and not IsBlockedJob(ply) then
                    ply:Give(weaponClass)
                    ply:SelectWeapon(weaponClass)
                end
            end)

            ply:ChatPrint("✅ Оружие приобретено")
            return
        end
    end
end)
