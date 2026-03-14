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
        surface.CreateFont(name, {
            font = "Overpass",
            size = size,
            weight = weight,
            extended = true
        })
    end

    F("WT.Title", 42, 800)
    F("WT.List", 20, 600)
    F("WT.StatLabel", 24, 500)
    F("WT.Button", 26, 800)
    F("WT.Balance", 36, 500)

    surface.CreateFont("WT.Model", {
            font = "Overpass",
            size = 64,
            weight = 800,
            extended = true,
        })

    -- ======================================================
    -- UI
    -- ======================================================
    net.Receive("WeaponTrader.Open", function()

        local player_weapons = net.ReadTable(false)
        if not player_weapons then 
            player_weapons = {}
        end
        if IsValid(WeaponTraderMenu) then WeaponTraderMenu:Remove() end

        local selectedWeapon
        local selectedCategory = "weapon"

        -- ================= FRAME =================
        local frame = vgui.Create("DFrame")
        WeaponTraderMenu = frame
        frame:SetSize(ScrW(), ScrH())
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        frame:MakePopup()

        frame.Paint = function(self, w, h)
            DrawBlur(self)
            draw.RoundedBox(0, 0, 0, w, h, C.bg)

            draw.SimpleText("ЗБРОЯРНЯ", "WT.Title", 40, 30, C.accent)

            local money = LocalPlayer():getDarkRPVar("money") or 0
            draw.SimpleText("БАЛАНС", "WT.Balance", w - 220, 36, C.soft)
            draw.SimpleText("RC "..money, "WT.Balance", w - 220, 58, C.accent)
        end

        -- ================= CLOSE =================
        local close = vgui.Create("DButton", frame)
        close:SetSize(42, 42)
        close:SetPos(ScrW() - 60, 30)
        close:SetText("✕")
        close:SetFont("WT.List")
        close:SetTextColor(C.text)
        close.Paint = function(self, w, h)
            draw.RoundedBox(14, 0, 0, w, h, C.panel)
        end
        close.DoClick = function() frame:Remove() end

        -- ================= CATEGORY =================
        local cat = vgui.Create("DPanel", frame)
        cat:SetSize(360, 60)
        cat:SetPos(30, 110)
        cat.Paint = function(self, w, h)
            draw.RoundedBox(18, 0, 0, w, h, C.panel)
        end

        local function CatBtn(text, id, x)
            local b = vgui.Create("DButton", cat)
            b:SetSize(160, 44)
            b:SetPos(x, 8)
            b:SetText(text)
            b:SetFont("WT.List")
            b:SetTextColor(C.text)
            b.Paint = function(self, w, h)
                draw.RoundedBox(14, 0, 0, w, h,
                    selectedCategory == id and C.accent or C.card
                )
            end
            b.DoClick = function()
                selectedCategory = id
                selectedWeapon = nil
                PopulateList()
            end
        end

        CatBtn("ОЗБРОЄННЯ", "weapon", 10)
        CatBtn("СПОРЯДЖЕННЯ", "equipment", 190)

        -- ================= LEFT LIST =================
        local left = vgui.Create("DPanel", frame)
        left:SetSize(360, ScrH() - 190)
        left:SetPos(30, 180)
        left.Paint = function(self, w, h)
            draw.RoundedBox(18, 0, 0, w, h, C.panel)
        end

        local list = vgui.Create("DScrollPanel", left)
        list:SetSize(left:GetWide() - 24, left:GetTall() - 20)
        list:SetPos(12, 10)

        -- ================= MODEL =================
        local model = vgui.Create("DModelPanel", frame)
        model:SetPos(420, 110)
        model:SetSize(ScrW() - 460, ScrH() - 320)
        model:SetVisible(false)
        model:SetFOV(30)
        model:SetCamPos(Vector(110,110,80))
        model:SetLookAt(Vector(0,0,0))
        model.LayoutEntity = function(_, ent)
            ent:SetAngles(Angle(0, CurTime()*15 % 360, 0))
        end

        -- ================= STATS (BARS) =================
        local stats = vgui.Create("DPanel", frame)
        stats:SetSize(ScrW() - 460, 140)
        stats:SetPos(420, ScrH() - 100)
        stats:SetVisible(false)
        stats.Paint = function(self, w, h)
            if not selectedWeapon or not selectedWeapon.stats then return end

            local stats = {
                { name = "DAMAGE", value = selectedWeapon.stats.damage, max = 100 },
                { name = "RPM",    value = selectedWeapon.stats.rpm,    max = 1000 },
            }

            local barWidth  = 400
            local barHeight = 6
            local spacing   = 40

            for i, stat in ipairs(stats) do
                local y = (i - 1) * spacing
                local frac = math.Clamp(stat.value / stat.max, 0, 1)

                surface.SetDrawColor(80, 140, 220, 220)
                surface.DrawRect(
                    0,
                    y + 14,
                    barWidth * frac,
                    barHeight
                )

                surface.SetDrawColor(80, 140, 220, 40)
                surface.DrawRect(
                    0,
                    y + 13,
                    barWidth * frac,
                    barHeight + 2
                )

                draw.SimpleText(
                    stat.name,
                    "WT.StatLabel",
                    barWidth + 14,
                    y,
                    Color(210, 225, 255),
                    TEXT_ALIGN_LEFT
                )

                draw.SimpleText(
                    stat.value,
                    "WT.StatLabel",
                    barWidth + 14,
                    y + 18,
                    Color(150, 190, 255),
                    TEXT_ALIGN_LEFT
                )
            end
        end

        -- ================= BUY =================
            local buy = vgui.Create("DButton", frame)
            buy:SetSize(320, 64)
            buy:SetPos(ScrW() - 360, ScrH() - 100)
            buy:SetText("ПРИДБАТИ")
            buy:SetTextColor(Color(10,10,10))
            buy:SetFont("WT.Button")
            buy:SetVisible(false)
            buy.Paint = function(self, w, h)
                draw.RoundedBox(22, 0, 0, w, h, C.accent)
            end
            buy.DoClick = function()
                if not selectedWeapon then return end
                net.Start("WeaponTrader.Buy")
                    net.WriteString(selectedWeapon.class)
                net.SendToServer()
            end

        function PopulateList()
            list:Clear()
            model:SetVisible(false)
            stats:SetVisible(false)
            buy:SetVisible(false)

            for _, wep in ipairs(Vendor.Weapons) do
                if wep.category ~= selectedCategory then continue end
                    if wep.jobs ~= nil then
                        local plyJob = LocalPlayer():Team()
                        local allowed = false

                        for _, job in ipairs(wep.jobs) do
                            if job == plyJob then
                                allowed = true
                                break
                            end
                        end

                        if not allowed then continue end
                    end
                
                local b = list:Add("DButton")
                b:SetTall(60)
                b:Dock(TOP)
                b:DockMargin(0,0,0,10)
                b:SetText("")
                b.Paint = function(self, w, h)
                    local bg = C.card

                    if wep.vip then
                        bg = Color(200,170,60,230)
                    end

                    draw.RoundedBox(14, 0, 0, w, h, bg)

                    draw.SimpleText(wep.name, "WT.List", 16, h/2, C.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText("RC "..wep.price, "WT.List", w-16, h/2, C.accent, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                end
                b.DoClick = function()
                    selectedWeapon = wep
                    model:SetModel(wep.model)
                    model:SetVisible(true)
                    stats:SetVisible(true)
                    buy:SetVisible(true)
                    for _, row in ipairs(player_weapons) do
                        if row.weapon == selectedWeapon.class then
                            if tonumber(row.stored) == 1 then
                                buy:SetText("ВЗЯТИ З АРСЕНАЛУ")
                            else
                                buy:SetText("ПОКЛАСТИ В АРСЕНАЛ")
                            end
                            buy.DoClick = function()
                            net.Start("WeaponTrader.ToggleStorage")
                                net.WriteString(selectedWeapon.class)
                            net.SendToServer()

                            for _, row in ipairs(player_weapons) do
                                if row.weapon == selectedWeapon.class then
                                    row.stored = tonumber(row.stored) == 1 and 0 or 1

                                    if tonumber(row.stored) == 1 then
                                        buy:SetText("ВЗЯТИ З АРСЕНАЛУ")
                                    else
                                        buy:SetText("ПОКЛАСТИ В АРСЕНАЛ")
                                    end

                                    break
                                end
                            end
                        end

                            return
                        end
                    end

                    buy:SetText("ПРИДБАТИ")
                    buy.DoClick = function()
                        net.Start("WeaponTrader.Buy")
                            net.WriteString(selectedWeapon.class)
                        net.SendToServer()
                    end
                end
            end
        end

        PopulateList()
    end)

    function ENT:Draw()
        self:DrawModel()

        local pos = self:GetPos() 
            + self:GetUp() * 50   
            + self:GetForward() * 10

        local ang = self:GetAngles()

        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D(pos, ang, 0.08)


            draw.SimpleText(
                "ЗБРОЯРНЯ",
                "WT.Model",
                0,
                0,
                C.accent,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

        cam.End3D2D()
    end
