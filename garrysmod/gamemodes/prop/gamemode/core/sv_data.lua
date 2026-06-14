prop.data = prop.data or {}

function prop.data.load(ply)
    if not IsValid(ply) then return false, "invalid_player" end

    local sid64 = ply:SteamID64()
    local res = prop.db.query("select data from prop_players where sid64 = " .. sql.SQLStr(sid64))

    if res and res[1] then
        ply.prop = util.JSONToTable(res[1].data) or {}
        prop.log("Loaded data for " .. ply:Nick())
    else
        ply.prop = {first_joined = os.time()}

        local json = util.TableToJSON(ply.prop)

        prop.db.query(string.format(
            "insert into prop_players (sid64, data) values (%s, %s)",
            sql.SQLStr(sid64),
            sql.SQLStr(json)
        ))
        prop.log("Create new record for " .. ply:Nick())
    end

    ply.propPublic = {}

    hook.Run("prop.PlayerDataLoaded", ply, ply.prop)
    return true
end

function prop.data.save(ply)
    if not IsValid(ply) then return false, "invalid_player" end
    if not ply.prop then return false, "no_data" end

    local sid64 = ply:SteamID64()
    local json = util.TableToJSON(ply.prop)

    prop.db.query(string.format(
        "update prop_players set data = %s where sid64 = %s",
        sql.SQLStr(json),
        sql.SQLStr(sid64)
    ))

    hook.Run("prop.PlayerDataSaved", ply, ply.prop)
    return true
end

function prop.data.saveAll()
    for _, ply in ipairs(player.GetAll()) do
        prop.data.save(ply)
    end

    hook.Run("prop.PlayerDataSavedAll")
    return true
end

function prop.data.get(ply, key, default)
    if not IsValid(ply) or not ply.prop then return default end

    local value = ply.prop[key]
    if value == nil then return default end

    return value
end

function prop.data.set(ply, key, value)
    if not IsValid(ply) then return false, "invalid_player" end
    if not ply.prop then return false, "no_data" end

    local oldValue = ply.prop[key]
    if oldValue == value then return false, "unchanged" end

    ply.prop[key] = value

    hook.Run("prop.PlayerDataChanged", ply, key, oldValue, value)

    return true
end

function prop.data.isPublic(ply, key)
    if not IsValid(ply) or not ply.propPublic then return false end

    return ply.propPublic[key] == true
end

function prop.data.markPublic(ply, key)
    if not IsValid(ply) then return false, "invalid_player" end
    if not ply.prop then return false, "no_data" end

    ply.propPublic = ply.propPublic or {}
    ply.propPublic[key] = true

    return true
end

function prop.data.setPublic(ply, key, value)
    if not prop.net.isValidKey(key) then return false, "invalid_key" end

    local canWrite, writeReason = prop.net.canWriteValue(value)
    if not canWrite then return false, writeReason end

    local wasPublic = prop.data.isPublic(ply, key)
    local ok, reason = prop.data.set(ply, key, value)

    if not ok and reason ~= "unchanged" then return false, reason end

    prop.data.markPublic(ply, key)

    if ok or not wasPublic then
        return prop.data.sync(ply, key, value)
    end

    return true
end

function prop.data.syncPublic(ply, key)
    if not prop.data.isPublic(ply, key) then return false, "private_key" end

    prop.data.sync(ply, key, prop.data.get(ply, key))
    return true
end

function prop.data.syncPublicAll(ply)
    if not IsValid(ply) or not ply.propPublic then return false, "invalid_player" end

    for key in pairs(ply.propPublic) do
        prop.data.syncPublic(ply, key)
    end

    return true
end

function GM:PlayerInitialSpawn(ply)
    prop.data.load(ply)

    prop.team.restore(ply)

    prop.data.syncPublicAll(ply)

    self.BaseClass.PlayerInitialSpawn(self, ply)
    hook.Run("prop.PlayerInitialSpawn", ply)
end

function GM:PlayerDisconnected(ply)
    prop.data.save(ply)
    hook.Run("prop.PlayerDisconnected", ply)
    self.BaseClass.PlayerDisconnected(self, ply)
end

timer.Create("prop.DataAutosave", prop.config.get("dataAutosaveInterval", 300), 0, function()
    prop.data.saveAll()
end)
