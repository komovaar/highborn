AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("BGTrader.Open")
util.AddNetworkString("BGTrader.Buy")

-- SQL
if not sql.TableExists("bg_trader") then
    sql.Query([[
        CREATE TABLE bg_trader (
            steamid TEXT,
            bgid INTEGER,
            value INTEGER
        )
    ]])
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    net.Start("BGTrader.Open")
    net.Send(ply)
end

net.Receive("BGTrader.Buy", function(_, ply)
    local bgid  = net.ReadUInt(8)
    local value = net.ReadUInt(8)

    ply:SetBodygroup(bgid, value)

    sql.Query("DELETE FROM bg_trader WHERE steamid = " ..
        sql.SQLStr(ply:SteamID()) .. " AND bgid = " .. bgid)

    sql.Query("INSERT INTO bg_trader VALUES (" ..
        sql.SQLStr(ply:SteamID()) .. ", " .. bgid .. ", " .. value .. ")")
end)

hook.Add("PlayerSpawn", "BGTrader.Load", function(ply)
    timer.Simple(0.2, function()
        if not IsValid(ply) then return end

        local data = sql.Query("SELECT * FROM bg_trader WHERE steamid = " ..
            sql.SQLStr(ply:SteamID()))

        if not data then return end

        for _, row in ipairs(data) do
            ply:SetBodygroup(tonumber(row.bgid), tonumber(row.value))
        end
    end)
end)
