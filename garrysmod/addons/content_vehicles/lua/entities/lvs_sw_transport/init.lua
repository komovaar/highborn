AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2500 )

	local DriverSeat = self:AddDriverSeat( Vector(29,0,26), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(-120,0,0)

	for i = 0, 3 do
		self:AddPassengerSeat( Vector(10-i*20,20,23), Angle(0,180,0) ).ExitPos = Vector(10-i*20,100,23)
	end

	for i = 0, 3 do
		self:AddPassengerSeat( Vector(10-i*20,-20,23), Angle(0,0,0) ).ExitPos = Vector(10-i*20,-100,23)
	end

	local WheelMass = 25
	local WheelRadius = 14
	local WheelPos = {
		Vector(-85,-40,-8),
		Vector(-5,-40,-8),
		Vector(70,-40,-8),
		Vector(-85,40,-8),
		Vector(-5,40,-8),
		Vector(70,40,-8),
	}

	for _, Pos in pairs( WheelPos ) do
		self:AddWheel( Pos, WheelRadius, WheelMass, 10 )
	end

	self:AddEngineSound( Vector(0,0,0) )
end

function ENT:OnCollision( data, physobj )
	if self:WorldToLocal( data.HitPos ).z < 0 then return true end -- dont detect collision when the lower part of the model touches the ground
	return false
end

function ENT:OnVehicleSpecificToggled( IsActive )
	self:SetLightOn(!self:GetLightOn())
	self:EmitSound( "buttons/lightswitch2.wav", 75, 105 )
end

local transports = {}
local beepDelay = 1.2

local reverseSound = function(ply, cmd)
	if not ply.lvsGetVehicle then return end
	local veh = ply:lvsGetVehicle()
	if not IsValid( veh ) then return end
	if not transports[veh:EntIndex()] then return end
	if not cmd:KeyDown( IN_BACK ) then return end
	if transports[veh:EntIndex()].nextBeep > CurTime() then return end
	transports[veh:EntIndex()].nextBeep = CurTime() + beepDelay
	veh:EmitSound( "lvs_sw_transporter/reverse.wav", 75)
end

hook.Add("OnEntityCreated", "lvs_sw_transport_created", function(ent)
	if not IsValid(ent) or not (ent:GetClass() == "lvs_sw_transport") then return end
	if table.IsEmpty(transports) then
		hook.Add("StartCommand", "lvs_sw_transport_reverse_sound", reverseSound)
	end
	transports[ent:EntIndex()] = {ent = ent, nextBeep = 0}
end)

hook.Add("EntityRemoved", "lvs_sw_transport_removed", function(ent, fullUpdate)
	if (not ent:GetClass() == "lvs_sw_transport") or fullUpdate then return end
	transports[ent:EntIndex()] = nil
	if table.IsEmpty(transports) then
		hook.Remove("StartCommand", "lvs_sw_transport_reverse_sound")
	end
end)