if CLIENT then
hook.Add("OnPlayerChat", "highborn_whitelist", function(ply, text, team, dead)
    if ply == LocalPlayer() then
        if string.lower(text) == HIGHBORN_WHITELIST_CHATCMD then
            openWhitelist()
            return ""
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
    PlayerList:AddColumn("Category")
    PlayerList:AddColumn("Job")
    PlayerList:SetSize(200, 0)
    for _, v in pairs(player.GetAll()) do
        PlayerList:AddLine(v:Name(), v:SteamID(), RPExtraTeams[v:Team()].category, RPExtraTeams[v:Team()].name)
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
    local canGL = net.ReadBool()
    local canGH = net.ReadBool()
    local canAL = net.ReadBool()
    local canAH = net.ReadBool()
    
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 240)
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
    if not selectedJob then 
        for job_index, job in pairs(RPExtraTeams) do
            if job.name == DComboBox:GetValue() then
                selectedJob = tonumber(job_index)
            end
        end
    end

    local DTextEntry = vgui.Create("DTextEntry", frame)
    DTextEntry:Dock(TOP)
    DTextEntry:DockMargin(5, 5, 0, 0)
    DTextEntry:SetValue(rank)
    
    local TicksRow = vgui.Create("DPanel", frame)
    TicksRow:Dock(TOP)
    TicksRow:DockMargin(5, 5, 0, 5)
    TicksRow:SetTall(160)
    TicksRow:SetPaintBackground(false)

    local DCheckBoxLabelGL = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelGL:Dock(TOP)
    DCheckBoxLabelGL:SetText("Ground Light")
    DCheckBoxLabelGL:SetFont("Trebuchet18")
    DCheckBoxLabelGL:SetChecked(canGL)
    DCheckBoxLabelGL:SizeToContents()

    local DCheckBoxLabelGH = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelGH:Dock(TOP)
    DCheckBoxLabelGH:SetText("Ground Heavy")
    DCheckBoxLabelGH:SetFont("Trebuchet18")
    DCheckBoxLabelGH:SetChecked(canGH)
    DCheckBoxLabelGH:SizeToContents()

    local DCheckBoxLabelAL = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelAL:Dock(TOP)
    DCheckBoxLabelAL:SetText("Air Light")
    DCheckBoxLabelAL:SetFont("Trebuchet18")
    DCheckBoxLabelAL:SetChecked(canAL)
    DCheckBoxLabelAL:SizeToContents()

    local DCheckBoxLabelAH = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelAH:Dock(TOP)
    DCheckBoxLabelAH:SetText("Air Heavy")
    DCheckBoxLabelAH:SetFont("Trebuchet18")
    DCheckBoxLabelAH:SetChecked(canAH)
    DCheckBoxLabelAH:SizeToContents()

    local DCheckBoxLabelStunstick = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelStunstick:Dock(TOP)
    DCheckBoxLabelStunstick:SetText("Stunstick")
    DCheckBoxLabelStunstick:SetValue(false)
    DCheckBoxLabelStunstick:SizeToContents()		
    DCheckBoxLabelStunstick:SetFont("Trebuchet18")
    DCheckBoxLabelStunstick:SetChecked(can_stunstick)

    local DCheckBoxLabel = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabel:Dock(TOP)
    DCheckBoxLabel:SetText("Respawn")
    DCheckBoxLabel:SetValue(false)
    DCheckBoxLabel:SizeToContents()		
    DCheckBoxLabel:SetFont("Trebuchet18")

    local DCheckBoxLabelTemp = vgui.Create("DCheckBoxLabel", TicksRow)
    DCheckBoxLabelTemp:Dock(TOP)
    DCheckBoxLabelTemp:SetText("Тимчасово")
    DCheckBoxLabelTemp:SetFont("Trebuchet18")
    DCheckBoxLabelTemp:SetValue(false)
    DCheckBoxLabelTemp:SizeToContents()
    
    local SaveButton = vgui.Create("DButton", frame)
    SaveButton:Dock(BOTTOM)
    SaveButton:SetText("Save")
    SaveButton:DockMargin(0, 0, 0, 0)
    SaveButton:SetTextColor(color_white)
    DCheckBoxLabel:SizeToContents()		
    SaveButton.DoClick = function()
        local spawn = DCheckBoxLabel:GetChecked()
        local can_stunstick_return = DCheckBoxLabelStunstick:GetChecked() and 1 or 0
        local canGL_return = DCheckBoxLabelGL:GetChecked()
        local canGH_return = DCheckBoxLabelGH:GetChecked()
        local canAL_return = DCheckBoxLabelAL:GetChecked()
        local canAH_return = DCheckBoxLabelAH:GetChecked()
        local temporary = DCheckBoxLabelTemp:GetChecked()

        net.Start("highborn_whitelist_set")
            net.WriteString(steamid)
            net.WriteInt(selectedJob, 17)
            net.WriteString(DTextEntry:GetValue())
            net.WriteInt(can_stunstick_return, 11)
            net.WriteBool(canGL_return)
            net.WriteBool(canGH_return)
            net.WriteBool(canAL_return)
            net.WriteBool(canAH_return)
            net.WriteBool(spawn)
            net.WriteBool(temporary)
        net.SendToServer()

        frame:Close()
    end
end)

concommand.Add("whitelist", openWhitelist)
print("[Highborn] Whitelist client loaded")
end