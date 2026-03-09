wOS = wOS or {}
wOS.LastStand = wOS.LastStand or {}
wOS.LastStand.InLastStand = wOS.LastStand.InLastStand or {}

hook.Add( "ScalePlayerDamage", "wOS.LastStand.Reduce", function( ply, hitgroup, dmginfo )
	if ply:WOSGetIncapped() then 
		dmginfo:ScaleDamage( 0.1 ) 
	end
end )

hook.Add( "EntityTakeDamage", "wOS.LastStand.Incap", function( ply, dmginfo ) 
	if not ply:IsPlayer() then return end
	if ply:WOSGetIncapped() then return end
	if not ply:Alive() then return end
	if ply:HasGodMode() then return end
	local diff = ply:Health() - dmginfo:GetDamage()

	if diff <= 0 then
		ply.WOS_IncapMe = true

		if not ply:IsBot() then
			ply:ConCommand("wos_ls_force_incap")
		else
			ply:WOSIncap()
		end

		dmginfo:SetDamage(0)
		return true
	end
	local bypass_down = hook.Call( "wOS.LastStand.ShouldIncap", nil, ply, dmg, dmginfo )
	if ( isbool( bypass_down ) ) then
		if not bypass_down then return end
	end
	if bypass_down or diff <= ply:GetMaxHealth()*wOS.LastStand.Percent:GetFloat() then
		ply.WOS_IncapMe = true
		if !ply:IsBot() then
			ply:ConCommand( "wos_ls_force_incap" )
		else
			ply:WOSIncap()
		end
	end
end )

hook.Add( "Think", "wOS.LastStand.Bleedout", function()
	local bleed = wOS.LastStand.BleedOutSpeed:GetFloat()
	if bleed <= 0 then return end
	local downpercent = wOS.LastStand.Percent:GetFloat()
	if downpercent <= 0 then return end
	for ply, _ in pairs( wOS.LastStand.InLastStand ) do
		if not IsValid( ply ) then continue end
		if not ply:WOSGetIncapped() then continue end
		if not ply.WOS_NextLSHurt then ply.WOS_NextLSHurt = 0 end
		if ply.WOS_NextLSHurt >= CurTime() then continue end
		ply:TakeDamage( ply:GetMaxHealth()*downpercent*bleed )
		ply.WOS_NextLSHurt = CurTime() + 1
	end
end )

hook.Add( "EntityTakeDamage", "wOS.LastStand.ReviveOnKill", function( ent, dmginfo )
	if not wOS.LastStand.ReviveOnKill:GetBool() then return end
	if not ent:IsNPC() and not ent:IsPlayer() then return end
	local att = dmginfo:GetAttacker()
	if not IsValid( att ) or not att:IsPlayer() then return end
	
	if not att:WOSGetIncapped() then return end
	
	local dmg = dmginfo:GetDamage()
	if dmg < ent:Health() then return end
	att.WOS_ReviveMe = true
	att:ConCommand( "wos_ls_force_revive" )
end )

hook.Add( "PlayerDeath", "wOS.LastStand.UndoLastStand", function( ply, hitgroup, dmginfo )
	ply:WOSRevive( true )
end )

hook.Add( "PlayerDisconnected", "wOS.LastStand.UndoLastStand", function( ply, hitgroup, dmginfo )
	wOS.LastStand.InLastStand[ ply ] = nil
end )

hook.Add( "PlayerInitialSpawn", "wOS.LastStand.SendLastStands", function( ply, hitgroup, dmginfo )
	net.Start( "wOS.LastStand.SendLastCache" )
		net.WriteInt( #wOS.LastStand.InLastStand, 32 )
		for id, status in pairs( wOS.LastStand.InLastStand ) do
			net.WriteEntity( id )
			net.WriteBool( status )
		end
	net.Send( ply )
end )

local meta = FindMetaTable( "Player" )

function meta:WOSGetIncapped()
	return self.WOS_InLastStand
end

function meta:WOSSetIncap( bool )
	self.WOS_InLastStand = bool
end

function meta:WOSIncap()
	if self:WOSGetIncapped() then return end
	self.WOS_LastSMinHull, self.WOS_LastSMaxHull = self:GetHull()
	self.WOS_LastSCMinHull, self.WOS_LastSCMaxHull = self:GetHullDuck()
	self:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 24 ) )
	self:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 24 ) )
	self:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE, 981 )	
	self:WOSSetIncap( true )
	wOS.LastStand.InLastStand[ self ] = true
	net.Start( "wOS.LastStand.ToggleLS" )
		net.WriteBool( true )
		net.WriteEntity( self )
	net.Broadcast()
end

function meta:WOSRevive( respawn )
	if !self:WOSGetIncapped() then return end
	self:SetHull( self.WOS_LastSMinHull, self.WOS_LastSMaxHull )
	self:SetHullDuck( self.WOS_LastSCMinHull, self.WOS_LastSCMaxHull )
	self:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE, 982 )
	self:WOSSetIncap( false )
	wOS.LastStand.InLastStand[ self ] = nil
	net.Start( "wOS.LastStand.ToggleLS" )
		net.WriteBool( false )
		net.WriteEntity( self )
	net.Broadcast()
	if not respawn then
		self:SetHealth( math.max( wOS.LastStand.RevivePercent:GetFloat()*self:GetMaxHealth(), self:Health() ) )
	end
end

--If you ask me a question about why I'm using console commands trust me, this shit is golden
concommand.Add( "wos_ls_force_incap", function( ply, cmd, args )
	if not ply.WOS_IncapMe then return end
	ply:WOSIncap()
	ply.WOS_IncapMe = nil
end )

concommand.Add( "wos_ls_force_revive", function( ply, cmd, args )
	if not ply.WOS_ReviveMe then return end
	ply:WOSRevive()
	ply.WOS_ReviveMe = nil
end )

hook.Add("PlayerUse", "wOS.LastStand.BlockReviveWhileDown", function(ply, ent)
    if ply:WOSGetIncapped() then
        return false
    end
end)