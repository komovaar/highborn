player_manager.AddValidModel( "pm_coruscant_police", "models/police/pm_coruscant_police.mdl" )

local NPC = {
	Name = "Coruscant Police (Friendly)",
	Class = "npc_citizen",
	Category = "CGI Coruscant Police",
	Model = "models/police/npc_coruscant_police_f.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_coruscant_police_f", NPC )


local NPC = {
	Name = "Coruscant Police (Hostile)",
	Class = "npc_combine_s",
	Category = "CGI Coruscant Police",
	Model = "models/police/npc_coruscant_police_h.mdl",
}
list.Set( "NPC", "npc_coruscant_police_h", NPC )