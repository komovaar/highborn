ENT.Type = "anim"
ENT.Base = "lvs_base_fakehover"

ENT.PrintName = "TX-130 / TX-130T"
ENT.Author = "Tkaro + Dec"
ENT.Information = "Republic Fighter Tank"
ENT.Category = "[LVS] SW-Vehicles"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/tkaro/starwars/vehicle/tx130/tx130.mdl"
ENT.GibModels = {
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_charge_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_flap_gib.mdl",
    "models/tkaro/starwars/vehicle/tx130/gibs/tx130_hatch_gib.mdl",
	--"models/tkaro/starwars/vehicle/tx130/gibs/tx130_main_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_sidegun_gib_1.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_sidegun_gib_2.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_model_turret_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_wing_gib_1.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_wing_gib_2.mdl",
}

ENT.AITEAM = 2

ENT.ForceAngleMultiplier = 3
ENT.ForceAngleDampingMultiplier = 3

ENT.ForceLinearMultiplier = 3
ENT.ForceLinearRate = 3

ENT.SpawnNormalOffset = 50

ENT.MaxHealth = 4000
ENT.MaxShield = 0
ENT.MaxVelocityX = 100
ENT.MaxVelocityY = 100
ENT.BoostAddVelocityX = 195
ENT.BoostAddVelocityY = 195
ENT.IgnoreWater = false

ENT.MaxTurnRate = 1
ENT.RotorPos = Vector(-68,0,18)

ENT.GroundTraceLength = 50
ENT.GroundTraceHull = 100


function ENT:OnSetupDataTables()

	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "SecondGunnerSeat" )
	self:AddDT("Bool", "IsCarried")
	
	self:NetworkVar( "Int",18, "DoorMode" )
	self:NetworkVar( "Bool",19, "BTLFire" )
	self:NetworkVar( "Bool",21, "RearHatch" )
	self:NetworkVar( "Bool",22, "WeaponOutOfRange" )
	self:NetworkVar( "Bool",23, "FrontInRange" )
	
	if SERVER then
        self:NetworkVarNotify("IsCarried", self.OnIsCarried)
    end
    self:NetworkVarNotify("lvsLockedStatus", self.OnLockChanged)
	
end

function ENT:OnLockChanged()
    self.StartTime = CurTime()
end

function ENT:CalcMainActivityPassenger( ply )
end

function ENT:CalcMainActivity( ply )
	local guner = self:GetGunnerSeat()

    if ply ~= guner:GetDriver() then return self:CalcMainActivityPassenger( ply ) end

    if ply.m_bWasNoclipping then 
        ply.m_bWasNoclipping = nil 
        ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
        
        if CLIENT then 
            ply:SetIK( true )
        end 
    end 

    ply.CalcIdeal = ACT_STAND
    ply.CalcSeqOverride = ply:LookupSequence( "idle_all_02" )

    return ply.CalcIdeal, ply.CalcSeqOverride
end

sound.Add( {
	name = "LVS.TX.PASSBY",
	sound = {
		"lvs/tx130/txpassby1.wav",
		"lvs/tx130/txpassby2.wav",
		"lvs/tx130/txpassby3.wav",
		"lvs/tx130/txpassby4.wav",
		"lvs/tx130/txpassby5.wav",
		"lvs/tx130/txpassby6.wav",
	}
} )

ENT.FlyByAdvance = 1
ENT.FlyBySound = "LVS.TX.PASSBY"

ENT.EngineSounds = {
	{
		channel = CHAN_STATIC,
		volume = 1.1,
		level = 100,
		sound = "lvs/tx130/engine.wav",
		sound_int = "lvs/tx130/interior.wav"
	},
	{
		sound = "^lvs/tx130/dist.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0.35,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 110,
	},
}

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_DROP_IN_AIR = true
ENT.LAATC_PICKUP_POS = Vector(-200,0,30)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

