util.AddNetworkString( "wOS.LastStand.ToggleLS" )
util.AddNetworkString( "wOS.LastStand.SendLastCache" )
util.AddNetworkString( "wOS.LastStand.RequestSuicide" )

net.Receive( "wOS.LastStand.RequestSuicide", function( len, ply )

	if not ply:WOSGetIncapped() then return end
	ply:Kill()

end )