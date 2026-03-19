if SERVER then
    hook.Add("Initialize", "Highborn_TransferToNewTable", function()
        -- Створюємо нову таблицю з UNIQUE
        sql.Query([[
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

        -- Беремо всі записи зі старої таблиці
        local rows = sql.Query("SELECT * FROM highborn_whitelist")
        if not rows then
            print("[Highborn] Стара таблиця порожня або не існує.")
            return
        end

        for _, row in ipairs(rows) do
            local query = "INSERT OR REPLACE INTO highborn_whitelist_new(" ..
                "steamid, job, rank, can_stunstick, can_ground_light, can_ground_heavy, can_air_light, can_air_heavy" ..
                ") VALUES (" ..
                sql.SQLStr(row.steamid) .. ", " ..
                (row.job or 0) .. ", " ..
                sql.SQLStr(row.rank or "") .. ", " ..
                (row.can_stunstick or 0) .. ", " ..
                (row.can_ground_light or 0) .. ", " ..
                (row.can_ground_heavy or 0) .. ", " ..
                (row.can_air_light or 0) .. ", " ..
                (row.can_air_heavy or 0) ..
                ")"
            sql.Query(query)
        end

        print("[Highborn] Перенесення даних завершено.")
    end)
end