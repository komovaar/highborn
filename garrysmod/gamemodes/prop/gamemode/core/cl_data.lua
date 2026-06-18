function prop.data.localGet(key, default)
    local ply = LocalPlayer()
    if not IsValid(ply) or not istable(ply.prop) then return default end

    local value = ply.prop[key]
    if value == nil then return default end

    return value
end

net.Receive("prop.DataSync", function()
    local key = net.ReadString()
    if not prop.net.isValidKey(key) then return end

    local value = prop.net.readValue()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local data = istable(ply.prop) and ply.prop or {}
    ply.prop = data
    data[key] = value
end)

net.Receive("prop.ChatBroadcast", function()
    chat.AddText(unpack(prop.net.readChatParts()))
end)
