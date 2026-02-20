surface.CreateFont('Jetted',{font='Trebuchet MS',size=48,weight=400})

local function DrawRect(col,x,y,w,h)
	x, y = math.Round(x), math.Round(y)
	w, h = math.Round(w), math.Round(h)
	surface.SetDrawColor(col.r,col.g,col.b,col.a)
	surface.DrawRect(x,y,w,h)
end

local function DrawText(...)
	local aye = {...}
	surface.SetFont(aye[1])
	local oldx, oldy = 0, 0
	for i = 4, #aye do
		if istable(aye[i]) then
			surface.SetTextColor(aye[i])
		else
			surface.SetTextPos(aye[2]+oldx,aye[3])
			surface.DrawText(tostring(aye[i]))
			local _ox, _oy = surface.GetTextSize(tostring(aye[i]))
			oldx, oldy = oldx+_ox, oldy+_oy
		end
	end
end

local function GetTextSize(...)
	local aye = {...}
	surface.SetFont(aye[1])
	local legx, legy = 0, 0
	for i = 2, #aye do
		if isstring(aye[i]) then
			local xd, yd = surface.GetTextSize(tostring(aye[i]))
			legx = legx + xd
			legy = legy > yd and legy or yd
		end
	end
	return legx, legy
end

local MSW, MSH = ScrW(), ScrH()
local fuelbarwidth, fuelbarheigth = 440, 10
local col_bg = Color(35,35,35,220)
local col_fuel = Color(255,183,45)
local jet, cf, mf = NULL, 100, 100

hook.Add('Tick','Jetted',function()
	if !IsValid(LocalPlayer()) then return end
	jet = LocalPlayer():GetNWEntity('Jetted')
	if !IsValid(jet) then return end
	cf, mf = jet:GetFuel(), jet:GetMaxFuel()
end)

hook.Add('HUDPaint','jetted',function()
	if !IsValid(jet) then return end
	local percent = math.floor(cf/mf*100)
	DrawRect(col_bg, MSW/2 - fuelbarwidth/2, MSH-fuelbarheigth*8, fuelbarwidth, fuelbarheigth)
	DrawRect(col_fuel, MSW/2 - fuelbarwidth/2, MSH-fuelbarheigth*8, (fuelbarwidth)*percent/100, fuelbarheigth)
end)
















