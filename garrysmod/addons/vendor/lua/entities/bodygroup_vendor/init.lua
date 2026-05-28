AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("BGTrader.Open")
util.AddNetworkString("BGTrader.Buy")
util.AddNetworkString("BGTrader.Remove")
util.AddNetworkString("BGTrader.Update")

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

    SendBGTraderState(ply, "open")
end

function SendBGTraderState(ply, status, success)
    if not IsValid(ply) then return end

    local rows = sql.Query(string.format(
        "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s",
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(ply:GetModel())
    )) or {}

    net.Start(status == "open" and "BGTrader.Open" or "BGTrader.Update")
        net.WriteTable(rows)
        if status != "open" then
            net.WriteBool(success == true)
        end
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
    if not cfg then SendBGTraderState(ply) return end

    local bgKey
    local bgData

    for key, data in pairs(cfg) do
        if data.id == bgID and value == data.default then
            bgKey = key
            bgData = data
            break
        end
    end

    if not bgKey then SendBGTraderState(ply) return end
    
    local vip1 = "STEAM_0:1:511487927"
    local vip2 = "STEAM_0:1:544475913"
	local vip3 = "STEAM_0:1:628530303"
    local vip4 = "STEAM_0:1:522577115"
    local vip5 = "STEAM_0:0:549149559"
    if bgData.vip and not ply:IsUserGroup("vip") and ply:SteamID() != vip1 and ply:SteamID() != vip2 and ply:SteamID() != vip3  and ply:SteamID() != vip4 and ply:SteamID() != vip5 then
        SendBGTraderState(ply)
        return
    end

    local row = sql.QueryRow(string.format(
        "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s AND bg_key=%s",
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(model),
        sql.SQLStr(bgKey)
    ))

    if not row then
        local money = ply:getDarkRPVar("money") or 0
        if money < bgData.price then SendBGTraderState(ply) return end
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
            SET equipped=1, owned_value=%d
            WHERE steamid=%s AND model=%s AND bg_key=%s
        ]],
            value,
            sql.SQLStr(ply:SteamID()),
            sql.SQLStr(model),
            sql.SQLStr(bgKey)
        ))
    end

    if bgKey == "jetpack" then
        if IsValid(ply:GetNWEntity("Jetted")) then SendBGTraderState(ply, nil, true) return end

        local jp = ents.Create("mk1")
        if not IsValid(jp) then SendBGTraderState(ply) return end

        jp:SetSlotName("mk1")
        jp:Spawn()
        jp:Attach(ply)

        ply:SetNWEntity("Jetted", jp)

    end

    ply:SetBodygroup(bgID, value)
    SendBGTraderState(ply, nil, true)
end)


net.Receive("BGTrader.Remove", function(_, ply)

    local bgID = net.ReadUInt(8)
    local value = net.ReadUInt(9)
    local model = ply:GetModel()

    local cfg = Vendor.Models[model]
    if not cfg then SendBGTraderState(ply) return end

    local bgKey
    local bgData

    for key, data in pairs(cfg) do
        if data.id == bgID and value == data.default then
            bgKey = key
            bgData = data
            break
        end
    end

    if not bgKey then SendBGTraderState(ply) return end

    local jp = ply:GetNWEntity("Jetted")
    if IsValid(jp) then
        jp:Remove()
        ply:SetNWEntity("Jetted", NULL)
    end

    sql.Query(string.format([[
        UPDATE bodygroup_purchases
        SET equipped=0
        WHERE steamid=%s AND model=%s AND bg_key=%s
    ]],
        sql.SQLStr(ply:SteamID()),
        sql.SQLStr(model),
        sql.SQLStr(bgKey)
    ))

    ply:SetBodygroup(bgID, bgData.off or 0)
    SendBGTraderState(ply, nil, true)
end)


hook.Add("PlayerSpawn", "BGTrader.ApplySavedBodygroups", function(ply)
    timer.Simple(0.5, function()
        if not IsValid(ply) or not ply:Alive() then return end

        local model = ply:GetModel()
        local rows = sql.Query(string.format(
            "SELECT * FROM bodygroup_purchases WHERE steamid=%s AND model=%s AND equipped=1",
            sql.SQLStr(ply:SteamID()),
            sql.SQLStr(model)
        )) or {}

        local cfg = Vendor.Models[model]
        if not cfg then return end

        for _, row in pairs(rows) do
            local bgKey = row.bg_key
            local value = tonumber(row.owned_value) or 0
            local data = cfg[bgKey]
            if data then
                ply:SetBodygroup(data.id, value)

                if bgKey == "jetpack" then
                    local jp = ents.Create("mk1")
                    if not IsValid(jp) then return end
                    jp:SetSlotName("mk1")
                    jp:Spawn()

                    if IsValid(ply:GetActiveWeapon()) then
                        jp:Attach(ply)
                        ply:SetNWEntity("Jetted", jp)
                    else
                        timer.Simple(0.1, function()
                            if IsValid(ply) and IsValid(jp) then
                                jp:Attach(ply)
                                ply:SetNWEntity("Jetted", jp)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)

hook.Add("PlayerSetModel", "RemoveJetpackOnModelChange", function(ply)
    local jp = ply:GetNWEntity("Jetted")
    if IsValid(jp) and ply:GetModel() != "models/jajoff/sps/jlmbase/merrankrieg2021.mdl" then
        jp:Remove()
        ply:SetNWEntity("Jetted", NULL)
    end
end)

hook.Add("PlayerSpawn", "BGTrader.ApplyJetpackMando", function(ply)
    timer.Simple(0.5, function()
        if not IsValid(ply) or not ply:Alive() then return end
        local model = ply:GetModel()
        if model == "models/jajoff/sps/jlmbase/merrankrieg2021.mdl" then
            local jp = ents.Create("mk1")
            if not IsValid(jp) then return end
            jp:SetSlotName("mk1")
            jp:Spawn()

            if IsValid(ply:GetActiveWeapon()) then
                jp:Attach(ply)
                ply:SetNWEntity("Jetted", jp)
            else
                timer.Simple(0.1, function()
                    if IsValid(ply) and IsValid(jp) then
                        jp:Attach(ply)
                        ply:SetNWEntity("Jetted", jp)
                    end
                end)
            end
        end
    end)
end)
