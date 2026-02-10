if SERVER then
    sql.Query([[
        CREATE TABLE IF NOT EXISTS perma_bodygroups (
            steamid TEXT,
            model TEXT,
            bg_key TEXT,
            bg_value INTEGER,
            PRIMARY KEY (steamid, model, bg_key)
        )
    ]])

    local function SetPermaBodygroup(ply)
        if not IsValid(ply) then return end


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
