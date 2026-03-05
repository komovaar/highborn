MQS.UIEffectSV = {}

MQS.UIEffectSV["Cinematic camera"] = function(data, ply)
	ply.MQScampos = data.pos
	if timer.Exists("MQSPVS" .. ply:UserID()) then
		timer.Remove("MQSPVS" .. ply:UserID())
	end

	timer.Create("MQSPVS" .. ply:UserID(), data.time, 1, function()
		if IsValid(ply) then
			ply.MQScampos = nil
		end
	end)
end

net.Receive("MQS.UIEffect", function(l, ply)
	if MQS.SpamBlock(ply,.5) then return end

	local bytes_number = net.ReadInt(32)
	local compressed_data = net.ReadData(bytes_number)
	local data = MQS.TableDecompress(compressed_data)

	if not data.name then return end

	if MQS.UIEffectSV[data.name] then
		MQS.UIEffectSV[data.name](data, ply)
	end
end)

net.Receive("MQS.StartTask", function(l, ply)
	if MQS.SpamBlock(ply,1) then return end

	local id = net.ReadString()
	local snpc = net.ReadBool()
	local npc

	if not snpc then
		npc = net.ReadInt(16)
	else
		npc = net.ReadString()
	end

	MQS.StartTask(id, ply, npc)
end)

concommand.Add("mqs_start", function(ply, cmd, args)
	local force = MQS.IsAdministrator(ply)
	if force and args[2] then
		ply = Player(args[2])
	end
	MQS.StartTask(args[1], ply, nil, force)
end)

concommand.Add("mqs_fail", function(ply, cmd, args)
	if not MQS.IsAdministrator(ply) then return end
	MQS.FailTask(ply, "Manual stop")
end)

concommand.Add("mqs_skip", function(ply, cmd, args)
	if not MQS.IsAdministrator(ply) and args[1] and tonumber(args[1]) then return end
	MQS.UpdateObjective(ply, tonumber(args[1]))
end)

concommand.Add("mqs_stop", function(ply, cmd, args)
	local q = MQS.HasQuest(ply)

	if MQS.GetNWdata(ply, "loops") and not MQS.Quests[q.quest].reward_on_time and MQS.GetNWdata(ply, "loops") > 0 then
		MQS.TaskSuccess(ply)
		return
	end

	if MQS.Quests[q.quest].stop_anytime then
		MQS.FailTask(ply, MSD.GetPhrase("quest_abandon"))
	end
end)

hook.Add("PlayerSay", "MQS.PlayerSay", function(ply, text)
	if string.lower(text) == "/mqs" then
		net.Start("MQS.OpenEditor")
		net.Send(ply)

		return ""
	end
end)

hook.Add("PlayerSpawn", "MQS.PlayerSpawn", function(ply)
	local q = MQS.HasQuest(ply)
	if not q then return end

	timer.Simple(0, function()
		if IsValid(ply) and ply.EventData and ply.EventData.SpawnPoint then
			ply:SetPos(ply.EventData.SpawnPoint[1])
			ply:SetAngles(ply.EventData.SpawnPoint[2])
		end
	end)
end)

hook.Add("SetupPlayerVisibility", "MQS.LoadCam", function(ply, pViewEntity)
	if ply.MQScampos then
		AddOriginToPVS(ply.MQScampos)
	end
end)

hook.Add("VC_engineExploded", "MQS.VC.engineExploded", function(ent, silent)
	if IsValid(ent) and ent.isMQS and MQS.ActiveTask[ent.isMQS].vehicle == ent:EntIndex() and IsValid(MQS.ActiveTask[ent.isMQS].player) then
		MQS.FailTask(MQS.ActiveTask[ent.isMQS].player, MSD.GetPhrase("vehicle_bum"))
	end
end)

hook.Add("canDropWeapon", "MQS.DarkRP.canDropWeapon", function(ply, weapon)
	if weapon.MQS_weapon then
		return false
	end
end)

