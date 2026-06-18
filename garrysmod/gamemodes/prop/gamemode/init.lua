prop = prop or {}

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")

include("sh_init.lua")

prop.includeShared("core/sh_commands.lua")
prop.includeShared("core/sh_networking.lua")
prop.includeShared("core/sh_playerclass.lua")
prop.includeShared("core/sh_teams.lua")

prop.includeServer("core/sv_database.lua")
prop.includeServer("core/sv_util.lua")
prop.includeServer("core/sv_chat.lua")
prop.includeServer("core/sv_commands.lua")
prop.includeServer("core/sv_data.lua")
prop.includeServer("core/sv_teams.lua")

hook.Run("prop.Initialized")

timer.Simple(0, function()
    prop.setReady()
    hook.Run("prop.PostReady")
end)
