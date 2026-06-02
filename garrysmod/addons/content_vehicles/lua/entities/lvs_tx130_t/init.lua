AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_prediction.lua" )
include("shared.lua")


local WheelMass = 35
local WheelRadius = 25
local WheelPos = {
		Vector(-100,-80,-12),
		Vector(0,-80,-11),
		Vector(100,-80,-7),
		Vector(-100,80,-12),
		Vector(0,80,-11),
		Vector(100,80,-7),
}

ENT.WheelsDestroyed = false
ENT.EngineLockedDueToDamage = false

ENT.SpawnNormalOffset = 120

function ENT:OnDriverChanged(Old, New, VehicleIsActive)
	if VehicleIsActive then
		if not self:GetEngineActive() and self:IsEngineStartAllowed() and not self.EngineLockedDueToDamage then
			self:SetEngineActive(false)
			self:SetMove(0, 0)
		end
	else
		local hasDriver = IsValid(self:GetDriver())
		local hasPassenger = IsValid(self:GetGunnerSeat()) or IsValid(self:GetPassengerSeat())

		if not hasDriver and not hasPassenger and not self.EngineLockedDueToDamage then
			self:SetEngineActive(false)
		end
	end
end

function ENT:OnSpawn()

	local PObj = self:GetPhysicsObject()

	PObj:SetMass( 2500 )
		
    local Driver = self:AddDriverSeat(Vector(-68,27,18), Angle(0,-90,15))
	Driver.ExitPos = Vector(-170, 0, 0)

	local TXGunnerSeat = self:AddPassengerSeat( Vector(0,0,0), Angle(0,-90,0) )
	TXGunnerSeat.ExitPos = Vector(-180, -35, 0)
	self:SetGunnerSeat( TXGunnerSeat )

	local ID = self:LookupAttachment( "driver_turret" )
	local Attachment = self:GetAttachment( ID )
	
	if Attachment then
		local Pos,Ang = LocalToWorld( Vector(0,-60,0), Angle(180,0,-90), Attachment.Pos, Attachment.Ang )
		
		TXGunnerSeat:SetParent( NULL )
		TXGunnerSeat:SetPos( Pos )
		TXGunnerSeat:SetAngles( Ang )
		TXGunnerSeat:SetParent( self, ID )
	end
	
	local EyeAngles = Angle(0,0,0)

	local Pod = self:AddPassengerSeat( Vector(-68,-23,18), Angle(0,-90,15) )
	Pod.ExitPos = Vector(-180, 35, 0)
	self:SetSecondGunnerSeat( Pod )

	self.SpawnedWheels = {}

	for _, Pos in pairs( WheelPos ) do 
		local wheel = self:AddWheel( Pos, WheelRadius, WheelMass, 10 )
		if IsValid(wheel) then
			table.insert(self.SpawnedWheels, wheel)
		end
	end

	self:AddEngineSound( Vector(0,0,30) )

	local ID = self:LookupAttachment( "muzzle_left" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDLeft = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/tx130/twincannonlaser.wav", "lvs/tx130/twincannonlaser.wav" )
	self.SNDLeft:SetSoundLevel( 110 )
	self.SNDLeft:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_right" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDRight = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/tx130/twincannonlaser.wav", "lvs/tx130/twincannonlaser.wav" )
	self.SNDRight:SetSoundLevel( 110 )
	self.SNDRight:SetParent( self, ID )
	
	self.SecSND = self:AddSoundEmitter( Vector(-97.79,0,77.35), "lvs/vehicles/laat/ballturret_fire.mp3", "lvs/vehicles/laat/ballturret_fire.mp3" )
	
	self:AddPassengerSeat( Vector(75,-35,16), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(75,35,16), Angle(0,-90,0) )
	
	self:AddArmor( Vector(30,0,25), Angle(20,0,0), Vector(-45,-40,-20), Vector(40,40,10), 750, 500 )
	
	self:AddArmor( Vector(-60,0,30), Angle(0,0,0), Vector(0,-50,-30), Vector(50,50,30), 250, 500 )
	self:AddArmor( Vector(-60,0,40), Angle(0,0,0), Vector(-60,-50,-30), Vector(0,50,30), 10, 500 )
	
	self:AddArmor( Vector(0,80,10), Angle(0,0,0), Vector(-110,-30,-10), Vector(130,10,10), 50, 500 )
	self:AddArmor( Vector(0,-60,10), Angle(0,0,0), Vector(-110,-30,-10), Vector(130,10,10), 50, 500 )

	self:AddTrailerHitch( Vector(-132,0,12), LVS.HITCHTYPE_MALE )
	
	self:AddEngineSound( Vector(18,0,40) )
	
