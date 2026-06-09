local civilianJobCommands = {
    "gangmale",
    "gangfemale",
    "civmale",
    "civfemale",
    "engmale",
    "engfemale",
    "formalmale",
    "formalfemale",
    "guardmale",
    "guardfemale",
    "jan1",
    "jan2",
    "noblemale",
    "noblefemale",
    "snowmale",
    "snowfemale",
    "smugmale",
    "smugfemale",
    "scimale",
    "scifemale",
    "citizenmale",
    "citizenfemale",
    "renmale",
    "renfemale",
}

local commandsToRemove = {
    -- Door commands.
    "addowner",
    "ao",
    "forceown",
    "forceremoveowner",
    "forcelock",
    "forceunlock",
    "forceunown",
    "forceunownall",
    "removeowner",
    "ro",
    "sellalldoors",
    "title",
    "togglegroupownable",
    "toggleteamownable",
    "toggleown",
    "toggleownable",
    "unownalldoors",

    -- Purchase commands.
    "buy",
    "buyammo",
    "buyshipment",
    "buyvehicle",
    "makeshipment",
    "price",
    "setprice",
    "splitshipment",

    -- Job commands.
    "demote",
    "job",
    "jobswitch",
    "switchjob",
    "switchjobs",
    "teamban",
    "teamunban",

    -- Police commands.
    "addagenda",
    "agenda",
    "arrest",
    "demotelicense",
    "givelicense",
    "lockdown",
    "lottery",
    "requestlicense",
    "setlicense",
    "unarrest",
    "unlockdown",
    "unwanted",
    "unwarrant",
    "unsetlicense",
    "wanted",
    "warrant",

    -- Weapon commands.
    "drop",
    "dropweapon",
    "weapondrop",
}

for _, command in ipairs(civilianJobCommands) do
    table.insert(commandsToRemove, command)
end

local samCommandsToRemove = {
    "arrest",
    "unarrest",
    "selldoor",
    "sellall",
    "setjob",
    "shipment",
}

local commandLookup = {}
for _, command in ipairs(commandsToRemove) do
    commandLookup[command] = true
end

local function removeDarkRPCommands()
    for _, command in ipairs(commandsToRemove) do
        DarkRP.removeChatCommand(command)
    end

    if SERVER then
        for _, command in ipairs(civilianJobCommands) do
            concommand.Remove("rp_" .. command)
        end
    end
end

local function removeSAMCommands()
    if not sam or not sam.command or not sam.command.remove_command then return end

    for _, command in ipairs(samCommandsToRemove) do
        sam.command.remove_command(command)
    end
end

removeDarkRPCommands()
removeSAMCommands()

if SERVER then
    hook.Add("PlayerSay", "SW.BlockRemovedDarkRPCommands", function(ply, text)
        local prefix = GAMEMODE.Config.chatCommandPrefix or "/"
        if string.sub(text, 1, #prefix) ~= prefix then return end

        local command = string.lower(string.Explode(" ", string.sub(text, #prefix + 1))[1] or "")
        if commandLookup[command] then return "" end
    end)

    hook.Add("InitPostEntity", "SW.RemoveUnwantedDarkRPCommandsLate", function()
        removeDarkRPCommands()
        removeSAMCommands()
    end)

    timer.Simple(0, function()
        removeDarkRPCommands()
        removeSAMCommands()
    end)

    timer.Simple(5, function()
        removeDarkRPCommands()
        removeSAMCommands()
    end)
end

hook.Add("postLoadCustomDarkRPItems", "SW.RemoveUnwantedDarkRPCommands", function()
    removeDarkRPCommands()
    removeSAMCommands()
end)

hook.Add("SAM.CommandAdded", "SW.RemoveUnwantedSAMDarkRPCommands", function(name)
    if not table.HasValue(samCommandsToRemove, name) then return end
    removeSAMCommands()
end)
