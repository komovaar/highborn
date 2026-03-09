if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Rancor Mount"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_a01.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 100)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1000
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {"fallenlogic/rancor/breath_loop.wav"}
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
ENT.MeleeAttackRange = 80
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}
ENT.Frightening = true
ENT.AllyDamageTolerance = 1.00
ENT.AfraidDamageTolerance = 1.00
ENT.NeutralDamageTolerance = 1.00

-- Locomotion --
ENT.Acceleration = 1000
ENT.Deceleration = 1000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_WALK
ENT.RunAnimRate = 1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_IDLE
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 100
ENT.RunSpeed = 200

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
ENT.EyeBone = "R_Eyelid"
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
    offset = Vector(-80, 0, 256),
    distance = 40
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
	   self:EmitSound("fallenlogic/rancor/slam.mp3")
       self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
	   local dist = 400 * 400
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
	end
  }}
}

if SERVER then

  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_LI)
	self:SetSkin(math.random(0,9))
	self:SetBodygroup(1,math.random(1,2))
	local mount_position = Vector(self:GetPos().x+35,self:GetPos().y,self:GetPos().z+160)
	local mount_rotation = Angle(0,-70,0)
	local mount_vehicle = ents.Create( "prop_vehicle_prisoner_pod" )
	mount_vehicle:SetModel("models/nova/airboat_seat.mdl")
	mount_vehicle:SetPos(mount_position)
	mount_vehicle:SetAngles( Angle( self:GetAngles().x, self:GetAngles().y-90, self:GetAngles().z ) )
	mount_vehicle:SetMoveType(MOVETYPE_NONE)
	mount_vehicle:SetParent(self, self:LookupBone("neck_mid"))
	--These bones are compiled into the model and need to be manually set
	mount_vehicle:Fire("SetParentAttachment", "SeatSpot", 0.1, self, self)
	mount_vehicle.mountPod = true
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
  function ENT:OnMeleeAttack(enemy)
	self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
  -- if math.random(1,2) == 1 then
	-- local oldpos = enemy:GetPos()
	-- local curHealth = self:Health()
	
	-- local matrix = self:GetBoneMatrix(51)
	-- local handpos = matrix:GetTranslation()
	-- local reset_angles = Angle(0,0,0)
	-- local grabbed = false
	
	-- self:PlaySequenceAndMove( "swipe_attack", 1, self.FaceEnemy )
	
	-- local dist = 300 * 300
	-- local vec = self:GetPos()
	-- local enemyDist = enemy:GetPos()
	-- if vec:DistToSqr(enemyDist) < dist then
		-- if IsValid( enemy ) then
			-- enemy:SetMoveType( MOVETYPE_NONE )
			-- enemy:SetParent(self, 51)
			-- enemy:Fire("SetParentAttachment", "RightHand", 0.1, self, self)
			-- grabbed = true
		-- end
	-- end
	-- self:EmitSound("fallenlogic/rancor/chew1.mp3")
	-- self:PlaySequenceAndMove("rancor_eat", 1, self.FaceForward)
	-- if math.random(1,10) != 10 then
		-- local can_escape = false
	-- end
	-- if ( self:Health() < curHealth and grabbed and can_escape) then
		-- enemy:SetParent(NULL,-1)
		-- enemy:SetAngles( reset_angles )
		-- enemy:SetPos( oldpos )
	-- elseif grabbed and not can_escape then 
		-- enemy:TakeDamage(enemy:GetMaxHealth(), self, enemy)
		-- enemy:SetParent(NULL,-1)
		-- enemy:SetAngles( reset_angles )
		-- enemy:SetPos( oldpos )
	-- end
	
	
	-- if enemy:IsPlayer() then
		-- enemy:SetMoveType(MOVETYPE_WALK)
	-- elseif ( enemy:GetClass() == "npc_turret_floor" ) then
		-- enemy:Remove()
	-- else
		-- enemy:SetMoveType(MOVETYPE_STEP) end
	
	
	
  -- else 	self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
	
	self:EmitSound("fallenlogic/rancor/slam.mp3")
      self:Attack({
        damage = 0.25*enemy:GetMaxHealth(),
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
  
  function ENT:OnDeath(dmg, hitgroup) 
	self:PlaySequenceAndMove("die", 1, self.FaceForward)
	self:Dispossess()
  end
  
  function ENT:OnDowned(dmg, hitgroup) end
  
  function ENT:Possessed()
	
  end

  function ENT:OnRemove() 
	
  end

else
  
  function ENT:CustomInitialize() end
  function ENT:CustomThink() end
  function ENT:CustomDraw() end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)