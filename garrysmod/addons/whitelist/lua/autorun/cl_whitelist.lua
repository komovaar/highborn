if CLIENT then
hook.Add("OnPlayerChat", "highborn_whitelist", function(ply, text, team, dead)
    if ply == LocalPlayer() then
        if string.lower(text) == HIGHBORN_WHITELIST_CHATCMD then
            openWhitelist()
        end
    end
end)

function openWhitelist()
    if not HIGHBORN_WHITELIST_ALLOWED_RANKS[LocalPlayer():GetUserGroup()] then return end
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
    for _, v in pairs(player.GetAll()) do
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
    local job = net.ReadInt(17)
    local rank = net.ReadString()
    local can_stunstick = net.ReadBool()
    
    local frame = vgui.Create("DFrame")
    frame:SetSize(200, 150)
    frame:ShowCloseButton(true)
    frame:SetTitle("Whitelist")
    frame:Center()
    frame:MakePopup(true)

    local jobName = nil 
    for index, name in pairs(RPExtraTeams) do 
        if index == job then 
            jobName = name.name
        end
    end
    local selectedJob = nil
    local DComboBox = vgui.Create("DComboBox", frame)
    DComboBox:Dock(TOP)
    DComboBox:DockMargin(5, 5, 0, 0)
    DComboBox:SetValue(jobName)
    for _, job in pairs(RPExtraTeams) do
        DComboBox:AddChoice(job.name)
    end
    DComboBox.OnSelect = function(self, index, value)
        for job_index, job in pairs(RPExtraTeams) do
            if job.name == value then
                selectedJob = tonumber(job_index)
            end
        end
    end

    local DTextEntry = vgui.Create("DTextEntry", frame)
    DTextEntry:Dock(TOP)
    DTextEntry:DockMargin(5, 5, 0, 0)
    DTextEntry:SetValue(rank)
    
    local DCheckBoxLabel = vgui.Create("DCheckBoxLabel", frame)
    DCheckBoxLabel:Dock(LEFT)
    DCheckBoxLabel:DockMargin(5, 0, 0, 0)
    DCheckBoxLabel:SetText("Respawn")
    DCheckBoxLabel:SetValue(false)
    DCheckBoxLabel:SizeToContents()		
    DCheckBoxLabel:SetFont("Trebuchet18")
    
    local DCheckBoxLabelStunstick = vgui.Create("DCheckBoxLabel", frame)
    DCheckBoxLabelStunstick:Dock(LEFT)
    DCheckBoxLabelStunstick:DockMargin(10, 0, 0, 0)
    DCheckBoxLabelStunstick:SetText("Stunstick")
    DCheckBoxLabelStunstick:SetValue(false)
    DCheckBoxLabelStunstick:SizeToContents()		
    DCheckBoxLabelStunstick:SetFont("Trebuchet18")
    DCheckBoxLabelStunstick:SetChecked(can_stunstick)
    
    local SaveButton = vgui.Create("DButton", frame)
    SaveButton:Dock(BOTTOM)
    SaveButton:SetText("Save")
    SaveButton:DockMargin(10, 10, 10, 10)
    SaveButton:SetTextColor(color_white)
    DCheckBoxLabel:SizeToContents()		
    SaveButton.DoClick = function()
        local spawn = false
        if DCheckBoxLabel:GetChecked() then 
            spawn = true
        end
        local can_stunstick_return = DCheckBoxLabelStunstick:GetChecked() and 1 or 0

        net.Start("highborn_whitelist_set")
        net.WriteString(steamid)
        net.WriteInt(selectedJob, 17)
        net.WriteString(DTextEntry:GetValue())
        net.WriteInt(can_stunstick_return, 11)
        net.WriteBool(spawn)
        net.SendToServer()
        frame:Close()
    end
end)

concommand.Add("whitelist", openWhitelist)
print("[Highborn] Whitelist client loaded")
end