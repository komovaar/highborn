AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

ENT.ExplodeSound = Sound("weapons/tfa_starwars/Shock_Explosion_02.wav")

function ENT:Draw()
	self:DrawModel()
	pos = self:GetPos()
	render.SetMaterial(Material("particle/particle_glow_04_additive"))
	render.DrawSprite(pos, 10, 10, Color(255, 90, 0))
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/cs574/explosif/grenade_train.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:DrawShadow( true )
	end
	self.ExplodeTimer = CurTime() + 2.5
end

function ENT:Think()
	if SERVER and self.ExplodeTimer <= CurTime() then
		self:EmitSound(self.ExplodeSound)
		self:Explode()
		self:Remove()
	end
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "TFA_CSGO_SmokeGrenade.Bounce" )
	end
end

function ENT:OnRemove()
end

function ENT:Explode()
	local effectdata = EffectData()
    effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale(2)
    util.Effect("train_light", effectdata)
end