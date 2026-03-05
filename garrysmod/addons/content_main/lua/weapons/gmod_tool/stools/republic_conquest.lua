TOOL.Category = "Stoneman"
TOOL.Name = "Conquest"

if CLIENT then
	language.Add( "tool.republic_conquest.name", "Conquest" )
	language.Add( "tool.republic_conquest.desc", "Creates objectives for players to do!" )
	language.Add( "tool.republic_conquest.0", "Left Click: Creates a configured objecitve. Right Click: Tie to entity. Reload: Remove from entity." )
end

local ConVarsDefault = TOOL:BuildConVarList()

local iconList = {
    { name = "Blank", icon = "republic_conquest/border.png" },
    { name = "Capture", icon = "republic_conquest/capture.png" },
    { name = "Command Post", icon = "republic_conquest/command_post.png" },
    { name = "Destroy", icon = "republic_conquest/destroy.png" },
    { name = "Defend", icon = "republic_conquest/hold.png" },
}

local function ConquestBuildCPanel()
	local CPanel = controlpanel.Get("republic_conquest")
	if not CPanel then return end
	CPanel:ClearControls()

    CPanel:AddControl( "ComboBox", 
	{ 
		MenuButton = 1,
		Folder = "republic_conquest",
		Options = { [ "#preset.default" ] = ConVarsDefault },
		CVars = table.GetKeys( ConVarsDefault ) 
	}
	)

	CPanel:AddControl("Header", 
	{
		Text = "Republic Conquest",
		Description = "Put down control points for players to conquer!"
	}
	)

	CPanel:AddControl( "slider", 
	{ 
		Label = "Radius:",
	 	Command = "republic_conquest_radius",
		min = "1",
		max = "100000"
	}
	)
    CPanel:ControlHelp("Radius of a circle control point.")

    CPanel:ControlHelp("How long does it take to capture?")
	CPanel:AddControl( "slider", 
	{ 
		Label = "Time:",
	 	Command = "republic_conquest_time",
		min = "1",
		max = "100000"
	}
	)
	CPanel:ControlHelp("How long does it take to capture your control point?")

	CPanel:AddControl( "slider", 
	{ 
		Label = "Expectation:",
		Command = "republic_conquest_expectation",
		min = "1",
		max = "1000"
	}
	)
	CPanel:ControlHelp("How many players does it take to get full capture rate?")

	CPanel:AddControl( "textbox", 
	{ 
		Label = "Model:", 
		Command = "republic_conquest_model"
	} 
	)

	CPanel:AddControl( "checkbox", 
	{ 
		Label = "Use proximity hud?", 
		Command = "republic_conquest_useproximity"
	} 
	)
	CPanel:ControlHelp("Show on hud only if you're close?")

	CPanel:AddControl( "slider",
	{
		Label = "Display distance:",
		Command = "republic_conquest_proximity",
		min = "1",
		max = "100000"
	}
	)

	CPanel:AddControl( "checkbox", 
	{ 
		Label = "Show circle?", 
		Command = "republic_conquest_circle"
	} 
	)
	CPanel:ControlHelp("Show the circle of the control point?")

	CPanel:AddControl( "checkbox", 
	{ 
		Label = "Show prop?", 
		Command = "republic_conquest_model_active"
	} 
	)
	CPanel:ControlHelp("Show prop?")

	CPanel:AddControl( "checkbox", 
	{ 
		Label = "Apply to self?", 
		Command = "republic_conquest_selfapply"
	} 
	)
	CPanel:ControlHelp("Changes right click to apply to self.")

	CPanel:AddControl( "checkbox",
	{
		Label = "Use NPC teams?",
		Command = "republic_conquest_npc_team"
	}
	)
	CPanel:ControlHelp("Use npc teams? (Friendly NPCs is on the player's team?)")

	local matselect = CPanel:MatSelect("republic_conquest_icon", nil, true, 0.25, 0.25)
	for k, v in pairs(iconList) do
		matselect:AddMaterial(v.name, v.icon)
	end
end

function TOOL:BuildCPanel(panel)
	ConquestBuildCPanel(panel)
end

if CLIENT then ConquestBuildCPanel() end

TOOL.ClientConVar[ "radius" ] = "100"
TOOL.ClientConVar[ "time" ] = "500"
TOOL.ClientConVar[ "icon" ] = "blank"
TOOL.ClientConVar[ "circle" ] = "1"
TOOL.ClientConVar[ "model_active" ] = "1"
TOOL.ClientConVar[ "expectation" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/props_c17/oildrum001.mdl"
TOOL.ClientConVar[ "selfapply" ] = "0"
TOOL.ClientConVar[ "useproximity" ] = "0"
TOOL.ClientConVar[ "proximity" ] = "500"
TOOL.ClientConVar[ "npc_team" ] = "1"

function TOOL:LeftClick(tr)
	if not IsFirstTimePredicted() then return end
	self:SetupConquest(tr.HitPos)
end

// Tie to an entity.
function TOOL:RightClick(tr)
	if not IsFirstTimePredicted() or CLIENT then return end
	if self:GetClientInfo("selfapply") == "1" then
		self:SetupConquest(tr.HitPos, self:GetOwner()) 
	else
		if not IsValid(tr.Entity) then return end
		self:SetupConquest(tr.HitPos, tr.Entity)
	end
end

function TOOL:Reload(tr)
	if not IsFirstTimePredicted() or CLIENT then return end
	if self:GetClientInfo("selfapply") == "1" then
		self:RemoveConquest(self:GetOwner())
	else
		if not IsValid(tr.Entity) then return end
		self:RemoveConquest(tr.Entity)
	end
end

function TOOL:SetupConquest(pos, entityToTie)
	if CLIENT then return end
	local data = {
		radius = self:GetClientInfo("radius"),
		owner = self:GetOwner(),
		time = self:GetClientInfo("time"),
		icon = self:GetClientInfo("icon"),
		expectation = self:GetClientInfo("expectation"),
		model = self:GetClientInfo("model"),
		circle = self:GetClientInfo("circle"),
		model_active = self:GetClientInfo("model_active"),
		useproximity = self:GetClientInfo("useproximity"),
		proximity = self:GetClientInfo("proximity"),
		npc_team = self:GetClientInfo("npc_team"),
	}

	RepublicConquest:AddPoint(pos, data, entityToTie)
end

function TOOL:RemoveConquest(ent)
	if CLIENT then return end
	if not IsValid(ent) then return end
	RepublicConquest:RemovePoint(ent)
end

if CLIENT then
	hook.Add( "PostDrawTranslucentRenderables", "RepublicConquest_PreviewToolgunner", function()
        if not IsValid(LocalPlayer():GetActiveWeapon()) then return end
        if LocalPlayer():GetActiveWeapon():GetClass() != "gmod_tool" then return end
        if LocalPlayer():GetWeapon("gmod_tool"):GetMode() == nil then return end
        if LocalPlayer():GetWeapon("gmod_tool"):GetMode() != "republic_conquest" then return end

        local tool = LocalPlayer():GetTool()
        local pos = LocalPlayer():GetEyeTrace().HitPos
		local radius = GetConVar("republic_conquest_radius"):GetInt()
		render.SetColorMaterial()
		render.DrawSphere( pos, radius, 30, 30, Color( 0, 175, 175, 100 ) )

		local proximity = GetConVar("republic_conquest_proximity"):GetInt()
		render.DrawWireframeSphere( pos, proximity, 30, 30, Color( 0, 175, 175, 100 ) )
	end )
end