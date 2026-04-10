local IsValid = IsValid
local CurTime = CurTime
local ParticleEmitter = ParticleEmitter
local Vector = Vector
local VectorRand = VectorRand
local math_Rand = math.Rand
local math_random = math.random
function EFFECT:Init(data)
	if not IsValid(data:GetEntity()) then return end
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	if self.WeaponEnt == nil then return else
		self.Position = data:GetOrigin()
		self.Forward = data:GetNormal()
		self.Angle = self.Forward:Angle()
		self.Owner = data:GetEntity()
		local light = DynamicLight(0)
		if light then
			light.Pos = self.Position
			light.Size = 100
			light.Decay = 256
			light.R, light.G, light.B = 80, 70, 50
			light.Brightness = 2
			light.DieTime = CurTime() + 2
		end
		local emitter = ParticleEmitter(self.Position)
		if emitter then	
			local particle = emitter:Add("sprites/heatwave", self.Position + self.Owner:GetAngles():Forward()*-25 + self.Owner:GetAngles():Up()*5)
			if particle then
				particle:SetVelocity(80 * self.Forward + 20 * VectorRand())
				particle:SetGravity(Vector(0, 0, 100))
				particle:SetAirResistance(160)
				particle:SetDieTime(math_Rand(0.2, 0.25))
				particle:SetStartSize(math_random(25, 40))
				particle:SetEndSize(10)
				particle:SetRoll(math_Rand(180, 480))
				particle:SetRollDelta(math_Rand(-1, 1))
			end
			for i = 1, 3 do
				local p = emitter:Add("sprites/flamelet"..math_random(1, 4), self.Position + self.Owner:GetAngles():Forward()*-25 + self.Owner:GetAngles():Up()*5)
				p:SetVelocity(8 * VectorRand())
				p:SetAirResistance(200)
				p:SetGravity(Vector(0, 0, 100))
				p:SetDieTime(0.2)
				p:SetStartAlpha(math_Rand(15, 30))
				p:SetEndAlpha(0)
				p:SetStartSize(math_Rand(10, 15))
				p:SetEndSize(0)
				p:SetRoll(math_Rand(-25, 25))
				p:SetRollDelta(math_Rand(-0.05, 0.05))
				p:SetColor(120, 120, 120, 255)
			end
			for i = 1, 3 do
				local p = emitter:Add("particle/smokesprites_000"..math_random(1, 4), self.Position + self.Owner:GetAngles():Forward()*-25 + self.Owner:GetAngles():Up()*5)
				p:SetVelocity(45 * VectorRand())
				p:SetAirResistance(400)
				p:SetGravity(Vector(0, 0, 100) + 45 * VectorRand())
				p:SetDieTime(math_Rand(1, 5))
				p:SetStartAlpha(math_Rand(15, 30))
				p:SetEndAlpha(0)
				p:SetStartSize(math_Rand(10, 15))
				p:SetEndSize(math_Rand(20, 35))
				p:SetRoll(math_Rand(-25, 25))
				p:SetRollDelta(math_Rand(-0.05, 0.05))
				p:SetColor(120, 120, 120, 255)
			end
			emitter:Finish()
		end
	end
end
function EFFECT:Think() return false end
function EFFECT:Render() end