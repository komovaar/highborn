
ENT.Base = "lvs_base_fakehover"

ENT.PrintName = "CK-6 Swoop"
ENT.Author = "Adas_22"
ENT.Information = "The snow speeder was known to be used on iced over planets. Due ti its speed you’ll need a windshield to go at high rates of speed."
ENT.Category = "[LVS] - Star Wars"

ENT.VehicleCategory = "Star Wars"
ENT.VehicleSubCategory = "Hover Bikes"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/nsn/vehicles/ck6_swoop.mdl"

ENT.GibModels = {
	"models/gibs/helicopter_brokenpiece_01.mdl",
	"models/gibs/helicopter_brokenpiece_02.mdl",
	"models/gibs/helicopter_brokenpiece_03.mdl",
	"models/combine_apc_destroyed_gib02.mdl",
	"models/combine_apc_destroyed_gib04.mdl",
	"models/combine_apc_destroyed_gib05.mdl",
	"models/props_c17/trappropeller_engine.mdl",
	"models/gibs/airboat_broken_engine.mdl",
}

ENT.AITEAM = 2

ENT.MaxHealth = 2700

ENT.ForceAngleMultiplier = 2
ENT.ForceAngleDampingMultiplier = 1

ENT.ForceLinearMultiplier = 1
ENT.ForceLinearRate = 0.25

ENT.TargetBoostVelocity = 1
ENT.MaxVelocityX = 600
ENT.MaxVelocityY = 180

ENT.MaxTurnRate = 5

ENT.BoostAddVelocityX = 600
ENT.BoostAddVelocityY = 120

ENT.GroundTraceHitWater = true
ENT.GroundTraceLength = 75
ENT.GroundTraceHull = 375

ENT.EngineSounds = {
	{
		sound = "lvs/freeco_engine_lp.wav",
		Volume = 0.7,
		Pitch = 85,
		PitchMul = 50,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/freeco_engine_lp.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 50,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "Gears" )
	self:AddDT( "Bool", "ProjectorStatus" )
	self:AddDT( "Bool", "IsBoosted" )
end

function ENT:WeaponsInRange()
	local Forward = self:GetForward()
	local AimForward = self:GetAimVector()

	return self:AngleBetweenNormal( Forward, AimForward ) < 30
end

local COLOR_RED = Color(255,0,0,255)
local COLOR_WHITE = Color(255,255,255,255)

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Ammo = 600
	weapon.Delay = 0.125
	weapon.HeatRateUp = 0.125
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		if not ent:WeaponsInRange() then return true end

		local ID_L = ent:LookupAttachment( "muzzle_left" )
		local ID_R = ent:LookupAttachment( "muzzle_right" )
		local MuzzleL = ent:GetAttachment( ID_L )
		local MuzzleR = ent:GetAttachment( ID_R )

		if not MuzzleL or not MuzzleR then return end

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos
		local Dir = (ent:GetEyeTrace().HitPos - Pos):GetNormalized()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.TracerName = "lvs_laser_blue_long"
		bullet.Force	= 10000
		bullet.HullSize 	= 1
		bullet.Damage	= 25
		bullet.Velocity = 40000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(50,50,255) )
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetStart( Vector(50,50,255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )

		ent:TakeAmmo()

		if ent.MirrorPrimary then

			if not IsValid( ent.SNDLeft ) then return end

			ent.SNDLeft:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 7 + math.Rand(-1,1), 1 )

			return
		end

		if not IsValid( ent.SNDRight ) then return end

		ent.SNDRight:PlayOnce( 100 + math.sin( CurTime() + ent:EntIndex() * 1337 ) * 7 + math.Rand(-1,1), 1 )
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = self:WeaponsInRange() and COLOR_WHITE or COLOR_RED
		local MuzzlePos2D = self:GetEyeTrace().HitPos:ToScreen()

		ent:PaintCrosshairCenter( MuzzlePos2D, Col )
		ent:LVSPaintHitMarker( MuzzlePos2D )
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/nos.png")
	weapon.HeatRateUp = 0.1
	weapon.HeatRateDown = 0.1
	weapon.UseableByAI = false
	weapon.StartAttack = function ( ent )
		ent.MaxVelocityX = 1150
		ent:EmitSound("lvs/vehicles/generic/boost.wav")
		ent:SetIsBoosted(true)
	end
	weapon.FinishAttack = function ( ent )
		ent.MaxVelocityX = 600
		ent:EmitSound("buttons/combine_button7.wav")
		ent:SetIsBoosted(false)
	end
	weapon.OnOverheat = function( ent ) timer.Simple(0.4, function() ent:EmitSound("lvs/overheat.wav") end) end
	weapon.OnSelect = function ( ent )
		ent:EmitSound("buttons/lever5.wav")
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/light.png")
	weapon.Ammo = -1
	weapon.Delay = 0.25
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.Attack = function( ent )
		if not IsValid(ent:GetDriver()) then return end
		if self:GetProjectorStatus() then
			self.Projector:Remove()
			self.Projector = nil
		else
			self.Projector = ents.Create("env_projectedtexture")
			self.Projector:SetPos(self:LocalToWorld( Vector(125,0,31) ))
			self.Projector:SetAngles(self:GetAngles())
			self.Projector:SetParent(self)
			self.Projector:SetKeyValue("targetname", "flashlight_projector_" ..self:EntIndex())
			self.Projector:SetKeyValue("texture", "effects/flashlight001")
			self.Projector:SetKeyValue("enableshadows", "1")
			self.Projector:SetKeyValue("distance", "5000")
			self.Projector:SetKeyValue("nearz", "25")
			self.Projector:SetKeyValue("farz", "4000")
			self.Projector:SetKeyValue("lightcolor", "255 255 255 2000")
			self.Projector:SetKeyValue("lightonlytarget", "0")
			self.Projector:Spawn()
			self.Projector:Activate()
			self.Projector:Fire("Enable", "", 0)
			self.Projector:SetOwner(self)
			self:SetProjectorStatus(true)
		end
		ent:EmitSound( "buttons/lightswitch2.wav", 75, 105 )
	end
	weapon.OnThink = function( ent )
		if not IsValid(self.Projector) and self:GetProjectorStatus() then self:SetProjectorStatus(false) end
	end
	self:AddWeapon( weapon )
end
