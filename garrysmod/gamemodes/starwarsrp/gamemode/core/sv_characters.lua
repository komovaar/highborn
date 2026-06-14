SWRP.Character = SWRP.Character or {}

SWRP.Character.SchemaVersion = 1

function SWRP.Character.InitDatabase()
    local q = [[
        create table if not exists swrp_characters (
            id text primary key,
            sid64 text not null,
            data text default '{}'
        );
    ]]

    local res = sql.Query(q)
    if res == false then
        error("[SWRP] Character database error: " .. sql.LastError())
    end
end

local function makeCharacterID(ply)
    return string.format("%s:%d:%d", ply:SteamID64(), os.time(), math.random(100000, 999999))
end

local function defaultCharacterData(ply)
    local teamKey = prop.data.get(ply, "team_key", "CloneRecruit")

    return {
        schema_version = SWRP.Character.SchemaVersion,
        name = SWRP.Config.DefaultCharacterName,
        team_key = teamKey,
        money = SWRP.Config.StartingMoney,
        level = 1,
        xp = 0,
        arrested = false,
        created_at = os.time(),
        last_seen = os.time()
    }
end

function SWRP.Character.Normalize(data, ply)
    if not istable(data) then data = {} end

    data.schema_version = SWRP.Character.SchemaVersion
    data.name = isstring(data.name) and data.name ~= "" and data.name or SWRP.Config.DefaultCharacterName
    data.team_key = isstring(data.team_key) and data.team_key ~= "" and data.team_key or prop.data.get(ply, "team_key", "CloneRecruit")
    data.money = tonumber(data.money) or SWRP.Config.StartingMoney
    data.level = math.max(1, math.floor(tonumber(data.level) or 1))
    data.xp = math.max(0, math.floor(tonumber(data.xp) or 0))
    data.arrested = data.arrested == true
    data.created_at = tonumber(data.created_at) or os.time()
    data.last_seen = tonumber(data.last_seen) or os.time()

    return data
end

function SWRP.Character.CreateDefault(ply)
    if not IsValid(ply) or not ply.prop then return false, "invalid_player" end

    local id = makeCharacterID(ply)
    local data = defaultCharacterData(ply)

    local res = prop.db.query(string.format(
        "insert into swrp_characters (id, sid64, data) values (%s, %s, %s)",
        sql.SQLStr(id),
        sql.SQLStr(ply:SteamID64()),
        sql.SQLStr(util.TableToJSON(data))
    ))
    if res == false then return false, "insert_failed" end

    prop.data.set(ply, "active_character_id", id)

    return {
        id = id,
        sid64 = ply:SteamID64(),
        data = data
    }
end

function SWRP.Character.LoadByID(ply, id)
    if not IsValid(ply) or not isstring(id) or id == "" then return nil end

    local res = prop.db.query(string.format(
        "select data from swrp_characters where id = %s and sid64 = %s limit 1",
        sql.SQLStr(id),
        sql.SQLStr(ply:SteamID64())
    ))

    if not res or not res[1] then return nil end

    return {
        id = id,
        sid64 = ply:SteamID64(),
        data = SWRP.Character.Normalize(util.JSONToTable(res[1].data), ply)
    }
end

function SWRP.Character.LoadActive(ply)
    if not IsValid(ply) or not ply.prop then return false, "invalid_player" end

    local id = prop.data.get(ply, "active_character_id")
    local character = SWRP.Character.LoadByID(ply, id)

    if not character then
        character = SWRP.Character.CreateDefault(ply)
    end
    if not character then return false, "create_failed" end

    ply.SWRPCharacter = character

    local job = prop.team.getByKey(character.data.team_key) or prop.team.getDefault()
    if job then
        character.data.team_key = job.key or character.data.team_key
        prop.team.apply(ply, job.id, true)
    end

    hook.Run("SWRP.CharacterLoaded", ply, character)

    return character
end

function SWRP.Character.GetActive(ply)
    if not IsValid(ply) then return nil end
    return ply.SWRPCharacter
end

function SWRP.Character.Save(ply)
    local character = SWRP.Character.GetActive(ply)
    if not character then return false, "no_character" end

    character.data.last_seen = os.time()

    local res = prop.db.query(string.format(
        "update swrp_characters set data = %s where id = %s and sid64 = %s",
        sql.SQLStr(util.TableToJSON(character.data)),
        sql.SQLStr(character.id),
        sql.SQLStr(character.sid64)
    ))
    if res == false then return false, "update_failed" end

    hook.Run("SWRP.CharacterSaved", ply, character)
    return true
end

SWRP.Character.InitDatabase()

hook.Add("prop.PlayerInitialSpawn", "SWRP.LoadActiveCharacter", function(ply)
    SWRP.Character.LoadActive(ply)
end)

hook.Add("prop.PlayerDisconnected", "SWRP.SaveActiveCharacter", function(ply)
    SWRP.Character.Save(ply)
end)

hook.Add("prop.PlayerTeamChanged", "SWRP.SyncCharacterTeam", function(ply, oldTeamID, teamID, oldJob, job)
    local character = SWRP.Character.GetActive(ply)
    if not character or not job then return end

    character.data.team_key = job.key or character.data.team_key
    SWRP.Character.Save(ply)
end)
