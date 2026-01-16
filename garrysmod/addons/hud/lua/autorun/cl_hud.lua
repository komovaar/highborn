if CLIENT then
    hook.Add("InitPostEntity", "SW_CreateFont", function()
        surface.CreateFont("SW_HUD_Main", {
            font = "Montserrat",
            size = 28,
            weight = 800,
            shadow=true,
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

    local barWidth = 220
    local barHeight = 10

    local xBase = ScrW() / 2 - barWidth 
    local yBase = ScrH() - 80

    local hp = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local armor = math.Clamp(ply:Armor(), 0, 100)

    -- HP BAR
    draw.RoundedBox(0, xBase, yBase, barWidth, barHeight, Color(25,25,25,220))
    draw.RoundedBox(0, xBase, yBase, barWidth * (hp / ply:GetMaxHealth()), barHeight, Color(200,60,60))

    -- ARMOR BAR
    draw.RoundedBox(0, xBase + barWidth, yBase, barWidth, barHeight, Color(25,25,25,220))
    draw.RoundedBox(0, xBase + barWidth, yBase, barWidth * (armor / ply:GetMaxArmor()), barHeight, Color(60,120,200))

    -- TEXT INFO
    local textY = yBase + barHeight * 2 

    local money = "RC " .. (ply:getDarkRPVar("money") or 0)
    local job = ply:getDarkRPVar("job") or "Unknown"
    
    draw.DrawText(job, font, xBase, textY, Color(255,255,255))
    draw.DrawText(money, font, xBase, textY + 22, Color(255,255,255))

    ----------------------------------------------------------------
    -- 🔹 ПРАВЫЙ ВЕРХ (NAME + TIME)
    ----------------------------------------------------------------

    local textLines = {
        "Highborn",
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
     draw.SimpleText(
        "Highborn",
        font,
        lineX - padding,
        yText,
        Color(255,255,255),
        TEXT_ALIGN_RIGHT
    )

    draw.SimpleText(
        os.date("%H:%M"),
        font,
        lineX - padding,
        yText + 24,
        Color(200,200,200),
        TEXT_ALIGN_RIGHT
    )

    -- VERTICAL LINE
    draw.RoundedBox(0, lineX, yText - 4, 2, lineH * 2 + 4, Color(60,120,200))
end)
