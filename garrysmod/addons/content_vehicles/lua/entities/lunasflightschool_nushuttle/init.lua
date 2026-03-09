-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName ) -- called by garry
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply  -- this is important
	ent:SetPos( tr.HitPos + tr.HitNormal * 20 ) -- spawn 20 units above ground
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick()
	--[[ self:DisableWep( self:GetLGear() < 0.99 )

	if self:HitGround() then
		if self:GetThrottlePercent() < 10 then
			self:DeployLandingGear()
		end
	else
		self:RaiseLandingGear()
		
	end ]]
end

function ENT:HitGround()
	local tr = util.TraceLine( {
		start = self:LocalToWorld( Vector(0,0,100) ),
		endpos = self:LocalToWorld( Vector(0,0,-500) ),
		filter = function( ent ) 
			if ( ent == self ) then 
				return false
			end
		end
	} )
	
	return tr.Hit 
end

function ENT:RunOnSpawn() -- called when the vehicle is spawned
	
	self:GetDriverSeat().ExitPos = Vector(100,0,185)
	local Seat1 = self:AddPassengerSeat(Vector(0,-50,200),Angle(0,0,0))
	Seat1.ExitPos = Vector(0,-10,200)
	local Seat2 = self:AddPassengerSeat(Vector(-25,-50,200),Angle(0,0,0))
	Seat2.ExitPos = Vector(-25,-10,200)
	local Seat3 = self:AddPassengerSeat(Vector(-55,-50,200),Angle(0,0,0))
	Seat3.ExitPos = Vector(-55,-10,200)
	local Seat4 = self:AddPassengerSeat(Vector(-85,-50,200),Angle(0,0,0))
	Seat4.ExitPos = Vector(-85,-10,200)
	local Seat5 = self:AddPassengerSeat(Vector(-110,-50,200),Angle(0,0,0))
	Seat5.ExitPos = Vector(-110,-10,200)
	local Seat6 = self:AddPassengerSeat(Vector(-140,-50,200),Angle(0,0,0))
	Seat6.ExitPos = Vector(-140,-10,200)
	local Seat7 = self:AddPassengerSeat(Vector(-170,-50,200),Angle(0,0,0))
	Seat7.ExitPos = Vector(-160,-10,200)

	local Seat8 = self:AddPassengerSeat(Vector(0,50,200),Angle(0,180,0))
	Seat8.ExitPos = Vector(0,20,200)
	local Seat9 = self:AddPassengerSeat(Vector(-25,50,200),Angle(0,180,0))
	Seat9.ExitPos = Vector(-25,20,200)
	local Seat10 = self:AddPassengerSeat(Vector(-55,50,200),Angle(0,180,0))
	Seat10.ExitPos = Vector(-55,20,200)
	local Seat11 = self:AddPassengerSeat(Vector(-85,50,200),Angle(0,180,0))
	Seat11.ExitPos = Vector(-85,20,200)
	local Seat12 = self:AddPassengerSeat(Vector(-110,50,200),Angle(0,180,0))
	Seat12.ExitPos = Vector(-110,20,200)
	local Seat13 = self:AddPassengerSeat(Vector(-140,50,200),Angle(0,180,0))
	Seat13.ExitPos = Vector(-140,20,200)
	local Seat14 = self:AddPassengerSeat(Vector(-170,50,200),Angle(0,180,0))
	Seat14.ExitPos = Vector(-160,20,200)
	self:PlayAnimation( "wings_close" )

end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimary( 0.20 )
	
	--[[ do primary attack code here ]]--
	
	self:EmitSound( "VANILLA_NUSHUTTLE_FIRE" )

		local Driver = self:GetDriver()

		local fp = {Vector(220,223,140),Vector(220,-223,140), Vector(200,223,120),Vector(200,-223,120)}
	
		self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
		if self.NumPrim > 4 then self.NumPrim = 1 end
	
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld(fp[self.NumPrim])
		bullet.Dir 	= self:GetForward()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 5
		bullet.Damage	= 20
		bullet.Attacker 	= Driver
		bullet.AmmoType = "Pistol"
	
		self:FireBullets( bullet )
	
		self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 0.15 )

	--[[ do secondary attack code here ]]--
	
	self:TakeSecondaryAmmo()
end

function ENT:CreateAI() -- called when the ai gets enabled
end

function ENT:RemoveAI() -- called when the ai gets disabled
end

function ENT:OnKeyThrottle( bPressed )
--[[ 	if self:CanSound() then -- makes sure the player cant spam sounds
		if bPressed then -- if throttle key is pressed
			--self:EmitSound( "buttons/button3.wav" )
			--self:DelayNextSound( 1 ) -- when the next sound should be allowed to be played
		else
			--self:EmitSound( "buttons/button11.wav" )
			--self:DelayNextSound( 0.5 )
		end
	end ]]
end

--[[
function ENT:ApplyThrustVtol( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetElevatorPos() )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetWingPos() )
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce, self:GetRotorPos() )
end
]]--

function ENT:OnEngineStarted()
	--[[ play engine start sound? ]]--
	
end

function ENT:OnEngineStopped()
	--[[ play engine stop sound? ]]--
	
end

function ENT:OnVtolMode( IsOn )
	--[[ called when vtol mode is activated / deactivated ]]--
end

function ENT:OnLandingGearToggled( bOn )
	
	local Driver = self:GetDriver()

	if not IsValid( Driver ) then return end

	if Driver:KeyDown( IN_ZOOM ) then
		local ToggleHatch = not self:GetRearHatch()
		self:SetRearHatch( ToggleHatch )
		
		if ToggleHatch then
			self:EmitSound( "lfs/laat/door_open.wav" )
		else
			self:EmitSound( "lfs/laat/door_close.wav" )
		end
	else

		local DoorMode = self:GetDoorMode() + 1

			self:SetDoorMode( DoorMode )

			if DoorMode == 1 then
				self:PlayAnimation( "wings_open" )

		self:EmitSound( "lfs/laat/door_open.wav" )
			end
			
			if DoorMode >= 2 then
				self:PlayAnimation( "wings_close" )

				self:EmitSound( "lfs/laat/door_open.wav" )
				self:SetDoorMode( 0 )
			end

	end
end
