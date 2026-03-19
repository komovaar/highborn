include("shared.lua")

function ENT:Initialize()
	self.MQSNPC = true
	self.names = 0
end

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > MQS.Config.QuestEntDrawDist ^ 2 then return end

	local Pos = self:EyePos() or self:GetPos()
	Pos = Pos + Vector(0, 0, 20)
	local Ang = self:GetAngles()
	local eyepos = EyePos()
	local planeNormal = Ang:Up()
	Ang:RotateAroundAxis(Ang:Forward(), 90)

	local relativeEye = eyepos - Pos
	local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
	local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

	textAng:RotateAroundAxis(textAng:Up(), 90)
	textAng:RotateAroundAxis(textAng:Forward(), 90)

	cam.Start3D2D(Pos - Ang:Right() * (8 + math.sin(CurTime()) * 0.9), textAng, 0.1)
		-- draw.RoundedBox(8, -self.names / 2 - 10, 0, self.names + 20, 35, MSD.Theme["d"])
		self.names = DrawTextShadow(self:GetNamer(), "HB_NPC", 0, 0, color_white, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end