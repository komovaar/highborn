include("shared.lua")

local blur = Material("pp/blurscreen")
local mainColor = WeaponTraderConfig.MainColor

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetMaterial(blur)
    surface.SetDrawColor(255,255,255)

    for i = 1, 4 do
        blur:SetFloat("$blur", i * amount)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end

net.Receive("WeaponTrader.Open", function()
    if IsValid(WeaponTraderMenu) then WeaponTraderMenu:Remove() end

    WeaponTraderMenu = vgui.Create("DFrame")
    WeaponTraderMenu:SetSize(560, 420)
    WeaponTraderMenu:Center()
    WeaponTraderMenu:SetTitle("")   
    WeaponTraderMenu:MakePopup()
    WeaponTraderMenu:ShowCloseButton(false)

    WeaponTraderMenu.Paint = function(self, w, h)
        DrawBlur(self, 6)

        draw.RoundedBox(0, 0, 0, w, h, Color(10, 14, 20, 240))

        -- рамка в стиле holo-панели
        surface.SetDrawColor(mainColor)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("IMPERIAL ARMORY", "DermaLarge", 24, 18, mainColor)
        draw.SimpleText("Authorized Personnel Only", "DermaDefault", 26, 48, Color(160,180,210))
    end

    -- кнопка закрытия
    local close = vgui.Create("DButton", WeaponTraderMenu)
    close:SetSize(34, 34)
    close:SetPos(520, 16)
    close:SetText("✕")
    close:SetFont("DermaLarge")
    close:SetTextColor(mainColor)
    close.Paint = function() end
    close.DoClick = function()
        WeaponTraderMenu:Remove()
    end

    -- список
    local scroll = vgui.Create("DScrollPanel", WeaponTraderMenu)
    scroll:SetPos(20, 80)
    scroll:SetSize(520, 320)

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        local item = scroll:Add("DPanel")
        item:SetTall(70)
        item:Dock(TOP)
        item:DockMargin(0, 0, 0, 10)

        item.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(18, 26, 38, 230))

            surface.SetDrawColor(mainColor)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(wep.name, "DermaLarge", 18, 10, color_white)
            draw.SimpleText(
                DarkRP.formatMoney(wep.price),
                "DermaDefaultBold",
                20,
                42,
                mainColor
            )
        end

        local buy = vgui.Create("DButton", item)
        buy:SetSize(120, 40)
        buy:SetPos(380, 15)
        buy:SetText("ACQUIRE")
        buy:SetFont("DermaDefaultBold")
        buy:SetTextColor(Color(10,10,10))

        buy.Paint = function(self, w, h)
            local col = self:IsHovered()
                and Color(mainColor.r + 20, mainColor.g + 20, mainColor.b + 20)
                or mainColor

            draw.RoundedBox(8, 0, 0, w, h, col)
        end

        buy.DoClick = function()
            net.Start("WeaponTrader.Buy")
                net.WriteString(wep.class)
            net.SendToServer()
        end
    end
end)
