if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Cybernetic Rancor"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_mecharancor_a01.mdl"}
ENT.Skins = {0}
--sorry
ENT.ModelScale = 190
--end sorry, the rest of the code isn't great either, but I'm not apologizing for it
ENT.CollisionBounds = Vector(0.8, 1, 1)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 500
ENT.HealthRegen = 0
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {"fallenlogic/rancor/death1.mp3"}
ENT.OnDownedSounds = {}
ENT.Footsteps = {}

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 0
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
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 45
ENT.RunSpeed =  70

-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = false
ENT.ClimbLadders = false
ENT.ClimbLaddersUp = false
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = "Head"
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
ENT.AcceptPlayerWeapons = false

-- Possession --
ENT.PossessionEnabled = false
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_1DIR
ENT.PossessionViews = {}
ENT.PossessionBinds = {}

if SERVER then

  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_HT)
  end
  
  function ENT:CustomThink() end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
  function ENT:OnMeleeAttack(enemy)
    self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
	self:EmitSound("fallenlogic/rancor/slam.mp3")
      self:Attack({
        damage = 35,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("fallenlogic/rancor/slam.mp3")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
	end
 
  
  function ENT:OnRangeAttack(enemy) end
  function ENT:OnChaseEnemy(enemy) end
  function ENT:OnAvoidEnemy(enemy) end

  -- These hooks are called while the nextbot is patrolling (inside the coroutine)
  function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(1, 4))
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
  
  function ENT:OnKilled()
	local exp = ents.Create( "env_explosion" )
    exp:SetPos( Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z+20) )
    exp:Spawn()
    exp:SetKeyValue( "iMagnitude", "200" )
    exp:Fire( "Explode", 0, 0 )
	self:Remove()
  end
  
  function ENT:OnDeath(dmg, hitgroup) end
  
  function ENT:OnDowned(dmg, hitgroup) end

else

  function ENT:CustomInitialize() end
  function ENT:CustomThink() end
  function ENT:CustomDraw() end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)