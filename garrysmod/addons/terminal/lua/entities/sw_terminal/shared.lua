ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Republic Field Terminal"
ENT.Author = "Highborn"
ENT.Category = "Star Wars RP"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsBroken")
    self:NetworkVar("Int", 0, "TerminalHealth")
end
