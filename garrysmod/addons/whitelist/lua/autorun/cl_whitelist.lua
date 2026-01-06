hook.Add("OnPlayerChat", "highborn_whitelist", function(ply, text, team, dead)
    if ply == LocalPlayer() then
        if string.lower(text) == HIGHBORN_WHITELIST_CHATCMD then
            openWhitelist()
        end
    end
end)

function openWhitelist()
    -- if not HIGHBORN_WHITELIST_ALLOWED_RANKS[LocalPlayer():GetUserGroup()] then -- notification.AddLegacy("You aren't allowed to open the whitelist!", 1, 5) -- return -- end
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:ShowCloseButton(true)
    frame:SetTitle("Whitelist")
    frame:Center()
    frame:MakePopup(true)

    local PlayerList = vgui.Create("DListView", frame)
    PlayerList:Dock(FILL)
    PlayerList:SetMultiSelect(false)
    PlayerList:AddColumn("Name")
    PlayerList:AddColumn("SteamID")
    PlayerList:SetSize(200, 0)
    for k, v in pairs(player.GetAll()) do
        PlayerList:AddLine(v:Name(), v:SteamID())
    end

    function PlayerList:DoDoubleClick(rowIndex, row)
        net.Start("highborn_whitelist_get")
        net.WriteString(row:GetColumnText(2))
        net.SendToServer()
    end
end

net.Receive("highborn_whitelist_get", function()
    local steamid = net.ReadString()
    
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 450)
    frame:ShowCloseButton(true)
    frame:SetTitle("Changing for " .. steamid)
    frame:Center()
    frame:MakePopup(true)
    
    local namePanel = vgui.Create("DLabel", frame)
    namePanel:Dock(TOP)
    namePanel:DockMargin(35, 10, 10, 0)
    namePanel:SetText("Jobs (" .. steamid .. ")")
    namePanel:SetFont("Trebuchet18")
    
    local selectedJob = nil
    local DComboBox = vgui.Create("DComboBox", frame)
    DComboBox:Dock(TOP)
    DComboBox:DockMargin(5, 5, 0, 0)
    for job_index, job in pairs(RPExtraTeams) do
        DComboBox:AddChoice(job.name)
    end
    DComboBox.OnSelect = function(self, index, value)
        for job_index, job in pairs(RPExtraTeams) do
            if job.name == value then
                selectedJob = tonumber(job_index)
            end
        end
    end

    local SaveButton = vgui.Create("DButton", frame)
    SaveButton:Dock(BOTTOM)
    SaveButton:SetText("Save")
    SaveButton:DockMargin(10, 10, 10, 10)
    SaveButton:SetTextColor(color_white)
    SaveButton.DoClick = function()
        net.Start("highborn_whitelist_set")
        net.WriteString(steamid)
        net.WriteInt(selectedJob, 17)
        net.SendToServer()
        frame:Close()
    end
end)

concommand.Add("whitelist", openWhitelist)
print("[Highborn] Whitelist client loaded")
