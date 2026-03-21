SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Republic"
SWEP.Manufacturer 					= "BlasTech Industries"
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DC-17m (Shotgun)"
SWEP.Type							= "Republic Heavy Modular Blaster Rifle"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 3
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= true
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true
SWEP.MuzzleFlashEffect 				= ""

SWEP.Primary.ClipSize				= 8
SWEP.Primary.DefaultClip			= 8*5
SWEP.Primary.RPM					= 100
SWEP.Primary.RPM_Burst				= nil
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 52495*0.065
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 5
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc17mshotgun.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/reload.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 15
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

local CurRange = 52495*0.065
SWEP.Primary.RangeFalloffLUT = {
    bezier = false,
    range_func = "quintic",
    units = "meters",
    lut = {
        {range = (CurRange*0.1)/52.495, damage = 0.99},
        {range = (CurRange*0.2)/52.495, damage = 0.975},
        {range = (CurRange*0.3)/52.495, damage = 0.95},
        {range = (CurRange*0.4)/52.495, damage = 0.92},
        {range = (CurRange*0.5)/52.495, damage = 0.88},
        {range = (CurRange*0.6)/52.495, damage = 0.80},
        {range = (CurRange*0.7)/52.495, damage = 0.70},
        {range = (CurRange*0.8)/52.495, damage = 0.55},
        {range = (CurRange*0.9)/52.495, damage = 0.35},
        {range = (CurRange*1)/52.495, damage = 0.05},
    }
}

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Auto",
	"Single"
}

SWEP.IronRecoilMultiplier			= 0.5
SWEP.CrouchRecoilMultiplier			= 0.25
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.81
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntitie 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/bf2017/c_dlt19.mdl"
SWEP.WorldModel						= "models/bf2017/w_dlt19.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2,-0.035)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2.02, 0, -4.82)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 0.10
SWEP.Primary.KickDown				= 0.06
SWEP.Primary.KickHorizontal			= 0.05
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.05
SWEP.Primary.IronAccuracy 			= 0.045
SWEP.Primary.SpreadMultiplierMax 	= 2.2
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.65, -9, 0.5)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.RunSightsPos = Vector(5.226, 0, -3)
SWEP.RunSightsAng = Vector(-22, 35, -22)

SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 1), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["dc17m"] = { type = "Model", model = "models/cs574/dc17m/dc17m_base.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {},},
	["shotgun_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_shotgun.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["sniper_magext"] = { type = "Model", model = "models/cs574/dc17m/dc17m_snipermagext.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["dc17m_ammo"] = { type = "Quad", bone = "", rel = "dc17m", pos = Vector(0.8, 06.35, 04.175), angle = Angle(0, -270, 62.5), size = 0.0045, draw_func = nil},
}

SWEP.WElements = {
	["dc17m"] = { type = "Model", model = "models/cs574/dc17m/dc17m_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -1.5), angle = Angle(0, -90, 165), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {},},
	["shotgun_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_shotgun.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["sniper_magext"] = { type = "Model", model = "models/cs574/dc17m/dc17m_snipermagext.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
}

SWEP.LuaShellEject = false
SWEP.LuaShellEffect = ""

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 1
SWEP.ScopeReticule_Scale 			= {0,0}

if surface then
	SWEP.Secondary.ScopeTable = nil
end

DEFINE_BASECLASS( SWEP.Base )

if CLIENT then
	surface.CreateFont( "Test", {font = "Aurebesh",extended = false,size = 200,weight = 0,blursize = 0,scanlines = 0,antialias = false,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
end
function SWEP:Think(...)
	BaseClass.Think(self, ...)
	if CLIENT then
		if self:Clip1()<=9 then self.VElements["dc17m_ammo"].draw_func=function(weapon)draw.SimpleText("00"..weapon:Clip1(),"Test",0,0,Color(0,120,180,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if self:Clip1()==0 then self.VElements["dc17m_ammo"].draw_func=function(weapon)draw.SimpleText("000","Test",0,0,Color(0,120,180,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if self:Clip1()==8 then self.VElements["sniper_magext"].pos=Vector(0,0,0)end
		if self:Clip1()==7 then self.VElements["sniper_magext"].pos=Vector(-0.72,0,0)end
		if self:Clip1()==6 then self.VElements["sniper_magext"].pos=Vector(-1.28,0,0)end
		if self:Clip1()==5 then self.VElements["sniper_magext"].pos=Vector(-1.83,0, 0)end
		if self:Clip1()==4 then self.VElements["sniper_magext"].pos=Vector(-2.38,0,0)end
		if self:Clip1()==3 then self.VElements["sniper_magext"].pos=Vector(-2.95,0,0)end
		if self:Clip1()==2 then self.VElements["sniper_magext"].pos=Vector(-3.52,0,0)end
		if self:Clip1()==1 then self.VElements["sniper_magext"].pos=Vector(-4.08,0,0)end
		if self:Clip1()==0 then self.VElements["sniper_magext"].pos=Vector(-4.5,0,0)end
	end
end