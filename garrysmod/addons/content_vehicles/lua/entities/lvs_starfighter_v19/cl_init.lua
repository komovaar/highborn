include("shared.lua")

function ENT:OnSpawn()
end

ENT.EngineColor = Color( 129, 228, 218, 255)
ENT.EngineGlow = Material("sprites/light_glow02_add")
ENT.EnginePos = {
		Vector(-69,83,12),
		Vector(-69,-83,12),
}

function ENT:OnFrame()
	self:EngineEffects()
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for i = -1,1,2 do

		local vOffset = self:LocalToWorld( Vector(-69,83 * i,12) )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "sprites/heatwave", vOffset )

		if not particle then continue end

		particle:SetVelocity( vNormal * (2000 + self:GetBoost() * 10) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.025 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 20 )
		particle:SetEndSize( 20 )
		particle:SetAngles( vNormal:Angle() )
		particle:SetColor( math.Rand( 10, 100 ), math.Rand( 100, 220 ), math.Rand( 240, 255 ) )
	end

	if self:GetPoseParameter( "wings" ) == 1 then
		local vOffset = self:LocalToWorld( Vector(24,0,-135) )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "sprites/heatwave", vOffset )

		if not particle then return end

		particle:SetVelocity( vNormal * (2000 + self:GetBoost() * 10) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.025 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 20 )
		particle:SetEndSize( 20 )
		particle:SetAngles( vNormal:Angle() )
		particle:SetColor( math.Rand( 10, 100 ), math.Rand( 100, 220 ), math.Rand( 240, 255 ) )
	end
end

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 120 + self:GetThrottle() * 120 + self:GetBoost()

	render.SetMaterial( self.EngineGlow )
    local throttle = self:GetThrottle()
    local sizeBase = 120
    local sizeBoost = 1.5

    local Size = sizeBase + throttle * sizeBoost
    local SizeBlue = (sizeBase * 0.8) + throttle * (sizeBoost * 1.2)

	for i = -1,1,2 do
		local pos = self:LocalToWorld( Vector(-69,83 * i,12) )
        render.DrawSprite(pos, Size * 2.4, Size * 1.4, Color(146, 231, 255, 200 + 55 * throttle))
        render.DrawSprite(pos, SizeBlue * 2, SizeBlue * 1, Color(0, 100 + 155 * throttle, 255, 255))
    end

	if self:GetPoseParameter( "wings" ) == 1 then
		local pos = self:LocalToWorld( Vector(24,0,-135) )
        render.DrawSprite(pos, Size * 2.4, Size * 1.4, Color(146, 231, 255, 200 + 55 * throttle))
        render.DrawSprite(pos, SizeBlue * 2, SizeBlue * 1, Color(0, 100 + 155 * throttle, 255, 255))
	end

end

function ENT:AnimCockpit()
end

function ENT:OnStartBoost()
	self:EmitSound( "ARC170_BOOST", 70 )
end

function ENT:OnStopBoost()
	self:EmitSound( "ARC170_BRAKE", 70 )
end