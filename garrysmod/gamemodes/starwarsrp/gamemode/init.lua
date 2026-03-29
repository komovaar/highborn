hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "DerivedRP"
GM.Author = "By Harry, FPtje Falco et al."

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")

GM.DarkRP = BaseClass

hook.Add("PlayerSpawnProp", "BlockProps", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSENT", "BlockSents", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSWEP", "BlockSweps", function(ply)
    if not ply:IsAdmin() then return false end
end)    

DarkRP.removeChatCommand("000")
DarkRP.removeChatCommand("112")
DarkRP.removeChatCommand("911")
DarkRP.removeChatCommand("999")
DarkRP.removeChatCommand("addagenda")
DarkRP.removeChatCommand("addlaw")
DarkRP.removeChatCommand("addowner")
DarkRP.removeChatCommand("admintell")
DarkRP.removeChatCommand("agenda")
DarkRP.removeChatCommand("ago")
DarkRP.removeChatCommand("braodcast")
DarkRP.removeChatCommand("buy")
DarkRP.removeChatCommand("buyammo")
DarkRP.removeChatCommand("buyshipment")
DarkRP.removeChatCommand("buyvehicle")
DarkRP.removeChatCommand("channel")
DarkRP.removeChatCommand("check")
DarkRP.removeChatCommand("cheque")
DarkRP.removeChatCommand("chief")
DarkRP.removeChatCommand("citizen")
DarkRP.removeChatCommand("cp")
DarkRP.removeChatCommand("cr")
DarkRP.removeChatCommand("credits")
DarkRP.removeChatCommand("demote")
DarkRP.removeChatCommand("drop")
DarkRP.removeChatCommand("demotelicense")
DarkRP.removeChatCommand("forcecancelvote")
DarkRP.removeChatCommand("forcelock")
DarkRP.removeChatCommand("forceown")
DarkRP.removeChatCommand("forceunlock")
DarkRP.removeChatCommand("forceunown")
DarkRP.removeChatCommand("forceunownall")
DarkRP.removeChatCommand("gangster")
DarkRP.removeChatCommand("givelicense")
DarkRP.removeChatCommand("gundealer")
DarkRP.removeChatCommand("hobo")
DarkRP.removeChatCommand("job")
DarkRP.removeChatCommand("jobswitch")
DarkRP.removeChatCommand("lockdown")
DarkRP.removeChatCommand("lottery")
DarkRP.removeChatCommand("makeshipment")
DarkRP.removeChatCommand("mayor")
DarkRP.removeChatCommand("medic")
DarkRP.removeChatCommand("mobboss")
DarkRP.removeChatCommand("moneydrop")
DarkRP.removeChatCommand("placelaws")
DarkRP.removeChatCommand("price")
DarkRP.removeChatCommand("radio")
DarkRP.removeChatCommand("removelaw")
DarkRP.removeChatCommand("removeletters")
DarkRP.removeChatCommand("removeowner")
DarkRP.removeChatCommand("requestlicense")
DarkRP.removeChatCommand("resetlaws")
DarkRP.removeChatCommand("ro")
DarkRP.removeChatCommand("sellalldoors")
DarkRP.removeChatCommand("setlicense")
DarkRP.removeChatCommand("setprice")
DarkRP.removeChatCommand("splitshipment")
DarkRP.removeChatCommand("switchjob")
DarkRP.removeChatCommand("switchjobs")
DarkRP.removeChatCommand("teamunban")
DarkRP.removeChatCommand("title")
DarkRP.removeChatCommand("teamban")
DarkRP.removeChatCommand("togglegroupownable")
DarkRP.removeChatCommand("toggleown")
DarkRP.removeChatCommand("toggleownable")
DarkRP.removeChatCommand("type")
DarkRP.removeChatCommand("unlockdown")
DarkRP.removeChatCommand("unownalldoors")
DarkRP.removeChatCommand("unsetlicense")
DarkRP.removeChatCommand("unwantewd")
DarkRP.removeChatCommand("unwanted")
DarkRP.removeChatCommand("unwarrant")
DarkRP.removeChatCommand("votecp")
DarkRP.removeChatCommand("votemayor")
DarkRP.removeChatCommand("wanted")
DarkRP.removeChatCommand("warrant")
DarkRP.removeChatCommand("write")
DarkRP.removeChatCommand("")


hook.Add("OnNPCKilled", "BlockNPCDrops", function(npc, attacker, inflictor)

    for _, wep in ipairs(npc:GetWeapons()) do
        if IsValid(wep) then
            wep:Remove()
        end
    end
end)

hook.Add("OnEntityCreated", "BlockNPCDrops", function(ent)

    timer.Simple(0, function()
        if not IsValid(ent) then return end

        local class = ent:GetClass()

        if class == "npc_grenade_frag"
        or class == "grenade_ar2"
        or class == "item_ammo_ar2_altfire"
        or class == "item_healthkit"
        or class == "item_healthvial"
        or class == "item_battery" then
            ent:Remove()
        end

    end)

end)

hook.Add("CreateEntityRagdoll", "RemoveNPCRagdoll", function(ent, ragdoll)
    if ent:IsNPC() then
        timer.Simple(0, function()
            if IsValid(ragdoll) then
                ragdoll:Remove()
            end
        end)
    end
end)

resource.AddWorkshop("3675351271")
resource.AddWorkshop("3675353729")
resource.AddWorkshop("3675355497")
resource.AddWorkshop("3675356291")
resource.AddWorkshop("3677164280")
resource.AddWorkshop("3675356933")

hook.Add("PlayerCanDropWeapon", "BlockWeaponDrop", function(ply, weapon)
    if IsValid(weapon) and weapon:IsWeapon() then
        return false -- запрещаем дроп
    end
end)

local NoTargetJobs = {
    [TEAM_B1] = true,
    [TEAM_B1CO] = true,
    [TEAM_B1SNP] = true,
    [TEAM_B1Z4] = true,
    [TEAM_B2] = true,
    [TEAM_B2CAN] = true,
    [TEAM_BX] = true,
    [TEAM_TACTICAL] = true,
}

local function UpdateNoTarget(ply)
    if not IsValid(ply) then return end

    if NoTargetJobs[ply:Team()] then
        ply:SetNoTarget(true)
    else
        ply:SetNoTarget(false)
    end
end

hook.Add("PlayerSpawn", "SetNoTargetOnSpawn", function(ply)
    timer.Simple(0.1, function()
        if not IsValid(ply) then return end
        UpdateNoTarget(ply)
    end)
end)

hook.Add("OnPlayerChangedTeam", "SetNoTargetOnJobChange", function(ply)
    timer.Simple(0.1, function()
        if not IsValid(ply) then return end
        UpdateNoTarget(ply)
    end)
end)