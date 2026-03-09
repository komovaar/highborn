AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Tibanna Charge Pack"
ENT.Category = "Osmonium Armory"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.UseTimer = CurTime()

ENT.Model = "models/cs574/objects/ammo_box.mdl"

function ENT:SpawnFunction( ply, tr, ClassName )
if ( !tr.Hit ) then return end
    local SpawnPos = tr.HitPos + tr.HitNormal * 10
    pAngle = ply:GetAngles()
    pAngle.pitch = pAngle.pitch
    pAngle.roll = pAngle.roll 
    pAngle.yaw = pAngle.yaw + 180
    local ent = ents.Create( ClassName ) 
    ent:SetPos( SpawnPos - Vector(0,0,-10) )
    ent:SetAngles( pAngle )
    ent:Spawn()
    ent:Activate()
    return ent	
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    if SERVER then
        self:SetModel( "models/cs574/objects/ammo_box.mdl" )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
        self:SetTrigger(true)
        
    end
end

function ENT:Use( activator, caller )
	local dispencer_ammo_basic_count = GetConVar("rw_sw_dispenser_ammo_basic_count"):GetInt()
    if self.UseTimer <= CurTime() and activator:IsPlayer() then
        activator:GiveAmmo(dispencer_ammo_basic_count, "ar2", false )
        self:Remove()
    end
end

function ENT:PhysicsCollide( data, phys )
end