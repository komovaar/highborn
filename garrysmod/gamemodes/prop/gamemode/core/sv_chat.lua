prop.chat = prop.chat or {}

local function normalizeTargets(target)
    if target == nil then return player.GetAll() end
    if IsValid(target) and target:IsPlayer() then return {target} end
    if istable(target) then return target end

    return {}
end

function prop.chat.send(target, parts)
    local normalized, reason = prop.net.normalizeChatParts(parts)
    if not normalized then return false, reason end

    local targets = normalizeTargets(target)
    if #targets == 0 then return false, "no_targets" end

    net.Start("prop.ChatBroadcast")
        prop.net.writeChatParts(normalized)
    net.Send(targets)

    hook.Run("prop.ChatMessageSent", targets, normalized)
    return true
end

function prop.chat.broadcast(parts)
    return prop.chat.send(player.GetAll(), parts)
end

function prop.chat.message(target, ...)
    local parts = {...}
    if #parts == 0 then return false, "empty_message" end

    return prop.chat.send(target, parts)
end

function prop.chat.notify(target, message)
    return prop.chat.message(target, Color(120, 180, 255), "[prop] ", color_white, tostring(message))
end

function prop.chat.proximity(ply, radius, parts)
    if not IsValid(ply) then return false, "invalid_player" end
    if not isnumber(radius) or radius <= 0 then return false, "invalid_radius" end
    if not istable(parts) then return false, "invalid_parts" end

    local targets = {}
    local origin = ply:GetPos()
    local maxDistSqr = radius * radius

    for _, v in ipairs(player.GetAll()) do
        if v:GetPos():DistToSqr(origin) <= maxDistSqr then
            table.insert(targets, v)
        end
    end

    return prop.chat.send(targets, parts)
end
