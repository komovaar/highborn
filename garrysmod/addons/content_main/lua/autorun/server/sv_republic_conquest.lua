function RepublicConquest:AddPoint(pos, data, entityToTie)
    // Create the control point entity.
    local ent = ents.Create("republic_control_point")
    ent:SetPos(pos + Vector(0, 0, 20))
    ent:Spawn()

    // Create undo entry.
    undo.Create("Republic Control Point")
        undo.AddEntity(ent)
        undo.SetPlayer(data.owner)
    undo.Finish()
    
    // Sets the control point properties.
    ent:SetPointPosition(pos)
    ent:SetPointRadius(data.radius)
    ent:SetTimeToCapture(data.time)
    ent:SetPointIcon(data.icon)
    ent:SetPlayerExpectation(data.expectation)
    ent:SetPointCircle(tobool(data.circle))
    ent:SetUseProximity(tobool(data.useproximity))
    ent:SetProximityDistance(data.proximity)
    ent:SetPointModel(data.model)
    ent:SetUseNPCTeam(tobool(data.npc_team))
    
    ent:CreateCustomCollision()

    // Should tie or make new prop?
    if IsValid(entityToTie) then
        RepublicConquest:TieToEntity(entityToTie, ent)
    else
        if data.model_active == "1" then
            ent:CreateFakeProp(data.model)
        end
    end
end

function RepublicConquest:TieToEntity(ent, point, isFakeProp)
    if not IsValid(ent) then return end
    if not IsValid(point) then return end
    // Make sure it isn't a republic_control_point.
    if ent:GetClass() == "republic_control_point" then return end
    // Sets parent to entity.
    point:SetParent(ent)
    point:SetPos(ent:GetPos())
    point:SetTiedEntity(ent)
    point:SetPointModel(ent:GetModel())

    ent:CallOnRemove("RepublicConquest_TiedPropRemoved", function(ent)
        if IsValid(point) then
            point:Remove()
        end
    end)

    point:CallOnRemove("RepublicConquest_TiedPointRemoved", function(point)
        if IsValid(ent) then
            if isFakeProp then
                ent:Remove()
            end
        end
    end)
end

function RepublicConquest:RemovePoint(ent)
    if not IsValid(ent) then return end

    // Check for all children.
    local children = ent:GetChildren()
    if not children then return end
    if table.Count(children) == 0 then return end

    // Find and remove control point from children.
    for k, v in pairs(children) do
        if v:GetClass() == "republic_control_point" then
            v:Remove()
        end
    end
end