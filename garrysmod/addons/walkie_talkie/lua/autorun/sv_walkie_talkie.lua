if SERVER then
    util.AddNetworkString("WalkieTalkie.SpeakerToggle")
    util.AddNetworkString("WalkieTalkie.MicroToggle")
    util.AddNetworkString("WalkieTalkie.ChangeChannel")

    hook.Add("PlayerInitialSpawn", "WalkieTalkie_PlayerInitialSpawn", function(ply)
        ply.walkie_talkie = {
            speaker = false,
            micro = false
        }
        ply:SetNW2Var("hborn_radio", nil)
    end)

    net.Receive("WalkieTalkie.SpeakerToggle", function(len, ply)
        ply.walkie_talkie.speaker = not ply.walkie_talkie.speaker
        local status = ply.walkie_talkie.speaker and "увімкнули" or "вимкнули"
    end)

    net.Receive("WalkieTalkie.MicroToggle", function(len, ply)
        ply.walkie_talkie.micro = not ply.walkie_talkie.micro
        local status = ply.walkie_talkie.micro and "увімкнули" or "вимкнули"
    end)

    net.Receive("WalkieTalkie.ChangeChannel", function(len, ply)
        local channel = net.ReadInt(8)
        if not channel or channel < 0 or channel > 999 then
            ply:ChatPrint("Частота може бути від 0 до 999!")
            return
        end
        ply:SetNW2Var("hborn_radio", channel)
        ply:ChatPrint("Ви встановили канал рації на " .. channel)
    end)

    hook.Add("PlayerSay", "WalkieTalkie_SetRadio", function(ply, text)
        local args = string.Explode(" ", text)
        if args[1]:lower() == "/setradio" then
            local channel = tonumber(args[2])
            if not channel then
                ply:ChatPrint("Вкажіть частоту!")
                return ""
            end
            if channel < 0 or channel > 999 then
                ply:ChatPrint("Частота може бути від 0 до 999!")
                return ""
            end
            ply:SetNW2Var("hborn_radio", channel)
            ply:ChatPrint("Ви встановили частоту рації на " .. channel)
            return ""
        end
    end)

    -- Голосовой чат по каналу
    hook.Add("PlayerCanHearPlayersVoice", "WalkieTalkie_PlayerCanHearPlayersVoice", function(listener, talker)
        if not IsValid(listener) or not IsValid(talker) then return end
        if not listener.walkie_talkie or not talker.walkie_talkie then return end

        local listener_channel = listener:GetNW2Var("hborn_radio")
        local talker_channel = talker:GetNW2Var("hborn_radio")

        if talker.walkie_talkie.micro and talker.walkie_talkie.speaker and listener.walkie_talkie.speaker then
            if listener_channel and talker_channel and listener_channel == talker_channel then
                return true
            end
        end
    end)

    local function getPlayersInChannel(channel)
        local targets = {}
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetNW2Var("hborn_radio") == channel then
                table.insert(targets, ply)
            end
        end
        return targets
    end

    local function sendGroupMessage(ply, text)
        local channel = ply:GetNW2Var("hborn_radio")
        if not channel then
            ply:ChatPrint("Ви не підключені до рації.")
            return
        end
        text = string.gsub(text, "^/g%s*", "")
        for _, target in ipairs(getPlayersInChannel(channel)) do
            DarkRP.talkToPerson(target, team.GetColor(ply:Team()), "[" .. channel .. "] " .. ply:Nick(), color_white, text, ply)
        end
    end

    hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)
        if string.StartWith(text, "/g") or teamonly then
            sendGroupMessage(ply, text)
            return ""
        end
    end)
end
