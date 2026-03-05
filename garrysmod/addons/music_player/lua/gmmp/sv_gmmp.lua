	--------------------------------------------------------------------------------------------------------
	--          _____                    _____                    _____                    _____          --
	--         /\    \                  /\    \                  /\    \                  /\    \         --
	--        /::\    \                /::\____\                /::\____\                /::\    \        --
	--       /::::\    \              /::::|   |               /::::|   |               /::::\    \       --
	--      /::::::\    \            /:::::|   |              /:::::|   |              /::::::\    \      --
	--     /:::/\:::\    \          /::::::|   |             /::::::|   |             /:::/\:::\    \     --
	--    /:::/  \:::\    \        /:::/|::|   |            /:::/|::|   |            /:::/__\:::\    \    --
	--   /:::/    \:::\    \      /:::/ |::|   |           /:::/ |::|   |           /::::\   \:::\    \   --
	--  /:::/    / \:::\    \    /:::/  |::|___|______    /:::/  |::|___|______    /::::::\   \:::\    \  --
	-- /:::/    /   \:::\ ___\  /:::/   |::::::::\    \  /:::/   |::::::::\    \  /:::/\:::\   \:::\____\ --
	--/:::/____/  ___\:::|    |/:::/    |:::::::::\____\/:::/    |:::::::::\____\/:::/  \:::\   \:::|    |--
	--\:::\    \ /\  /:::|____|\::/    / ~~~~~/:::/    /\::/    / ~~~~~/:::/    /\::/    \:::\  /:::|____|--
	-- \:::\    /::\ \::/    /  \/____/      /:::/    /  \/____/      /:::/    /  \/_____/\:::\/:::/    / --
	--  \:::\   \:::\ \/____/               /:::/    /               /:::/    /            \::::::/    /  --
	--   \:::\   \:::\____\                /:::/    /               /:::/    /              \::::/    /   --
	--    \:::\  /:::/    /               /:::/    /               /:::/    /                \::/____/    --
	--     \:::\/:::/    /               /:::/    /               /:::/    /                  ~~          --
	--      \::::::/    /               /:::/    /               /:::/    /                               --
	--       \::::/    /               /:::/    /               /:::/    /                                --
	--        \::/____/                \::/    /                \::/    /                                 --
	--                                  \/____/                  \/____/                                  --
	--------------------------------------------------------------------------------------------------------

	resource.AddWorkshop( "306423885" ) --Will add materials
		
	--Serverside override
		
	--hook.Add("PostGamemodeLoaded", "CleanUpMapOverrideServerSide", function()
		--if gamemode.Get( "terrortown" ) then 
		
			--OldCleanUpMap = OldCleanUpMap or game.CleanUpMap
		
			--function game.CleanUpMap(_, extraFilters)
				--return OldCleanUpMap(true, extraFilters)
			--end
		--end
	--end)

	function SendToggleMenu( ply, strKey )
		if TogKey:GetString() == strKey then
			ply:SendLua("ToggleMenu()")
		end
	end

	hook.Add("OnPlayerChat", "AdminChatMenuCommands", function(ply, text, teamChat, isDead)
		if ply ~= LocalPlayer() then return end
		if not ply:IsAdmin() then return end

		text = string.lower(text)

		if text == "/music" then
			SendToggleMenu(ply, "F4")
			return ""
		end
	end)

		
	--FCVAR_ARCHIVE stores the value in the config.cfg file
	DoRes = CreateConVar( "gmmp_autoresource", 1, FCVAR_ARCHIVE, "If set to 1 then songs in garrysmod\\sound\\gmmp will automatically be added to the download list")
	TogKey = CreateConVar( "gmmp_menukey", "F4", FCVAR_ARCHIVE, "The function key that will toggle the menu")
	GlobalPass = CreateConVar( "gmmp_globalpass", "", FCVAR_ARCHIVE, "The password for players that aren't admins to play songs to everyone")


	--Declaring network names for sending information between server and client
	util.AddNetworkString( "DoResChange" )
	util.AddNetworkString( "RequestDoRes" )
	util.AddNetworkString( "SendDoRes" )

	util.AddNetworkString( "TogKeyChange" )
	util.AddNetworkString( "RequestTogKey" )
	util.AddNetworkString( "SendTogKey" )

	util.AddNetworkString( "GlobalPassChange" )
	util.AddNetworkString( "RequestGlobalPass" )
	util.AddNetworkString( "SendGlobalPass" )
		
	util.AddNetworkString( "PlayGlobal" )
	util.AddNetworkString( "BroadcastSong" ) 
		
		
	net.Receive( "PlayGlobal", function( length, sender )
		local PlayerPass = net.ReadString()
		if sender:IsValid() and (sender:IsAdmin() or(GlobalPass:GetString() ~=  "" and GlobalPass:GetString() == PlayerPass)) then
			local strFilePath = net.ReadString()
			net.Start( "BroadcastSong" )
				net.WriteString( strFilePath )
				net.WriteEntity( sender )
			net.Send( player.GetAll() )
		else
			sender:SendLua("chat.AddText('Wrong Play to everyone password')")
		end
	end )

	net.Receive( "RequestDoRes", function( length, sender )
		if sender:IsValid() and sender:IsSuperAdmin() then
			net.Start( "SendDoRes" )
				net.WriteString( DoRes:GetInt() )
			net.Send( sender )
		end
	end )
		
	net.Receive( "DoResChange", function( length, sender ) --Receiving a new DoRes setting from a client
		if sender:IsValid() and sender:IsSuperAdmin() then
			RunConsoleCommand( "gmmp_autoresource", net.ReadString() )
		end
	end )

	net.Receive( "RequestTogKey", function( length, sender )
		if sender:IsValid() and sender:IsSuperAdmin() then
			net.Start( "SendTogKey" )
				net.WriteString( TogKey:GetString() )
			net.Send( sender )
		end
	end )

	net.Receive( "RequestGlobalPass", function( length, sender )
		if sender:IsValid() and sender:IsSuperAdmin() then
			net.Start( "SendGlobalPass" )
				net.WriteString( GlobalPass:GetString() )
			net.Send( sender )
		end
	end )
		
	net.Receive( "TogKeyChange", function( length, sender ) --Receiving a new TogKey setting from a client
		if sender:IsValid() and sender:IsSuperAdmin() then
			RunConsoleCommand( "gmmp_menukey", net.ReadString())
		end
	end )

	net.Receive( "GlobalPassChange", function( length, sender ) --Receiving a new GlobalPass setting from a client
		if sender:IsValid() and sender:IsSuperAdmin() then
			RunConsoleCommand( "gmmp_globalpass", net.ReadString())
		end
	end )
		
	function AddContent( path ) --Adding songs to resources
		local songs, folders = file.Find( path .. "/*", "GAME" )
		for k, v in pairs( songs ) do
			resource.AddFile( path .. "/" .. v )
		end
		
		for k, v in pairs( folders ) do
			AddContent( path .. "/" .. v )
		end
	end
		
	if DoRes:GetInt() >= 1 then
		AddContent( "sound/gmmp" )
	end
		
	cvars.AddChangeCallback( "gmmp_autoresource", function() --Send new value to all super admins
		
		local SuperAdmins = {}
		
		for key, v in pairs( player.GetAll() ) do
			if v:IsSuperAdmin() then
				table.insert( SuperAdmins, v )
			end
		end
			
		net.Start( "SendDoRes" )
				net.WriteString( DoRes:GetInt() )
		net.Send( SuperAdmins )
			
	end )

	cvars.AddChangeCallback( "gmmp_menukey", function() --Send new value to all super admins
		
		local SuperAdmins = {}
		
		for key, v in pairs( player.GetAll() ) do
			if v:IsSuperAdmin() then
				table.insert( SuperAdmins, v )
			end
		end
			
		net.Start( "SendTogKey" )
				net.WriteString( TogKey:GetString() )
		net.Send( SuperAdmins )
			
	end )

	cvars.AddChangeCallback( "gmmp_globalpass", function() --Send new value to all super admins
		
		local SuperAdmins = {}
		
		for key, v in pairs( player.GetAll() ) do
			if v:IsSuperAdmin() then
				table.insert( SuperAdmins, v )
			end
		end
			
		net.Start( "SendGlobalPass" )
				net.WriteString( GlobalPass:GetString() )
		net.Send( SuperAdmins )
			
	end )

	print( "GMMP v3.7.1 loaded -- Made by Declivity http://steamcommunity.com/profiles/76561198024690138/" )