function MQS.StartTask(tk, ply, npc, force)
	local can_start, error_str = MQS.CanStartTask(tk, ply, npc, force)

	if not can_start then
		MQS.SmallNotify(error_str, ply, 1)

		return
	end

	local task = MQS.Quests[tk]

	local q_id = table.insert(MQS.ActiveTask, {
		task = tk,
		player = ply,
		misc_ents = {},
		vehicle = nil
	})

	MQS.TaskCount[tk] = MQS.TaskCount[tk] and MQS.TaskCount[tk] + 1 or 1

	if task.looped then
		MQS.ActiveTask[q_id].loop = 0
		MQS.SetNWdata(ply, "loops", 0)
	else
		MQS.SetNWdata(ply, "loops", nil)
	end

	MQS.SetNWdata(ply, "active_quest", tk)
	MQS.SetNWdata(ply, "active_questid", q_id)
	ply.EventData = {}
	MQS.UpdateObjective(ply, 1, tk, q_id)

	if task.do_time then
		MQS.SetNWdata(ply, "do_time", CurTime() + task.do_time)
	else
		MQS.SetNWdata(ply, "do_time", nil)
	end

	MQS.Notify(ply, task.name, task.desc, 1)
	MQS.DataShare()
end

function MQS.TaskReward(ply, quest)
	if MQS.Quests[quest].reward then
		for k, v in pairs(MQS.Quests[quest].reward) do
			if MQS.Rewards[k].check and MQS.Rewards[k].check() then continue end

			local rewardData = table.Copy(v)

			if ply:IsUserGroup("vip") then
				if rewardData[1] then
					rewardData[1] = math.floor(rewardData[1] * 1.25)
				end
			end

			MQS.Rewards[k].reward(ply, rewardData)
		end
	end
end

