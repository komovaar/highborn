prop = prop or {}
prop.jobFiles = prop.jobFiles or {
    "jobs/sh_republic.lua"
}

prop.team.list = {}
prop.team.byKey = {}
prop.team.jobIDs = {}
prop.team.defaultID = nil

prop.category.register("republic", {
    name = "Republic",
    description = "Grand Army of the Republic roles.",
    color = Color(120, 180, 255),
    sortOrder = 10
})

function prop.registerJob(key, name, data)
    data.key = key

    local id, reason = prop.team.register(name, data)
    assert(id, "Failed to register " .. tostring(name) .. " team: " .. tostring(reason))

    prop.team.jobIDs[key] = id
    return id
end

local function includeJobFile(path)
    local fullPath = (prop.gamemodePath or "starwarsrp/gamemode/") .. path

    if SERVER then AddCSLuaFile(fullPath) end
    include(fullPath)
end

for _, path in ipairs(prop.jobFiles) do
    includeJobFile(path)
end
