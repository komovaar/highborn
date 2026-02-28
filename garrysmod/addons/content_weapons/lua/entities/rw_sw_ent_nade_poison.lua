ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Dioxis Grenade"
ENT.Spawnable = false

ENT.BounceSound = Sound("weapons/tfa_csgo/smokegrenade/grenade_hit1.wav")
ENT.ExplodeSound = Sound("weapons/tfa_starwars/Smoke_Explosive_Puff_01.wav")

AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/forrezzur/dioxisgrenade.mdl") 
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
    self:EmitSound("weapons/tfa_csgo/smokegrenade/pinpull.wav")
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

local function ApplyDamageAndPunch(ply)
    if IsValid(ply) then
        local damageAmount = math.max(math.ceil(ply:GetMaxHealth() * 0.02), 1)
        
        local damage = DamageInfo()
        damage:SetDamage(damageAmount)
        damage:SetAttacker(ply)
        damage:SetDamageType(DMG_FALL)
        ply:TakeDamageInfo(damage)
        ply:ViewPunch(Angle(math.random(-3, 3), math.random(-2, 2), math.random(-2, 2)))
    end
end

local function EmitCoughSound(ply)
    if IsValid(ply) then
        ply:EmitSound("ambient/voices/cough" .. math.random(1, 3) .. ".wav")
    end
end

function ENT:Think()
    if SERVER then
        if CurTime() > self.Delay and not self.IsDetonated then
            self:Detonate(self:GetPos())
            self.IsDetonated = true
        end
    end

    if self.IsDetonated then
        for _, v in pairs(ents.FindInSphere(self:GetPos(), 216)) do
            if v:IsPlayer() then
                if self.DamageCount % 8 == 0 then
                    EmitCoughSound(v)
                end
                ApplyDamageAndPunch(v)
                self.DamageCount = self.DamageCount + 1
            end
        end
        self:NextThink(CurTime() + 0.2)
        return true
    end
end

function ENT:Detonate(pos)
    if SERVER then
        self:SetNWBool("IsDetonated", true)
        self:EmitSound(self.ExplodeSound)
        local gas = EffectData()
        gas:SetOrigin(pos)
        util.Effect("tfa_csgo_poisonade", gas)
    end
    
    self:SetMoveType(MOVETYPE_NONE)
    
    if SERVER then
        SafeRemoveEntityDelayed(self, 30)
    end
end

function ENT:Draw()
    self:DrawModel()
end
