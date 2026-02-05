include("shared.lua")

local ACCENT = Color(80, 140, 220)

-- ==================== ПОДКЛЮЧЕНИЕ ШРИФТА ====================
    surface.CreateFont("OverpassLarge", {
        font = "Overpass",
        size = 32,
        weight = 700,
        antialias = true,
    })

    surface.CreateFont("OverpassMedium", {
        font = "Overpass",
        size = 22,
        weight = 600,
        antialias = true,
    })

    surface.CreateFont("OverpassSmall", {
        font = "Overpass",
        size = 18,
        weight = 500,
        antialias = true,
    })

-- ==================== NET RECEIVE ====================
net.Receive("BGTrader.Open", function()
    if IsValid(BGTraderFrame) then BGTraderFrame:Remove() end

    local ply = LocalPlayer()
    local selectedBG
    local selectedValue
    local originalBodygroups = {}

    -- ================= FRAME =================
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    BGTraderFrame = frame

    frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, SysTime())
        draw.RoundedBox(0, 0, 0, w, h, Color(12, 14, 20, 245))
        draw.SimpleText("BODYGROUP SHOP", "OverpassLarge", w / 2, 28, color_white, TEXT_ALIGN_CENTER)
    end

    -- ================= CLOSE =================
    local close = vgui.Create("DButton", frame)
    close:SetSize(40, 40)
    close:SetPos(ScrW() - 60, 24)
    close:SetText("✕")
    close:SetFont("OverpassLarge")
    close:SetTextColor(color_white)
    close.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(120, 40, 40))
    end
    close.DoClick = function()
        for bgid, val in pairs(originalBodygroups) do
            ply:SetBodygroup(bgid, val)
        end
        frame:Remove()
    end

    -- ================= LEFT =================
    local left = vgui.Create("DScrollPanel", frame)
    left:SetWide(300)
    left:SetPos(30, 80)
    left:SetTall(ScrH() - 120)

    -- ================= RIGHT =================
    local right = vgui.Create("DScrollPanel", frame)
    right:SetWide(300)
    right:SetPos(ScrW() - 330, 80)
    right:SetTall(ScrH() - 120)

    -- ================= MODEL =================
    local model = vgui.Create("DModelPanel", frame)
    model:SetPos(350, 80)
    model:SetSize(ScrW() - 700, ScrH() - 200)
    model:SetModel(ply:GetModel())
    model:SetFOV(30)
    model.LayoutEntity = function(self, ent)
        ent:SetAngles(Angle(0, 45, 0))
    end

    local ent = model.Entity
    if not IsValid(ent) then return end

    -- Сохраняем оригинальные значения
    for _, bg in ipairs(ent:GetBodyGroups()) do
        originalBodygroups[bg.id] = ent:GetBodygroup(bg.id)
    end

    -- ================= BODYGROUP LIST =================
    for _, bg in ipairs(ent:GetBodyGroups()) do
        if bg.num <= 1 then continue end

        local btn = vgui.Create("DButton", left)
        btn:Dock(TOP)
        btn:SetTall(46)
        btn:DockMargin(0, 0, 0, 8)
        btn:SetText(bg.name)
        btn:SetFont("OverpassMedium")
        btn:SetTextColor(color_white)

        btn.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h,
                selectedBG == bg.id and ACCENT or Color(40, 45, 60))
        end

        btn.DoClick = function()
            -- откат предыдущей бодигрупы, если не куплено
            if selectedBG and selectedValue ~= nil then
                model.Entity:SetBodygroup(selectedBG, originalBodygroups[selectedBG])
            end

            selectedBG = bg.id
            selectedValue = nil
            right:Clear()

            -- опции текущей бодигрупы
            for v = 0, bg.num - 1 do
                local opt = vgui.Create("DButton", right)
                opt:Dock(TOP)
                opt:SetTall(42)
                opt:DockMargin(0, 0, 0, 6)
                opt:SetText("Вариант " .. v)
                opt:SetFont("OverpassSmall")
                opt:SetTextColor(color_white)

                opt.Paint = function(self, w, h)
                    draw.RoundedBox(6, 0, 0, w, h,
                        selectedValue == v and ACCENT or Color(35, 40, 55))
                end

                opt.DoClick = function()
                    selectedValue = v
                    model.Entity:SetBodygroup(bg.id, v)
                end
            end
        end
    end

    -- ================= BUY =================
    local buy = vgui.Create("DButton", frame)
    buy:SetSize(280, 56)
    buy:SetPos(ScrW() / 2 - 140, ScrH() - 90)
    buy:SetText("КУПИТЬ")
    buy:SetFont("OverpassMedium")
    buy:SetTextColor(color_white)

    buy.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h,
            (selectedBG and selectedValue ~= nil) and ACCENT or Color(70, 70, 70))
    end

    buy.DoClick = function()
        if not selectedBG or selectedValue == nil then return end
        originalBodygroups[selectedBG] = selectedValue

        net.Start("BGTrader.Buy")
            net.WriteUInt(selectedBG, 8)
            net.WriteUInt(selectedValue, 8)
        net.SendToServer()
    end
end)
