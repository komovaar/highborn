prop = prop or {}

include("sh_init.lua")

prop.includeShared("core/sh_commands.lua")
prop.includeShared("core/sh_networking.lua")
prop.includeShared("core/sh_playerclass.lua")
prop.includeShared("core/sh_teams.lua")
prop.includeClient("core/cl_data.lua")

hook.Run("prop.Initialized")

timer.Simple(0, function()
    prop.setReady()
    hook.Run("prop.PostReady")
end)
