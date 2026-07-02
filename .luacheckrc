global = false

globals = {
    "SERVER", "CLIENT", "MENU_DLL"
    "gmod", "HOOK_HIGH", "HOOK_MONITOR", "HOOK_LOW",
    "Color", "Vector", "Angle", "Lerp", "CurTime", "RealTime", "FrameTime",
    "include", "AddCSLuaFile", "ValidEntity", "IsValid",
    "LocalPlayer", "CLIENT_NODRAW",
    "hook", "net", "util", "timer", "ents", "player", "file", "sql", "http",
    "cam", "render", "surface", "draw", "vgui", "input", "gui", "concommand"
}

read_globals = {
    "DarkRP"
}

ignore = {
    "611", -- Ігнорувати попередження про довжину рядків
    "113", -- Ігнорувати специфічні глобальні змінні (якщо вони не в списку, але потрібні)
}

allow_defined_top = true