swrp_f4menu = swrp_f4menu or {}

local matGrad  = Material("gui/gradient")
local matGradR = Material("gui/gradient_r")

-- Battlefront-inspired navy palette
swrp_f4menu.C = {
    bg      = Color(7,   18,  32),
    sidebar = Color(9,   20,  35),
    sbAct   = Color(23,  80,  148),
    card    = Color(11,  24,  44),
    border  = Color(26,  58,  92),
    accent  = Color(61,  159, 219),
    bright  = Color(94,  207, 255),
    text    = Color(184, 216, 240),
    textDim = Color(58,  106, 144),
    textMut = Color(26,  58,  92),
    gold    = Color(255, 187, 44),
    success = Color(44,  201, 144),
    danger  = Color(215, 72,  72),
    warn    = Color(215, 140, 45),
    button  = Color(23,  96,  168),
}
local C = swrp_f4menu.C

swrp_f4menu.Mat = {grad = matGrad, gradR = matGradR}

local function mkfont(name, family, size, weight)
    surface.CreateFont(name, {font = family, size = size, weight = weight, antialias = true})
end
mkfont("swrp_f4_nav",    "Verdana", 13, 400)
mkfont("swrp_f4_label",  "Verdana", 9,  700)
mkfont("swrp_f4_title",  "Verdana", 18, 700)
mkfont("swrp_f4_valSm",  "Verdana", 15, 700)
mkfont("swrp_f4_val",    "Verdana", 22, 700)
mkfont("swrp_f4_small",  "Verdana", 11, 400)
mkfont("swrp_f4_mono",   "Courier New", 13, 700)
mkfont("swrp_f4_navLbl", "Verdana", 8,  700)
mkfont("swrp_f4_hero",   "Verdana", 22, 700)
mkfont("swrp_f4_cred",   "Courier New", 14, 700)
mkfont("swrp_f4_sub",    "Verdana", 10, 400)

-- ── Icon drawing ──────────────────────────────────────────────────────────
local function drawIcon(id, cx, cy, col)
    surface.SetDrawColor(col)
    local s = 9

    if id == "lobby" then
        local pts = {}
        for i = 0, 5 do
            local a = math.rad(60 * i)
            pts[i+1] = {x = cx + s * math.cos(a), y = cy + s * math.sin(a)}
        end
        for i = 1, 6 do
            surface.DrawLine(pts[i].x, pts[i].y, pts[i % 6 + 1].x, pts[i % 6 + 1].y)
        end
        local inner = {}
        for i = 0, 5 do
            local a = math.rad(60 * i)
            inner[i+1] = {x = cx + 4 * math.cos(a), y = cy + 4 * math.sin(a)}
        end
        surface.DrawPoly(inner)

    elseif id == "loadout" then
        -- Shield outline
        local pts = {
            {x = cx - s + 2, y = cy - s},
            {x = cx + s - 2, y = cy - s},
            {x = cx + s - 2, y = cy},
            {x = cx,         y = cy + s},
            {x = cx - s + 2, y = cy},
        }
        for i = 1, #pts do
            local n = i % #pts + 1
            surface.DrawLine(pts[i].x, pts[i].y, pts[n].x, pts[n].y)
        end

    elseif id == "squad" then
        -- Two people silhouettes
        draw.RoundedBox(3, cx - s,     cy - s, 6, 6, col)
        surface.SetDrawColor(col)
        surface.DrawRect(cx - s, cy - 1, 6, s + 1)
        draw.RoundedBox(3, cx + 2,     cy - s, 6, 6, col)
        surface.SetDrawColor(col)
        surface.DrawRect(cx + 2, cy - 1, 6, s + 1)

    elseif id == "progress" then
        -- Bar chart
        surface.DrawRect(cx - s,         cy + 1,             5, s - 2)
        surface.DrawRect(cx - 2,         cy - math.floor(s * 0.4), 5, s + math.floor(s * 0.4) - 2)
        surface.DrawRect(cx + s - 5,     cy - s,             5, s * 2 - 2)

    elseif id == "profile" then
        -- Head + shoulders
        draw.RoundedBox(4, cx - 4, cy - s, 8, 8, col)
        surface.SetDrawColor(col)
        surface.DrawRect(cx - s + 2, cy, (s - 2) * 2, s - 1)

    elseif id == "exit" then
        -- Door frame + arrow
        surface.DrawRect(cx - s, cy - s, 3, s * 2)
        surface.DrawLine(cx - s + 5, cy, cx + s, cy)
        surface.DrawLine(cx + s - 5, cy - 5, cx + s, cy)
        surface.DrawLine(cx + s - 5, cy + 5, cx + s, cy)
    end
