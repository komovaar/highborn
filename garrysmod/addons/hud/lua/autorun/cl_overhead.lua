if not CLIENT then return end

local MAX_DIST = 500 * 500
local SCALE = 0.045

local NAME_FONT = "HB_Overhead"
local JOB_FONT  = "HB_Overhead"

hook.Add("PostDrawTranslucentRenderables", "HB_DrawOverheadNames_3D2D", function()
    local lp = LocalPlayer()
    if not IsValid(lp) then return end

    for _, ply in ipairs(player.GetAll()) do
        if ply == lp then continue end
        if not ply:Alive() then continue end

        local dist = lp:GetPos():DistToSqr(ply:GetPos())
        if dist > MAX_DIST then continue end

        local pos = ply:GetPos() + Vector(0, 0, 78)
        local ang = Angle(0, lp:EyeAngles().y - 90, 90)

        local tr = util.TraceLine({
            start = lp:EyePos(),
            endpos = pos,
            filter = { lp, ply }
        })
        if tr.Hit then continue end

        local jobTable = ply:getJobTable()
        local jobColor = (jobTable and jobTable.color) or Color(160,160,160)

        -- === Категория + звание (как в табе) ===
        local category = jobTable and jobTable.category or ""
        local rank = ply:GetNWString("HighbornRank", "")

        local title = ""

        if category ~= "" and rank ~= "" then
            title = category .. " " .. rank
        elseif category ~= "" then
            title = category
        elseif rank ~= "" then
            title = rank
        else
            title = ply:getDarkRPVar("job") or ""
        end

        cam.Start3D2D(pos, ang, SCALE)

            DrawTextShadow(
                ply:Nick(),
                NAME_FONT,
                0,
                22,
                color_white,
                Color(0, 0, 0, 180),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_BOTTOM
            )

            DrawTextShadow(
                title,
                JOB_FONT,
                0,
                0,
                Color(jobColor.r, jobColor.g, jobColor.b, 255),
                Color(0, 0, 0, 180),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_TOP
            )

        cam.End3D2D()
    end
end)
