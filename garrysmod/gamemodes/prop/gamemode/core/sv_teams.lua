local BaseGamemode = baseclass.Get("gamemode_base")

local function callBaseGamemode(name, ...)
    local fn = BaseGamemode and BaseGamemode[name]
    if isfunction(fn) then return fn(...) end
end

function prop.team.apply(ply, teamID, noSpawn)
    if not IsValid(ply) then return false, "invalid_player" end

    teamID = tonumber(teamID)
    local job = prop.team.get(teamID)
    if not job then return false, "invalid_team" end

    ply:SetTeam(teamID)

    if ply.prop then
        prop.data.setPublic(ply, "team_id", teamID)
        if job.key then
            prop.data.setPublic(ply, "team_key", job.key)
        else
            prop.data.setPublic(ply, "team_key", nil)
        end
        prop.data.setPublic(ply, "job_name", job.name)
    end

    if not noSpawn then
        ply:Spawn()
    end

    return true
end

function prop.team.set(ply, teamID)
    if not IsValid(ply) then return false, "invalid_player" end

    teamID = tonumber(teamID)
    local job = prop.team.get(teamID)
    if not job then return false, "invalid_team" end

    local oldTeamID = ply:Team()
    if oldTeamID == teamID then return false, "unchanged" end

    local oldJob = prop.team.get(oldTeamID)

    if job.adminOnly and not ply:IsAdmin() then
        return false, "admin_only"
    end

    local canChange, reason = hook.Run("prop.CanPlayerChangeTeam", ply, oldTeamID, teamID, oldJob, job)
    if canChange == false then return false, reason or "blocked" end

    if isfunction(job.onCanChange) then
        local success
        success, canChange, reason = prop.safeCall("team.onCanChange:" .. job.name, job.onCanChange, ply, oldTeamID, teamID, oldJob, job)
        if not success then return false, "callback_error" end
        if canChange == false then return false, reason or "blocked" end
    end

    local ok, applyReason = prop.team.apply(ply, teamID)
    if not ok then return false, applyReason end

    if isfunction(job.onChanged) then
        prop.safeCall("team.onChanged:" .. job.name, job.onChanged, ply, oldTeamID, teamID, oldJob, job)
    end

    hook.Run("prop.PlayerTeamChanged", ply, oldTeamID, teamID, oldJob, job)
    return true
end

function prop.team.assignDefault(ply, noSpawn)
    local defaultID = prop.team.getDefaultID()
    if not defaultID then return false, "no_default_team" end

    return prop.team.apply(ply, defaultID, noSpawn)
end

function prop.team.restore(ply)
    if not IsValid(ply) then return false, "invalid_player" end
    if not ply.prop then return false, "no_data" end

    local savedTeamKey = prop.data.get(ply, "team_key")
    local savedJob = prop.team.getByKey(savedTeamKey)
    if savedJob then
        return prop.team.apply(ply, savedJob.id, true)
    end
    if savedTeamKey ~= nil then
        return prop.team.assignDefault(ply, true)
    end

    local savedTeamID = prop.data.get(ply, "team_id")
    if savedTeamID and prop.team.get(savedTeamID) then
        return prop.team.apply(ply, savedTeamID, true)
    end

    return prop.team.assignDefault(ply, true)
end

function GM:PlayerLoadout(ply)
    local job = prop.team.get(ply:Team())
    if not job then return callBaseGamemode("PlayerLoadout", self, ply) end

    ply:StripWeapons()
    for _, wep in ipairs(job.weapons) do
        ply:Give(wep)
    end

    hook.Run("prop.PlayerLoadout", ply, job)
    return true
end

function GM:PlayerSetModel(ply)
    local job = prop.team.get(ply:Team())
    if job and job.model then
        ply:SetModel(istable(job.model) and table.Random(job.model) or job.model)
    else
        callBaseGamemode("PlayerSetModel", self, ply)
    end

    hook.Run("prop.PlayerSetModel", ply, job)
end

function GM:PlayerSpawn(ply, transition)
    callBaseGamemode("PlayerSpawn", self, ply, transition)

    local job = prop.team.get(ply:Team())
    if job and isfunction(job.onSpawn) then
        prop.safeCall("team.onSpawn:" .. job.name, job.onSpawn, ply)
    end

    hook.Run("prop.PlayerSpawn", ply, transition, job)
end
