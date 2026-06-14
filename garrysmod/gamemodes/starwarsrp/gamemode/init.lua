GM.Version = "0.1.0"
GM.Name = "StarWarsRP"
GM.Author = "whosgotch"

DeriveGamemode("prop")
DEFINE_BASECLASS("gamemode_prop")

hook.Add("PlayerSpawnProp", "SWRP.BlockProps", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSENT", "SWRP.BlockSents", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSWEP", "SWRP.BlockSweps", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("OnNPCKilled", "SWRP.BlockNPCDrops", function(npc)
    for _, wep in ipairs(npc:GetWeapons()) do
        if IsValid(wep) then
            wep:Remove()
        end
    end
end)

hook.Add("OnEntityCreated", "SWRP.BlockNPCDrops", function(ent)
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

hook.Add("CreateEntityRagdoll", "SWRP.RemoveNPCRagdoll", function(ent, ragdoll)
    if not ent:IsNPC() then return end

    timer.Simple(0, function()
        if IsValid(ragdoll) then
            ragdoll:Remove()
        end
    end)
end)

resource.AddWorkshop("3675351271")
resource.AddWorkshop("3675353729")
resource.AddWorkshop("3675355497")
resource.AddWorkshop("3675356291")
resource.AddWorkshop("3677164280")
resource.AddWorkshop("3675356933")
resource.AddFile("materials/91st_shared/21st_trooper_shoulderant.vmt")

hook.Add("PlayerCanDropWeapon", "SWRP.BlockWeaponDrop", function(ply, weapon)
    if IsValid(weapon) and weapon:IsWeapon() then
        return false
    end
end)