function ENT:HandleShoot(FireInput, active, ent)
	self.charge = self.charge or 0
	self._ChargeTime = self._ChargeTime or 12
	self._MaxCharge = 100
	self._CooldownTime = self._CooldownTime or 5

	if self._CoolingDown then
		local coolRate = FrameTime() * (100 / self._CooldownTime)
		self.charge = math.max(self.charge - coolRate, 0)
		self:SetHeat(math.Clamp(self.charge / self._MaxCharge, 0, 1))

		if self.charge <= 0 then
			self._CoolingDown = false
			self:SetOverheated(false)
		end
		return
	end

	if self.charging then
		self.charge = math.min(self.charge + FrameTime() * (100 / self._ChargeTime), self._MaxCharge)
		local progress = self.charge / self._MaxCharge

		if progress >= 0.5 and not self._ElectroPlayed then
			self._ElectroPlayed = true
			if self._ChargeElectroSound then
				self._ChargeElectroSound:Play()
				self._ChargeElectroSound:SetSoundLevel(70)
				self._ChargeElectroSound:ChangeVolume(1, 0)
			end
		end

		if self._ChargeSound then
			self._ChargeSound:ChangePitch(80 + progress * 50, 0.1)
		end

		if self.charge >= self._MaxCharge and not self._ChargedSoundPlayed then
			self._ChargedSoundPlayed = true
			self:EmitSound("lvs/tx130/chargeready.wav")
			self:ShootChargedBeam()

			self._CoolingDown = true
			self:SetOverheated(true)
			self.charge = self._MaxCharge
			self.charging = false
			self._WasCharging = false
		end
	else
		if FireInput and not self._CoolingDown then
			self:ChargeGun()
		else
		self.charge = math.max(self.charge - FrameTime() * 25, 0)
		
		if self._WasCharging and not self._CoolingDown and self.charge > 0 then
			self._WasCharging = false
			self:EmitSound("lvs/tx130/chargeerror.wav")
			end
		end
	end

	if not active then return end

	self:SetHeat(math.Clamp(self.charge / self._MaxCharge, 0, 1))

	self:HandleChargeVFX()
end

function ENT:ChargeGun()
	if not self:GetEngineActive() or self:GetIsCarried() then return end

	self._doAttack = true
	self.charging = true
	self._WasCharging = true
	self._ChargedSoundPlayed = false
	self._ElectroPlayed = false

	if not self._ChargeSound then
		self._ChargeSound = CreateSound(self, "lvs/tx130/chargeloop.wav")
	end
	if not self._ChargeElectroSound then
		self._ChargeElectroSound = CreateSound(self, "lvs/tx130/chargeelectro.wav")
	end

	if self._ChargeSound then
		self._ChargeSound:Play()
		self._ChargeSound:SetSoundLevel(70)
		self._ChargeSound:ChangeVolume(1, 0)
		self._ChargeSound:ChangePitch(80, 0)
	end
end


function ENT:FinishShoot(ent)
	ent:TakeAmmo()
	self._doAttack = nil
	self.charging = nil

	if self._ChargeSound then self._ChargeSound:Stop() end
	if self._ChargeElectroSound then self._ChargeElectroSound:Stop() end
end


