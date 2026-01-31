include("shared.lua")

local MAIN_COLOR = Color(80,140,220)

net.Receive("WeaponTrader.Open", function()

    if IsValid(WeaponTraderMenu) then
        WeaponTraderMenu:Remove()
    end

    local selectedWeapon = nil

    WeaponTraderMenu = vgui.Create("DFrame")
    WeaponTraderMenu:SetSize(ScrW(), ScrH())
    WeaponTraderMenu:SetPos(0, 0)
    WeaponTraderMenu:SetTitle("")
    WeaponTraderMenu:ShowCloseButton(false)
    WeaponTraderMenu:SetDraggable(false)
    WeaponTraderMenu:MakePopup()

    WeaponTraderMenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 14, 22, 245))
        draw.SimpleText(
            "WEAPON TRADER",
            "DermaLarge",
            w / 2,
            25,
            MAIN_COLOR,
            TEXT_ALIGN_CENTER
        )
    end

    -- ❌ КНОПКА ЗАКРЫТИЯ
    local close = vgui.Create("DButton", WeaponTraderMenu)
    close:SetSize(40, 40)
    close:SetPos(ScrW() - 55, 15)
    close:SetText("✕")
    close:SetFont("DermaLarge")
    close:SetTextColor(color_white)
    close.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 40, 60))
    end
    close.DoClick = function()
        WeaponTraderMenu:Remove()
    end

    local list = vgui.Create("DScrollPanel", WeaponTraderMenu)
    list:SetSize(320, ScrH() - 120)
    list:SetPos(20, 80)

    local placeholder = vgui.Create("DPanel", WeaponTraderMenu)
    placeholder:SetSize(520, 520)
    placeholder:SetPos(ScrW() - 600, 120)
    placeholder.Paint = function(self, w, h)
        draw.RoundedBox(14, 0, 0, w, h, Color(15, 20, 30))
        draw.SimpleText("SELECT A WEAPON", "DermaLarge", w / 2, h / 2 - 10, MAIN_COLOR, TEXT_ALIGN_CENTER)
        draw.SimpleText("Choose from the list on the left", "DermaDefault", w / 2, h / 2 + 20, Color(180, 200, 220), TEXT_ALIGN_CENTER)
    end

    local modelPanel = vgui.Create("DModelPanel", WeaponTraderMenu)
    modelPanel:SetSize(520, 520)
    modelPanel:SetPos(ScrW() - 600, 120)
    modelPanel:SetVisible(false)
    modelPanel:SetCamPos(Vector(50, 50, 40))
    modelPanel:SetLookAt(Vector(0, 0, 0))
    modelPanel:SetFOV(35)
    modelPanel.LayoutEntity = function(self, ent)
        ent:SetAngles(Angle(0, CurTime() * 30 % 360, 0))
    end

    local stats = vgui.Create("DPanel", WeaponTraderMenu)
    stats:SetSize(520, 110)
    stats:SetPos(ScrW() - 600, 80)
    stats:SetVisible(false)
    stats.Paint = function(self, w, h)
        if not selectedWeapon then return end
        draw.RoundedBox(10, 0, 0, w, h, Color(15, 20, 30))
        draw.SimpleText(selectedWeapon.name, "DermaLarge", 20, 10, MAIN_COLOR)
        draw.SimpleText("Damage: " .. selectedWeapon.stats.damage, "DermaDefaultBold", 20, 55, color_white)
        draw.SimpleText("RPM: " .. selectedWeapon.stats.rpm, "DermaDefaultBold", 200, 55, color_white)
        draw.SimpleText("$" .. selectedWeapon.price, "DermaDefaultBold", w - 20, 55, MAIN_COLOR, TEXT_ALIGN_RIGHT)
    end

    local buy = vgui.Create("DButton", WeaponTraderMenu)
    buy:SetSize(520, 55)
    buy:SetPos(ScrW() - 600, ScrH() - 90)
    buy:SetText("PURCHASE")
    buy:SetFont("DermaLarge")
    buy:SetTextColor(Color(10, 10, 10))
    buy:SetVisible(false)
    buy.Paint = function(self, w, h)
        draw.RoundedBox(12, 0, 0, w, h, MAIN_COLOR)
    end
    buy.DoClick = function()
        if not selectedWeapon then return end
        net.Start("WeaponTrader.Buy")
        net.WriteString(selectedWeapon.class)
        net.SendToServer()
    end

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        local btn = list:Add("DButton")
        btn:SetTall(60)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 8)
        btn:SetText("")
        btn.hover = 0

        btn.Paint = function(self, w, h)
            self.hover = Lerp(FrameTime() * 10, self.hover, self:IsHovered() and 1 or 0)
            draw.RoundedBox(10, 0, 0, w, h,
                Color(
                    20 + self.hover * 20,
                    30 + self.hover * 40,
                    50 + self.hover * 80
                )
            )
            draw.SimpleText(wep.name, "DermaLarge", 15, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("$" .. wep.price, "DermaDefaultBold", w - 15, h / 2, MAIN_COLOR, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        btn.DoClick = function()
            selectedWeapon = wep
            placeholder:SetVisible(false)
            modelPanel:SetVisible(true)
            stats:SetVisible(true)
            buy:SetVisible(true)
            modelPanel:SetModel(wep.model)
        end
    end
end)
