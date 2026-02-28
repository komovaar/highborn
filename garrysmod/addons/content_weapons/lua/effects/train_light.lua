if SERVER then AddCSLuaFile() end

function EFFECT:Init(data)

	self.Start = data:GetOrigin()
	self.size = data:GetScale()
	self.Emitter = ParticleEmitter(self.Start)

	for i = 1, math.random(25, 35) do
		local p = self.Emitter:Add("effects/muzzleflash"..math.random(1,4), self.Start)
		p:SetDieTime(math.Rand(0.2, 0.35))
		p:SetStartAlpha(255)
		p:SetEndAlpha(40)
		p:SetStartSize(math.random(35, 55) * self.size)
		p:SetEndSize(45 * self.size)
		p:SetRoll(math.Rand(-50, 50))
		p:SetRollDelta(math.Rand(-10, 10))
		p:SetCollide(true)
		p:SetVelocity(VectorRand():GetNormal() * math.random(25, 75) * self.size)
		p:SetColor(255, 90, 0)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end