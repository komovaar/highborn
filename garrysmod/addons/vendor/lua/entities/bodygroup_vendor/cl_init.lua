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
-- FONTS
-- ======================================================
surface.CreateFont("BT.Title", {font="Overpass", size=42, weight=800, extended=true})
surface.CreateFont("BT.List", {font="Overpass", size=20, weight=600, extended=true})
surface.CreateFont("BT.Option", {font="Overpass", size=20, weight=500, extended=true})
surface.CreateFont("BT.Button", {font="Overpass", size=26, weight=800, extended=true})
surface.CreateFont("BT.Balance", {font="Overpass", size=36, weight=500, extended=true})

-- ======================================================
-- UI
-- ======================================================
net.Receive("BGTrader.Open", function()
    if IsValid(BGTraderFrame) then BGTraderFrame:Remove() end

    local ply = LocalPlayer()
    local selectedBG
    local selectedValue
    local originalBodygroups = {}
    local bought = {}

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
        draw.SimpleText("RC "..money, "BT.Balance", w - 220, 58, C.accent)
    end

    -- ================= CLOSE =================
    local close = vgui.Create("DButton", frame)
    close:SetSize(42,42)
    close:SetPos(ScrW()-60,30)
    close:SetText("✕")
    close:SetFont("BT.List")
    close:SetTextColor(C.text)
    close.Paint = function(self,w,h)
        draw.RoundedBox(14,0,0,w,h,C.panel)
    end
    close.DoClick = function()
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
    
    local vbar = list:GetVBar()
    vbar:SetWide(0)
    vbar.Paint = function() end
    vbar.btnUp.Paint = function() end
    vbar.btnDown.Paint = function() end
    vbar.btnGrip.Paint = function() end

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
        local id = bg.id
        local val = ply:GetBodygroup(id)

        ent:SetBodygroup(id, val)
        originalBodygroups[id] = val
    end
end

    -- ================= BODYGROUP LIST =================
    local cfg = Vendor.Models[ent:GetModel()]
    if not cfg then return end

    for key, values in pairs(cfg) do
        for i, name in pairs(values.options) do
            if i == 0 then continue end

            local opt = vgui.Create("DButton", list)
            opt:Dock(TOP)
            opt:SetTall(60)
            opt:DockMargin(0,0,0,10)
            opt:SetText(values.name)
            opt:SetFont("BT.List")
            opt:SetTextColor(C.text)

            opt.Paint = function(self,w,h)
                draw.RoundedBox(
                    12, 0, 0, w, h,
                    (selectedBG == values.id and selectedValue == i)
                        and C.accent or C.card
                )
            end

            opt.DoClick = function()
                if selectedBG then
                    ent:SetBodygroup(
                        selectedBG,
                        originalBodygroups[selectedBG]
                    )
                end

                selectedBG = values.id
                selectedValue = i

                ent:SetBodygroup(values.id, i)
            end
        end
    end

    -- ================= BUY =================
    local buy = vgui.Create("DButton", frame)
    buy:SetSize(320,64)
    buy:SetPos(ScrW()-360,ScrH()-100)
    buy:SetFont("BT.Button")
    buy:SetTextColor(Color(10,10,10))
    buy:SetText("")
    buy.Paint = function(self,w,h)
        draw.RoundedBox(22,0,0,w,h,C.accent)

        local text = "ПРИДБАТИ"
        if selectedBG and bought[selectedBG] then
            text = "ЗМІНИТИ"
        end

        draw.SimpleText(
            text,
            "BT.Button",
            w/2,
            h/2,
            Color(10,10,10),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end

    buy.DoClick = function()
        if not selectedBG or selectedValue == nil then return end

        ply:SetBodygroup(selectedBG, selectedValue)

        if not bought[selectedBG] then
            net.Start("BGTrader.Buy")
                net.WriteUInt(selectedBG, 8)
                net.WriteUInt(selectedValue, 8)
            net.SendToServer()
            bought[selectedBG] = true 
        end
    end
end)
