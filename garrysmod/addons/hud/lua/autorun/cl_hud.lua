if CLIENT then
    hook.Add("InitPostEntity", "Highborn_CreateHUDFonts", function()

        surface.CreateFont("HB_HUD_Title", {
            font = "Roboto",
            size = 26,
            weight = 700,
            antialias = true,
            extended = true
        })

        surface.CreateFont("HB_HUD_Main", {
            font = "Roboto",
            size = 21,
            weight = 500,
            antialias = true,
            extended = true
        })

        surface.CreateFont("HB_HUD_Small", {
            font = "Roboto",
            size = 18,
            weight = 400,
            antialias = true,
            extended = true
        })
    end)
end


hook.Add("HUDShouldDraw", "Highborn_DisableDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)


hook.Add("HUDPaint", "Highborn_HUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local barW = 220
    local barH = 10

    local xBase = math.floor(ScrW() / 2 - barW)
    local yBase = math.floor(ScrH() - 90)

    local hp = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local armor = math.Clamp(ply:Armor(), 0, ply:GetMaxArmor())

    draw.RoundedBox(0, xBase, yBase, barW, barH, Color(35,35,35,220))
    draw.RoundedBox(0, xBase, yBase, barW * (hp / ply:GetMaxHealth()), barH, Color(200,60,60))

    draw.RoundedBox(0, xBase + barW, yBase, barW, barH, Color(35,35,35,220))
    draw.RoundedBox(0, xBase + barW, yBase, barW * (armor / ply:GetMaxArmor()), barH, Color(70,130,220))

    local job = ply:getDarkRPVar("job") or "Unknown"
    local money = ply:getDarkRPVar("money") or 0

    

    DrawTextOutlined(
        job,
        "HB_HUD_Main",
        xBase,
        yBase + 18,
        Color(255,255,255),
        Color(0,0,0,200),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )

    DrawTextOutlined(
        "RC " .. money,
        "HB_HUD_Small",
        xBase,
        yBase + 38,
        Color(220,220,220),
        Color(0,0,0,200),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )


    local rightX = ScrW() - 30
    local topY = 22

    DrawTextShadow(
        "Highborn",
        "HB_HUD_Title",
        rightX,
        topY,
        Color(255,255,255),
        Color(0,0,0,180),
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_TOP
    )

    DrawTextShadow(
        os.date("%d.%m.%y  %H:%M"),
        "HB_HUD_Small",
        rightX,
        topY + 30,
        Color(180,180,180),
        Color(0,0,0,160),
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_TOP
    )

    draw.RoundedBox(0, rightX + 8, topY + 2, 2, 48, Color(80,140,220))
end)
