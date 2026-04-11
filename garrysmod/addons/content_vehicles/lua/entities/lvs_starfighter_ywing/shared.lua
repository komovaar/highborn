
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "Y-Wing"
ENT.Author = "KurtJQ"
ENT.Information = "BTL-B Y-Wing Starfighter of the Republic"
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.MDL = "models/ywing/BTL-B_Y-Wing.mdl"

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

ENT.MaxVelocity = 2350
ENT.MaxThrust = 2350

ENT.ThrustVtol = 55
ENT.ThrustRateVtol = 3

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.75

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 400
ENT.MaxShield = 100

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "TopGunnerSeat")
end

function ENT:SetPoseParameterTopGun( weapon )
	if not IsValid( weapon:GetDriver() ) and not weapon:GetAI() then return end

	local AimAng = weapon:WorldToLocal( weapon:GetPos() + weapon:GetAimVector() ):Angle()
	AimAng:Normalize()

	self:SetPoseParameter("gunner_seat", AimAng.y)
	self:SetPoseParameter("turrets", -AimAng.p)
end

function ENT:TraceGunner()
	local IDL = self:LookupAttachment("turret_muzzle_L")
	local IDR = self:LookupAttachment("turret_muzzle_R")
	local MuzzleL = self:GetAttachment( IDL )
	local MuzzleR = self:GetAttachment( IDR )

	if not MuzzleL then return end
	if not MuzzleR then return end

	local dir = -MuzzleL.Ang:Up()
	local pos = MuzzleL.Pos

	local trace = util.TraceLine( {
		start = pos,
		endpos = pos + dir * 50000,
	} )

	return trace
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	self.FirePositions = {
		Vector(517.48,-22.81,45.25),
		Vector(517.48,22.64,45.24)
	}

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1200
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		ent.NumPrim = ent.NumPrim and ent.NumPrim + 1 or 1
		if ent.NumPrim > #ent.FirePositions then ent.NumPrim = 1 end

		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local startpos = pod:LocalToWorld( pod:OBBCenter() )
		local trace = util.TraceHull( {
			start = startpos,
			endpos = startpos + ent:GetForward() * 50000,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = ent:GetCrosshairFilterEnts()
		} )

		local bullet = {}
		bullet.Src 	= ent:LocalToWorld( ent.FirePositions[ent.NumPrim] )
		bullet.Dir 	= (trace.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.02,  0.02, 0 )
		bullet.TracerName = "lvs_laser_blue_long"
		bullet.Force	= 10
		bullet.HullSize 	= 30
		bullet.Damage	= 40
		bullet.SplashDamage = 60
		bullet.SplashDamageRadius = 250
		bullet.Velocity = 50000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0 ,0 ,255) )
				effectdata:SetOrigin( tr.HitPos )
			util.Effect( "lvs_laser_explosion", effectdata )
		end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetStart( Vector(0 , 0, 255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )

		ent:TakeAmmo()

		ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )



	local weapon = {}
	weapon.Icon = Material("lvs/weapons/protontorpedo.png")
	weapon.Ammo = 12
	weapon.Delay = 0
	weapon.HeatRateUp = -0.5
	weapon.HeatRateDown = 0.1
	weapon.Attack = function( ent )

		local T = CurTime()

		if IsValid( ent._ProtonTorpedo ) then
			if (ent._nextMissleTracking or 0) > T then return end

			ent._nextMissleTracking = T + 0.1

			ent._ProtonTorpedo:FindTarget( ent:GetPos(), ent:GetForward(), 30, 7500 )

			return
		end

		if (ent._nextMissle or 0) > T then return end

		ent._nextMIssle = T + 0.5

		ent._swapMissile = not ent._swapMissile

		local Pos = Vector( 535, ent._swapMissile and -22.81 or 22.81, 46.04)

		local Driver = self:GetDriver()

		local projectile = ents.Create( "lvs_protontorpedo")
		projectile:SetPos( ent:LocalToWorld( Pos ))
		projectile:SetAngles( ent:LocalToWorldAngles( Angle(0, ent._swapMissile and 0, 0) ) )
		projectile:SetParent( ent )
		projectile:Spawn()
		projectile:Activate()
		projectile:SetAttacker( IsValid( Driver ) and Driver or self )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
		projectile:SetSpeed( ent:GetVelocity():Length() + 4000 )

		ent._ProtonTorpedo = projectile

		ent:SetNextAttack( CurTime() + 0.1 )
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent._ProtonTorpedo ) then return end

		local projectile = ent._ProtonTorpedo

		projectile:Enable()
		projectile:EmitSound( "lvs/vehicles/naboo_n1_starfighter/proton_fire.mp3", 125 )
		ent:TakeAmmo()

		ent._ProtonTorpedo = nil

		local NewHeat = ent:GetHeat() + 0.30

		ent:SetHeat(NewHeat)
		if NewHeat >= 1 then
			ent:SetOverheated(true)
		end
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material( "lvs/weapons/bomb.png" )
	weapon.Ammo = 10
	weapon.HeatRateUp = -0.5
	weapon.HeatRateDown = 0.1
	weapon.StartAttack = function( ent )
		local Driver = ent:GetDriver()

		local bomb = ents.Create( "lvs_protonbomb" )
		bomb:SetPos( ent:LocalToWorld( Vector( -135, 0, -10) ) )
		bomb:SetAngles( ent:GetAngles() )
		bomb:SetParent( ent )
		bomb:Spawn()
		bomb:Activate()
		bomb:SetAttacker( IsValid( Driver ) and Driver or self )
		bomb:SetSpeed( ent:GetVelocity() )

		ent._ProtonBomb = bomb
	end
	weapon.FinishAttack = function( ent )
		if not IsValid ( ent._ProtonBomb ) then return end

		local bomb = ent._ProtonBomb
		bomb:Enable()
		ent:TakeAmmo()

		ent._ProtonBomb = nil
	end
	weapon.OnThink = function( ent )
		if not IsValid( ent._ProtonBomb ) then return end

		local bomb = ent._ProtonBomb
		bomb:SetSpeed( ent:GetVelocity() )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end

	self:AddWeapon(weapon)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.2
	weapon.Attack = function( ent )
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local IDL = self:LookupAttachment( "turret_muzzle_L" )
		local IDR = self:LookupAttachment( "turret_muzzle_R" )
		local MuzzleL = self:GetAttachment( IDL )
		local MuzzleR = self:GetAttachment( IDR )

		if not MuzzleL then return end
		if not MuzzleR then return end

		local veh = ent:GetVehicle()

		veh.GunnerSND:PlayOnce( 100 + math.Rand(-3, 3), 1)

		ent.SwapLeftRight = not ent.SwapLeftRight

		local bullet = {}
		bullet.Src = ent.SwapLeftRight and MuzzleL.Pos or MuzzleR.Pos
		bullet.Dir = -MuzzleL.Ang:Up()
		bullet.Spread = Vector(0, 0, 0)
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force = 10
		bullet.HullSize = 25
		bullet.Damage = 50
		bullet.Velocity = 30000
		bullet.Attacker = ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0 ,0 ,255) )
				effectdata:SetOrigin( tr.HitPos )
			util.Effect( "lvs_laser_explosion", effectdata )
		end

		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetStart( Vector(0 , 0, 255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )
	end

	weapon.OnThink = function( ent, active)
		local base = ent:GetVehicle()

		if not IsValid ( base ) then return end

		base:SetPoseParameterTopGun( ent )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end

	weapon.CalcView = function( ent, ply, pos, angle, fov, pod)
		local base = ent:GetVehicle()

		if not IsValid( base ) then
			return LVS:CalcView( ent, ply, pos, angle, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + (ent:GetUp() * 20)
		end

		return LVS:CalcView( ent, ply, pos, angle, fov, pod )
	end

	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = base:TraceGunner().HitPos:ToScreen()

		base:PaintCrosshairCenter( Pos2D, COLOR_WHITE )
		base:PaintCrosshairOuter( Pos2D, COLOR_WHITE )
		base:LVSPaintHitMarker( Pos2D )
	end

	self:AddWeapon( weapon, 2)
end

ENT.FlyByAdvance = 0.5
ENT.FlyBySound = "lvs/vehicles/arc170/flyby.wav"
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "vanilla/ywing/vanilla_ywing_eng.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
	},
	{
		sound = "vanilla/ywing/vanilla_ywing_dist.wav",
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
		SoundLevel = 100,
	}
}