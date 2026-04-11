include("shared.lua")

ENT.EngineColor = Color( 150, 220, 255, 255)
ENT.BoostedEngineColor = Color( 60, 95, 255, 255)
ENT.EngineGlow = Material( "sprites/light_glow02_add" )
ENT.EngineCenter = Material( "vgui/circle" )
ENT.EnginePos = {
	[1] = Vector(-82,43.4,54.3),
	[2] = Vector(-82,-43.4,54.3),
}

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/freeco_boost_on.wav", 75, 100,  LVS.EngineVolume )
		self:SetGears(true)
		return
	end

	self:EmitSound( "lvs/freeco_boost_off.wav", 75, 100,  LVS.EngineVolume )
	self:SetGears(false)
end

function ENT:OnFrame()
	self:DamageFX()
	self:AnimGears()
end

function ENT:AnimGears()
	self._sm_gear = self._sm_gear or 1

	local target_gear = self:GetGears() and 0 or 1
	local RFT = RealFrameTime() * (0.5 + math.abs( math.sin( self._sm_gear * math.pi ) ) * 0.5)
	local RateUp = RFT * 2
	local RateDown = RFT * 3

	self._sm_gear = self._sm_gear + math.Clamp(target_gear - self._sm_gear,-RateDown,RateUp)

	local DoneMoving = self._sm_gear == 1 or self._sm_gear == 0

	if self._oldDoneMoving ~= DoneMoving then
		self._oldDoneMoving = DoneMoving
		if not DoneMoving then
			self:EmitSound("lvs/vehicles/vwing/sfoils.wav")
		end
	end

	self:SetPoseParameter( "move_gear", 1 - self._sm_gear )

	self:InvalidateBoneCache()
end

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.5 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-50,0,50) + VectorRand() * 40 ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_engine_blacksmoke", effectdata )

		if HP <= MaxHP * 0.25 then
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( self.EnginePos[1] ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(1,3) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )

			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( self.EnginePos[2] ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(1,3) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )
		end
	end
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for _, pos in pairs( self.EnginePos ) do
		local vOffset = self:LocalToWorld( pos )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "effects/muzzleflash2", vOffset )

		if not particle then continue end

		particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(15,25) )
		particle:SetEndSize( math.Rand(0,10) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
		particle:SetColor( 255, 200, 50 )
	end
end

function ENT:PostDraw()
	if not self:GetEngineActive() then return end

	cam.Start3D2D( self:LocalToWorld( self.EnginePos[1] ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 7, 7, 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 7, 7, 0 )
	cam.End3D2D()

	cam.Start3D2D( self:LocalToWorld( self.EnginePos[2] ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 7, 7, 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 7, 7, 0 )
	cam.End3D2D()
end

function ENT:PostDrawTranslucent()
	if self:GetProjectorStatus() then
		local Mirror = false
		for i=0,1 do
			local ID_L = self:LookupAttachment( "muzzle_left" )
			local ID_R = self:LookupAttachment( "muzzle_right" )
			local MuzzleL = self:GetAttachment( ID_L )
			local MuzzleR = self:GetAttachment( ID_R )

			if not MuzzleL or not MuzzleR then return end

			Mirror = not Mirror

			local StartPos = Mirror and MuzzleL.Pos or MuzzleR.Pos
			local Dir = Mirror and -MuzzleL.Ang:Right() or -MuzzleR.Ang:Right()

			render.SetMaterial( Material( "sprites/light_glow02_add" ) )
			render.DrawSprite( StartPos , 60, 60, Color( 155, 155, 155, 255) )
			render.SetMaterial( Material( "sprites/light_glow02_add" ) )
			render.DrawSprite( StartPos , 120, 120, Color( 155, 155, 155, 255) )

			render.SetMaterial( Material( "effects/spotlight_single_tracer_add" ) )
			render.DrawBeam(  StartPos + Dir * 150 , StartPos - Dir * 150 , 250, 0, 0.99, Color( 255, 255, 255, 75) )
		end
	end

	if not self:GetEngineActive() then return end

	local Size = 60 + self:GetThrottle() * (self:GetIsBoosted() and 110 or 60)

	render.SetMaterial( self.EngineGlow )

	for _, pos in pairs( self.EnginePos ) do
		render.DrawSprite(  self:LocalToWorld( pos ), Size, Size, self:GetIsBoosted() and self.BoostedEngineColor or self.EngineColor )
	end
end
