AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(26.74,-41.55,100.77), Angle(0,-90,0) ).HidePlayer = true

	self:AddEngine( Vector(-37.31,41.67,102.98) )
	self:AddEngineSound( Vector(-1.82,0.32,90.71) )

	self.PrimarySND = self:AddSoundEmitter( Vector(60,0,8), "lvs/vehicles/vulturedroid/fire_wing.wav", "lvs/vehicles/vulturedroid/fire_wing.wav" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SecondarySND = self:AddSoundEmitter( Vector(30,0,6.5), "lvs/vehicles/vulturedroid/fire.mp3", "lvs/vehicles/vulturedroid/fire_interior.mp3" )
	self.SecondarySND:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/hyena/hyenastartingup.wav" )
	else
		self:EmitSound( "lvs/hyena/VEH_HYENA_BOMBER_BY_01.mp3" )
	end
end