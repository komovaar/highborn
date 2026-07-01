if not CLIENT then return end

local contextMenu

local function CloseContextMenu()
    if IsValid(contextMenu) then
        contextMenu:Remove()
    end
end

local function AddAction(parent, title, subtitle, accent, onClick)
    local btn = vgui.Create("DButton", parent)
    btn:Dock(TOP)
    btn:DockMargin(0, 0, 0, 8)
    btn:SetTall(54)
    btn:SetText("")

    btn.Paint = function(self, w, h)
        local colors = HB_UI.Colors
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and colors.PanelHover or colors.Panel)
        surface.SetDrawColor(colors.Stroke)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        draw.RoundedBox(0, 0, 0, 3, h, accent)
        draw.SimpleText(title, "HB_UI_Main", 16, 9, colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(subtitle, "HB_UI_Tiny", 16, 33, colors.Muted, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    btn.DoClick = onClick
    return btn
end

local function OpenContextMenu()
    if not HB_UI then return end
    HB_UI.CreateFonts()
    CloseContextMenu()

    local colors = HB_UI.Colors
    local w = 360
    local h = 410

    contextMenu = vgui.Create("EditablePanel")
    contextMenu:SetSize(w, h)
    contextMenu:SetPos(ScrW() - w - 28, ScrH() / 2 - h / 2)
    contextMenu:MakePopup()
    contextMenu:SetKeyboardInputEnabled(false)

    contextMenu.Paint = function(self, pw, ph)
        DrawBlur(self)
        HB_UI.DrawPanel(0, 0, pw, ph, colors.Cyan)
        draw.SimpleText("C-МЕНЮ", "HB_UI_Title", 24, 20, colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Интерфейс сервера", "HB_UI_Tiny", 26, 58, colors.Muted, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local list = vgui.Create("DPanel", contextMenu)
    list:SetPos(24, 96)
    list:SetSize(w - 48, h - 120)
    list.Paint = function() end

    AddAction(list, "Профессии", "Открыть DarkRP меню", colors.Blue, function()
        if DarkRP and DarkRP.toggleF4Menu then
            DarkRP.toggleF4Menu()
        else
            RunConsoleCommand("say", "/jobs")
        end

        CloseContextMenu()
    end)

    AddAction(list, "Discord", "Открыть приглашение сервера", colors.Cyan, function()
        gui.OpenURL("https://discord.gg/2GJVAuBJbz")
    end)

    AddAction(list, "Статут", "Правила и структура Highborn", colors.Amber, function()
        gui.OpenURL("https://sites.google.com/view/highborn")
    end)

    AddAction(list, "Третье лицо", "Переключить камеру", colors.Green, function()
        RunConsoleCommand("simple_thirdperson_enable_toggle")
        CloseContextMenu()
    end)

    AddAction(list, "Скопировать SteamID", "Быстро для заявок и отчетов", colors.Red, function()
        SetClipboardText(LocalPlayer():SteamID())
    end)
end

hook.Add("OnContextMenuOpen", "HB_ContextMenu_Open", OpenContextMenu)
hook.Add("OnContextMenuClose", "HB_ContextMenu_Close", CloseContextMenu)
