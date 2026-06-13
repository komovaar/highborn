TOOL.Category = "DarkRP"
TOOL.Name = "Spawn Editor"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar = {
    category = "CT",
    only_selected = "0"
}

local TOOL_MODE = "admin_spawn_editor"
local NET_SPAWNS = "asv_spawns"
local NET_REFRESH = "asv_refresh"
local NET_CATEGORIES = "asv_categories"
local REMOVE_DISTANCE_SQR = 160 * 160

if CLIENT then
    language.Add("tool.admin_spawn_editor.name", "DarkRP Spawn Editor")
    language.Add("tool.admin_spawn_editor.desc", "Edit and view DarkRP category spawns.")
    language.Add("tool.admin_spawn_editor.0", "Left click: add selected category spawn. Right click: remove nearest selected category spawn. Reload: refresh.")
end

local function isAdmin(ply)
    return IsValid(ply) and (ply:IsAdmin() or ply:IsSuperAdmin())
end

local function colorToTable(col)
    col = col or color_white

    return {
        r = col.r or 255,
        g = col.g or 255,
        b = col.b or 255,
        a = col.a or 255
    }
end

local function firstJobModel(job)
    if not job then return "models/player/kleiner.mdl" end
    if istable(job.model) then return job.model[1] or "models/player/kleiner.mdl" end

    return job.model or "models/player/kleiner.mdl"
end

local function getJobCategories()
    local categories = {}

    if DarkRP and DarkRP.getCategories then
        for _, category in ipairs((DarkRP.getCategories().jobs) or {}) do
            categories[category.name] = {
                name = category.name,
                color = colorToTable(category.color),
                sortOrder = category.sortOrder or 100
            }
        end
    end

    if RPExtraTeams then
        for _, job in pairs(RPExtraTeams) do
            local name = job.category or "Other"
            categories[name] = categories[name] or {
                name = name,
                color = colorToTable(job.color),
                sortOrder = 100
            }
        end
    end

    local list = {}
    for _, category in pairs(categories) do
        table.insert(list, category)
    end

    table.SortByMember(list, "sortOrder", true)

    return list
end

