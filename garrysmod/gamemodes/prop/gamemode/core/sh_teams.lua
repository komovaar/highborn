prop.team = prop.team or {}
prop.team.list = prop.team.list or {}
prop.team.defaultID = prop.team.defaultID or nil
prop.team.defaultCategory = prop.team.defaultCategory or prop.config.get("defaultJobCategory", "Uncategorized")

local function normalizeCategory(category)
    if not isstring(category) then return nil end

    category = string.Trim(category)
    if category == "" then return nil end

    return category
end

prop.team.normalizeCategory = normalizeCategory

local function isColor(value)
    return istable(value) and isnumber(value.r) and isnumber(value.g) and isnumber(value.b)
end

local function normalizeModel(model)
    if model == nil then return nil end
    if isstring(model) then
        model = string.Trim(model)
        if model ~= "" then return model end
    end

    if istable(model) then
        local models = {}

        for _, value in ipairs(model) do
            if not isstring(value) then return false end
            value = string.Trim(value)
            if value == "" then return false end
            table.insert(models, value)
        end

        return models
    end

    return false
end

local function normalizeWeapons(weapons)
    if weapons == nil then return {} end
    if not istable(weapons) then return false end

    local normalized = {}

    for _, weapon in ipairs(weapons) do
        if not isstring(weapon) then return false end
        weapon = string.Trim(weapon)
        if weapon == "" then return false end
        table.insert(normalized, weapon)
    end

    return normalized
end

local function validateCallback(callback)
    return callback == nil or isfunction(callback)
end

local function normalizeDescription(description)
    if description == nil then return "" end
    if not isstring(description) then return false end

    return description
end

function prop.team.register(name, data)
    if not isstring(name) or string.Trim(name) == "" then return false, "invalid_name" end
    if not istable(data) then return false, "invalid_data" end
    if data.adminOnly ~= nil and type(data.adminOnly) ~= "boolean" then return false, "invalid_admin_flag" end
    if data.default ~= nil and type(data.default) ~= "boolean" then return false, "invalid_default_flag" end
    if data.color ~= nil and not isColor(data.color) then return false, "invalid_color" end
    if not validateCallback(data.onCanChange) then return false, "invalid_on_can_change" end
    if not validateCallback(data.onChanged) then return false, "invalid_on_changed" end
    if not validateCallback(data.onSpawn) then return false, "invalid_on_spawn" end

    name = string.Trim(name)

    local model = normalizeModel(data.model)
    if model == false then return false, "invalid_model" end

    local weapons = normalizeWeapons(data.weapons)
    if weapons == false then return false, "invalid_weapons" end

    local description = normalizeDescription(data.description)
    if description == false then return false, "invalid_description" end

    local id = #prop.team.list + 1
    team.SetUp(id, name, data.color or Color(255, 255, 255))
    
    local isDefault = data.default or not prop.team.defaultID
    local category = normalizeCategory(data.category) or prop.team.defaultCategory

    prop.team.list[id] = {
        id = id,
        name = name,
        description = description,
        category = category,
        model = model,
        weapons = weapons,
        adminOnly = data.adminOnly or false,
        default = isDefault,
        onCanChange = data.onCanChange,
        onChanged = data.onChanged,
        onSpawn = data.onSpawn or function(ply) end
    }

    if isDefault then
        if prop.team.defaultID and prop.team.list[prop.team.defaultID] then
            prop.team.list[prop.team.defaultID].default = false
        end

        prop.team.defaultID = id
    end

    prop.log("Registered Job: " .. name .. " (ID: " .. id .. ")")
    return id
end

function prop.team.get(id)
    return prop.team.list[tonumber(id)]
end

function prop.team.all()
    return prop.team.list
end

function prop.team.getCategories()
    local categories = {}
    local seen = {}

    for _, job in pairs(prop.team.list) do
        if not seen[job.category] then
            seen[job.category] = true
            table.insert(categories, job.category)
        end
    end

    return categories
end

function prop.team.getByCategory(category)
    category = normalizeCategory(category)
    if not category then return {} end

    local jobs = {}

    for id, job in pairs(prop.team.list) do
        if job.category == category then
            jobs[id] = job
        end
    end

    return jobs
end

function prop.team.getDefault()
    return prop.team.get(prop.team.defaultID)
end

function prop.team.getDefaultID()
    return prop.team.defaultID
end

function prop.team.setDefault(id)
    id = tonumber(id)
    if not prop.team.get(id) then return false, "invalid_team" end

    if prop.team.defaultID and prop.team.list[prop.team.defaultID] then
        prop.team.list[prop.team.defaultID].default = false
    end

    prop.team.defaultID = id
    prop.team.list[id].default = true

    return true
end
