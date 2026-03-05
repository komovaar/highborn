local ROW = Color(28,28,28)
local ROW_HOVER = Color(42,42,42)
local ACCENT = Color(60,120,200)
local BG_MENU = Color(28,28,28)

if CLIENT then
    hook.Add("InitPostEntity", "HB_CreateFontScoreaboard", function()
        surface.CreateFont("HB_Scoreboard_Main", {
            font = "Overpass",
            size = 24,
            weight = 300,
        })

        surface.CreateFont("HB_Scoreboard_Category", {
            font = "Overpass",
            size = 32,
            weight = 300,
            extended=true,
        })

        surface.CreateFont("HB_Scoreboard_Large", {
            font = "Overpass",
            size = 36,
            weight = 700,
        })

        surface.CreateFont("HB_Scoreboard_Small", {
            font = "Overpass",
            size = 12,
            weight = 300,
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
        btn:SetFont("HB_Scoreboard_Small")
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
        if LocalPlayer():IsAdmin() then
            table.insert(options, {
                name = "Телепортуватися до гравця",
                func = function()
                    RunConsoleCommand("sam", "goto", ply:Nick())
                end
            })

            table.insert(options, {
                name = "Телепортувати гравця",
                func = function()
                    RunConsoleCommand("sam", "bring", ply:Nick())
                end
            })
        end
        CreateModernMenu(options)
    end

    local avatar = vgui.Create("AvatarImage", row)
    avatar:SetSize(36, 36)
    avatar:SetPos(12, 9)
    avatar:SetPlayer(ply, 64)

    local nick = vgui.Create("DLabel", row)
    nick:SetFont("HB_Scoreboard_Main")
    nick:SetText(ply:Nick())
    nick:SetTextColor(color_white)
    nick:SetPos(58, 4)
    nick:SizeToContents()

    local catRank = vgui.Create("DLabel", row)
    catRank:SetFont("HB_Scoreboard_Main")
    catRank:SetTextColor(jobColor)
    catRank:SetPos(58, 22)

    local function UpdateRank()
        local jobTable = ply:getJobTable()
        local category = jobTable and jobTable.category or "Other"
        local rank = ply:GetNWString("HighbornRank", "")

        if category ~= "" and rank ~= "" then
            catRank:SetText(category .. " " .. rank)
        elseif category ~= "" then
            catRank:SetText(category)
        elseif rank ~= "" then
            catRank:SetText(rank)
        else
            catRank:SetText(ply:getDarkRPVar("job") or "Unknown")
        end

        catRank:SizeToContents()
    end

    UpdateRank()
    catRank.Think = UpdateRank

    local kd = vgui.Create("DLabel", row)
    kd:SetFont("HB_Scoreboard_Main")
    kd:SetTextColor(Color(200,200,200))

    kd.Think = function(s)
        s:SetText("K " .. ply:Frags() .. " / D " .. ply:Deaths())
        s:SizeToContents()
        s:SetPos(row:GetWide() - 200, 14)
    end

    local ping = vgui.Create("DLabel", row)
    ping:SetFont("HB_Scoreboard_Main")
    ping:SetTextColor(jobColor)

    ping.Think = function(s)
        s:SetText(ply:Ping() .. " ms")
        s:SizeToContents()
        s:SetPos(row:GetWide() - 90, 14)
    end
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW() * 0.4, ScrH() * 0.8)
    self:Center()
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)

    -- HEADER
    self.HeaderH = 90

    self.Header = vgui.Create("DPanel", self)
    self.Header:Dock(TOP)
    self.Header:SetTall(self.HeaderH)
    self.Header.Paint = function(_, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,0))
    end

    self.ServerName = vgui.Create("DLabel", self.Header)
    self.ServerName:SetFont("HB_Scoreboard_Large")
    self.ServerName:SetText("Highborn")
    self.ServerName:SetTextColor(color_white)
    self.ServerName:SizeToContents()

    self.ServerInfo = vgui.Create("DLabel", self.Header)
    self.ServerInfo:SetFont("HB_Scoreboard_Main")
    self.ServerInfo:SetTextColor(Color(180,180,180))

    self.Header.PerformLayout = function(s, w, h)
        self.ServerName:SetPos(w/2 - self.ServerName:GetWide()/2, 38)

        local info =
            #player.GetAll() ..
            " / " ..
            game.MaxPlayers()

        self.ServerInfo:SetText(info)
        self.ServerInfo:SizeToContents()
        self.ServerInfo:SetPos(w/2 - self.ServerInfo:GetWide()/2, 72)
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
    cat:SetTall(38)

    cat.Paint = function(_, w, h)
        DrawTextShadow(
            name,
            "HB_Scoreboard_Category",
            16,
            h / 2,
            color_white,
            Color(0, 0, 0, 180),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
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
        local catName = jobTable and jobTable.category or "Інше"
        local cat = jobTable and jobTable.category or "Інше"
        if cat == "212th" then
            catName = "212 штурмовий батальйон"
        elseif cat == "91st" then
            catName = "91 розвідувальний корпус"
        elseif cat == "Fleet"  then
            catName = "Республіканський флот"
        end

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

vgui.Register("HB_Scoreboard", PANEL, "EditablePanel")

local sb

hook.Add("ScoreboardShow", "HB_OpenScoreboard", function()
    if IsValid(sb) then sb:Remove() end
    sb = vgui.Create("HB_Scoreboard")
    sb:Populate()
    return false
end)

hook.Add("ScoreboardHide", "HB_CloseScoreboard", function()
    if IsValid(sb) then sb:Remove() end
    return false
end)
