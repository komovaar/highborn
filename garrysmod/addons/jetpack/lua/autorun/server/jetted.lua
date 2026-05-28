hook.Add('DoPlayerDeath','Jetted',function(ply)
	local jet = ply:GetNWEntity('Jetted')
	if !IsValid(jet) then return end

	if jet.HighbornVendorJetpack and ply.WOS_IncapMe then return end

	jet:Remove()
end)

hook.Add("PlayerButtonDown", "JetpackToggle", function(ply, button)

	if button ~= KEY_F4 then return end

	local jp = ply:GetNWEntity("Jetted")
	if not IsValid(jp) then return end

	jp:SetEnabled( not jp:GetEnabled() )

	if not jp:GetEnabled() then
		jp:SetActive(false)
	end

end)