end

function ENT:OnTick()
	self:HatchControl()
	self:RocketHatchControl(self.TargetRocketHatch or 0)
	self:MainGunPoser()
	self:AnimMove()
	self:CheckWheelDamage()
	self:LockRampIfCarried()
end

function ENT:LockRampIfCarried()
	if not self:GetIsCarried() then return end

	self.StartTime = self.StartTime or CurTime()

	local rampOpen = self:GetlvsLockedStatus()
	local progress = Lerp((CurTime() - self.StartTime) / 2, rampOpen and 0 or 1, rampOpen and 1 or 0)

	self:ManipulateBoneAngles(20, Angle(0, 0, -85 * progress))

	if progress > 0 and progress < 1 then
		if not self.HatchSound then
			self.HatchSound = CreateSound(self, "lvs/tx130/back_hatch.wav")
			self.HatchSound:Play()
		end
	else
		if self.HatchSound then
			self.HatchSound:Stop()
			self.HatchSound = nil
		end
	end
end

function ENT:SpawnWreckage()
	local skin = self:GetSkin()
    local wreck = ents.Create("tkaro_tx130w")
    if not IsValid(wreck) then return end 

	wreck:SetSkin(skin)
    wreck:SetPos(self:GetPos())
    wreck:SetAngles(self:GetAngles())
    wreck:Spawn()
    wreck:Activate()
end

function ENT:OnDestroyed()
	self:SpawnWreckage()
end

function ENT:BallturretDamage( target, attacker, HitPos, HitDir )
	if not IsValid( target ) or not IsValid( attacker ) then return end

	if target ~= self then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( 1500 * FrameTime() )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType( bit.bor( DMG_SHOCK, DMG_ENERGYBEAM ) )
		dmginfo:SetInflictor( self ) 
		dmginfo:SetDamagePosition( HitPos ) 
		dmginfo:SetDamageForce( HitDir * 20000 ) 
		target:TakeDamageInfo( dmginfo )
	end
end

function ENT:MainGunPoser()

	local Driver = self:GetDriver()
	local Pod = self:GetDriverSeat()

	if IsValid(Driver) then

		local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
			
		self.MainGunDir = EyeAngles:Forward()
		
		local startpos =  self:LocalToWorld(Vector(-120,0,30))
		local TracePlane = util.TraceHull( {
			start = startpos,
			endpos = (startpos + EyeAngles:Forward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( ent ) 
				if IsValid( ent ) then
					if ent == self or ent:GetClass() == "lvs_laser_green_short" or ent:GetClass() == "lvs_protontorpedo" then 
						return false
					end
				end
				return true
			end
		} )
		
		local AimAnglesG = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(-5,51,43) ) ):GetNormalized():Angle() )
		local AimAnglesL = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(5,51,43) ) ):GetNormalized():Angle() )
		local AimAnglesR = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(5,-51,43) ) ):GetNormalized():Angle() )
		
		
		self:SetPoseParameter("sidegun_pitch", -AimAnglesG.p )
		self:SetPoseParameter("sidegun_left_yaw", -AimAnglesL.y )
		self:SetPoseParameter("sidegun_right_yaw", -AimAnglesR.y )

		local ID = self:LookupAttachment( "muzzle_left" )
		local Muzzle = self:GetAttachment( ID )
	end


	if self:GetBodygroup(1) == 0 then
		self:SetPoseParameter("cannon_pitch", 0 )
		self:SetPoseParameter("cannon_yaw", 0 )

		self:SetBTLFire( false )
	else
		local pod = self:GetGunnerSeat()
		local gunner = pod:GetDriver()
		if IsValid(gunner) then
			local EyeAngles = pod:WorldToLocalAngles( gunner:EyeAngles() )
			local _,LocalAng = WorldToLocal( Vector(0,0,0), EyeAngles, Vector(0,0,0), self:LocalToWorldAngles( Angle(0,0,0)  ) )

			self:SetPoseParameter("cannon_pitch", -LocalAng.p )
			self:SetPoseParameter("cannon_yaw", LocalAng.y )
		end
	end	
end

function ENT:HatchControl()
	local gunners = self:GetGunnerSeat()
	local HasTurret = IsValid( gunners:GetDriver() )
	local Rate = FrameTime() * 5
	self.smHatch = self.smHatch and self.smHatch + math.Clamp((HasTurret and 1 or 0) - self.smHatch,-Rate,Rate) or 0
	if not HasTurret and self.smHatch > 0.7 then self.smHatch = 0.7 end
	self:SetPoseParameter( "open_hatch", self.smHatch )
