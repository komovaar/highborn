include("shared.lua")

-- ======================================================
-- THEME
-- ======================================================
local C = {
    bg     = Color(10, 12, 18, 220),
    panel  = Color(20, 24, 36, 220),
    card   = Color(26, 32, 48, 230),
    accent = Color(80,140,220),
    soft   = Color(150,160,190),
    text   = Color(220,230,255)
}

-- ======================================================
-- BLUR
-- ======================================================
local blur = Material("pp/blurscreen")
local function DrawBlur(panel)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetMaterial(blur)
    surface.SetDrawColor(255,255,255)
    for i = 1, 6 do
        blur:SetFloat("$blur", i * 1.2)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end

-- ======================================================
-- FONTS (Overpass)
-- ======================================================
local function F(name, size, weight)
    surface.CreateFont(name, {font="Overpass", size=size, weight=weight, extended=true})
end

F("BT.Title", 42, 800)
F("BT.List", 20, 600)
F("BT.Option", 20, 500)
F("BT.Button", 26, 800)
F("BT.Balance", 36, 500)

-- ======================================================
-- UI
-- ======================================================
net.Receive("BGTrader.Open", function()
    if IsValid(BGTraderFrame) then BGTraderFrame:Remove() end

    local ply = LocalPlayer()
    local selectedBG
    local selectedValue
    local originalBodygroups = {}

    -- ================= FRAME =================
    local frame = vgui.Create("DFrame")
    BGTraderFrame = frame
    frame:SetSize(ScrW(), ScrH())
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()

    frame.Paint = function(self, w, h)
        DrawBlur(self)
        draw.RoundedBox(0, 0, 0, w, h, C.bg)
        draw.SimpleText("ТОРГОВЕЦЬ СПОРЯДЖЕННЯМ", "BT.Title", 40, 30, C.accent)
        local money = ply:getDarkRPVar("money") or 0
        draw.SimpleText("БАЛАНС", "BT.Balance", w - 220, 36, C.soft)
        draw.SimpleText("$"..money, "BT.Balance", w - 220, 58, C.accent)
    end

    -- ================= CLOSE =================
    local close = vgui.Create("DButton", frame)
    close:SetSize(42,42)
    close:SetPos(ScrW()-60,30)
    close:SetText("✕")
    close:SetFont("BT.List")
    close:SetTextColor(C.text)
    close.Paint = function(self,w,h) draw.RoundedBox(14,0,0,w,h,C.panel) end
    close.DoClick = function()
        -- откат всех несохранённых бодигруп
        for bgid,val in pairs(originalBodygroups) do
            ply:SetBodygroup(bgid,val)
        end
        frame:Remove()
    end

    -- ================= LEFT PANEL =================
    local left = vgui.Create("DPanel", frame)
    left:SetSize(360,ScrH()-190)
    left:SetPos(30,100)
    left.Paint = function(self,w,h)
        draw.RoundedBox(18,0,0,w,h,C.panel)
    end
    local list = vgui.Create("DScrollPanel", left)
    list:SetSize(left:GetWide()-24,left:GetTall()-20)
    list:SetPos(12,10)

    -- ================= RIGHT PANEL =================
    local right = vgui.Create("DScrollPanel", frame)
    right:SetSize(300,ScrH()-190)
    right:SetPos(ScrW()-330,100)

    -- ================= MODEL =================
    local model = vgui.Create("DModelPanel", frame)
    model:SetPos(350, 90)
    model:SetSize(ScrW() - 700, ScrH() - 200)
    model:SetModel(ply:GetModel())
    model:SetFOV(70)
    model.LayoutEntity = function(_,ent)
        ent:SetAngles(Angle(0,45,0))
    end

    local ent = model.Entity
    if not IsValid(ent) then return end
    for _, bg in ipairs(ent:GetBodyGroups()) do
        originalBodygroups[bg.id] = ent:GetBodygroup(bg.id)
    end

    -- ================= BODYGROUP LIST =================
    for _, bg in ipairs(ent:GetBodyGroups()) do
        if bg.num <= 1 then continue end

        local btn = vgui.Create("DButton", list)
        btn:Dock(TOP)
        btn:SetTall(60)
        btn:DockMargin(0,0,0,10)
        btn:SetText(bg.name)
        btn:SetFont("BT.List")
        btn:SetTextColor(C.text)
        btn.Paint = function(self,w,h)
            draw.RoundedBox(12,0,0,w,h,C.card)
        end

        btn.DoClick = function()
            -- откат предыдущей категории если не куплено
            if selectedBG and selectedValue ~= nil then
                model.Entity:SetBodygroup(selectedBG,originalBodygroups[selectedBG])
            end

            selectedBG = bg.id
            selectedValue = nil
            right:Clear()

            for v=0,bg.num-1 do
                local opt = vgui.Create("DButton", right)
                opt:Dock(TOP)
                opt:SetTall(50)
                opt:DockMargin(0,0,0,6)
                opt:SetText(v)
                opt:SetFont("BT.Option")
                opt:SetTextColor(C.text)

                opt.Paint = function(self,w,h)
                    draw.RoundedBox(8,0,0,w,h,selectedValue==v and C.accent or C.card)
                end

                opt.DoClick = function()
                    selectedValue=v
                    model.Entity:SetBodygroup(bg.id,v)
                end
            end
        end
    end

    -- ================= BUY =================
    local buy = vgui.Create("DButton", frame)
    buy:SetSize(320,64)
    buy:SetPos(ScrW()-360,ScrH()-100)
    buy:SetText("ПРИДБАТИ")
    buy:SetFont("BT.Button")
    buy:SetTextColor(Color(10,10,10))
    buy.Paint = function(self,w,h)
        draw.RoundedBox(22,0,0,w,h,C.accent)
    end
    buy.DoClick = function()
        if not selectedBG or selectedValue==nil then return end
        originalBodygroups[selectedBG] = selectedValue
        net.Start("BGTrader.Buy")
            net.WriteUInt(selectedBG,8)
            net.WriteUInt(selectedValue,8)
        net.SendToServer()
    end
end)
