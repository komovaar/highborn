if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Tracking Mod"
ATTACHMENT.ShortName = "T.M"
ATTACHMENT.Icon = "entities/atts/rctm_traget.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["="], "The rocket will track your target.", 
    TFA.AttachmentColors["="], "10 seconds life time.", 
    TFA.AttachmentColors["="], "Speed of 157 m/s.", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {},
	["WElements"] = {
		["laser_beam"] = {["active"] = false},
		["laser_beam_tracking"] = {["active"] = true},
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
