--[[---------------------------------------------------------
Talking
 ---------------------------------------------------------]]
local function PM(ply, args)
    local namepos = string.find(args, " ")
    if not namepos then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local name = string.sub(args, 1, namepos - 1)
    local msg = string.sub(args, namepos + 1)

    if msg == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local target = DarkRP.findPlayer(name)
    if target == ply then return "" end

    if target then
        local col = team.GetColor(ply:Team())
        local pname = ply:Nick()
        local col2 = color_white
        DarkRP.talkToPerson(target, col, "[PM]", col2, msg, ply)
        DarkRP.talkToPerson(ply, col, "[PM]", col2, msg, ply)
    else
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(name)))
    end

    return ""
end
DarkRP.defineChatCommand("pm", PM, 1.5)

local function Whisper(ply, args)
    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
        DarkRP.talkToRange(ply, "[Шепіт]", text, GAMEMODE.Config.whisperDistance)
    end
    return args, DoSay
end
DarkRP.defineChatCommand("w", Whisper, 1.5)

local function Yell(ply, args)
    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
        DarkRP.talkToRange(ply, "[Крик]", text, GAMEMODE.Config.yellDistance)
    end
    return args, DoSay
end
DarkRP.defineChatCommand("y", Yell, 1.5)

local function Me(ply, args)
    if args == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
        if GAMEMODE.Config.alltalk then
            local col = team.GetColor(ply:Team())
            local name = ply:Nick()
            for _, target in ipairs(player.GetAll()) do
                DarkRP.talkToPerson(target, col, name .. " " .. text)
            end
        else
            DarkRP.talkToRange(ply, ply:Nick() .. " " .. text, "", GAMEMODE.Config.meDistance)
        end
    end
    return args, DoSay
end
DarkRP.defineChatCommand("me", Me, 1.5)

local function OOC(ply, args)
    if not GAMEMODE.Config.ooc then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", DarkRP.getPhrase("ooc"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
        local col = Color(204, 0, 0)
        local col2 = color_white
        if not ply:Alive() then
            col2 = Color(204, 200, 200, 255)
            col = col2
        end

        local phrase = DarkRP.getPhrase("ooc")
        local name = ply:Nick()
        for _, v in ipairs(player.GetAll()) do
            DarkRP.talkToPerson(v, col, "[" .. phrase .. "]", col2, text, ply)
        end
    end
    return args, DoSay
end
DarkRP.defineChatCommand("/", OOC, true, 1.5)
DarkRP.defineChatCommand("a", OOC, true, 1.5)
DarkRP.defineChatCommand("ooc", OOC, true, 1.5)

local function LOOC(ply, args)
    if not GAMEMODE.Config.ooc then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", DarkRP.getPhrase("ooc"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end

        local col = Color(255, 255, 102, 255) 
        local col2 = color_white     

        local phrase = "LOOC"
        local name = ply:Nick()

        for _, v in ipairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) <= GAMEMODE.Config.talkDistance then
                DarkRP.talkToPerson(v, col, "[" .. phrase .. "]", col2, text, ply)
            end
        end
    end

    return args, DoSay
end

DarkRP.defineChatCommand("looc", LOOC, true, 1.5)
DarkRP.defineChatCommand("l", LOOC, true, 1.5)

local function Advert(ply, args)
    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
        local col = Color(51, 255, 153)
        local col2 = color_white
        if not ply:Alive() then
            col2 = Color(255, 200, 200, 255)
            col = col2
        end

        local phrase = "Оголошення"
        local name = ply:Nick()
        for _, v in ipairs(player.GetAll()) do
            DarkRP.talkToPerson(v, col, "[" .. phrase .. "]", col2, text, ply)
        end
    end
    return args, DoSay
end
DarkRP.defineChatCommand("ad", Advert, true, 1.5)
DarkRP.defineChatCommand("advert", Advert, true, 1.5)

local function Roll(ply)
    local num = math.random(1, 100)

    DarkRP.talkToRange(ply, ply:Nick() .. " " .. " викинув число: " .. num, "", GAMEMODE.Config.meDistance)

    return ""
end
DarkRP.defineChatCommand("roll", Roll, true, 1.5)

local function Do(ply, args)
    if args == "" then return "" end

    DarkRP.talkToRange(ply, args .. " (" .. ply:Nick() .. ")", "", GAMEMODE.Config.meDistance)

    return ""
end
DarkRP.defineChatCommand("do", Do, true, 1.5)
DarkRP.defineChatCommand("it", Do, true, 1.5)

function Try(ply, args)
    if args == "" then return "" end

    local success = math.random(1,2) == 1
    local result = success and "успішно" or "неуспішно"
    DarkRP.talkToRange(ply, ply:Nick() .. " " .. args .. ", " .. result, "", GAMEMODE.Config.meDistance)
    return ""
end
DarkRP.defineChatCommand("try", Try, true, 1.5)

DarkRP.defineChatCommand("helmet", function(ply, args)

    local id = ply:FindBodygroupByName("helmet")
    if id == -1 then
        id = ply:FindBodygroupByName("helm")
    end
    if id == -1 then
        id = ply:FindBodygroupByName("head")
    end
    if id == -1 then
        DarkRP.notify(ply, 1, 4, "У вас немає шолома")
        return ""
    end

    local current = ply:GetBodygroup(id)

    if current == 0 then
        ply:SetBodygroup(id, 1)
    else
        ply:SetBodygroup(id, 0)
    end

    return ""
end)