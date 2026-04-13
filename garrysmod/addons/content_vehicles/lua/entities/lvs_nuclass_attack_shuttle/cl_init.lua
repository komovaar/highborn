include("shared.lua")

ENT.EngineColor = Color( 101, 181, 212)
ENT.EngineGlow = Material("sprites/light_glow02_add")
ENT.EnginePos = {
	Vector(-375,32,155),
	Vector(-375,-32,155),
	Vector(-375,32,95),
	Vector(-375,-32,95),
	Vector(-375,32,155),
	Vector(-375,-32,155),
	Vector(-375,32,95),
	Vector(-375,-32,95),
}

ENT.SecondaryEnginePos = {}
ENT.NextSparkTime = 0 
ENT.LocalEngineScale = 0

ENT.EngineFlicker = 1
ENT.NextEngineFlicker = 0

-- Hello Devs, this function generates engine effect positions using 2 positions to define a line and a number of sprites to generate along that line.
-- This is good for angled engine effects.
function generateEngine(startPos, endPos, n)
    for i = 0, n-1 do
        local t = i / (n-1)
        local pos = Vector(
            startPos.x + (endPos.x - startPos.x) * t,
            startPos.y + (endPos.y - startPos.y) * t,
            startPos.z + (endPos.z - startPos.z) * t
        )
        table.insert(ENT.SecondaryEnginePos, pos)
    end
end

local engoffset = -400  
local numofsprites = 7
generateEngine(Vector(engoffset,167,92.5), Vector(engoffset,149,35.6), numofsprites)
generateEngine(Vector(engoffset,138,103.6), Vector(engoffset,119,46), numofsprites)
generateEngine(Vector(engoffset,108.6,113.7), Vector(engoffset,91,58), numofsprites)
generateEngine(Vector(engoffset,-167,92.5), Vector(engoffset,-149,35.6), numofsprites)
generateEngine(Vector(engoffset,-138,103.6), Vector(engoffset,-119,46), numofsprites)
generateEngine(Vector(engoffset,-108.6,113.7), Vector(engoffset,-91,58), numofsprites)

function ENT:Initialize()
    self.NextSparkTime = 0 
end

function ENT:OnRemove()
    if IsValid(self.SmokeEmitter) then
        self.SmokeEmitter:Finish()
        self.SmokeEmitter = nil
    end
end

function ENT:OnSpawn()
end

function ENT:StartWreckEffects()
    if self.WreckFXActive then return end
    self.WreckFXActive = true
    self.NextFireTrail = 0
    self.NextSpark = 0
end

function ENT:StopWreckEffects()
    self.WreckFXActive = false
end

function ENT:DoWreckFX()
    if not self.WreckFXActive then return end
    if self.NextFireTrail > CurTime() then return end
    self.NextFireTrail = CurTime() + 0.12

    local fx = EffectData()
    fx:SetEntity(self)
    fx:SetStart(Vector(-450, 0, 180))
    fx:SetScale(1.5)
    fx:SetMagnitude(1)

    util.Effect("lvs_firetrail", fx)


    local fx2 = EffectData()
    fx2:SetEntity(self)
    fx2:SetStart(Vector(200, 0, 100))
    fx2:SetScale(0.5)
    fx2:SetMagnitude(1)

    util.Effect("lvs_firetrail", fx2)

    local pos = self:LocalToWorld(Vector(-450, 0, 120))

    if self.NextSpark < CurTime() then
        self.NextSpark = CurTime() + math.Rand(0.2, 0.6)

        local fx = EffectData()
        fx:SetOrigin(pos)
        fx:SetNormal(VectorRand())
        fx:SetMagnitude(2)
        fx:SetScale(1)
        fx:SetRadius(4)
        util.Effect("sparks", fx)

        self:EmitSound(
            "ambient/energy/spark"..math.random(1,6)..".wav",
            70,
            math.random(90,110)
        )
    end
end


function ENT:OnFrame()
    self:DamageFX()
    if self:GetDisabled() then
        self:StartWreckEffects()
        self:DoWreckFX()
    else
        self:StopWreckEffects()
    end

    if not IsValid(self) then return end

    local animSpeed = 30
    local damping = 6
    local stiffness = 14

    self.animProgress = self.animProgress or 0
    self.velocity = self.velocity or 0

    local target = self:GetWingsDown() and 1 or 0
    local t = Lerp(FrameTime() * animSpeed, self.animProgress, target)
    local x = self.animProgress
    self.velocity = self.velocity + (stiffness * (t - x) - damping * self.velocity) * FrameTime()
    x = x + self.velocity * FrameTime()
    self.animProgress = math.Clamp(x, 0, 1)


    local angle = Lerp(self.animProgress, 12.5, 135)
    local bR = self:LookupBone("WingR")
    local bL = self:LookupBone("WingL")
    if bR then self:ManipulateBoneAngles(bR, Angle(angle, 0, 0)) end
    if bL then self:ManipulateBoneAngles(bL, Angle(-angle, 0, 0)) end
end

function ENT:OnWingsChanged()
end

function ENT:DamageFX()
    self.nextDFX = self.nextDFX or 0
    if self.nextDFX < CurTime() then
        self.nextDFX = CurTime() + 0.05

        local HP = self:GetHP()
        local MaxHP = self:GetMaxHP()
        if HP > MaxHP * 0.5 then return end

        local enginePositions = {
            Vector(-460,-36,96),
            Vector(-460,-36,152),
            Vector(-460,36,96),
            Vector(-460,36,152),
        }

        if HP <= MaxHP * 0.25 then
            for _, pos in ipairs(enginePositions) do
                local effectdata = EffectData()
                effectdata:SetOrigin(self:LocalToWorld(pos))
                effectdata:SetNormal(self:GetUp())
                effectdata:SetMagnitude(math.Rand(0.5,1.5))
                effectdata:SetEntity(self)
                util.Effect("lvs_exhaust_fire", effectdata)
            end
        end
    end
