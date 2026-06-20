if SERVER then return end

include("swrp_f4menu/cl_menu.lua")
include("swrp_f4menu/cl_profile.lua")
include("swrp_f4menu/cl_roster.lua")
include("swrp_f4menu/cl_characters.lua")
include("swrp_f4menu/cl_calladmin.lua")
include("swrp_f4menu/cl_donate.lua")
include("swrp_f4menu/cl_quests.lua")

hook.Add("PlayerButtonDown", "swrp_f4menu.Keybind", function(_, btn)
    if btn == KEY_F4 then
        swrp_f4menu.Open()
    end
end)
