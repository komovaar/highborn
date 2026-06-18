prop.command.add("setjob", {
    description = "Sets a player's job. Temporary development command.",
    usage = "/setjob <player|me> <job id|key|name>",
    category = "Admin",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = prop.util.findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local jobQuery = table.concat(args, " ", 2)
        local teamID, jobReason = prop.util.findJob(jobQuery)
        if not teamID then return false, jobReason end

        local ok, reason = prop.team.set(target, teamID)
        if not ok and reason ~= "unchanged" then return false, reason end

        local job = prop.team.get(teamID)
        return true, string.format("[prop] Set %s to %s.", target:Nick(), job.name)
    end
})

prop.command.add("mydata", {
    description = "Prints your saved player data. Temporary development command.",
    usage = "/mydata",
    category = "Debug",
    onRun = function(ply)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local teamKey = prop.data.get(ply, "team_key", "nil")
        local job = prop.team.getByKey(teamKey)

        ply:ChatPrint("[prop] team_key: " .. tostring(teamKey))
        ply:ChatPrint("[prop] job_name: " .. (job and job.name or "unknown"))

        return true
    end
})

prop.command.add("mychar", {
    description = "Prints your active character data. Temporary development command.",
    usage = "/mychar",
    category = "Debug",
    onRun = function(ply)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local character = prop.characters.getActive(ply)
        if not character then return false, "no_character" end

        ply:ChatPrint("[prop] character_id: " .. tostring(character.id))
        ply:ChatPrint("[prop] cid: " .. tostring(character.data.cid))
        ply:ChatPrint("[prop] callsign: " .. tostring(character.data.callsign))
        ply:ChatPrint("[prop] name: " .. tostring(character.data.name))
        ply:ChatPrint("[prop] team_key: " .. tostring(character.data.team_key))
        ply:ChatPrint("[prop] money: " .. tostring(character.data.money))
        ply:ChatPrint("[prop] level: " .. tostring(character.data.level))
        ply:ChatPrint("[prop] xp: " .. tostring(character.data.xp))
        ply:ChatPrint("[prop] arrested: " .. tostring(character.data.arrested))
        ply:ChatPrint("[prop] arrested_until: " .. tostring(character.data.arrested_until))
        ply:ChatPrint("[prop] arrested_by: " .. tostring(character.data.arrested_by))

        return true
    end
})

prop.command.add("callsign", {
    description = "Shows your character callsign.",
    usage = "/callsign",
    category = "Character",
    onRun = function(ply)
        local character = prop.characters.getActive(ply)
        if not character then return false, "no_character" end

        return true, string.format("[prop] %s-%s", character.data.callsign, character.data.cid)
    end
})

prop.command.add("setcallsign", {
    description = "Sets a character callsign. Temporary development command.",
    usage = "/setcallsign <player|me> <callsign>",
    category = "Debug",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = prop.util.findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local callsign = table.concat(args, " ", 2)
        local ok, reason = prop.characters.setCallsign(target, callsign, ply)
        if not ok and reason ~= "unchanged" then return false, reason end

        local character = prop.characters.getActive(target)
        return true, string.format("[prop] Set %s callsign to %s-%s.", target:Nick(), character.data.callsign, character.data.cid)
    end
})

prop.command.add("chars", {
    description = "Lists your characters.",
    usage = "/chars",
    category = "Character",
    onRun = function(ply)
        local characters = prop.characters.list(ply)
        if #characters == 0 then return false, "no_characters" end

        local active = prop.characters.getActive(ply)
        ply:ChatPrint("[prop] Characters:")

        for _, character in ipairs(characters) do
            local marker = active and active.id == character.id and "*" or "-"
            ply:ChatPrint(string.format(
                "%s %s %s-%s (%s)",
                marker,
                character.id,
                character.data.callsign,
                character.data.cid,
                character.data.team_key
            ))
        end

        return true
    end
})

prop.command.add("createchar", {
    description = "Creates a new character.",
    usage = "/createchar <callsign>",
    category = "Character",
    onRun = function(ply, args)
        local callsign = table.concat(args, " ")
        local character, reason = prop.characters.create(ply, {callsign = callsign})
        if not character then return false, reason end

        return true, string.format("[prop] Created %s-%s. Use /switchchar %s to activate.", character.data.callsign, character.data.cid, character.data.cid)
    end
})

prop.command.add("switchchar", {
    description = "Switches your active character.",
    usage = "/switchchar <id|cid|callsign>",
    category = "Character",
    onRun = function(ply, args)
        local query = table.concat(args, " ")
        local character = prop.characters.findOwned(ply, query)
        if not character then return false, "character_not_found" end

        local ok, result = prop.characters.setActive(ply, character.id)
        if not ok and result == "unchanged" then
            return true, string.format("[prop] Already using %s-%s.", character.data.callsign, character.data.cid)
        end
        if not ok then return false, result end

        return true, string.format("[prop] Switched to %s-%s.", result.data.callsign, result.data.cid)
    end
})

prop.command.add("addmoney", {
    description = "Adds money to a character. Temporary development command.",
    usage = "/addmoney <player|me> <amount>",
    category = "Debug",
    onRun = function(ply, args)
        if not prop.canUseDevCommand(ply) then
            return false, "no_access"
        end

        local target, targetReason = prop.util.findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local amount = math.floor(tonumber(args[2]) or 0)
        if amount <= 0 then return false, "invalid_amount" end

        local ok, reason = prop.money.add(target, amount, "dev_addmoney")
        if not ok and reason ~= "unchanged" then return false, reason end

        target:ChatPrint("[prop] Balance: " .. tostring(prop.money.get(target)))
        return true, string.format("[prop] Added %d to %s.", amount, target:Nick())
    end
})
