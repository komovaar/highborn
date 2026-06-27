prop.command = prop.command or {}
prop.command.list = prop.command.list or {}
prop.command.aliases = prop.command.aliases or {}

local function normalizeName(name)
    if not isstring(name) then return nil end

    name = string.Trim(string.lower(name))
    if name == "" then return nil end

    return name
end

local function normalizeAliases(aliases)
    if aliases == nil then return {} end
    if isstring(aliases) then return {aliases} end
    if istable(aliases) then return aliases end

    return {}
end

local function normalizeText(value, default)
    if value == nil then return default end
    if not isstring(value) then return false end

    value = string.Trim(value)
    if value == "" then return default end

    return value
end

function prop.command.add(name, data)
    name = normalizeName(name)
    if not name then return false, "invalid_name" end
    if not istable(data) then return false, "invalid_data" end
    if not isfunction(data.onRun) then return false, "invalid_callback" end
    if data.adminOnly ~= nil and type(data.adminOnly) ~= "boolean" then return false, "invalid_admin_flag" end
    if data.hidden ~= nil and type(data.hidden) ~= "boolean" then return false, "invalid_hidden_flag" end

    local description = normalizeText(data.description, "No description provided.")
    if description == false then return false, "invalid_description" end

    local usage = normalizeText(data.usage, prop.config.get("commandPrefix", "/") .. name)
    if usage == false then return false, "invalid_usage" end

    local category = normalizeText(data.category, "General")
    if category == false then return false, "invalid_category" end

    local aliases = {}

    for _, alias in ipairs(normalizeAliases(data.aliases)) do
        alias = normalizeName(alias)

        if alias and alias ~= name then
            if prop.command.list[alias] or (prop.command.aliases[alias] and prop.command.aliases[alias] ~= name) then
                return false, "alias_taken"
            end

            table.insert(aliases, alias)
        end
    end

    local oldCommand = prop.command.list[name]

    if oldCommand then
        for _, alias in ipairs(oldCommand.aliases or {}) do
            prop.command.aliases[alias] = nil
        end
    end

    prop.command.list[name] = {
        name = name,
        onRun = data.onRun,
        adminOnly = data.adminOnly or false,
        description = description,
        usage = usage,
        category = category,
        hidden = data.hidden or false,
        aliases = aliases
    }

    prop.command.aliases[name] = nil

    for _, alias in ipairs(aliases) do
        prop.command.aliases[alias] = name
    end

    prop.log("Registered Command " .. name)
    return true
end

function prop.command.resolve(name)
    name = normalizeName(name)
    if not name then return nil end

    local realName = prop.command.aliases[name] or name
    return prop.command.list[realName], realName
end

function prop.command.get(name)
    local cmd = prop.command.resolve(name)
    return cmd
end

function prop.command.exists(name)
    return prop.command.get(name) ~= nil
end

function prop.command.all()
    return prop.command.list
end

function prop.command.parse(rawText)
    local args = {}

    for _, part in ipairs(string.Explode(" ", rawText or "")) do
        if part ~= "" then
            table.insert(args, part)
        end
    end

    local cmdName = table.remove(args, 1)
    return normalizeName(cmdName), args
end

function prop.command.sorted()
    local commands = {}

    for name, cmd in pairs(prop.command.list) do
        table.insert(commands, {name = name, command = cmd})
    end

    table.SortByMember(commands, "name", true)
    return commands
end
