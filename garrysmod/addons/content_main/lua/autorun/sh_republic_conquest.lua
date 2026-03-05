RepublicConquest = RepublicConquest or {}
RepublicConquest.Teams = RepublicConquest.Teams or {}
RepublicConquest.Point = RepublicConquest.Point or {}
RepublicConquest.SBTM = RepublicConquest.SBTM or false

function RepublicConquest:CreateTeam(name, color)
    local newTeam = {
        Name = name,
        Color = color,
        ID = #RepublicConquest.Teams + 1,
        Entities = {}
    }

    if not table.HasValue(RepublicConquest.Teams, newTeam) then
        table.insert(RepublicConquest.Teams, newTeam)
    end
end

function RepublicConquest:SetupPredefinedTeams()
    RepublicConquest:CreateTeam("Neutral", Color(255, 255, 255, 0))
    RepublicConquest:CreateTeam("Player", Color(0, 0, 255))
    RepublicConquest:CreateTeam("NPC", Color(255, 0, 0, 255))
end

function RepublicConquest:FetchPoints()
    for k, v in pairs(ents.FindByClass("republic_control_point")) do
        RepublicConquest.Point[v] = k
    end
end

hook.Add("InitPostEntity", "RepublicConquest_Setup", function()
    RepublicConquest:SetupPredefinedTeams()

    if CLIENT then
        RepublicConquest:FetchPoints()
    end
end)