AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

-- ENT.Category = "Republic Bases"
ENT.PrintName = "Control Point Base"
ENT.Spawnable = true

ENT.Author = "Stoneman"
ENT.PointCache = {}

if SERVER then
    util.AddNetworkString("RepublicConquest_ControlPointCaptured")
end

// Non SBTM
ENT.TeamEntities = {} -- Entities inside the control point per team.

function ENT:Initialize()
    // Invisible model
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    self:ManipulateBoneScale(0, Vector(0, 0, 0))
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)

    RepublicConquest.Point[self] = table.Count(RepublicConquest.Point) + 1

    if SERVER then
        self:SetTrigger(true)
    end
end

function ENT:CreateFakeProp(model)
    local prop = ents.Create("prop_physics")
    if not model then
        model = "models/props_c17/oildrum001.mdl"
    end
    prop:SetModel(model)
    prop:SetPos(self:GetPos())
    prop:SetAngles(self:GetAngles())
    prop:SetMoveType(MOVETYPE_VPHYSICS)
    prop:SetSolid(SOLID_VPHYSICS)
    prop:SetCollisionGroup(COLLISION_GROUP_NONE)
    prop:PhysicsInit(SOLID_VPHYSICS)
    local phys = prop:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Wake()
    end
    prop:Spawn()
    prop:Activate()
    
    RepublicConquest:TieToEntity(prop, self, true)
end

function ENT:OnRemove()
    if SERVER then
        if self:GetTiedEntity() then
            if self:GetTiedEntity().CreatedByControlPoint == self then
                self:GetTiedEntity():Remove()
            end
        end
    end

    RepublicConquest.Point[self] = nil
end

// Tag the entity as a tie when we copy.
function ENT:PreEntityCopy()
    // We need to tag both entity and the control point with a unique identifier so we can tie them together when they are pasted.
    duplicator.StoreEntityModifier(self, "TiedControlPoint", {self:EntIndex()})
    duplicator.StoreEntityModifier(self:GetTiedEntity(), "TiedControlPoint", {self:EntIndex()})
end

function ENT:PostEntityPaste(ply, ent, createdEntities)
    timer.Simple(0, function()
        // Check if both the control point and tied entity have matching TiedControlPoint data.
        local dupedIndex = ent.TiedControlPoint[1]

        // If dupedIndex is nil, then we don't have a tied entity.
        if not dupedIndex then return end

        local newTiedEntity
        for _, entity in pairs(createdEntities) do
            if entity:GetClass() == "republic_control_point" then continue end
            local propIndex = entity.EntityMods.TiedControlPoint[1]

            // If the index matches, we have found the tied entity.
            if propIndex == dupedIndex then
                newTiedEntity = entity
                break
            end
        end

        local model = "models/props_c17/oildrum001.mdl"
        if newTiedEntity then
            model = newTiedEntity:GetModel()
        end

        local data = {
            radius = self:GetPointRadius(),
            owner = self:GetOwner(),
            time = self:GetTimeToCapture(),
            icon = self:GetPointIcon(),
            expectation = self:GetPlayerExpectation(),
            model = model,
            circle = self:GetPointCircle(),
            model_active = self:GetPointModelActive(),
            useproximity = self:GetUseProximity(),
            proximity = self:GetProximityDistance(),
        }

        // Re-run creation.
        RepublicConquest:AddPoint(self:GetPos(), data, newTiedEntity)
        
        self:Remove()
    end)
end

duplicator.RegisterEntityModifier("TiedControlPoint", function(ply, ent, data)
    ent.TiedControlPoint = data
end)

function ENT:CreateCustomCollision()
    local points = {}
    local radius = self:GetPointRadius()
    local height = 360  -- Total height of the cylinder
    local numPoints = 12  -- Reduced from 16 for optimization
    local topBottomOffset = height / 2

    -- Create bottom circle
    for i = 0, numPoints do
        local angle = math.rad((i / numPoints) * 360)
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        table.insert(points, Vector(x, y, -topBottomOffset))
    end

    -- Create top circle
    for i = 0, numPoints do
        local angle = math.rad((i / numPoints) * 360)
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        table.insert(points, Vector(x, y, topBottomOffset))
    end

    self:PhysicsInitConvex(points)
    self:EnableCustomCollisions(true)
end

