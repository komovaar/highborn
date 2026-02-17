if CLIENT then

local linkMenu

-- =========================
-- МЕНЮ ССЫЛОК (маленькое)
-- =========================
local function OpenLinkMenu()

    if IsValid(linkMenu) then return end

    gui.EnableScreenClicker(true)

    linkMenu = vgui.Create("DFrame")
    linkMenu:SetSize(260, 150)
    linkMenu:Center()
    linkMenu:SetTitle("")
    linkMenu:ShowCloseButton(false)
    linkMenu:SetDraggable(false)

    linkMenu.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(18,18,25,245))
        surface.SetDrawColor(80,140,220)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end


    local closeBtn = vgui.Create("DButton", linkMenu)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPos(linkMenu:GetWide() - 30, 6)
    closeBtn:SetText("")
    closeBtn.HoverAnim = 0

    closeBtn.Paint = function(self, w, h)
        self.HoverAnim = Lerp(FrameTime()*10, self.HoverAnim, self:IsHovered() and 1 or 0)

        local col = Color(120 + 80*self.HoverAnim, 50, 50)

        surface.SetDrawColor(col)
        surface.DrawLine(6, 6, w-6, h-6)
        surface.DrawLine(w-6, 6, 6, h-6)
    end

    closeBtn.DoClick = function()
        linkMenu:Remove()
        gui.EnableScreenClicker(false)
    end

    local links = {
        {name = "Discord", url = "https://discord.gg/yourserver"},
        {name = "Статут", url = "https://yourserver.com"}
    }

    local y = 40

    for _, data in ipairs(links) do
        local btn = vgui.Create("DButton", linkMenu)
        btn:SetSize(220, 32)
        btn:SetPos(20, y)
        btn:SetText("")
        btn.LabelText = data.name
        btn.HoverAnim = 0

        btn.Paint = function(self, w, h)
            self.HoverAnim = Lerp(FrameTime()*8, self.HoverAnim, self:IsHovered() and 1 or 0)

            local blue = 120 + (60 * self.HoverAnim)

            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))

            draw.SimpleText(self.LabelText, "HB_HUD_Small",
                w/2, h/2, color_white,
                TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn.DoClick = function()
            gui.OpenURL(data.url)
        end

        y = y + 38
    end

    linkMenu:MakePopup()
end

local function CloseLinkMenu()
    if IsValid(linkMenu) then
        linkMenu:Remove()
    end
    gui.EnableScreenClicker(false)
end

-- =========================
-- F1 (ShowHelp) → третье лицо
-- =========================
hook.Add("ShowHelp", "Thirdperson", function ()
    RunConsoleCommand("simple_thirdperson_enable_toggle")
    return true
end)

-- =========================
-- F2 (ShowTeam) → меню ссылок
-- =========================
hook.Add("ShowTeam", "F2Menu", function ()
    if IsValid(linkMenu) then
        CloseLinkMenu()
    else
        OpenLinkMenu()
    end
    return true
end)

end
