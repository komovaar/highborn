if SERVER then
    util.AddNetworkString("WalkieTalkie.SwapChannels")
    util.AddNetworkString("WalkieTalkie.SetActiveChannel")
    util.AddNetworkString("WalkieTalkie.SetAltChannel")
    util.AddNetworkString("WalkieTalkie.SpeakerToggle")
    util.AddNetworkString("WalkieTalkie.MicroToggle")
    util.AddNetworkString("WalkieTalkie.ChangeChannel")

    net.Receive("WalkieTalkie.SpeakerToggle", function (len, ply)
        if ply.walkie_talkie.speaker then 
            ply.walkie_talkie.speaker = false
        else 
            ply.walkie_talkie.speaker = true
        end
    end)

    net.Receive("WalkieTalkie.MicroToggle", function (len, ply)
        if  ply.walkie_talkie.micro then 
            ply.walkie_talkie.micro = false
        else 
            ply.walkie_talkie.micro = true
        end
    end)

    hook.Add("PlayerInitialSpawn", "WalkieTalkie_Init", function(ply)
        ply.walkie_talkie = { speaker = false, micro = false }
        ply:SetNW2Var("radio_main", nil)
        ply:SetNW2Var("radio_alt", nil)
        ply:SetNW2Var("radio_active", nil)
    end)

    net.Receive("WalkieTalkie.SetActiveChannel", function(len, ply)
        local channel = net.ReadInt(8)
        ply:SetNW2Var("radio_active", channel)
    end)

    net.Receive("WalkieTalkie.SetAltChannel", function(len, ply)
        local channel = net.ReadInt(8)
        ply:SetNW2Var("radio_alt", channel)
    end)

    hook.Add("PlayerCanHearPlayersVoice", "WalkieTalkie_VoiceChat", function(listener, talker)
        if not IsValid(listener) or not IsValid(talker) then return end
        if not listener.walkie_talkie or not talker.walkie_talkie then return end
        if not talker.walkie_talkie.micro or not talker.walkie_talkie.speaker then return end

        local talker_chan = talker:GetNW2Var("radio_active")
        local listener_main = listener:GetNW2Var("radio_main")
        local listener_alt = listener:GetNW2Var("radio_alt")
        print(talker_chan)
        print(listener_main)

        if talker_chan and (talker_chan == listener_main or talker_chan == listener_alt) and listener.walkie_talkie.speaker then
            return true
        end
    end)

    local function getPlayersInChannel(channel)
        local targets = {}
        for _, ply in ipairs(player.GetAll()) do
            local main = ply:GetNW2Var("radio_main")
            local alt = ply:GetNW2Var("radio_alt")
            if main == channel or alt == channel then
                table.insert(targets, ply)  
            end
        end
        return targets
    end

    local function sendGroupMessage(ply, text)
        local channel = ply:GetNW2Var("radio_active")
        if not channel then
            local main = ply:GetNW2Var("radio_main")
            if main then
                ply:SetNW2Var("radio_active", main)
                channel = ply:GetNW2Var("radio_active")
            end
        end
        text = string.gsub(text, "^/g%s*", "")
        for _, target in ipairs(getPlayersInChannel(channel)) do
            DarkRP.talkToPerson(target, team.GetColor(ply:Team()), "["..channel.."] ", color_white, text, ply)
        end
    end

    hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)
        local txt = text:lower()
        local args = string.Explode(" ", text)

        if string.StartWith(txt, "/g") or teamonly then
            sendGroupMessage(ply, text)
            return ""
        elseif string.StartWith(txt, "/setmain") then
            local chan = tonumber(args[2])
            if chan then
                ply:SetNW2Var("radio_main", chan)
                local main = ply:GetNW2Var("radio_main")
                ply:SetNW2Var("radio_active", main)
            end
            return ""
        elseif string.StartWith(txt, "/setalt") then
            local chan = tonumber(args[2])
            if chan then
                ply:SetNW2Var("radio_alt", chan)
                if not ply:GetNW2Var("radio_main") then 
                    local alt = ply:GetNW2Var("radio_alt")
                    ply:SetNW2Var("radio_active", alts)
                end
                
            end
            return ""
        end
    end)
end
