GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

SWRP = SWRP or {}
SWRP.GamemodePath = "starwarsrp/gamemode/"

include(SWRP.GamemodePath .. "sh_config.lua")
include(SWRP.GamemodePath .. "sh_teams.lua")