function ENT:SetupDataTables()
    // Creation Data (Unchanged):
    self:NetworkVar("Float", 0, "PointRadius")
    self:NetworkVar("Vector", 0, "PointPosition")
    self:NetworkVar("String", 0, "PointIcon")
    self:NetworkVar("Int", 0, "PlayerExpectation")
    self:NetworkVar("Bool", 0, "PointModelActive")
    self:NetworkVar("Bool", 1, "PointCircle")
    self:NetworkVar("Bool", 2, "UseProximity")
    self:NetworkVar("Float", 1, "ProximityDistance")
    self:NetworkVar("Entity", 0, "TiedEntity")
    self:NetworkVar("String", 1, "PointModel")
    self:NetworkVar("Bool", 3, "UseNPCTeam")

    // Capture Data:
    self:NetworkVar("Int", 1, "TeamOwner")
    self:NetworkVar("Float", 2, "Progress")
    self:NetworkVar("Float", 3, "TimeToCapture")
    self:NetworkVar("Int", 2, "TeamProgressing")
    self:NetworkVar("Bool", 4, "Contested")

    self:SetTeamOwner(1) -- Set the owner to neutral.
    self:SetProgress(0) -- Starts at 0 progress.
    self:SetTeamProgressing(1) -- Starts at none.
    self:SetContested(false) -- Not contested.
end

function ENT:IsFriendlyNPC(ent)
    if not ent:IsNPC() then return false end
    if not self:GetUseNPCTeam() then return false end
    local anyPlayer = Entity(1)

    -- Use pcall to safely call Disposition
    local success, disposition = pcall(function()
        return ent:Disposition(anyPlayer)
    end)

    -- If pcall failed or disposition is not set, return false
    if not success or not disposition then return false end

    -- Check disposition
    return disposition == D_LI or disposition == D_NU
end

function ENT:GetControlTeam(ent)
    if RepublicConquest.SBTM then
        return self:Team()
    else
        // We don't use SBTM. So we use set teams. 1 = Neutral, 2 = Player, 3 = NPC.
        if ent:IsPlayer() then
            return 2
        elseif ent:IsNPC() then
            if self:IsFriendlyNPC(ent) then
                return 2
            end
            
            return 3
        end
    end

    return nil
end

function ENT:StartTouch(ent)
    local entTeam = self:GetControlTeam(ent)
    // If a player is in a team..
    if entTeam then
        // Add them to their team table!
        self.TeamEntities[entTeam] = (self.TeamEntities[entTeam] or 0) + 1
    end

    if ent:IsPlayer() then
        ent:SetNWEntity("Conquest_ControlPoint", self)
    end
end

function ENT:EndTouch(ent)
    local entTeam = self:GetControlTeam(ent)
    // If a player is in a team..
    if entTeam and self.TeamEntities[entTeam] then
        // Remove them from their team table!
        self.TeamEntities[entTeam] = self.TeamEntities[entTeam] - 1

        // Cleaning up the table.
        if self.TeamEntities[entTeam] <= 0 then
            self.TeamEntities[entTeam] = nil
        end
    end

    if ent:IsPlayer() then
        if ent:GetNWEntity("Conquest_ControlPoint") == self then
            ent:SetNWEntity("Conquest_ControlPoint", ent)
        end
    end
end

function ENT:GetPointColor()
    return RepublicConquest.Teams[self:GetTeamOwner()].Color
end

function ENT:GetProgressorColor()
    return RepublicConquest.Teams[self:GetTeamProgressing()].Color
end

