ENT.Base = "lvs_nuclass_attack_shuttle"

ENT.PrintName = "NU-Class Attack Shuttle [MEDICAL VAR 2]"
ENT.Category = "[LVS] - Republic Vehicles"
ENT.Spawnable = true

ENT.Skin = 4
ENT.AITEAM = 2

function ENT:InitWeapons()

	self.FirePositions = {
		Vector(454,94, 58),
		Vector(454,-94, 58),
		Vector(454,-94, 76),
		Vector(454,94, 76)
	}

	local weapon = {}
		weapon.Icon = Material("lvs/weapons/hmg.png")
		weapon.Ammo = 1250
		weapon.Delay = 0.1
		weapon.HeatRateUp = 0.3
		weapon.HeatRateDown = 0.5
		weapon.Attack = function( ent )
			ent.NumPrim = ent.NumPrim and ent.NumPrim + 1 or 1
			if ent.NumPrim > #ent.FirePositions then ent.NumPrim = 1 end

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
			bullet.Src  = ent:LocalToWorld( ent.FirePositions[ent.NumPrim] )
			bullet.Dir 	= (trace.HitPos - bullet.Src):GetNormalized()
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_green"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 150
			bullet.SplashDamage = 150
			bullet.SplashDamageRadius = 400
			bullet.Velocity = 60000
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
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/dual_mg.png")
	weapon.Ammo = 1250
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0.4
	weapon.HeatRateDown = 0.5

	weapon.Attack = function( ent )

		if not self:GetWingsDown(true) then 
			ent:SetHeat( ent:GetHeat() * 0 )
			return
		end

		local pod = ent:GetDriverSeat()
		if not IsValid(pod) then return end

		ent._NextFireSide = ent._NextFireSide or -1

		local side = ent._NextFireSide

		local bullet = {}
		bullet.Spread 	= Vector(0.01, 0.01, 0.01)
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force = 10
		bullet.HullSize = 25
		bullet.Damage = 280
		bullet.SplashDamage = 50
		bullet.SplashDamageRadius = 50
		bullet.Velocity = 60000
		bullet.Attacker = ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
			effectdata:SetStart(Vector(50,50,255)) 
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			util.Effect("lvs_laser_impact", effectdata)
		end

		local src1 = ent:LocalToWorld(Vector(254, 187 * side, 57))
		bullet.Src = src1
		bullet.Dir = ent:GetForward()

		local effect = EffectData()
		effect:SetStart(Vector(50,50,255))
		effect:SetOrigin(src1)
		effect:SetNormal(ent:GetForward())
		effect:SetEntity(ent)
		util.Effect("lvs_muzzle_colorable", effect)

		ent:LVSFireBullet(bullet)

		local src2 = ent:LocalToWorld(Vector(254, 187 * side, 39))
		bullet.Src = src2

		local effect2 = EffectData()
		effect2:SetStart(Vector(50,50,255))
		effect2:SetOrigin(src2)
		effect2:SetNormal(ent:GetForward())
		effect2:SetEntity(ent)
		util.Effect("lvs_muzzle_colorable", effect2)

		ent:LVSFireBullet(bullet)

		ent._NextFireSide = -ent._NextFireSide

		ent:TakeAmmo()
		ent.SecondarySND:PlayOnce(100 + math.cos(CurTime() + self:EntIndex() * 1337) * 5 + math.Rand(-1,1), 1)
	end

	weapon.OnSelect = function(ent) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function(ent) ent:EmitSound("lvs/vehicles/shuttle/overheat.wav") end
	self:AddWeapon(weapon)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/light.png")
	weapon.Ammo = -1
	weapon.Delay = 2
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.StartAttack = function(ent)
		local newState = not self:GetSpotlightToggle()
		self:SetSpotlightToggle(newState)
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/gunship_reardoor.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.StartAttack = function( ent )
		local newState = not self:GetHatchOpen()
		self:SetHatchOpen(newState)
		self:EmitSound("lvs/vehicles/vwing/sfoils.wav")
	end
	self:AddWeapon( weapon )

end