SWRP = SWRP or {}
SWRP.Teams = {}
SWRP.JobFiles = SWRP.JobFiles or {
    "jobs/sh_republic.lua"
}

prop.team.list = {}
prop.team.byKey = {}
prop.team.defaultID = nil

function SWRP.RegisterJob(key, name, data)
    data.key = key

    local id, reason = prop.team.register(name, data)
    assert(id, "Failed to register " .. tostring(name) .. " team: " .. tostring(reason))

    SWRP.Teams[key] = id
    return id
end

local function includeJobFile(path)
    local fullPath = (SWRP.GamemodePath or "starwarsrp/gamemode/") .. path

    if SERVER then AddCSLuaFile(fullPath) end
    include(fullPath)
end

for _, path in ipairs(SWRP.JobFiles) do
    includeJobFile(path)
end