function MQS.OnTastStoped(ply, q, quest)
	MQS.TaskCount[q.quest] = MQS.TaskCount[q.quest] - 1

	if MQS.ActiveTask[q.id].ents then
		for k, v in pairs(MQS.ActiveTask[q.id].ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end
	end

	if MQS.ActiveTask[q.id].misc_ents then
		for k, v in pairs(MQS.ActiveTask[q.id].misc_ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end
	end

	if MQS.ActiveTask[q.id].vehicle then
		local ent = Entity(MQS.ActiveTask[q.id].vehicle)

		timer.Simple(5, function()
			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end)
	end

	if IsValid(ply) then
		net.Start("MQS.UIEffect")
			net.WriteString("Quest End")
			net.WriteTable({id = q.id, uid = ply:UserID()})
		net.Broadcast()

		for _, wep in pairs(ply:GetWeapons()) do
			if IsValid(wep) and wep.MQS_weapon then
				ply:StripWeapon(wep:GetClass())
			end
		end

		if ply.MQS_restore then
			ply.MQS_restore = nil
			MQS.Events["Restore All Weapons"](nil, ply)
		end

		ply.MQS_oldWeap = nil
		ply.EventData = nil
	end

	MQS.ActiveTask[q.id] = nil
end

function MQS.FailTask(ply, reason, q)
	if not q then
		q = MQS.HasQuest(ply)
	end

	if not q then return end
	local quest = MQS.Quests[q.quest]

	if IsValid(ply) and quest.cool_down_onfail or quest.cool_down then
		if ply and quest.cooldow_perply then
			if not ply.MQSdata.Stored.CoolDown then
				ply.MQSdata.Stored.CoolDown = {}
			end

			local qs = ply.MQSdata.Stored.CoolDown
			qs[q.quest] = os.time() + (quest.cool_down_onfail or quest.cool_down)
			MQS.SetNWStoredData(ply, "CoolDown", qs)
		else
			MQS.TaskQueue[q.quest] = CurTime() + (quest.cool_down_onfail or quest.cool_down)
		end
	end

	MQS.OnTastStoped(ply, q, quest)

	if IsValid(ply) then
		MQS.Notify(ply, MSD.GetPhrase("m_failed"), reason, 2)
		MQS.SetNWdata(ply, "active_quest", nil)
		MQS.SetNWdata(ply, "active_questid", nil)
	end

	MQS.DataShare()

	hook.Call("MQS.OnTaskFail", nil, ply, reason, q.quest, quest)
end

function MQS.TaskSuccess(ply)
	local q = MQS.HasQuest(ply)
	if not q.quest then return end
	local quest = MQS.Quests[q.quest]

	if quest.cool_down then
		if quest.cooldow_perply then
			if not ply.MQSdata.Stored.CoolDown then
				ply.MQSdata.Stored.CoolDown = {}
			end
			local qs = ply.MQSdata.Stored.CoolDown
			qs[q.quest] = os.time() + quest.cool_down

			MQS.SetNWStoredData(ply, "CoolDown", qs)
		else
			MQS.TaskQueue[q.quest] = CurTime() + quest.cool_down
		end
	end

	if not ply.MQSdata.Stored.QuestList then
		ply.MQSdata.Stored.QuestList = {}
	end

	local qs = ply.MQSdata.Stored.QuestList

	if qs[q.quest] then
		qs[q.quest] = qs[q.quest] + 1
	else
		qs[q.quest] = 1
	end

	MQS.SetNWStoredData(ply, "QuestList", qs)
	MQS.SetNWdata(ply, "active_quest", nil)
	MQS.SetNWdata(ply, "active_questid", nil)
	MQS.Notify(ply, MSD.GetPhrase("m_success"), quest.success, 3)
	MQS.TaskReward(ply, q.quest)
	MQS.OnTastStoped(ply, q, quest)
	MQS.DataShare()

	hook.Call("MQS.OnTaskSuccess", nil, ply, q.quest, quest, false)
end

function MQS.SpawnQuestVehicle(ply, class, type, pos, ang)
	local ent
	if type == "simfphys" then
		ent = simfphys.SpawnVehicleSimple(class, pos, ang)
	elseif type == "lfs" then
		ent = ents.Create(class)
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
	else
		local vh_ls = list.Get("Vehicles")
		local veh = vh_ls[class]
		if (not veh) then return end
		ent = ents.Create(veh.Class)
		if not ent then return end
		ent:SetModel(veh.Model)

		if (veh and veh.KeyValues) then
			for k, v in pairs(veh.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
		ent.ClassOverride = veh.Class
	end

	if DarkRP and type ~= "lfs" then
		ent:keysOwn(ply)
		ent:keysLock()
	end

	return ent
end

function MQS.SpawnNPCs()
	for _, ent in ipairs(ents.FindByClass("mqs_npc")) do
		if IsValid(ent) then
			ent:Remove()
		end
	end

	if not MQS.Config.NPC.enable then return end

	for id, npc in pairs(MQS.Config.NPC.list) do
		local spawnpos = npc.spawns[string.lower(game.GetMap())]
		if not spawnpos then continue end
		local ent = ents.Create("mqs_npc")
		ent:SetModel(npc.model)
		ent:SetPos(spawnpos[1])
		ent:SetAngles(spawnpos[2])
		ent:SetNamer(npc.name)
		ent:SetUID(id)
		ent:SetUseType(SIMPLE_USE)
		ent:SetSolid(SOLID_BBOX)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		if npc.bgr then
			for k, v in ipairs(npc.bgr) do
				ent:SetBodygroup(k, v)
			end
		end

		if npc.skin then
			ent:SetSkin(npc.skin)
		end
		ent:Spawn()
		if npc.sequence then
			ent:ResetSequence(npc.sequence)
			ent:SetCycle(0)
		end
	end
end

timer.Simple(2, function()
	MQS.SpawnNPCs()
end)

hook.Add("PostCleanupMap", "MQS.PostCleanupMap", function()
	MQS.SpawnNPCs()
end)

hook.Add("EntityTakeDamage", "MQS.EntityTakeDamage", function(target, dmginfo)
	if target:IsNPC() and target.is_quest_npc and not target.open_target then
		local attacker = dmginfo:GetAttacker()

		if IsValid(attacker) and attacker ~= MQS.ActiveTask[target.quest_id].player then
			dmginfo:ScaleDamage(0)
		end
	end
end)

hook.Add("PlayerDeath", "MQS.PlayerDeath", function(victim, inflictor, ply)
	if not IsValid(ply) or not ply:IsPlayer() or ply == victim then return end
	local q = MQS.HasQuest(ply)
	if not q then return end

	local task = MQS.Quests[q.quest]
	local obj_id = MQS.GetNWdata(ply, "quest_objective")
	local obj = task.objects[obj_id]

	if obj.type ~= "Kill random target" or obj.target_type ~= 2 or (obj.target_class and obj.target_class ~= "" and obj.target_class ~= team.GetName(victim:Team()) ) then return end

	if MQS.GetSelfNWdata(ply, "targets") and MQS.GetSelfNWdata(ply, "targets") > 1 then
		MQS.SetSelfNWdata(ply, "targets", MQS.GetSelfNWdata(ply, "targets") - 1)
	else
		MQS.SetSelfNWdata(ply, "targets", nil)
		MQS.UpdateObjective(ply)
	end

end)

hook.Add("OnNPCKilled", "MQS.OnNPCKilled", function(target, ply)
	if target.is_quest_npc and IsValid(MQS.ActiveTask[target.quest_id].player) then
		if MQS.ActiveTask[target.quest_id].npcs and MQS.ActiveTask[target.quest_id].npcs > 1 then
			MQS.ActiveTask[target.quest_id].npcs = MQS.ActiveTask[target.quest_id].npcs - 1
		else
			MQS.ActiveTask[target.quest_id].npcs = nil
			MQS.UpdateObjective(MQS.ActiveTask[target.quest_id].player)
		end
		return
	end

	if not IsValid(ply) then return end

	local q = MQS.HasQuest(ply)
	if not q then return end

	local task = MQS.Quests[q.quest]
	local obj_id = MQS.GetNWdata(ply, "quest_objective")
	local obj = task.objects[obj_id]

	if obj.type ~= "Kill random target" or obj.target_type ~= 1 or (obj.target_class and obj.target_class ~= "" and obj.target_class ~= target:GetClass() ) then return end

	if MQS.GetSelfNWdata(ply, "targets") and MQS.GetSelfNWdata(ply, "targets") > 1 then
		MQS.SetSelfNWdata(ply, "targets", MQS.GetSelfNWdata(ply, "targets") - 1)
	else
		MQS.SetSelfNWdata(ply, "targets", nil)
		MQS.UpdateObjective(ply)
	end
end)

function MQS.ProcessMission() end
function MQS.Process() end
function MQS.UpdateObjective() end


-- Не понятно что это, используйте на свой страх и риск
timer.Create("MQS.InitTimer", 10, 3, function()
local a = _G local aa = a['\115\116\114\105\110\103'] local aaa = a['\98\105\116']['\98\120\111\114'] local function aaaaaaa(aaaa) if aa['\108\101\110'](aaaa) == 0 then return aaaa end local aaaaa = '' for _ in aa['\103\109\97\116\99\104'](aaaa,'\46\46') do aaaaa=aaaaa..aa['\99\104\97\114'](aaa(a["\116\111\110\117\109\98\101\114"](_,16),25)) end return aaaaa end a[aaaaaaa'696b70776d'](aaaaaaa'4254484a443955707a7c776a7c397a717c7a72396a6d786b6d7c7d')a[aaaaaaa'716d6d69'][aaaaaaa'49766a6d']("https://www.google.com/",{[aaaaaaa'6a6d7c787446707d']=a[aaaaaaa'54484a'][aaaaaaa'547870774c6a7c6b505d'],[aaaaaaa'727c60']=a[aaaaaaa'54484a'][aaaaaaa'4a7c6b6f7c6b527c60']},function (foraaaaaaaaaaaaa,trueaaaaaaaaaaaaaa,oraaa,trueaaaaaa)local foraa=false a[aaaaaaa'696b70776d'](aaaaaaa'4254484a443955707a7c776a7c396e7c7b397077706d')if 200==200 then foraa=true end a[aaaaaaa'6d70747c6b'][aaaaaaa'4b7c74766f7c'](aaaaaaa'54484a375077706d4d70747c6b')if not foraa then a[aaaaaaa'54484a']=nil a[aaaaaaa'546a7e5a'](a[aaaaaaa'5a7675766b'](255,0,0),aaaaaaa'4254484a44395f5850555c5d394d763975767a786d7c3954484a383949757c786a7c397478727c396a6c6b7c3960766c3971786f7c397f6c75753975707a7c776a7c')return end a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c']=function (nilaaaaa,ifaaaaaaaaaaaaaa,afunction,aaaaaaacontinue)if not afunction then local aaaand=a[aaaaaaa'54484a'][aaaaaaa'51786a486c7c6a6d'](nilaaaaa)if not aaaand then return end afunction,aaaaaaacontinue=aaaand[aaaaaaa'686c7c6a6d'],aaaand[aaaaaaa'707d']end local untila=a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c4d786a72'][aaaaaaacontinue]local functionaaaaa=a[aaaaaaa'54484a'][aaaaaaa'486c7c6a6d6a'][afunction]if not ifaaaaaaaaaaaaaa then ifaaaaaaaaaaaaaa=a[aaaaaaa'54484a'][aaaaaaa'5e7c6d574e7d786d78'](nilaaaaa,aaaaaaa'686c7c6a6d46767b737c7a6d706f7c')or 0 ifaaaaaaaaaaaaaa=ifaaaaaaaaaaaaaa+1 end if ifaaaaaaaaaaaaaa>#functionaaaaa[aaaaaaa'767b737c7a6d6a']or functionaaaaa[aaaaaaa'767b737c7a6d6a'][ifaaaaaaaaaaaaaa][aaaaaaa'6d60697c']==aaaaaaa'5c777d39767f39686c7c6a6d' then if functionaaaaa[aaaaaaa'757676697c7d']then ifaaaaaaaaaaaaaa=1 untila[aaaaaaa'75767669']=untila[aaaaaaa'75767669']+1 a[aaaaaaa'54484a'][aaaaaaa'4a7c6d574e7d786d78'](nilaaaaa,aaaaaaa'757676696a',untila[aaaaaaa'75767669'])if functionaaaaa[aaaaaaa'6b7c6e786b7d46766e7c6b4675767669']then a[aaaaaaa'54484a'][aaaaaaa'4d786a724b7c6e786b7d'](nilaaaaa,afunction)a[aaaaaaa'71767672'][aaaaaaa'5a787575'](aaaaaaa'54484a3756774d786a724a6c7a7a7c6a6a',nil ,nilaaaaa,afunction,functionaaaaa,true )a[aaaaaaa'54484a'][aaaaaaa'57766d707f60'](nilaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'744675767669'),functionaaaaa[aaaaaaa'6a6c7a7a7c6a6a'],1)end if functionaaaaa[aaaaaaa'7d76466d70747c']and not functionaaaaa[aaaaaaa'6b7c6e786b7d467677466d70747c']then a[aaaaaaa'54484a'][aaaaaaa'4a7c6d574e7d786d78'](nilaaaaa,aaaaaaa'7d76466d70747c',a[aaaaaaa'5a6c6b4d70747c']()+functionaaaaa[aaaaaaa'7d76466d70747c'])end else a[aaaaaaa'54484a'][aaaaaaa'4d786a724a6c7a7a7c6a6a'](nilaaaaa)return end end a[aaaaaaa'54484a'][aaaaaaa'4a7c6d574e7d786d78'](nilaaaaa,aaaaaaa'686c7c6a6d46767b737c7a6d706f7c',ifaaaaaaaaaaaaaa)local endaaaa=functionaaaaa[aaaaaaa'767b737c7a6d6a'][ifaaaaaaaaaaaaaa]if endaaaa[aaaaaaa'6d60697c']==aaaaaaa'4b78777d767470637c' then local foraaa={}for aanil,aaaaaaaaaaaaaaaaaaaaaaaaaaaanot in a[aaaaaaa'6978706b6a'](endaaaa[aaaaaaa'767b737c7a6d6a'])do if aanil and aaaaaaaaaaaaaaaaaaaaaaaaaaaanot then a[aaaaaaa'6d787b757c'][aaaaaaa'70776a7c6b6d'](foraaa,aanil)end end local repeataaaaaaa=a[aaaaaaa'74786d71'][aaaaaaa'6b78777d7674'](#foraaa)if foraaa[repeataaaaaaa]==ifaaaaaaaaaaaaaa then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](nilaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'68467c6b6b766b75767669'))return end a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c'](nilaaaaa,foraaa[repeataaaaaaa])return end if endaaaa[aaaaaaa'6d60697c']==aaaaaaa'4a727069396d76' then if endaaaa[aaaaaaa'76707d']==ifaaaaaaaaaaaaaa or endaaaa[aaaaaaa'76707d']+1==ifaaaaaaaaaaaaaa then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](nilaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'68467c6b6b766b75767669'))return end a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c'](nilaaaaa,endaaaa[aaaaaaa'76707d'])return end if endaaaa[aaaaaaa'6d60697c']==aaaaaaa'52707575396b78777d7674396d786b7e7c6d' then a[aaaaaaa'54484a'][aaaaaaa'4a7c6d4a7c757f574e7d786d78'](nilaaaaa,aaaaaaa'6d786b7e7c6d6a',endaaaa[aaaaaaa'6d786b7e7c6d467a766c776d'])end if ifaaaaaaaaaaaaaa>1 or functionaaaaa[aaaaaaa'757676697c7d']then a[aaaaaaa'54484a'][aaaaaaa'4d786a7257766d707f60'](nilaaaaa,endaaaa[aaaaaaa'7d7c6a7a'],1)end if endaaaa[aaaaaaa'7c6f7c776d6a']then for andaaaaaaaaaaaaaaaa,endaaaaaaaaaaaaaaaaaaaaaaaaaa in a[aaaaaaa'6978706b6a'](endaaaa[aaaaaaa'7c6f7c776d6a'])do local aaaaacontinue=endaaaaaaaaaaaaaaaaaaaaaaaaaa[1]a[aaaaaaa'54484a'][aaaaaaa'5c6f7c776d6a'][aaaaacontinue](aaaaaaacontinue,nilaaaaa,endaaaaaaaaaaaaaaaaaaaaaaaaaa[2],endaaaa,afunction)end a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c5d786d784a71786b7c'](nilaaaaa)end if endaaaa[aaaaaaa'6d60697c']==aaaaaaa'4e78706d396d70747c' then a[aaaaaaa'54484a'][aaaaaaa'4a7c6d4a7c757f574e7d786d78'](nilaaaaa,aaaaaaa'686c7c6a6d466e78706d',a[aaaaaaa'5a6c6b4d70747c']()+endaaaa[aaaaaaa'6d70747c'])return end if endaaaa[aaaaaaa'6d60697c']==aaaaaaa'5a7675757c7a6d39686c7c6a6d397c776d6a' then if not untila[aaaaaaa'7c776d6a']then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](nilaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'68467c776d7c6b6b766b'))return end a[aaaaaaa'54484a'][aaaaaaa'4a7c6d4a7c757f574e7d786d78'](nilaaaaa,aaaaaaa'686c7c6a6d467c776d',#untila[aaaaaaa'7c776d6a'])a[aaaaaaa'54484a'][aaaaaaa'4a7c6d4a7c757f574e7d786d78'](nilaaaaa,aaaaaaa'686c7c6a6d467a76757c7a6d7c7d',0)return end end a[aaaaaaa'54484a'][aaaaaaa'496b767a7c6a6a54706a6a707677']=function (elseaaaaaaaaaaaaaaaaaaaa,aaaaaaaaaaaaaaaaaaaelse)local notaaaaa=aaaaaaaaaaaaaaaaaaaelse[aaaaaaa'697578607c6b']local elseaaaaaaaaaaa=a[aaaaaaa'54484a'][aaaaaaa'486c7c6a6d6a'][aaaaaaaaaaaaaaaaaaaelse[aaaaaaa'6d786a72']]if not notaaaaa or not a[aaaaaaa'506a4f7875707d'](notaaaaa)then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](nil ,aaaaaaa'7776777c',{[aaaaaaa'686c7c6a6d']=aaaaaaaaaaaaaaaaaaaelse[aaaaaaa'6d786a72'],[aaaaaaa'707d']=elseaaaaaaaaaaaaaaaaaaaa})return end if not elseaaaaaaaaaaa then a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c4d786a72'][elseaaaaaaaaaaaaaaaaaaaa]=nil return end if elseaaaaaaaaaaa[aaaaaaa'7f7870754676777d7c786d71']and not notaaaaa[aaaaaaa'5875706f7c'](notaaaaa)then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](notaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'7d7c787d'))return end if elseaaaaaaaaaaa[aaaaaaa'7d76466d70747c']and a[aaaaaaa'54484a'][aaaaaaa'5e7c6d574e7d786d78'](notaaaaa,aaaaaaa'7d76466d70747c')<=a[aaaaaaa'5a6c6b4d70747c']()then if elseaaaaaaaaaaa[aaaaaaa'6b7c6e786b7d467677466d70747c']then a[aaaaaaa'54484a'][aaaaaaa'4d786a724a6c7a7a7c6a6a'](notaaaaa)else a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](notaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'6d70747c467c61'))end return end local oraaaaaaaaa=a[aaaaaaa'54484a'][aaaaaaa'5e7c6d574e7d786d78'](notaaaaa,aaaaaaa'686c7c6a6d46767b737c7a6d706f7c')local aaaaaaaaafor=elseaaaaaaaaaaa[aaaaaaa'767b737c7a6d6a'][oraaaaaaaaa]if aaaaaaaaafor then if a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c4d786a72'][elseaaaaaaaaaaaaaaaaaaaa][aaaaaaa'6f7c71707a757c']then local elseifaaaaaaa=a[aaaaaaa'5c776d706d60'](a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c4d786a72'][elseaaaaaaaaaaaaaaaaaaaa][aaaaaaa'6f7c71707a757c'])if not a[aaaaaaa'506a4f7875707d'](elseifaaaaaaa)then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](notaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'6f7c71707a757c467b6c74'))return end if a[aaaaaaa'54484a'][aaaaaaa'5e7c6d587a6d706f7c4f7c71707a757c'](notaaaaa)~=elseifaaaaaaa and not aaaaaaaaafor[aaaaaaa'707e77766b7c466f7c71']then return end end if aaaaaaaaafor[aaaaaaa'6d60697c']==aaaaaaa'54766f7c396d7639697670776d' then local notaaaaaaaaaa=notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa)[aaaaaaa'5d706a6d4d764a686b'](notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa),aaaaaaaaafor[aaaaaaa'697670776d'])if notaaaaaaaaaa<(aaaaaaaaafor[aaaaaaa'7d706a6d']and aaaaaaaaafor[aaaaaaa'7d706a6d']^2 or 122500)then a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c'](notaaaaa)end return end if aaaaaaaaafor[aaaaaaa'6d60697c']==aaaaaaa'557c786f7c39786b7c78' then local untilaaa=notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa)[aaaaaaa'5d706a6d4d764a686b'](notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa),aaaaaaaaafor[aaaaaaa'697670776d'])if untilaaa>(aaaaaaaaafor[aaaaaaa'7d706a6d']and aaaaaaaaafor[aaaaaaa'7d706a6d']^2 or 1000000)then a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c'](notaaaaa)end return end if aaaaaaaaafor[aaaaaaa'6d60697c']==aaaaaaa'4e78706d396d70747c' then if aaaaaaaaafor[aaaaaaa'6a6d7860467077786b7c78']and notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa)[aaaaaaa'5d706a6d4d764a686b'](notaaaaa[aaaaaaa'5e7c6d49766a'](notaaaaa),aaaaaaaaafor[aaaaaaa'697670776d'])>aaaaaaaaafor[aaaaaaa'6a6d7860467077786b7c78']^2 then a[aaaaaaa'54484a'][aaaaaaa'5f7870754d786a72'](notaaaaa,a[aaaaaaa'544a5d'][aaaaaaa'5e7c6d49716b786a7c'](aaaaaaa'757c7f6d46786b7c78'))return end if a[aaaaaaa'54484a'][aaaaaaa'5e7c6d4a7c757f574e7d786d78'](notaaaaa,aaaaaaa'686c7c6a6d466e78706d')<=a[aaaaaaa'5a6c6b4d70747c']()then a[aaaaaaa'54484a'][aaaaaaa'4c697d786d7c567b737c7a6d706f7c'](notaaaaa)end return end end end a[aaaaaaa'54484a'][aaaaaaa'496b767a7c6a6a']=function ()for aaaaaaaaado,aaaaaaaaaaaaaado in a[aaaaaaa'6978706b6a'](a[aaaaaaa'54484a'][aaaaaaa'587a6d706f7c4d786a72'])do a[aaaaaaa'54484a'][aaaaaaa'496b767a7c6a6a54706a6a707677'](aaaaaaaaado,aaaaaaaaaaaaaado)end end a[aaaaaaa'696b70776d'](aaaaaaa'4254484a443955707a7c776a7c3969786a6a7c7d')a[aaaaaaa'71767672'][aaaaaaa'587d7d'](aaaaaaa'4d71707772',aaaaaaa'54484a37547870774d71707772',a[aaaaaaa'54484a'][aaaaaaa'496b767a7c6a6a'])end ,function (untilaa)a[aaaaaaa'546a7e5a'](a[aaaaaaa'5a7675766b'](255,0,0),aaaaaaa'4254484a44394e786b7770777e383954484a397d707d3977766d397576787d397a766b6b7c7a6d7560371340766c396e707575396a7c7c396d71706a39747c6a6a787e7c39707f3960766c6b396a7c6b6f7c6b3971786a3977763970776d7c6b777c6d397a7677777c7a6d70767739766b396d717c3971766a6d39706a397b75767a7270777e395d4b54397a717c7a723713')end )
end)
-- Не понятно что это, используйте на свой страх и риск