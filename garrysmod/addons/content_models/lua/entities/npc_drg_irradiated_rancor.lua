if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "npc_drg_rancor" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Irradiated Rancor"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_a01.mdl"}
ENT.Skins = {6}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 100)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1200
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

if SERVER then

	function ENT:CustomThink()
		enemy = self:GetEnemy()
		local dist = 300 * 300
			local vec = self:GetPos()
		if enemy:IsValid() then
			local enemyDist = enemy:GetPos()
			if ( vec:DistToSqr(enemyDist) < dist) then
				if enemy:IsNPC() and enemy:IsValid() then
					enemy:TakeDamage( 0.1, self, self )
				elseif enemy:IsPlayer() and not enemy:InVehicle() then
					enemy:TakeDamage( 0.1, self, self )
				end
			end
		end
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)