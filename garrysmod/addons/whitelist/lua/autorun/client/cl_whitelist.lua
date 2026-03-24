whitelist = whitelist or {}

function whitelist_open()
    if not whitelist.ranks[LocalPlayer():GetUserGroup()] then return end
    
    whitelist.frame = vgui.Create("DFrame")
    whitelist.frame:SetSize(600, 400)
    whitelist.frame:ShowCloseButton(true)
    whitelist.frame:SetTitle("Whitelist")
    whitelist.frame:Center()
    whitelist.frame:MakePopup()

    whitelist.player_list = vgui.Create("DListView", whitelist.frame)
    whitelist.player_list:Dock(FILL)
    whitelist.player_list:SetMultiSelect(false)

    whitelist.player_list:AddColumn("Name")
    whitelist.player_list:AddColumn("SteamID")
    whitelist.player_list:AddColumn("Category")
    whitelist.player_list:AddColumn("Job")

    for _, v in pairs(player.GetAll()) do
        local teamData = RPExtraTeams[v:Team()]
        if teamData then
            whitelist.player_list:AddLine(
                v:Name(),
                v:SteamID(),
                teamData.category,
                teamData.name
            )
        end
    end

    function whitelist.player_list:DoDoubleClick(_, row)
        net.Start("whitelist.get")
            net.WriteString(row:GetColumnText(2))
        net.SendToServer()
    end
end

net.Receive("whitelist.get", function()
    local steamid = net.ReadString()
    local job = net.ReadInt(17)
    local rank = net.ReadString()
    local can_stunstick = net.ReadBool()
    local can_gl = net.ReadBool()
    local can_gh = net.ReadBool()
    local can_al = net.ReadBool()
    local can_ah = net.ReadBool()

    local respawn = false 
    local temp = false
    
    whitelist.profile = vgui.Create("DFrame")
    whitelist.profile:SetSize(300, 225)
    whitelist.profile:SetTitle("Whitelist")
    whitelist.profile:Center()
    whitelist.profile:MakePopup()

    local job_name = RPExtraTeams[job] and RPExtraTeams[job].name or "Unknown"

    local selected_job = job

    whitelist.jobs = vgui.Create("DComboBox", whitelist.profile)
    whitelist.jobs:Dock(TOP)
    whitelist.jobs:DockMargin(5, 5, 5, 0)
    whitelist.jobs:SetValue(job_name)

    for k, v in pairs(RPExtraTeams) do
        whitelist.jobs:AddChoice(v.name, k)
    end
    
    function whitelist.jobs:OnSelect(_, _, data)
        selected_job = data
    end

    whitelist.rank = vgui.Create("DTextEntry", whitelist.profile)
    whitelist.rank:Dock(TOP)
    whitelist.rank:DockMargin(5, 5, 5, 0)
    whitelist.rank:SetValue(rank)
    
    whitelist.options = vgui.Create("DPanel", whitelist.profile)
    whitelist.options:Dock(TOP)
    whitelist.options:DockMargin(5, 5, 5, 5)
    whitelist.options:SetTall(160)
    whitelist.options.Paint = function() end
        

    whitelist.save = vgui.Create("DButton", whitelist.profile)
    whitelist.save:Dock(BOTTOM)
    whitelist.save:SetText("Save")

    whitelist.options_array = {
        ["Наземна легка"] = can_gl,
        ["Наземна тяжка"] = can_gh,
        ["Повітряна легка"] = can_al,
        ["Повітряна тяжка"] = can_ah,
        ["Stunstick"] = can_stunstick,
        ["Тимчасово"] = temp,
        ["Респавн"] = respawn
    }

    whitelist.checkboxes = {}

    function whitelist.create_option(parent, name, value)
        local cb = vgui.Create("DCheckBoxLabel", parent)
        cb:Dock(TOP)
        cb:SetText(name)
        cb:SetChecked(value)
        cb:SizeToContents()

        whitelist.checkboxes[name] = cb
    end

    for name, val in pairs(whitelist.options_array) do
        whitelist.create_option(whitelist.options, name, val)
    end
    
    function whitelist.save:DoClick()
        net.Start("whitelist.set")
            net.WriteString(steamid)
            net.WriteInt(selected_job or 0, 17)
            net.WriteString(whitelist.rank:GetValue())

            net.WriteBool(whitelist.checkboxes["Stunstick"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Наземна легка"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Наземна тяжка"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Повітряна легка"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Повітряна тяжка"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Респавн"]:GetChecked())
            net.WriteBool(whitelist.checkboxes["Тимчасово"]:GetChecked())
        net.SendToServer()

        whitelist.profile:Close()
    end
end)

concommand.Add("whitelist", whitelist_open)

hook.Add("OnPlayerChat", "wl_chat_command", function(ply, text)
    if ply ~= LocalPlayer() then return end

    if string.lower(text) == string.lower(whitelist.command or "") then
        whitelist_open()
        return true
    end
end)