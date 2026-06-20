function swrp_f4menu.CreateDonatePanel(parent, w, h)
    local C   = swrp_f4menu.C
    local Mat = swrp_f4menu.Mat

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local boxW = math.min(580, w - 80)
    local boxX = math.floor((w - boxW) / 2)
    local curY = math.floor(h * 0.1)

    local title = vgui.Create("DLabel", panel)
    title:SetPos(boxX, curY)
    title:SetSize(boxW, 30)
    title:SetFont("swrp_f4_title")
    title:SetTextColor(C.text)
    title:SetText("Support the server")
    title:SetContentAlignment(5)

    curY = curY + 46

    local perks = {
        {label = "Custom callsign",       sub = "Set any callsign you want"},
        {label = "Donor rank",            sub = "Highlighted name in chat and roster"},
        {label = "Priority queue",        sub = "Skip the wait when the server is full"},
        {label = "Exclusive cosmetics",   sub = "Donor-only player models and trails"},
    }

    for _, perk in ipairs(perks) do
        local row = vgui.Create("DPanel", panel)
        row:SetPos(boxX, curY)
        row:SetSize(boxW, 58)
        row.Paint = function(_, rw, rh)
            swrp_f4menu.DrawCard(0, 0, rw, rh)
            -- Green accent stripe
            draw.RoundedBox(6, 0, 0, 3, rh, C.success)
        end

        local lbl1 = vgui.Create("DLabel", row)
        lbl1:SetPos(18, 12)
        lbl1:SetFont("swrp_f4_valSm")
        lbl1:SetTextColor(C.text)
        lbl1:SetText(perk.label)
        lbl1:SizeToContents()

        local lbl2 = vgui.Create("DLabel", row)
        lbl2:SetPos(18, 33)
        lbl2:SetFont("swrp_f4_small")
        lbl2:SetTextColor(C.textDim)
        lbl2:SetText(perk.sub)
        lbl2:SizeToContents()

        curY = curY + 68
    end

    curY = curY + 8

    local linkBtn = vgui.Create("DButton", panel)
    linkBtn:SetPos(boxX, curY)
    linkBtn:SetSize(boxW, 40)
    linkBtn:SetText("Visit the donation store")
    linkBtn:SetFont("swrp_f4_nav")
    linkBtn:SetTextColor(C.text)
    linkBtn:SetCursor("hand")
    linkBtn.Paint = function(s, bw, bh)
        local hov = s:IsHovered()
        draw.RoundedBox(6, 0, 0, bw, bh, hov and C.success or C.border)
        draw.RoundedBox(5, 1, 1, bw - 2, bh - 2, Color(12, 24, 18))
        surface.SetMaterial(Mat.grad)
        surface.SetDrawColor(C.success.r, C.success.g, C.success.b, hov and 60 or 28)
        surface.DrawTexturedRect(1, 1, bw - 2, bh - 2)
    end
    linkBtn.DoClick = function()
        -- Replace with actual store URL
        gui.OpenURL("https://example.com/donate")
    end

    return panel
end
