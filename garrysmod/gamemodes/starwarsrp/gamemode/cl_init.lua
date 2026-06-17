GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

prop.gamemodePath = "starwarsrp/gamemode/"

include(prop.gamemodePath .. "sh_config.lua")
include(prop.gamemodePath .. "sh_teams.lua")
