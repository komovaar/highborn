if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Krykna"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/jediacad/npcs/krykna.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(72, 72, 100)
ENT.BloodColor = DONT_BLEED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1000
ENT.HealthRegen = 0
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
ENT.OnSpawnSounds = {""}
ENT.OnIdleSounds = {"Zombie.FootstepLeft", "Zombie.FootstepRight"}
ENT.IdleSoundDelay = 0.2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {}
ENT.OnDownedSounds = {}
ENT.Footsteps = {}

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 10
ENT.RangeAttackRange = 300
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}
ENT.Frightening = false
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
ENT.Acceleration = 800
ENT.Deceleration = 800
ENT.JumpHeight = 50
ENT.StepHeight = 10
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_WALK
ENT.RunAnimRate = 1.5
ENT.IdleAnimation = ACT_WALK
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 100
ENT.RunSpeed =  150

-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = true
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 80
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = "mouth_translate"
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Weapons --
ENT.UseWeapons = false
ENT.Weapons = {}
ENT.WeaponAccuracy = 1
ENT.WeaponAttachment = ""
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = true

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionCrosshair = true
ENT.PossessionViews = {
  {
    offset = Vector(-200, 0, 150),
    distance = 0
  },
  {
    offset = Vector(45, 0, 0),
    distance = -325,
    eyepos = true
  }
}
ENT.PossessionBinds = {}

if SERVER then

  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_HT)
  end
  
    function ENT:CustomThink() end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
  function ENT:OnMeleeAttack(enemy) 
	self:EmitSound("fallenlogic/spider/click.mp3")
	self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
      self:Attack({
        damage = 0.25*enemy:GetMaxHealth(),
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("fallenlogic/spider/click.mp3")
        else self:EmitSound("fallenlogic/spider/click.mp3") end
      end)
	  self:PlaySequenceAndMove("default_attack2", 1, self.FaceEnemy)
	end
  
  
  function ENT:OnRangeAttack(enemy) end
  function ENT:OnChaseEnemy(enemy) end
  function ENT:OnAvoidEnemy(enemy) end

  -- These hooks are called while the nextbot is patrolling (inside the coroutine)
  function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(1, 3))
  end 
  function ENT:OnPatrolUnreachable(pos) end
  function ENT:OnPatrolling(pos) end

  -- These hooks are called when the current enemy changes (outside the coroutine)
  function ENT:OnNewEnemy(enemy) end
  function ENT:OnEnemyChange(oldEnemy, newEnemy) end
  function ENT:OnLastEnemy(enemy) end

  -- Those hooks are called inside the coroutine
  function ENT:OnSpawn() end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Called outside the coroutine
  function ENT:OnTakeDamage(dmg, hitgroup)
    self:SpotEntity(dmg:GetAttacker())
  end
  function ENT:OnFatalDamage(dmg, hitgroup) end
  
  -- Called inside the coroutine
  function ENT:OnTookDamage(dmg, hitgroup) end
  function ENT:OnDeath(dmg, hitgroup)
	self:PlaySequenceAndMove("die", 1, self.FaceForward)
  end
	
  function ENT:OnDowned(dmg, hitgroup) end

else

  function ENT:CustomInitialize() end
  function ENT:CustomThink() end
  function ENT:CustomDraw() end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)