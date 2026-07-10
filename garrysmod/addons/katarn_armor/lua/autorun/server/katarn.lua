AddCSLuaFile()

util.AddNetworkString("Katarn_RemoveSuit")

-- ConVars
local cv_max_armor = CreateConVar("katarn_max_armor", "75", FCVAR_ARCHIVE)
local cv_max_energy = CreateConVar("katarn_max_energy", "75", FCVAR_ARCHIVE)
local cv_regen = CreateConVar("katarn_energy_regen", "1", FCVAR_ARCHIVE)

-- Player meta
local meta = FindMetaTable("Player")

function meta:SetExoSuit(str)
    self:SetNWString("hgexosuit", str)
    self:SetNWFloat("exoarmor", cv_max_armor:GetFloat())
    self:SetNWFloat("exoenergy", cv_max_energy:GetFloat())
end

function meta:RemoveExoSuit()
    self:SetNWString("hgexosuit", "")
end

net.Receive("Katarn_RemoveSuit", function(_, ply)
    if not IsValid(ply) or ply:GetNWString("hgexosuit") == "" then return end

    ply:RemoveExoSuit()
end)

local RC_JOBS = {}

hook.Add("PlayerSpawn", "KatarnAutoGive", function(ply)
    timer.Simple(0.3, function()
        if not IsValid(ply) then return end

        local jobName = team.GetName(ply:Team()) or ""
        jobName = string.lower(jobName)

        if string.find(jobName, "%f[%a]rc%f[%A]") then
            ply:SetExoSuit("katarn")
        else
            ply:RemoveExoSuit()
        end
    end)
end)

-- ⚡ ENERGY REGEN
hook.Add("PlayerPostThink", "Katarn_Regen", function(ply)
    if ply:GetNWString("hgexosuit") == "" then return end

    local en = ply:GetNWFloat("exoenergy")
    local max_en = cv_max_energy:GetFloat()
    local regen = cv_regen:GetFloat()

    if en < max_en and CurTime() > ply:GetNWFloat("exoenergy_nxt", 0) then
        if ply:GetNWFloat("exoarmor") > 0 then
            ply:SetNWFloat("exoenergy", math.min(en + regen, max_en))
        else
            ply:SetNWFloat("exoenergy", math.min(en + (regen * 0.3), max_en))
        end
    end
end)

-- 💥 DAMAGE SYSTEM
hook.Add("EntityTakeDamage", "Katarn_Damage", function(target, dmginfo)
    if not target:IsPlayer() then return end

    local ply = target
    if ply:GetNWString("hgexosuit") == "" then return end

    local en = ply:GetNWFloat("exoenergy")
    local ar = ply:GetNWFloat("exoarmor")

    if en > 0 then
        ply:SetNWFloat("exoenergy", en - dmginfo:GetDamage())
        ply:SetNWFloat("exoenergy_nxt", CurTime() + 2)
        dmginfo:ScaleDamage(0)

    elseif ar > 0 then
        ply:SetNWFloat("exoarmor", ar - dmginfo:GetDamage() * 0.5)
        dmginfo:ScaleDamage(0.1)
    end
end)

-- ❌ REMOVE ON DEATH
hook.Add("PlayerDeath", "Katarn_Remove", function(ply)
    ply:RemoveExoSuit()
end)

hook.Add("OnPlayerChangedTeam", "Katarn_Refresh", function(ply)
    timer.Simple(0.3, function()
        if not IsValid(ply) then return end

        local jobName = team.GetName(ply:Team()) or ""
        jobName = string.lower(jobName)

        if string.find(jobName, "%f[%a]rc%f[%A]") then
            ply:SetExoSuit("katarn")
        else
            ply:RemoveExoSuit()
        end
    end)
end)
