include("shared.lua")

local mainColor = WeaponTraderConfig.MainColor
local selectedWeapon = nil

local function GetWeaponModel(wep)
    if wep.model and util.IsValidModel(wep.model) then
        return wep.model
    end

    -- fallback (если модель не указана или сломана)
    return "models/weapons/w_pistol.mdl"
end


net.Receive("WeaponTrader.Open", function()
    if IsValid(WeaponTraderMenu) then WeaponTraderMenu:Remove() end

    WeaponTraderMenu = vgui.Create("DFrame")
    WeaponTraderMenu:SetSize(900, 520)
    WeaponTraderMenu:Center()
    WeaponTraderMenu:SetTitle("")
    WeaponTraderMenu:MakePopup()
    WeaponTraderMenu.Paint = function(self, w, h)
        draw.RoundedBox(14, 0, 0, w, h, Color(10,15,25,245))
        surface.SetDrawColor(mainColor)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    -- 🧊 МОДЕЛЬ
   local model = vgui.Create("DModelPanel", WeaponTraderMenu)
    model:SetSize(360, 360)
    model:SetPos(270, 80)
    model:SetVisible(false)
    
    local placeholder = vgui.Create("DPanel", WeaponTraderMenu)
    placeholder:SetSize(360, 360)
    placeholder:SetPos(270, 80)
    placeholder.Paint = function(self, w, h)
        draw.RoundedBox(12, 0, 0, w, h, Color(14, 20, 32))
        draw.SimpleText(
            "SELECT A WEAPON",
            "DermaLarge",
            w / 2,
            h / 2 - 10,
            WeaponTraderConfig.MainColor,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
        draw.SimpleText(
            "Choose from the list on the left",
            "DermaDefault",
            w / 2,
            h / 2 + 20,
            Color(160, 180, 210),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
end

    -- 📊 ХАРАКТЕРИСТИКИ
    local stats = vgui.Create("DPanel", WeaponTraderMenu)
    stats:SetPos(650, 90)
    stats:SetSize(220, 300)
    stats:SetVisible(false)
    stats.Paint = function(self, w, h)
        draw.SimpleText("STATS", "DermaLarge", 10, 10, mainColor)

        local y = 50
        for k, v in pairs(selectedWeapon.stats) do
            draw.SimpleText(k .. ": " .. tostring(v), "DermaDefaultBold", 10, y, color_white)
            y = y + 30
        end
    end

    -- 📜 СПИСОК
    local list = vgui.Create("DScrollPanel", WeaponTraderMenu)
    list:SetPos(20, 80)
    list:SetSize(230, 400)

    for _, wep in ipairs(WeaponTraderConfig.Weapons) do
        local btn = list:Add("DButton")
        btn:SetTall(60)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 8)
        btn:SetText("")
        btn.hover = 0

        btn.Paint = function(self, w, h)
            self.hover = Lerp(FrameTime() * 10, self.hover, self:IsHovered() and 1 or 0)
            local glow = Color(
                mainColor.r,
                mainColor.g,
                mainColor.b,
                50 + self.hover * 80
            )

            draw.RoundedBox(8, 0, 0, w, h, Color(18,25,38))
            draw.RoundedBox(8, 0, 0, w, h, glow)
            draw.SimpleText(wep.name, "DermaDefaultBold", 10, 20, color_white)
        end

      btn.DoClick = function()
    selectedWeapon = wep

    placeholder:SetVisible(false)

    model:SetVisible(true)
    model:SetModel(GetWeaponModel(wep))

    stats:SetVisible(true)

end

    end
end)
