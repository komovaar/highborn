swrp_f4menu = swrp_f4menu or {}

local matGrad  = Material("gui/gradient")
local matGradR = Material("gui/gradient_r")

-- Navy-slate palette — dark but not pitch black, Star Wars holoscreen feel
swrp_f4menu.C = {
    bg      = Color(13,  19,  32),
    sidebar = Color(9,   13,  23),
    card    = Color(20,  29,  48),
    border  = Color(36,  52,  80),
    accent  = Color(58,  148, 230),
    text    = Color(210, 232, 255),
    textDim = Color(82,  118, 165),
    textMut = Color(36,  56,  88),
    topbar  = Color(9,   13,  23),
    success = Color(52,  180, 100),
    danger  = Color(215, 72,  72),
    warn    = Color(215, 140, 45),
}
local C = swrp_f4menu.C

swrp_f4menu.Mat = {grad = matGrad, gradR = matGradR}

local function mkfont(name, family, size, weight)
    surface.CreateFont(name, {font = family, size = size, weight = weight, antialias = true})
end
mkfont("swrp_f4_nav",   "Verdana", 13, 400)
mkfont("swrp_f4_label", "Verdana", 10, 700)
mkfont("swrp_f4_title", "Verdana", 16, 700)
mkfont("swrp_f4_valSm", "Verdana", 16, 700)
mkfont("swrp_f4_val",   "Verdana", 22, 700)
mkfont("swrp_f4_small", "Verdana", 11, 400)
mkfont("swrp_f4_mono",  "Courier New", 11, 400)

function swrp_f4menu.DrawCard(x, y, w, h, r)
    r = r or 7
    draw.RoundedBox(r, x,     y,     w,     h,     C.border)
    draw.RoundedBox(r, x + 1, y + 1, w - 2, h - 2, C.card)
end

function swrp_f4menu.DrawGradCard(x, y, w, h, r, alpha)
    swrp_f4menu.DrawCard(x, y, w, h, r)
    surface.SetMaterial(matGrad)
    surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, alpha or 30)
    surface.DrawTexturedRect(x + 1, y + 1, w - 2, h - 2)
end

local INFOBAR_H = 44
local TABBAR_H  = 46

