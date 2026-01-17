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