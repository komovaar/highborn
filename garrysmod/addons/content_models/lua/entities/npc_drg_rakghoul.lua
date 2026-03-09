if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Lumbering Rakghoul"
ENT.Category = "[Valkyrie] Humanoid NPCs"
ENT.Models = {"models/swtor/npcs/rakghoul.mdl"}
ENT.BloodColor = BLOOD_COLOR_ZOMBIE
ENT.Skins = {0}

-- Sounds --
ENT.OnDamageSounds = {"fallenlogic/rakghoul/rakghoul_growl.mp3"}
ENT.OnDeathSounds = {"Zombie.Die"}

-- Stats --
ENT.SpawnHealth = 100

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 30
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_WALK

-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)

if SERVER then

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
  end

  -- AI --

  function ENT:OnMeleeAttack(enemy)
    self:EmitSound("fallenlogic/rakghoul/rakghoul_growl.mp3")
    self:PlaySequenceAndMove("attackA", 1, self.FaceEnemy)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Animations/Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound("Zombie.Alert")
  end

  function ENT:OnAnimEvent()
    if self:IsAttacking() and self:GetCycle() > 0.3 then
      self:Attack({
        damage = 10,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("Zombie.AttackHit")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
    elseif math.random(2) == 1 then
      self:EmitSound("Zombie.FootstepLeft")
    else self:EmitSound("Zombie.FootstepRight") end
  end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)