end

function ENT:RocketHatchControl(target)
    local transitionTime = 1
    local rate = FrameTime() * (1 / transitionTime)

    self.smRocketHatch = self.smRocketHatch or 0
    self.smRocketHatch = self.smRocketHatch + math.Clamp(target - self.smRocketHatch, -rate, rate)
    self:SetPoseParameter("rocket_hatch", self.smRocketHatch)
end

function ENT:OnVehicleSpecificToggled()
   if not self:GetEngineActive() then return end
	local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end
	local DoorMode = self:GetDoorMode() + 1
	self:SetDoorMode( DoorMode )			
	if DoorMode == 1 then
		self.TargetRocketHatch = 1
		self:EmitSound("lvs/tx130/rocketpods_raise.wav")
	elseif DoorMode >= 2 then
		self.TargetRocketHatch = 0
		self:EmitSound("lvs/tx130/rocketpods_lower.wav")
		self:SetDoorMode(0)
	end
end

local BaseClassPhy = baseclass.Get("lvs_base_fakehover")

function ENT:PhysicsCollide(data, physobj)
    
    if BaseClassPhy.PhysicsCollide then
        BaseClassPhy.PhysicsCollide(self, data, physobj)
    end
	
	local health = self:GetHP()
	if health <= 1000 then
		if not self.HasHitGround and data.Speed > 200 and data.DeltaTime > 0.2 then
			local pos = data.HitPos

			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetEntity(self)
			effectdata:SetMagnitude(5)
			effectdata:SetScale(200)
			util.Effect("ThumperDust", effectdata)

			self.HasHitGround = true
		end
	end
end

function ENT:CheckWheelDamage()
	local health = self:GetHP()

	if not self.SpawnedWheels then self.SpawnedWheels = {} end
	
	if health <= 1500 then
		self.BoostAddVelocityX = 0
		self.BoostAddVelocityY = 0
	else
		self.BoostAddVelocityX = 195
		self.BoostAddVelocityY = 195
	end
	
	if health <= 1000 then
		if not self.ErrorSound then
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos())
			effectdata:SetEntity( self )
			effectdata:SetMagnitude(5)
			effectdata:SetScale(200)
			util.Effect( "ThumperDust", effectdata )
				
			self:EmitSound("lvs/tx130/error.wav", 75, 100, 0.7)
			self.ErrorSound = true
		end
		
		self:SetBodygroup(2,1)
		
		if not self.WheelsDestroyed then
			self.WheelsDestroyed = true

			if self:GetEngineActive() then
				self:StopEngine()
			end

			self.EngineLockedDueToDamage = true
		
			for _, wheel in ipairs(self.SpawnedWheels) do
				if IsValid(wheel) then
					wheel:Remove()
				end
			end
			self.SpawnedWheels = {}
		end
	else
		self.ErrorSound = false
		self:SetBodygroup(2,0)
		if self.WheelsDestroyed then
			self.WheelsDestroyed = false

			self.EngineLockedDueToDamage = false
			
			self:SetPos(self:GetPos() + Vector(0, 0, 33))
			
			for _, pos in ipairs(WheelPos) do
				local wheel = self:AddWheel(pos, WheelRadius, WheelMass, 10)
				if IsValid(wheel) then
					table.insert(self.SpawnedWheels, wheel)
				end
			end
		end
	end
end

function ENT:IsEngineStartAllowed()
	if self.EngineLockedDueToDamage then
		return false
	end

	if hook.Run("LVS.IsEngineStartAllowed", self) == false then return false end
	if self:WaterLevel() > (self.WaterLevelPreventStart or 2) then return false end

	return true
end

function ENT:AnimMove()
	local phys = self:GetPhysicsObject()

	if not IsValid( phys ) then return end

	local steer = phys:GetAngleVelocity().z

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() / 1.2 )  

	self:SetPoseParameter( "move_x", math.Clamp(-VelL.x / self.MaxVelocityX,-1,1) )
	self:SetPoseParameter( "move_y", math.Clamp(-VelL.y / self.MaxVelocityY + steer / 100,-1,1) )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/tx130/twincannon_activate.wav" )
	else
		self:EmitSound( "lvs/tx130/twincannon_deactivate.wav" )
	end
end

function ENT:OnCreateAI()
    self:Lock()
    self:StartEngine()
end

function ENT:OnRemoveAI()
    self:UnLock()
    self:StopEngine()
end
