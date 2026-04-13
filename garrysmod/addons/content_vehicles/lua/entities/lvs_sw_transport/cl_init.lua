include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() then
		if not pod:GetThirdPersonMode() then
			return pos + self:GetForward() * 20 + self:GetUp() * 20, angles, fov
		else
			return pos + self:GetForward() * 0 - self:GetUp() * 40, angles, fov
		end
	end

	return pos, angles, fov
end

function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
end

function ENT:OnRemoved()
	self:RemoveLight()
end

ENT.LightMaterial = Material( "effects/lvs/laat_spotlight" )
ENT.GlowMaterial = Material( "sprites/light_glow02_add" )

function ENT:PreDrawTranslucent()
	if not self:GetLightOn() then self:RemoveLight() return false end

	if not IsValid( self.projector ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( true ) 
		thelamp:SetFarZ( 2500 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 80 )
		self.projector = thelamp
	end

	local Start1 = self:LocalToWorld( Vector(81,13,15) )
	local Start2 = self:LocalToWorld( Vector(81,0,15) )
	local Start3 = self:LocalToWorld( Vector(81,-13,15) )

	local Dir1 = self:LocalToWorldAngles( Angle(0,15,0) ):Forward()
	local Dir2 = self:LocalToWorldAngles( Angle(0,0,0) ):Forward()
	local Dir3 = self:LocalToWorldAngles( Angle(0,-15,0) ):Forward()

	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite( Start1, 32, 32, Color( 100, 100, 100, 255) )
	render.DrawSprite( Start2, 32, 32, Color( 100, 100, 100, 255) )
	render.DrawSprite( Start3, 32, 32, Color( 100, 100, 100, 255) )

	render.SetMaterial( self.LightMaterial )
	render.DrawBeam( Start1,  Start1 + Dir1 * 400, 150, 0, 0.99, Color( 100, 100, 100, 5) ) 
	render.DrawBeam( Start2,  Start2 + Dir2 * 400, 150, 0, 0.99, Color( 100, 100, 100, 5) ) 
	render.DrawBeam( Start3,  Start3 + Dir3 * 400, 150, 0, 0.99, Color( 100, 100, 100, 5) ) 

	if IsValid( self.projector ) then
		self.projector:SetPos( self:LocalToWorld( Vector(60,0,10.5) ) )
		self.projector:SetAngles( self:LocalToWorldAngles( Angle(15,0,0) ) )
		self.projector:Update()
	end

	return false
end