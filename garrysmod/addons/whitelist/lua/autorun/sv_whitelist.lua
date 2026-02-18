if SERVER then

    -- Список оружия для стэнстика
    local stunstick_weapons = {"stunstick", "unarrest_stick", "arrest_stick"}

    -- Списки техники
    local HeavyAir = {
        ["lvs_repulsorlift_dropship"] = true,
        ["lvs_repulsorlift_gunship"]   = true,
    }

    local LightAir = {
        ["lvs_starfighter_vwing"] = true,
        ["lvs_starfighter_arc170"] = true,
    }

    local HeavyGround = {
        ["lvs_fakehover_iftx"] = true,
        ["lvs_walker_atte"] = true,
    }

    local LightGround = {
        ["lvs_fakehover_barc"] = true,
        ["lvs_fakehover_barc_medical"] = true,
    }

    -- Создание таблицы whitelist при старте сервера
    local function CreateWhitelistTable()
        local query = sql.Query([[
            CREATE TABLE IF NOT EXISTS highborn_whitelist(
                steamid TEXT,
                job INT,
                rank TEXT CHECK(LENGTH(rank) <= 12),
                can_stunstick INT DEFAULT 0,
                can_ground_light INT DEFAULT 0,
                can_ground_heavy INT DEFAULT 0,
                can_air_light INT DEFAULT 0,
                can_air_heavy INT DEFAULT 0
               )
        ]])
        if query == false then
            ErrorNoHaltWithStack(sql.LastError())
        else
            print("[Highborn] Whitelist table ensured.")
        end
    end
    hook.Add("Initialize", "HighbornWhitelistInit", CreateWhitelistTable)

    -- Добавляем сетевые строки
    util.AddNetworkString("highborn_whitelist_set")
    util.AddNetworkString("highborn_whitelist_get")

    -- Функция выдачи оружия стэнстика
    local function GiveStunstick(ply)
        for _, swep in ipairs(stunstick_weapons) do
            ply:Give(swep)
        end
    end

    -- Автоматическая установка данных игроку при заходе
    hook.Add("PlayerLoadout", "highborn_whitelist_autojob", function(ply)
        if ply._WhitelistApplied then return end
        ply._WhitelistApplied = true

        local row = sql.QueryRow(
            "SELECT job, can_stunstick, rank, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
        )

        -- Если записи нет — создаём стандартную
        if not row then 
            sql.Query("INSERT INTO highborn_whitelist(steamid, job, rank, can_stunstick) VALUES(" 
                .. sql.SQLStr(ply:SteamID()) .. ", " 
                .. sql.SQLStr("1") .. ", " 
                .. sql.SQLStr("TRP") .. ", " 
                .. sql.SQLStr("0") .. ")"
            )
            row = sql.QueryRow(
                "SELECT job, can_stunstick, rank, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
            )
        end

        -- Устанавливаем сетевые значения
        ply:SetNWString("HighbornRank", row.rank or "")
        ply:SetNWBool("HighbornCanGL", tonumber(row.can_ground_light) == 1)
        ply:SetNWBool("HighbornCanGH", tonumber(row.can_ground_heavy) == 1)
        ply:SetNWBool("HighbornCanAL", tonumber(row.can_air_light) == 1)
        ply:SetNWBool("HighbornCanAH", tonumber(row.can_air_heavy) == 1)

        -- Устанавливаем команду
        local jobID = tonumber(row.job)
        if jobID and ply:Team() ~= jobID then
            ply:changeTeam(jobID, true, true)
        end

        -- Выдаём стэнстик, если разрешено
        if tonumber(row.can_stunstick) == 1 then
            GiveStunstick(ply)
        end
    end)

    -- Получение whitelist данных
    net.Receive("highborn_whitelist_get", function(len, ply)
        if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
        local steamid = net.ReadString()

        if not (steamid:find("^STEAM_%d:%d:%d+$")) then
            DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
            return
        end

        local row = sql.QueryRow(
            "SELECT job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM highborn_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
        )
        if not row then return end

        net.Start("highborn_whitelist_get")
            net.WriteString(steamid)
            net.WriteInt(tonumber(row.job), 17)
            net.WriteString(row.rank)
            net.WriteBool(tonumber(row.can_stunstick) == 1)
            net.WriteBool(tonumber(row.can_ground_light) == 1)
            net.WriteBool(tonumber(row.can_ground_heavy) == 1)
            net.WriteBool(tonumber(row.can_air_light) == 1)
            net.WriteBool(tonumber(row.can_air_heavy) == 1)
        net.Send(ply)
    end)

    -- Установка whitelist данных
    net.Receive("highborn_whitelist_set", function(len, ply)
        if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end
        local steamid = net.ReadString()
        if not (steamid:find("^STEAM_%d:%d:%d+$")) then
            DarkRP.notify(ply, 1, 5, "You didn't send a valid SteamID!")
            return
        end

        local job = net.ReadInt(17)
        local rank = net.ReadString()
        local can_stunstick = net.ReadInt(11)
        local canGL = net.ReadBool() and 1 or 0
        local canGH = net.ReadBool() and 1 or 0
        local canAL = net.ReadBool() and 1 or 0
        local canAH = net.ReadBool() and 1 or 0
        local spawn = net.ReadBool()

        -- Удаляем старую запись
        sql.Query("DELETE FROM highborn_whitelist WHERE steamid = "..sql.SQLStr(steamid))

        -- Вставляем новую
        sql.Query("INSERT INTO highborn_whitelist(steamid, job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy) VALUES("
            .. sql.SQLStr(steamid) .. ", "
            .. sql.SQLStr(job) .. ", "
            .. sql.SQLStr(rank) .. ", "
            .. sql.SQLStr(can_stunstick) .. ", "
            .. sql.SQLStr(canGL) .. ", "
            .. sql.SQLStr(canGH) .. ", "
            .. sql.SQLStr(canAL) .. ", "
            .. sql.SQLStr(canAH) .. ")"
        )

        -- Применяем игроку, если онлайн
        for _, v in pairs(player.GetAll()) do
            if v:SteamID() == steamid then
                v:SetNWString("HighbornRank", rank)
                v:SetNWBool("HighbornCanGL", canGL == 1)
                v:SetNWBool("HighbornCanGH", canGH == 1)
                v:SetNWBool("HighbornCanAL", canAL == 1)
                v:SetNWBool("HighbornCanAH", canAH == 1)
                
                v:changeTeam(job, true, true)

                if can_stunstick == 1 then
                    GiveStunstick(v)
                end

                if spawn then v:Spawn() end
                break
            end
        end
    end)

hook.Add("LVS.CanPlayerDrive", "HighbornWhitelistDrive", function(ply, vehicle)

    if not IsValid(vehicle) then return end

    local class = vehicle:GetClass()

    if HeavyAir[class] and not ply:GetNWBool("HighbornCanAH", false) then
        DarkRP.notify(ply, 1, 4, "Ви не можете керувати важким літальним транспортом.")
        return false
    elseif LightAir[class] and not ply:GetNWBool("HighbornCanAL", false) then
        DarkRP.notify(ply, 1, 4, "Ви не можете керувати легким літальним транспортом.")
        return false
    elseif HeavyGround[class] and not ply:GetNWBool("HighbornCanGH", false) then
        DarkRP.notify(ply, 1, 4, "Ви не можете керувати важким наземним транспортом.")
        return false
    elseif LightGround[class] and not ply:GetNWBool("HighbornCanGL", false) then
        DarkRP.notify(ply, 1, 4, "Ви не можете керувати легким наземним транспортом.")
        return false
    end

end)


end
