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

local function findJob(query)
    query = normalize(query)
    if query == "" then return nil, "missing_job" end

    local teamID = tonumber(query)
    if teamID and prop.team.get(teamID) then return teamID end

    for key, id in pairs(SWRP.Teams) do
        if normalize(key) == query and prop.team.get(id) then
            return id
        end
    end

    local matches = {}

    for id, job in pairs(prop.team.all()) do
        if string.find(normalize(job.name), query, 1, true) then
            table.insert(matches, id)
        end
    end

    if #matches == 1 then return matches[1] end
    if #matches > 1 then return nil, "multiple_jobs" end

    return nil, "job_not_found"
end

prop.command.add("setjob", {
    description = "Sets a player's job. Temporary development command.",
    usage = "/setjob <player|me> <job id|key|name>",
    category = "Admin",
    onRun = function(ply, args)
        if not SWRP.CanUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local jobQuery = table.concat(args, " ", 2)
        local teamID, jobReason = findJob(jobQuery)
        if not teamID then return false, jobReason end

        local ok, reason = prop.team.set(target, teamID)
        if not ok and reason ~= "unchanged" then return false, reason end

        local job = prop.team.get(teamID)
        return true, string.format("[SWRP] Set %s to %s.", target:Nick(), job.name)
    end
})
