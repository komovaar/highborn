SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end

SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Other"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"


SWEP.PrintName						= "Ammo Crate"
SWEP.Type							= "This is a WIP swep, so you can throw 5 (default) crate of 750 (default) ammo and the swep will be deleted"
SWEP.Slot							= 0
SWEP.SlotPos						= 0

SWEP.VElements = {
	["carte"] = { 
		type = "Model", 
		model = "models/cs574/objects/ammo_box.mdl", 
		bone = "v_scoutblaster_reference001", 
		rel = "", 
		pos = Vector(0, 0, -15), 
		angle = Angle(0, 90, 0), 
		size = Vector(1, 1, 1), 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		material = "", 
		skin = 0, 
		bodygroup = {}
	},
}

SWEP.WElements = {
	["carte"] = { 
		type = "Model",
		model = "models/cs574/objects/ammo_box.mdl", 
		bone = "ValveBiped.Bip01_R_Hand", 
		rel = "", 
		pos = Vector(-02, 10.5, -06), 
		angle = Angle(0, -05, 06), 
		size = Vector(1.15, 1.15, 1.15), 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		material = "", 
		skin = 0, 
		bodygroup = {} }
}

function SWEP:Think()
	if (self:Clip1() <= 0) then
		if IsValid(self) and self:OwnerIsValid() and SERVER then
			self:GetOwner():StripWeapon(self:GetClass())
		end
	end
end

SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 75
SWEP.FiresUnderwater 				= true
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= false
SWEP.DrawCrosshairIS 				= false
SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= nil
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= GetConVar("rw_sw_dispenser_ammo_crate_number"):GetInt()
SWEP.Primary.DefaultClip			= GetConVar("rw_sw_dispenser_ammo_crate_number"):GetInt()
SWEP.Primary.RPM					= 200
SWEP.Primary.RPM_Burst				= 0
SWEP.Primary.Ammo					= "crate"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 0
SWEP.Primary.RangeFalloff 			= 0
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= 0
SWEP.Primary.BurstDelay				= 0
SWEP.Primary.Sound 					= nil
SWEP.Primary.ReloadSound 			= nil
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 0
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= 0

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"none"
}

SWEP.IronRecoilMultiplier			= 0
SWEP.CrouchRecoilMultiplier			= 0
SWEP.JumpRecoilMultiplier			= 0
SWEP.WallRecoilMultiplier			= 0
SWEP.ChangeStateRecoilMultiplier	= 0
SWEP.CrouchAccuracyMultiplier		= 0
SWEP.ChangeStateAccuracyMultiplier	= 0
SWEP.JumpAccuracyMultiplier			= 0
SWEP.WalkAccuracyMultiplier			= 0
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 300

SWEP.ProjectileEntity 				= "ammo_chargepack"
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/bf2017/c_scoutblaster.mdl"
SWEP.WorldModel						= "models/bf2017/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= false
SWEP.HoldType 						= "duel"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,0,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= nil
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= nil
SWEP.ImpactDecal 					= nil

SWEP.VMPos = Vector(-05, -10, -4)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.5
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0
SWEP.Primary.StaticRecoilFactor 	= 0
SWEP.Primary.Spread					= 0
SWEP.Primary.IronAccuracy 			= 0
SWEP.Primary.SpreadMultiplierMax 	= 0
SWEP.Primary.SpreadIncrement 		= 0
SWEP.Primary.SpreadRecovery 		= 0
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.7
SWEP.IronSightsMoveSpeed 			= 0.7

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, -0.3, 0), angle = Angle(0, 0, 0) }
}

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "" 
SWEP.Secondary.ScopeZoom 			= 0
SWEP.ScopeReticule_Scale 			= {1,1}
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