local NAV = {
    {id = "profile",   label = "Profile"},
    {id = "roster",    label = "Roster"},
    {id = "chars",     label = "Characters"},
    {id = "calladmin", label = "Call an admin"},
    {id = "donate",    label = "Donate"},
    {id = "quests",    label = "Quests"},
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
        surface.SetDrawColor(C.bg.r, C.bg.g, C.bg.b, 248)
        surface.DrawRect(0, 0, w, h)
        -- Subtle full-width accent line at very top of screen
        surface.SetMaterial(matGrad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 180)
        surface.DrawTexturedRect(0, 0, math.floor(w * 0.55), 2)
        surface.SetMaterial(matGradR)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 180)
        surface.DrawTexturedRect(math.floor(w * 0.45), 0, math.floor(w * 0.55), 2)
    end
    overlay.OnKeyCodePressed = function(_, key)
        if key == KEY_ESCAPE or key == KEY_F4 then
            swrp_f4menu.Close()
        end
    end
    swrp_f4menu.Overlay = overlay

    -- ── INFO BAR (row 1) — server name | avatar · nick · credits | ESC ──────
    local infobar = vgui.Create("DPanel", overlay)
    infobar:SetPos(0, 0)
    infobar:SetSize(sw, INFOBAR_H)
    infobar.Paint = function(_, w, h)
        surface.SetDrawColor(C.topbar)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, h - 1, w, 1)
    end

    local logoLbl = vgui.Create("DLabel", infobar)
    logoLbl:SetPos(22, 0)
    logoLbl:SetSize(260, INFOBAR_H)
    logoLbl:SetFont("swrp_f4_label")
    logoLbl:SetTextColor(C.textDim)
    logoLbl:SetText("REPUBLIC SERVER  ·  v1.0")
    logoLbl:SetContentAlignment(4)

    -- Avatar + nick
    local av = vgui.Create("AvatarImage", infobar)
    av:SetSize(28, 28)
    av:SetPos(sw - 312, math.floor((INFOBAR_H - 28) / 2))
    av:SetPlayer(LocalPlayer(), 32)

    local nickLbl = vgui.Create("DLabel", infobar)
    nickLbl:SetPos(sw - 280, 0)
    nickLbl:SetSize(148, INFOBAR_H)
    nickLbl:SetFont("swrp_f4_small")
    nickLbl:SetTextColor(C.textDim)
    nickLbl:SetText(LocalPlayer():Nick())
    nickLbl:SetContentAlignment(4)

    -- Credits chip
    local chip = vgui.Create("DPanel", infobar)
    chip:SetPos(sw - 218, math.floor((INFOBAR_H - 26) / 2))
    chip:SetSize(124, 26)
    chip.Paint = function(_, w, h)
        draw.RoundedBox(5, 0, 0, w, h, C.border)
        draw.RoundedBox(4, 1, 1, w - 2, h - 2, Color(14, 20, 36))
        surface.SetMaterial(matGrad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 22)
        surface.DrawTexturedRect(1, 1, w - 2, h - 2)
    end

    local credLbl = vgui.Create("DLabel", chip)
    credLbl:SetPos(10, 0)
    credLbl:SetSize(104, 26)
    credLbl:SetFont("swrp_f4_small")
    credLbl:SetTextColor(C.accent)
    credLbl:SetText(string.format("\xE2\x82\xB9 %d", prop.data.localGet("character_money", 0)))
    credLbl:SetContentAlignment(4)
    swrp_f4menu._credLbl = credLbl

    -- ESC button
    local escBtn = vgui.Create("DButton", infobar)
    escBtn:SetPos(sw - 86, math.floor((INFOBAR_H - 26) / 2))
    escBtn:SetSize(70, 26)
    escBtn:SetText("ESC")
    escBtn:SetFont("swrp_f4_label")
    escBtn:SetTextColor(C.textDim)
    escBtn:SetCursor("hand")
    escBtn.Paint = function(s, w, h)
        local hov = s:IsHovered()
        draw.RoundedBox(5, 0, 0, w, h, hov and C.accent or C.border)
        draw.RoundedBox(4, 1, 1, w - 2, h - 2, Color(12, 18, 32))
        s:SetTextColor(hov and C.text or C.textDim)
    end
    escBtn.DoClick = swrp_f4menu.Close

    -- ── TAB BAR (row 2) — evenly distributed tabs ─────────────────────────
    local tabW = math.floor(sw / #NAV)

    local tabbar = vgui.Create("DPanel", overlay)
    tabbar:SetPos(0, INFOBAR_H)
    tabbar:SetSize(sw, TABBAR_H)
    tabbar.Paint = function(_, w, h)
        surface.SetDrawColor(C.topbar)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, h - 1, w, 1)
    end

    local activePanel = nil

    for i, item in ipairs(NAV) do
        local btn = vgui.Create("DButton", tabbar)
        btn:SetPos((i - 1) * tabW, 0)
        btn:SetSize(tabW, TABBAR_H)
        btn:SetText("")
        btn:SetCursor("hand")

        btn.Paint = function(s, w, h)
            local active = (activePanel == item.id)
            local hover  = s:IsHovered()

            if active then
                surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 18)
                surface.DrawRect(0, 0, w, h)
                -- Active indicator: 2px bottom bar
                surface.SetDrawColor(C.accent)
                surface.DrawRect(0, h - 2, w, 2)
            elseif hover then
                surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 8)
                surface.DrawRect(0, 0, w, h)
            end

            -- Vertical divider between tabs
            if i > 1 then
                surface.SetDrawColor(C.border)
                surface.DrawRect(0, 10, 1, h - 20)
            end

            draw.SimpleText(
                item.label, "swrp_f4_nav",
                w / 2, h / 2,
                active and C.text or C.textDim,
                TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
            )
        end

        btn.DoClick = function()
            swrp_f4menu.SetPanel(item.id)
        end
    end

    -- ── CONTENT ──────────────────────────────────────────────────────────────
    local ch = sh - INFOBAR_H - TABBAR_H

    local content = vgui.Create("DPanel", overlay)
    content:SetPos(0, INFOBAR_H + TABBAR_H)
    content:SetSize(sw, ch)
    content.Paint = function() end

    local panels = {
        profile   = swrp_f4menu.CreateProfilePanel   (content, sw, ch),
        roster    = swrp_f4menu.CreateRosterPanel    (content, sw, ch),
        chars     = swrp_f4menu.CreateCharactersPanel(content, sw, ch),
        calladmin = swrp_f4menu.CreateCallAdminPanel (content, sw, ch),
        donate    = swrp_f4menu.CreateDonatePanel    (content, sw, ch),
        quests    = swrp_f4menu.CreateQuestsPanel    (content, sw, ch),
    }

    for _, p in pairs(panels) do
        p:SetPos(0, 0)
        p:SetSize(sw, ch)
        p:SetVisible(false)
    end

    function swrp_f4menu.SetPanel(id)
        for _, p in pairs(panels) do p:SetVisible(false) end
        if not panels[id] then return end
        panels[id]:SetVisible(true)
        activePanel = id
        if panels[id].OnShow then panels[id]:OnShow() end
    end

    swrp_f4menu.SetPanel("profile")
end

function swrp_f4menu.Close()
    if IsValid(swrp_f4menu.Overlay) then
        swrp_f4menu.Overlay:Remove()
        swrp_f4menu.Overlay = nil
    end
end
