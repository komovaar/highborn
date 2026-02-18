--[[-------------------------------------------------------------------
	The Last Stand Client Core:
		Core files in client form
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2018 ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
]]--

local w,h = ScrW(), ScrH()

wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}

wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

net.Receive( "wOS.LastStand.ToggleLS", function()

	local toggle = net.ReadBool()
	local ent = net.ReadEntity()
	
	wOS.LastStand.InLastStand[ ent ] = toggle
	
end )

net.Receive( "wOS.LastStand.SendLastCache", function()

	local num = net.ReadInt( 32 )
	
	for i=1, num do
		local id = net.ReadEntity()
		if wOS.LastStand.InLastStand[ id ] then continue end
		wOS.LastStand.InLastStand[ id ] = net.ReadBool()
	end
	
end )

hook.Add( "CalcView", "wOS.LastStand.FirstPerson", function( ply, pos, ang )

	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	if !wOS.LastStand.InLastStand[ ply ] and !ply.WOS_LastStandIsReviving then return end

	local cammode = wOS.LastStand.CameraMode:GetInt()
	if cammode == 0 then
		local angs = ang
		local eyes = ply:GetAttachment( ply:LookupAttachment( "eyes" ) );
		angs = eyes.Ang
		local forward = ang:Forward()
		local up = ang:Up()
		
		return {
			origin = eyes.Pos + ( up + forward )*1.5,
			angles = angs,
			fov = GetConVar( "fov_desired" ):GetInt(), 
			drawviewer = true
		}
	elseif cammode == 2 then
		local trace = util.TraceHull( {
			start = pos,
			endpos = pos - ang:Forward() * 100,
			filter = { ply:GetActiveWeapon(), ply },
			mins = Vector( -4, -4, -4 ),
			maxs = Vector( 4, 4, 4 ),
		} )

		if ( trace.Hit ) then pos = trace.HitPos else pos = pos - ang:Forward() * 100 end

		return {
			origin = pos,
			angles = ang,
			drawviewer = true
		}
	end

end )

hook.Add( "HUDPaint", "wOS.LastStand.ProgressBar", function()
	local ply = LocalPlayer()
	if not IsValid( ply.WOS_LastStandChild ) or not ply.WOS_LastStandHeld or not ply.WOS_LastStandIsReviving then return end

	local tim = wOS.LastStand.ReviveTime:GetFloat()
	local rat = math.Clamp( CurTime() - ply.WOS_LastStandHeld, 0, tim ) / tim
	
	local ww, hh = w*0.3, h*0.03
	
	draw.RoundedBox( 9, w*0.5 - ww/2, h*0.6, ww, hh, Color( 0, 0, 0, 55 ) )
	draw.RoundedBox( 12, w*0.5 - ww/2, h*0.6, ww*rat, hh, Color( 0, 125, 255, 155 ) )
	local text = ( rat >= 1 and "Release your USE key!" ) or "Reviving " .. ply.WOS_LastStandChild:Nick() .. " ( " .. math.Round( rat * 100 ) .. "% )"
	draw.SimpleText( text, "CloseCaption_BoldItalic", w/2, h*0.6 + hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
end )

local lastuse = 0
hook.Add( "HUDPaint", "wOS.LastStand.KillYourselfHUD", function()
	local ply = LocalPlayer()
	if not wOS.LastStand.InLastStand[ LocalPlayer() ] then return end
	
	local tim = 3
	local rat = math.Clamp( lastuse, 0, tim ) / tim
	
	local ww, hh = w*0.3, h*0.03
	draw.RoundedBox( 9, w*0.5 - ww/2, h*0.6, ww, hh, Color( 0, 0, 0, 55 ) )
	draw.RoundedBox( 12, w*0.5 - ww/2, h*0.6, ww*rat, hh, Color( 255, 255, 255, 155 ) )
	draw.SimpleText( "Hold down your USE key to end it all ( " .. math.Round( rat * 100 ) .. "% )", "CloseCaption_BoldItalic", w/2, h*0.6 + hh/2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
end )

hook.Add( "Think", "wOS.LastStand.KillYourself", function()
	if not wOS.LastStand.InLastStand[ LocalPlayer() ] then return end
	if not LocalPlayer():Alive() then return end
	if LocalPlayer():KeyDown( IN_USE ) then
		if not lastuse then lastuse = 0 end
		lastuse = lastuse + FrameTime()
	else
		lastuse = 0
	end
	if not lastuse then return end
	if lastuse >= 3 then
		net.Start( "wOS.LastStand.RequestSuicide" )
		net.SendToServer()
		lastuse = 0
	end
end )

hook.Add( "CreateMove", "wOS.LastStand.PreventAttack", function( cmd/* ply, mv, cmd*/ )
	if !wOS.LastStand.InLastStand[ LocalPlayer() ] and !LocalPlayer():GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	cmd:RemoveKey( IN_JUMP )
	cmd:SetButtons( bit.bor( cmd:GetButtons(), IN_DUCK ) )
	if wOS.LastStand.CanShoot:GetBool() and !LocalPlayer():GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	cmd:RemoveKey( IN_ATTACK )
	cmd:RemoveKey( IN_ATTACK2 )
end )
