AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
util.AddNetworkString("OpenTerminal")
util.AddNetworkString("OpenError")
util.AddNetworkString("EjectDisk")
util.AddNetworkString("WriteValue")
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel( "models/starwars/syphadias/props/sw_tor/bioware_ea/props/imperial/imp_holo_console.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetNWBool("CardInsert", false)
	self:SetNWBool("IsWorking", true)
	self.DiskContent = {}
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end
end
 
function ENT:Use( ply, caller )

	local tr = util.TraceLine( {
	start = self:GetPos(),
	endpos = self:GetPos() + self:GetAngles():Up() * -20,
	filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
	} ) 

	if not (tr.Hit) then return end

	if self:GetNWBool("IsWorking") then
		net.Start("OpenTerminal")
		net.WriteTable(self.DiskContent)
		net.WriteEntity(self)
		net.Send(ply)
	else
		net.Start("OpenError")
		net.Send(ply)
	end
	return ent
end

function ENT:Think()
end

function ENT:Touch( entity )
	if string.sub(entity:GetClass(), 1, 8) == "diskcard" and self:GetNWBool("CardInsert") == false and self:GetNWBool("IsWorking") then
		self:EmitSound("bin/insert.wav")
		self.DiskContent = entity.DiskContent
		self:SetNWBool("CardInsert", true)
		entity:Remove()
	end
end

net.Receive("WriteValue", function()
	local NEnt = net.ReadEntity()
	local NTab = net.ReadTable()
	NEnt.DiskContent[NTab.Index] = NTab.Value
end)


net.Receive("EjectDisk", function()
	local NEnt = net.ReadEntity()
	
	NEnt:EmitSound("bin/eject.wav")
	
	local disk = ents.Create( "diskcard_" .. NEnt.DiskContent.Size )
	disk:SetPos( NEnt:GetPos() + NEnt:GetAngles():Forward() * 30 + NEnt:GetAngles():Right() * 40) 
	disk:Spawn()
	disk.DiskContent = NEnt.DiskContent
	disk:SetNWString("DN", NEnt.DiskContent["Author"])
	
	NEnt.DiskContent = {}
	NEnt:SetNWBool("CardInsert", false) 
end)














