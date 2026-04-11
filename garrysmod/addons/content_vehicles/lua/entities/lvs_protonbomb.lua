AddCSLuaFile()

ENT.Base = "lvs_bomb"

ENT.Type = "anim"

ENT.PrintName = "Proton Bomb"
ENT.Author = "KurtJQ"
ENT.Information = "LVS Proton Bomb"
ENT.Category = "[LVS]"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.ExplosionEffect = "lvs_proton_explosion"
ENT.GlowColor = Color( 0, 127, 255, 255 )

if SERVER then
	function ENT:GetDamage() return
		(self._dmg or 2000)
	end

	function ENT:GetRadius() return
		(self._radius or 400)
	end

	return
end

ENT.GlowMat = Material( "sprites/light_glow02_add" )

function ENT:Initialize()
	self:SetModel( "models/weapons/w_missile_launch.mdl" )
end

function ENT:Enable()
	if self.IsEnabled then return end

	self.IsEnabled = true

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetEntity( self )
	util.Effect( "lvs_proton_trail", effectdata)
end

function ENT:Draw()
	if not self:GetActive() then return end

	self:DrawModel()

	render.SetMaterial( self.GlowMat )

	local pos = self:GetPos()
	local dir = self:GetForward()

	for i = 0, 30 do
		local Size = ((30 - i) / 30) ^ 2 * 128

		render.DrawSprite( pos - dir * i * 7, Size, Size, self.GlowColor )
	end
end