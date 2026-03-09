if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Bantha"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/bantha_a01.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(72, 72, 72)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 500
ENT.HealthRegen = 0
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
ENT.OnSpawnSounds = {"fallenlogic/bantha/bantha_spawn.wav"}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {}
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
ENT.StepHeight = 10
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 1.1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 50
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
  	local mount_position = Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z+100)
	local mount_rotation = Angle(0,-70,0)
	local mount_vehicle = ents.Create( "prop_vehicle_prisoner_pod" )
	mount_vehicle:SetModel("models/nova/airboat_seat.mdl")
	mount_vehicle:SetPos(mount_position)
	mount_vehicle:SetAngles( Angle( self:GetAngles().x, self:GetAngles().y-90, self:GetAngles().z ) )
	mount_vehicle:SetMoveType(MOVETYPE_NONE)
	mount_vehicle:SetParent(self, 0)
	mount_vehicle.mountPod = true
	--mount_vehicle.allowWeapons = false
	mount_vehicle:AddEffects( EF_NODRAW )
	mount_vehicle:Spawn()
  end
  
    function ENT:CustomThink() 
		if not self:IsPossessed() then
			for k,v in ipairs(self:GetChildren()) do
				v:AddEffects(EF_NODRAW)
			end
		end
	end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
  function ENT:OnMeleeAttack(enemy) end
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
	self:Dispossess()
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