if SERVER then
LUCTUS_DEATH_TIME = 15

hook.Add("PlayerDisconnected","hb_remove_svragdoll",function(ply)
  if ply.lragdoll then
    ply.lragdoll:Remove()
  end
end)

hook.Add("CreateEntityRagdoll","hb_set_death_owner",function(ply,rag)
  ply.lragdoll = rag
end)

util.AddNetworkString("hb_deathscreen")
hook.Add("PlayerDeath","hb_deathscreen",function(ply)
    net.Start("hb_deathscreen")
        net.WriteInt(LUCTUS_DEATH_TIME,15)
    net.Send(ply)

    timer.Create(ply:SteamID().."_death_timer",LUCTUS_DEATH_TIME,1,function()
        if not IsValid(ply) then return end
        if not ply:Alive() then
            ply:Spawn()
        end
    end)
end)

-- hook.Add("PlayerDeathThink","hb_deathscreen",function(ply)
--   return false
-- end)

hook.Add("PlayerSpawn","hb_deathscreen",function(ply)
  net.Start("hb_deathscreen")
    net.WriteInt(-1,15)
  net.Send(ply)
  if timer.Exists(ply:SteamID().."_death_timer") then
    timer.Remove(ply:SteamID().."_death_timer")
  end
end)

hook.Add("PlayerSay","hb_deathscreen",function(ply,text,team)
  if text == "!resetscreen" then
    net.Start("hb_deathscreen")
      net.WriteInt(-1,15)
    net.Send(ply)
  end
end)
end

