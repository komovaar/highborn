local PLAYER_CLASS = {}

-- Value of -1 = set to config value, if a corresponding setting exists
PLAYER_CLASS.DisplayName			= "Default Player Class"

PLAYER_CLASS.WalkSpeed			= 100		-- How fast to move when not running
PLAYER_CLASS.RunSpeed				= 225		-- How fast to move when running
PLAYER_CLASS.CrouchedWalkSpeed	= 25		-- Multiply move speed by this when crouching
PLAYER_CLASS.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER_CLASS.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER_CLASS.JumpPower			= 160		-- How powerful our jump should be
PLAYER_CLASS.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER_CLASS.MaxHealth			= 100		-- Max health we can have
PLAYER_CLASS.StartHealth			= 100		-- How much health we start with
PLAYER_CLASS.StartArmor			= 0			-- How much armour we start with
PLAYER_CLASS.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER_CLASS.TeammateNoCollide	= false		-- Do we collide with teammates or run straight through them
PLAYER_CLASS.AvoidPlayers			= false		-- Automatically swerves around other players
PLAYER_CLASS.UseVMHands			= true		-- Uses viewmodel hands

function PLAYER_CLASS:Loadout()
    -- Let gamemode decide
end

function PLAYER_CLASS:SetModel()
    -- Let gamemode decide
end

function PLAYER_CLASS:ShouldDrawLocal()
    -- Let gamemode decide
end

function PLAYER_CLASS:CreateMove(cmd)
    -- Let gamemode decide
end

function PLAYER_CLASS:CalcView(view)
    -- Let gamemode decide
end

function PLAYER_CLASS:GetHandsModel()
    -- Let gamemode decide
end

function PLAYER_CLASS:StartMove(mv, cmd)
    -- Let gamemode decide
end

function PLAYER_CLASS:FinishMove(mv)
    -- Let gamemode decide
end

player_manager.RegisterClass("player_darkrp", PLAYER_CLASS, "player_sandbox")
