SWEP.Gun							= ("rw_sw_dual_dc15s")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Republic"
SWEP.Manufacturer 					= "Blastech Industries"
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Dual DC-17s"
SWEP.Type							= "Republic Advanced Dual Pistol Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 1
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= ""
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 36*2
SWEP.Primary.DefaultClip			= 36*8
SWEP.Primary.RPM					= 385*2*0.8
SWEP.Primary.RPM_Burst				= 385*2*0.8
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc17s_custom.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 35
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.Akimbo 						= true

SWEP.DoMuzzleFlash 					= false
SWEP.CustomMuzzleFlash 				= false
SWEP.MuzzleFlashEffect 				= "none"

SWEP.FireModes = {
	"Automatic",
	"Single",
}

SWEP.IronRecoilMultiplier			= 0.44
SWEP.CrouchRecoilMultiplier			= 0.33
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.18
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.6
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/strasser/weapons/c_ddeagle.mdl"
SWEP.WorldModel						= "models/bf2017/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 90
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "duel"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-3,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= ""

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_dual_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(0, -6, -3)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.10
SWEP.Primary.KickDown				= 0.08
SWEP.Primary.KickHorizontal			= 0.025
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.005
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 1.6
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(0, -5, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, -7.5, -10)
SWEP.RunSightsAng = Vector(37.5, 0, 0)
SWEP.InspectPos = Vector(0, -5, -5)
SWEP.InspectAng = Vector(37.5,0,0)

SWEP.LuaShellEject = false

