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

local SIDEBAR_W  = 220
local TOPBAR_H   = 58
local NAV_ITEM_H = 48

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

    -- Full-screen overlay — blur + dark navy tint over the game world
    local overlay = vgui.Create("EditablePanel")
    overlay:SetSize(sw, sh)
    overlay:SetPos(0, 0)
    overlay:MakePopup()
    overlay:SetKeyboardInputEnabled(true)
    overlay.Paint = function(s, w, h)
        -- Solid dark navy — no blur to avoid render state corruption
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

    -- ── SIDEBAR ──────────────────────────────────────────────────────────────
    local sidebar = vgui.Create("DPanel", overlay)
    sidebar:SetPos(0, 0)
    sidebar:SetSize(SIDEBAR_W, sh)
    sidebar.Paint = function(_, w, h)
        surface.SetDrawColor(C.sidebar)
        surface.DrawRect(0, 0, w, h)
        -- Gradient right edge (fades into the content bg)
        surface.SetMaterial(matGradR)
        surface.SetDrawColor(C.border.r, C.border.g, C.border.b, 120)
        surface.DrawTexturedRect(w - 24, 0, 24, h)
        -- Hard 1px right border
        surface.SetDrawColor(C.border)
        surface.DrawRect(w - 1, 0, 1, h)
    end

    -- Avatar block at top of sidebar
    local avatarH = 88
    local avatarArea = vgui.Create("DPanel", sidebar)
    avatarArea:SetPos(0, 0)
    avatarArea:SetSize(SIDEBAR_W, avatarH)
    avatarArea.Paint = function(_, w, h)
        -- Accent gradient wash behind avatar area
        surface.SetMaterial(matGrad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 22)
        surface.DrawTexturedRect(0, 0, w, h)
        -- Bottom separator
        surface.SetDrawColor(C.border)
        surface.DrawRect(18, h - 1, w - 36, 1)
    end

    local av = vgui.Create("AvatarImage", avatarArea)
    av:SetSize(40, 40)
    av:SetPos(18, math.floor((avatarH - 40) / 2))
    av:SetPlayer(LocalPlayer(), 32)

    local nickLbl = vgui.Create("DLabel", avatarArea)
    nickLbl:SetPos(68, 24)
    nickLbl:SetFont("swrp_f4_nav")
    nickLbl:SetTextColor(C.text)
    nickLbl:SetText(LocalPlayer():Nick())
    nickLbl:SizeToContents()

    local jobLbl = vgui.Create("DLabel", avatarArea)
    jobLbl:SetPos(68, 44)
    jobLbl:SetFont("swrp_f4_small")
    jobLbl:SetTextColor(C.textDim)
    jobLbl:SetText(prop.data.localGet("character_job_name", "Unknown"))
    jobLbl:SizeToContents()

    -- Nav items
    local activePanel = nil

    for i, item in ipairs(NAV) do
        local btn = vgui.Create("DButton", sidebar)
        btn:SetPos(0, avatarH + (i - 1) * NAV_ITEM_H)
        btn:SetSize(SIDEBAR_W, NAV_ITEM_H)
        btn:SetText("")
        btn:SetCursor("hand")

        btn.Paint = function(s, w, h)
            local active = (activePanel == item.id)
            local hover  = s:IsHovered()

            if active then
                -- Full-width gradient wash
                surface.SetMaterial(matGrad)
                surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 60)
                surface.DrawTexturedRect(0, 0, w, h)
                -- Left accent bar (4px, inset vertically)
                surface.SetDrawColor(C.accent)
                surface.DrawRect(0, 10, 4, h - 20)
                -- Second softer bar
                surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 80)
                surface.DrawRect(4, 10, 1, h - 20)
            elseif hover then
                surface.SetDrawColor(16, 24, 40)
                surface.DrawRect(0, 0, w, h)
            end

            draw.SimpleText(
                item.label, "swrp_f4_nav",
                28, h / 2,
                active and C.text or C.textDim,
                TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
            )
        end

        btn.DoClick = function()
            swrp_f4menu.SetPanel(item.id)
        end
    end

    local tagLbl = vgui.Create("DLabel", sidebar)
    tagLbl:SetPos(18, sh - 26)
    tagLbl:SetFont("swrp_f4_label")
    tagLbl:SetTextColor(C.textMut)
    tagLbl:SetText("Republic Server · v1.0")
    tagLbl:SizeToContents()

    -- ── CONTENT ──────────────────────────────────────────────────────────────
    local cw = sw - SIDEBAR_W

    local content = vgui.Create("DPanel", overlay)
    content:SetPos(SIDEBAR_W, 0)
    content:SetSize(cw, sh)
    content.Paint = function() end  -- transparent — blurred game world shows through

    -- Top bar
    local topbar = vgui.Create("DPanel", content)
    topbar:SetPos(0, 0)
    topbar:SetSize(cw, TOPBAR_H)
    topbar.Paint = function(_, w, h)
        surface.SetDrawColor(C.topbar)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(C.border)
        surface.DrawRect(0, h - 1, w, 1)
    end

    local titleLbl = vgui.Create("DLabel", topbar)
    titleLbl:SetPos(28, 0)
    titleLbl:SetSize(400, TOPBAR_H)
    titleLbl:SetFont("swrp_f4_title")
    titleLbl:SetTextColor(C.text)
    titleLbl:SetText("Profile")
    titleLbl:SetContentAlignment(4)
    swrp_f4menu._title = titleLbl

    -- Credits chip
    local chip = vgui.Create("DPanel", topbar)
    chip:SetPos(cw - 248, 13)
    chip:SetSize(144, 32)
    chip.Paint = function(_, w, h)
        draw.RoundedBox(6, 0, 0, w, h, C.border)
        draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(14, 20, 36))
        surface.SetMaterial(matGrad)
        surface.SetDrawColor(C.accent.r, C.accent.g, C.accent.b, 26)
        surface.DrawTexturedRect(1, 1, w - 2, h - 2)
    end

    local credLbl = vgui.Create("DLabel", chip)
    credLbl:SetPos(12, 0)
    credLbl:SetSize(120, 32)
    credLbl:SetFont("swrp_f4_nav")
    credLbl:SetTextColor(C.accent)
    credLbl:SetText(string.format("\xE2\x82\xB9 %d", prop.data.localGet("character_money", 0)))
    credLbl:SetContentAlignment(4)
    swrp_f4menu._credLbl = credLbl

    -- ESC button
    local escBtn = vgui.Create("DButton", topbar)
    escBtn:SetPos(cw - 92, 13)
    escBtn:SetSize(76, 32)
    escBtn:SetText("ESC")
    escBtn:SetFont("swrp_f4_label")
    escBtn:SetTextColor(C.textDim)
    escBtn:SetCursor("hand")
    escBtn.Paint = function(s, w, h)
        local hov = s:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, hov and C.accent or C.border)
        draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(12, 18, 32))
        s:SetTextColor(hov and C.text or C.textDim)
    end
    escBtn.DoClick = swrp_f4menu.Close

    -- Content panels
    local ch = sh - TOPBAR_H
    local panels = {
        profile   = swrp_f4menu.CreateProfilePanel   (content, cw, ch),
        roster    = swrp_f4menu.CreateRosterPanel    (content, cw, ch),
        chars     = swrp_f4menu.CreateCharactersPanel(content, cw, ch),
        calladmin = swrp_f4menu.CreateCallAdminPanel (content, cw, ch),
        donate    = swrp_f4menu.CreateDonatePanel    (content, cw, ch),
        quests    = swrp_f4menu.CreateQuestsPanel    (content, cw, ch),
    }

    for _, p in pairs(panels) do
        p:SetPos(0, TOPBAR_H)
        p:SetSize(cw, ch)
        p:SetVisible(false)
    end

    function swrp_f4menu.SetPanel(id)
        for _, p in pairs(panels) do p:SetVisible(false) end
        if not panels[id] then return end
        panels[id]:SetVisible(true)
        activePanel = id
        for _, item in ipairs(NAV) do
            if item.id == id then
                swrp_f4menu._title:SetText(item.label)
                break
            end
        end
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
