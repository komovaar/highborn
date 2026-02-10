AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("BGTrader.Open")
util.AddNetworkString("BGTrader.Buy")

local function GetPlayerBodygroups(ply)
    local data = {}

    local rows = sql.Query(
        "SELECT * FROM bodygroup_purchases WHERE steamid = " .. sql.SQLStr(ply:SteamID())
    )

    if rows then
        for _, row in ipairs(rows) do
            data[row.bg_key] = tonumber(row.bg_value)
        end
    end

    return data
end




function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    net.Start("BGTrader.Open")
    net.Send(ply)
end

net.Receive("BGTrader.Buy", function(_, ply)
    local bgKey = net.ReadString()
    local value = net.ReadUInt(8)

    local model = ply:GetModel()
    local cfg = Vendor.Models[model]
    if not cfg then return end

    local bg = cfg[bgKey]
    if not bg then return end

    if bg.vip and not Vendor.IsVIP(ply) then
        return
    end

    local saved = ply:GetPData("bg_" .. bgKey)
    if not saved then
        local money = ply:getDarkRPVar("money") or 0
        if money < bg.price then
            return
        end
        ply:addMoney(-bg.price)
    end

    ply:SetPData("bg_" .. bgKey, value)
    ply:SetBodygroup(bg.id, value)

end)

hook.Add("PlayerSpawn", "BGTrader.ApplySaved", function(ply)
    timer.Simple(0.2, function()
        if not IsValid(ply) then return end

        local cfg = Vendor.Models[ply:GetModel()]
        if not cfg then return end

        for key, bg in pairs(cfg) do
            local val = ply:GetPData("bg_" .. key)
            if val then
                ply:SetBodygroup(bg.id, tonumber(val))
            end
        end
    end)
end)