SWEP.VElements = {

	["dc17s"] = { type = "Model", model = "models/fisher/dc17s/dc17s.mdl", bone = "LeftHand_1stP", rel = "", pos = Vector(8, 3.5, -1.5), angle = Angle(82, -2, 90), size = Vector(0.85, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} },

	["ind1"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind2"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind3"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind4"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind5"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05-0.49-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind6"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s", pos = Vector(-0.7, -01.05-0.49-0.49-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },

	["dc17s+"] = { type = "Model", model = "models/fisher/dc17s/dc17s.mdl", bone = "RightHand_1stP", rel = "", pos = Vector(-8, -3.5, 2), angle = Angle(98, 178, 90), size = Vector(0.85, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} },

	["ind1+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind2+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind3+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind4+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind5+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05-0.49-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["ind6+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "", rel = "dc17s+", pos = Vector(0.8, -01.05-0.49-0.49-0.49-0.49-0.49, 01.34), angle = Angle(0, -90, 90), size = Vector(0.15, 0.1, 0.1), color = Color(255, 0, 80, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
}


SWEP.WElements = {

	["dc17s"] = { type = "Model", model = "models/fisher/dc17s/dc17s.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(8.8, 01.8, 2.8), angle = Angle(0, 80, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

	["dc17s+"] = { type = "Model", model = "models/fisher/dc17s/dc17s.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.5, 01.8, -3.2), angle = Angle(0, -97.5, 175), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

}

SWEP.ProceduralHolsterPos = Vector(0,-8,-8)
SWEP.ProceduralHolsterAng = Vector(37.5,0,0)
SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2.3

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 1
SWEP.ScopeReticule_Scale 			= {1.1,1.1}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
DEFINE_BASECLASS( SWEP.Base )

local ColorActive = Color(255, 0, 0, 255)
local ColorDisabled = Color(30, 30, 30, 255)

function SWEP:Think(...)
	BaseClass.Think(self, ...)
	
	if( self.Weapon:Clip1() <= self.Primary.ClipSize && self.Weapon:Clip1() >= (self.Primary.ClipSize/6)*5) then 
		self.VElements["ind1"].color = ColorActive
		self.VElements["ind1"].surpresslightning = true
		self.VElements["ind2"].color = ColorActive
		self.VElements["ind2"].surpresslightning = true
		self.VElements["ind3"].color = ColorActive
		self.VElements["ind3"].surpresslightning = true
		self.VElements["ind4"].color = ColorActive
		self.VElements["ind4"].surpresslightning = true
		self.VElements["ind5"].color = ColorActive
		self.VElements["ind5"].surpresslightning = true
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorActive
		self.VElements["ind1+"].surpresslightning = true
		self.VElements["ind2+"].color = ColorActive
		self.VElements["ind2+"].surpresslightning = true
		self.VElements["ind3+"].color = ColorActive
		self.VElements["ind3+"].surpresslightning = true
		self.VElements["ind4+"].color = ColorActive
		self.VElements["ind4+"].surpresslightning = true
		self.VElements["ind5+"].color = ColorActive
		self.VElements["ind5+"].surpresslightning = true
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end	
	if( self.Weapon:Clip1() <= (self.Primary.ClipSize/6)*5 && self.Weapon:Clip1() >= (self.Primary.ClipSize/6)*4) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorActive
		self.VElements["ind2"].surpresslightning = true
		self.VElements["ind3"].color = ColorActive
		self.VElements["ind3"].surpresslightning = true
		self.VElements["ind4"].color = ColorActive
		self.VElements["ind4"].surpresslightning = true
		self.VElements["ind5"].color = ColorActive
		self.VElements["ind5"].surpresslightning = true
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorActive
		self.VElements["ind2+"].surpresslightning = true
		self.VElements["ind3+"].color = ColorActive
		self.VElements["ind3+"].surpresslightning = true
		self.VElements["ind4+"].color = ColorActive
		self.VElements["ind4+"].surpresslightning = true
		self.VElements["ind5+"].color = ColorActive
		self.VElements["ind5+"].surpresslightning = true
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end	
	if( self.Weapon:Clip1() <= (self.Primary.ClipSize/6)*4 && self.Weapon:Clip1() >= (self.Primary.ClipSize/6)*3) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorDisabled
		self.VElements["ind2"].surpresslightning = false
		self.VElements["ind3"].color = ColorActive
		self.VElements["ind3"].surpresslightning = true
		self.VElements["ind4"].color = ColorActive
		self.VElements["ind4"].surpresslightning = true
		self.VElements["ind5"].color = ColorActive
		self.VElements["ind5"].surpresslightning = true
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorDisabled
		self.VElements["ind2+"].surpresslightning = false
		self.VElements["ind3+"].color = ColorActive
		self.VElements["ind3+"].surpresslightning = true
		self.VElements["ind4+"].color = ColorActive
		self.VElements["ind4+"].surpresslightning = true
		self.VElements["ind5+"].color = ColorActive
		self.VElements["ind5+"].surpresslightning = true
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end	
	if( self.Weapon:Clip1() <= (self.Primary.ClipSize/6)*3 && self.Weapon:Clip1() >= (self.Primary.ClipSize/6)*2) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorDisabled
		self.VElements["ind2"].surpresslightning = false
		self.VElements["ind3"].color = ColorDisabled
		self.VElements["ind3"].surpresslightning = false
		self.VElements["ind4"].color = ColorActive
		self.VElements["ind4"].surpresslightning = true
		self.VElements["ind5"].color = ColorActive
		self.VElements["ind5"].surpresslightning = true
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorDisabled
		self.VElements["ind2+"].surpresslightning = false
		self.VElements["ind3+"].color = ColorDisabled
		self.VElements["ind3+"].surpresslightning = false
		self.VElements["ind4+"].color = ColorActive
		self.VElements["ind4+"].surpresslightning = true
		self.VElements["ind5+"].color = ColorActive
		self.VElements["ind5+"].surpresslightning = true
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end	
	if( self.Weapon:Clip1() <= (self.Primary.ClipSize/6)*2 && self.Weapon:Clip1() >= self.Primary.ClipSize/6) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorDisabled
		self.VElements["ind2"].surpresslightning = false
		self.VElements["ind3"].color = ColorDisabled
		self.VElements["ind3"].surpresslightning = false
		self.VElements["ind4"].color = ColorDisabled
		self.VElements["ind4"].surpresslightning = false
		self.VElements["ind5"].color = ColorActive
		self.VElements["ind5"].surpresslightning = true
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorDisabled
		self.VElements["ind2+"].surpresslightning = false
		self.VElements["ind3+"].color = ColorDisabled
		self.VElements["ind3+"].surpresslightning = false
		self.VElements["ind4+"].color = ColorDisabled
		self.VElements["ind4+"].surpresslightning = false
		self.VElements["ind5+"].color = ColorActive
		self.VElements["ind5+"].surpresslightning = true
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end	
	if( self.Weapon:Clip1() <= self.Primary.ClipSize/6 && self.Weapon:Clip1() > 0) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorDisabled
		self.VElements["ind2"].surpresslightning = false
		self.VElements["ind3"].color = ColorDisabled
		self.VElements["ind3"].surpresslightning = false
		self.VElements["ind4"].color = ColorDisabled
		self.VElements["ind4"].surpresslightning = false
		self.VElements["ind5"].color = ColorDisabled
		self.VElements["ind5"].surpresslightning = false
		self.VElements["ind6"].color = ColorActive
		self.VElements["ind6"].surpresslightning = true
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorDisabled
		self.VElements["ind2+"].surpresslightning = false
		self.VElements["ind3+"].color = ColorDisabled
		self.VElements["ind3+"].surpresslightning = false
		self.VElements["ind4+"].color = ColorDisabled
		self.VElements["ind4+"].surpresslightning = false
		self.VElements["ind5+"].color = ColorDisabled
		self.VElements["ind5+"].surpresslightning = false
		self.VElements["ind6+"].color = ColorActive
		self.VElements["ind6+"].surpresslightning = true
	end
	if( self.Weapon:Clip1() == 0) then 
		self.VElements["ind1"].color = ColorDisabled
		self.VElements["ind1"].surpresslightning = false
		self.VElements["ind2"].color = ColorDisabled
		self.VElements["ind2"].surpresslightning = false
		self.VElements["ind3"].color = ColorDisabled
		self.VElements["ind3"].surpresslightning = false
		self.VElements["ind4"].color = ColorDisabled
		self.VElements["ind4"].surpresslightning = false
		self.VElements["ind5"].color = ColorDisabled
		self.VElements["ind5"].surpresslightning = false
		self.VElements["ind6"].color = ColorDisabled
		self.VElements["ind6"].surpresslightning = false
		
		self.VElements["ind1+"].color = ColorDisabled
		self.VElements["ind1+"].surpresslightning = false
		self.VElements["ind2+"].color = ColorDisabled
		self.VElements["ind2+"].surpresslightning = false
		self.VElements["ind3+"].color = ColorDisabled
		self.VElements["ind3+"].surpresslightning = false
		self.VElements["ind4+"].color = ColorDisabled
		self.VElements["ind4+"].surpresslightning = false
		self.VElements["ind5+"].color = ColorDisabled
		self.VElements["ind5+"].surpresslightning = false
		self.VElements["ind6+"].color = ColorDisabled
		self.VElements["ind6+"].surpresslightning = false
	end
end