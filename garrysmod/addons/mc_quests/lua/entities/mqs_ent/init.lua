AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if not self.model then
		self.model = "models/props_junk/garbage_newspaper001a.mdl"
	end

	self:SetModel(self.model)
	self:SetCModel(self.model)
	self:SetTPly(self.task_ply)
	self:SetShowPointer(self.pointer)
	self:SetEnablePhys(self.enablephys)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:Activate()
end

function ENT:PickUP(ply)
	MQS.SetSelfNWdata(ply, "quest_colected", MQS.GetSelfNWdata(ply, "quest_colected") + 1)

	if MQS.GetSelfNWdata(ply, "quest_colected") >= MQS.GetSelfNWdata(ply, "quest_ent") then
		MQS.UpdateObjective(ply)
	end

	self.save_remove = true
	SafeRemoveEntity(self)

end

function ENT:Use(ply)
	if ply ~= self.task_ply then return end

	if self:GetUseHold() then
		if not self.StartPicking then
			self.StartPicking = CurTime()
			self.pickply = ply
		end
		return
	end
	self:PickUP(ply)
end

function ENT:Think()
	self:NextThink(CurTime())

	if self.StartPicking and self:GetUseHold() and IsValid(self.pickply) and self.pickply:KeyDown(IN_USE) then
		local progress = (self.StartPicking + self:GetUseHold() - CurTime()) / self:GetUseHold()
		progress = 1 - progress
		if progress >= 1 then
			self:PickUP(self.pickply)
			self.StartPicking = nil
			self:SetPickProgress(0)
			self.pickply = nil
			return true
		end
		self:SetPickProgress(progress)
	else
		self.StartPicking = nil
		self:SetPickProgress(0)
		self.pickply = nil
	end
	return true
end

function ENT:OnRemove()
	if MQS.ActiveTask[self.task_id] then
		table.RemoveByValue(MQS.ActiveTask[self.task_id].ents, self:EntIndex())
	end

	if not self.save_remove and IsValid(self.task_ply) then
		MQS.SetSelfNWdata(self.task_ply, "quest_ent", MQS.GetSelfNWdata(self.task_ply, "quest_ent") - 1)

		if MQS.GetSelfNWdata(self.task_ply, "quest_colected") >= MQS.GetSelfNWdata(self.task_ply, "quest_ent") then
			MQS.UpdateObjective(self.task_ply)
		end
	end

	if self.task_ply then
		MQS.ActiveDataShare(self.task_ply)
	end
end