function ENT:HandleChargeVFX()
	if not self.charging or self:GetOverheated() then return end

	self.nextChargeVFX = self.nextChargeVFX or 0
	if CurTime() < self.nextChargeVFX then return end
	self.nextChargeVFX = CurTime() + 0.05

	local chargeProgress = self.charge / (self._MaxCharge or 100)

	local boneOffsets = {
		left_gun_pitch = {
			Vector(10, 6, -20),
			Vector(10, 0, -20),
			Vector(10, 6, 39),
			Vector(10, 0, 160),
		},
		right_gun_pitch = {
			Vector(-10, 6, -20),
			Vector(-10, 0, -20),
			Vector(-10, 6, 39),
			Vector(-10, 0, 160),
		},
	}

	for boneName, offsets in pairs(boneOffsets) do
		local boneID = self:LookupBone(boneName)
		if not boneID then continue end

		local pos, ang = self:GetBonePosition(boneID)
		if not pos or not ang then continue end

		local numEffects = math.ceil(#offsets * chargeProgress)

		for i = 1, numEffects do
			local localOffset = offsets[i]
			local worldPos = LocalToWorld(localOffset, Angle(0, 0, 0), pos, ang)

			local fx = EffectData()
			fx:SetOrigin(worldPos)
			fx:SetEntity(self)
			fx:SetStart(localOffset)
			util.Effect("tx_130_charge_s", fx)
		end
	end
end

function ENT:ShootChargedBeam()
	local ID_L = self:LookupAttachment("muzzle_left")
	local ID_R = self:LookupAttachment("muzzle_right")
	local MuzzleL = self:GetAttachment(ID_L)
	local MuzzleR = self:GetAttachment(ID_R)

	if not MuzzleL or not MuzzleR then return end

	self:EmitSound("lvs/tx130/chargefire.wav")

	local bullet = {
		Spread = Vector(0.01, 0.01, 0.01),
		TracerName = "lvs_laser_blue_long",
		Force = 10000,
		HullSize = 1,
		Damage = 1000,
		Velocity = 40000,
		Attacker = self:GetDriver(),
		Callback = function(att, tr, dmginfo)
			local hitEnt = tr.Entity

			if IsValid(hitEnt) and hitEnt.GetAI and hitEnt:GetAI() and hitEnt.LVS or hitEnt.LFS then
				hitEnt:StopEngine()
				if hitEnt.SetShield then
					hitEnt:SetShield(0)
				end

				timer.Simple(5, function()
					if IsValid(hitEnt) then
						hitEnt:StartEngine()
					end
				end)
			end
		end
	}

	for _, Muzzle in pairs({ MuzzleL, MuzzleR }) do
		local fx = EffectData()
		fx:SetStart(Vector(50, 50, 255))
		fx:SetOrigin(Muzzle.Pos)
		fx:SetNormal(Muzzle.Ang:Up())
		fx:SetEntity(self)
		util.Effect("lvs_muzzle_colorable", fx)

		bullet.Src = Muzzle.Pos
		bullet.Dir = Muzzle.Ang:Up()
		self:LVSFireBullet(bullet)
	end

	self.charge = 0
	self:SetHeat(1)

	self.charging = nil
	self._WasCharging = nil
	self._ChargedSoundPlayed = false
	self._ElectroPlayed = false
end


function ENT:InitWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)
	self.curfire = false

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/dual_mg.png")
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0.40
	weapon.HeatRateDown = 0.8
	weapon.Ammo = 500
	weapon.Attack = function( ent )
	   if not self:GetEngineActive() then return end
		if self:GetIsCarried() then return end
		
		local ID_L = self:LookupAttachment( "muzzle_left" )
		local ID_R = self:LookupAttachment( "muzzle_right" )
		local MuzzleL = self:GetAttachment( ID_L )
		local MuzzleR = self:GetAttachment( ID_R )
		
		if not MuzzleL or not MuzzleR then return end
	
		self.MirrorPrimary = not self.MirrorPrimary
	
		local Pos = self.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos
		local Dir = (self.MirrorPrimary and MuzzleL.Ang or MuzzleR.Ang):Up()
		
		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_red_short"
		bullet.Force	= 10000
		bullet.HullSize 	= 1
		bullet.Damage	= 150
		bullet.SplashDamage	= 100
		bullet.SplashDamageRadius	= 200
		bullet.Velocity = 	40000
		bullet.Attacker = ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_concussion_explosion", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(50,50,255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )
		
		ent:LVSFireBullet( bullet )
		
		if ent.MirrorPrimary then
			ent:PlayAnimation( "gun_l_anim" )
	
			if not IsValid( ent.SNDLeft ) then return end
	
			ent.SNDLeft:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
			ent:TakeAmmo()

			return
		end

		ent:PlayAnimation( "gun_r_anim" )
		ent:TakeAmmo()
		if not IsValid( ent.SNDRight ) then return end

		ent.SNDRight:PlayOnce( 100 + math.sin( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

	end
	weapon.OnThink = function( ent, active )
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	
	self:AddWeapon( weapon )
	
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/laserbeam.png")
	weapon.Ammo = 25
	weapon.Delay = 4
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.25
	weapon.StartAttack = function(ent)
		ent:ChargeGun()
	end
	weapon.FinishAttack = function(ent)
		ent:FinishShoot(ent)
	end
	weapon.Attack = function(ent) end
	weapon.OnThink = function(ent, active)
	if not active then return end
		ent:HandleShoot(ent._doAttack and active, active, ent)
	end
	weapon.OnSelect = function(ent)
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function(ent)
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.HudPaint = function(ent, X, Y, ply)
		local Col = (ent:AngleBetweenNormal(ent:GetAimVector(), ent:GetForward()) > 360) and COLOR_RED or COLOR_WHITE
		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter(Pos2D, Col)
		base:PaintCrosshairOuter(Pos2D, Col)
		base:LVSPaintHitMarker(Pos2D)
	end

	self:AddWeapon(weapon)


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.Ammo = 20
	weapon.Delay = 0.3
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.9
	weapon.Attack = function( ent )
	   if not self:GetEngineActive() then return end
	   if self:GetIsCarried() then return end
		timer.Simple( 0, function()
			if self:GetDoorMode() == 0 then return end
		
			local ID1 = self:LookupAttachment( "left_launch_tube_1" )
			local ID2 = self:LookupAttachment( "right_launch_tube_1" )
			local ID3 = self:LookupAttachment( "left_launch_tube_2" )
			local ID4 = self:LookupAttachment( "right_launch_tube_2" )
			local ID5 = self:LookupAttachment( "left_launch_tube_3" )
			local ID6 = self:LookupAttachment( "right_launch_tube_3" )
			local ID7 = self:LookupAttachment( "left_launch_tube_4" )
			local ID8 = self:LookupAttachment( "right_launch_tube_4" )
			local ID9 = self:LookupAttachment( "left_launch_tube_5" )
			local ID10 = self:LookupAttachment( "right_launch_tube_5" )
		
			local Muzzle1 = self:GetAttachment( ID1 )
			local Muzzle2 = self:GetAttachment( ID2 )
			local Muzzle3 = self:GetAttachment( ID3 )
			local Muzzle4 = self:GetAttachment( ID4 )
			local Muzzle5 = self:GetAttachment( ID5 )
			local Muzzle6 = self:GetAttachment( ID6 )
			local Muzzle7 = self:GetAttachment( ID7 )
			local Muzzle8 = self:GetAttachment( ID8 )
			local Muzzle9 = self:GetAttachment( ID9 )
			local Muzzle10 = self:GetAttachment( ID10 )
			
			local FirePos = {
				[1] = Muzzle1,
				[2] = Muzzle2,
				[3] = Muzzle3,
				[4] = Muzzle4,
				[5] = Muzzle5,
				[6] = Muzzle6,
				[7] = Muzzle7,
				[8] = Muzzle8,
				[9] = Muzzle9,
				[10] = Muzzle10,
			}
			
			if not FirePos then return end
			self.FireIndex2 = self.FireIndex2 and self.FireIndex2 + 1 or 1
			if self.FireIndex2 > 10 then
				self.FireIndex2 = 1
			end
			self:EmitSound( "lvs/tx130/rocket.wav" )

		
			local Pos = FirePos[self.FireIndex2].Pos
			if not IsValid( ent ) then return end

			if ent:GetAmmo() <= 0 then ent:SetHeat( 1 ) return end
			ent:TakeAmmo()
			local Dir =  FirePos[self.FireIndex2].Angle

			local trace = ent:GetEyeTrace()

			local Driver = self:GetDriver()

			local Pos = self:WorldToLocal( Pos ) + Vector(25,0,10)	
			local projectile = ents.Create( "lvs_missile" )
			projectile:SetPos( self:LocalToWorld(Pos) )
			projectile:SetAngles( self:GetAngles() )
			projectile:SetParent( ent )
			projectile:Spawn()
			projectile:Activate()
			projectile.GetTargetPos = function( projectile )
				return projectile:LocalToWorld( Vector(150,0,0) + VectorRand() * math.random(-5,5) )
			end
			projectile:SetAttacker(Driver)
			projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
			projectile:SetDamage( 1500 )
			projectile:SetRadius( 300 )
			projectile:Enable()

			ent:SetHeat( 1 )
			ent:SetOverheated( true )

			for i=1,2 do
				local effectdata = EffectData()
				effectdata:SetOrigin(  self:LocalToWorld(Pos - Vector(0,0,30)) )
				effectdata:SetRadius(80 * 80)
				effectdata:SetScale(10 * 10)
				util.Effect( "ThumperDust", effectdata, true, true )
			end

		end)
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 30) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("weapons/shotgun/shotgun_cock.wav")
	end
	self:AddWeapon( weapon )

   local weapon = {}
    weapon.Icon = Material("lvs/weapons/gunship_reardoor.png")
    weapon.Ammo = 0
    weapon.Delay = 2
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.UseableByAI = false
    weapon.Attack = function(ent)
        if self:GetIsCarried() or self:GetAI() then return end

        if self:GetlvsLockedStatus() then
            self:UnLock()
            return
        end
        self:Lock()
    end
    weapon.OnSelect = function(ent)
        ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
    end
	weapon.OnThink = function(ent, active)
        if self:GetDisabled() then return end

        if self:GetIsCarried() then
            ent.IsRampOpen = false
            return
        end

        if not ent.StartTime then return end

        local rampOpen = not self:GetlvsLockedStatus()
       local progress = Lerp((CurTime() - ent.StartTime) / 2, rampOpen and 0 or 1, rampOpen and 1 or 0)


	self:ManipulateBoneAngles(20, Angle(0, 0, -85 * progress))

	self.HatchSound = self.HatchSound or nil

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
	
    self.StartTime = CurTime()
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/laserbeam.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0.8
	weapon.HeatRateDown = 0.4
	weapon.Attack = function( ent )
	   if not self:GetEngineActive() then return end
	   if self:GetIsCarried() then return end
		local Pod = self:GetGunnerSeat()
		local Driver = Pod:GetDriver()
		if self:GetBodygroup(1) == 1 then
			if IsValid( Driver ) and IsValid( Pod ) then
				local veh = ent:GetVehicle()
				self:SetBTLFire( true )
				if self.curfire == false then
					veh.SecSND:PlayOnce()
					self.curfire = true
				end
				
				local ID = self:LookupAttachment( "lazer_cannon_muzzle" )
				local Muzzle = self:GetAttachment( ID )
							
				local Dir = Muzzle.Ang:Up()
				local startpos = Muzzle.Pos
						
				local Trace = util.TraceLine( {
					start = startpos,
					endpos = (startpos + Dir * 50000),
				} )
					
				self:BallturretDamage( Trace.Entity, Driver, Trace.HitPos, Dir )
			end
		end
	end
	weapon.FinishAttack = function( ent )
		self:SetBTLFire( false )
		self.curfire = false
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if self:GetBodygroup(1) == 1 then

			local Pos2D = base:TraceBTL().HitPos:ToScreen()

			base:PaintCrosshairCenter( Pos2D, color_white )
			base:PaintCrosshairOuter( Pos2D, color_white )
			base:LVSPaintHitMarker( Pos2D )
		end
	end
	self:AddWeapon( weapon, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/laserbeam.png")
	weapon.Ammo = -1
	weapon.Delay = 1.5
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.4
	weapon.StartAttack = function( ent )
		if (self.turmount) then
			self.turmount = false
			self:SetBodygroup(1, 0)
		else
			self:SetBodygroup(1, 1)
			self.turmount = true
		end
	end
	self:AddWeapon( weapon, 3 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tx_spotlight.png")
	weapon.Ammo = -1
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.StartAttack = function( ent )
	   if not self:GetEngineActive() then return end
		if self.lighton == true then
			self:SetBodygroup(10, 0)
			self.lighton = false
			self:EmitSound( "buttons/lightswitch2.wav", 75, 105 )
		else
			self.lighton = true
			self:SetBodygroup(10, 1)
			self:EmitSound( "buttons/lightswitch2.wav", 75, 105 )
		end
	end

	self:AddWeapon( weapon, 3 )
end

function ENT:TraceBTL()
	local ID = self:LookupAttachment( "lazer_cannon_muzzle" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end

	local dir = Muzzle.Ang:Up()
	local pos = Muzzle.Pos

	local trace = util.TraceLine( {
		start = pos,
		endpos = (pos + dir * 50000),
	} )

	return trace
end
