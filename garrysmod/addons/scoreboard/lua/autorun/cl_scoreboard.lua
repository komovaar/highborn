local ROW = Color(28,28,28)
local ROW_HOVER = Color(42,42,42)
local ACCENT = Color(60,120,200)
local BG_MENU = Color(28,28,28)

if CLIENT then
    hook.Add("InitPostEntity", "SW_CreateFontScoreaboard", function()
        surface.CreateFont("HB_Scoreboard_Main", {
            font = "Robot",
            size = 20,
            weight = 600,
            shadow=true,
        })
        surface.CreateFont("HB_Scoreboard_Category", {
            font = "Roboto",
            size = 26,
            weight = 600,
            shadow=true,
        })
        surface.CreateFont("HB_Scoreboard_Large", {
            font = "Roboto",
            size = 36,
            weight = 700,
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
            if s:IsHovered() then
                draw.RoundedBox(0, w-6, h/2-10, 4, 20, ACCENT)
            end
        end
    end

    menu:Open()
end


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

        draw.RoundedBox(0, 0, 0, 4, h, jobColor)
    end

row.DoRightClick = function()
    local options = {
        { name = "Скопіювати нікнейм", func = function() SetClipboardText(ply:Nick()) end },
        { name = "Скопіювати SteamID", func = function() SetClipboardText(ply:SteamID()) end },
        { name = "Скопіювати SteamID64", func = function() SetClipboardText(ply:SteamID64()) end },
        { name = "Скопіювати професію", func = function() SetClipboardText(ply:getDarkRPVar("job") or "Unknown") end },
        { name = "Відкрити профіль Steam", func = function() gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64()) end }
    }

    CreateModernMenu(options)
end

    local avatar = vgui.Create("AvatarImage", row)
    avatar:SetSize(36, 36)
    avatar:SetPos(12, 9)
    avatar:SetPlayer(ply, 64)

    local nick = vgui.Create("DLabel", row)
    nick:SetFont("SW_Scoreboard_Main")
    nick:SetText(ply:Nick())
    nick:SetTextColor(color_white)
    nick:SetPos(58, 6)
    nick:SizeToContents()

    local job = vgui.Create("DLabel", row)
    job:SetFont("SW_Scoreboard_Main")
    job:SetText(ply:getDarkRPVar("job") or "Unknown")
    job:SetTextColor(jobColor)
    job:SetPos(58, 26)
    job:SizeToContents()

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

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW()*0.4, ScrH()*0.8)
    self:Center()
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)

    self.PlayerCount = vgui.Create("DLabel", self)
    self.PlayerCount:SetFont("HB_Scoreboard_Main")
    self.PlayerCount:SetTextColor(color_white)
    self.PlayerCount:SetText("Players online: 0")
    self.PlayerCount:SizeToContents()

    self.PlayerCount.Think = function(s)
        local total = #player.GetAll()
        s:SetText("Гравців онлайн: " .. total)
        s:SizeToContents()
        s:SetPos(self:GetWide() - s:GetWide() - 10, 10)
    end

    self.Scroll = vgui.Create("DScrollPanel", self)
    self.Scroll:Dock(FILL)

    local vbar = self.Scroll:GetVBar()
    vbar:SetWide(0)          
    vbar.Paint = function() end
    vbar.btnUp.Paint = function() end
    vbar.btnDown.Paint = function() end
    vbar.btnGrip.Paint = function() end
    
end

function PANEL:AddCategory(name, color)
    local cat = vgui.Create("DPanel", self.Scroll)
    cat:Dock(TOP)
    cat:DockMargin(0, 0, 0, 0)
    cat:SetTall(38)

    cat.Paint = function(_, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(32,32,32, 0))
        DrawTextShadow(name, "HB_Scoreboard_Category", 16, h/2, color_white, Color(0, 0, 0, 180), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Populate()
    self.Scroll:Clear()

    local categories = {}

    for _, cat in ipairs(DarkRP.getCategories().jobs or {}) do
        categories[cat.name] = {
            color = cat.color or Color(100,100,100),
            players = {}
        }
    end

    for _, ply in ipairs(player.GetAll()) do
        local jobTable = ply:getJobTable()
        local catName = jobTable and jobTable.category or "Other"

        categories[catName] = categories[catName] or {
            color = Color(100,100,100),
            players = {}
        }

        table.insert(categories[catName].players, ply)
    end

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
