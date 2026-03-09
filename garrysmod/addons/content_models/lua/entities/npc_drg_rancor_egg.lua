if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Rancor Hatchling"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_egg.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(1, 1, 1)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1000
ENT.HealthRegen = 5
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
ENT.MeleeAttackRange = 80
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}
ENT.Frightening = true
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

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
ENT.RunAnimRate = 1.2
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 0
ENT.RunSpeed = 0

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
ENT.PossessionEnabled = false
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_1DIR
ENT.PossessionViews = {}
ENT.PossessionBinds = {}

game.AddParticles( "particles/antlion_blood.pcf" )
PrecacheParticleSystem( "AntlionGib" )

if SERVER then

  function ENT:CustomInitialize() 
	self:SetDefaultRelationship(D_LI)
  end
  
  function ENT:CustomThink() end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
  function ENT:OnMeleeAttack(enemy)
  if self:GetModel() == "models/swtor/npcs/rancor_egg.mdl" then return end
  if (math.random(1,2) == 1 and fullsize) then
	local oldpos = enemy:GetPos()
	local curHealth = self:Health()
	
	local matrix = self:GetBoneMatrix(51)
	local handpos = matrix:GetTranslation()
	local reset_angles = Angle(0,0,0)
	local grabbed = false
	
	self:PlaySequenceAndMove( "swipe_attack", 1, self.FaceEnemy )
	
	local dist = 300 * 300
	local vec = self:GetPos()
	local enemyDist = enemy:GetPos()
	if vec:DistToSqr(enemyDist) < dist then
		if IsValid( enemy ) then
			enemy:SetMoveType( MOVETYPE_NONE )
			enemy:SetParent(self, 51)
			enemy:Fire("SetParentAttachment", "RightHand", 0.1, self, self)
			grabbed = true
		end
	end
	self:EmitSound("fallenlogic/rancor/chew1.mp3")
	self:PlaySequenceAndMove("rancor_eat", 1, self.FaceForward)
	if math.random(1,10) != 10 then
		local can_escape = false
	end
	if ( self:Health() < curHealth and grabbed and can_escape) then
		enemy:SetParent(NULL,-1)
		enemy:SetAngles( reset_angles )
		enemy:SetPos( oldpos )
	elseif grabbed and not can_escape then 
		enemy:TakeDamage(enemy:GetMaxHealth(), self, enemy)
		enemy:SetParent(NULL,-1)
		enemy:SetAngles( reset_angles )
		enemy:SetPos( oldpos )
	end
	
	
	if enemy:IsPlayer() then
		enemy:SetMoveType(MOVETYPE_WALK)
	elseif ( enemy:GetClass() == "npc_turret_floor" ) then
		enemy:Remove()
	else
		enemy:SetMoveType(MOVETYPE_STEP) end
	
	
	
  else 	
  
  self:PlaySequenceAndMove("default_attack", 1, self.FaceEnemy)
	
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
  function ENT:OnSpawn() 

	
	timer.Simple( 15, function() 
		if self:IsValid() then
			ParticleEffect( "AntlionGib", self:GetPos(), Angle( 0, 0, 0 ) )
			self:SetSkin(math.random(0,9))
			self:SetModelScale(0.2)
			self:SetModel("models/swtor/npcs/rancor_a01.mdl")
			self.OnIdleSounds = {"fallenlogic/rancor/breath_loop.wav"}
			--self.CollisionBounds = Vector(0.03, 0.03, 0.03)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			self:SetModelScale(self:GetModelScale() * 3, 90)
			self.WalkSpeed = 100
			self.RunSpeed = 200
			--this doesn't work, but the check that relies on it for 1-hit kills would be too OP anyway. 
			-- It can be disabled by removing the "and fullsize" from the OnMeleeAttack method
			self.fullsize = true 
			end
			end)
		--self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Called outside the coroutine
  function ENT:OnTakeDamage(dmg, hitgroup)
    self:SpotEntity(dmg:GetAttacker())
	self:AddEntityRelationship(dmg:GetAttacker(), D_HT, 99)
  end
  function ENT:OnFatalDamage(dmg, hitgroup) end
  
  -- Called inside the coroutine
  function ENT:OnTookDamage(dmg, hitgroup) end
  
  function ENT:OnDeath(dmg, hitgroup) 
	--self:EmitSound("fallenlogic/rancor/death1.mp3")
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