
--[[-------------------------------------------------------------------
	The Last Stand Shared Core:
		Core files in shared form
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


wOS.LastStand.ReviveTime = CreateConVar( "wos_ls_revivetime", "5", { FCVAR_ARCHIVE, FCVAR_REPLICATED  }, "How long ( in seconds ) does it take for you to revive someone? Default: 5" )
wOS.LastStand.Percent = CreateConVar( "wos_ls_percent", "0.25", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "At what percent of a person's health do they go down? Default: 0.25 (25 Percent)" )
wOS.LastStand.CanShoot = CreateConVar( "wos_ls_canshoot", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Should downed players be able to shoot their gun? Default: 1" )
wOS.LastStand.RevivePercent = CreateConVar( "wos_ls_revived_percent", "0.5", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "At what percent of their health do revived players be put to? Default: 0.5 (50 Percent)" )
wOS.LastStand.JobRestrict = CreateConVar( "wos_ls_enable_jobrestrict", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Should reviving be restricted to specific jobs? REQUIRES EXTRA CONFIG. Default: 0" )
wOS.LastStand.CanCrawl = CreateConVar( "wos_ls_cancrawl", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Should downed players be able to crawl slowly? Default: 0" )
wOS.LastStand.ReviveOnKill = CreateConVar( "wos_ls_enable_reviveonkill", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Should downed players be revived if they can kill someone while downed? Default: 0" )
wOS.LastStand.BleedOutSpeed = CreateConVar( "wos_ls_bleedoutspeed", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "What percentage of their downed health should downed players lose over time? Set to 0 to disable bleed out. Default: 0" )
wOS.LastStand.CameraMode = CreateConVar( "wos_ls_cameramode", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, [[What camera mode should downed players be put in? Default: 1

	0 = Cinematic First Person ( Camera Attached to Player Eyes )
	1 = Standard First Person ( Regular First Person )
	2 = Standard Third Person ( Completely Third Person )]]  )

wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}
wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

wOS.LastStand.JobTable = {}

function wOS.LastStand:AddJob( teamnum )
	if not teamnum then return end
	wOS.LastStand.JobTable[ teamnum ] = true
end

hook.Add( "DoAnimationEvent" , "wOS.LastStand.CallIncap" , function( ply, event, data )
	if event == PLAYERANIMEVENT_ATTACK_GRENADE  then
		local seq
		if data == 981 then
			seq = ply:LookupSequence( "wos_l4d_collapse_to_incap" )
		elseif data == 982 then
			seq = ply:LookupSequence( "wos_l4d_getup_from_pounced" )
		end
		if not seq or seq < 0 then return end
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, seq, 0, true ) 
		return ACT_INVALID
	end
end )

hook.Add( "CalcMainActivity", "wOS.LastStand.IdleAnim", function( ply )
	if !wOS.LastStand.InLastStand[ ply ] and !ply:GetNW2Bool( "wOS.LS.IsReviving", false ) then return end
	local seq = ply:LookupSequence( "wos_l4d_idle_incap_pistol" )
	if ply:GetNW2Bool( "wOS.LS.IsReviving", false ) then
		seq = ply:LookupSequence( "wos_l4d_heal_incap_crouching" )
	end
	if seq < 0 then return end
	return -1, seq
end )

hook.Add( "Move", "wOS.LastStand.DontMove", function( ply, mv ) 
	if !wOS.LastStand.InLastStand[ ply ] and !ply.WOS_LastStandIsReviving then return end
	if wOS.LastStand.InLastStand[ ply ] and wOS.LastStand.CanCrawl:GetBool() then
		mv:SetMaxClientSpeed( 20 )
	else
		mv:SetForwardSpeed( 0.1 )
		mv:SetSideSpeed( 0.1 )
		mv:SetUpSpeed( 0.1 )	
	end
end )

hook.Add( "KeyPress", "wOS.LastStand.ReviveCheck", function( ply, key )
	if wOS.LastStand.JobRestrict:GetBool() and not wOS.LastStand.JobTable[ ply:Team() ] then return end
	if ply.WOS_LastStandKT and ply.WOS_LastStandKT >= CurTime() then return	end
	if ( key == IN_USE ) and ply:KeyDown( IN_DUCK ) then
		local tr = util.TraceLine( util.GetPlayerTrace( ply ) )
		if tr.Entity and tr.Entity:GetPos():DistToSqr( ply:GetPos() ) <= 7000 and tr.Entity:IsPlayer() then
			if wOS.LastStand.InLastStand[ tr.Entity ] then
				ply.WOS_LastStandIsReviving = true
				ply:SetCycle( 0 )
				ply.WOS_LastStandHeld = CurTime()
				ply.WOS_LastStandChild = tr.Entity
				if SERVER then
					ply:SetNW2Bool( "wOS.LS.IsReviving", true )
				end
			end
		end
		ply.WOS_LastStandKT = CurTime() + 0.2
	end
end )

hook.Add( "KeyRelease", "wOS.LastStand.ReviveUncheck", function( ply, key )
	if ply.WOS_LastStandIsReviving and ( key == IN_USE ) then
		ply.WOS_LastStandKT = CurTime() + 0.2
		ply.WOS_LastStandIsReviving = false
		if SERVER then
			ply:SetNW2Bool( "wOS.LS.IsReviving", false )
			if CurTime() - ply.WOS_LastStandHeld >= wOS.LastStand.ReviveTime:GetFloat() then
				if IsValid( ply.WOS_LastStandChild ) and ply.WOS_LastStandChild:WOSGetIncapped() then
					ply.WOS_LastStandChild.WOS_ReviveMe = true
					if !ply.WOS_LastStandChild:IsBot() then
						ply.WOS_LastStandChild:ConCommand( "wos_ls_force_revive" )
					else
						ply.WOS_LastStandChild:WOSRevive()
					end
				end
			end
		end
		ply.WOS_LastStandChild = nil
		ply.WOS_LastStandHeld = nil
	end
end )
