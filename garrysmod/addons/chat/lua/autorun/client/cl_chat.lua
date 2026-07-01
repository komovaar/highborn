chatbox = chatbox or {}

chatbox.timestamps = true
chatbox.fadetime = 10
chatbox.col_background = Color(26, 26, 26, 200)
chatbox.col_textentry = Color(30, 30, 30, 100)

chatbox.history = {}
chatbox.curHistory = 1

if not GAMEMODE then
	hook.Remove("Initialize", "chatbox_init")
	hook.Add("Initialize", "chatbox_init", function()
		include("autorun/client/cl_chat.lua")
		chatbox.build()
	end)
	return
end

function chatbox.build()    
    chatbox.frame = vgui.Create("DFrame")
    chatbox.frame:SetSize(800, 300)
    chatbox.frame:SetTitle("")
    chatbox.frame:ShowCloseButton(false)
    chatbox.frame:SetDraggable(true)
    chatbox.frame:SetSizable(false)
    chatbox.frame:SetPos(20, (ScrH() - chatbox.frame:GetTall()) - ScrH() * 0.1)
    chatbox.frame:SetMinWidth(300)
    chatbox.frame:SetMinHeight(100)

    function chatbox.frame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then 
            chatbox:hide()
        end
    end
    
    function chatbox.frame:Paint(w, h)
        DrawBlur(self)
        draw.RoundedBox(0, 0, 0, w, h, chatbox.col_background)
    end
    chatbox.oldPaint = chatbox.frame.Paint

    chatbox.entry = vgui.Create("DTextEntry", chatbox.frame) 
    chatbox.entry:SetSize(chatbox.frame:GetWide() - 10, 20)
    chatbox.entry:SetTextColor(color_white)
    chatbox.entry:SetFont("chat18")
    chatbox.entry:SetDrawBorder(false)
    chatbox.entry:SetDrawBackground(false)
    chatbox.entry:SetCursorColor(color_white)
    chatbox.entry:SetHighlightColor(Color(52, 152, 219))
    chatbox.entry:SetPos(5, chatbox.frame:GetTall() - chatbox.entry:GetTall() - 5)
    
    function chatbox.entry:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, chatbox.col_textentry)
        derma.SkinHook("Paint", "TextEntry", self, w, h)
    end

    function chatbox.entry:OnTextChanged()
        if self and self.GetText then
            gamemode.Call("ChatTextChanged", self:GetText() or "")
        end
    end

    function chatbox.entry:OnKeyCodeTyped(code)
        local types = {"", "console"}

        if code == KEY_ESCAPE then
            if IsValid(chatbox) then 
                chtabox:hide()
                gui.HideGameUI()
            end

        elseif code == KEY_UP then
            if #chatbox.history == 0 then return end
            
            chatbox.curHistory = chatbox.curHistory - 1
            if chatbox.curHistory <= 0 then 
                chatbox.curHistory = #chatbox.history 
            end

            local current = chatbox.history[chatbox.curHistory]
            
            self:SetText(current)
            self:SetCaretPos(#current)

        elseif code == KEY_DOWN then
            if #chatbox.history == 0 then return end

            chatbox.curHistory = chatbox.curHistory + 1
            if chatbox.curHistory > #chatbox.history then 
                chatbox.curHistory = 1 
            end

            local current = chatbox.history[chatbox.curHistory]
            
            self:SetText(current)
            self:SetCaretPos(#current)

        elseif code == KEY_ENTER then
            local text = self:GetText() or ""

            if chatbox.ChatType == "console" then 
                LocalPlayer():ConCommand(text)
            end

            if string.Trim(text) != "" then
                table.insert(chatbox.history, text)
                chatbox.curHistory = #chatbox.history + 1

                net.Start("chatbox_say")
                    net.WriteString(text)
                net.SendToServer()
            end
        chatbox:hide()
    end
    end

    chatbox.log = vgui.Create("RichText", chatbox.frame) 
    chatbox.log:SetPos(5, 5)
    chatbox.log:SetSize(chatbox.frame:GetWide() - 10, chatbox.frame:GetTall() - chatbox.entry:GetTall() - 10)
    chatbox.log.Paint = function() end

    function chatbox.log:Think()
        if chatbox.last then
            if CurTime() - chatbox.last > chatbox.fadetime then
                self:SetVisible(false)
            else
                self:SetVisible(true)
            end
        end
        self:SetSize(chatbox.frame:GetWide(), chatbox.frame:GetTall() - chatbox.entry:GetTall())
    end
    
    function chatbox.log:PerformLayout()
        self:SetFontInternal("chat18")
        self:SetFGColor(color_white)
    end
    
    chatbox.oldPaint2 = chatbox.log.Paint
    chatbox.hide()
end

function chatbox.show()
    chatbox.frame.Paint = chatbox.oldPaint
    chatbox.log.Paint = chatbox.oldPaint2
    chatbox.log:SetVerticalScrollbarEnabled(true)
    chatbox.last = nil
    chatbox.entry:SetVisible(true)
    chatbox.log:SetVisible(true)
    chatbox.frame:MakePopup()
    chatbox.entry:RequestFocus()
    gamemode.Call("StartChat")
end

function chatbox.hide()
    chatbox.frame.Paint = function() end
    chatbox.log.Paint = function() end
    chatbox.log:SetVerticalScrollbarEnabled(false)
    chatbox.log:GotoTextEnd()
    chatbox.last = chatbox.last or CurTime() - chatbox.fadetime
    chatbox.entry:SetVisible(false)
    chatbox.frame:SetMouseInputEnabled(false)
    chatbox.frame:SetKeyboardInputEnabled(false)
    gui.EnableScreenClicker(false)
    gamemode.Call("FinishChat")
    chatbox.entry:SetText( "" )
    gamemode.Call("ChatTextChanged", "")
end

function chat.AddText(...)
    if not chatbox.log then 
        chatbox:build()
    end

    local msg = {}

    for k, obj in pairs({...}) do
        if type(obj) == "table" then
            chatbox.log:InsertColorChange(obj.r, obj.g, obj.b, obj.a)
            table.insert(msg, Color(obj.r, obj.g, obj.b, obj.a) )

        elseif type(obj) == "string" then
            chatbox.log:AppendText(obj)
            table.insert(msg, obj)

        elseif obj:IsPlayer() then
            local ply = obj

            if chatbox.timestamps then
                chatbox.log:InsertColorChange(130, 130, 130, 255)
                chatbox.log:AppendText(""..os.date("%H:%M").." ")
            end

            local col = GAMEMODE:GetTeamColor(obj)
            chatbox.log:InsertColorChange(col.r, col.g, col.b, 255)
            chatbox.log:AppendText(obj:Nick())
            table.insert(msg, obj:Nick())
        end
    end
    chatbox.log:AppendText("\n")

    chatbox.log:SetVisible(true)
    chatbox.last = CurTime()
    chatbox.log:InsertColorChange(255, 255, 255, 255)
end

hook.Remove("ChatText", "chatbox_joinleave")
hook.Add("ChatText", "chatbox_joinleave", function (index, name, text, type)
    if not chatbox.log then 
        chatbox:build()
    end
end)

hook.Remove("PlayerBindPress", "chatbox_hijackbind")
hook.Add("PlayerBindPress", "chatbox_hijackbind", function(ply, bind, pressed)
    if string.sub( bind, 1, 11 ) == "messagemode" then
		chatbox.ChatType = ""
        
        if IsValid(chatbox.frame) then 
            chatbox:show()
        else
            chatbox:build()
            chatbox:show()
        end
        return true
    end
end)

hook.Remove("HUDShouldDraw", "chathbox_hidedefault")
hook.Add("HUDShouldDraw", "chatbox_hidedefault", function(name)
    if name == "CHudChat" then 
        return false 
    end
end)

function chat.GetChatBoxPos()
    return chatbox.frame:GetPos()
end

function chat.GetChatBoxSize()
    return chatbox.frame:GetSize()
end

chat.Open = chatbox.show
function chat.Close(...) 
    if IsValid(chatbox.frame) then 
        chatbox:hide()
    else 
        chatbox:build()
        chatbox:show()
    end
end