ENT.Type = "anim"
ENT.Base = "lvs_base_fakehover"

ENT.PrintName = "J-1 Proton Cannon"
ENT.Author = "Dec"
ENT.Information = ""
ENT.Category = "[LVS] SW-Vehicles"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector( 338, 0, 214 )

ENT.MDL = "models/jr/proton_cannon.mdl"
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


ENT.AITEAM = 1

ENT.MaxVelocityY = 0
ENT.BoostAddVelocityY = 0

ENT.ForceAngleMultiplier = 4
ENT.ForceAngleDampingMultiplier = 4

ENT.ForceLinearMultiplier = 0
ENT.ForceLinearRate = 0

ENT.MaxVelocityZ = 0
ENT.BoostAddVelocityZ = 0

ENT.MaxHealth = 2500
ENT.MaxShield = 0
ENT.MaxVelocityX = 0
ENT.BoostAddVelocitX = 0
ENT.IgnoreWater = false

ENT.MaxTurnRate = 1

ENT.GroundTraceLength = 50
ENT.GroundTraceHull = 100


function ENT:InitWeapons()

	self.perst = 0

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.Ammo = 45
	weapon.Delay = 1.2
	weapon.HeatRateUp = 0.8
	weapon.HeatRateDown = 0.3
	weapon.Attack = function( ent )

		if self:GetBodygroup(1) == 1 then return end

		local veh = ent:GetVehicle()
		local Driver = ent:GetDriver()
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		for i = 1, 1 do
			timer.Simple( (i / 2) * 0.2, function()
				if not IsValid( ent ) then return end
				
				if ent:GetAmmo() <= 0 then ent:SetHeat( 1 ) return end
	
				ent:TakeAmmo()

				local ID_1 = self:LookupAttachment( "muzzle" )
				local Muzzle1 = self:GetAttachment( ID_1 )
				
				local Pos = Muzzle1.Pos				
				local Dir =  (Muzzle1.Ang):Up()
				
				print(Dir)

				local trace = ent:GetEyeTrace()

				local projectile = ents.Create( "lvs_fall_missel_cis" )
				projectile:SetPos(Pos)
				projectile:SetAngles(Dir:Angle())
				projectile:SetParent()
				projectile:Spawn()
				projectile:Activate()
				projectile.GetTarget = function( missile ) return missile end
				projectile.GetTargetPos = function( missile )
					return missile:LocalToWorld( Vector(150,0,0) + VectorRand() * math.random(-10,10) )
				end
				projectile:SetAttacker( IsValid( Driver ) and Driver or self )
				projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
				projectile:Enable()
				projectile:EmitSound( "vehicle/starwars/av7/av7fire.wav" )

				util.ScreenShake(self:GetPos(), 50, 50, 0.8, 2000, true )
				for i=1,10 do
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() )
					effectdata:SetRadius(500 * 500)
					effectdata:SetScale(24 * 20)
					util.Effect( "ThumperDust", effectdata, true, true )
				end
				self:SetPos(self:GetPos() - self:GetForward() * 1.5)
				timer.Simple(1.5, function()
					if IsValid(self) then
						self:SetPos(self:GetPos() + self:GetForward() * 1.5)
					end
				end)
			end)
		end
	end
	weapon.OnThink = function( ent, active )
		self.perst = self.perst + 1

		if self.perst == 4 then
			self.perst = 0
		end

		if self.perst == 0 then
			local Driver = self:GetDriver()

			if self:GetAI() or IsValid( Driver ) then		
				
				local EyeAngles = Driver:EyeAngles()
			
				local Pitch =  EyeAngles.x
			
				if Pitch > 10 then 
					Pitch = 10
				end

				if Pitch < -35 then 
					Pitch = -35
				end
			
				local Pitch =  Pitch
			
				self:ManipulateBoneAngles(self:LookupBone("gun"), Angle(0, 0, Pitch))
			end
		end
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
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.Ammo = 25
	weapon.Delay = 0.8
	weapon.HeatRateUp = 0.8
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )

		if self:GetBodygroup(1) == 1 then return end


		local veh = ent:GetVehicle()
		local Driver = ent:GetDriver()

		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		for i = 1, 1 do
			timer.Simple( (i / 2) * 0.2, function()
				if not IsValid( ent ) then return end

				if ent:GetAmmo() <= 0 then ent:SetHeat( 1 ) return end
	
				ent:TakeAmmo()
				local ID_1 = self:LookupAttachment( "muzzle" )
				local Muzzle1 = self:GetAttachment( ID_1 )
				
				local Pos = Muzzle1.Pos
				local Dir =  (Muzzle1.Ang):Up()
			
				local projectile = ents.Create( "lvs_concussionmissile" )
				projectile:SetPos(Pos)
				projectile:SetAngles( Dir:Angle())
				projectile:SetParent()
				projectile:Spawn()
				projectile:Activate()
				projectile:SetDamage( 550 )
				projectile:SetRadius( 350 )
				projectile.GetTarget = function( missile ) return missile end
				projectile.GetTargetPos = function( missile )
					return missile:LocalToWorld( Vector(150,0,0) + VectorRand() * math.random(-1,1) )
				end
				projectile:SetAttacker( IsValid( Driver ) and Driver or self )
				projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
				projectile:Enable()
				projectile:EmitSound( "vehicle/starwars/av7/av7fire.wav" )

				util.ScreenShake(self:GetPos(), 50, 50, 0.3, 2000, true )
				for i=1,10 do
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() )
					effectdata:SetRadius(500 * 500)
					effectdata:SetScale(24 * 20)
					util.Effect( "ThumperDust", effectdata, true, true )
				end
				self:SetPos(self:GetPos() - self:GetForward() * 1.5)
				timer.Simple(1.5, function()
					if IsValid(self) then
						self:SetPos(self:GetPos() + self:GetForward() * 1.5)
					end
				end)
			end)
		end
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 30) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnThink = function( ent, active )
		--[[local Driver = self:GetDriver()
		
		if not IsValid( Driver ) then return end
	
		local EyeAngles = Driver:EyeAngles()
	
		local Pitch =  EyeAngles.x
	
		if Pitch > 20 then 
			Pitch = 20
		end
	
		local Pitch =  -Pitch
	
		self:ManipulateBoneAngles(self:LookupBone("gun"), Angle(0, Pitch, 0))]]--
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("weapons/shotgun/shotgun_cock.wav")
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/gunship_reardoor.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.StartAttack = function( ent )
		if self:GetAI() == true then return end 
		if (self.gateDown) then
			self.gateDown = false
			self:SetBodygroup(1, 0)
			ent.MaxVelocityY = 0
			ent.BoostAddVelocityY = 0
			ent.MaxVelocityX = 0
			ent.BoostAddVelocitX = 0
			ent.ForceLinearMultiplier = 0
			ent.ForceLinearRate = 0
		else
			self:SetBodygroup(1, 1)
			self.gateDown = true
			ent.MaxVelocityY = 100
			ent.BoostAddVelocityY = 150
			ent.MaxVelocityX = 200
			ent.BoostAddVelocitX = 300	
			ent.ForceLinearMultiplier = 2
			ent.ForceLinearRate = 0.8
		end

		self:EmitSound("lvs/vehicles/laat/door_large_open.wav")
	end
	self:AddWeapon( weapon )
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/iftx/loop.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		SoundLevel = 85,
	},
	{
		sound = "lvs/vehicles/iftx/loop_hi.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		SoundLevel = 85,
	},
	{
		sound = "lvs/vehicles/iftx/dist.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		SoundLevel = 90,
	},
}

