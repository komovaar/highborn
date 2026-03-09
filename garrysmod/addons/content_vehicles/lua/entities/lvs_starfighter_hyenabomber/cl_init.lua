include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-201.14,-178.05,101.58), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-201.14,178.05,101.58), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-269.82,-178.6,65.6), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-269.82,178.6,65.6), 0, 20, 2, 1000, 150 )
end

function ENT:OnFrame()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )
ENT.EngineFXColor = Color( 0, 0, 255)
ENT.EngineFxPos = {
	Vector(0.16,-102.55,85.47),
	Vector(-1.33,-102.85,78.71),
	Vector(1.14,-109.51,78.55),
	Vector(0.28,-109.68,85.77),
	Vector(5.99,-116.13,85.42),
	Vector(5.82,-116.12,78.67),
	Vector(10.93,-122.51,84.96),
	Vector(10.56,-122.86,78.4),
	--left
	Vector(0.16,102.55,85.47),
	Vector(-1.33,102.85,78.71),
	Vector(1.14,109.51,78.55),
	Vector(0.28,109.68,85.77),
	Vector(5.99,116.13,85.42),
	Vector(5.82,116.12,78.67),
	Vector(10.93,122.51,84.96),
	Vector(10.56,122.86,78.4),
}

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 25 + self:GetThrottle() * 90 + self:GetBoost() * 0.9

	render.SetMaterial( self.EngineGlow )

	for _, v in pairs( self.EngineFxPos ) do
		local pos = self:LocalToWorld( v )
		render.DrawSprite( pos, Size, Size, self.EngineFXColor )

	end
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/hyena/VEH_STARHAWK_BOOST_ON.mp3", 85 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vulturedroid/brake.wav", 85 )
end
