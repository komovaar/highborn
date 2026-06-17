prop.characters = prop.characters or {}

prop.characters.schemaVersion = 1

function prop.characters.initDatabase()
    local q = [[
        create table if not exists characters (
            id text primary key,
            sid64 text not null,
            data text default '{}'
        );
    ]]

    local res = sql.Query(q)
    if res == false then
        error("[prop] Character database error: " .. sql.LastError())
    end
end

local function makeCharacterID(ply)
    return string.format("%s:%d:%d", ply:SteamID64(), os.time(), math.random(100000, 999999))
end

local function normalizeCID(cid)
    cid = tonumber(cid)
    if not cid then return nil end

    cid = math.floor(cid)
    if cid < 0 or cid > 9999 then return nil end

    return string.format("%04d", cid)
end

local function getUsedCIDs(exceptID)
    local used = {}
    local res = prop.db.query("select id, data from characters")
    if not res then return used end

    for _, row in ipairs(res) do
        if row.id ~= exceptID then
            local data = util.JSONToTable(row.data)
            local cid = data and normalizeCID(data.cid)
            if cid then
                used[cid] = true
            end
        end
    end

    return used
end

function prop.characters.generateCID(exceptID)
    local used = getUsedCIDs(exceptID)

    for _ = 1, 100 do
        local cid = string.format("%04d", math.random(0, 9999))
        if not used[cid] then return cid end
    end

    for i = 0, 9999 do
        local cid = string.format("%04d", i)
        if not used[cid] then return cid end
    end

    return nil, "cid_pool_exhausted"
end

local function normalizeCallsign(callsign)
    if not isstring(callsign) then return nil end

    callsign = string.Trim(callsign)
    if callsign == "" then return nil end
    if #callsign > 32 then callsign = string.sub(callsign, 1, 32) end

    return callsign
end

local function defaultCharacterData(ply, overrides)
    local teamKey = prop.data.get(ply, "team_key", "CloneRecruit")
    overrides = istable(overrides) and overrides or {}

    return {
        schema_version = prop.characters.schemaVersion,
        cid = prop.characters.generateCID(),
        callsign = normalizeCallsign(overrides.callsign) or prop.config.defaultCallsign,
        name = isstring(overrides.name) and string.Trim(overrides.name) ~= "" and string.Trim(overrides.name) or prop.config.defaultCharacterName,
        team_key = teamKey,
        money = prop.config.startingMoney,
        level = 1,
        xp = 0,
        arrested = false,
        arrested_until = 0,
        arrested_by = "",
        created_at = os.time(),
        last_seen = os.time()
    }
end

function prop.characters.normalize(data, ply, characterID)
    if not istable(data) then data = {} end

    data.schema_version = prop.characters.schemaVersion
    data.cid = normalizeCID(data.cid) or prop.characters.generateCID(characterID)
    data.callsign = normalizeCallsign(data.callsign) or prop.config.defaultCallsign
    data.name = isstring(data.name) and data.name ~= "" and data.name or prop.config.defaultCharacterName
    data.team_key = isstring(data.team_key) and data.team_key ~= "" and data.team_key or prop.data.get(ply, "team_key", "CloneRecruit")
    data.money = tonumber(data.money) or prop.config.startingMoney
    data.level = math.max(1, math.floor(tonumber(data.level) or 1))
    data.xp = math.max(0, math.floor(tonumber(data.xp) or 0))
    data.arrested = data.arrested == true
    data.arrested_until = math.max(0, math.floor(tonumber(data.arrested_until) or 0))
    data.arrested_by = isstring(data.arrested_by) and data.arrested_by or ""
    data.created_at = tonumber(data.created_at) or os.time()
    data.last_seen = tonumber(data.last_seen) or os.time()

    return data
end

function prop.characters.create(ply, overrides)
    if not IsValid(ply) or not ply.prop then return false, "invalid_player" end

    local id = makeCharacterID(ply)
    local data = defaultCharacterData(ply, overrides)
    if not data.cid then return false, "cid_pool_exhausted" end

    local res = prop.db.query(string.format(
        "insert into characters (id, sid64, data) values (%s, %s, %s)",
        sql.SQLStr(id),
        sql.SQLStr(ply:SteamID64()),
        sql.SQLStr(util.TableToJSON(data))
    ))
    if res == false then return false, "insert_failed" end

    return {
        id = id,
        sid64 = ply:SteamID64(),
        data = data
    }
end

function prop.characters.createDefault(ply)
    local character, reason = prop.characters.create(ply)
    if not character then return false, reason end

    prop.data.set(ply, "active_character_id", character.id)
    prop.data.save(ply)
    return character
end

