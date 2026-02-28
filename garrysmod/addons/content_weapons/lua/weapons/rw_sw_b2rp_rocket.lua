SWEP.Gun							= ("rw_sw_b2rp_rocket")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked CIS"
SWEP.Manufacturer 					= "Baktoid Combat Automata"
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "B2 Hand-Rocket"
SWEP.Type							= "CIS Hand Rocket"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 78
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
SWEP.DefaultFireMode 				= "single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 1
SWEP.Primary.DefaultClip			= 3
SWEP.Primary.RPM					= 30
SWEP.Primary.RPM_Burst				= 30
SWEP.Primary.Ammo					= "rpg_round"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/b2_blaster.wav");
SWEP.Primary.ReloadSound 			= nil
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 1000
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.Primary.Force 					= 0
SWEP.Primary.Knockback 				= 0

SWEP.FireModes = {
	"Single"
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

SWEP.ProjectileEntity 				= "ent_rw_rocket"
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_scoutblaster.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= false
SWEP.HoldType 						= "pistol"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-3,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(02, -07, -02)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.1
SWEP.Primary.KickUp					= 0.0
SWEP.Primary.KickDown				= 0.0
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.02
SWEP.Primary.IronAccuracy 			= 0.02
SWEP.Primary.SpreadMultiplierMax 	= 1
SWEP.Primary.SpreadIncrement 		= 1
SWEP.Primary.SpreadRecovery 		= 1
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(-5.9, -8, 1.8)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-50, 0, 0)
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["b2"] = { type = "Model", model = "models/cs574/weapons/b2_hand.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["r"] = { type = "Model", model = "models/sw_battlefront/weapons/rocketprojectile.mdl", bone = "", rel = "b2", pos = Vector(0, 04, 01.25), angle = Angle(0, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["b2rph"] = { type = "Model", model = "models/hunter/misc/roundthing4.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(2.5, -6, 5), angle = Angle(90, 0, 0), size = Vector(0.12, 0.12, 0.12), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	--["b2rpb"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(3, 6, 2.85), angle = Angle(0, -90, -90), size = Vector(0.12, 0.12, 0.12), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	--["b2rpb1"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(4, 4, 4.5), angle = Angle(0, 90, 0), size = Vector(0.12, 0.12, 0.12), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	--["b2rpb2"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(4, 4, 1), angle = Angle(0, 90, 0), size = Vector(0.12, 0.12, 0.12), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["b2rp"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1, 1), angle = Angle(-8, 0, 180), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.Animations = { --Override this after SWEP:Initialize, for example, in attachments
	["reload"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
	["reload_empty"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY
	},
	["reload_silenced"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
}

function SWEP:Think()
	if( self.Weapon:Clip1() == 1 ) then
		self.VElements["r"].color = Color(255, 255, 255, 255)
	end
	if( self.Weapon:Clip1() == 0 ) then
		self.VElements["r"].color = Color(255, 255, 255, 0)
	end
end

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.09,1.09}
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

function SWEP:Think(...)
	BaseClass.Think(self, ...)
	if(self.Weapon:Clip1()==1)then self.VElements["r"].color=Color(255,255,255,255)end
	if(self.Weapon:Clip1()==0)then self.VElements["r"].color=Color(255,255,255,0)end
end