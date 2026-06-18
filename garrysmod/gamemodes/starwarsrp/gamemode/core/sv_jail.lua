prop.jail = prop.jail or {}

function prop.jail.initDatabase()
    local q = [[
        create table if not exists settings (
            key text primary key,
            data text default '{}'
        );
    ]]

    local res = sql.Query(q)
    if res == false then
        error("[prop] Settings database error: " .. sql.LastError())
    end
end

local function normalizeDuration(duration)
    duration = math.floor(tonumber(duration) or prop.config.jailDefaultDuration or 0)
    if duration <= 0 then return 0 end

    return duration
end

local function getCharacter(ply)
    if not IsValid(ply) then return nil, "invalid_player" end

    local character = prop.characters.getActive(ply)
    if not character then return nil, "no_character" end

    return character
end

local function getActorID(actor)
    if not IsValid(actor) or not actor:IsPlayer() then return "" end
    return actor:SteamID64()
end

local function isVector(value)
    return isvector and isvector(value)
end

local function serializePosition(position)
    return {
        x = position.x,
        y = position.y,
        z = position.z
    }
end

local function deserializePosition(data)
    if not istable(data) then return nil end

    local x = tonumber(data.x)
    local y = tonumber(data.y)
    local z = tonumber(data.z)
    if not x or not y or not z then return nil end

    return Vector(x, y, z)
end

function prop.jail.loadPositions()
    local res = prop.db.query("select data from settings where key = " .. sql.SQLStr("jail_positions") .. " limit 1")
    if not res or not res[1] then return false, "not_found" end

    local data = util.JSONToTable(res[1].data)
    if not istable(data) then return false, "invalid_data" end

    local positions = {}
    for _, rawPosition in ipairs(data) do
        local position = deserializePosition(rawPosition)
        if position then
            table.insert(positions, position)
        end
    end

    prop.config.jailPositions = positions
    prop.config.jailPosition = #positions == 1 and positions[1] or nil

    return true
end

function prop.jail.savePositions()
    local data = {}

    if istable(prop.config.jailPositions) then
        for _, position in ipairs(prop.config.jailPositions) do
            if isVector(position) then
                table.insert(data, serializePosition(position))
            end
        end
    end

    if #data == 0 and isVector(prop.config.jailPosition) then
        table.insert(data, serializePosition(prop.config.jailPosition))
    end

    local res = prop.db.query(string.format(
        "insert or replace into settings (key, data) values (%s, %s)",
        sql.SQLStr("jail_positions"),
        sql.SQLStr(util.TableToJSON(data))
    ))
    if res == false then return false, "save_failed" end

    return true
end

function prop.jail.addPosition(position)
    if not isVector(position) then return false, "invalid_position" end

    prop.config.jailPositions = istable(prop.config.jailPositions) and prop.config.jailPositions or {}
    table.insert(prop.config.jailPositions, position)

    if #prop.config.jailPositions == 1 then
        prop.config.jailPosition = position
    else
        prop.config.jailPosition = nil
    end

    return prop.jail.savePositions()
end

function prop.jail.clearPositions()
    prop.config.jailPositions = {}
    prop.config.jailPosition = nil

    return prop.jail.savePositions()
end

function prop.jail.getPositionCount()
    if istable(prop.config.jailPositions) and #prop.config.jailPositions > 0 then
        return #prop.config.jailPositions
    end

    return isVector(prop.config.jailPosition) and 1 or 0
end

function prop.jail.getPosition()
    if isVector(prop.config.jailPosition) then
        return prop.config.jailPosition
    end

    if not istable(prop.config.jailPositions) then return nil end

    local positions = {}
    for _, position in ipairs(prop.config.jailPositions) do
        if isVector(position) then
            table.insert(positions, position)
        end
    end

    if #positions == 0 then return nil end
    return table.Random(positions)
end

local function moveToJail(ply)
    if not IsValid(ply) then return false, "invalid_player" end

    local position = prop.jail.getPosition()
    if not position then return false, "no_jail_position" end

    ply:SetPos(position)
    return true
end

function prop.jail.isArrested(ply)
    local character = prop.characters.getActive(ply)
    return character and character.data.arrested == true or false
end

function prop.jail.getRemaining(ply)
    local character = prop.characters.getActive(ply)
    if not character or not character.data.arrested then return 0 end

    local untilTime = tonumber(character.data.arrested_until) or 0
    if untilTime <= 0 then return 0 end

    return math.max(0, untilTime - os.time())