if SERVER then
    util.AddNetworkString(NET_SPAWNS)
    util.AddNetworkString(NET_REFRESH)
    util.AddNetworkString(NET_CATEGORIES)

    local function notify(ply, kind, text)
        if DarkRP and DarkRP.notify then
            DarkRP.notify(ply, kind, 4, text)
        else
            ply:ChatPrint(text)
        end
    end

    local function getCategoryJobs(categoryName)
        local jobs = {}

        for teamId, job in pairs(RPExtraTeams or {}) do
            if job.category == categoryName then
                jobs[#jobs + 1] = {
                    teamId = teamId,
                    job = job
                }
            end
        end

        return jobs
    end

    local function getCategoryByName(categoryName)
        for _, category in ipairs(getJobCategories()) do
            if string.lower(category.name) == string.lower(categoryName or "") then
                return category
            end
        end
    end

    local function posKey(pos)
        return math.Round(pos.x) .. "," .. math.Round(pos.y) .. "," .. math.Round(pos.z)
    end

    local function collectSpawnData()
        local grouped = {}

        if not (DarkRP and DarkRP.retrieveTeamSpawnPos and RPExtraTeams) then
            return {}
        end

        for teamId, job in pairs(RPExtraTeams) do
            local categoryName = job.category or "Other"
            local spawns = DarkRP.retrieveTeamSpawnPos(teamId) or {}

            for _, pos in ipairs(spawns) do
                local key = categoryName .. "|" .. posKey(pos)
                local item = grouped[key]

                if not item then
                    item = {
                        category = categoryName,
                        pos = pos,
                        color = colorToTable(job.color),
                        model = firstJobModel(job),
                        jobs = {},
                        count = 0
                    }
                    grouped[key] = item
                end

                item.count = item.count + 1
                item.jobs[#item.jobs + 1] = job.name
            end
        end

        local data = {}
        for _, item in pairs(grouped) do
            data[#data + 1] = item
        end

        table.sort(data, function(a, b)
            if a.category == b.category then
                return a.pos:DistToSqr(vector_origin) < b.pos:DistToSqr(vector_origin)
            end

            return a.category < b.category
        end)

        return data
    end

    local function sendCategories(ply)
        local categories = getJobCategories()

        net.Start(NET_CATEGORIES)
            net.WriteUInt(#categories, 12)
            for _, category in ipairs(categories) do
                net.WriteString(category.name)
            end
        net.Send(ply)
    end

    local function sendSpawns(ply)
        local data = collectSpawnData()

        net.Start(NET_SPAWNS)
            net.WriteUInt(#data, 14)
            for _, item in ipairs(data) do
                net.WriteString(item.category)
                net.WriteVector(item.pos)
                net.WriteString(item.model)
                net.WriteColor(Color(item.color.r, item.color.g, item.color.b, item.color.a))
                net.WriteUInt(math.min(item.count, 255), 8)
                net.WriteString(table.concat(item.jobs, ", "))
            end
        net.Send(ply)
    end

    local function refreshPlayer(ply)
        if not isAdmin(ply) then return end

        sendCategories(ply)
        sendSpawns(ply)
    end

    net.Receive(NET_REFRESH, function(_, ply)
        refreshPlayer(ply)
    end)

    hook.Add("PlayerInitialSpawn", "ASV_SendInitialData", function(ply)
        timer.Simple(6, function()
            if IsValid(ply) then
                refreshPlayer(ply)
            end
        end)
    end)

    function TOOL:LeftClick(trace)
        local ply = self:GetOwner()
        if not isAdmin(ply) or not (DarkRP and DarkRP.addTeamSpawnPos) then return false end

        local categoryName = self:GetClientInfo("category")
        local category = getCategoryByName(categoryName)
        if not category then
            notify(ply, 1, "Category not found: " .. tostring(categoryName))
            return false
        end

        local jobs = getCategoryJobs(category.name)
        if #jobs == 0 then
            notify(ply, 1, "No jobs in category: " .. category.name)
            return false
        end

        local pos = trace.HitPos
        for _, entry in ipairs(jobs) do
            DarkRP.addTeamSpawnPos(entry.teamId, {pos.x, pos.y, pos.z})
        end

        notify(ply, 0, "Spawn added for category: " .. category.name)
        timer.Simple(0.2, function()
            if IsValid(ply) then sendSpawns(ply) end
        end)

        return true
    end

    function TOOL:RightClick(trace)
        local ply = self:GetOwner()
        if not isAdmin(ply) or not (DarkRP and DarkRP.removeTeamSpawnPos and DarkRP.addTeamSpawnPos) then return false end

        local categoryName = self:GetClientInfo("category")
        local category = getCategoryByName(categoryName)
        if not category then
            notify(ply, 1, "Category not found: " .. tostring(categoryName))
            return false
        end

        local jobs = getCategoryJobs(category.name)
        local perTeamPositions = {}
        local nearestKey
        local nearestDist = REMOVE_DISTANCE_SQR

        for _, entry in ipairs(jobs) do
            perTeamPositions[entry.teamId] = {}

            for _, pos in ipairs(DarkRP.retrieveTeamSpawnPos(entry.teamId) or {}) do
                local key = posKey(pos)
                perTeamPositions[entry.teamId][key] = pos

                local dist = pos:DistToSqr(trace.HitPos)
                if dist < nearestDist then
                    nearestKey = key
                    nearestDist = dist
                end
            end
        end

        if not nearestKey then
            notify(ply, 1, "No nearby spawn found for category: " .. category.name)
            return false
        end

        for teamId in pairs(perTeamPositions) do
            perTeamPositions[teamId][nearestKey] = nil
        end

        local pending = #jobs
        local function restoreSpawns()
            pending = pending - 1
            if pending > 0 then return end

            for _, entry in ipairs(jobs) do
                for _, pos in pairs(perTeamPositions[entry.teamId]) do
                    DarkRP.addTeamSpawnPos(entry.teamId, {pos.x, pos.y, pos.z})
                end
            end

            if IsValid(ply) then
                notify(ply, 0, "Nearest spawn removed for category: " .. category.name)
                timer.Simple(0.2, function()
                    if IsValid(ply) then sendSpawns(ply) end
                end)
            end
        end

        for _, entry in ipairs(jobs) do
            DarkRP.removeTeamSpawnPos(entry.teamId, restoreSpawns)
        end

        return true
    end

    function TOOL:Reload()
        local ply = self:GetOwner()
        if not isAdmin(ply) then return false end

        refreshPlayer(ply)
        notify(ply, 0, "Spawn editor refreshed.")

        return true
    end
else
    local spawns = {}
    local models = {}
    local categories = {}
    local lastRefresh = 0

    local function cleanupModels()
        for _, model in pairs(models) do
            if IsValid(model) then
                model:Remove()
            end
        end

        models = {}
    end

    local function hasToolEquipped()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end

        local weapon = ply:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "gmod_tool" and weapon:GetMode() == TOOL_MODE
    end

    local function requestRefresh()
        if CurTime() < lastRefresh + 1 then return end
        lastRefresh = CurTime()

        net.Start(NET_REFRESH)
        net.SendToServer()
    end

    local function selectedCategory()
        return GetConVar("admin_spawn_editor_category"):GetString()
    end

    local function shouldShow(item)
        local onlySelected = GetConVar("admin_spawn_editor_only_selected"):GetBool()
        return not onlySelected or item.category == selectedCategory()
    end

    local function rebuildModels()
        cleanupModels()
        if not hasToolEquipped() then return end

        for index, item in ipairs(spawns) do
            if shouldShow(item) then
                local model = ClientsideModel(item.model, RENDERGROUP_TRANSLUCENT)
                if IsValid(model) then
                    model:SetPos(item.pos)
                    model:SetAngles(Angle(0, 0, 0))
                    model:SetRenderMode(RENDERMODE_TRANSALPHA)
                    model:SetColor(Color(item.color.r, item.color.g, item.color.b, 85))
                    model:SetNoDraw(false)
                    model:Spawn()

                    local sequence = model:LookupSequence("idle_all_01")
                    if sequence >= 0 then
                        model:SetSequence(sequence)
                    end

                    models[index] = model
                end
            end
        end
    end

    net.Receive(NET_CATEGORIES, function()
        categories = {}

        for _ = 1, net.ReadUInt(12) do
            categories[#categories + 1] = net.ReadString()
        end
    end)

    net.Receive(NET_SPAWNS, function()
        spawns = {}

        for i = 1, net.ReadUInt(14) do
            spawns[i] = {
                category = net.ReadString(),
                pos = net.ReadVector(),
                model = net.ReadString(),
                color = net.ReadColor(),
                count = net.ReadUInt(8),
                jobs = net.ReadString()
            }
        end

        rebuildModels()
    end)

    hook.Add("Think", "ASV_ToolVisibility", function()
        if hasToolEquipped() then
            if table.IsEmpty(spawns) then
                requestRefresh()
            end

            if table.IsEmpty(models) and not table.IsEmpty(spawns) then
                rebuildModels()
            end
        elseif not table.IsEmpty(models) then
            cleanupModels()
        end
    end)

    hook.Add("PostDrawTranslucentRenderables", "ASV_DrawLabels", function()
        if not hasToolEquipped() then return end

        local eyePos = EyePos()
        local ang = EyeAngles()
        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)

        for _, item in ipairs(spawns) do
            if shouldShow(item) and eyePos:DistToSqr(item.pos) < 3000 * 3000 then
                cam.Start3D2D(item.pos + Vector(0, 0, 84), Angle(0, ang.y, 90), 0.18)
                    draw.SimpleTextOutlined(item.category, "DermaLarge", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 220))
                    draw.SimpleTextOutlined(item.count .. " jobs", "DermaDefaultBold", 0, 28, Color(230, 230, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 220))
                cam.End3D2D()
            end
        end
    end)

    cvars.AddChangeCallback("admin_spawn_editor_only_selected", function()
        timer.Simple(0, rebuildModels)
    end, "ASV_RebuildSelected")

    cvars.AddChangeCallback("admin_spawn_editor_category", function()
        timer.Simple(0, rebuildModels)
    end, "ASV_RebuildCategory")

    function TOOL:Deploy()
        requestRefresh()
    end

    function TOOL:Holster()
        cleanupModels()
    end

    function TOOL.BuildCPanel(panel)
        panel:ClearControls()
        panel:Help("DarkRP Spawn Editor")
        panel:Help("Left click adds a spawn for every job in the selected category.")
        panel:Help("Right click removes the nearest spawn point from the selected category.")
        panel:Help("Reload refreshes visible spawns.")

        local combo = panel:ComboBox("Category", "admin_spawn_editor_category")
        if #categories == 0 then
            for _, category in ipairs(getJobCategories()) do
                combo:AddChoice(category.name, category.name)
            end
        else
            for _, categoryName in ipairs(categories) do
                combo:AddChoice(categoryName, categoryName)
            end
        end

        panel:CheckBox("Show only selected category", "admin_spawn_editor_only_selected")
        panel:Button("Refresh spawns", "asv_refresh_client")
    end

    concommand.Add("asv_refresh_client", function()
        requestRefresh()
    end)
end
