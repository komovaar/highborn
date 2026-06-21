function swrp_f4menu.CreateLobbyPanel(parent, w, h)
    local C = swrp_f4menu.C

    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local RPANEL_W = 280
    local cw       = w - RPANEL_W

    -- Center of the glow (fixed in layout coords)
    local gcx = math.floor(cw / 2)
    local gcy = math.floor(h * 0.42)

    -- ── CENTER ─────────────────────────────────────────────────────────────
    local center = vgui.Create("DPanel", panel)
    center:SetPos(0, 0)
    center:SetSize(cw, h)
    center.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)

        -- Wide background glow (fills most of the bg with subtle blue)
        local bigR = math.floor(math.max(pw, ph) * 0.8)
        for i = 16, 1, -1 do
            local t = i / 16
            local r = math.floor(bigR * t)
            local a = math.floor(30 * (1 - t))
            draw.RoundedBox(r, gcx - r, gcy - r, r * 2, r * 2,
                Color(C.accent.r, C.accent.g, C.accent.b, a))
        end

        -- Tight center glow (brighter core)
        local coreR = math.floor(math.min(pw, ph) * 0.38)
        for i = 10, 1, -1 do
            local t = i / 10
            local r = math.floor(coreR * t)
            local a = math.floor(70 * (1 - t))
            draw.RoundedBox(r, gcx - r, gcy - r, r * 2, r * 2,
                Color(C.accent.r, C.accent.g, C.accent.b, a))
        end

        -- Hex floor outline
        local floorY = gcy + math.floor(h * 0.28)
        local pr     = math.floor(h * 0.21)
        local pts    = {}
        for i = 0, 5 do
            local a = math.rad(60 * i + 30)
            pts[i + 1] = {
                x = gcx + pr * math.cos(a),
                y = floorY + pr * 0.28 * math.sin(a),
            }
        end
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 50)
        for i = 1, 6 do
            surface.DrawLine(pts[i].x, pts[i].y, pts[i % 6 + 1].x, pts[i % 6 + 1].y)
        end

        -- Floor ellipse glow (under character feet)
        for j = 7, 1, -1 do
            local fw = math.floor(pr * 1.5 * j / 7)
            local fh = math.floor(22 * j / 7)
            local fa = math.floor(60 * (8 - j) / 7)
            draw.RoundedBox(fh, gcx - fw, floorY - math.floor(fh / 2), fw * 2, fh,
                Color(C.accent.r, C.accent.g, C.accent.b, fa))
        end
    end

    -- ── MODEL ────────────────────────────────────────────────────────────────
    local modelH = math.floor(h * 0.68)
    local modelW = math.floor(cw * 0.48)
    local modelX = math.floor((cw - modelW) / 2)
    local modelY = math.floor(h * 0.03)

    local mdl = vgui.Create("DModelPanel", center)
    mdl:SetPos(modelX, modelY)
    mdl:SetSize(modelW, modelH)
    mdl:SetModel(LocalPlayer():GetModel())
    mdl:SetAmbientLight(Color(10, 28, 55))
    mdl:SetDirectionalLight(BOX_FRONT, Color(220, 240, 255))
    mdl:SetDirectionalLight(BOX_TOP,   Color(70,  140, 220))
    mdl:SetDirectionalLight(BOX_LEFT,  Color(30,  80,  160))
    mdl:SetDirectionalLight(BOX_BACK,  Color(5,   15,  40))

    function mdl:Paint(mw, mh)
        -- Match bg so panel edge isn't jarring
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, mw, mh)
        self:DrawModel()
    end

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

    -- ── NAME / SUBTITLE ──────────────────────────────────────────────────────
    local infoY = modelY + modelH + 6

    local jobLbl = vgui.Create("DLabel", center)
    jobLbl:SetPos(0, infoY)
    jobLbl:SetSize(cw, 30)
    jobLbl:SetFont("swrp_f4_hero")
    jobLbl:SetTextColor(C.text)
    jobLbl:SetText(string.upper(prop.data.localGet("character_job_name", "ШТУРМОВИК")))
    jobLbl:SetContentAlignment(5)

    local subLbl = vgui.Create("DLabel", center)
    subLbl:SetPos(0, infoY + 32)
    subLbl:SetSize(cw, 16)
    subLbl:SetFont("swrp_f4_sub")
    subLbl:SetTextColor(C.textDim)
    subLbl:SetText("101-Й ФОРМАЦИОННЫЙ КОРПУС")
    subLbl:SetContentAlignment(5)

    -- ── DEPLOY BUTTON ────────────────────────────────────────────────────────
    local btnW = math.floor(cw * 0.44)
    local btnH = 48
    local btnX = math.floor((cw - btnW) / 2)
    local btnY = infoY + 58
    local chev = 18  -- chevron depth

    local deployBtn = vgui.Create("DButton", center)
    deployBtn:SetPos(btnX, btnY)
    deployBtn:SetSize(btnW, btnH)
    deployBtn:SetText("")
    deployBtn:SetCursor("hand")

    deployBtn.Paint = function(s, bw, bh)
        local hov  = s:IsHovered()
        local base = hov and Color(48, 118, 210) or C.button
        local mid  = math.floor(bh / 2)

        -- Pentagon: chevron on left, straight on right
        surface.SetDrawColor(base)
        surface.DrawPoly({
            {x = chev, y = 0},
            {x = bw,   y = 0},
            {x = bw,   y = bh},
            {x = chev, y = bh},
            {x = 0,    y = mid},
        })

        -- Border
        local bc = hov and C.bright or C.accent
        local ba = hov and 200 or 110
        surface.SetDrawColor(bc.r, bc.g, bc.b, ba)
        surface.DrawLine(chev, 0,      bw - 1, 0)
        surface.DrawLine(bw - 1, 0,    bw - 1, bh - 1)
        surface.DrawLine(chev, bh - 1, bw - 1, bh - 1)
        surface.DrawLine(0, mid,       chev,   0)
        surface.DrawLine(0, mid,       chev,   bh - 1)

        -- Label (centered in the non-chevron area)
        draw.SimpleText("РАЗВЕРНУТЬСЯ", "swrp_f4_nav",
            math.floor((bw + chev) / 2) - 14, mid,
            C.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        -- Enter key box
        local kx = bw - 38
        local ky = math.floor((bh - 18) / 2)
        draw.RoundedBox(3, kx, ky, 26, 18,
            Color(C.bright.r, C.bright.g, C.bright.b, hov and 80 or 45))
        draw.SimpleText("↵", "swrp_f4_small", kx + 13, ky + 9,
            C.bright, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    deployBtn.DoClick = swrp_f4menu.Close

    -- ── RIGHT PANEL ──────────────────────────────────────────────────────────
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
    local HDR_H = 48
    local sqH   = vgui.Create("DPanel", rp)
    sqH:SetPos(0, 0)
    sqH:SetSize(RPANEL_W, HDR_H)
    sqH.Paint = function(_, rw, rh)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, rh - 1, rw, 1)
        draw.SimpleText("◀  ОТРЯД", "swrp_f4_valSm",
            16, math.floor(rh / 2), C.bright, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local cnt = tostring(#player.GetAll()) .. " / " .. tostring(game.MaxPlayers())
        draw.SimpleText(cnt, "swrp_f4_valSm",
            rw - 14, math.floor(rh / 2), C.textDim, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    -- ── Player row factory ────────────────────────────────────────────────────
    local ROW_H = 60
    local function makeRow(par, ypos, ply, highlight)
        local row = vgui.Create("DPanel", par)
        row:SetPos(0, ypos)
        row:SetSize(RPANEL_W, ROW_H)

        local jobName = (ply == LocalPlayer())
            and string.upper(prop.data.localGet("character_job_name", "СОЛДАТ"))
            or string.upper(team.GetName(ply:Team()) or "СОЛДАТ")

        row.Paint = function(_, rw, rh)
            if highlight then
                surface.SetDrawColor(C.sbAct.r, C.sbAct.g, C.sbAct.b, 40)
                surface.DrawRect(0, 0, rw, rh)
            end
            surface.SetDrawColor(C.border)
            surface.DrawRect(0, rh - 1, rw, 1)

            -- Targeting-reticle indicator
            local icx = 28
            local icy = math.floor(rh / 2)
            local r1  = 14
            local r2  = 9
            surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 190)
            surface.DrawOutlinedRect(icx - r1, icy - r1, r1 * 2, r1 * 2, 1)
            draw.RoundedBox(r2, icx - r2, icy - r2, r2 * 2, r2 * 2,
                Color(C.accent.r, C.accent.g, C.accent.b, 45))
            draw.RoundedBox(3, icx - 3, icy - 3, 6, 6, C.accent)
        end

        local av = vgui.Create("AvatarImage", row)
        av:SetSize(26, 26)
        av:SetPos(15, math.floor((ROW_H - 26) / 2))
        av:SetPlayer(ply, 32)

        local nLbl = vgui.Create("DLabel", row)
        nLbl:SetPos(50, math.floor(ROW_H / 2) - 13)
        nLbl:SetFont("swrp_f4_small")
        nLbl:SetTextColor(C.text)
        nLbl:SetText(ply:Nick())
        nLbl:SizeToContents()

        local sLbl = vgui.Create("DLabel", row)
        sLbl:SetPos(50, math.floor(ROW_H / 2) + 2)
        sLbl:SetFont("swrp_f4_label")
        sLbl:SetTextColor(C.textDim)
        sLbl:SetText(jobName .. " · В СЕТИ")
        sLbl:SizeToContents()
    end

    local lp = LocalPlayer()
    makeRow(rp, HDR_H, lp, true)

    -- Scrollable list of other players
    local scroll = vgui.Create("DScrollPanel", rp)
    scroll:SetPos(0, HDR_H + ROW_H)
    scroll:SetSize(RPANEL_W, h - HDR_H - ROW_H)
    scroll:GetVBar():SetWide(3)

    local function rebuildList()
        scroll:Clear()
        local curY = 0
        for _, ply in ipairs(player.GetAll()) do
            if ply == lp then continue end
            makeRow(scroll, curY, ply, false)
            curY = curY + ROW_H
        end
    end

    -- ── OnShow ────────────────────────────────────────────────────────────────
    panel.OnShow = function()
        rebuildList()
        jobLbl:SetText(string.upper(prop.data.localGet("character_job_name", "ШТУРМОВИК")))
        local charName = prop.data.localGet("character_name", "")
        subLbl:SetText(charName ~= "" and string.upper(charName) or "101-Й ФОРМАЦИОННЫЙ КОРПУС")
        mdl:SetModel(lp:GetModel())
        mdl._ready = nil
    end

    return panel
end
