include("shared.lua")

local C = {
    bg     = Color(15,18,25,230),
    panel  = Color(20, 24, 36, 220),
    card   = Color(26,32,48,230),
    green  = Color(80,200,120),
    blue   = Color(80,140,220),
    red    = Color(220,80,80),
    text   = Color(230,235,255),
    soft   = Color(150,160,190),
    accent = Color(80,140,220),
}

local blur = Material("pp/blurscreen")

local function DrawBlur(panel)
    local x,y = panel:LocalToScreen(0,0)
    surface.SetMaterial(blur)
    surface.SetDrawColor(255,255,255)
    for i=1,6 do
        blur:SetFloat("$blur",i*1.2)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
    end
end

net.Receive("BGTrader.Open", function()

    local serverData = net.ReadTable() or {}

    if IsValid(BGTraderFrame) then BGTraderFrame:Remove() end

    local ply = LocalPlayer()
    local modelPath = ply:GetModel()
    local cfg = Vendor.Models[modelPath]
    if not cfg then return end

    local owned = {}
    for _, row in ipairs(serverData) do
        owned[row.bg_key] = {
            value = tonumber(row.owned_value),
            equipped = tonumber(row.equipped)
        }
    end

    local selectedKey
    local selectedData
    local selectedValue

    -- FRAME
    local frame = vgui.Create("DFrame")
    BGTraderFrame = frame
    frame:SetSize(ScrW(),ScrH())
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()

    frame.Paint = function(self,w,h)
        DrawBlur(self)
        draw.RoundedBox(0,0,0,w,h,C.bg)
        draw.SimpleText("ЕКІПІРУВАННЯ","WT.Title",40,30,C.blue)

        local money = LocalPlayer():getDarkRPVar("money") or 0
        draw.SimpleText("БАЛАНС", "WT.Balance", w - 220, 36, C.soft)
        draw.SimpleText("RC "..money, "WT.Balance", w - 220, 58, C.accent)
    end
    
    -- ================= CLOSE =================
    local close = vgui.Create("DButton", frame)
    close:SetSize(42,42)
    close:SetPos(ScrW()-60,30)
    close:SetText("✕")
    close:SetFont("WT.List")
    close:SetTextColor(C.text)
    close.Paint = function(self,w,h)
        draw.RoundedBox(14,0,0,w,h,C.panel)
    end
    close.DoClick = function()
        frame:Remove()
    end

    -- MODEL
    local modelPanel = vgui.Create("DModelPanel",frame)
    modelPanel:SetSize(ScrW()/2,ScrH()-220)
    modelPanel:SetPos(650,120)
    modelPanel:SetModel(modelPath)
    modelPanel:SetFOV(70)
	modelPanel.CurrAng = 0
	modelPanel.CamX = 0
	modelPanel.CamY = 0
    function modelPanel:Think()
		local pX, pY = self:GetParent():GetPos()
		local thisX, thisY, thisW, thisH = self:GetBounds()
		thisX = thisX + pX
		thisY = thisY + pY
		if gui.MouseX() < thisX or gui.MouseX() > thisX + thisW or gui.MouseY() < thisY or gui.MouseY() > thisY + thisH then
			if self.Rotating and not input.IsMouseDown( MOUSE_LEFT ) then
				self.Rotating = false 
			end
		end
	end
	function modelPanel:LayoutEntity( ent )
		if ( self.bAnimated ) then
			self:RunAnimation()
		end

		local pX, pY = self:GetParent():GetPos()

		if self.Rotating then
			local angDiff = gui.MouseX() - self.InitPos
			self.CurrAng = self.CurrAng + angDiff * 0.001
			if self.CurrAng >= 360 then
				self.CurrAng = self.CurrAng - 360
			end
			if self.CurrAng < 0 then
				self.CurrAng = self.CurrAng + 360
			end

		end
    		ent:SetAngles( Angle( 0, self.CurrAng, 0 ) )

	end

    function modelPanel:OnMousePressed( key )
		if key == MOUSE_LEFT then
			self.Rotating = true
			self.InitPos = gui.MouseX()
		end
	end
	function modelPanel:OnMouseReleased( key )
		if key == MOUSE_LEFT then
			self.Rotating = false
		end
	end

    local ent = modelPanel.Entity
    for _, bg in ipairs(ent:GetBodyGroups()) do
        ent:SetBodygroup(bg.id, ply:GetBodygroup(bg.id))
    end

    local action = vgui.Create("DButton",frame)
    action:SetSize(300,60)
    action:SetPos(ScrW()-360,ScrH()-120)
    action:SetFont("WT.Button")
    action:SetText("")
    action.mode = nil
    action:SetVisible(false)

    action.Paint=function(self,w,h)
        if not self.mode then return end

        local col = C.green
        if self.mode=="equip" then col=C.blue end
        if self.mode=="remove" then col=C.red end

        draw.RoundedBox(16,0,0,w,h,col)
        draw.SimpleText(self:GetText(),"WT.Button",w/2,h/2,Color(10,10,10),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    -- ================= LEFT LIST =================
    local left = vgui.Create("DPanel", frame)
    left:SetSize(360, ScrH() - 220)
    left:SetPos(30, 130)
    left.Paint = function(self, w, h)
        draw.RoundedBox(18, 0, 0, w, h, C.panel)
    end

    -- LIST LEFT
    local list = vgui.Create("DScrollPanel", left)
    list:SetSize(left:GetWide() - 24, left:GetTall() - 20)
    list:SetPos(12, 10)

    for key,data in pairs(cfg) do

        local card = list:Add("DButton")
        card:Dock(TOP)
        card:DockMargin(0,0,0,10)
        card:SetText("")
        card:SetTall(60)

        card.Paint=function(self,w,h)
            local bg = C.card

            if data.vip then
                bg = Color(200,170,60,230)
            end

            if selectedKey == key then
                bg = C.blue
            end

            draw.RoundedBox(12,0,0,w,h,bg)

            draw.SimpleText(
                data.name,
                "WT.List",
                15,20,
                C.text
            )

            draw.SimpleText(
                data.price.." RC",
                "WT.List",
                w-80,25,
                C.accent
            )
        end

        card.DoClick=function()
            for _, bg in ipairs(ent:GetBodyGroups()) do
                ent:SetBodygroup(bg.id, ply:GetBodygroup(bg.id))
            end

            selectedKey = key
            selectedData = data
            selectedValue = data.default or 1

            if (not owned[selectedKey]) then
                ent:SetBodygroup(data.id, selectedValue)
            end


            local state = owned[key]

            action:SetVisible(true)

            if not state then
                action:SetText("ПРИДБАТИ")
                action.mode="buy"

            elseif state.equipped==1 then
                action:SetText("ЗНЯТИ")
                action.mode="remove"

            else
                action:SetText("ОДЯГНУТИ")
                action.mode="equip"
            end
        end
    end

    -- BUTTON LOGIC
    action.DoClick=function()

        if not selectedData then return end

        if action.mode=="buy" then

            net.Start("BGTrader.Buy")
                net.WriteUInt(selectedData.id,8)
                net.WriteUInt(selectedValue,8)
            net.SendToServer()

            owned[selectedKey]={
                value=selectedValue,
                equipped=1
            }

            ply:SetBodygroup(selectedData.id,selectedValue)
            ent:SetBodygroup(selectedData.id,selectedValue)
            local money = ply:getDarkRPVar("money") or 0
            if money > selectedData.price then 
                action:SetText("ЗНЯТИ")
                action.mode="remove"
            end

        elseif action.mode=="equip" then

            net.Start("BGTrader.Buy")
                net.WriteUInt(selectedData.id,8)
                net.WriteUInt(selectedValue,8)
            net.SendToServer()

            owned[selectedKey].equipped=1

            ply:SetBodygroup(selectedData.id,selectedValue)
            ent:SetBodygroup(selectedData.id,selectedValue)

            action:SetText("ЗНЯТИ")
            action.mode="remove"

        elseif action.mode=="remove" then

            net.Start("BGTrader.Remove")
                net.WriteUInt(selectedData.id,8)
                net.WriteUInt(selectedData.default,9)
            net.SendToServer()

            owned[selectedKey].equipped=0

            ply:SetBodygroup(selectedData.id, selectedData.default)
            ent:SetBodygroup(selectedData.id,0)

            action:SetText("ОДЯГНУТИ")
            action.mode="equip"
        end
    end
end)


function ENT:Draw()
    self:DrawModel()

    -- Позиция немного впереди шкафа
    local pos = self:GetPos() 
        + self:GetUp() * 50    -- выше
        + self:GetForward() * 25 -- чуть вперед

    local ang = self:GetAngles()

    -- Поворачиваем текст по плоскости шкафа
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    cam.Start3D2D(pos, ang, 0.08)


        draw.SimpleText(
            "ЕКІПІРУВАННЯ",
            "WT.Model",
            0,
            0,
            C.accent,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

    cam.End3D2D()
end