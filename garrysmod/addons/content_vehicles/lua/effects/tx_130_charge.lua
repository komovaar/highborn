function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	if not emitter then return end

	for i = 1, 6 do
		local particle = emitter:Add("sprites/light_glow02_add", pos)
		if particle then
			local dir = VectorRand()
			dir.z = dir.z * 0.1

			particle:SetVelocity(dir * 10)
			particle:SetDieTime(0.2)
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(3)
			particle:SetEndSize(6)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetColor(255, 0, 50)
		end
	end

	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end