end

function prop.jail.arrest(actor, target, duration, reason)
    if not IsValid(target) or not target:IsPlayer() then return false, "invalid_target" end

    local character, characterReason = getCharacter(target)
    if not character then return false, characterReason end

    duration = normalizeDuration(duration)

    local position = prop.jail.getPosition()
    if not position then return false, "no_jail_position" end

    character.data.arrested = true
    character.data.arrested_until = duration > 0 and os.time() + duration or 0
    character.data.arrested_by = getActorID(actor)

    local ok, saveReason = prop.characters.save(target)
    if not ok then return false, saveReason end

    target:StripWeapons()
    target:SetPos(position)

    hook.Run("prop.PlayerArrested", actor, target, duration, reason)
    return true
end

function prop.jail.release(actor, target, reason)
    if not IsValid(target) or not target:IsPlayer() then return false, "invalid_target" end

    local character, characterReason = getCharacter(target)
    if not character then return false, characterReason end
    if not character.data.arrested then return false, "not_arrested" end

    character.data.arrested = false
    character.data.arrested_until = 0
    character.data.arrested_by = ""

    local ok, saveReason = prop.characters.save(target)
    if not ok then return false, saveReason end

    target:Spawn()

    hook.Run("prop.PlayerReleased", actor, target, reason)
    return true
end

function prop.jail.checkExpired(ply)
    if not prop.jail.isArrested(ply) then return false, "not_arrested" end

    local remaining = prop.jail.getRemaining(ply)
    if remaining > 0 then return false, "still_arrested" end

    local character = prop.characters.getActive(ply)
    if character and tonumber(character.data.arrested_until) == 0 then return false, "no_expiry" end

    return prop.jail.release(nil, ply, "expired")
end

function prop.jail.checkAllExpired()
    for _, ply in ipairs(player.GetAll()) do
        prop.jail.checkExpired(ply)
    end
end

timer.Create("prop.JailExpiry", 1, 0, function()
    prop.jail.checkAllExpired()
end)

prop.jail.initDatabase()
prop.jail.loadPositions()

hook.Add("prop.PlayerSpawn", "prop.EnforceJailSpawn", function(ply)
    if not prop.jail.isArrested(ply) then return end

    timer.Simple(0, function()
        if not IsValid(ply) or not prop.jail.isArrested(ply) then return end

        ply:StripWeapons()
        moveToJail(ply)
    end)
end)

hook.Add("prop.PlayerLoadout", "prop.EnforceJailLoadout", function(ply)
    if prop.jail.isArrested(ply) then
        ply:StripWeapons()
    end
end)

prop.command.add("jail", {
    description = "Arrests a player. Temporary development command.",
    usage = "/jail <player|me> [seconds]",
    category = "Debug",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = prop.util.findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local duration = normalizeDuration(args[2])
        local ok, reason = prop.jail.arrest(ply, target, duration, "dev_jail")
        if not ok then return false, reason end

        return true, string.format("[prop] Arrested %s for %d seconds.", target:Nick(), duration)
    end
})

prop.command.add("addjailpos", {
    description = "Adds your current position as a jail position.",
    usage = "/addjailpos",
    category = "Debug",
    onRun = function(ply)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local ok, reason = prop.jail.addPosition(ply:GetPos())
        if not ok then return false, reason end

        return true, string.format("[prop] Added jail position #%d.", prop.jail.getPositionCount())
    end
})

prop.command.add("clearjailpos", {
    description = "Clears all jail positions.",
    usage = "/clearjailpos",
    category = "Debug",
    onRun = function(ply)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local ok, reason = prop.jail.clearPositions()
        if not ok then return false, reason end

        return true, "[prop] Cleared jail positions."
    end
})

prop.command.add("jailpos", {
    description = "Shows the jail position count.",
    usage = "/jailpos",
    category = "Debug",
    onRun = function(ply)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        return true, string.format("[prop] Jail positions: %d.", prop.jail.getPositionCount())
    end
})

prop.command.add("unjail", {
    description = "Releases an arrested player. Temporary development command.",
    usage = "/unjail <player|me>",
    category = "Debug",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = prop.util.findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local ok, reason = prop.jail.release(ply, target, "dev_unjail")
        if not ok then return false, reason end

        return true, string.format("[prop] Released %s.", target:Nick())
    end
})
