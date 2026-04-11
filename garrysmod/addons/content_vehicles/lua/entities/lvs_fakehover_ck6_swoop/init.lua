AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )
	local ID = self:LookupAttachment( "muzzle_left" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDLeft = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/freeco_fire.wav" )
	self.SNDLeft:SetSoundLevel( 95 )
	self.SNDLeft:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_right" )
	local Muzzle2 = self:GetAttachment( ID )
	self.SNDRight = self:AddSoundEmitter( self:WorldToLocal( Muzzle2.Pos ), "lvs/freeco_fire.wav" )
	self.SNDRight:SetSoundLevel( 95 )
	self.SNDRight:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(-17,0,40), Angle(0,-90,0) )

	local DoorHandler = self:AddDoorHandler( "move_glass", Vector(-5,0,60), Angle(0,0,0), Vector(-30,-25,-30), Vector(50,25,30), Vector(-30,-25,-30), Vector(50,25,30) )
	DoorHandler:LinkToSeat( DriverSeat )
	DoorHandler:SetSoundOpen( "doors/door_metal_thin_open1.wav" )
	DoorHandler:SetSoundClose( "doors/door_metal_thin_close2.wav" )

	self:AddEngineSound( Vector(-50,0,55) )

	local WheelMass = 25
	local WheelRadius = 25
	local WheelPos = {
		Vector(-100,-20,25),
		Vector(0,-50,20),
		Vector(100,-20,25),
		Vector(-100,20,25),
		Vector(0,50,20),
		Vector(100,20,25),
	}

	for _, Pos in pairs( WheelPos ) do
		self:AddWheel( Pos, WheelRadius, WheelMass, 10 )
	end
end
