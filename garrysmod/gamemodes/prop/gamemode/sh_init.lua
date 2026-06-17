GM.Name = "prop"
GM.Author = "whosgotch"

prop = prop or {}

prop.team = prop.team or {}
prop.spawn = prop.spawn or {}
prop.net = prop.net or {}
prop.data = prop.data or {}
prop.command = prop.command or {}
prop.player = prop.player or {}
prop.state = prop.state or {}
prop.ready = prop.ready or false
prop.config = prop.config or {}

prop.config.defaults = prop.config.defaults or {
    commandPrefix = "/",
    dataAutosaveInterval = 300,
    defaultJobCategory = "Uncategorized",
    netMaxKeyLength = 64,
    netMaxStringLength = 512,
    netMaxChatParts = 32,
    playerWalkSpeed = 200,
    playerRunSpeed = 400,
    playerSlowWalkSpeed = 100,
    playerDuckSpeed = 0.3,
    playerUnDuckSpeed = 0.3,
    playerCrouchedWalkSpeed = 0.3,
    playerJumpPower = 200,
    playerStartHealth = 100,
    logLevel = "warn",
    debug = false
}

function prop.config.get(key, default)
    local value = prop.config[key]
    if value ~= nil then return value end

    value = prop.config.defaults[key]
    if value ~= nil then return value end

    return default
end

function prop.config.set(key, value)
    prop.config[key] = value
    hook.Run("prop.ConfigChanged", key, value)

    return true
end

prop.logLevels = prop.logLevels or {
    debug = 1,
    info = 2,
    warn = 3,
    error = 4
}

function prop.log(level, message)
    if message == nil then
        message = level
        level = "debug"
    end

    level = tostring(level or "debug")

    local configuredLevel = prop.config.get("debug", false) and "debug" or prop.config.get("logLevel", "warn")
    local currentLevel = prop.logLevels[configuredLevel] or prop.logLevels.warn
    local messageLevel = prop.logLevels[level] or prop.logLevels.debug
    if messageLevel < currentLevel then return end

    print(string.format("[prop:%s] %s", level, tostring(message)))
end

function prop.handleError(context, err)
    context = context or "unknown"
    err = tostring(err)

    ErrorNoHalt("[prop:error] Error in " .. context .. ": " .. err .. "\n")
    hook.Run("prop.Error", context, err)
end

function prop.safeCall(context, callback, ...)
    if not isfunction(callback) then return false, "invalid_callback" end

    local result = {pcall(callback, ...)}
    local success = table.remove(result, 1)

    if not success then
        prop.handleError(context, result[1])
        return false, result[1]
    end

    return true, unpack(result)
end

function prop.includeShared(path)
    if SERVER then AddCSLuaFile(path) end
    include(path)
end

function prop.includeServer(path)
    if SERVER then include(path) end
end

function prop.includeClient(path)
    if SERVER then
        AddCSLuaFile(path)
    elseif CLIENT then
        include(path)
    end
end

function prop.setReady()
    if prop.ready then return false end

    prop.ready = true
    hook.Run("prop.Ready")

    return true
end

function prop.onReady(identifier, callback)
    if not identifier or not isfunction(callback) then return false end

    if prop.ready then
        prop.safeCall("onReady:" .. tostring(identifier), callback)
    else
        hook.Add("prop.Ready", identifier, function()
            hook.Remove("prop.Ready", identifier)
            prop.safeCall("onReady:" .. tostring(identifier), callback)
        end)
    end

    return true
end

prop.log("Core Tables Initialized...")
