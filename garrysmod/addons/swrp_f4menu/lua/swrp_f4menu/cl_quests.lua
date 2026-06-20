function swrp_f4menu.CreateQuestsPanel(parent, w, h)
    local C   = swrp_f4menu.C
    local Mat = swrp_f4menu.Mat

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local boxW = 400
    local boxX = math.floor((w - boxW) / 2)
    local boxY = math.floor(h * 0.3)

    local placeholder = vgui.Create("DPanel", panel)
    placeholder:SetPos(boxX, boxY)
    placeholder:SetSize(boxW, 130)
    placeholder.Paint = function(_, bw, bh)
        swrp_f4menu.DrawCard(0, 0, bw, bh, 8)
        surface.SetMaterial(Mat.grad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 20)
        surface.DrawTexturedRect(1, 1, bw - 2, bh - 2)
    end

    local t1 = vgui.Create("DLabel", placeholder)
    t1:SetPos(0, 34)
    t1:SetSize(boxW, 26)
    t1:SetFont("swrp_f4_valSm")
    t1:SetTextColor(C.text)
    t1:SetText("Quests coming soon")
    t1:SetContentAlignment(5)

    local t2 = vgui.Create("DLabel", placeholder)
    t2:SetPos(0, 68)
    t2:SetSize(boxW, 18)
    t2:SetFont("swrp_f4_small")
    t2:SetTextColor(C.textDim)
    t2:SetText("Mission objectives and rewards will appear here.")
    t2:SetContentAlignment(5)

    return panel
end
