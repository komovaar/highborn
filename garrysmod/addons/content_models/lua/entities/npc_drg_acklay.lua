if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Acklay"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/acklay_a01.mdl"}
ENT.ModelScale = 2
ENT.BloodColor = BLOOD_COLOR_GREEN
--ENT.CollisionBounds = Vector(60, 80, 50)

-- Sounds --
ENT.OnDamageSounds = {}
ENT.OnDeathSounds = {"fallenlogic/acklay/screech01.mp3"}
ENT.OnSpawnSounds = {}

-- Stats --
ENT.SpawnHealth = 1500

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 120
ENT.ReachEnemyRange = 100
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}

-- Movements/animations --
ENT.UseWalkframes = false
ENT.WalkAnimation = ACT_WALK
ENT.RunAnimation = ACT_RUN
ENT.IdleAnimation = ACT_IDLE

ENT.WalkSpeed = 30
ENT.RunSpeed = 120

-- Detection --
ENT.EyeBone = "EyelidTop"
--ENT.EyeOffset = Vector(7.5, 0, 5)

if SERVER then

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
  end

  -- AI --

  function ENT:OnMeleeAttack(enemy)
	if math.random(1,2) == 1 then
		self:EmitSound("fallenlogic/acklay/screech02.mp3")
	else
		self:EmitSound("fallenlogic/acklay/screech01.mp3")
	end
    self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
      self:Attack({
        damage = 0.5*enemy:GetMaxHealth(),
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("Zombie.FootstepLeft")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
	  self:PlaySequenceAndMove("default_attack2", 1, self.FaceEnemy)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1600))
  end

  -- Animations/Sounds --

  function ENT:OnNewEnemy() end

  function ENT:OnAnimEvent() end
  
  function ENT:OnDeath(dmg, hitgroup) 
	self:PlaySequenceAndMove("die", 1, self.FaceForward)
  end
  
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)