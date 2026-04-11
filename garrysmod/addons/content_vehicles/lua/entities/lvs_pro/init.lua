AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 45

local WheelMass = 100
local WheelRadius = 40
local WheelPos = {
	Vector(-225,-80,-45),
	Vector(-225,80,-45),
	Vector(225,-80,-45),
	Vector(225,80,-45),
}

function ENT:OnSpawn( PObj )

	PObj:SetMass( 4000 )

	self:ManipulateBoneAngles(self:LookupBone("root"), Angle(0, 90, 0))


    local Pod = self:AddDriverSeat(Vector(5,-45,8), Angle(0,-90,0))

	--local Pod = self:AddPassengerSeat( Vector(225,-100,-20), Angle(0,0,0) )
	
	local driver = self:GetDriver()

	for _, Pos in pairs( WheelPos ) do 
		self:AddWheel( Pos, WheelRadius, WheelMass, 10 )
	end
	self:AddEngineSound( Vector(0,0,30) )

	self:SetPos(self:GetPos() - Vector(0,0,25) )

end

function ENT:OnTick()

end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

