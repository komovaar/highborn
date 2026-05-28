AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("RepTerminal_OpenUI")
util.AddNetworkString("RepTerminal_RepairSuccess")

function ENT:Initialize()
    self:SetModel("models/lordtrilobite/starwars/isd/imp_console_medium01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetTerminalHealth(100)
    self:SetIsBroken(false)
end

-- scan NPC
function ENT:ScanEnemies()
    local count = 0
    local pos = self:GetPos()
    for _, ent in ipairs(ents.FindInSphere(pos, 10000)) do
        if ent:IsNPC() then
            count = count + 1
        end
    end
    return count
end

function ENT:Use(activator)
    if not activator:IsPlayer() then return end
    
    
    local enemyCount = self:ScanEnemies()
    
    net.Start("RepTerminal_OpenUI")
    net.WriteEntity(self)
    net.WriteBool(self:GetIsBroken())
    net.WriteInt(enemyCount, 16)
    net.Send(activator)
end


function ENT:OnTakeDamage(dmg)
    if self:GetIsBroken() then return end
    local newHealth = self:GetTerminalHealth() - dmg:GetDamage()
    self:SetTerminalHealth(math.max(0, newHealth))
    if self:GetTerminalHealth() <= 0 then
        self:SetIsBroken(true)
        self:EmitSound("ambient/energy/zap1.wav")
    end
end

net.Receive("RepTerminal_RepairSuccess", function(len, ply)
    local ent = net.ReadEntity()
    if IsValid(ent) and ply:GetPos():DistToSqr(ent:GetPos()) < 20000 then
        ent:SetIsBroken(false)
        ent:SetTerminalHealth(100)
    end
end)