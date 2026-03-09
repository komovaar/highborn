if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Gundark"
ENT.Category = "[Atlantis] Creature NPCs"
ENT.Models = {"models/swtor/npcs/terentatek_gundark_a01.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 2
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CollisionBounds = Vector(40, 40, 80)

-- Sounds --
ENT.OnDamageSounds = {}
ENT.OnDeathSounds = {"fallenlogic/rakghoul/rakghoul_growl.mp3"}

-- Stats --
ENT.SpawnHealth = 1500

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 45
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}

-- Movements/animations --
ENT.UseWalkframes = false
ENT.WalkAnimation = ACT_WALK
ENT.RunAnimation = ACT_RUN
ENT.IdleAnimation = ACT_IDLE

ENT.WalkSpeed = 65
ENT.RunSpeed = 300

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
    self:EmitSound("fallenlogic/rakghoul/rakghoul_growl.mp3")
    self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
      self:Attack({
        damage = 75,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("Zombie.FootstepLeft")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
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