local charCache   = {}
local activeCharID = ""

net.Receive("swrp_f4menu.CharacterList", function()
    activeCharID = net.ReadString()
    local count  = net.ReadUInt(8)
    charCache    = {}
    for _ = 1, count do
        table.insert(charCache, {
            id       = net.ReadString(),
            name     = net.ReadString(),
            callsign = net.ReadString(),
            job      = net.ReadString(),
            model    = net.ReadString(),
        })
    end
    if swrp_f4menu._charsRefresh then swrp_f4menu._charsRefresh() end
end)

function swrp_f4menu.CreateCharactersPanel(parent, w, h)
    local C   = swrp_f4menu.C
    local Mat = swrp_f4menu.Mat

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local PAD   = 18
    local cardW = 220
    local cardH = 310
    local grid  = nil

    local function build()
        if IsValid(grid) then grid:Remove() end

        grid = vgui.Create("DPanel", panel)
        grid:SetPos(PAD, PAD)
        grid:SetSize(w - PAD * 2, h - PAD * 2)
        grid.Paint = function() end

        local maxSlots = math.max(prop.config.maxCharacters or 1, #charCache)
        local curX     = 0

        for i = 1, maxSlots do
            local char    = charCache[i]
            local isActive = char and (char.id == activeCharID)

            local slot = vgui.Create("DPanel", grid)
            slot:SetPos(curX, 0)
            slot:SetSize(cardW, cardH)

            if char then
                slot.Paint = function(_, cw, ch)
                    if isActive then
                        swrp_f4menu.DrawGradCard(0, 0, cw, ch, 8, 45)
                        -- Accent top edge
                        surface.SetDrawColor(C.accent)
                        surface.DrawRect(8, 0, cw - 16, 2)
                    else
                        swrp_f4menu.DrawCard(0, 0, cw, ch, 8)
                    end
                end

                -- Mini model panel
                local mdl = vgui.Create("DModelPanel", slot)
                mdl:SetPos(0, 0)
                mdl:SetSize(cardW, 200)
                mdl:SetModel(char.model)
                mdl:SetAmbientLight(Color(28, 52, 92))
                mdl:SetDirectionalLight(BOX_FRONT, Color(70, 120, 200))
                mdl:SetDirectionalLight(BOX_TOP,   Color(45, 80, 155))
                function mdl:LayoutEntity(ent)
                    ent:SetAngles(Angle(0, RealTime() * 18, 0))
                    if not self._c then
                        self._c = true
                        local mn, mx = ent:GetModelBounds()
                        local ctr  = (mn + mx) * 0.5
                        local dist = (mx - mn):Length() * 1.05
                        self:SetCamPos(ctr + Vector(dist, 0, 0))
                        self:SetLookAt(ctr)
                    end
                end

                local nameLbl = vgui.Create("DLabel", slot)
                nameLbl:SetPos(12, 208)
                nameLbl:SetSize(cardW - 24, 22)
                nameLbl:SetFont("swrp_f4_nav")
                nameLbl:SetTextColor(C.text)
                nameLbl:SetText(char.name)
                nameLbl:SetContentAlignment(5)

                local jobLbl = vgui.Create("DLabel", slot)
                jobLbl:SetPos(12, 228)
                jobLbl:SetSize(cardW - 24, 18)
                jobLbl:SetFont("swrp_f4_small")
                jobLbl:SetTextColor(C.textDim)
                jobLbl:SetText(char.job)
                jobLbl:SetContentAlignment(5)

                if isActive then
                    local badge = vgui.Create("DPanel", slot)
                    badge:SetPos(math.floor((cardW - 80) / 2), 256)
                    badge:SetSize(80, 22)
                    badge.Paint = function(_, bw, bh)
                        draw.RoundedBox(4, 0, 0, bw, bh, Color(10, 24, 44))
                        surface.SetDrawColor(C.accent)
                        surface.DrawOutlinedRect(0, 0, bw, bh, 1)
                    end
                    local badgeLbl = vgui.Create("DLabel", badge)
                    badgeLbl:SetPos(0, 0)
                    badgeLbl:SetSize(80, 22)
                    badgeLbl:SetFont("swrp_f4_label")
                    badgeLbl:SetTextColor(C.accent)
                    badgeLbl:SetText("ACTIVE")
                    badgeLbl:SetContentAlignment(5)
                else
                    local switchBtn = vgui.Create("DButton", slot)
                    switchBtn:SetPos(12, 254)
                    switchBtn:SetSize(cardW - 24, 28)
                    switchBtn:SetText("Switch")
                    switchBtn:SetFont("swrp_f4_label")
                    switchBtn:SetTextColor(C.textDim)
                    switchBtn:SetCursor("hand")
                    switchBtn.Paint = function(s, bw, bh)
                        local hov = s:IsHovered()
                        draw.RoundedBox(5, 0, 0, bw, bh, hov and C.border or Color(14, 18, 28))
                        s:SetTextColor(hov and C.text or C.textDim)
                    end
                    local cid = char.id
                    switchBtn.DoClick = function()
                        net.Start("swrp_f4menu.SwitchCharacter")
                            net.WriteString(cid)
                        net.SendToServer()
                        swrp_f4menu.Close()
                    end
                end
            else
                -- Empty slot
                slot.Paint = function(_, cw, ch)
                    draw.RoundedBox(8, 0, 0, cw, ch, C.border)
                    draw.RoundedBox(7, 1, 1, cw - 2, ch - 2, C.card)
                    -- Dashed feel via 4 corner marks
                    surface.SetDrawColor(C.textMut)
                    surface.DrawRect(8, 8, 20, 1)
                    surface.DrawRect(8, 8, 1, 20)
                    surface.DrawRect(cw - 28, 8, 20, 1)
                    surface.DrawRect(cw - 9, 8, 1, 20)
                    surface.DrawRect(8, ch - 9, 20, 1)
                    surface.DrawRect(8, ch - 28, 1, 20)
                    surface.DrawRect(cw - 28, ch - 9, 20, 1)
                    surface.DrawRect(cw - 9, ch - 28, 1, 20)
                end

                local emptyLbl = vgui.Create("DLabel", slot)
                emptyLbl:SetPos(0, math.floor(cardH / 2) - 8)
                emptyLbl:SetSize(cardW, 16)
                emptyLbl:SetFont("swrp_f4_small")
                emptyLbl:SetTextColor(C.textMut)
                emptyLbl:SetText("Empty slot")
                emptyLbl:SetContentAlignment(5)
            end

            curX = curX + cardW + 16
        end
    end

    swrp_f4menu._charsRefresh = build

    panel.OnShow = function()
        net.Start("swrp_f4menu.RequestCharacters")
        net.SendToServer()
    end

    build()

    return panel
end
