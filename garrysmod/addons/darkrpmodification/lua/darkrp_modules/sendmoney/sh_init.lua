--[[---------------------------------------------------------------------------
/sendmoney <name> <amount>
Send money to a nearby player by their (partial) nickname.
---------------------------------------------------------------------------]]

DarkRP.declareChatCommand{
    command = "sendmoney",
    description = "Send money to a nearby player by their name.",
    delay = 1.5,
    tableArgs = true
}

if CLIENT then return end

local maxDistance = 150 -- same range as /give

local function SendMoney(ply, args)
    local target = DarkRP.findPlayer(args[1])
    local amount = DarkRP.toInt(args[2])

    if not target then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(args[1])))
        return ""
    end

    if not amount or amount < 1 then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ">=1"))
        return ""
    end

    if target == ply then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("recipient"), ""))
        return ""
    end

    if target:GetPos():DistToSqr(ply:GetPos()) >= maxDistance * maxDistance then
        DarkRP.notify(ply, 1, 4, target:Nick() .. " is too far away.")
        return ""
    end

    if not ply:canAfford(amount) then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))
        return ""
    end

    DarkRP.payPlayer(ply, target, amount)

    hook.Call("playerGaveMoney", nil, ply, target, amount)

    DarkRP.notify(target, 0, 4, DarkRP.getPhrase("has_given", ply:Nick(), DarkRP.formatMoney(amount)))
    DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_gave", target:Nick(), DarkRP.formatMoney(amount)))
    DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") has sent " .. DarkRP.formatMoney(amount) .. " to " .. target:Nick() .. " (" .. target:SteamID() .. ")")

    return ""
end
DarkRP.defineChatCommand("sendmoney", SendMoney, 0.2)
