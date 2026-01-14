local BG = Color(0,0,0,50)
local ROW = Color(28,28,28)
local ROW_HOVER = Color(42,42,42)
local ACCENT = Color(60,120,200)
local BG_MENU = Color(28,28,28)
local HOVER = Color(42,42,42)
local TXT = Color(255,255,255)

if CLIENT then
    hook.Add("InitPostEntity", "SW_CreateFont", function()
        surface.CreateFont("SW_Scoreboard_Main", {
            font = "Montserrat",
            size = 18,
            weight = 800,
            shadow=true,
        })
    end)

        hook.Add("InitPostEntity", "SW_CreateFont", function()
        surface.CreateFont("SW_Scoreboard_Large", {
            font = "Montserrat",
            size = 48,
            weight = 800,
            shadow=true,
        })
    end)
end


local function CreateModernMenu(options)
    local menu = DermaMenu()

    menu.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, BG_MENU)
    end

    for _, opt in ipairs(options) do
        local btn = menu:AddOption(opt.name, opt.func)
        btn.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, s:IsHovered() and HOVER or BG_MENU)
            if s:IsHovered() then
                draw.RoundedBox(0, w-6, h/2-10, 4, 20, ACCENT)
            end
        end
    end

    menu:Open()
end

--------------------------------------------------
-- PLAYER ROW
--------------------------------------------------
local function CreatePlayerRow(parent, ply)
    local jobTable = ply:getJobTable()
    local jobColor = (jobTable and jobTable.color) or Color(160,160,160)

    local row = vgui.Create("DButton", parent)
    row:Dock(TOP)
    row:DockMargin(0, 6, 0, 0)
    row:SetTall(54)
    row:SetText("")

    row.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, s:IsHovered() and ROW_HOVER or ROW)

        -- цветная полоса профессии
        draw.RoundedBox(0, 0, 0, 4, h, jobColor)
    end

    -- ПКМ меню
row.DoRightClick = function()
    local options = {
        { name = "Скопировать ник", func = function() SetClipboardText(ply:Nick()) end },
        { name = "Скопировать SteamID", func = function() SetClipboardText(ply:SteamID()) end },
        { name = "Скопировать SteamID64", func = function() SetClipboardText(ply:SteamID64()) end },
        { name = "Скопировать профессию", func = function() SetClipboardText(ply:getDarkRPVar("job") or "Unknown") end },
        { name = "Открыть профиль Steam", func = function() gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64()) end }
    }

    CreateModernMenu(options)
end

    -- Avatar
    local avatar = vgui.Create("AvatarImage", row)
    avatar:SetSize(36, 36)
    avatar:SetPos(12, 9)
    avatar:SetPlayer(ply, 64)

    -- Nick
    local nick = vgui.Create("DLabel", row)
    nick:SetFont("SW_Scoreboard_Main")
    nick:SetText(ply:Nick())
    nick:SetTextColor(color_white)
    nick:SetPos(58, 6)
    nick:SizeToContents()

    -- Job
    local job = vgui.Create("DLabel", row)
    job:SetFont("SW_Scoreboard_Main")
    job:SetText(ply:getDarkRPVar("job") or "Unknown")
    job:SetTextColor(jobColor)
    job:SetPos(58, 26)
    job:SizeToContents()

    -- K/D
    local kd = vgui.Create("DLabel", row)
    kd:SetFont("SW_Scoreboard_Main")
    kd:SetText("K " .. ply:Frags() .. " / D " .. ply:Deaths())
    kd:SetTextColor(Color(200,200,200))
    kd:SizeToContents()
    kd:SetPos(row:GetWide() - 200, 18)
    kd.Think = function(s)
        s:SetText("K " .. ply:Frags() .. " / D " .. ply:Deaths())
        s:SizeToContents()
        s:SetPos(row:GetWide() - 200, 18)
    end

    -- Ping
    local ping = vgui.Create("DLabel", row)
    ping:SetFont("SW_Scoreboard_Main")
    ping:SetText(ply:Ping() .. " ms")
    ping:SetTextColor(jobColor)
    ping:SizeToContents()
    ping:SetPos(row:GetWide() - 90, 18)
    ping.Think = function(s)
        s:SetText(ply:Ping() .. " ms")
        s:SizeToContents()
        s:SetPos(row:GetWide() - 90, 18)
    end
end

--------------------------------------------------
-- SCOREBOARD PANEL
--------------------------------------------------
local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW()*0.4, ScrH()*0.8)
    self:Center()
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)

    self.Paint = function(_, w, h)
        draw.RoundedBox(6, 0, 0, w, h, BG)
    end

    self.Header = vgui.Create("DPanel", self)
    self.Header:Dock(TOP)
    self.Header:SetTall(56)
    self.Header.Paint = function(_, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, Color(24,24,24, 0), true, true, false, false)
        draw.SimpleText("Highborn", "SW_Scoreboard_Large", w / 2 - 36, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.Scroll = vgui.Create("DScrollPanel", self)
    self.Scroll:Dock(FILL)
end

function PANEL:AddCategory(name, color)
    local cat = vgui.Create("DPanel", self.Scroll)
    cat:Dock(TOP)
    cat:DockMargin(0, 0, 0, 0)
    cat:SetTall(38)

    cat.Paint = function(_, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(32,32,32, 0))
        -- draw.RoundedBox(0, 0, 0, 6, h, color)
        draw.SimpleText(name, "SW_Scoreboard_Main", 16, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Populate()
    self.Scroll:Clear()

    local categories = {}

    -- получаем реальные категории DarkRP
    for _, cat in ipairs(DarkRP.getCategories().jobs or {}) do
        categories[cat.name] = {
            color = cat.color or Color(100,100,100),
            players = {}
        }
    end

    -- распределяем игроков
    for _, ply in ipairs(player.GetAll()) do
        local jobTable = ply:getJobTable()
        local catName = jobTable and jobTable.category or "Other"

        categories[catName] = categories[catName] or {
            color = Color(100,100,100),
            players = {}
        }

        table.insert(categories[catName].players, ply)
    end

    -- рисуем
    for catName, data in SortedPairs(categories) do
        if #data.players > 0 then
            self:AddCategory(catName, data.color)

            for _, ply in ipairs(data.players) do
                CreatePlayerRow(self.Scroll, ply)
            end
        end
    end
end

vgui.Register("SW_Scoreboard", PANEL, "EditablePanel")

--------------------------------------------------
-- TAB HOOKS
--------------------------------------------------
local sb

hook.Add("ScoreboardShow", "SW_OpenScoreboard", function()
    if IsValid(sb) then sb:Remove() end
    sb = vgui.Create("SW_Scoreboard")
    sb:Populate()
    return false
end)

hook.Add("ScoreboardHide", "SW_CloseScoreboard", function()
    if IsValid(sb) then sb:Remove() end
    return false
end)