end

function ENT:StartWindSounds()
    self:StopWindSounds()
    if LocalPlayer():lvsGetVehicle() ~= self then return end
    self._WaterSFX = CreateSound( self, "LVS.Physics.Water" )
    self._WaterSFX:PlayEx(0,100)
end   

function ENT:PostDrawTranslucent()
    local HP = self:GetHP()
    local MaxHP = self:GetMaxHP()

    if not self:GetEngineActive() then 
        self.LocalEngineScale = Lerp(FrameTime() * 1.5, self.LocalEngineScale, 0)
        if self.LocalEngineScale < 0.01 then return end
    end

    local TargetScale = self:GetEngineEffectScale()
    local LerpRate = 10

    if self:GetEngineActive() and TargetScale < self.LocalEngineScale then
        LerpRate = 1.5
    end

    self.LocalEngineScale = Lerp(FrameTime() * LerpRate, self.LocalEngineScale, TargetScale)

    local FlickerMul = 1

    if HP <= MaxHP * 0.10 then
        self.NextEngineFlicker = self.NextEngineFlicker or 0
        self.EngineFlicker = self.EngineFlicker or 1

        if CurTime() > self.NextEngineFlicker then
            self.NextEngineFlicker = CurTime() + math.Rand(0.04, 0.12)
            self.EngineFlicker = math.random() > 0.5 and 1 or 0
        end

        FlickerMul = self.EngineFlicker
    end


    if not self:GetEngineActive() then 
        self.LocalEngineScale = Lerp( FrameTime() * 1.5, self.LocalEngineScale, 0 )
        if self.LocalEngineScale < 0.01 then return end
    end
    
    local TargetScale = self:GetEngineEffectScale()
    local LerpRate = 10 
    
    if self:GetEngineActive() and TargetScale < self.LocalEngineScale then
        LerpRate = 1.5 
    end
    
    self.LocalEngineScale = Lerp( FrameTime() * LerpRate, self.LocalEngineScale, TargetScale )


    local BaseSize = (200 + self:GetThrottle() * 120 + self:GetBoost() * 4) * FlickerMul
    local SecondaryBaseSize = (140 + self:GetThrottle() * 60 + self:GetBoost() * 4) * FlickerMul

    local PrimaryWidth = BaseSize * self.LocalEngineScale
    local PrimaryHeight = BaseSize * self.LocalEngineScale

    local SecondaryWidth = SecondaryBaseSize * self.LocalEngineScale
    local SecondaryHeight = SecondaryBaseSize * math.Clamp(self.LocalEngineScale + 0.2, 0, 1.0)

    render.SetMaterial( self.EngineGlow )

    for _, pos in pairs( self.EnginePos ) do
        render.DrawSprite( self:LocalToWorld( pos ), PrimaryWidth, PrimaryHeight, self.EngineColor )
    end

    for _, pos in pairs( self.SecondaryEnginePos ) do
        render.DrawSprite( self:LocalToWorld( pos ), SecondaryWidth, SecondaryHeight, self.EngineColor )
    end
end

function ENT:OnStartBoost()
	self:EmitSound( "^lvs/vehicles/rho_class/flyby.wav", 85 )
end

function ENT:OnStopBoost()
end

ENT.LightGlow    = Material( "sprites/light_glow02_add" )
ENT.LightMaterial= Material( "effects/lvs/laat_spotlight" )

function ENT:PreDraw()
	return true
end

function ENT:PreDrawTranslucent()
    if self:GetSpotlightToggle() == false then 
        self:RemoveLight()
        return false
    end

    local lampLocalPositions = {
        Vector(453,91,59),
        Vector(453,-91,59)
    }

    local lampPositions = {}
    for i, v in ipairs(lampLocalPositions) do
        lampPositions[i] = self:LocalToWorld(v)
    end

    local targetCenter = self:LocalToWorld(Vector(888,0,-318))

    if not self.projectors then
        self.projectors = {}
        for i, pos in ipairs(lampPositions) do
            local lamp = ProjectedTexture()
            lamp:SetBrightness(20)
            lamp:SetTexture("effects/flashlight/soft")
            lamp:SetColor(Color(255, 255, 255))
            lamp:SetEnableShadows(false)
            lamp:SetFarZ(2000)
            lamp:SetNearZ(1)
            lamp:SetFOV(45)
            self.projectors[i] = lamp
        end
    end

    for i, pos in ipairs(lampPositions) do
        local dir = (targetCenter - pos):GetNormalized()

        render.SetMaterial(self.LightGlow)
        render.DrawSprite(pos + dir * 10, 60, 60, Color(255, 255, 255, 255))
        render.SetMaterial(self.LightMaterial)
        render.DrawBeam(pos - dir * 0, pos + dir * 400, 400, 0, 1, Color(255, 255, 255, 50))

        if IsValid(self.projectors[i]) then
            self.projectors[i]:SetPos(pos)
            self.projectors[i]:SetAngles(dir:Angle())
            self.projectors[i]:Update()
        end
    end

    return false
end

function ENT:RemoveLight()
    if self.projectors then
        for _, proj in ipairs(self.projectors) do
            if IsValid(proj) then
                proj:Remove()
            end
        end
        self.projectors = nil
    end
end