end
swrp_f4menu.DrawIcon = drawIcon

-- ── Radial glow (stacked circles) ────────────────────────────────────────
function swrp_f4menu.DrawGlow(cx, cy, maxR, col, maxAlpha)
    local steps = 8
    for i = steps, 1, -1 do
        local r = math.floor(maxR * i / steps)
        local a = math.floor(maxAlpha * (steps - i + 1) / steps)
        draw.RoundedBox(r, cx - r, cy - r, r * 2, r * 2, Color(col.r, col.g, col.b, a))
    end
end

-- ── Card helpers ──────────────────────────────────────────────────────────
function swrp_f4menu.DrawCard(x, y, w, h, r)
    r = r or 0
    draw.RoundedBox(r, x,     y,     w,     h,     C.border)
    draw.RoundedBox(r, x + 1, y + 1, w - 2, h - 2, C.card)
end

function swrp_f4menu.DrawGradCard(x, y, w, h, r, alpha)
    swrp_f4menu.DrawCard(x, y, w, h, r)
    surface.SetMaterial(matGrad)
    surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, alpha or 30)
    surface.DrawTexturedRect(x + 1, y + 1, w - 2, h - 2)
end

-- ── Layout ────────────────────────────────────────────────────────────────
local SIDEBAR_W  = 115
local TOPBAR_H   = 48
local NAV_ITEM_H = 72

local NAV = {
    {id = "lobby",    label = "ЛОББИ",    icon = "lobby"},
    {id = "loadout",  label = "СНАРЯГА",  icon = "loadout"},
    {id = "squad",    label = "ОТРЯД",    icon = "squad"},
    {id = "progress", label = "ПРОГРЕСС", icon = "progress"},
    {id = "profile",  label = "ПРОФИЛЬ",  icon = "profile"},
}

