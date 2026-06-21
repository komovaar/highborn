if SERVER then return end

include("swrp_f4menu/cl_menu.lua")
include("swrp_f4menu/cl_lobby.lua")

hook.Add("PlayerButtonDown", "swrp_f4menu.Keybind", function(_, btn)
    if btn == KEY_F4 then
        swrp_f4menu.Open()
    end
end)
