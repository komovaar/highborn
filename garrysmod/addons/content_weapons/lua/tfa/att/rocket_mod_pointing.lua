if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Pointing Mod"
ATTACHMENT.ShortName = "P.M"
ATTACHMENT.Icon = "entities/atts/rctm_point.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["="], "The rocket will go where you point.", 
    TFA.AttachmentColors["="], "10 seconds life time.", 
    TFA.AttachmentColors["="], "Speed of 128 m/s.", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {},
	["WElements"] = {
		["laser_beam"] = {["active"] = false},
		["laser_beam_pointing"] = {["active"] = true},
	},
	["Primary"] = {},
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
