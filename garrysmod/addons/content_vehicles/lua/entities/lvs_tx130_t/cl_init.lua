include("shared.lua")
include( "cl_prediction.lua" )

function ENT:Initialize()
end

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()
	
		if HP > MaxHP * 0.5 then return end
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(15,3,50) ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_engine_blacksmoke", effectdata )
		
		if HP <= 1500 then
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(50,-50,30) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(0.5,1.5) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )
			if math.random(0,45) < 3 then
				if math.random(1,2) == 1 then
					local Pos = self:LocalToWorld( Vector(0,0,20) + VectorRand() * 30 )
					local effectdata = EffectData()
						effectdata:SetOrigin( Pos )
					util.Effect( "cball_explode", effectdata, true, true )
					
					sound.Play( "ambient/energy/spark"..math.random(1,6)..".wav", Pos, 75 )
				end
			end
		end
		
		if HP <= MaxHP * 0.25 then
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-20,40,46) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(0.5,1.5) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )
			
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-130,-35,50) ) )
				effectdata:SetNormal( -self:GetForward() )
				effectdata:SetMagnitude( math.Rand(0.5,1.5) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )
		end
	end
end

function ENT:OnFrame()
	self:AnimCabin()
	self:DamageFX()
end

function ENT:AnimCabin()
	local Fire = self:GetBTLFire()
	if Fire ~= self.OldFireBTL then
		self.OldFireBTL = Fire
		
		if Fire then		
			self:EmitSound("LAATi_BT_FIRE")

			self.BTLLOOP = CreateSound( self, "RX_BEAM" )
			self.BTLLOOP:Play()
			
			local effectdata = EffectData()
			effectdata:SetEntity( self )
			util.Effect( "tx_130_projector", effectdata )
			else
			if self.BTLLOOP then
				self.BTLLOOP:Stop()
			end
		end
end
	
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	
	
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
	
	if self.BTLLOOP then
		self.BTLLOOP:Stop()
	end
	
	if self._ChargeSound then 
	self._ChargeSound:Stop() 
	end
	
	if self._ChargeElectroSound then 
	self._ChargeElectroSound:Stop() 
	end
end

function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	local view = {}
	view.origin = pos
	view.fov = fov
	view.drawviewer = true
	view.angles = ply:EyeAngles()
	local gunners = self:GetGunnerSeat()
	local gunner = gunners:GetDriver()
	local Driver = self:GetDriver()
	if pod:GetThirdPersonMode() then
		if ply == Driver then
			local Pod = ply:GetVehicle()
			
				local radius = 400
				radius = radius + radius * Pod:GetCameraDistance()
				
				local StartPos = self:LocalToWorld( Vector(0,0,50) ) + view.angles:Up() * 100
				local EndPos = StartPos - view.angles:Forward() * radius
				
				local WallOffset = 4
		
				local tr = util.TraceHull( {
					start = StartPos,
					endpos = EndPos,
					filter = function( e )
						local c = e:GetClass()
						local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS and not e.LVS
						
						return collide
					end,
					mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
					maxs = Vector( WallOffset, WallOffset, WallOffset ),
				} )
				
				view.drawviewer = true
				view.origin = tr.HitPos
				
				if tr.Hit and not tr.StartSolid then
					view.origin = view.origin + tr.HitNormal * WallOffset
				end
			return view
		else
			local Pod = ply:GetVehicle()
			
			local radius = 400
			radius = radius + radius * Pod:GetCameraDistance()
			
			local StartPos = self:LocalToWorld( Vector(0,0,50) ) + view.angles:Up() * 100
			local EndPos = StartPos - view.angles:Forward() * radius
			
			local WallOffset = 4
	
			local tr = util.TraceHull( {
				start = StartPos,
				endpos = EndPos,
				filter = function( e )
					local c = e:GetClass()
					local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
					
					return collide
				end,
				mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
				maxs = Vector( WallOffset, WallOffset, WallOffset ),
			} )
			
			view.drawviewer = true
			view.origin = tr.HitPos
			
			if tr.Hit and not tr.StartSolid then
				view.origin = view.origin + tr.HitNormal * WallOffset
			end
			return view
		end
	end
	if not pod:GetThirdPersonMode() then

		view.drawviewer = false

		local gunners = self:GetGunnerSeat()
		
		local Driver = self:GetDriver()
		local Gunner = gunners:GetDriver()

		if ply == Driver then
	view.origin = self:LocalToWorld( Vector(-65,25,55) )
	elseif ply == Gunner then
		view.origin = self:LocalToWorld( Vector(-100,0,95) )
	else
	local seats = self:GetPassengerSeats()
	if istable(seats) then
		if IsValid(seats[2]) and ply == seats[2]:GetDriver() then
			view.origin = self:LocalToWorld( Vector(75, -35, 55) )
		elseif IsValid(seats[1]) and ply == seats[1]:GetDriver() then
			view.origin = self:LocalToWorld( Vector(75, 35, 55) )
		else
			view.origin = self:LocalToWorld( Vector(-65, -25, 55) )
		end
	else
		view.origin = self:LocalToWorld( Vector(-65, -25, 55) )
	end
end

		
	return view
	end

	return view
end

function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	self:RemoveLight()
end

local spotlight = Material( "effects/lvs/laat_spotlight" )
local glow_spotlight = Material( "sprites/light_glow02_add" )

function ENT:Draw()
	self:DrawModel()

	if self:GetBodygroup( 10 ) ~= 1 then 
		self:RemoveLight()

		return
	end

	if not IsValid( self.projector ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 20 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 2500 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 80 )
		self.projector = thelamp
	end

	local StartPos = self:LocalToWorld( Vector(60,0,10.5) )
	local Dir = self:GetForward()

	render.SetMaterial( glow_spotlight )
	render.DrawSprite( StartPos + Dir * -10 , 220, 120, Color( 255, 255, 255, 255) )

	render.SetMaterial( spotlight )
	render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 800, 250, 0, 0.99, Color( 255, 255, 255, 10) ) 
	
	if IsValid( self.projector ) then
		self.projector:SetPos( StartPos )
		self.projector:SetAngles( Dir:Angle() )
		self.projector:Update()
	end
end

