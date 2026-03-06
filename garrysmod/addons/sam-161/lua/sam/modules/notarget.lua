local sam, command = sam, sam.command
local worldspawn = nil
timeoutdelay = 60
command.set_category("Utility")

command.new("notarget"):SetPermission("NoTarget", "user"):AddArg("player", {}):AddArg("number", {
    hint = "0 = notarget deactivated 1 = notarget activated!",
    min = 0,
    max = 1,
    optional = true
}):Help("With that you can switch on of No Target so that NPC´s doesnt targets you"):OnExecute(function(ply, targets, newval)
    if (not ply:IsAdmin() or targets == nil) then
        targets = {ply}
    end

    for i = 1, #targets do
        if (newval == nil) then
            local val = not targets[i]:GetNWBool("rooki_notarget", false)
            targets[i]:SetNWBool("rooki_notarget", val)
            targets[i]:SetNoTarget(val)
        else
            targets[i]:SetNWBool("rooki_notarget", tobool(newval))
            targets[i]:SetNoTarget(tobool(newval))
        end
    end

    if (newval) then
        local text = "False"
        if(newval == 1) then
            text = "True"
        end
        sam.player.send_message(nil, "{A} sets notarget of {T} to {V}", {
            A = ply,
            T = targets,
            V = newval
        })
    else
        sam.player.send_message(nil, "{A} swapped notarget of {T}", {
            A = ply,
            T = targets,
        })
    end
end):End()

