GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

AddCSLuaFile("sh_config.lua")
AddCSLuaFile("sh_teams.lua")

include("sh_config.lua")
include("sh_teams.lua")
include("core/sv_characters.lua")
include("core/sv_dev_commands.lua")
