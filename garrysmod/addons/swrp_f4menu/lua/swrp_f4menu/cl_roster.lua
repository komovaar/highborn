local rosterCache = {}

net.Receive("swrp_f4menu.RosterData", function()
    local count = net.ReadUInt(8)
    rosterCache = {}
    for _ = 1, count do
        table.insert(rosterCache, {
            nick     = net.ReadString(),
            steamid  = net.ReadString(),
            name     = net.ReadString(),
            callsign = net.ReadString(),
            job      = net.ReadString(),
            color    = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)),
            level    = net.ReadUInt(8),
        })
    end
    if swrp_f4menu._rosterRefresh then swrp_f4menu._rosterRefresh() end
end)

function swrp_f4menu.CreateRosterPanel(parent, w, h)
    local C   = swrp_f4menu.C
    local Mat = swrp_f4menu.Mat

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local PAD  = 18
    local list = nil  -- populated in build()

    local function build()
        if IsValid(list) then list:Remove() end

        list = vgui.Create("DScrollPanel", panel)
        list:SetPos(PAD, PAD)
        list:SetSize(w - PAD * 2, h - PAD * 2)
        local sb = list:GetVBar()
        sb:SetWide(4)
        sb:SetHideButtons(true)

        local canvas = list:GetCanvas()
        local rowH   = 52
        local curY   = 0

        for _, p in ipairs(rosterCache) do
            local row = vgui.Create("DPanel", canvas)
            row:SetPos(0, curY)
            row:SetSize(w - PAD * 2 - 6, rowH)

            local jobColor = p.color
            row.Paint = function(s, rw, rh)
                swrp_f4menu.DrawCard(0, 0, rw, rh)
                -- Job color stripe on left
                draw.RoundedBox(6, 0, 0, 4, rh, jobColor)
                draw.RoundedBox(5, 1, 0, 3, rh, jobColor)
            end

            -- Online dot
            local dot = vgui.Create("DPanel", row)
            dot:SetPos(18, (rowH - 8) / 2)
            dot:SetSize(8, 8)
            dot.Paint = function(_, dw, dh)
                draw.RoundedBox(4, 0, 0, dw, dh, C.success)
            end

            local nameLbl = vgui.Create("DLabel", row)
            nameLbl:SetPos(34, 11)
            nameLbl:SetFont("swrp_f4_nav")
            nameLbl:SetTextColor(C.text)
            nameLbl:SetText(p.nick)
            nameLbl:SizeToContents()

            local charLbl = vgui.Create("DLabel", row)
            charLbl:SetPos(34, 29)
            charLbl:SetFont("swrp_f4_small")
            charLbl:SetTextColor(C.textDim)
            charLbl:SetText(p.name ~= "" and (p.name .. (p.callsign ~= "" and " · " .. p.callsign or "")) or p.callsign)
            charLbl:SizeToContents()

            local jobLbl = vgui.Create("DLabel", row)
            jobLbl:SetSize(160, rowH)
            jobLbl:SetFont("swrp_f4_small")
            jobLbl:SetTextColor(C.textDim)
            jobLbl:SetText(p.job)
            jobLbl:SetContentAlignment(6)

            row.PerformLayout = function(s, rw2, _)
                jobLbl:SetPos(rw2 - 180, 0)
            end
            row:InvalidateLayout(true)

            curY = curY + rowH + 8
        end

        canvas:SetTall(math.max(curY, 1))
    end

    swrp_f4menu._rosterRefresh = build

    panel.OnShow = function()
        net.Start("swrp_f4menu.RequestRoster")
        net.SendToServer()
    end

    -- Show count label
    local countLbl = vgui.Create("DLabel", panel)
    countLbl:SetPos(PAD, h - PAD - 14)
    countLbl:SetFont("swrp_f4_label")
    countLbl:SetTextColor(C.textMut)
    countLbl:SetText("")

    -- Override refresh to also update count
    local origRefresh = swrp_f4menu._rosterRefresh
    swrp_f4menu._rosterRefresh = function()
        origRefresh()
        if IsValid(countLbl) then
            countLbl:SetText(string.format("%d ONLINE", #rosterCache))
            countLbl:SizeToContents()
        end
    end

    build()

    return panel
end
