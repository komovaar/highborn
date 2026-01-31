AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("WeaponTrader.Open")
util.AddNetworkString("WeaponTrader.Buy")

sql.Query([[
    CREATE TABLE IF NOT EXISTS perma_weapons (
        steamid TEXT,
        weapon TEXT
    )
]])

local function IsBlockedJob(ply)
    local job = ply:getDarkRPVar("job")
    if not job then return false end
    return WeaponTraderConfig.BlockedJobs[job] == true
end

function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE) -- ⭐ ОБЯЗАТЕЛЬНО

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    net.Start("WeaponTrader.Open")
    net.Send(activator)
end



net.Receive("WeaponTrader.Buy", function(_, ply)
    local weaponClass = net.ReadString()

    if IsBlockedJob(ply) then
        ply:ChatPrint("🚫 Ваша профессия не может использовать оружие")
        return
    end

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        if wep.class == weaponClass then

            local money = ply:getDarkRPVar("money") or 0
            if money < wep.price then
                ply:ChatPrint("❌ Недостаточно денег")
                return
            end

            local exists = sql.QueryRow(
                "SELECT weapon FROM perma_weapons WHERE steamid = " ..
                sql.SQLStr(ply:SteamID()) ..
                " AND weapon = " ..
                sql.SQLStr(weaponClass)
            )

            if exists then
                ply:ChatPrint("ℹ️ У вас уже есть это оружие")
                return
            end

            ply:addMoney(-wep.price)

            sql.Query("INSERT INTO perma_weapons VALUES (" ..
                sql.SQLStr(ply:SteamID()) .. ", " ..
                sql.SQLStr(weaponClass) .. ")")

            timer.Simple(0.1, function()
                if IsValid(ply) and not IsBlockedJob(ply) then
                    ply:Give(weaponClass)
                    ply:SelectWeapon(weaponClass)
                end
            end)

            ply:ChatPrint("✅ Оружие приобретено")
            return
        end
    end
end)
