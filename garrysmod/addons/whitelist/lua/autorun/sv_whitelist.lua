if SERVER then

    -- Список оружия для стэнстика
    local stunstick_weapons = {"stunstick", "unarrest_stick", "arrest_stick", "weapon_cuff_elastic"}

    -- Списки техники
    local HeavyAir = {
        ["lvs_repulsorlift_dropship"] = true,
        ["lvs_repulsorlift_gunship"]   = true,
        ["lvs_nuclass_attack_shuttle"] = true,
        ["lvs_nuclass_attack_shuttle_medical_2"] = true,
        ["lvs_nuclass_attack_shuttle_medical"] = true,
        ["lvs_nuclass_attack_shuttle_republic_2"] = true,
        ["lvs_nuclass_attack_shuttle_republic"] = true,
        ["lvs_nuclass_attack_shuttle_imp"] = true,
    }

    local LightAir = {
        ["lvs_starfighter_vwing"] = true,
        ["lvs_starfighter_arc170"] = true,
        ["lvs_starfighter_v19"] = true,
    }

    local HeavyGround = {
        ["lvs_walker_atte"] = true,
        ["lvs_tx130_t"] = true,
    }

    local LightGround = {
        ["lvs_fakehover_barc"] = true,
        ["lvs_fakehover_barc_medical"] = true,
        ["lvs_fakehover_iftx"] = true,
        ["lvs_atrt"] = true,
        ["lvs_fakehover_ck6_swoop"] = true,
        ["lvs_sw_transport"] = true,
    }

    -- Создание таблицы whitelist при старте сервера
    local function CreateWhitelistTable()
        local query = sql.Query([[
            CREATE TABLE IF NOT EXISTS hb_whitelist(
                steamid TEXT UNIQUE,
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
    local function FindPlayerBySteamID(steamid)
        for _, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamid then return v end
        end
    end

    local function WhitelistJobName(job)
        job = tonumber(job) or 0
        return RPExtraTeams and RPExtraTeams[job] and RPExtraTeams[job].name or tostring(job)
    end

    local function WhitelistState(row)
        if not row then return "none" end

        return {
            job = WhitelistJobName(row.job),
            rank = tostring(row.rank or ""),
            stunstick = tonumber(row.can_stunstick) == 1,
            ground_light = tonumber(row.can_ground_light) == 1,
            ground_heavy = tonumber(row.can_ground_heavy) == 1,
            air_light = tonumber(row.can_air_light) == 1,
            air_heavy = tonumber(row.can_air_heavy) == 1,
        }
    end

    hook.Add("PlayerLoadout", "highborn_whitelist_autojob", function(ply)
        if ply._WhitelistApplied then return end
        ply._WhitelistApplied = true

        local row = sql.QueryRow(
            "SELECT job, can_stunstick, rank, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
        )
        if not row then 
            sql.Query("INSERT OR REPLACE INTO hb_whitelist(steamid, job, rank, can_stunstick) VALUES(" 
            .. sql.SQLStr(ply:SteamID()) .. ", " 
            .. sql.SQLStr("1") .. ", " 
            .. sql.SQLStr("CDT") .. ", " 
            .. sql.SQLStr("0") .. ")"
        )
            row = sql.QueryRow(
                "SELECT job, can_stunstick, rank, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(ply:SteamID())
            )
        end

        ply:SetNWString("HighbornRank", row.rank or "")
        ply:SetNWBool("HighbornCanGL", tonumber(row.can_ground_light) == 1)
        ply:SetNWBool("HighbornCanGH", tonumber(row.can_ground_heavy) == 1)
        ply:SetNWBool("HighbornCanAL", tonumber(row.can_air_light) == 1)
        ply:SetNWBool("HighbornCanAH", tonumber(row.can_air_heavy) == 1)

        local jobID = tonumber(row.job)
        if jobID and ply:Team() ~= jobID then
            ply:changeTeam(jobID, true, true)
        end

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
            "SELECT job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
        )

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

    net.Receive("highborn_whitelist_set", function(len, ply)
        if not HIGHBORN_WHITELIST_ALLOWED_RANKS[ply:GetUserGroup()] then return end

        local steamid = net.ReadString()

        if not isstring(steamid) or not steamid:match("^STEAM_%d:%d:%d+$") then
            DarkRP.notify(ply, 1, 5, "Invalid SteamID!")
            print("[WHITELIST] Invalid SteamID:", steamid)
            return
        end

        local job = tonumber(net.ReadInt(17)) or 0
        local rank = net.ReadString() or ""

        local can_stunstick = tonumber(net.ReadInt(11)) or 0
        local canGL = net.ReadBool() and 1 or 0
        local canGH = net.ReadBool() and 1 or 0
        local canAL = net.ReadBool() and 1 or 0
        local canAH = net.ReadBool() and 1 or 0
        local spawn = net.ReadBool()
        local temporary = net.ReadBool()
        local whitelistSaved = temporary

        if not sql.TableExists("hb_whitelist") then
            print("[WHITELIST ERROR] Table does not exist!")
            return
        end

        local oldRow = sql.QueryRow(
            "SELECT job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy FROM hb_whitelist WHERE steamid = " .. sql.SQLStr(steamid)
        )
        local targetPly = FindPlayerBySteamID(steamid)
        local targetName = IsValid(targetPly) and targetPly:Nick() or "Offline"

        if not temporary then
            local query = "INSERT OR REPLACE INTO hb_whitelist(" ..
                "steamid, job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy" ..
                ") VALUES (" ..
                sql.SQLStr(steamid) .. ", " ..
                job .. ", " ..
                sql.SQLStr(rank) .. ", " ..
                can_stunstick .. ", " ..
                canGL .. ", " ..
                canGH .. ", " ..
                canAL .. ", " ..
                canAH ..
                ")"

            local result = sql.Query(query)

            if result == false then
                print("[WHITELIST SQL ERROR]", sql.LastError())
                print("[WHITELIST QUERY]", query)
            else
                print("[WHITELIST] Saved:", steamid)
                whitelistSaved = true
            end
        end

        if whitelistSaved and LuctusLog then
            local newRow = {
                job = job,
                rank = rank,
                can_stunstick = can_stunstick,
                can_ground_light = canGL,
                can_ground_heavy = canGH,
                can_air_light = canAL,
                can_air_heavy = canAH,
            }
            local logData = {
                admin_name = ply:Nick(),
                admin_steamid = ply:SteamID(),
                target_name = targetName,
                target_steamid = steamid,
                temporary = temporary,
                before = WhitelistState(oldRow),
                after = WhitelistState(newRow),
            }

            LuctusLog("Whitelist","HBWHITELIST "..util.TableToJSON(logData))
        end

        for _, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamid then
                v:SetNWString("HighbornRank", rank)
                v:SetNWBool("HighbornCanGL", canGL == 1)
                v:SetNWBool("HighbornCanGH", canGH == 1)
                v:SetNWBool("HighbornCanAL", canAL == 1)
                v:SetNWBool("HighbornCanAH", canAH == 1)

                if RPExtraTeams and RPExtraTeams[job] then
                    v:changeTeam(job, true, true)
                else
                    print("[WHITELIST WARNING] Invalid job:", job)
                end

                if can_stunstick == 1 then
                    if GiveStunstick then
                        GiveStunstick(v)
                    else
                        print("[WHITELIST WARNING] GiveStunstick function missing")
                    end
                end

                -- Респавн
                if spawn then
                    v:Spawn()
                end

                print("[WHITELIST] Applied to online player:", v:Nick())
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
