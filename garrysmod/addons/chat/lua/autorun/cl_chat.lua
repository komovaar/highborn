
local LUCTUS_CHAT_USE_TIMESTAMPS = true
local LUCTUS_CHAT_MSG_FADETIME = 10

local color_background = Color(26, 26, 26, 200)
local color_textentry = Color(30, 30, 30, 100)

if CLIENT then
surface.CreateFont( "eChat_18", {
    font = "Roboto",
    size = 18,
    weight = 500,
    antialias = true,
    shadow = true,
    outline = false,
    extended=true,
})

local blur = Material("pp/blurscreen")
local function DrawBlur(panel)
    local x,y = panel:LocalToScreen(0,0)
    surface.SetMaterial(blur)
    surface.SetDrawColor(255,255,255)
    for i=1,6 do
        blur:SetFloat("$blur",i)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
    end
end

eChat = eChat or {}
eChat.history = {}
eChat.curHistory = 1

--// Builds the chatbox but don't display it
function eChat.buildBox()
    if IsValid(eChat.frame) then return end
    eChat.frame = vgui.Create("DFrame")
    eChat.frame:SetSize( 800, 300 )
    eChat.frame:SetTitle("")
    eChat.frame:ShowCloseButton(false)
    eChat.frame:SetDraggable(true)
    eChat.frame:SetSizable(false)
    eChat.frame:SetPos(20, (ScrH() - eChat.frame:GetTall()) - ScrH() * 0.1)
    eChat.frame:SetMinWidth( 300 )
    eChat.frame:SetMinHeight( 100 )
    function eChat.frame:Paint(w, h)
        DrawBlur(self)
        draw.RoundedBox( 0, 0, 0, w, h, color_background )
    end

    eChat.oldPaint = eChat.frame.Paint
    
    eChat.entry = vgui.Create("DTextEntry", eChat.frame) 
    eChat.entry:SetSize( eChat.frame:GetWide() - 10, 20 )
    eChat.entry:SetTextColor( color_white )
    eChat.entry:SetFont("eChat_18")
    eChat.entry:SetDrawBorder( false )
    eChat.entry:SetDrawBackground( false )
    eChat.entry:SetCursorColor( color_white )
    eChat.entry:SetHighlightColor(Color(52, 152, 219))
    eChat.entry:SetPos( 5, eChat.frame:GetTall() - eChat.entry:GetTall() - 5 )
    eChat.entry.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, color_textentry)
        derma.SkinHook("Paint", "TextEntry", self, w, h)
    end
    eChat.entry.OnFocusChanged = function(self,gained)
        self.iHasFocus = gained
        timer.Simple(0,function()
            if not self.iHasFocus and not eChat.chatLog.iHasFocus then
                eChat.entry:RequestFocus()
            end
        end)
    end
    eChat.entry.OnTextChanged = function(self)
        gamemode.Call( "ChatTextChanged", self:GetText() or "" )
    end

    eChat.entry.OnKeyCodeTyped = function( self, code )
        gui.HideGameUI() --faster than waiting for escape press check
        if code == KEY_ESCAPE then
            eChat.hideBox()
        elseif code == KEY_UP then
            if #eChat.history == 0 then return end
            eChat.curHistory = eChat.curHistory -1
            if eChat.curHistory <= 0 then eChat.curHistory = #eChat.history end
            local h = eChat.history[eChat.curHistory]
            self:SetText(h)
            self:SetCaretPos(#h)
        elseif code == KEY_DOWN then
            if #eChat.history == 0 then return end
            eChat.curHistory = eChat.curHistory +1
            if eChat.curHistory > #eChat.history then eChat.curHistory = 1 end
            local h = eChat.history[eChat.curHistory]
            self:SetText(h)
            self:SetCaretPos(#h)
        elseif code == KEY_ENTER then
            local txt = string.Trim(self:GetText() or "")

            if txt ~= "" then
                print(txt)
                RunConsoleCommand("say", txt)
                table.insert(eChat.history, txt)
            end

            eChat.hideBox()
        end
    end

    eChat.chatLog = vgui.Create("RichText", eChat.frame) 
    eChat.chatLog:SetPos(0, 0)
    eChat.chatLog.Paint = function() end
    eChat.chatLog:SetSelectable(true)
    eChat.chatLog:SetMouseInputEnabled(true)
    eChat.chatLog:SetKeyboardInputEnabled(true)
    eChat.chatLog:SetWrap(true)

    function eChat.chatLog:OnFocusChanged(gained)
        self.iHasFocus = gained
    end
    
    
    function eChat.chatLog:OnKeyCodeReleased(code)
        if code == KEY_ESCAPE then
            eChat.hideBox()
            return true
        end
    end
    
    function eChat.chatLog:Think()
        if eChat.lastMessage then
            if gui.IsGameUIVisible() or CurTime() - eChat.lastMessage > LUCTUS_CHAT_MSG_FADETIME then
                self:SetVisible(false)
            else
                self:SetVisible(true)
            end
        end
        self:SetSize( eChat.frame:GetWide() - 10, eChat.frame:GetTall() - eChat.entry:GetTall())
    end
    
    function eChat.chatLog:PerformLayout()
        self:SetFontInternal("eChat_18")
        self:SetFGColor( color_white )
    end
    
    eChat.oldPaint2 = eChat.chatLog.Paint
    eChat.hideBox()
end

--// Hides the chat box but not the messages
function eChat.hideBox()
    eChat.ChatType = ""
    eChat.curHistory = 1
    eChat.TypeSelector = 1
    gui.HideGameUI()
    
    eChat.frame.Paint = function() end
    eChat.chatLog.Paint = function() end
    
    eChat.chatLog:SetVerticalScrollbarEnabled(false)
    eChat.chatLog:GotoTextEnd()
    
    eChat.lastMessage = eChat.lastMessage or CurTime() - LUCTUS_CHAT_MSG_FADETIME
    
    eChat.entry:SetVisible(false)
    
    -- Give the player control again
    eChat.frame:SetMouseInputEnabled( false )
    eChat.frame:SetKeyboardInputEnabled( false )
    gui.EnableScreenClicker( false )
    
    -- We are done chatting
    gamemode.Call("FinishChat")
    
    -- Clear the text entry
    eChat.entry:SetText( "" )
    gamemode.Call( "ChatTextChanged", "" )
end

--// Shows the chat box
function eChat.showBox()
    -- Draw the chat box again
    eChat.frame.Paint = eChat.oldPaint
    eChat.chatLog.Paint = eChat.oldPaint2
    
    eChat.chatLog:SetVerticalScrollbarEnabled( true )
    eChat.lastMessage = nil
    
    eChat.entry:SetVisible(true)
    eChat.chatLog:SetVisible(true)
    
    -- MakePopup calls the input functions so we don't need to call those
    eChat.frame:MakePopup()
    eChat.entry:RequestFocus()
    
    -- Make sure other addons know we are chatting
    gamemode.Call("StartChat")
end

local oldAddText = chat.AddText

local function AppendWrappedText(rtext, str)
    local maxLen = 80
    while #str > maxLen do
        local breakAt = maxLen
        -- Try to find a space to break at
        for i = maxLen, 1, -1 do
            if str:sub(i, i) == " " then
                breakAt = i
                break
            end
        end
        rtext:AppendText(str:sub(1, breakAt))
        rtext:AppendText("\n")
        str = str:sub(breakAt + 1)
    end
    if #str > 0 then
        rtext:AppendText(str)
    end
end

function chat.AddText(...)
    if not IsValid(eChat.frame) then eChat.buildBox() end
    local msg = {}
    if LUCTUS_CHAT_USE_TIMESTAMPS then
        eChat.chatLog:InsertColorChange( 130, 130, 130, 255 )
        eChat.chatLog:AppendText( ""..os.date("%H:%M").." " )
    end
    for k, obj in pairs({...}) do
        if type(obj) == "table" then
            eChat.chatLog:InsertColorChange(obj.r,obj.g,obj.b,obj.a)
        elseif type(obj) == "string" then
            -- переносим текст даже для команд
            AppendWrappedText(eChat.chatLog, obj)
        elseif obj:IsPlayer() then
            local col = GAMEMODE:GetTeamColor(obj)
            eChat.chatLog:InsertColorChange(col.r,col.g,col.b,255)
            AppendWrappedText(eChat.chatLog, obj:Nick())
        end
    end
    eChat.chatLog:SetVisible(true)
    eChat.chatLog:AppendText("\n") 
    eChat.lastMessage = CurTime()
    eChat.chatLog:InsertColorChange(255,255,255,255)
end

hook.Add("PlayerBindPress", "luctus_chat", function(ply, bind, pressed)
    if not IsValid(eChat.frame) then eChat.buildBox() end
    if string.sub(bind, 1, 11) == "messagemode" and pressed then
        if bind == "messagemode2" then 
            eChat.ChatType = "teamchat"
        else
            eChat.ChatType = ""
        end
        
        eChat.showBox()
        return true
    end
end)

local dontDrawChat = {
    ["CHudChat"] = false,
}
hook.Add("HUDShouldDraw", "luctus_chat_hidedefault", function(name)
    return dontDrawChat[name]
end)

function chat.GetChatBoxPos()
    if not IsValid(eChat.frame) then eChat.buildBox() end
    return eChat.frame:GetPos()
end

function chat.GetChatBoxSize()
    if not IsValid(eChat.frame) then eChat.buildBox() end
    return eChat.frame:GetSize()
end

chat.Open = eChat.showBox
function chat.Close(...) 
    eChat.hideBox(...)
end

hook.Add("InitPostEntity", "luctus_chat", function()
    if not IsValid(eChat.frame) then eChat.buildBox() end
end)

end