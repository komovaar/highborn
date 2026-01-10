if CLIENT then
    hook.Add("InitPostEntity", "SW_CreateFontAndLogo", function()
        -- Шрифт
        surface.CreateFont("SW_HUD_Main", {
            font = "DM Sans",
            size = 24,
            weight = 1000,
            antialias = true,
            extended = true
        })
        print("[SW HUD] Font created")

        -- Картинка
        SW_HUD_Logo = Material("hud/gar.png")
        if SW_HUD_Logo:IsError() then
            print("[SW HUD] ERROR: Logo not found!")
        else
            print("[SW HUD] Logo loaded successfully")
        end
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

    local barWidth = 240
    local barHeight = 10
    local xBars = ScrW() / 2 - barWidth
    local yBars = ScrH() - 80

    local hp = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local armor = math.Clamp(ply:Armor(), 0, 100)

    -- HP
    draw.RoundedBox(0, xBars, yBars, barWidth, barHeight, Color(30,30,30,220))
    draw.RoundedBox(0, xBars, yBars, barWidth * (hp / ply:GetMaxHealth()), barHeight, Color(200,60,60,255))

    -- Armor
    draw.RoundedBox(0, xBars + barWidth, yBars, barWidth, barHeight, Color(30,30,30,220))
    draw.RoundedBox(0, xBars + barWidth, yBars, barWidth * (armor / 100), barHeight, Color(60,120,200,255))

    local font = "SW_HUD_Main"
    surface.SetFont(font)

    local textLines = {
        "Highborn",
        os.date("%d/%m/%Y"),
        "$" .. (ply:getDarkRPVar("money") or "0")
    }

    local maxW, lineH = 0, 0
    for _, line in ipairs(textLines) do
        local w, h = surface.GetTextSize(line)
        if w > maxW then maxW = w end
        lineH = h
    end

    local padding = 10
    local xText = ScrW() - maxW - 76 - padding*2 
    local yText = 30

    for i, line in ipairs(textLines) do
        draw.SimpleText(line, font, xText + 2, yText + 2 + (i-1)*(lineH+2), Color(0,0,0,150))
        draw.SimpleText(line, font, xText, yText + (i-1)*(lineH+2), Color(220,220,220,255))
    end

    local lineX = xText + maxW + padding
    local lineY = yText
    local lineHFull = (#textLines * (lineH + 2)) + 10
    draw.RoundedBox(0, lineX, lineY, 2, lineHFull, Color(255,255,255,255))

    -- Рисуем картинку справа от линии
    if SW_HUD_Logo and not SW_HUD_Logo:IsError() then
        local logoSize = 64
        local xLogo = lineX + 10
        local yLogo = lineY

        surface.SetMaterial(SW_HUD_Logo)
        surface.SetDrawColor(255, 255, 255, 255)  -- делаем белой
        surface.DrawTexturedRect(xLogo, yLogo, logoSize, logoSize)
    end

end)
