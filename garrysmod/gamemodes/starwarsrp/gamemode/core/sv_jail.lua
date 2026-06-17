prop.jail = prop.jail or {}

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

local function moveToJail(ply)
    if not IsValid(ply) then return false, "invalid_player" end
    if not isvector or not isvector(prop.config.jailPosition) then return false, "no_jail_position" end

    ply:SetPos(prop.config.jailPosition)
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

    character.data.arrested = true
    character.data.arrested_until = duration > 0 and os.time() + duration or 0
    character.data.arrested_by = getActorID(actor)

    local ok, saveReason = prop.characters.save(target)
    if not ok then return false, saveReason end

    target:StripWeapons()
    moveToJail(target)

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

local function normalize(value)
    if not isstring(value) then return "" end
    return string.lower(string.Trim(value))
end

local function findPlayer(caller, query)
    query = normalize(query)
    if query == "" then return nil, "missing_player" end
    if query == "me" then return caller end

    local userID = tonumber(query)
    if userID then
        local ply = Player(userID)
        if IsValid(ply) then return ply end
    end

    for _, ply in ipairs(player.GetAll()) do
        if normalize(ply:SteamID()) == query or normalize(ply:SteamID64()) == query then
            return ply
        end
    end

    local matches = {}

    for _, ply in ipairs(player.GetAll()) do
        if string.find(normalize(ply:Nick()), query, 1, true) then
            table.insert(matches, ply)
        end
    end

    if #matches == 1 then return matches[1] end
    if #matches > 1 then return nil, "multiple_players" end

    return nil, "player_not_found"
end

prop.command.add("jail", {
    description = "Arrests a player. Temporary development command.",
    usage = "/jail <player|me> [seconds]",
    category = "Debug",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local duration = normalizeDuration(args[2])
        local ok, reason = prop.jail.arrest(ply, target, duration, "dev_jail")
        if not ok then return false, reason end

        return true, string.format("[prop] Arrested %s for %d seconds.", target:Nick(), duration)
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

        local target, targetReason = findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local ok, reason = prop.jail.release(ply, target, "dev_unjail")
        if not ok then return false, reason end

        return true, string.format("[prop] Released %s.", target:Nick())
    end
})
