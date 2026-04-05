util.AddNetworkString("chatbox_say")

net.Receive("chatbox_say", function(len, ply)
    if not IsValid(ply) then return end
    local text = net.ReadString()
    if not text or string.Trim(text) == "" then return end
    text = string.gsub(text, "[\n\r]", "")
    hook.Call("PlayerSay", GAMEMODE, ply, text, false)
end)