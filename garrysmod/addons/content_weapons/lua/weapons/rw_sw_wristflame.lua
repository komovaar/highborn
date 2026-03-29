SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked WristWeapons"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "WristFlame"
SWEP.Type							= "Wrist FlameThrower"
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
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 120
SWEP.Primary.DefaultClip			= 120*3
SWEP.Primary.RPM					= 1000
SWEP.Primary.RPM_Burst				= 1000
SWEP.Primary.RPM_Semi				= 1000
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 350
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.BurstDelay				= 0.25
SWEP.Primary.ReloadSound 			= Sound ("w/reload_fast.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 35
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.Primary.Force 					= 0
SWEP.Primary.Knockback 				= 0

SWEP.FireModes = {
	"Single"
}


SWEP.DoMuzzleFlash 					= false
SWEP.CustomMuzzleFlash 				= false
SWEP.MuzzleFlashEffect 				= ""

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
SWEP.ProjectileVelocity 			= 1100

SWEP.ProjectileEntity 				= "ent_rw_rocket"
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/delta/c_wrist_blaster.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 65
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "pistol"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_aqua"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_aqua"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(-3,-4,-1)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.1
SWEP.Primary.KickUp					= 0.08
SWEP.Primary.KickDown				= 0.065
SWEP.Primary.KickHorizontal			= 0.065
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.022
SWEP.Primary.IronAccuracy 			= 0.022
SWEP.Primary.SpreadMultiplierMax 	= 1
SWEP.Primary.SpreadIncrement 		= 1
SWEP.Primary.SpreadRecovery 		= 1
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.9, -8, 1.8)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-20, 0, 0)
SWEP.InspectPos = Vector(8, -2, -3)
SWEP.InspectAng = Vector(15, 45, 0)

SWEP.ViewModelBoneMods = { 
	["ValveBiped.Bip01_R_Wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["base"] = { type = "Model", model = "models/cs574/weapons/arc_leftwrist.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "", pos = Vector(-06, 0, 02.9), angle = Angle(-03, 0, 175), size = Vector(1.05, 1.05, 1.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_defaultbarrel.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "base", pos = Vector(-17.2, -0.25, 04.15), angle = Angle(-03.5, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster2"] = { type = "Model", model = "models/sw_battlefront/weapons/mods/blurrg_cycler_mod.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "blaster", pos = Vector(14.3, 0.75, -02), angle = Angle(0, -90, 0), size = Vector(1.55, 1.55, 1.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster3"] = { type = "Model", model = "models/sw_battlefront/weapons/mods/blurrg_cycler_mod.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "blaster", pos = Vector(14.3, -0.75, -02), angle = Angle(0, -90, 0), size = Vector(1.55, 1.55, 1.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["base"] = { type = "Model", model = "models/cs574/weapons/arc_leftwrist.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "", pos = Vector(-0.5, -0.25, 3.1), angle = Angle(0, 0, 175), size = Vector(1.05, 1.05, 1.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_defaultbarrel.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "base", pos = Vector(-17.2, -0.25, 04.15), angle = Angle(-03.5, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster2"] = { type = "Model", model = "models/sw_battlefront/weapons/mods/blurrg_cycler_mod.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "blaster", pos = Vector(14.3, 0.75, -02), angle = Angle(0, -90, 0), size = Vector(1.55, 1.55, 1.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blaster3"] = { type = "Model", model = "models/sw_battlefront/weapons/mods/blurrg_cycler_mod.mdl", bone = "ValveBiped.Bip01_R_Wrist", rel = "blaster", pos = Vector(14.3, -0.75, -02), angle = Angle(0, -90, 0), size = Vector(1.55, 1.55, 1.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.ProceduralHolsterPos = Vector(0,0,0)
SWEP.ProceduralHolsterAng = Vector(-20,0,0)
SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2.55

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
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

game.AddParticles("particles/waw_flamer.pcf")
PrecacheParticleSystem("flamethrower")

function SWEP:Think2( ... )
	if not IsFirstTimePredicted() then
		return BaseClass.Think2(self,...)
	end
	if not self:VMIV() then return end
	if self.Shooting_Old == nil then
		self.Shooting_Old = false
	end
	local shooting = self:GetStatus() == TFA.GetStatus("shooting")
	if shooting ~= self.Shooting_Old then
		if shooting then
			self:EmitSound("weapons/waw_flamer/fire_in.wav")
			self.NextIdleSound = CurTime() + 0.2
			local fx = EffectData()
			fx:SetEntity(self)
			fx:SetAttachment(1)
			util.Effect("waw_flame",fx)
			if self:IsFirstPerson() then
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self.OwnerViewModel,1)
			else
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self,1)
			end
		else
			self:EmitSound("weapons/waw_flamer/fire_end.wav")
			self.NextIdleSound = -1
			self:CleanParticles()
			--self:SendViewModelAnim( ACT_VM_PRIMARYATTACK_EMPTY)
		end
	end
	if shooting then
		if self.NextIdleSound and CurTime() > self.NextIdleSound then
			self:EmitSound("weapons/waw_flamer/fire_loop.wav")
			self.NextIdleSound = CurTime() + SoundDuration( "weapons/waw_flamer/fire_loop.wav" ) - 0.1
		end
	end
	self.Shooting_Old = shooting
	BaseClass.Think2(self,...)
end

function SWEP:ShootEffectsCustom() end
function SWEP:DoImpactEffect() return true end
local range
local bul = {}
local function cb( a, b, c )
	if b.HitPos:Distance( a:GetShootPos() ) > range then return end
	c:SetDamageType(DMG_BURN)
	if IsValid(b.Entity) and b.Entity.Ignite and not b.Entity:IsWorld() then
		b.Entity:Ignite( c:GetDamage(), 16 )
	end
end

function SWEP:ShootBullet()
	bul.Attacker = self.Owner
	bul.Distance = self.Primary.Range
	bul.HullSize = self.Primary.HullSize
	bul.Num = 1
	bul.Damage = self.Primary.Damage
	bul.Distance = self.Primary.Range
	bul.Tracer = 0
	bul.Callback = cb
	bul.Src = self.Owner:GetShootPos()
	bul.Dir = self.Owner:GetAimVector()
	range = bul.Distance
	self.Owner:FireBullets(bul)
end