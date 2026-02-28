--Thanks Inconceivable/Generic Default
function EFFECT:Init(data)
	self.Entity = data:GetEntity()
	pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(pos)
	for i=1, 25 do
		local particle = self.Emitter:Add( "tfa_csgo/particle/particle_smokegrenade", pos)
		if (particle) then
			particle:SetVelocity( VectorRand():GetNormalized()*math.Rand(150, 300) )
			if i <= 5 then 
				particle:SetDieTime( 35 )
			else
				particle:SetDieTime( math.Rand( 30,35 ) )
			end
			particle:SetStartAlpha( math.Rand( 116, 216 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 116 )
			particle:SetEndSize( 216 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-1, 1)/3 )
			particle:SetColor( 95, 125, 60 ) 
			particle:SetAirResistance( 82 ) 
			//particle:SetGravity( Vector(math.Rand(-30, 30),math.Rand(-30, 30), -200 )) 	
			particle:SetCollide( true )
			particle:SetBounce( 1 )
		end
	end

end

function EFFECT:Think()
return false
end

function EFFECT:Render()

end