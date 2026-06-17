GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

prop.gamemodePath = "starwarsrp/gamemode/"

AddCSLuaFile(prop.gamemodePath .. "cl_init.lua")
AddCSLuaFile(prop.gamemodePath .. "sh_config.lua")
AddCSLuaFile(prop.gamemodePath .. "sh_teams.lua")

include(prop.gamemodePath .. "sh_config.lua")
include(prop.gamemodePath .. "sh_teams.lua")
include(prop.gamemodePath .. "core/sv_characters.lua")
include(prop.gamemodePath .. "core/sv_money.lua")
include(prop.gamemodePath .. "core/sv_salary.lua")
include(prop.gamemodePath .. "core/sv_dev_commands.lua")
