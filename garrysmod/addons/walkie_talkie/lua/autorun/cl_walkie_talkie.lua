if CLIENT then
    local radio_s = false
    local micro_s = false

    hook.Add("PlayerButtonDown", "WalkieTalkie_ClientButtons", function(ply, button)
        if ply ~= LocalPlayer() then return end
        if button == KEY_N then
            net.Start("WalkieTalkie.SpeakerToggle")
            net.SendToServer()
            radio_s = not radio_s
        elseif button == KEY_M then
            net.Start("WalkieTalkie.MicroToggle")
            net.SendToServer()
            micro_s = not micro_s
        end

        local main = LocalPlayer():GetNW2Var("radio_main")
        local alt  = LocalPlayer():GetNW2Var("radio_alt")
        local active = LocalPlayer():GetNW2Var("radio_active")

        if button == KEY_L and alt then
            if active == main then 
                active = alt 
            else 
                active = main
            end
            net.Start("WalkieTalkie.SetActiveChannel")
            net.WriteInt(active, 8)
            net.SendToServer()
        end

    end)

    hook.Add("HUDPaint", "WalkieTalkie_HUDPaint", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local main = ply:GetNW2Var("radio_main") or "—"
        local alt  = ply:GetNW2Var("radio_alt") or "—"
        local active = ply:GetNW2Var("radio_active") or "-"

        local radio_status = radio_s and "Увімкнутий" or "Вимкнутий"
        local micro_status = micro_s and "Увімкнута" or "Вимкнута"

        local sh = ScrH()
        DrawTextShadow("Передача: "..active, "HB_HUD_Main", 20, sh-100, Color(255,255,255), Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Рація: "..radio_status.." (F4)", "HB_HUD_Main", 20, sh-80, Color(255,255,255), Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Мікрофон: "..micro_status.." (F5)", "HB_HUD_Main", 20, sh-60, Color(255,255,255), Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Основной канал: "..main, "HB_HUD_Main", 20, sh-40, mainColor, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        DrawTextShadow("Вспомогательный: "..alt, "HB_HUD_Main", 250, sh-40, altColor, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end)

end
