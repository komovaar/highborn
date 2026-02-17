if CLIENT then
    local radio_s = false
    local micro_s = false

    hook.Add("PlayerButtonDown", "WalkieTalkie_ClientButtons", function(ply, button)
        if ply ~= LocalPlayer() then return end

        if button == KEY_F4 then
            net.Start("WalkieTalkie.SpeakerToggle")
            net.SendToServer()
            radio_s = not radio_s
        end

        if button == KEY_F5 then
            net.Start("WalkieTalkie.MicroToggle")
            net.SendToServer()
            micro_s = not micro_s
        end
    end)

    hook.Add("HUDPaint", "WalkieTalkie_HUDPaint", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        if not ply:GetNW2Var("hborn_radio") then return end

        local sw, sh = ScrW(), ScrH()
        local radio_status = radio_s and "Увімкнутий" or "Вимкнутий"
        local micro_status = micro_s and "Увімкнута" or "Вимкнута"
        local channel = ply:GetNW2Var("hborn_radio") or "Відсутній"

        DrawTextShadow("Рація: " .. radio_status .. " (F4)", "HB_HUD_Main", 20, sh - 60, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Мікрофон: " .. micro_status .. " (F5)", "HB_HUD_Main", 20, sh - 40, Color(255, 255, 255), Color(0, 0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Канал: " .. channel, "HB_HUD_Main", 20, sh - 20, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end)

    concommand.Add("radio_set_channel", function(_, _, args)
        local channel = tonumber(args[1])
        if not channel then return end
        net.Start("WalkieTalkie.ChangeChannel")
        net.WriteInt(channel, 8)
        net.SendToServer()
    end)
end
