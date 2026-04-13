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
SWEP.PrintName						= "DC-17m (Launcher)"
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
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true
SWEP.MuzzleFlashEffect 				= ""

SWEP.Primary.ClipSize				= 1
SWEP.Primary.DefaultClip			= 1*5
SWEP.Primary.RPM					= 165
SWEP.Primary.RPM_Burst				= nil
SWEP.Primary.Ammo					= "rpg_round"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 52495*0.085
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc17mrocket.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/reload.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 1000
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

local CurRange = 52495*0.085
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

SWEP.ProjectileEntitie 				= "rw_sw_nade"
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
SWEP.BlowbackVector 				= Vector(0,-3,-0.035)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
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

SWEP.VMPos = Vector(2.02, 0, -4.82)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 01.10
SWEP.Primary.KickDown				= 01.06
SWEP.Primary.KickHorizontal			= 0.05
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.02
SWEP.Primary.IronAccuracy 			= 0.003
SWEP.Primary.SpreadMultiplierMax 	= 2.2
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.65, -3.2, 1.8)
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
	["rifle_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_rifle.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["rocket_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_rocket.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["dc17m_ironsight"] = { type = "Model", model = "models/cs574/dc17m/dc17m_ironsight.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["dc17m_ammo"] = { type = "Quad", bone = "", rel = "dc17m", pos = Vector(0.8, 06.35, 04.175), angle = Angle(0, -270, 62.5), size = 0.0045, draw_func = nil},
}

SWEP.WElements = {
	["dc17m"] = { type = "Model", model = "models/cs574/dc17m/dc17m_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -1.5), angle = Angle(0, -90, 165), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["rifle_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_rifle.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["rocket_module"] = { type = "Model", model = "models/cs574/dc17m/dc17m_rocket.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["dc17m_ironsight"] = { type = "Model", model = "models/cs574/dc17m/dc17m_ironsight.mdl", bone = "", rel = "dc17m", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
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
	end
end

function SWEP:ShootBullet(...)
	if IsFirstTimePredicted() then
		if SERVER then
			timer.Simple(0, function()
				local ent = ents.Create("rw_sw_nade")
				local dir
				local ang = self.Owner:EyeAngles()
				rec, aimcone = self:CalculateConeRecoil()
				dir = ang:Forward()
				ang:RotateAroundAxis(ang:Right(), - aimcone / 2)
				if !self:GetIronSights( issighting ) then
					ent:SetPos(self.Owner:GetShootPos() + ang:Forward()*10 + ang:Right()*8 + ang:Up()*-10)
				end
				if self:GetIronSights( issighting ) then
					ent:SetPos(self.Owner:GetShootPos() + ang:Forward()*10 + ang:Right()*-5 + ang:Up()*-10)
				end
				ent:SetOwner(self.Owner)
				ent:Spawn()
				ent:SetVelocity(dir * 1500)
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(dir * 1500)
					phys:EnableGravity( true )
					phys:EnableDrag(false)
				end
			end)
		end
		return
	end
	return BaseClass.ShootBullet(self,...)
end