include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
    if self.Model and self:GetModel() ~= self.Model then
        self:SetModel(self.Model)
    end
end