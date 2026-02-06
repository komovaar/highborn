AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("BGTrader.Open")
util.AddNetworkString("BGTrader.Buy")

-- ================================
-- INITIALIZE
-- ================================
function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Wake()
    end

    self:SetUseType(SIMPLE_USE)
end

-- ================================
-- USE (НАЖАТИЕ E)
-- ================================
function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    net.Start("BGTrader.Open")
    net.Send(activator)
end

-- ================================
-- BUY BODYGROUP
-- ================================
net.Receive("BGTrader.Buy", function(_, ply)
    local bgKey = net.ReadString()
    local value = net.ReadUInt(8)

    local model = ply:GetModel()
    local cfg = BodygroupTraderConfig.Models[model]
    if not cfg then return end

    local bg = cfg[bgKey]
    if not bg then return end

    if bg.vip and not BodygroupTraderConfig.IsVIP(ply) then
        ply:ChatPrint("❌ Доступно лише для VIP")
        return
    end

    local money = ply:getDarkRPVar("money") or 0
    if money < bg.price then
        ply:ChatPrint("❌ Недостатньо коштів")
        return
    end

    ply:addMoney(-bg.price)

    ply:SetPData("bg_" .. bgKey, value)
    ply:SetBodygroup(bg.id, value)

    ply:ChatPrint("✅ Придбано: " .. bg.name)
end)

-- ================================
-- APPLY ON SPAWN
-- ================================
hook.Add("PlayerSpawn", "BGTrader.ApplySaved", function(ply)
    timer.Simple(0.2, function()
        if not IsValid(ply) then return end

        local model = ply:GetModel()
        local cfg = BodygroupTraderConfig.Models[model]
        if not cfg then return end

        for key, bg in pairs(cfg) do
            local saved = ply:GetPData("bg_" .. key)
            if saved then
                ply:SetBodygroup(bg.id, tonumber(saved))
            end
        end
    end)
end)