if SERVER then
    function ENT:ControlPointProgress()
        if not IsValid(self) then return end
        // Debouncing..
        if CurTime() - (self.LastProgressUpdate or 0) < 0.25 then return end
        self.LastProgressUpdate = CurTime()

        // Contesting
        self:SetContested(table.Count(self.TeamEntities) > 1)

        // If there are absolutely no teams inside the control point and there's progress, start decreasing it.
        if table.IsEmpty(self.TeamEntities) and self:GetProgress() > 0 then
            self:UpdateCaptureProgress(false)
        end

        /////// Capturing -- Add progress when a team is inside. ///////
        // If there's a team inside the control point, start increasing progress.
        if table.Count(self.TeamEntities) == 1 then
            // There's only one team inside the control point.
            local captureTeam = next(self.TeamEntities) -- Since this is the only team inside, next will return the only team key inside.
            
            // If there was already progress, we have to de-progress it to 0 first before we can start progressing again.
            if self:GetTeamProgressing() ~= captureTeam then
                // Deprogress!
                self:UpdateCaptureProgress(false)

                if self:GetProgress() <= 0 then
                    // Change team.
                    self:SetTeamProgressing(captureTeam)
                end
            else
                // If we already own the point, do nothing.
                if self:GetTeamOwner() ~= captureTeam then
                    // Progress!
                    self:SetTeamProgressing(captureTeam)
                    self:UpdateCaptureProgress(true, captureTeam)

                    if self:GetProgress() >= 1 then
                        self:CaptureControlPoint(captureTeam)
                    end
                end
            end
        end
    end

    function ENT:UpdateCaptureProgress(capture, capturingTeam)
        if not IsValid(self) then return end

        local timeToCapture = self:GetTimeToCapture()
        local progress = self:GetProgress()
        local progressPerSecond = 0.25 / timeToCapture

        // Progress per second goes down if player expectation isn't matched.
        // If expectation is 10, and there's 1 player, we're at 10% of the rate.
        
        if capture then
            local playerExpectation = self:GetPlayerExpectation()
            local playerCount = self.TeamEntities[capturingTeam]
            local newProgressPerSecond = progressPerSecond * (playerCount / playerExpectation)
            // Cap the progress per second to 100% max rate.
            newProgressPerSecond = math.Clamp(newProgressPerSecond, 0, progressPerSecond)
            self:SetProgress(math.Clamp(progress + newProgressPerSecond, 0, 1))
        else
            self:SetProgress(math.Clamp(progress - progressPerSecond, 0, 1))
        end
    end

    function ENT:CaptureControlPoint(team)
        // Set the team owner to the team.
        self:SetTeamOwner(team)
        self:SetProgress(0)
        self:SetTeamProgressing(1)

        net.Start("RepublicConquest_ControlPointCaptured")
        net.Broadcast()
    end

    function ENT:Think()
        self:ControlPointProgress()
        self:NextThink(CurTime() + 0.25)
        return true
    end
end

local function Draw3DCircle(pos, rad, clr, detail, thick)
    local AlphaMask = Color(0, 0, 0, 0)
	render.SetStencilEnable(true)
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.SetColorMaterial()
	render.ClearStencil()
	-- All
	render.SetStencilReferenceValue(7)
	render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	render.DrawSphere(pos, -rad, detail, detail, AlphaMask)
	-- Under
	render.SetStencilReferenceValue(7)
	render.SetStencilZFailOperation(STENCILOPERATION_DECR)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	render.DrawSphere(pos, rad, detail, detail, AlphaMask)
	-- Inner
	render.SetStencilReferenceValue(7)
	render.SetStencilZFailOperation(STENCILOPERATION_INCR)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	render.DrawSphere(pos, -math.max(rad - thick, 0), detail, detail, AlphaMask)
	render.SetStencilZFailOperation(STENCILOPERATION_DECR)
	-- Overall
	render.SetStencilReferenceValue(7)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	render.DrawSphere(pos, math.max(rad - thick, 0), detail, detail, AlphaMask)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

	cam.IgnoreZ(true)
	render.SetStencilReferenceValue(7)
	render.DrawSphere(pos, rad + thick, detail, detail, clr)
	render.DrawSphere(pos, -rad, detail, detail, clr)
	cam.IgnoreZ(false)
	render.SetStencilEnable(false)
end

function ENT:GeneratePoints()
    local points = {}
    local radius = self:GetPointRadius()
    local height = 360  -- Total height of the cylinder
    local numPoints = 12  -- Reduced from 16 for optimization
    local topBottomOffset = height / 2

    -- Create bottom circle
    for i = 0, numPoints do
        local angle = math.rad((i / numPoints) * 360)
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        table.insert(points, Vector(x, y, -topBottomOffset))
    end

    -- Create top circle
    for i = 0, numPoints do
        local angle = math.rad((i / numPoints) * 360)
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        table.insert(points, Vector(x, y, topBottomOffset))
    end

    return points
end

function ENT:DrawPointCache()
    if not self.PointCache then return end
    for i = 1, #self.PointCache do
        local nextPoint = self.PointCache[i + 1] or self.PointCache[1]
        render.DrawLine(self:GetPos() + self.PointCache[i], self:GetPos() + nextPoint, 0.1, Color(255, 0, 0), false)
    end
end

function ENT:Draw()
    if self:GetPointCircle() then
        Draw3DCircle(self:GetPos(), self:GetPointRadius(), Color(0, 255, 0), 50, 10)
    end
    self:DrawModel()

    // Check if you have toolgun on
    if not IsValid(LocalPlayer():GetActiveWeapon()) then return end
    if LocalPlayer():GetActiveWeapon():GetClass() != "gmod_tool" then return end

    if table.IsEmpty(self.PointCache) then
        self.PointCache = self:GeneratePoints()
    end

    self:DrawPointCache()
end
