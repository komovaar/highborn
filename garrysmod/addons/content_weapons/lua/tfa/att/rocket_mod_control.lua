if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Control Mod"
ATTACHMENT.ShortName = "C.M"
ATTACHMENT.Icon = "entities/atts/rctm_control.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["="], "You can control the rocket.", 
    TFA.AttachmentColors["="], "10 seconds life time.", 
    TFA.AttachmentColors["="], "Speed of 100 m/s.", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {},
	["WElements"] = {
		["laser_beam"] = {["active"] = false},
		["laser_beam_control"] = {["active"] = true},
	},
	["Primary"] = {},
}

function ATTACHMENT:Attach(wep)
	wep.data.ironsights = 0
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.data.ironsights = 1
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
