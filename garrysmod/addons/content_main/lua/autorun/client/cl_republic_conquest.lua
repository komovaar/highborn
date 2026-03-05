surface.CreateFont( "RepublicConquestFont", {
    font = "geometos",
    size = 20,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
} )

surface.CreateFont( "RepublicConquestContested", {
    font = "geometos",
    size = 24,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
} )

local function DrawIcon(icon, x, y, w, h)
    local mat = Material(icon)

    if not mat then mat = Material("republic_conquest/border.png") end

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, w, h)
end

// Drawing variables
local lerpProgress = 0

net.Receive("RepublicConquest_ControlPointCaptured", function()
    surface.PlaySound("republic_conquest/capture.wav")
end)

hook.Add("HUDPaint", "RepublicConquest_HUDPaint", function()
    if not RepublicConquest.Point then return end

    local numPoints = table.Count(RepublicConquest.Point)

    if numPoints == 0 then return end

    local size = ScrH()/18
    local padding = 10

    local visiblePoints = {}
    for point, index in pairs(RepublicConquest.Point) do
        if IsValid(point) then
            if not point:GetUseProximity() or point:GetPos():Distance(LocalPlayer():GetPos()) <= point:GetProximityDistance() then
                table.insert(visiblePoints, {point = point, index = index})
            end
        end
    end

    table.sort(visiblePoints, function(a, b) return a.index < b.index end)

    local visibleCount = #visiblePoints
    local width = (size + padding) * visibleCount - padding
    -- local width = (size + padding) * numPoints - padding

    for index, data in ipairs(visiblePoints) do
        local point = data.point
        if not IsValid(point) then continue end

        local x = (ScrW() / 2) - (width / 2) + ((size + padding) * (index - 1))
        local y = ScrH() / 8

        local progress = point:GetProgress()
        local progressHeight = size * progress

        // Draw owner color background
        surface.SetDrawColor(point:GetPointColor())
        surface.DrawRect(x, y, size, size)

        // Draw progression
        surface.SetDrawColor(point:GetProgressorColor())
        surface.DrawRect(x, y + (size - progressHeight), size, progressHeight)

        DrawIcon(point:GetPointIcon(), x, y, size, size)
    end

    local controlPointInside = LocalPlayer():GetNWEntity("Conquest_ControlPoint")

    if controlPointInside == LocalPlayer() or not IsValid(controlPointInside) then return end

    // Progression Bar
    local barWidth = ScrW() / 4
    local barHeight = 20
    local progress = controlPointInside:GetProgress()

    // Interpolate the progress bar
    lerpProgress = Lerp(FrameTime() * 5, lerpProgress, progress)

    local progressWidth = barWidth * lerpProgress

    local barX = (ScrW() / 2) - (barWidth / 2)
    local barY = ScrH() / 8 + size + padding

    local barColor = Color(255, 255, 255, 200)
    
    if controlPointInside:GetProgress() ~= 0 then
        // Fade in and out the bar but subtly, the alpha doesn't go below 150.
        local alpha = math.abs(math.sin(CurTime() * 3) * 105) + 150
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(barX, barY, barWidth, barHeight)

        // Progression Bar Progress
        // If full, just draw the full bar.
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.DrawRect(barX, barY, progressWidth, barHeight)
    end

    if controlPointInside:GetContested() then
        local alpha = math.abs(math.sin(CurTime() * 2) * 255)
        surface.SetFont("RepublicConquestContested")
        surface.SetTextColor(0, 150, 255, alpha)
        local w, h = surface.GetTextSize("Contested")
        surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() / 8 + size + padding)
        surface.DrawText("Contested")
    end
end)

hook.Add("InitPostEntity", "RepublicConquest_Setup_Client", function()
    timer.Create("RepublicConquest_FetchPoints", 15, 6, function()
        RepublicConquest:FetchPoints()
    end)
end)