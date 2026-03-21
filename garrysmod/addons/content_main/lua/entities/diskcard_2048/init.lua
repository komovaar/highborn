AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel( "models/lordtrilobite/starwars/props/imp_datatape.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self.DiskContent = 
	{
	Author = "---",
	Message = "This drive is empty.",
	Size = 2048,
	}

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetNWString("DN", self.DiskContent["Author"])
end
 
function ENT:Use( ply, caller )
	if ( self:IsPlayerHolding() ) then return end
		ply:PickupObject( self )
    return ent
end
 
function ENT:Think()
end

