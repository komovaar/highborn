AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

util.AddNetworkString("lvs_vehicle_disabled")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 25000 )
    
    self:SetSkin(self.Skin or 0)
	self:SetWingsDown(false)

    local DriverSeat = self:AddDriverSeat( Vector(400,0,130), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(510,30,10)
	DriverSeat:SetCameraDistance(3.5)
    self:SetDriverSeat(DriverSeat)

    local GunnerSeat = self:AddPassengerSeat( Vector(362,0,150), Angle(0,-90,0) )
	GunnerSeat.ExitPos = Vector(510,-30,10)
	GunnerSeat:SetCameraDistance(3.5)

    local numSeats = 14
    local exitXStart = 540
    local exitZ = 10
    local exitSpacing = 20

    local exitYPositions = {-60, -30, 0, 30, 60}

    for i = 1, numSeats do
        local seat = self:AddPassengerSeat(Vector(0, 0, 120), Angle(0, -90, 0))
        
        local exitX = exitXStart + (i - 1) * exitSpacing
        local exitY = exitYPositions[(i - 1) % #exitYPositions + 1]
        seat.ExitPos = Vector(exitX, exitY, exitZ)
        seat.HidePlayer = true
    end

	self.PrimarySND = self:AddSoundEmitter( Vector(675,0, -15), "lvs/vehicles/naboo_n1_starfighter/fire.mp3", "lvs/vehicles/naboo_n1_starfighter/fire.mp3" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SecondarySND = self:AddSoundEmitter( Vector(675,0, -15), "lvs/vehicles/rho_class/gbran.wav", "lvs/vehicles/rho_class/gbran.wav" )
	self.SecondarySND:SetSoundLevel( 110 )
	
	self:AddEngine( Vector(-480,-160,65) )
	self:AddEngine( Vector(-480,-132,77) )
	self:AddEngine( Vector(-480,-103,91) )
	self:AddEngine( Vector(-480,160,65) )
	self:AddEngine( Vector(-480,132,77) )
	self:AddEngine( Vector(-480,103,91) )

	self:AddEngine( Vector(-460,-36,96) )
	self:AddEngine( Vector(-460,-36,152) )

	self:AddEngine( Vector(-460,36,96) )
	self:AddEngine( Vector(-460,36,152) )

	self:AddEngineSound( Vector(-460,0,96) )

    self:SetSpotlightToggle(false)
    self:SetHatchOpen(true)
	self:SetDisabled(false)
    self:SetMaxThrottle(0.5)

    self.NextSparkTime = 0 
    self.LocalEngineScale = 0

    self.smHatch = self.smHatch or 0
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:SetEngineEffectScale( 2.5 )
		self:EmitSound( "lvs/vehicles/rho_class/poweron.mp3")
        self:EmitSound( "lvs/vehicles/rho_class/startup.wav")
	else
		self:SetEngineEffectScale( 0 )
		self:EmitSound( "lvs/vehicles/rho_class/powerdown_amb.mp3" )
        self:EmitSound( "lvs/vehicles/rho_class/shutdown.wav" )
	end
end

function ENT:OnVehicleSpecificToggled()
	if not self:GetWingsDown(false) then
		self:EmitSound("lvs/vehicles/rho_class/sfoils.mp3")
		self:SetMaxThrottle(1)
		self:SetWingsDown(true)
	else
        if self:GetThrottle() <= 0.5 then
            self:EmitSound("lvs/vehicles/rho_class/sfoils.mp3")
            self:SetMaxThrottle(0.5)
            self:SetWingsDown(false)
        else
            self:EmitSound("LVS.LAAT.GRABBER_CANTDROP")
        end
	end
end

function ENT:OnRemoved()
end

function ENT:HitGround()
	local tr = util.TraceLine( {
		start = self:LocalToWorld( Vector(0,0,100) ),
		endpos = self:LocalToWorld( Vector(0,0,-20) ),
		filter = function( ent ) 
			if ( ent == self ) then 
				return false
			end
		end
	} )

	return tr.Hit 
end

-- Hello devs, here is the crash system
ENT._BaseExplode = ENT._BaseExplode or ENT.Explode

function ENT:OnDestroyed()
    if self.CrashSystemActivated then return end
    self.CrashSystemActivated = true
    self.HasCrashed = false

    self:SetEngineActive(false)
    self:SetThrottle(0)
    
    self.Destroyed = true
    
    self:SetDisabled(true)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableGravity(true)
        phys:Wake()
    end
end

function ENT:IsEngineStartAllowed()
    if self.CrashSystemActivated then return false end
    if self:GetDisabled() then return false end
    if hook.Run("LVS.IsEngineStartAllowed", self) == false then return false end
    if self:WaterLevel() > self.WaterLevelPreventStart then return false end
    return true
end

function ENT:PhysicsCollide(data, phys)
    if not self.CrashSystemActivated then return end
    if self.HasCrashed then return end
    if data.Speed < 200 then return end

    self.HasCrashed = true

    local fx = EffectData()
    fx:SetOrigin(self:GetPos())
    fx:SetScale(5)
    fx:SetEntity(self)
    util.Effect("lvs_explosion", fx)

    local attacker = self.FinalAttacker or self
    if IsValid(self:GetDriver()) then
        attacker = self:GetDriver()
    end

    util.BlastDamage(self, attacker, self:GetPos(), 500, 100)
    self:EmitSound("lvs/vehicles/generic/explosion_large.wav", 140, 100)

    self:SetEngineActive(false)
    self:SetEngineEffectScale( 0 )
    self:SetThrottle(0)
end

function ENT:Explode()
    -- if self.CrashSystemActivated then
    --     return
    -- end

    if self._BaseExplode then
        return self:_BaseExplode()
    end

    if self:GetHP() > -(self:GetMaxHP() * 0.25) then
        return
    end

    if self.ExplodedAlready then return end
    self.ExplodedAlready = true

    local Driver = self:GetDriver()
    if IsValid(Driver) then
        self:HurtPlayer(Driver, Driver:Health() + Driver:Armor(), self.FinalAttacker, self.FinalInflictor)
    end

    if istable(self.pSeats) then
        for _, seat in pairs(self.pSeats) do
            local psgr = IsValid(seat) and seat:GetDriver()
            if IsValid(psgr) then
                self:HurtPlayer(psgr, psgr:Health() + psgr:Armor(), self.FinalAttacker, self.FinalInflictor)
            end
        end
    end

    self:OnFinishExplosion()
    self:Remove()
end

function ENT:RecoverFromCrash()
    self.Destroyed = false

    self:SetEngineActive(false)
    self:SetEngineEffectScale( 0 )
    self:SetThrottle(0)

    self:SetDisabled(false)
    self.CrashSystemActivated = false
    self.HasCrashed = false
    self.ExplodedAlready = false

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        local ang = self:GetAngles()
        ang.p = 0
        ang.r = 0

        self:SetAngles(ang)
        phys:SetAngles(ang)

        phys:SetVelocity(Vector(0, 0, 0))
        phys:SetAngleVelocity(Vector(0, 0, 0))

        phys:EnableGravity(true)

        phys:Wake()
    end
end

function ENT:OnTick()
    local rate = FrameTime() * 2
    local target = self:GetHatchOpen() and 1 or 0

    self.smHatch = self.smHatch or 0
    self.smHatch = math.Approach(self.smHatch, target, rate)

    self:SetPoseParameter("hatch", self.smHatch)

    if not self.CrashSystemActivated then return end

    local hp = self:GetHP()
    local max = self:GetMaxHP()

    if hp <= -(max * 0.75) then
        self:Explode()
    end

    if hp >= (max * 0.25) then
        self:SetHP(max * 0.26)
        self:RecoverFromCrash()
    end
end