function DrawTextOutlined(text, font, x, y, col, outlineCol, ax, ay)
    draw.SimpleText(text, font, x+1, y, outlineCol, ax, ay)
    draw.SimpleText(text, font, x-1, y, outlineCol, ax, ay)
    draw.SimpleText(text, font, x, y+1, outlineCol, ax, ay)
    draw.SimpleText(text, font, x, y-1, outlineCol, ax, ay)

    draw.SimpleText(text, font, x, y, col, ax, ay)
end

function DrawTextShadow(text, font, x, y, col, shadowCol, ax, ay)
    draw.SimpleText(text, font, x+1, y+1, shadowCol, ax, ay)
    draw.SimpleText(text, font, x, y, col, ax, ay)
end

local blur = Material("pp/blurscreen")
function DrawBlur(panel)
    local x, y = panel:LocalToScreen(0,0)
    surface.SetMaterial(blur)
    surface.SetDrawColor(255,255,255)
    for i=1,6 do
        blur:SetFloat("$blur",i)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
    end
end