function swrp_f4menu.Open()
    if IsValid(swrp_f4menu.Overlay) then
        swrp_f4menu.Close()
        return
    end

    local sw, sh = ScrW(), ScrH()

    local overlay = vgui.Create("EditablePanel")
    overlay:SetSize(sw, sh)
    overlay:SetPos(0, 0)
    overlay:MakePopup()
    overlay:SetKeyboardInputEnabled(true)
    overlay.Paint = function(_, w, h)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, w, h)
    end
    overlay.OnKeyCodePressed = function(_, key)
        if key == KEY_ESCAPE or key == KEY_F4 then
            swrp_f4menu.Close()
        end
    end
    swrp_f4menu.Overlay = overlay

    -- ── TOPBAR ──────────────────────────────────────────────────────────────
    local topbar = vgui.Create("DPanel", overlay)
    topbar:SetPos(0, 0)
    topbar:SetSize(sw, TOPBAR_H)
    topbar.Paint = function(_, w, h)
        surface.SetDrawColor(C.bg)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, h - 1, w, 1)

        -- Hex logo
        local hcx = 28
        local hcy = math.floor(h / 2)
        local hr  = 12
        local outer = {}
        for i = 0, 5 do
            local a = math.rad(60 * i - 30)
            outer[i+1] = {x = hcx + hr * math.cos(a), y = hcy + hr * math.sin(a)}
        end
        surface.SetDrawColor(C.accent)
        for i = 1, 6 do
            surface.DrawLine(outer[i].x, outer[i].y, outer[i % 6 + 1].x, outer[i % 6 + 1].y)
        end
        local inner = {}
        for i = 0, 5 do
            local a = math.rad(60 * i - 30)
            inner[i+1] = {x = hcx + 5 * math.cos(a), y = hcy + 5 * math.sin(a)}
        end
        surface.SetDrawColor(C.accent)
        surface.DrawPoly(inner)

        -- Server name
        draw.SimpleText("ГВАРДИЯ РЕСПУБЛИКИ", "swrp_f4_nav",
            50, hcy, C.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        -- Credits (top-right)
        local money = prop.data.localGet("character_money", 0)
        -- Star icon
        surface.SetDrawColor(C.gold)
        surface.DrawRect(w - 210, hcy - 5, 10, 10)
        draw.SimpleText(tostring(money), "swrp_f4_cred",
            w - 194, hcy - 4, C.gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        -- Player name below credits
        draw.SimpleText(LocalPlayer():Nick(), "swrp_f4_label",
            w - 16, hcy + 6, C.textDim, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    -- ── SIDEBAR ─────────────────────────────────────────────────────────────
    local sidebar = vgui.Create("DPanel", overlay)
    sidebar:SetPos(0, TOPBAR_H)
    sidebar:SetSize(SIDEBAR_W, sh - TOPBAR_H)

    local activePanel = nil

    sidebar.Paint = function(_, w, h)
        surface.SetDrawColor(C.sidebar)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(C.border)
        surface.DrawRect(w - 1, 0, 1, h)
        -- Separator above exit button
        surface.SetDrawColor(C.border)
        surface.DrawRect(16, h - NAV_ITEM_H - 1, w - 32, 1)
    end

    for i, item in ipairs(NAV) do
        local btn = vgui.Create("DButton", sidebar)
        btn:SetPos(0, (i - 1) * NAV_ITEM_H)
        btn:SetSize(SIDEBAR_W, NAV_ITEM_H)
        btn:SetText("")
        btn:SetCursor("hand")

        btn.Paint = function(s, w, h)
            local active = (activePanel == item.id)
            local hover  = s:IsHovered()

            if active then
                surface.SetDrawColor(C.sbAct)
                surface.DrawRect(0, 0, w, h)
                -- Left accent stripe
                surface.SetDrawColor(C.bright)
                surface.DrawRect(0, 0, 3, h)
            elseif hover then
                surface.SetDrawColor(C.sbAct.r, C.sbAct.g, C.sbAct.b, 80)
                surface.DrawRect(0, 0, w, h)
            end

            local col = active and C.bright or (hover and C.text or C.textDim)
            drawIcon(item.icon, math.floor(w / 2), math.floor(h / 2) - 10, col)
            draw.SimpleText(item.label, "swrp_f4_navLbl",
                math.floor(w / 2), math.floor(h / 2) + 14,
                col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn.DoClick = function()
            swrp_f4menu.SetPanel(item.id)
        end
    end

    -- Exit button (bottom of sidebar)
    local exitBtn = vgui.Create("DButton", sidebar)
    exitBtn:SetPos(0, sh - TOPBAR_H - NAV_ITEM_H)
    exitBtn:SetSize(SIDEBAR_W, NAV_ITEM_H)
    exitBtn:SetText("")
    exitBtn:SetCursor("hand")
    exitBtn.Paint = function(s, w, h)
        local hov = s:IsHovered()
        if hov then
            surface.SetDrawColor(C.danger.r, C.danger.g, C.danger.b, 35)
            surface.DrawRect(0, 0, w, h)
        end
        local col = hov and C.danger or C.textDim
        drawIcon("exit", math.floor(w / 2), math.floor(h / 2) - 10, col)
        draw.SimpleText("ВЫХОД", "swrp_f4_navLbl",
            math.floor(w / 2), math.floor(h / 2) + 14,
            col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    exitBtn.DoClick = swrp_f4menu.Close

    -- ── CONTENT ─────────────────────────────────────────────────────────────
    local cw = sw - SIDEBAR_W
    local ch = sh - TOPBAR_H

    local content = vgui.Create("DPanel", overlay)
    content:SetPos(SIDEBAR_W, TOPBAR_H)
    content:SetSize(cw, ch)
    content.Paint = function() end

    local function makeStub(label)
        local p = vgui.Create("DPanel", content)
        p.Paint = function(_, pw, ph)
            surface.SetDrawColor(C.bg)
            surface.DrawRect(0, 0, pw, ph)
            draw.SimpleText(label, "swrp_f4_title",
                pw / 2, ph / 2, C.textDim, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return p
    end

    local panels = {}
    local function tryCreate(fn, fallback)
        if fn then return fn(content, cw, ch) end
        return makeStub(fallback)
    end

    panels.lobby    = tryCreate(swrp_f4menu.CreateLobbyPanel,    "ЛОББИ")
    panels.loadout  = tryCreate(swrp_f4menu.CreateLoadoutPanel,  "СНАРЯГА — скоро")
    panels.squad    = tryCreate(swrp_f4menu.CreateSquadPanel,    "ОТРЯД — скоро")
    panels.progress = tryCreate(swrp_f4menu.CreateProgressPanel, "ПРОГРЕСС — скоро")
    panels.profile  = tryCreate(swrp_f4menu.CreateProfilePanel,  "ПРОФИЛЬ — скоро")

    for _, p in pairs(panels) do
        p:SetPos(0, 0)
        p:SetSize(cw, ch)
        p:SetVisible(false)
    end

    function swrp_f4menu.SetPanel(id)
        for _, p in pairs(panels) do p:SetVisible(false) end
        if not panels[id] then return end
        panels[id]:SetVisible(true)
        activePanel = id
        if panels[id].OnShow then panels[id]:OnShow() end
    end

    swrp_f4menu.SetPanel("lobby")
end

function swrp_f4menu.Close()
    if IsValid(swrp_f4menu.Overlay) then
        swrp_f4menu.Overlay:Remove()
        swrp_f4menu.Overlay = nil
    end
end
