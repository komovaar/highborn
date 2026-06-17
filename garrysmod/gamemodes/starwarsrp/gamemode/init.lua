GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

SWRP = SWRP or {}
SWRP.GamemodePath = "starwarsrp/gamemode/"

AddCSLuaFile(SWRP.GamemodePath .. "cl_init.lua")
AddCSLuaFile(SWRP.GamemodePath .. "sh_config.lua")
AddCSLuaFile(SWRP.GamemodePath .. "sh_teams.lua")

include(SWRP.GamemodePath .. "sh_config.lua")
include(SWRP.GamemodePath .. "sh_teams.lua")
include(SWRP.GamemodePath .. "core/sv_characters.lua")
include(SWRP.GamemodePath .. "core/sv_money.lua")
include(SWRP.GamemodePath .. "core/sv_dev_commands.lua")
