DEATHSCREEN_RULES = "Ви мертві!"

hook.Add("CreateClientsideRagdoll","hb_hide_cl_ragdolls",function(ownEnt,ragEnt)
    if ragEnt:GetClass() == "class C_HL2MPRagdoll" then
        ragEnt:SetNoDraw(true)
    end
end)

lDeathscreen = nil

net.Receive("hb_deathscreen",function()

    local deathTime = net.ReadInt(15)
    local endTime = CurTime() + deathTime

    if deathTime < 0 then
      if IsValid(lDeathscreen) then
          lDeathscreen:Remove()
      end
      return
    end

    if IsValid(lDeathscreen) then lDeathscreen:Remove() end

  lDeathscreen = vgui.Create("DFrame")
  lDeathscreen:SetDraggable(false)
  lDeathscreen:ShowCloseButton(false)
  lDeathscreen:SetTitle("")
  lDeathscreen:SetPos(0,0)
  lDeathscreen:SetSize(ScrW(),ScrH())

    local barHeight = ScrH() * 0.2

    function lDeathscreen:Paint(w,h)

    draw.RoundedBox(0, 0, 0, w, barHeight, Color(0,0,0,255))

    draw.RoundedBox(0, 0, h-barHeight, w, barHeight, Color(0,0,0,255))

    draw.RoundedBox(0, 0, barHeight, w, h-barHeight*2, Color(30,30,30,220))

    DrawTextShadow(DEATHSCREEN_RULES, "HB_HUD_Title", w/2, h/2, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_CENTER)

    DrawTextShadow("Відродження через "..math.max(math.Round(endTime-CurTime(),1),0), "HB_HUD_Title", w/2, h/2 + 20, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_CENTER)

end
end)