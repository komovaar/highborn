function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	if not emitter then return end

	for i = 1, 10 do
		local particle = emitter:Add("effects/tool_tracer", pos)
		if particle then
			local dir = VectorRand()
			dir.z = dir.z * 0.1

			particle:SetVelocity(dir * 30)
			particle:SetDieTime(0.4)
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(12)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(80, 150, 255)
		end
	end

	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end
