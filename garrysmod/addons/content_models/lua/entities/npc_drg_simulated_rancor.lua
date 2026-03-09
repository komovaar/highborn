if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "npc_drg_rancor" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Simulated Rancor"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_a01.mdl"}
ENT.Skins = {1}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 100)
ENT.BloodColor = BLOOD_COLOR_MECH
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1000
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

if SERVER then
  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_HT)
	self:SetRenderFX( kRenderFxHologram )
	self:SetColor( Color( 0, 200, 240, 100 ) ) 
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
  end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)