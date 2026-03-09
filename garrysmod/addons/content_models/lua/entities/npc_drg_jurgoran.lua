if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Jurgoran"
ENT.Category = "[Atlantis] Creature NPCs"
ENT.Models = {"models/swtor/npcs/wampa_jurgoran_a01.mdl"}
ENT.ModelScale = 2
ENT.CollisionBounds = Vector(20, 20, 80)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.ModelScale = 1

-- Sounds --
ENT.OnDamageSounds = {}
ENT.OnDeathSounds = {}

-- Stats --
ENT.SpawnHealth = 700

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Movements/animations --
ENT.UseWalkframes = false
ENT.RunSpeed = 32
ENT.WalkSpeed = 32
ENT.RunAnimation = ACT_WALK



-- Detection --
ENT.EyeBone = "head"
ENT.EyeOffset = Vector(7.5, 0, 5)

if SERVER then

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
  end

  -- AI --

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end
  
  function ENT:OnMeleeAttack(enemy)
	self:PlaySequenceAndMove("default_attack", 1, self.FaceForward)
	self:EmitSound("fallenlogic/rancor/slam.mp3")
      self:Attack({
        damage = 25,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("fallenlogic/rancor/slam.mp3")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
  end

  -- Animations/Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound("fallenlogic/rakghoul/rakghoul_growl.mp3")
  end

  function ENT:OnAnimEvent()
  end
  
  function ENT:OnDeath(dmg, hitgroup) 
	self:PlaySequenceAndMove("die", 1, self.FaceForward)
  end
  
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)