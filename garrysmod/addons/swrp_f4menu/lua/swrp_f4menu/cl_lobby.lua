function swrp_f4menu.CreateLobbyPanel(parent, w, h)
    local C = swrp_f4menu.C

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local RPANEL_W = 210

    -- ── CENTER AREA ──────────────────────────────────────────────────────────
    local cw = w - RPANEL_W
    local center = vgui.Create("DPanel", panel)
    center:SetPos(0, 0)
    center:SetSize(cw, h)
    center.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)

        local gcx = math.floor(pw / 2)
        local gcy = math.floor(ph * 0.45)

        -- Atmospheric radial glow
        swrp_f4menu.DrawGlow(gcx, gcy, math.floor(math.min(pw, ph) * 0.55), C.accent, 75)

        -- Hexagonal platform on the floor
        local floorY = gcy + math.floor(ph * 0.27)
        local pr     = math.floor(ph * 0.19)
        local pts    = {}
        for i = 0, 5 do
            local a = math.rad(60 * i + 30)
            pts[i+1] = {
                x = gcx + pr * math.cos(a),
                y = floorY + pr * 0.28 * math.sin(a),  -- squish for perspective
            }
        end
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 35)
        for i = 1, 6 do
            surface.DrawLine(pts[i].x, pts[i].y, pts[i % 6 + 1].x, pts[i % 6 + 1].y)
        end

        -- Elliptical floor glow under feet
        for j = 6, 1, -1 do
            local fw = math.floor(pr * 1.6 * j / 6)
            local fh = math.floor(18 * j / 6)
            local fa = math.floor(50 * (7 - j) / 6)
            draw.RoundedBox(fh,
                gcx - fw, floorY - math.floor(fh / 2),
                fw * 2,   fh,
                Color(C.accent.r, C.accent.g, C.accent.b, fa))
        end
    end

    -- ── CHARACTER MODEL ──────────────────────────────────────────────────────
    local modelH = math.floor(h * 0.68)
    local modelW = math.floor(cw * 0.5)
    local modelX = math.floor((cw - modelW) / 2)
    local modelY = math.floor(h * 0.04)

    local mdl = vgui.Create("DModelPanel", center)
    mdl:SetPos(modelX, modelY)
    mdl:SetSize(modelW, modelH)
    mdl:SetModel(LocalPlayer():GetModel())
    mdl:SetAmbientLight(Color(8, 22, 44))
    mdl:SetDirectionalLight(BOX_FRONT, Color(160, 200, 255))
    mdl:SetDirectionalLight(BOX_TOP,   Color(60,  120, 210))
    mdl:SetDirectionalLight(BOX_BACK,  Color(4,   14,  36))
    mdl:SetDirectionalLight(BOX_LEFT,  Color(20,  60,  140))

    function mdl:LayoutEntity(ent)
        ent:SetAngles(Angle(0, RealTime() * 14, 0))
        if not self._ready then
            self._ready = true
            local mn, mx = ent:GetModelBounds()
            local ctr  = (mn + mx) * 0.5
            local dist = (mx - mn):Length() * 1.0
            self:SetCamPos(ctr + Vector(dist, 0, 0))
            self:SetLookAt(ctr)
        end
    end

    -- ── NAME / CLASS ─────────────────────────────────────────────────────────
    local infoY = modelY + modelH + 10

    local jobLbl = vgui.Create("DLabel", center)
    jobLbl:SetPos(0, infoY)
    jobLbl:SetSize(cw, 28)
    jobLbl:SetFont("swrp_f4_hero")
    jobLbl:SetTextColor(C.text)
    jobLbl:SetText(string.upper(prop.data.localGet("character_job_name", "ШТУРМОВИК")))
    jobLbl:SetContentAlignment(5)

    local subLbl = vgui.Create("DLabel", center)
    subLbl:SetPos(0, infoY + 30)
    subLbl:SetSize(cw, 16)
    subLbl:SetFont("swrp_f4_sub")
    subLbl:SetTextColor(C.textDim)
    subLbl:SetText(string.upper(prop.data.localGet("character_name", "")))
    subLbl:SetContentAlignment(5)

    -- ── DEPLOY BUTTON ────────────────────────────────────────────────────────
    local btnW = math.floor(cw * 0.40)
    local btnH = 46
    local btnX = math.floor((cw - btnW) / 2)
    local btnY = infoY + 62

    local deployBtn = vgui.Create("DButton", center)
    deployBtn:SetPos(btnX, btnY)
    deployBtn:SetSize(btnW, btnH)
    deployBtn:SetText("")
    deployBtn:SetCursor("hand")

    deployBtn.Paint = function(s, bw, bh)
        local hov = s:IsHovered()
        local base = hov and Color(38, 110, 195) or C.button

        -- Angled left side (cut top-left corner)
        local cut = 12
        surface.SetDrawColor(base)
        surface.DrawPoly({
            {x = cut, y = 0},
            {x = bw,  y = 0},
            {x = bw,  y = bh},
            {x = 0,   y = bh},
        })

        -- Border lines
        local bc = hov and C.bright or C.accent
        local ba = hov and 160 or 90
        surface.SetDrawColor(bc.r, bc.g, bc.b, ba)
        surface.DrawLine(cut, 0, bw, 0)
        surface.DrawLine(bw - 1, 0, bw - 1, bh)
        surface.DrawLine(0, bh - 1, bw, bh - 1)
        surface.DrawLine(0, bh - 1, cut, 0)

        draw.SimpleText("РАЗВЕРНУТЬСЯ", "swrp_f4_nav",
            math.floor(bw / 2) + 6, math.floor(bh / 2),
            C.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        -- Enter key hint
        local kx = bw - 34
        local ky = math.floor((bh - 16) / 2)
        draw.RoundedBox(2, kx, ky, 22, 16,
            Color(C.bright.r, C.bright.g, C.bright.b, hov and 60 or 35))
        draw.SimpleText("↵", "swrp_f4_small", kx + 11, ky + 8,
            C.bright, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    deployBtn.DoClick = function()
        swrp_f4menu.Close()
    end

    -- ── RIGHT PANEL ───────────────────────────────────────────────────────────
    local rp = vgui.Create("DPanel", panel)
    rp:SetPos(cw, 0)
    rp:SetSize(RPANEL_W, h)
    rp.Paint = function(_, rw, rh)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, rw, rh)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, 0, 1, rh)
    end

    -- Squad header
    local sqH = vgui.Create("DPanel", rp)
    sqH:SetPos(0, 0)
    sqH:SetSize(RPANEL_W, 40)
    sqH.Paint = function(_, rw, rh)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, rh - 1, rw, 1)
        draw.SimpleText("◀  ОТРЯД", "swrp_f4_label",
            14, math.floor(rh / 2), C.bright, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local cnt = #player.GetAll()
        local max = game.MaxPlayers()
        draw.SimpleText(cnt .. " / " .. max, "swrp_f4_mono",
            rw - 12, math.floor(rh / 2), C.textDim, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    -- Local player row
    local lp  = LocalPlayer()
    local row = vgui.Create("DPanel", rp)
    row:SetPos(0, 40)
    row:SetSize(RPANEL_W, 54)
    row.Paint = function(_, rw, rh)
        -- Highlighted (it's us)
        surface.SetDrawColor(C.sbAct.r, C.sbAct.g, C.sbAct.b, 40)
        surface.DrawRect(0, 0, rw, rh)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, rh - 1, rw, 1)
        -- Online dot
        draw.RoundedBox(4, 10, math.floor((rh - 8) / 2), 8, 8, C.success)
    end

    local av = vgui.Create("AvatarImage", row)
    av:SetSize(28, 28)
    av:SetPos(26, math.floor((54 - 28) / 2))
    av:SetPlayer(lp, 32)

    local nickLbl = vgui.Create("DLabel", row)
    nickLbl:SetPos(62, 12)
    nickLbl:SetFont("swrp_f4_small")
    nickLbl:SetTextColor(C.text)
    nickLbl:SetText(lp:Nick())
    nickLbl:SizeToContents()

    local statusLbl = vgui.Create("DLabel", row)
    statusLbl:SetPos(62, 28)
    statusLbl:SetFont("swrp_f4_label")
    statusLbl:SetTextColor(C.textDim)
    statusLbl:SetText(string.upper(prop.data.localGet("character_job_name", "...")))
    statusLbl:SizeToContents()

    -- Other players list
    local scroll = vgui.Create("DScrollPanel", rp)
    scroll:SetPos(0, 94)
    scroll:SetSize(RPANEL_W, h - 94)
    scroll:GetVBar():SetWide(4)

    local function rebuildList()
        scroll:Clear()
        local curY = 0
        for _, ply in ipairs(player.GetAll()) do
            if ply == lp then continue end

            local prow = vgui.Create("DPanel", scroll)
            prow:SetPos(0, curY)
            prow:SetSize(RPANEL_W, 48)
            prow.Paint = function(_, rw, rh)
                surface.SetDrawColor(C.border)
                surface.DrawRect(0, rh - 1, rw, 1)
                draw.RoundedBox(4, 10, math.floor((rh - 8) / 2), 8, 8, C.success)
            end

            local pav = vgui.Create("AvatarImage", prow)
            pav:SetSize(24, 24)
            pav:SetPos(26, math.floor((48 - 24) / 2))
            pav:SetPlayer(ply, 32)

            local pnick = vgui.Create("DLabel", prow)
            pnick:SetPos(58, 10)
            pnick:SetFont("swrp_f4_small")
            pnick:SetTextColor(C.text)
            pnick:SetText(ply:Nick())
            pnick:SizeToContents()

            local pjob = vgui.Create("DLabel", prow)
            pjob:SetPos(58, 26)
            pjob:SetFont("swrp_f4_label")
            pjob:SetTextColor(C.textDim)
            pjob:SetText(tostring(ply:Team()))
            pjob:SizeToContents()

            curY = curY + 48
        end
        scroll:SetTall(math.max(curY, h - 94))
    end

    panel.OnShow = function()
        rebuildList()
        -- Refresh job/name labels live
        jobLbl:SetText(string.upper(prop.data.localGet("character_job_name", "ШТУРМОВИК")))
        subLbl:SetText(string.upper(prop.data.localGet("character_name", "")))
        statusLbl:SetText(string.upper(prop.data.localGet("character_job_name", "...")))
        mdl:SetModel(lp:GetModel())
        mdl._ready = nil
    end

    return panel
end
