
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "V-19 Torrent"
ENT.Author = "Durian"
ENT.Information = ""
ENT.Category = "[LVS] - Republic Vehicles"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/durian/v19/v19.mdl"
ENT.GibModels = {
}

ENT.AITEAM = 2

ENT.MaxVelocity = 2650
ENT.MaxThrust = 2650

ENT.ThrustVtol = 55
ENT.ThrustRateVtol = 3

ENT.TurnRatePitch = 1.2
ENT.TurnRateYaw = 1.2
ENT.TurnRateRoll = 1.2

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 800
ENT.MaxShield = 0

ENT.GOZANTI_PICKUPABLE = true
ENT.GOZANTI_DROP_IN_AIR = true
ENT.GOZANTI_PICKUP_POS = Vector(0, 0, 0)
ENT.GOZANTI_PICKUP_Angle = Angle(0,0,0)

function ENT:GetGroundDistance()
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector( 0, 0, 2000 ),
		filter = self
	})

	if not tr.Hit then return math.huge end
	return self:GetPos():Distance( tr.HitPos )
end

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "WingsDown" )

	if SERVER or CLIENT then
		self:NetworkVarNotify( "WingsDown", self.OnWingsChanged )
	end
end

function ENT:InitWeapons()
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/mg.png")
		weapon.Ammo = 2000
		weapon.Delay = 0.1
		weapon.HeatRateUp = 0.3
		weapon.HeatRateDown = 0.5
		weapon.Attack = function( ent )
			-- if not self:GetWingsDown(true) then 
			-- 	ent:SetHeat( ent:GetHeat() * 0 )
			-- 	return
			-- end

			local ID_L = ent:LookupAttachment( "cannon_left" )
			local ID_R = ent:LookupAttachment( "cannon_right" )
			local MuzzleL = ent:GetAttachment( ID_L )
			local MuzzleR = ent:GetAttachment( ID_R )

			if not MuzzleL or not MuzzleR then return end

			ent.MirrorPrimary = not ent.MirrorPrimary

			local Pos = ent.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos
			local Dir =  (ent.MirrorPrimary and MuzzleL.Ang or MuzzleR.Ang):Up()

			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end

			local startpos = pod:LocalToWorld( pod:OBBCenter() )
			local trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + ent:GetForward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = ent:GetCrosshairFilterEnts()
			} )

			local bullet = {}
			bullet.Src 	= Pos
			bullet.Dir 	= (trace.HitPos - bullet.Src):GetNormalized()
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_green"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 150
			bullet.SplashDamageRadius = 250
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(50,255,50) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end
			ent:LVSFireBullet( bullet )



			local effectdata = EffectData()
			effectdata:SetStart( Vector(50,255,50) )
			effectdata:SetOrigin( bullet.Src )
			effectdata:SetNormal( ent:GetForward() )
			effectdata:SetEntity( ent )
			util.Effect( "lvs_muzzle_colorable", effectdata )

			ent:TakeAmmo()

			ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/tie/overheat.wav") end
	self:AddWeapon( weapon )

	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Ammo = 2500
		weapon.Delay = 0.25
		weapon.HeatRateUp = 0.3
		weapon.HeatRateDown = 0.5
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end

			local ID_L = ent:LookupAttachment( "cannon_left" )
			local ID_R = ent:LookupAttachment( "cannon_right" )
			local MuzzleL = ent:GetAttachment( ID_L )
			local MuzzleR = ent:GetAttachment( ID_R )

			if not MuzzleL or not MuzzleR then return end

			local startpos = pod:LocalToWorld( pod:OBBCenter() )
			local trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + ent:GetForward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = ent:GetCrosshairFilterEnts()
			} )
			
			local bullet = {}
			bullet.Dir 	= ent:GetForward()
			bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force = 1000
			bullet.HullSize = 25
			bullet.Damage = 280
			bullet.SplashDamage = 15
			bullet.SplashDamageRadius = 5
			bullet.Velocity = 60000
			bullet.Attacker = ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
				effectdata:SetStart(Vector(50,50,255)) 
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
				util.Effect("lvs_laser_impact", effectdata)
			end
			
			local muzzles = {
				MuzzleL,
				MuzzleR,
			}

			for _, muzzle in ipairs(muzzles) do
				bullet.Src = muzzle.Pos
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart(Vector(50,50,225))
				effectdata:SetOrigin(bullet.Src)
				effectdata:SetNormal(muzzle.Ang:Up())
				effectdata:SetEntity(ent)
				util.Effect("lvs_muzzle_colorable", effectdata)

				ent:LVSFireBullet(bullet)
			end

			ent:TakeAmmo()

			ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/shuttle/overheat.wav") end
	self:AddWeapon( weapon )

	local weapon = {}
		weapon.Icon = Material("lvs/weapons/concussionmissile.png")
		weapon.Ammo = 6
		weapon.Delay = 0 -- this will turn weapon.Attack to a somewhat think function
		weapon.HeatRateUp = -0.25 -- cool down when attack key is held. This system fires on key-release.
		weapon.HeatRateDown = 0.25
		weapon.Attack = function( ent )
			local T = CurTime()

			if IsValid( ent._ConcussionMissile ) then
				if (ent._nextMissleTracking or 0) > T then return end

				ent._nextMissleTracking = T + 0.1 -- 0.1 second interval because those find functions can be expensive

				ent._ConcussionMissile:FindTarget( ent:GetPos(), ent:GetForward(), 30, 7500 )

				return
			end

			if (ent._nextMissle or 0) > T then return end

			ent._nextMissle = T + 0.5

			ent._swapMissile = not ent._swapMissile
			local Pos = Vector( 118, (ent._swapMissile and -40 or 40), 20 )

			local Driver = self:GetDriver()

			local projectile = ents.Create( "lvs_protontorpedo" )
			projectile:SetPos( ent:LocalToWorld( Pos ) )
			projectile:SetAngles( ent:GetAngles() )
			projectile:SetParent( ent )
			projectile:Spawn()
			projectile:Activate()
			projectile:SetAttacker( IsValid( Driver ) and Driver or self )
			projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
			projectile:SetSpeed( ent:GetVelocity():Length() + 8000 )
			projectile:SetDamage( 800 )
			projectile:SetRadius( 300 )

			ent._ConcussionMissile = projectile

			ent:SetNextAttack( CurTime() + 0.1 ) -- wait 0.1 second before starting to track
		end
		weapon.FinishAttack = function( ent )
			if not IsValid( ent._ConcussionMissile ) then return end

			local projectile = ent._ConcussionMissile

			projectile:Enable()
			projectile:EmitSound( "lvs/vehicles/vulturedroid/fire_missile.mp3", 125 )
			ent:TakeAmmo()

			ent._ConcussionMissile = nil

			local NewHeat = ent:GetHeat() + 0.75

			ent:SetHeat( NewHeat )
			if NewHeat >= 1 then
				ent:SetOverheated( true )
			end
		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
	self:AddWeapon( weapon )

end

ENT.FlyByAdvance = 0.5
ENT.FlyBySound = "lvs/vehicles/vwing/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/vwing/loop.wav",
		sound_int = "lvs/vehicles/vwing/loop_interior.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		SoundLevel = 90,
	},
}