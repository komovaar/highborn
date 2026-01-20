include("shared.lua")

function ENT:Initialize()
	if self:GetEnablePhys() then return end
	self:InitRenderModel()
end

function ENT:InitRenderModel()
	self.RenderModel = ClientsideModel(self:GetCModel())
	self.RenderModel:SetPos(self:GetPos())
	self.RenderModel:SetParent(self)
	self.RenderModel:SetMaterial(self:GetMaterial())
	self.RenderModel:SetColor(self:GetColor())
	self:CallOnRemove("RenderModel", function()
		SafeRemoveEntity(self.RenderModel)
	end)
end

function ENT:Draw()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local eyepos = EyePos()
	local planeNormal = Ang:Up()
	if Pos:DistToSqr(LocalPlayer():GetPos()) > MQS.Config.QuestEntDrawDist ^ 2 then return end

	if self:GetEnablePhys() then
		self:DrawModel()
	else
		local sysTime = SysTime()
		local rotAng = Angle(Ang)
		self.rotationOffset = sysTime % 360 * 130
		rotAng:RotateAroundAxis(planeNormal, self.rotationOffset)

		if not IsValid(self.RenderModel) then
			self:InitCsInitRenderModelModel()
		end

		self.RenderModel:SetPos(Pos)
		self.RenderModel:SetAngles(rotAng)
	end

	if self:GetTPly() ~= LocalPlayer() then return end
	if not self:GetShowPointer() then return end
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local relativeEye = eyepos - Pos
	local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
	local textAng = relativeEyeOnPlane:AngleEx(planeNormal)
	textAng:RotateAroundAxis(textAng:Up(), 90)
	textAng:RotateAroundAxis(textAng:Forward(), 90)
	cam.Start3D2D(Pos - Ang:Right() * (50 + math.sin(CurTime() * 2) * 5), textAng, 0.2)
	MSD.DrawTexturedRect(-23, -23, 48, 64, MSD.Icons48.arrow_down_color, color_white)
	cam.End3D2D()
end