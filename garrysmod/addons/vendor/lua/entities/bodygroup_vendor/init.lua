AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("BGTrader.Open")
util.AddNetworkString("BGTrader.Buy")
util.AddNetworkString("BGTrader.Remove")

-- ======================================================
-- DATABASE
-- ======================================================

sql.Query([[
CREATE TABLE IF NOT EXISTS bodygroup_purchases (
    steamid TEXT,
    model TEXT,
    bg_key TEXT,
    owned_value INTEGER,
    equipped INTEGER,
    PRIMARY KEY (steamid, model, bg_key)
)
]])


-- ======================================================
-- ENTITY
-- ======================================================

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
    if not IsValid(ply) then return end

    local rows = sql.Query(string.format(
        "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s",
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(ply:GetModel())
    )) or {}

    net.Start("BGTrader.Open")
        net.WriteTable(rows)
    net.Send(ply)
end


-- ======================================================
-- BUY
-- ======================================================

net.Receive("BGTrader.Buy", function(_, ply)

    local bgID = net.ReadUInt(8)
    local value = net.ReadUInt(8)

    local model = ply:GetModel()
    local cfg = Vendor.Models[model]
    if not cfg then return end

    local bgKey
    local bgData

    for key, data in pairs(cfg) do
        if data.id == bgID then
            bgKey = key
            bgData = data
            break
        end
    end

    if not bgKey then return end

    local row = sql.QueryRow(string.format(
        "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s AND bg_key=%s",
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(model),
        sql.SQLStr(bgKey)
    ))

    if not row then
        -- Первая покупка
        local money = ply:getDarkRPVar("money") or 0
        if money < bgData.price then return end
        ply:addMoney(-bgData.price)

        sql.Query(string.format([[
            INSERT INTO bodygroup_purchases
            (steamid, model, bg_key, owned_value, equipped)
            VALUES (%s,%s,%s,%d,1)
        ]],
            sql.SQLStr(ply:SteamID()),
            sql.SQLStr(model),
            sql.SQLStr(bgKey),
            value
        ))
    else
        sql.Query(string.format([[
            UPDATE bodygroup_purchases
            SET equipped=1
            WHERE steamid=%s AND model=%s AND bg_key=%s
        ]],
            sql.SQLStr(ply:SteamID()),
            sql.SQLStr(model),
            sql.SQLStr(bgKey)
        ))
    end

    ply:SetBodygroup(bgID, value)
end)


net.Receive("BGTrader.Remove", function(_, ply)

    local bgID = net.ReadUInt(8)
    local model = ply:GetModel()

    local cfg = Vendor.Models[model]
    if not cfg then return end

    local bgKey

    for key, data in pairs(cfg) do
        if data.id == bgID then
            bgKey = key
            break
        end
    end

    if not bgKey then return end

    sql.Query(string.format([[
        UPDATE bodygroup_purchases
        SET equipped=0
        WHERE steamid=%s AND model=%s AND bg_key=%s
    ]],
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(model),
        sql.SQLStr(bgKey)
    ))

    ply:SetBodygroup(bgID, 0)
end)


hook.Add("PlayerSpawn", "BGTrader.ApplySaved", function(ply)

    timer.Simple(0.2, function()

        if not IsValid(ply) then return end

        local model = ply:GetModel()

        local rows = sql.Query(string.format(
            "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s",
            sql.SQLStr(ply:SteamID()),
            sql.SQLStr(model)
        ))

        if not rows then return end

        local cfg = Vendor.Models[model]
        if not cfg then return end

        for _, row in ipairs(rows) do
            if tonumber(row.equipped) == 1 then
                local key = row.bg_key
                if cfg[key] then
                    ply:SetBodygroup(cfg[key].id, tonumber(row.owned_value))
                end
            end
        end

    end)
end)
