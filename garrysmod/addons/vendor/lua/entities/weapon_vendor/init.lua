AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("WeaponTrader.Open")
util.AddNetworkString("WeaponTrader.Buy")
util.AddNetworkString("WeaponTrader.ToggleStorage")

sql.Query([[
    CREATE TABLE IF NOT EXISTS perma_weapons (
        steamid TEXT,
        weapon TEXT,
        stored INTEGER DEFAULT 0
    )
]])

local function IsBlockedJob(ply)
    local job = ply:getDarkRPVar("job")
    if not job then return false end
    return Vendor.BlockedJobs[job] == true
end

local function GivePermaWeapons(ply)
    if not IsValid(ply) then return end

    if IsBlockedJob(ply) then
        ply:StripWeapons()
        return
    end

    timer.Simple(0.1, function()
        if not IsValid(ply) then return end

        local data = sql.Query(
            "SELECT weapon FROM perma_weapons WHERE steamid = " ..
            sql.SQLStr(ply:SteamID()) ..
            " AND stored = 0"
        )

        if not data then return end

        for _, row in ipairs(data) do
            if weapons.Get(row.weapon) and not ply:HasWeapon(row.weapon) then
                ply:Give(row.weapon)
            end
        end
    end)
end

hook.Add("PlayerSpawn", "PermaWeaponsSpawn", GivePermaWeapons)
hook.Add("OnPlayerChangedTeam", "PermaWeaponsJobCheck", function(ply)
    timer.Simple(0, function()
        if IsValid(ply) then
            GivePermaWeapons(ply)
        end
    end)
end)

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
     local data = sql.Query(
        "SELECT weapon, stored FROM perma_weapons WHERE steamid = " ..
        sql.SQLStr(activator:SteamID())
    )

    net.Start("WeaponTrader.Open")
        if data then 
            net.WriteTable(data, false)
        end
    net.Send(activator)

end

net.Receive("WeaponTrader.Buy", function(_, ply)
    local weaponClass = net.ReadString()

    if IsBlockedJob(ply) then
        return
    end

    for _, wep in ipairs(Vendor.Weapons) do
        if wep.class == weaponClass then

            local money = ply:getDarkRPVar("money") or 0
            if money < wep.price then
                return
            end

            local exists = sql.QueryRow(
                "SELECT weapon FROM perma_weapons WHERE steamid = " ..
                sql.SQLStr(ply:SteamID()) ..
                " AND weapon = " ..
                sql.SQLStr(weaponClass)
            )

            if exists then
                return
            end

            ply:addMoney(-wep.price)

            sql.Query(
                "INSERT INTO perma_weapons (steamid, weapon, stored) VALUES (" ..
                sql.SQLStr(ply:SteamID()) .. ", " ..
                sql.SQLStr(weaponClass) .. ", 0)"
            )

            timer.Simple(0.1, function()
                if IsValid(ply) and not IsBlockedJob(ply) then
                    ply:Give(weaponClass)
                    ply:SelectWeapon(weaponClass)
                end
            end)
            return
        end
    end
end)


net.Receive("WeaponTrader.ToggleStorage", function(_, ply)
    local class = net.ReadString()

    local row = sql.QueryRow(
        "SELECT stored FROM perma_weapons WHERE steamid = " ..
        sql.SQLStr(ply:SteamID()) ..
        " AND weapon = " ..
        sql.SQLStr(class)
    )

    if not row then return end

    local newState = tonumber(row.stored) == 1 and 0 or 1

    sql.Query(
        "UPDATE perma_weapons SET stored = " .. newState ..
        " WHERE steamid = " .. sql.SQLStr(ply:SteamID()) ..
        " AND weapon = " .. sql.SQLStr(class)
    )

    if newState == 1 then
        if ply:HasWeapon(class) then
            ply:StripWeapon(class)
        end
    else
        if not IsBlockedJob(ply) then
            ply:Give(class)
        end
    end
end)
