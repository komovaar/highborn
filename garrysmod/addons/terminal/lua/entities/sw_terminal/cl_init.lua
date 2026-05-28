include("shared.lua")

local COL_BG = Color(5, 12, 18, 246)
local COL_PANEL = Color(9, 24, 34, 230)
local COL_PANEL_SOFT = Color(10, 36, 48, 150)
local COL_LINE = Color(44, 178, 218, 190)
local COL_LINE_DIM = Color(44, 178, 218, 45)
local COL_TEXT = Color(186, 225, 238)
local COL_MUTED = Color(105, 154, 172)
local COL_GREEN = Color(86, 226, 142)
local COL_AMBER = Color(255, 186, 79)
local COL_RED = Color(255, 82, 82)
local COL_WHITE = Color(235, 245, 248)

surface.CreateFont("RepTerm_3DTitle", { font = "Jura", size = 44, weight = 800, antialias = true })
surface.CreateFont("RepTerm_3DSub", { font = "Jura", size = 24, weight = 600, antialias = true })
surface.CreateFont("RepTerm_Model", { font = "Overpass", size = 64, weight = 800, extended = true })
surface.CreateFont("RepTerm_Title", { font = "Jura", size = 22, weight = 800, antialias = true })
surface.CreateFont("RepTerm_Label", { font = "Jura", size = 15, weight = 700, antialias = true })
surface.CreateFont("RepTerm_Status", { font = "Jura", size = 18, weight = 800, antialias = true })
surface.CreateFont("RepTerm_Text", { font = "Tahoma", size = 15, weight = 500, antialias = true })
surface.CreateFont("RepTerm_Console", { font = "Consolas", size = 16, weight = 500, antialias = true })
surface.CreateFont("RepTerm_Button", { font = "Jura", size = 16, weight = 800, antialias = true })

local function DrawOutlinedPanel(x, y, w, h, accent, fill)
    draw.RoundedBox(4, x, y, w, h, fill or COL_PANEL)
    surface.SetDrawColor(accent or COL_LINE)
    surface.DrawOutlinedRect(x, y, w, h, 1)

    local l = 16
    surface.DrawLine(x, y + l, x, y)
    surface.DrawLine(x, y, x + l, y)
    surface.DrawLine(x + w - l, y, x + w, y)
    surface.DrawLine(x + w, y, x + w, y + l)
    surface.DrawLine(x, y + h - l, x, y + h)
    surface.DrawLine(x, y + h, x + l, y + h)
    surface.DrawLine(x + w - l, y + h, x + w, y + h)
    surface.DrawLine(x + w, y + h - l, x + w, y + h)
end

local function DrawCircle(x, y, radius, color, segments)
    surface.SetDrawColor(color)
    draw.NoTexture()

    local poly = {}
    segments = segments or 48
    for i = 0, segments do
        local a = math.rad((i / segments) * -360)
        poly[#poly + 1] = {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius
        }
    end

    surface.DrawPoly(poly)
end

local function DrawStatusDot(x, y, color)
    DrawCircle(x, y, 8, color, 24)
    DrawCircle(x, y, 14, Color(color.r, color.g, color.b, 24), 24)
end