function prop.characters.loadByID(ply, id)
    if not IsValid(ply) or not isstring(id) or id == "" then return nil end

    local res = prop.db.query(string.format(
        "select data from characters where id = %s and sid64 = %s limit 1",
        sql.SQLStr(id),
        sql.SQLStr(ply:SteamID64())
    ))

    if not res or not res[1] then return nil end

    return {
        id = id,
        sid64 = ply:SteamID64(),
        data = prop.characters.normalize(util.JSONToTable(res[1].data), ply, id)
    }
end

function prop.characters.list(ply)
    if not IsValid(ply) then return {} end

    local res = prop.db.query("select id, data from characters where sid64 = " .. sql.SQLStr(ply:SteamID64()))
    if not res then return {} end

    local characters = {}
    for _, row in ipairs(res) do
        table.insert(characters, {
            id = row.id,
            sid64 = ply:SteamID64(),
            data = prop.characters.normalize(util.JSONToTable(row.data), ply, row.id)
        })
    end

    table.sort(characters, function(a, b)
        return tostring(a.data.cid or "") < tostring(b.data.cid or "")
    end)

    return characters
end

function prop.characters.findOwned(ply, query)
    if not IsValid(ply) or not isstring(query) or query == "" then return nil end

    local normalizedQuery = string.lower(string.Trim(query))
    for _, character in ipairs(prop.characters.list(ply)) do
        if string.lower(character.id) == normalizedQuery
            or string.lower(tostring(character.data.cid or "")) == normalizedQuery
            or string.lower(tostring(character.data.callsign or "")) == normalizedQuery then
            return character
        end
    end

    return nil
end

function prop.characters.setActive(ply, characterID)
    if not IsValid(ply) or not ply.prop then return false, "invalid_player" end

    local character = prop.characters.loadByID(ply, characterID)
    if not character then return false, "character_not_found" end

    prop.characters.save(ply)
    prop.data.set(ply, "active_character_id", character.id)
    prop.data.save(ply)
    ply.propCharacter = character

    local job = prop.team.getByKey(character.data.team_key) or prop.team.getDefault()
    if job then
        character.data.team_key = job.key or character.data.team_key
        prop.team.apply(ply, job.id)
    else
        ply:Spawn()
    end

    prop.characters.save(ply)
    hook.Run("prop.CharacterSwitched", ply, character)

    return true, character
end

function prop.characters.loadActive(ply)
    if not IsValid(ply) or not ply.prop then return false, "invalid_player" end

    local id = prop.data.get(ply, "active_character_id")
    local character = prop.characters.loadByID(ply, id)

    if not character then
        character = prop.characters.createDefault(ply)
    end
    if not character then return false, "create_failed" end

    ply.propCharacter = character

    local job = prop.team.getByKey(character.data.team_key) or prop.team.getDefault()
    if job then
        character.data.team_key = job.key or character.data.team_key
        prop.team.apply(ply, job.id, true)
    end

    prop.characters.save(ply)

    hook.Run("prop.CharacterLoaded", ply, character)

    return character
end

function prop.characters.getActive(ply)
    if not IsValid(ply) then return nil end
    return ply.propCharacter
end

function prop.characters.save(ply)
    local character = prop.characters.getActive(ply)
    if not character then return false, "no_character" end

    character.data.last_seen = os.time()

    local res = prop.db.query(string.format(
        "update characters set data = %s where id = %s and sid64 = %s",
        sql.SQLStr(util.TableToJSON(character.data)),
        sql.SQLStr(character.id),
        sql.SQLStr(character.sid64)
    ))
    if res == false then return false, "update_failed" end

    hook.Run("prop.CharacterSaved", ply, character)
    return true
end

function prop.characters.setCallsign(ply, callsign, actor)
    local character = prop.characters.getActive(ply)
    if not character then return false, "no_character" end

    callsign = normalizeCallsign(callsign)
    if not callsign then return false, "invalid_callsign" end

    local oldCallsign = character.data.callsign
    if oldCallsign == callsign then return false, "unchanged" end

    character.data.callsign = callsign

    local ok, saveReason = prop.characters.save(ply)
    if not ok then return false, saveReason end

    hook.Run("prop.CharacterCallsignChanged", actor, ply, character, oldCallsign, callsign)
    return true
end

prop.characters.initDatabase()

hook.Add("prop.PlayerInitialSpawn", "prop.LoadActiveCharacter", function(ply)
    prop.characters.loadActive(ply)
end)

hook.Add("prop.PlayerDisconnected", "prop.SaveActiveCharacter", function(ply)
    prop.characters.save(ply)
end)

hook.Add("prop.PlayerTeamChanged", "prop.SyncCharacterTeam", function(ply, oldTeamID, teamID, oldJob, job)
    local character = prop.characters.getActive(ply)
    if not character or not job then return end

    character.data.team_key = job.key or character.data.team_key
    prop.characters.save(ply)
end)
