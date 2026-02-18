
--[[-------------------------------------------------------------------
	The Last Stand Server Net:
		Net functons for the server to use
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

util.AddNetworkString( "wOS.LastStand.ToggleLS" )
util.AddNetworkString( "wOS.LastStand.SendLastCache" )
util.AddNetworkString( "wOS.LastStand.RequestSuicide" )

net.Receive( "wOS.LastStand.RequestSuicide", function( len, ply )

	if not ply:WOSGetIncapped() then return end
	ply:Kill()

end )