if CLIENT then

local linkMenu

 local musicSound
    local Volume = GetConVar("gmmp_volume") or CreateClientConVar("gmmp_volume", "50", true, false)

    local function PlayMusic(url)
        if IsValid(musicSound) then
            musicSound:Stop()
        end
        sound.PlayFile(url, "noplay", function(station)
            if IsValid(station) then
                station:Play()
                station:SetVolume(Volume:GetFloat() / 100)
                musicSound = station
            end
        end)
    end

    local function OpenLinkMenu()
        if IsValid(linkMenu) then return end

        gui.EnableScreenClicker(true)
        linkMenu = vgui.Create("DFrame")
        linkMenu:SetSize(260, 230)
        linkMenu:Center()
        linkMenu:SetTitle("")
        linkMenu:ShowCloseButton(false)
        linkMenu:SetDraggable(false)

        linkMenu.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(18,18,25,245))
            surface.SetDrawColor(80,140,220)
            surface.DrawOutlinedRect(0,0,w,h,1)
        end

        -- Закрытие
        local closeBtn = vgui.Create("DButton", linkMenu)
        closeBtn:SetSize(24, 24)
        closeBtn:SetPos(linkMenu:GetWide() - 30, 6)
        closeBtn:SetText("")
        closeBtn.Paint = function(self, w, h)
            local col = Color(200, 50, 50)
            surface.SetDrawColor(col)
            surface.DrawLine(6, 6, w-6, h-6)
            surface.DrawLine(w-6, 6, 6, h-6)
        end
        closeBtn.DoClick = function()
            linkMenu:Remove()
            gui.EnableScreenClicker(false)
        end

        local links = {
            {name = "Discord", url = "https://discord.gg/2GJVAuBJbz"},
            {name = "Статут", url = "https://sites.google.com/view/highborn"},
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
                draw.RoundedBox(4, 0, 0, w, h, Color(20 + 15*self.HoverAnim, 20 + 15*self.HoverAnim, 20 + 15*self.HoverAnim, 200))
                draw.SimpleText(self.LabelText, "HB_HUD_Small", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            btn.DoClick = function()
                if data.name == "Музыка" then
                    PlayMusic(data.url)
                else
                    gui.OpenURL(data.url)
                end
            end
            y = y + 38
        end

        local sldVolume = vgui.Create("DNumSlider", linkMenu)
        sldVolume:SetPos(20, y)
        sldVolume:SetSize(220, 40)
        sldVolume:SetText("")
        sldVolume:SetMin(0)
        sldVolume:SetMax(100)
        sldVolume:SetDecimals(0)
        sldVolume:SetConVar("gmmp_volume")

        sldVolume.Label:SetVisible(false)
        sldVolume.TextArea:SetVisible(false)
        sldVolume.Slider:SetVisible(false)

        sldVolume.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, h/2-5, w, 10, Color(30,30,35,200))
            local fill = (self:GetValue()/self:GetMax())*w
            draw.RoundedBox(4, 0, h/2-5, fill, 10, Color(80,140,220,200))
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(fill-5, h/2-7, 10, 14)
        end

        sldVolume.OnMousePressed = function(self, mc)
            self.Dragging = true
        end

        sldVolume.OnMouseReleased = function(self, mc)
            self.Dragging = false
        end

        sldVolume.Think = function(self)
            if self.Dragging and input.IsMouseDown(MOUSE_LEFT) then
                local mx = math.Clamp(gui.MouseX() - self:LocalToScreen(0,0), 0, self:GetWide())
                local val = (mx / self:GetWide()) * self:GetMax()
                self:SetValue(val)
                if IsValid(musicSound) then
                    musicSound:SetVolume(val / 100)
                end
            end
        end

        if Volume:GetFloat() == Volume:GetInt() then
            sldVolume:SetValue(Volume:GetInt())
        else
            sldVolume:SetValue(math.Round(Volume:GetFloat()))
        end

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
