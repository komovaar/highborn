if SERVER then
	hook.Add("PlayerEnteredVehicle", "mountPods", function(ply, veh, role )
		if veh:GetClass() == "prop_vehicle_prisoner_pod" and veh.mountPod then
			local mounted_npc = veh:GetParent()
				if IsValid( mounted_npc ) then
				
				if ( mounted_npc:IsNPC() or mounted_npc:IsNextBot() ) then
					local rider = veh:GetDriver()
					local vehangles = veh:GetAngles()
					mounted_npc:AddEntityRelationship( rider, D_LI, 99 )
					FakeRiderModel = rider:GetModel()
					veh:SetModel(FakeRiderModel)
					rider:ExitVehicle()
					if mounted_npc:GetClass() == "npc_drg_rancor_mount" then
						veh:SetLocalAngles(Angle(0,90,0))
					else
						veh:SetLocalAngles(Angle(0,0,0))
					end
					veh:RemoveEffects(EF_NODRAW)
					veh:SetSequence( "sit" )
						local possess = mounted_npc:Possess(rider)
						if possess == "ok" then
							net.Start("DrGBaseNextbotCanPossess")
							net.WriteEntity(mounted_npc)
						end
						net.WriteString(possess)
						net.Send(rider)
				end
			end
		end
	end)
end