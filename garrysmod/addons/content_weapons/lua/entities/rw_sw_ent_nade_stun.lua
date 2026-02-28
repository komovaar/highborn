ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Shock Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 

ENT.BounceSound = Sound("weapons/tfa_csgo/smokegrenade/grenade_hit1.wav")
ENT.ExplodeSound = Sound("weapons/tfa_starwars/Shock_Explosion_02.wav")

AddCSLuaFile()

local freezeDuration = 5 -- Freeze duration in seconds
local damagePercentage = 0.005 -- Damage as a percentage of max health
-- local damageType = DMG_SHOCK -- Damage type
local effectInterval = 0.25 -- Interval to apply the TeslaHitBoxes effect and damage
local damageInterval = 0.5 -- Damage interval in seconds

-- Function to apply freeze, damage, and screen fade to a player
local function ApplyFreeze(ply)
    if IsValid(ply) and ply:Alive() then
        ply:Freeze(true)
        
        local damageTimer = "TeslaDamage_" .. ply:UserID()
        local damageCount = 0
        
        timer.Create(damageTimer, damageInterval, 0, function()
            if IsValid(ply) and ply:Alive() then
                damageCount = damageCount + 1
                if damageCount * damageInterval <= freezeDuration then
                    ply:ViewPunch(Angle(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2)))
                    local fx = EffectData()
                    fx:SetOrigin(ply:GetPos())
                    fx:SetMagnitude(5)
                    util.Effect("TeslaHitBoxes", fx)
                    local damageAmount = math.max(ply:GetMaxHealth() * damagePercentage, 1)
                    ply:TakeDamage(damageAmount)
                    ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 100), 0.2, 0)
					--ply:EmitSound("weapons/stunstick/spark".. math.random(1, 3) ..".wav")
                else
                    ply:Freeze(false)
                    timer.Remove(damageTimer)
                end
            else
                ply:Freeze(false)
                timer.Remove(damageTimer)
            end
        end)
    end
end

-- Hook to detect players entering the freeze radius
hook.Add("PlayerEnteredFreezeRadius", "PlayerEnteredFreezeRadius", function(ply)
    ApplyFreeze(ply)
end)

hook.Add("PlayerLeftFreezeRadius", "PlayerLeftFreezeRadius", function(ply)
    if IsValid(ply) then
        ply:Freeze(false)
        timer.Remove("TeslaDamage_" .. ply:UserID())
    end
end)

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/weapons/tfa_starwars/w_flash.mdl") 
  self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
        end
        
        self.Delay = CurTime() + 2
        self.IsDetonated = false
        self.DamageCount = 0
    end
    self:EmitSound("weapons/tfa_starwars/Shock_Charge_01.wav")
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        self.HitP = data.HitPos
        self.HitN = data.HitNormal

        if self:GetVelocity():Length() > 60 then
            self:EmitSound(self.BounceSound)
        end
        
        if self:GetVelocity():Length() < 5 then
            self:SetMoveType(MOVETYPE_NONE)
        end
        
    end
end

function ENT:Think()
    if SERVER then    
        if CurTime() > self.Delay then
            if self.IsDetonated == false then
                self:Detonate()
                self.IsDetonated = true
                
                -- Player entered the freeze radius after detonation
                for _, v in pairs(ents.FindInSphere(self:GetPos(), 260)) do
                    if v:IsPlayer() then
                        hook.Call("PlayerEnteredFreezeRadius", nil, v)
                    end
                end
            end
        end
    end
end

function ENT:Detonate()
    self.ParticleCreated = false
    self.ExtinguishParticleCreated = false
    if SERVER then
        if not self:IsValid() then return end
        self:SetNWBool("IsDetonated", true)
        self:EmitSound(self.ExplodeSound)
        
        local teslaRadius = 216
        local coneAngle = (360 * teslaRadius) / (2 * math.pi * teslaRadius)
        
        local lightningPos = self:GetPos()
        
        timer.Create("tesla_zap" .. self:EntIndex(), math.Rand(0.03, 0.1), math.random(12, 15), function()
            local lightning = ents.Create("point_tesla")
            lightning:SetPos(lightningPos)
            lightning:SetKeyValue("m_SoundName", "")
            lightning:SetKeyValue("texture", "sprites/physbeam.spr")
            lightning:SetKeyValue("m_Color", "255 255 255")
            lightning:SetKeyValue("m_flRadius", tostring(teslaRadius))
            lightning:SetKeyValue("beamcount_max", "15")
            lightning:SetKeyValue("thick_min", "25")
            lightning:SetKeyValue("thick_max", "40")
            lightning:SetKeyValue("lifetime_min", "0.15")
            lightning:SetKeyValue("lifetime_max", "0.4")
            lightning:SetKeyValue("interval_min", "0.15")
            lightning:SetKeyValue("interval_max", "0.25")
            lightning:SetKeyValue("spread", tostring(coneAngle))
            lightning:SetKeyValue("disposition", tostring(coneAngle))
            lightning:Spawn()
            lightning:Fire("DoSpark", "", 0)
            lightning:Fire("kill", "", 0.2)
        end)
    end
    
    self:SetMoveType(MOVETYPE_NONE)
    
    if SERVER then
        SafeRemoveEntityDelayed(self, 0.25)
    end
end


function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end
