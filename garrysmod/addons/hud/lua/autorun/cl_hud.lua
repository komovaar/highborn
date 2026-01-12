if CLIENT then
    hook.Add("InitPostEntity", "SW_CreateFont", function()
        surface.CreateFont("SW_HUD_Main", {
            font = "DM Sans",
            size = 22,
            weight = 800,
            antialias = true,
            extended = true
        })
    end)
end

-- Отключаем стандартный HUD
hook.Add("HUDShouldDraw", "DisableDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)

hook.Add("HUDPaint", "StarWarsRP_CustomHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local font = "SW_HUD_Main"
    surface.SetFont(font)

    ----------------------------------------------------------------
    -- 🔹 ЛЕВЫЙ НИЖНИЙ УГОЛ (HP / ARMOR / MONEY / JOB)
    ----------------------------------------------------------------

    local xBase = 30
    local yBase = ScrH() - 120

    local barWidth = 220
    local barHeight = 10
    local spacing = 6

    local hp = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local armor = math.Clamp(ply:Armor(), 0, 100)

    -- HP BAR
    draw.RoundedBox(0, xBase, yBase, barWidth, barHeight, Color(25,25,25,220))
    draw.RoundedBox(0, xBase, yBase, barWidth * (hp / ply:GetMaxHealth()), barHeight, Color(200,60,60))

    -- ARMOR BAR
    draw.RoundedBox(0, xBase, yBase + barHeight + spacing, barWidth, barHeight, Color(25,25,25,220))
    draw.RoundedBox(0, xBase, yBase + barHeight + spacing, barWidth * (armor / 100), barHeight, Color(60,120,200))

    -- TEXT INFO
    local textY = yBase + barHeight * 2 + spacing * 2 + 6

    local money = "RC " .. (ply:getDarkRPVar("money") or 0)
    local job = ply:getDarkRPVar("job") or "Unknown"
    
    draw.SimpleText(job, font, xBase, textY, Color(255,255,255))
    draw.SimpleText(money, font, xBase, textY + 22, Color(255,255,255))

    ----------------------------------------------------------------
    -- 🔹 ПРАВЫЙ ВЕРХ (NAME + TIME)
    ----------------------------------------------------------------

    local textLines = {
        "Highborn",
        os.date("%H:%M")
    }

    local padding = 10
    local lineX = ScrW() - padding - 2
    local yText = 20

    local lineH = 0
    for _, line in ipairs(textLines) do
        local _, h = surface.GetTextSize(line)
        lineH = lineH + h + 4
    end

    -- TEXT
    local yOffset = yText
    for _, line in ipairs(textLines) do
        draw.SimpleText(
            line,
            font,
            lineX - padding,
            yOffset,
            Color(255,255,255),
            TEXT_ALIGN_RIGHT
        )
        yOffset = yOffset + 24
    end

    -- VERTICAL LINE
    draw.RoundedBox(0, lineX, yText - 4, 2, lineH + 4, Color(60,120,200))
end)
