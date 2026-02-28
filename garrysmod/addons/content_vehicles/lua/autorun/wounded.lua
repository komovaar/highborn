local Category = "[LVS] Republic Vehicle"

local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE_PASSIVE )
end

local V = {
	Name = "Stretcher pod",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,
	Author = "",
	Information = "Seat for wounded.",
	Offset = 0,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	
	Members = {
		HandleAnimation = StandAnimation
	}
}
list.Set( "Vehicles", "wounded", V )