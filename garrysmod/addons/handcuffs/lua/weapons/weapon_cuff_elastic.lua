AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "Stretchable restraint."

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 3
SWEP.PrintName = "Elastic Restraint"

//
// Handcuff Vars
SWEP.CuffTime = 0.1 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "models/props_pipes/GutterMetal01a"
SWEP.CuffRope = "cable/red"
SWEP.CuffStrength = 1.0
SWEP.CuffRegen = 2.0
SWEP.RopeLength = 100
SWEP.CuffReusable = true

SWEP.CuffBlindfold = true
SWEP.CuffGag = true

SWEP.CuffStrengthVariance = 0.08 // Randomise strangth
SWEP.CuffRegenVariance = 0.08 // Randomise regen

-- vk.com/urbanichka