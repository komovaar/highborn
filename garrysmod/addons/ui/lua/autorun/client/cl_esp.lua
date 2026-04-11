hook.Add("HUDPaint", "AdminNoclipESP", function()

    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if ply:GetMoveType() ~= MOVETYPE_NOCLIP then return end
    if ply:InVehicle() then return end
    if not ply:IsAdmin() then return end

    for _, target in ipairs(player.GetAll()) do
        if not IsValid(target) or target == ply then continue end
        if not target:Alive() then continue end

        local pos = target:EyePos():ToScreen()

        draw.SimpleTextOutlined(
            target:Nick(),
            "DermaDefault",
            pos.x,
            pos.y,
            Color(255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            1,
            Color(0,0,0)
        )

        draw.SimpleTextOutlined(
            "HP: "..target:Health(),
            "DermaDefault",
            pos.x,
            pos.y + 12,
            Color(0,255,0),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            1,
            Color(0,0,0)
        )

        local traceLength = 100
        local eyePos = target:EyePos()
        local aimDir = target:EyeAngles():Forward()
        local endPos = eyePos + aimDir * traceLength

        local screenStart = eyePos:ToScreen()
        local screenEnd = endPos:ToScreen()

        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawLine(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y)
    end
end)