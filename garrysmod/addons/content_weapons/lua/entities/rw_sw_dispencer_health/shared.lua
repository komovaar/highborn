ENT.Type = "anim"
ENT.Base = "base_gmodentity"

local dispencer_health = GetConVar("rw_sw_dispenser_health"):GetInt()
ENT.BaseHealth = dispencer_health

ENT.PrintName		= "Health Dispenser"
ENT.Author			= "ChanceSphere574"
ENT.Category		= "StarWars Reworked Armory"
ENT.Spawnable 		= true
ENT.AdminSpawnable	= false

ENT.UseTimer = CurTime()
ENT.Status   = 0

ENT.LoadingSkin = 3
ENT.CurSkin = 1