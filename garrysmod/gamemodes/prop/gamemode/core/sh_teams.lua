prop.team = prop.team or {}
prop.team.list = prop.team.list or {}
prop.team.byKey = prop.team.byKey or {}
prop.team.defaultID = prop.team.defaultID or nil
prop.team.defaultCategory = prop.team.defaultCategory or prop.config.get("defaultJobCategory", "Uncategorized")
prop.category = prop.category or {}
prop.category.list = prop.category.list or {}

local function normalizeCategory(category)
    if not isstring(category) then return nil end

    category = string.Trim(category)
    if category == "" then return nil end

    return category
end

prop.team.normalizeCategory = normalizeCategory

local function normalizeCategoryKey(key)
    if key == nil then return nil end
    if not isstring(key) then return false end

    key = string.Trim(string.lower(key))
    if key == "" then return false end

    return key
end

local function normalizeSortOrder(sortOrder)
    return math.floor(tonumber(sortOrder) or 0)
end

local function normalizeKey(key)
    if key == nil then return nil end
    if not isstring(key) then return false end

    key = string.Trim(key)
    if key == "" then return false end

    return key
end

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

        if #models == 0 then return false end

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

local function normalizeSalary(salary)
    if salary == nil then return 0 end

    salary = tonumber(salary)
    if not salary then return false end

    return math.max(0, math.floor(salary))
end

function prop.category.register(key, data)
    key = normalizeCategoryKey(key)
    if not key then return false, "invalid_key" end
    if data == nil then data = {} end
    if not istable(data) then return false, "invalid_data" end
    if data.color ~= nil and not isColor(data.color) then return false, "invalid_color" end

    local name = normalizeCategory(data.name) or key
    local description = normalizeDescription(data.description)
    if description == false then return false, "invalid_description" end

    prop.category.list[key] = {
        key = key,
        name = name,
        description = description,
        color = data.color or Color(255, 255, 255),
        sortOrder = normalizeSortOrder(data.sortOrder)
    }

    return prop.category.list[key]
end

function prop.category.get(key)
    key = normalizeCategoryKey(key)
    if not key then return nil end

    return prop.category.list[key]
end

function prop.category.all()
    return prop.category.list
end

function prop.category.sorted()
    local categories = {}

    for _, category in pairs(prop.category.list) do
        table.insert(categories, category)
    end

    table.sort(categories, function(a, b)
        if a.sortOrder == b.sortOrder then return a.name < b.name end
        return a.sortOrder < b.sortOrder
    end)

    return categories
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

    local key = normalizeKey(data.key)
    if key == false then return false, "invalid_key" end
    if key and prop.team.byKey[key] then return false, "key_taken" end

    local model = normalizeModel(data.model)
    if model == false then return false, "invalid_model" end

    local weapons = normalizeWeapons(data.weapons)
    if weapons == false then return false, "invalid_weapons" end

    local description = normalizeDescription(data.description)
    if description == false then return false, "invalid_description" end

    local salary = normalizeSalary(data.salary)
    if salary == false then return false, "invalid_salary" end

    local id = #prop.team.list + 1
    team.SetUp(id, name, data.color or Color(255, 255, 255))
    
    local isDefault = data.default == true or (data.default ~= false and not prop.team.defaultID)
    local categoryKey = normalizeCategoryKey(data.category)
    local registeredCategory = categoryKey and prop.category.get(categoryKey) or nil
    local category = registeredCategory and registeredCategory.name or normalizeCategory(data.category) or prop.team.defaultCategory

    prop.team.list[id] = {
        id = id,
        key = key,
        name = name,
        description = description,
        category = category,
        categoryKey = registeredCategory and registeredCategory.key or nil,
        salary = salary,
        model = model,
        weapons = weapons,
        adminOnly = data.adminOnly or false,
        default = isDefault,
        onCanChange = data.onCanChange,
        onChanged = data.onChanged,
        onSpawn = data.onSpawn or function(ply) end
    }

    if key then
        prop.team.byKey[key] = id
    end

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

function prop.team.getByKey(key)
    key = normalizeKey(key)
    if not key then return nil end

    return prop.team.get(prop.team.byKey[key])
end

function prop.team.all()
    return prop.team.list
end

function prop.team.getCategories()
    local categories = {}

    for _, category in ipairs(prop.category.sorted()) do
        table.insert(categories, category.name)
    end

    return categories
end

function prop.team.getByCategory(category)
    local categoryKey = normalizeCategoryKey(category)
    local registeredCategory = categoryKey and prop.category.get(categoryKey) or nil
    category = registeredCategory and registeredCategory.name or normalizeCategory(category)
    if not category and not registeredCategory then return {} end

    local jobs = {}

    for id, job in pairs(prop.team.list) do
        if registeredCategory then
            if job.categoryKey == registeredCategory.key or
               (not job.categoryKey and job.category and
                string.lower(job.category) == string.lower(registeredCategory.name)) then
                jobs[id] = job
            end
        elseif job.category and string.lower(job.category) == string.lower(category) then
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
