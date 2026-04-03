local launcher = {
	["rw_sw_plx1"] = true,
	["rw_sw_rps6"] = true,
	["rw_sw_rps4"] = true,
	["rw_sw_smartlauncher"] = true,
	["rw_sw_e60r"] = true,
	["rw_sw_hh12"] = true,
	["rw_sw_hh15"] = true,
}

hook.Add("PostDrawOpaqueRenderables", "Joe_shit", function()
  for _,v in ipairs(player.GetAll()) do
	if not v:Alive() then continue end
	local wep = v:GetActiveWeapon()
	if not IsValid(wep) or not launcher[wep:GetClass()] then continue end
		if wep:IsAttached("rocket_mod_pointing") then
			local tr = v:GetEyeTrace()
			local pos = tr.HitPos
			local angle = tr.HitNormal:Angle()
			angle:RotateAroundAxis(angle:Right(), -90)
			cam.Start3D2D( pos - angle:Right()*8 - (angle:Up() *-1) + (angle:Forward() *-7), angle, 0.1 )
			surface.SetDrawColor(255,0,0)
			surface.SetMaterial(Material("sprites/glow04_noz"))
			surface.DrawTexturedRect(0, 0, 150, 150)
			cam.End3D2D()
		end
  	end
end)