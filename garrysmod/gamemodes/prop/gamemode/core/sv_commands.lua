local BaseGamemode = baseclass.Get("gamemode_base")

local function callBaseGamemode(name, ...)
    local fn = BaseGamemode and BaseGamemode[name]
    if isfunction(fn) then return fn(...) end
end

local function sendCommandLine(ply, name, cmd)
    local prefix = prop.config.get("commandPrefix", "/")
    local aliases = ""
    if #cmd.aliases > 0 then
        aliases = " (aliases: " .. table.concat(cmd.aliases, ", ") .. ")"
    end

    ply:ChatPrint(string.format("%s%s - %s%s", prefix, name, cmd.description, aliases))
end

prop.command.add("help", {
    description = "Lists commands or shows command details.",
    usage = "/help [command]",
    aliases = {"commands", "?"},
    onRun = function(ply, args)
        local lookup = args[1]

        if lookup then
            local cmd, name = prop.command.resolve(lookup)
            if not cmd or cmd.hidden then return false, "Unknown command." end
            if cmd.adminOnly and not ply:IsAdmin() then return false, "Unknown command." end

            ply:ChatPrint(string.format("%s%s - %s", prop.config.get("commandPrefix", "/"), name, cmd.description))
            ply:ChatPrint("Usage: " .. cmd.usage)

            if #cmd.aliases > 0 then
                ply:ChatPrint("Aliases: " .. table.concat(cmd.aliases, ", "))
            end

            return true
        end

        ply:ChatPrint("[prop] Commands:")

        for _, entry in ipairs(prop.command.sorted()) do
            local cmd = entry.command

            if not cmd.hidden and (not cmd.adminOnly or ply:IsAdmin()) then
                sendCommandLine(ply, entry.name, cmd)
            end
        end

        return true
    end
})

function GM:PlayerSay(ply, text, teamOnly)
    local prefix = prop.config.get("commandPrefix", "/")

    if prefix ~= "" and string.sub(text, 1, #prefix) == prefix then
        local rawText = string.sub(text, #prefix + 1)
        local cmdName, args = prop.command.parse(rawText)

        local cmd, realName = prop.command.resolve(cmdName)

        if cmd then
            if cmd.adminOnly and not ply:IsAdmin() then
                ply:ChatPrint("[prop] You don't have permission to use this!")
                return ""
            end

            local canRun, blockReason = hook.Run("prop.CanRunCommand", ply, realName, cmd, args, rawText)
            if canRun == false then
                if blockReason then ply:ChatPrint("[prop] " .. tostring(blockReason)) end
                return ""
            end

            local success, result, message = prop.safeCall("command:" .. realName, cmd.onRun, ply, args, rawText, realName)

            if not success then
                ply:ChatPrint("[prop] Error: " .. tostring(result))
                return ""
            end

            if result == false and message then
                ply:ChatPrint("[prop] " .. tostring(message))
                if cmd.usage then ply:ChatPrint("Usage: " .. cmd.usage) end
            elseif result == true and message then
                ply:ChatPrint(tostring(message))
            end

            hook.Run("prop.CommandRan", ply, realName, cmd, args, rawText, result, message)
            return ""
        end
    end

    return callBaseGamemode("PlayerSay", self, ply, text, teamOnly)
end
