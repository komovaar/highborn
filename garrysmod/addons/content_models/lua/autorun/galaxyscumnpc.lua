local Category = "Star Wars Galaxy Scum"

local NPC = { Name = "Quarren (Hostile)",
            Class = "npc_combine_s",
            Model = "models/quarren/nossorri.mdl",
			Health = "80",
            Squadname = "galaxy_scum",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_scum_quar_k_hostile", NPC )


local NPC = { Name = "Quarren (Friendly)",
            Class = "npc_citizen",      
            Model = "models/quarren/nossorri.mdl",
            Health = "80",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_scum_quar_k_friendly", NPC )


local NPC = { Name = "Weequay (Hostile)",
            Class = "npc_combine_s",
            Model = "models/weequay/geequay_regular_player.mdl",
			Health = "80",
            Squadname = "swbf3_rebel_pilots",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_scum_weeq_k_hostile", NPC )


local NPC = { Name = "Weequay (Friendly)",
            Class = "npc_citizen",      
            Model = "models/weequay/geequay_regular_player.mdl",
            Health = "80",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_scum_weeq_k_friendly", NPC )


local NPC = { Name = "Rodian (Hostile)",
            Class = "npc_combine_s",
            Model = "models/rodian/segular_rodian_player.mdl",
			Health = "100",
            Squadname = "galaxy_scum",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_scum_rodian_k_hostile", NPC )


local NPC = { Name = "Rodian (Friendly)",
            Class = "npc_citizen",      
            Model = "models/rodian/segular_rodian_player.mdl",
            Health = "100",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_scum_rodian_k_friendly", NPC )


local NPC = { Name = "Drabatan (Hostile)",
            Class = "npc_combine_s",
            Model = "models/drabatan/pao.mdl",
			Health = "100",
            Squadname = "galaxy_scum",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_scum_pao_k_hostile", NPC )


local NPC = { Name = "Drabatan (Friendly)",
            Class = "npc_citizen",      
            Model = "models/drabatan/pao.mdl",
            Health = "100",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_scum_pao_k_friendly", NPC )


local NPC = { Name = "Talz (Hostile)",
            Class = "npc_combine_s",
            Model = "models/talz/talz.mdl",
			Health = "100",
            Squadname = "galaxy_scum",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_scum_talz_k_hostile", NPC )


local NPC = { Name = "Talz (Friendly)",
            Class = "npc_citizen",      
            Model = "models/talz/talz.mdl",
            Health = "100",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_scum_talz_k_friendly", NPC )
