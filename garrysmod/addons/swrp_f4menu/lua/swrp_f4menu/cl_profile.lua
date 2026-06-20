local C            = swrp_f4menu.C
local Mat          = swrp_f4menu.Mat
local _sessionStart = RealTime()

local function lbl(par, x, y, w, text, font, col)
    local l = vgui.Create("DLabel", par)
    l:SetPos(x, y)
    l:SetSize(w, 26)
    l:SetFont(font or "swrp_f4_small")
    l:SetTextColor(col or C.textDim)
    l:SetText(text)
    return l
end

function swrp_f4menu.CreateProfilePanel(parent, w, h)
    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(_, pw, ph)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, pw, ph)
    end

    local modelW = math.floor(w * 0.33)
    local infoW  = w - modelW
    local PAD    = 24
    local GAP    = 12
    local colW   = math.floor((infoW - PAD * 2 - GAP) / 2)
    local cardH  = 92

    -- ── MODEL PANEL ──────────────────────────────────────────────────────────
    local modelBg = vgui.Create("DPanel", panel)
    modelBg:SetPos(infoW, 0)
    modelBg:SetSize(modelW, h)
    modelBg.Paint = function(_, mw, mh)
        surface.SetDrawColor(C.sidebar)
        surface.DrawRect(0, 0, mw, mh)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, 0, 1, mh)
        -- fade strip at bottom so labels sit cleanly
        surface.SetDrawColor(C.sidebar.r, C.sidebar.g, C.sidebar.b, 200)
        surface.DrawRect(0, mh - 52, mw, 52)
    end

    local mdl = vgui.Create("DModelPanel", modelBg)
    mdl:SetPos(0, 0)
    mdl:SetSize(modelW, h - 46)
    mdl:SetModel(LocalPlayer():GetModel())
    mdl:SetAmbientLight(Color(28, 52, 92))
    mdl:SetDirectionalLight(BOX_FRONT, Color(75, 128, 205))
    mdl:SetDirectionalLight(BOX_TOP,   Color(48, 88, 162))
    mdl:SetDirectionalLight(BOX_BACK,  Color(14, 32, 72))

    function mdl:LayoutEntity(ent)
        ent:SetAngles(Angle(0, RealTime() * 18, 0))
        if not self._camReady then
            self._camReady = true
            local mn, mx = ent:GetModelBounds()
            local ctr  = (mn + mx) * 0.5
            local dist = (mx - mn):Length() * 1.05
            self:SetCamPos(ctr + Vector(dist, 0, 0))
            self:SetLookAt(ctr)
        end
    end

    lbl(modelBg, 0, h - 42, modelW, prop.data.localGet("character_name", "Clone Recruit"), "swrp_f4_nav", C.text):SetContentAlignment(5)
    lbl(modelBg, 0, h - 24, modelW, prop.data.localGet("character_callsign", "Recruit"),    "swrp_f4_small", C.textDim):SetContentAlignment(5)

    -- ── INFO CARDS ───────────────────────────────────────────────────────────
    local info = vgui.Create("DPanel", panel)
    info:SetPos(0, 0)
    info:SetSize(infoW, h)
    info.Paint = function() end

    local curY = PAD

    local function card(col, cw2, ch2)
        local cx = PAD + (col == 2 and (colW + GAP) or 0)
        local c  = vgui.Create("DPanel", info)
        c:SetPos(cx, curY)
        c:SetSize(cw2 or colW, ch2 or cardH)
        c.Paint = function(_, bw, bh) swrp_f4menu.DrawCard(0, 0, bw, bh) end
        return c
    end

    local jobInfo = prop.team.get(LocalPlayer():Team())
    local salary  = jobInfo and jobInfo.salary or 0
    local money   = prop.data.localGet("character_money", 0)

    -- Row 1 — Credits · Job
    local c1 = card(1)
    lbl(c1, 14, 12, colW - 24, "CREDITS",                             "swrp_f4_label")
    lbl(c1, 14, 30, colW - 24, string.format("\xE2\x82\xB9 %d", money), "swrp_f4_val", C.text)
    lbl(c1, 14, 64, colW - 24, string.format("Salary: \xE2\x82\xB9 %d / 5min", salary))

    local c2 = card(2)
    lbl(c2, 14, 12, colW - 24, "JOB", "swrp_f4_label")
    lbl(c2, 14, 30, colW - 24, prop.data.localGet("character_job_name", "Unknown"), "swrp_f4_valSm", C.text)

    curY = curY + cardH + GAP

    -- Row 2 — Name · Callsign
    local c3 = card(1)
    lbl(c3, 14, 12, colW - 24, "CHARACTER NAME", "swrp_f4_label")
    lbl(c3, 14, 30, colW - 24, prop.data.localGet("character_name", "Clone Recruit"), "swrp_f4_valSm", C.text)

    local c4 = card(2)
    lbl(c4, 14, 12, colW - 24, "CALLSIGN", "swrp_f4_label")
    lbl(c4, 14, 30, colW - 24, prop.data.localGet("character_callsign", "Recruit"), "swrp_f4_valSm", C.text)

    curY = curY + cardH + GAP

    -- Row 3 — CID · Level
    local c5 = card(1)
    lbl(c5, 14, 12, colW - 24, "CID", "swrp_f4_label")
    lbl(c5, 14, 30, colW - 24, "#" .. prop.data.localGet("character_cid", "0000"), "swrp_f4_val", C.text)

    local c6 = card(2)
    lbl(c6, 14, 12, colW - 24, "LEVEL", "swrp_f4_label")
    lbl(c6, 14, 30, colW - 24, tostring(prop.data.localGet("character_level", 1)), "swrp_f4_val", C.text)

    curY = curY + cardH + GAP

    -- Row 4 — Session time · Division
    local c7 = card(1)
    lbl(c7, 14, 12, colW - 24, "SESSION TIME", "swrp_f4_label")
    local sesLbl = lbl(c7, 14, 30, colW - 24, "0h 00m", "swrp_f4_val", C.text)

    local function updateSes()
        if not IsValid(sesLbl) then timer.Remove("swrp_f4_session") return end
        local t = math.floor(RealTime() - _sessionStart)
        sesLbl:SetText(string.format("%dh %02dm", math.floor(t / 3600), math.floor((t % 3600) / 60)))
    end
    updateSes()
    timer.Create("swrp_f4_session", 60, 0, updateSes)

    local c8 = card(2)
    lbl(c8, 14, 12, colW - 24, "DIVISION",                          "swrp_f4_label")
    lbl(c8, 14, 30, colW - 24, prop.config.defaultJobCategory or "Republic", "swrp_f4_valSm", C.text)

    curY = curY + cardH + GAP

    -- Row 5 — Labels (full width)
    local fullW = colW * 2 + GAP
    local cLab = vgui.Create("DPanel", info)
    cLab:SetPos(PAD, curY)
    cLab:SetSize(fullW, 62)
    cLab.Paint = function(_, bw, bh) swrp_f4menu.DrawCard(0, 0, bw, bh) end

    lbl(cLab, 14, 12, fullW - 24, "LABELS", "swrp_f4_label")
    lbl(cLab, 14, 32, fullW - 24, "None assigned")

    return panel
end
