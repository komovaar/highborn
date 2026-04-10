if CLIENT then
	local suitelements = {}
	local helmelements = {}
	local LocalPlayer = LocalPlayer
	local IsValid = IsValid
	local CurTime = CurTime
	local Lerp = Lerp
	local math_random = math.random
	local math_sin = math.sin
	local math_Round = math.Round
	local surface_SetDrawColor = surface.SetDrawColor
	local draw_RoundedBox = draw.RoundedBox
	local draw_SimpleText = draw.SimpleText
	local cam_Start3D = cam.Start3D
	local cam_End3D = cam.End3D
	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local cv_nv_key = CreateConVar("katarn_nv_key", tostring(KEY_N), {FCVAR_ARCHIVE}, "Night Vision Key")
	local cv_nv_r = CreateConVar("katarn_nv_r", "102", {FCVAR_ARCHIVE}, "NV Red")
	local cv_nv_g = CreateConVar("katarn_nv_g", "153", {FCVAR_ARCHIVE}, "NV Green")
	local cv_nv_b = CreateConVar("katarn_nv_b", "255", {FCVAR_ARCHIVE}, "NV Blue")
	local cv_nv_cont = CreateConVar("katarn_nv_contrast", "0.6", {FCVAR_ARCHIVE}, "NV Contrast")
	local cv_nv_bright = CreateConVar("katarn_nv_brightness", "5", {FCVAR_ARCHIVE}, "NV Brightness")
	
	net.Receive("UpdateExosuitModelHG", function()
		suitelements = net.ReadTable()
	end)
	
	surface.CreateFont("HGScoreBoard1", {font="Roboto Bold Condensed", size=23, weight=500, antialias=true})
	surface.CreateFont("HGScoreBoard2", {font="Roboto Bold Condensed", size=15, weight=500, antialias=true})
	
	local function GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang
		if tab.rel and tab.rel ~= "" then
			local v = basetab[tab.rel]
			if not v then return end
			pos, ang = GetBoneOrientation(basetab, v, ent)
			if not pos then return end
			pos = pos + ang:Forward()*v.pos.x + ang:Right()*v.pos.y + ang:Up()*v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if not bone then return end
			local m = ent:GetBoneMatrix(bone)
			if m then pos, ang = m:GetTranslation(), m:GetAngles() else return Vector(0,0,0), Angle(0,0,0) end
		end
		return pos, ang
	end
	
	hook.Add("PostPlayerDraw", "DrawExosuitHg", function(ply)
		if not IsValid(ply) or ply:GetNWString("hgexosuit") == "" then
			if suitelements then
				for _, v in pairs(suitelements) do if IsValid(v.modelEnt) then v.modelEnt:Remove() end end
			end
			return
		end
		
		if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 2250000 then return end
		
		for _, v in pairs(suitelements) do
			if IsValid(v.modelEnt) then
				local model = v.modelEnt
				local pos, ang
				if v.bone then pos, ang = GetBoneOrientation(suitelements, v, ply)
				else pos, ang = GetBoneOrientation(suitelements, v, ply, "ValveBiped.Bip01_R_Hand") end
				if pos and ang then
					model:SetPos(pos + ang:Forward()*v.pos.x + ang:Right()*v.pos.y + ang:Up()*v.pos.z)
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
					model:SetAngles(ang)
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix("RenderMultiply", matrix)
					render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
					render.SetBlend(v.color.a/255)
					model:DrawModel()
					render.SetBlend(1)
					render.SetColorModulation(1, 1, 1)
				end
			elseif v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) then
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if IsValid(v.modelEnt) then
					v.modelEnt:SetPos(ply:GetPos())
					v.modelEnt:SetAngles(ply:GetAngles())
					v.modelEnt:SetParent(ply)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else v.modelEnt = nil end
			end
		end
	end)
	
	local lerp1, lerp2, thrustlerp, bobang, bobangr, bobangr2 = 1, 0, 0, Angle(0,0,0), 0, 0
	local mdeltax, mdeltay, armorlerp, nvdelay, nv_on, nv_lerp, nv_lerp2, loading = 0, 0, 0, 0, false, 0, 1, 0
	local nv_katarn_light = nil
	
	hook.Add("CreateMove", "CreateMoveExosuitHudhg", function(cmd) mdeltax = cmd:GetMouseX() mdeltay = cmd:GetMouseY() end)
	
	local function HandleNighvision(ply)
		local key = cv_nv_key:GetInt()
		
		if key > 0 and input.IsKeyDown(key) and nvdelay < CurTime() and ply:GetNWString("hgexosuit") ~= "" then
			nv_on = not nv_on
			nvdelay = CurTime() + .2
			if not nv_on and IsValid(nv_katarn_light) then
				nv_katarn_light:Remove()
			end
		end
		
		if ply:GetNWString("hgexosuit") == "" then 
			nv_on = false 
			if IsValid(nv_katarn_light) then
				nv_katarn_light:Remove()
			end
		end
		
		if ply:Alive() and nv_on then
			nv_lerp = Lerp(FrameTime()*4, nv_lerp, 1)
			nv_lerp2 = Lerp(FrameTime()*8, nv_lerp2, 0)
			if not IsValid(nv_katarn_light) then
				nv_katarn_light = ProjectedTexture()
				nv_katarn_light:SetTexture("effects/flashlight001")
				nv_katarn_light:SetEnableShadows(false)
				nv_katarn_light:SetFOV(150)
			end
			if IsValid(nv_katarn_light) then
				local r = cv_nv_r:GetInt() * nv_lerp
				local g = cv_nv_g:GetInt() * nv_lerp
				local b = cv_nv_b:GetInt() * nv_lerp
				nv_katarn_light:SetPos(LocalPlayer():GetShootPos())
				nv_katarn_light:SetAngles(LocalPlayer():EyeAngles())
				nv_katarn_light:SetColor(Color(r, g, b, 255))
				local range_cvar = GetConVar("katarn_nv_range")
				local range = range_cvar and range_cvar:GetInt() or 1024
				nv_katarn_light:SetFarZ(range)
				nv_katarn_light:SetBrightness(0.8 * nv_lerp)
				nv_katarn_light:Update()
			end
			DrawSharpen(cv_nv_cont:GetFloat()*nv_lerp, cv_nv_bright:GetFloat()*nv_lerp)
			surface_SetDrawColor(255, 255, 255, 255)
			local tid = surface.GetTextureID("effects/combine_binocoverlay")
			if tid then surface.SetTexture(tid) surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, ScrW(), ScrH(), 0) end
			draw_RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 105*nv_lerp, 205*nv_lerp, 255*nv_lerp2))
		else
			nv_lerp = Lerp(FrameTime()*16, nv_lerp, 0)
			nv_lerp2 = Lerp(FrameTime()*8, nv_lerp2, 1)
			if nv_lerp > 0.01 then draw_RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(102*nv_lerp2, 153*nv_lerp2, 255*nv_lerp2, 255*nv_lerp)) end
		end
	end
	
	local startX, startY = 350, 50
	
	local function HandleLoading()
		if loading < 100 then
			draw_RoundedBox(0, startX + 2, startY + 72, 125, 13, Color(0, 153, 255, math_random(35,55)))
			draw_SimpleText(" Authorization... ", "HGScoreBoard2", startX + 37, startY + 47, Color(255, 255, 255, math_random(100,120)*math.abs(math_sin(CurTime()*2))), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw_SimpleText(math_Round(loading).." %", "HGScoreBoard2", startX + 133, startY + 78, Color(255, 255, 255, math_random(100,120)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			for i = 1, loading/2.7 do draw_RoundedBox(0, startX + 3.3*i, startY + 73, 3, 10, Color(255, 255, 255, math_random(90,120)*lerp2)) end
			loading = loading + 0.5
		end
		if loading < 150 and loading >= 100 then
			draw_SimpleText("< System synchronization >", "HGScoreBoard2", startX, startY + 67, Color(255, 255, 255, math_random(100,120)*math.abs(math_sin(CurTime()*2))), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			loading = loading + 0.5
		end
	end
	
	hook.Add("HUDPaint", "DrawExosuitHudhg", function()
		local ply = LocalPlayer()
		
		HandleNighvision(ply)
		
		if GetConVarNumber("cl_drawhud") == 1 and ply:GetNWString("hgexosuit") ~= "" then
			lerp1 = Lerp(FrameTime()*2, lerp1, 0)
			lerp2 = Lerp(FrameTime()*2, lerp2, 1)
			
			if loading >= 30 then
				draw_RoundedBox(0, startX, startY, 267, 21, Color(15, 15, 255, math_random(35,55)*lerp2))
				
				local energy = ply:GetNWFloat("exoenergy")
				
				if energy > 20 then
					for i = 1, energy/4 do draw_RoundedBox(0, startX + 57 + 8*i, startY + 2, 7, 17, Color(123, 104, 238, math_random(90,105)*lerp2)) end
					draw_SimpleText("Normal", "HGScoreBoard2", startX + 7, startY + 11, Color(0, 255, 255, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				elseif energy <= 20 and energy > 5 then
					for i = 1, energy/4 do draw_RoundedBox(0, startX + 57 + 8*i, startY + 2, 7*math.abs(math_sin(CurTime()*3)), 17, Color(255, 50, 50, math_random(90,105)*lerp2)) end
					draw_SimpleText("Low", "HGScoreBoard2", startX + 7, startY + 11, Color(255, 0, 255, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				elseif energy <= 5 then
					draw_RoundedBox(0, startX + 63, startY + 2, 200*math.abs(math_sin(CurTime()*3)), 17, Color(255, 50, 50, math_random(85,100)))
					draw_SimpleText("CRITICAL CONDITION", "HGScoreBoard2", startX + 7, startY + 11, Color(255, 0, 0, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
			
			if loading >= 50 then
				local armor = ply:GetNWFloat("exoarmor")
				
				armorlerp = Lerp(FrameTime()*8, armorlerp, armor+1)
				
				draw_RoundedBox(0, startX, startY + 30, 267, 21, Color(15, 15, 255, math_random(35,55)*lerp2))
				
				if armor > 0 then 
					draw_SimpleText("Armor", "HGScoreBoard2", startX + 11, startY + 41, Color(0, 255, 255, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else 
					draw_SimpleText("Broken", "HGScoreBoard2", startX + 7, startY + 41, Color(255, 0, 0, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
					draw_RoundedBox(0, startX + 63, startY + 32, 200*math.abs(math_sin(CurTime()*3)), 17, Color(255, 0, 0, math_random(85,100))) 
				end
				
				for i = 1, armorlerp/4 do draw_RoundedBox(0, startX + 57 + 8*i, startY + 32, 7, 17, Color(255, 0, 255, math_random(90,105)*lerp2)) end
			end
			
			if loading >= 90 then
				draw_SimpleText("CTRL+E+R - Remove armor system", "HGScoreBoard2", startX + 7, startY + 60, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				local keyName = input.GetKeyName(cv_nv_key:GetInt())
				if keyName then
					draw_SimpleText(string.upper(keyName).." - Night Vision", "HGScoreBoard2", startX + 7, startY + 77, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				if ply:GetNWFloat("exojumphold") > 20 then
					if ply:GetNWFloat("exoenergy") > 10 then 
						draw_SimpleText("< System Online >", "HGScoreBoard2", startX, startY + 93, Color(255, 50, 50, math_random(220,255)*math.abs(math_sin(CurTime()*2))), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					else 
						draw_SimpleText("< Insufficient Energy >", "HGScoreBoard2", startX, startY + 93, Color(255, 50, 50, math_random(220,255)*math.abs(math_sin(CurTime()*2))), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
					end
				end
				if ply:GetNWFloat("exoenergy") < 10 then draw_SimpleText("< DANGER!!! >", "HGScoreBoard2", startX + 20, startY + 93, Color(255, 0, 0, math_random(220,255)*math.abs(math_sin(CurTime()*2))), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
				draw_SimpleText("Katarn Armor", "HGScoreBoard2", startX, startY - 10, Color(65, 105, 225, math_random(240,255)*lerp2), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
			HandleLoading()
			draw_RoundedBox(0, 0, 0, ScrW(), ScrH()/2*lerp1, Color(0, 0, 0, 255*lerp1))
			draw_RoundedBox(0, 0, ScrH()-ScrH()/2*lerp1, ScrW(), ScrH()/2*lerp1, Color(0, 0, 0, 255*lerp1))
			draw_RoundedBox(0, 0, ScrH()/2-1, ScrW()/6, 2, Color(0, 153, 255, math_random(15,55)*lerp2))
			draw_RoundedBox(0, ScrW()-ScrW()/6, ScrH()/2-1, ScrW()/6, 2, Color(0, 153, 255, math_random(15,55)*lerp2))
		
		elseif ply:GetNWString("hgexosuit") == "" then 
			lerp1, lerp2, loading = 1, 0, 0 
		end
	end)
end