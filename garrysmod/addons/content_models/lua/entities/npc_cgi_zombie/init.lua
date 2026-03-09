-- lua/entities/npc_cgi_zombie/init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_NPC)
    self:SetHealth(self.StartHealth)
    self:SetBloodColor(BLOOD_COLOR_RED)
    
    self.CustomZombieModel = self.Model
    self.CGI_NoScale = true
    
    self:RandomizeAppearance()
    
    if SERVER then
        self.loco:SetDesiredSpeed(50)
        self.loco:SetAcceleration(200)
        self.loco:SetJumpHeight(60)
        self.loco:SetStepHeight(18)
        self.loco:SetDeathDropHeight(200)
    end
    
    self.NextIdleSound = 0
    self.NextAttackSound = 0
    self.IsDead = false
    self.IsNextBot = true
    
    self:StartActivity(ACT_IDLE)
    
    timer.Create("ZombieIdle_" .. self:EntIndex(), 5, 0, function()
        if not IsValid(self) or self.IsDead then return end
        if math.random(1, 2) == 1 then
            self:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1, 14) .. ".wav", 75, math.random(95, 105))
        end
    end)
end

function ENT:RandomizeAppearance()
    local numSkins = self:SkinCount()
    if numSkins > 1 then
        self:SetSkin(math.random(0, numSkins - 1))
    end
    
    local numBodygroups = self:GetNumBodyGroups()
    for i = 0, numBodygroups - 1 do
        local numOptions = self:GetBodygroupCount(i)
        if numOptions > 1 then
            self:SetBodygroup(i, math.random(0, numOptions - 1))
        end
    end
    
    self.StoredSkin = self:GetSkin()
    self.StoredBodygroups = {}
    for i = 0, numBodygroups - 1 do
        self.StoredBodygroups[i] = self:GetBodygroup(i)
    end
    self.StoredColor = self:GetColor()
end

function ENT:OnTakeDamage(dmginfo)
    if not IsValid(self) or self.IsDead then return end
    
    local damage = dmginfo:GetDamage()
    local newHealth = self:Health() - damage
    self:SetHealth(math.max(newHealth, 0))
    
    if newHealth > 0 then
        self:EmitSound("npc/zombie/zombie_pain" .. math.random(1, 6) .. ".wav", 75, math.random(95, 105))
    end
    
    if newHealth <= 0 and not self.IsDead then
        self.IsDead = true
        self:SetHealth(0)
        
        timer.Remove("ZombieIdle_" .. self:EntIndex())
        
        self:EmitSound("npc/zombie/zombie_die" .. math.random(1, 3) .. ".wav", 75, 100)
        
        self:SetModel(self.CustomZombieModel)
    end
end

function ENT:RunBehaviour()
    while true do
        local enemy = self:FindNearestEnemy()
        
        if IsValid(enemy) and enemy:Health() > 0 then
            self:StartActivity(ACT_WALK)
            self:ChaseEnemy(enemy)
        else
            self:StartActivity(ACT_IDLE)
            self:Wander()
        end
        
        coroutine.yield()
    end
end

function ENT:FindNearestEnemy()
    local nearestDist = 1500
    local nearest = nil
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and ply:Health() > 0 then
            local dist = self:GetPos():DistToSqr(ply:GetPos())
            if dist < nearestDist * nearestDist then
                local tr = util.TraceLine({
                    start = self:GetPos() + Vector(0, 0, 50),
                    endpos = ply:GetPos() + Vector(0, 0, 50),
                    filter = self
                })
                
                if tr.Entity == ply or tr.Fraction > 0.9 then
                    nearestDist = math.sqrt(dist)
                    nearest = ply
                end
            end
        end
    end
    
    return nearest
end

function ENT:ChaseEnemy(enemy)
    if math.random(1, 3) == 1 then
        self:EmitSound("npc/zombie/zombie_alert" .. math.random(1, 3) .. ".wav", 80, math.random(95, 105))
    end
    
    local path = Path("Follow")
    path:SetMinLookAheadDistance(200)
    path:SetGoalTolerance(30)
    path:Compute(self, enemy:GetPos())
    
    if not path:IsValid() then 
        coroutine.wait(1)
        return 
    end
    
    local recheckTime = CurTime() + 0.5
    
    while path:IsValid() and IsValid(enemy) and enemy:Health() > 0 do
        if CurTime() > recheckTime then
            path:Compute(self, enemy:GetPos())
            recheckTime = CurTime() + 0.5
        end
        
        path:Update(self)
        
        self:SetAngles(Angle(0, (enemy:GetPos() - self:GetPos()):Angle().y, 0))
        
        local dist = self:GetPos():Distance(enemy:GetPos())
        if dist < 75 then
            self:Attack(enemy)
            coroutine.wait(1.5)
        end
        
        if dist > 2000 then
            break
        end
        
        coroutine.yield()
    end
end

function ENT:Attack(target)
    if not IsValid(self) or not IsValid(target) or self.IsDead then return end
    
    self:StartActivity(ACT_MELEE_ATTACK1)
    
    self:EmitSound("npc/zombie/zombie_attack" .. math.random(1, 3) .. ".wav", 85, math.random(95, 105))
    
    timer.Simple(0.3, function()
        if not IsValid(self) or not IsValid(target) or self.IsDead then return end
        
        if self:GetPos():Distance(target:GetPos()) > 100 then return end
        
        local dmg = DamageInfo()
        dmg:SetDamage(self.MeleeDamage)
        dmg:SetAttacker(self)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_SLASH)
        dmg:SetDamagePosition(target:GetPos())
        
        target:TakeDamageInfo(dmg)
        
        self:EmitSound("npc/zombie/claw_strike" .. math.random(1, 3) .. ".wav", 75, math.random(95, 105))
        
        if target:IsPlayer() then
            target:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 5) .. ".wav", 70)
        end
    end)
end

function ENT:Wander()
    local pos = self:GetPos() + Vector(math.random(-500, 500), math.random(-500, 500), 0)
    
    local tr = util.TraceLine({
        start = pos + Vector(0, 0, 100),
        endpos = pos - Vector(0, 0, 500),
        mask = MASK_SOLID_BRUSHONLY
    })
    
    if tr.Hit then
        pos = tr.HitPos
    end
    
    self:MoveToPos(pos)
    
    coroutine.wait(math.random(2, 5))
end

function ENT:MoveToPos(pos, options)
    local path = Path("Follow")
    path:SetMinLookAheadDistance(200)
    path:SetGoalTolerance(50)
    path:Compute(self, pos)
    
    if not path:IsValid() then return end
    
    while path:IsValid() do
        if path:GetAge() > 0.5 then
            path:Compute(self, pos)
        end
        
        path:Update(self)
        
        if self:GetPos():Distance(pos) < 50 then
            break
        end
        
        if path:GetAge() > 10 then
            break
        end
        
        coroutine.yield()
    end
end

function ENT:Think()
    if self.CustomZombieModel and self:GetModel() ~= self.CustomZombieModel then
        self:SetModel(self.CustomZombieModel)
    end
end

function ENT:OnRemove()
    timer.Remove("ZombieIdle_" .. self:EntIndex())
end