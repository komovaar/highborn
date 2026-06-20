function swrp_f4menu.CreateCallAdminPanel(parent, w, h)
    local C   = swrp_f4menu.C
    local Mat = swrp_f4menu.Mat

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local boxW = math.min(560, w - 80)
    local boxX = math.floor((w - boxW) / 2)
    local curY = math.floor(h * 0.15)

    -- Header
    local title = vgui.Create("DLabel", panel)
    title:SetPos(boxX, curY)
    title:SetSize(boxW, 28)
    title:SetFont("swrp_f4_title")
    title:SetTextColor(C.text)
    title:SetText("Request admin assistance")
    title:SetContentAlignment(4)

    curY = curY + 38

    local sub = vgui.Create("DLabel", panel)
    sub:SetPos(boxX, curY)
    sub:SetSize(boxW, 18)
    sub:SetFont("swrp_f4_small")
    sub:SetTextColor(C.textDim)
    sub:SetText("Describe your issue. All online admins will be notified.")
    sub:SetContentAlignment(4)

    curY = curY + 34

    -- Reason input
    local inputBox = vgui.Create("DPanel", panel)
    inputBox:SetPos(boxX, curY)
    inputBox:SetSize(boxW, 110)
    inputBox.Paint = function(_, bw, bh)
        draw.RoundedBox(6, 0, 0, bw, bh, C.border)
        draw.RoundedBox(5, 1, 1, bw - 2, bh - 2, C.card)
    end

    local entry = vgui.Create("DTextEntry", inputBox)
    entry:SetPos(10, 8)
    entry:SetSize(boxW - 20, 94)
    entry:SetMultiline(true)
    entry:SetFont("swrp_f4_small")
    entry:SetTextColor(C.text)
    entry:SetCursorColor(C.accent)
    entry:SetPaintBackground(false)
    entry:SetPlaceholderText("Describe the issue...")
    entry:SetPlaceholderColor(C.textMut)
    entry:SetMaximumCharCount(256)

    curY = curY + 120

    -- Send button
    local sendBtn = vgui.Create("DButton", panel)
    sendBtn:SetPos(boxX, curY)
    sendBtn:SetSize(boxW, 38)
    sendBtn:SetText("Send to admins")
    sendBtn:SetFont("swrp_f4_nav")
    sendBtn:SetTextColor(C.text)
    sendBtn:SetCursor("hand")
    sendBtn.Paint = function(s, bw, bh)
        local hov = s:IsHovered()
        draw.RoundedBox(6, 0, 0, bw, bh, hov and C.accent or C.border)
        draw.RoundedBox(5, 1, 1, bw - 2, bh - 2, hov and Color(20, 50, 95) or Color(14, 20, 32))
        surface.SetMaterial(Mat.grad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, hov and 55 or 30)
        surface.DrawTexturedRect(1, 1, bw - 2, bh - 2)
    end

    local cooldown = false

    sendBtn.DoClick = function()
        if cooldown then return end

        local reason = string.Trim(entry:GetValue())
        if reason == "" then return end

        net.Start("swrp_f4menu.CallAdmin")
            net.WriteString(reason)
        net.SendToServer()

        entry:SetValue("")
        cooldown = true
        sendBtn:SetText("Sent!")
        sendBtn:SetTextColor(C.success)

        timer.Simple(10, function()
            if IsValid(sendBtn) then
                sendBtn:SetText("Send to admins")
                sendBtn:SetTextColor(C.text)
                cooldown = false
            end
        end)
    end

    return panel
end
