if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Womp rat"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/womprat_a01.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(45, 66, 43)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 200
ENT.HealthRegen = 0
ENT.MinPhysDamage = 20
ENT.MinFallDamage = 5
ENT.AttackDamage = 15

-- Sounds --
ENT.OnSpawnSounds = {"fallenlogic/nexu/nexu_growl.mp3"}
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
ENT.RangeAttackRange = 65
ENT.MeleeAttackRange = 65
ENT.ReachEnemyRange = 65
ENT.AvoidEnemyRange = 0
ENT.FollowPlayers = true

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}
ENT.Frightening = true
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
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 35
ENT.RunSpeed =  53

-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = true
ENT.ClimbLadders = false
ENT.ClimbLaddersUp = false
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 80
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(-12, 0, 0)

-- Detection --
ENT.EyeBone = "Camera"
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
ENT.PossessionBinds = {
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
       self:PlaySequenceAndMove("default_attack", 1, self.PossessionFaceForward)
	   local dist = 300 * 300
	   local vec = self:GetPos()
	   for k, v in ipairs( ents.FindByClass( "*" ) ) do
			--sbd (should be damaged)
			local sbd = v:GetPos()
			if ( vec:DistToSqr(sbd) < dist) then
				if IsValid( v ) then
					v:TakeDamage( 25, self, self )
				end
			end
		end
	self:PlaySequenceAndMove("default_attack2", 1, self.PossessionFaceForward)
	end
  }}
}

if SERVER then
  
  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_HT)
	local mount_position = Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z+45)
	local mount_rotation = Angle(0,-70,0)
	local mount_vehicle = ents.Create( "prop_vehicle_prisoner_pod" )
	mount_vehicle:SetModel("models/nova/airboat_seat.mdl")
	mount_vehicle:SetPos(Vector(mount_position.x,mount_position.y, mount_position.z+7))
	mount_vehicle:SetAngles( Angle( self:GetAngles().x, self:GetAngles().y-90, self:GetAngles().z ) )
	mount_vehicle:SetMoveType(MOVETYPE_NONE)
	mount_vehicle:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	mount_vehicle:SetParent(self, 0)
	mount_vehicle.mountPod = true
	mount_vehicle:AddEffects( EF_NODRAW )
	mount_vehicle:Spawn()
  end
  
    function ENT:CustomThink() 
	if not self:IsPossessed() then
		for k,v in ipairs(self:GetChildren()) do
			v:AddEffects(EF_NODRAW)
			v:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end
	end
	end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
    function ENT:OnMeleeAttack(enemy)
	self:PlaySequenceAndMove("default_attack", 1, self.FaceForward)
	  self:Attack({
        damage = self.AttackDamage,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("Zombie.AttackHit")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
	self:PlaySequenceAndMove("default_attack2", 1, self.FaceForward)
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