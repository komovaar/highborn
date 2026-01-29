local function IsBlockedJob(ply)
    for _, teamID in ipairs(WeaponTraderConfig.BlockedJobs) do
        if ply:Team() == teamID then
            return true
        end
    end
    return false
end



if SERVER then
    sql.Query([[
        CREATE TABLE IF NOT EXISTS perma_weapons (
            steamid TEXT,
            weapon TEXT
        )
    ]])

    local function GivePermaWeapons(ply)
        if not IsValid(ply) then return end

        -- ❌ если профессия запрещена — НЕ выдаем
        if IsBlockedJob(ply) then
            ply:StripWeapons()
            return
        end

        timer.Simple(0.1, function()
            if not IsValid(ply) then return end

            local data = sql.Query(
                "SELECT weapon FROM perma_weapons WHERE steamid = " ..
                sql.SQLStr(ply:SteamID())
            )
            if not data then return end

            for _, row in ipairs(data) do
                if weapons.Get(row.weapon) and not ply:HasWeapon(row.weapon) then
                    ply:Give(row.weapon)
                end
            end
        end)
    end

    hook.Add("PlayerSpawn", "PermaWeaponsSpawn", GivePermaWeapons)
    hook.Add("OnPlayerChangedTeam", "PermaWeaponsJobCheck", function(ply)
        timer.Simple(0, function()
            if IsValid(ply) then
                GivePermaWeapons(ply)
            end
        end)
    end)

end
