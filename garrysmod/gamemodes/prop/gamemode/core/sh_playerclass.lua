prop.player = prop.player or {}

local CLASS_NAME = "player_prop"

local PLAYER_CLASS = {}

PLAYER_CLASS.DisplayName = "prop Player Class"

PLAYER_CLASS.TeammateNoCollide = false

local classConfig = {
    WalkSpeed = {"playerWalkSpeed", 200},
    RunSpeed = {"playerRunSpeed", 400},
    SlowWalkSpeed = {"playerSlowWalkSpeed", 100},
    DuckSpeed = {"playerDuckSpeed", 0.3},
    UnDuckSpeed = {"playerUnDuckSpeed", 0.3},
    CrouchedWalkSpeed = {"playerCrouchedWalkSpeed", 0.3},
    JumpPower = {"playerJumpPower", 200},
    StartHealth = {"playerStartHealth", 100}
}

local function numberOrDefault(value, default)
    value = tonumber(value)
    if value == nil then return default end

    return value
end

function PLAYER_CLASS:Loadout()
end

function PLAYER_CLASS:SetModel()
end

function PLAYER_CLASS:ShouldDrawLocal()
end

function PLAYER_CLASS:CreateMove(cmd)
end

function PLAYER_CLASS:CalcView(view)
end

function PLAYER_CLASS:GetHandsModel()
end

function PLAYER_CLASS:StartMove(mv, cmd)
end

function PLAYER_CLASS:FinishMove(mv)
end

player_manager.RegisterClass(CLASS_NAME, PLAYER_CLASS, "player_sandbox")

function prop.player.refreshClass()
    for field, meta in pairs(classConfig) do
        PLAYER_CLASS[field] = numberOrDefault(prop.config.get(meta[1], meta[2]), meta[2])
    end

    return PLAYER_CLASS
end

function prop.player.getClassName()
    return CLASS_NAME
end

function prop.player.getClass()
    return PLAYER_CLASS
end

prop.player.refreshClass()
