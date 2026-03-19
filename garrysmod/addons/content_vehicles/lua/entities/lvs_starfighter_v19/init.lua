AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25
ENT.GearDeployHeight = 200
ENT.GearEaseSpeed = 1
ENT.WingsExponent = 2

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2000 )

	local DriverSeat = self:AddDriverSeat( Vector(35,0,7), Angle(0,-90,9) )

	local DoorHandler = self:AddDoorHandler( "canopy", Vector(0,0,0) )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( DriverSeat )

    DoorHandler:SetPoseMin( 1 )
    DoorHandler:SetPoseMax( 0 ) 

	self:AddEngine( Vector(-69,83,12) )
	self:AddEngine( Vector(-69,-83,12) )
	self:AddEngineSound( Vector(0,0,12) )

	self.PrimarySND = self:AddSoundEmitter( Vector(49.91, 0, -42.09), "lvs/weapon/v19/v19_shoot.wav", "lvs/weapon/v19/v19_shoot.wav" )
	self.PrimarySND:SetSoundLevel( 110 )

	self:SetWingsDown(false)
	self._WingsTarget = 0
    self._WingsValue = 0
	self:SetMaxThrottle(0.25)
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end

function ENT:HandleLandingGear()
	self.GearPose = self.GearPose or 0

	local dist = self:GetGroundDistance()
	local shouldDeploy = dist >= self.GearDeployHeight

	local target = shouldDeploy and 0 or 1

	local dt = FrameTime()
	local oldPose = self.GearPose
	self.GearPose = math.Approach(
		self.GearPose,
		target,
		dt * self.GearEaseSpeed
	)

	if self.GearPose ~= oldPose then
		if (oldPose <= 0.05 and self.GearPose > 0.05) or (oldPose >= 0.95 and self.GearPose < 0.95) then
			self:EmitSound("lvs/vehicles/atte/hydraulic4.ogg")
		end
	end

	self:SetBodygroup( 7, self.GearPose )

	if not shouldDeploy and self.GearPose > 0.05 then
		self:SetBodygroup(1,0)
		self:SetWingsDown(false)
		self._WingsTarget = 0
	elseif shouldDeploy and self.GearPose < 0.05 then
		self:SetBodygroup(1,1)
	end
end

function ENT:OnVehicleSpecificToggled()
	local dist = self:GetGroundDistance()
	local shouldDeploy = dist >= self.GearDeployHeight
	if shouldDeploy then
		self:SetWingsDown( not self:GetWingsDown() )
		self._WingsTarget = self:GetWingsDown() and 1 or 0
		self:SetMaxThrottle(self:GetWingsDown() and 1 or 0.25)
		self:EmitSound(self:GetWingsDown() and "lvs/vehicles/laat/door_large_close.wav" or "lvs/vehicles/laat/door_large_open.wav")
	end
end

function ENT:AnimWings()
    self._WingsTarget = self._WingsTarget or 0
    self._WingsValue = self._WingsValue or 0

    local ft = FrameTime()
    local seconds = 1

    local step = ft / seconds
    local diff = self._WingsTarget - self._WingsValue

    if math.abs(diff) > step then
        local dir = diff > 0 and 1 or -1
        self._WingsValue = self._WingsValue + dir * step
    else
        self._WingsValue = self._WingsTarget
    end

    local eased = self._WingsValue ^ self.WingsExponent
    self:SetPoseParameter("wings", eased)
end

function ENT:OnTick()
	self:HandleLandingGear()
	self:AnimWings()
end