local function ButtonPaint(self, w, h)
    local col = self:IsHovered() and COL_LINE or COL_LINE_DIM
    draw.RoundedBox(3, 0, 0, w, h, self:IsHovered() and Color(18, 55, 68, 235) or Color(8, 24, 32, 220))
    surface.SetDrawColor(col)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos()
        + self:GetUp() * 70
        + self:GetForward() * 4

    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    cam.Start3D2D(pos, ang, 0.05)
        draw.SimpleText(
            "TERMINAL",
            "RepTerm_Model",
            0,
            0,
            self:GetIsBroken() and COL_RED or COL_LINE,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    cam.End3D2D()
end

net.Receive("RepTerminal_OpenUI", function()
    local targetEnt = net.ReadEntity()
    local isBroken = net.ReadBool()
    local enemyCount = net.ReadInt(16)

    if not IsValid(targetEnt) then return end

    local frame = vgui.Create("DFrame")
    frame:SetSize(math.min(980, ScrW() - 80), math.min(620, ScrH() - 80))
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()

    local radarActive = false
    local step = 0
    local isProcessing = false
    local title = isBroken and "MAINTENANCE CONSOLE" or "OPERATIONAL CONSOLE"
    local nodeStatus = isBroken and "DEGRADED" or "STABLE"
    local nodeColor = isBroken and COL_RED or COL_GREEN

    frame.Paint = function(_, w, h)
        Derma_DrawBackgroundBlur(frame, frame.m_fCreateTime or SysTime())
        draw.RoundedBox(6, 0, 0, w, h, COL_BG)

        surface.SetDrawColor(COL_LINE_DIM)
        for x = 24, w, 48 do surface.DrawLine(x, 54, x, h - 18) end
        for y = 78, h, 48 do surface.DrawLine(18, y, w - 18, y) end

        DrawOutlinedPanel(12, 12, w - 24, h - 24, isBroken and COL_RED or COL_LINE, Color(2, 10, 15, 210))
        draw.RoundedBox(0, 13, 52, w - 26, 1, isBroken and COL_RED or COL_LINE)

        draw.SimpleText("GAR FIELD NETWORK", "RepTerm_Label", 28, 24, COL_MUTED)
        draw.SimpleText(title, "RepTerm_Title", w / 2, 17, isBroken and COL_AMBER or COL_LINE, TEXT_ALIGN_CENTER)
        draw.SimpleText("SESSION " .. LocalPlayer():UserID(), "RepTerm_Label", w - 72, 24, COL_MUTED, TEXT_ALIGN_RIGHT)

        DrawOutlinedPanel(24, 74, 168, 170, COL_LINE_DIM, COL_PANEL_SOFT)
        draw.SimpleText("NODE STATUS", "RepTerm_Label", 38, 88, COL_MUTED)
        DrawStatusDot(50, 126, nodeColor)
        draw.SimpleText(nodeStatus, "RepTerm_Status", 70, 116, nodeColor)

        draw.SimpleText("CORE LOAD", "RepTerm_Label", 38, 156, COL_MUTED)
        surface.SetDrawColor(COL_LINE_DIM)
        surface.DrawOutlinedRect(38, 178, 118, 12, 1)
        draw.RoundedBox(0, 40, 180, math.abs(math.sin(CurTime() * 0.5)) * 114, 8, isBroken and COL_AMBER or COL_LINE)

        draw.SimpleText("THERMAL", "RepTerm_Label", 38, 204, COL_MUTED)
        surface.DrawOutlinedRect(38, 226, 118, 12, 1)
        local temp = isBroken and 94 or 43
        draw.RoundedBox(0, 40, 228, math.Clamp(temp, 0, 100) * 1.14, 8, isBroken and COL_RED or COL_GREEN)

        DrawOutlinedPanel(24, 260, 168, 160, COL_LINE_DIM, COL_PANEL_SOFT)
        draw.SimpleText("LOCAL SCAN", "RepTerm_Label", 38, 274, COL_MUTED)
        local cx, cy, radius = 104, 342, 54
        DrawCircle(cx, cy, radius, Color(28, 117, 146, 22), 48)
        surface.SetDrawColor(COL_LINE_DIM)
        surface.DrawOutlinedRect(cx - radius, cy - radius, radius * 2, radius * 2, 1)
        surface.DrawLine(cx - radius, cy, cx + radius, cy)
        surface.DrawLine(cx, cy - radius, cx, cy + radius)
        surface.SetDrawColor(COL_LINE)
        surface.DrawLine(cx, cy, cx + math.cos(CurTime() * 2) * radius, cy + math.sin(CurTime() * 2) * radius)

        if radarActive and IsValid(targetEnt) then
            local myPos = targetEnt:GetPos()
            local scanRadius = 10000
            for _, ent in ipairs(ents.FindInSphere(myPos, scanRadius)) do
                if ent:IsNPC() then
                    local delta = ent:GetPos() - myPos
                    local dist = math.min(delta:Length() / scanRadius, 1) * radius
                    local ang = math.rad(delta:Angle().y - targetEnt:GetAngles().y - 90)
                    local px = cx + math.cos(ang) * dist
                    local py = cy + math.sin(ang) * dist
                    surface.SetDrawColor(COL_RED)
                    surface.DrawRect(px - 2, py - 2, 4, 4)
                end
            end
        end

        DrawOutlinedPanel(w - 196, 74, 172, 346, COL_LINE_DIM, COL_PANEL_SOFT)
        draw.SimpleText("UPLINK", "RepTerm_Label", w - 180, 88, COL_MUTED)
        draw.SimpleText("CORUSCANT", "RepTerm_Text", w - 180, 116, COL_TEXT)
        draw.SimpleText("CHANNEL", "RepTerm_Label", w - 180, 154, COL_MUTED)
        draw.SimpleText("GAR-91 SEC", "RepTerm_Text", w - 180, 182, COL_TEXT)
        draw.SimpleText("BIOS", "RepTerm_Label", w - 180, 220, COL_MUTED)
        draw.SimpleText(isBroken and "RECOVERY" or "ACTIVE", "RepTerm_Text", w - 180, 248, nodeColor)
        draw.SimpleText("TRACE", "RepTerm_Label", w - 180, 300, COL_MUTED)
        for i = 0, 4 do
            local value = string.format("0x%04X", 1200 + i * 617 + math.floor(CurTime() * 3) % 80)
            draw.SimpleText(value, "RepTerm_Console", w - 180, 326 + i * 18, COL_MUTED)
        end
    end

    local close = vgui.Create("DButton", frame)
    close:SetSize(34, 28)
    close:SetPos(frame:GetWide() - 48, 18)
    close:SetText("X")
    close:SetFont("RepTerm_Button")
    close:SetTextColor(COL_TEXT)
    close.Paint = ButtonPaint
    close.DoClick = function() frame:Close() end

    local log = vgui.Create("RichText", frame)
    log:SetPos(205, 74)
    log:SetSize(frame:GetWide() - 430, frame:GetTall() - 156)
    log.Paint = function(_, w, h)
        DrawOutlinedPanel(0, 0, w, h, COL_LINE_DIM, Color(3, 12, 17, 230))
    end
    function log:PerformLayout()
        self:SetFontInternal("RepTerm_Console")
        self:SetFGColor(COL_TEXT)
    end

    local function AddLog(txt, col)
        if not IsValid(log) then return end
        col = col or COL_TEXT
        log:InsertColorChange(col.r, col.g, col.b, col.a or 255)
        log:AppendText(txt .. "\n")
        log:GotoTextEnd()
    end

    local function Process(lines, finalStep, onComplete)
        isProcessing = true
        local totalTime = 0
        for i, data in ipairs(lines) do
            totalTime = totalTime + data.delay
            timer.Simple(totalTime, function()
                if not IsValid(frame) then return end
                AddLog(data.msg, data.col)
                if i == #lines then
                    isProcessing = false
                    if finalStep then step = finalStep end
                    if onComplete then onComplete() end
                end
            end)
        end
    end

    local inputBg = vgui.Create("DPanel", frame)
    inputBg:SetPos(205, frame:GetTall() - 68)
    inputBg:SetSize(frame:GetWide() - 430, 38)
    inputBg.Paint = function(_, w, h)
        DrawOutlinedPanel(0, 0, w, h, COL_LINE, Color(4, 16, 22, 235))
        draw.SimpleText(">", "RepTerm_Console", 14, 10, COL_LINE)
    end

    local input = vgui.Create("DTextEntry", inputBg)
    input:Dock(FILL)
    input:DockMargin(34, 4, 10, 4)
    input:SetFont("RepTerm_Console")
    input:SetTextColor(COL_WHITE)
    input:SetCursorColor(COL_LINE)
    input:SetPaintBackground(false)
    input:RequestFocus()
    input.Paint = function(self, w, h)
        self:DrawTextEntryText(COL_WHITE, COL_LINE, COL_TEXT)
    end

    AddLog("REPUBLIC_OS v4.2 INITIALIZED", COL_LINE)
    AddLog("TERMINAL: " .. (isBroken and "RECOVERY MODE" or "OPERATIONAL MODE"), isBroken and COL_AMBER or COL_GREEN)
    AddLog("Type 'help' for available commands.", COL_MUTED)
    AddLog("")

    input.OnEnter = function(self)
        if isProcessing then return end

        local cmd = string.lower(string.Trim(self:GetValue()))
        self:SetText("")
        self:RequestFocus()
        if cmd == "" then return end

        AddLog("> " .. cmd, COL_WHITE)

        if cmd == "help" then
            AddLog("AVAILABLE COMMANDS", COL_LINE)
            if isBroken then
                AddLog(" diag      - run full hardware diagnostic")
                AddLog(" reset     - reset sector 44 controller")
                AddLog(" bypass    - isolate damaged power route")
                AddLog(" reboot    - restart terminal after repair")
                AddLog(" voltage   - inspect power rails")
                AddLog(" temp      - inspect thermal sensors")
                AddLog(" ports     - inspect physical ports")
                AddLog(" integrity - verify system files")
            else
                AddLog(" scan      - scan nearby hostile signatures")
                AddLog(" ping      - test uplink latency")
                AddLog(" status    - print system status")
            end
            AddLog(" logs      - show recent events")
            AddLog(" whoami    - show current operator")
            AddLog(" clear     - clear terminal buffer")
            AddLog(" logout    - close terminal")

        elseif cmd == "clear" then
            log:SetText("")
            radarActive = false

        elseif cmd == "logout" then
            frame:Close()

        elseif cmd == "whoami" then
            AddLog("OPERATOR ID: CT-" .. LocalPlayer():UserID(), COL_LINE)
            AddLog("ACCESS CLASS: " .. (isBroken and "ENGINEERING RECOVERY" or "FIELD COMMAND"), COL_TEXT)

        elseif cmd == "logs" then
            AddLog("[10:15] Authentication accepted.", COL_TEXT)
            AddLog("[10:16] Uplink handshake completed.", COL_TEXT)
            if isBroken then
                AddLog("[14:42] CRITICAL: Sector 44 power loss.", COL_RED)
                AddLog("[14:43] Recovery interlock engaged.", COL_AMBER)
            else
                AddLog("[14:42] Patrol channel synchronized.", COL_GREEN)
            end

        elseif (cmd == "diag" or cmd == "reset" or cmd == "bypass" or cmd == "reboot" or cmd == "voltage" or cmd == "temp" or cmd == "ports" or cmd == "integrity") and not isBroken then
            AddLog("ACCESS DENIED: engineering commands are locked while the node is stable.", COL_RED)

        elseif (cmd == "scan" or cmd == "ping" or cmd == "status") and isBroken then
            AddLog("ERROR: operational modules are offline. Complete repair first.", COL_RED)

        elseif cmd == "diag" and isBroken then
            AddLog("STARTING HARDWARE DIAGNOSTIC...", COL_LINE)
            Process({
                { msg = "[12%] firmware access accepted", delay = 0.7 },
                { msg = "[34%] memory bus stable", delay = 0.8 },
                { msg = "[58%] sector 44 power controller: fault", col = COL_AMBER, delay = 0.9 },
                { msg = "[81%] recovery interlock active", col = COL_AMBER, delay = 0.8 },
                { msg = "[100%] diagnostic complete: route bypass required", col = COL_RED, delay = 0.9 },
            }, 1)

        elseif cmd == "reset" and isBroken then
            if step < 1 then AddLog("ERROR: run 'diag' first.", COL_RED) return end
            AddLog("RESETTING SECTOR 44 CONTROLLER...", COL_AMBER)
            Process({
                { msg = "[25%] interrupt sent", delay = 0.8 },
                { msg = "[55%] EEPROM clear failed", col = COL_AMBER, delay = 0.9 },
                { msg = "[100%] reset blocked by hardware interlock", col = COL_RED, delay = 1 },
            }, 2)

        elseif cmd == "bypass" and isBroken then
            if step < 2 then AddLog("ERROR: run 'reset' before bypass.", COL_RED) return end
            AddLog("CREATING POWER BYPASS...", COL_LINE)
            Process({
                { msg = "[20%] alternate rail selected", delay = 0.8 },
                { msg = "[45%] virtual bridge created", delay = 0.9 },
                { msg = "[72%] voltage stabilized", delay = 0.8 },
                { msg = "[100%] bypass accepted. terminal ready to reboot", col = COL_GREEN, delay = 1 },
            }, 3)

        elseif cmd == "reboot" and isBroken then
            if step < 3 then AddLog("ERROR: repair sequence incomplete.", COL_RED) return end
            AddLog("REBOOTING REPUBLIC_OS...", COL_WHITE)
            Process({
                { msg = "[20%] shutting down recovery mode", delay = 0.7 },
                { msg = "[48%] restoring sector database", delay = 0.9 },
                { msg = "[76%] uplink restored", delay = 0.8 },
                { msg = "[100%] terminal restored", col = COL_GREEN, delay = 1 },
            }, nil, function()
                timer.Simple(0.4, function()
                    if not IsValid(frame) then return end
                    frame:Close()
                    net.Start("RepTerminal_RepairSuccess")
                    net.WriteEntity(targetEnt)
                    net.SendToServer()
                end)
            end)

        elseif cmd == "voltage" and isBroken then
            AddLog("MAIN RAIL: 220.4V [STABLE]", COL_GREEN)
            AddLog("SECTOR 44: 0.08V [CRITICAL]", COL_RED)
            AddLog("I/O RAIL: 219.8V [STABLE]", COL_GREEN)

        elseif cmd == "temp" and isBroken then
            AddLog("CPU: 42 C [NORMAL]", COL_GREEN)
            AddLog("PSU: 96 C [HIGH]", COL_RED)
            AddLog("COOLING: MAXIMUM", COL_AMBER)

        elseif cmd == "ports" and isBroken then
            AddLog("PORT_01 FIBER: LINK_DOWN", COL_RED)
            AddLog("PORT_02 DATA: READY", COL_GREEN)
            AddLog("PORT_03 MAIN: OFFLINE", COL_RED)

        elseif cmd == "integrity" and isBroken then
            AddLog("/boot: OK", COL_GREEN)
            AddLog("/sys/kernel: OK", COL_GREEN)
            AddLog("/bin/cmd: ERROR 44", COL_RED)

        elseif cmd == "scan" and not isBroken then
            radarActive = false
            AddLog("SCANNING LOCAL SECTOR...", COL_LINE)
            Process({
                { msg = "[24%] calibrating receiver", delay = 0.7 },
                { msg = "[61%] filtering life-signatures", delay = 0.9 },
                { msg = enemyCount > 0 and ("[100%] hostile signatures detected: " .. enemyCount) or "[100%] sector clear", col = enemyCount > 0 and COL_RED or COL_GREEN, delay = 1 },
            }, nil, function()
                radarActive = enemyCount > 0
            end)

        elseif cmd == "ping" and not isBroken then
            AddLog("CORUSCANT_HUB reply: 45ms", COL_TEXT)
            AddLog("CORUSCANT_HUB reply: 42ms", COL_TEXT)
            AddLog("packet loss: 0%", COL_GREEN)

        elseif cmd == "status" and not isBroken then
            AddLog("OS: active", COL_GREEN)
            AddLog("network: secure", COL_GREEN)
            AddLog("power: nominal", COL_GREEN)
            AddLog("nearby hostile signatures: " .. enemyCount, enemyCount > 0 and COL_AMBER or COL_GREEN)

        else
            AddLog("UNKNOWN COMMAND: '" .. cmd .. "'. Type 'help'.", COL_RED)
        end
    end
end)
