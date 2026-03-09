-- lua/autorun/cgi_civ_randomize.lua
-- CGI Civ Pack RNG + per-NPC hair/facial-hair tint
-- SP/MP-safe (AddCSLuaFile). No bodygroup blacklist. No helmet bias.
-- Retains 10% blind-eye chance. Random skins + subtle height variance.

if SERVER then AddCSLuaFile() end

---------------------------------------
-- ConVars
---------------------------------------
CreateConVar("cgi_randomize_npcs", "1", FCVAR_ARCHIVE, "Enable CGI Civilian NPC randomizer")
CreateConVar("cgi_randomize_debug", "0", FCVAR_ARCHIVE, "Debug prints for CGI randomizer")

-- Hair behaviour
CreateConVar("cgi_hair_natural_weight", "0.90", FCVAR_ARCHIVE, "Probability of natural hair colors (0..1)")
CreateConVar("cgi_hair_tint_strength",  "0.65", FCVAR_ARCHIVE, "Tint strength toward white (0..1, lower=stronger color)")

-- Scale / height randomization (enable/disable)
CreateConVar("cgi_scale_enable", "1", FCVAR_ARCHIVE, "Enable random height/scale for CGI civilians")

-- Cache ConVar objects
local CVar_Randomize     = GetConVar("cgi_randomize_npcs")
local CVar_Debug         = GetConVar("cgi_randomize_debug")
local CVar_HairNatural   = GetConVar("cgi_hair_natural_weight")
local CVar_HairStrength  = GetConVar("cgi_hair_tint_strength")
local CVar_ScaleEnable   = GetConVar("cgi_scale_enable")

-- Localize hot functions
local Rand, Random, Clamp = math.Rand, math.random, math.Clamp
local max                  = math.max
local lower, find, gsub    = string.lower, string.find, string.gsub
local StripExt             = string.StripExtension
local FileFrom             = string.GetFileFromFilename
local fmt                  = string.format
local CRC                  = util.CRC

local print = print
local function dbg(...) if CVar_Debug:GetBool() then print("[CGI Rand]", ...) end end

---------------------------------------
-- Helpers
---------------------------------------
local function IsCivPackNPC(ent)
    if not IsValid(ent) or not ent:IsNPC() then return false end
    local mdl = lower(ent:GetModel() or "")
    return find(mdl, "/npc_civ_", 1, true) ~= nil
end

-- Normalize filename to key
local function NormKeyFromPath(matPath)
    local base = lower(StripExt(FileFrom(matPath) or ""))
    base = gsub(base, "^fhair[_%-]?", "")
    base = gsub(base, "^hair[_%-]?", "")
    base = gsub(base, "[^%w]", "")
    return base
end

-- Safely ask engine for submodel name
local function GetSubmodelName(ent, bgid, i)
    local ok, name = pcall(ent.GetBodygroupName, ent, bgid, i)
    return (ok and isstring(name)) and name or nil
end

---------------------------------------
-- Hair / facial-hair basenames (filename-only; folders don’t matter)
---------------------------------------
local HAIR_BASE, FHAIR_BASE = {}, {}
local function add(list, arr) for i=1,#arr do list[arr[i]] = true end end

add(HAIR_BASE, {
    "boost","braids","chicho","cornrows",
    "curley_hair","curleyhair","curlyhair",
    "emo","flat","forward","front_flip","frontflip",
    "jaybo","kenobi","mohawk","parted","quigon","senior","spikes","reg","flow","short",
    "bangs","bob","braid","buns","dreads","flip","karen","long","luxurybob","messy",
    "pigtails","ponytails","princess","shoulderlength","spirals","swoop","topbun"
})
add(FHAIR_BASE, { "beard","stache","walrus" })

local function IsHairMaterial(matPath)
    if not matPath or matPath == "" then return false end
    local key  = NormKeyFromPath(matPath)
    if FHAIR_BASE[key] then return true, "facial", key end
    if HAIR_BASE[key]  then return true, "head",   key end
    return false
end

---------------------------------------
-- Color palettes (Vectors 0..1 RGB) with labels
---------------------------------------
local NATURAL_PALETTE = {
    { name="dirty_blonde", col=Vector(0.78, 0.71, 0.50), w=1.2 },
    { name="blonde",       col=Vector(0.90, 0.82, 0.62), w=1.0 },
    { name="silver_grey",  col=Vector(0.66, 0.62, 0.58), w=0.8 },

    { name="light_brown",  col=Vector(0.40, 0.28, 0.16), w=1.4, minV=0.60, strength=0.90 },
    { name="brown",        col=Vector(0.28, 0.20, 0.13), w=2.0, minV=0.58, strength=0.95 },
    { name="charcoal",     col=Vector(0.10, 0.09, 0.09), w=2.2, minV=0.50, strength=1.00 },
    { name="jet_black",    col=Vector(0.02, 0.02, 0.02), w=4.0, minV=0.42, strength=1.00 },
}
local EXOTIC_PALETTE = {
    { name="platinum_white", col=Vector(0.92,0.92,0.90), strength=0.85, w=1 },
    { name="vivid_ginger",   col=Vector(0.90,0.45,0.20), strength=0.95, w=1 },

    { name="moss_green",     col=Vector(0.32,0.58,0.36), strength=1.00, w=1 },
    { name="strong_blue",    col=Vector(0.20,0.42,0.78), strength=1.00, w=1 },

    { name="seafoam",        col=Vector(0.55,0.75,0.65), strength=0.95, w=1 },
    { name="steel_blue",     col=Vector(0.50,0.65,0.85), strength=0.95, w=1 },
    { name="sky_blue",       col=Vector(0.60,0.75,0.90), strength=0.95, w=1 },
    { name="lavender",       col=Vector(0.65,0.55,0.75), strength=0.95, w=1 },
    { name="plum",           col=Vector(0.50,0.35,0.55), strength=0.95, w=1 },

    { name="rose",           col=Vector(0.95,0.35,0.60), strength=0.95, w=1 },
    { name="pink",           col=Vector(1.00,0.50,0.70), strength=0.95, w=1 },
    { name="brick_red",      col=Vector(0.55,0.25,0.25), strength=0.95, w=1 },
    { name="crimson",        col=Vector(0.65,0.30,0.30), strength=0.95, w=1 },
}

---------------------------------------
-- Color helpers
---------------------------------------
local function WeightedPickDef(list)
    local sum = 0
    for i=1,#list do sum = sum + (list[i].w or 1) end
    local r = Rand(0, sum)
    for i=1,#list do
        r = r - (list[i].w or 1)
        if r <= 0 then return list[i] end
    end
    return list[#list]
end

local function Jitter(vec, pct)
    return Vector(
        Clamp(vec.x * Rand(1-pct, 1+pct), 0, 1),
        Clamp(vec.y * Rand(1-pct, 1+pct), 0, 1),
        Clamp(vec.z * Rand(1-pct, 1+pct), 0, 1)
    )
end

local function EnsureMinValue(vec, minV)
    local v = max(vec.x, max(vec.y, vec.z))
    if v <= 0 then return Vector(minV, minV, minV) end
    if v >= minV then return vec end
    local k = minV / v
    return Vector(math.min(1, vec.x*k), math.min(1, vec.y*k), math.min(1, vec.z*k))
end

local function TowardsWhite(vec, strength)
    local s = Clamp(strength or 1, 0, 1)
    local w = 1 - s
    return Vector(vec.x*s + 1*w, vec.y*s + 1*w, vec.z*s + 1*w)
end

local function ApplyOverrides(vec, def, defaultMinV, defaultStrength)
    vec = EnsureMinValue(vec, def.minV or defaultMinV)
    local useStrength = (def.strength ~= nil) and def.strength or defaultStrength
    return TowardsWhite(vec, useStrength)
end

-- Returns: Vector color, string label
local function SoftHairColorVec()
    local naturalWeight = Clamp(CVar_HairNatural:GetFloat(), 0, 1)
    local strength      = Clamp(CVar_HairStrength:GetFloat(), 0, 1)
    local defaultMinV   = 0.72 -- keeps blondes/greys bright

    local def
    if Rand(0,1) < naturalWeight then
        def = WeightedPickDef(NATURAL_PALETTE)
        local pick = Jitter(def.col, 0.05)
        return ApplyOverrides(pick, def, defaultMinV, strength), (def.name or "natural")
    else
        def = WeightedPickDef(EXOTIC_PALETTE)
        local pick = def.col
        return ApplyOverrides(pick, def, 0.72, strength), (def.name or "exotic")
    end
end

---------------------------------------
-- SCALE / HEIGHT RANDOMIZATION
---------------------------------------
local function RandomizeScale(ent)
    if not IsValid(ent) or not CVar_ScaleEnable:GetBool() then return end

    -- Weighted distribution: mostly normal
    local r = Rand(0,1)
    local s
    if r < 0.15 then
        s = Rand(0.90, 0.95)   -- short ~15%
    elseif r < 0.85 then
        s = Rand(0.97, 1.03)   -- normal ~70%
    else
        s = Rand(1.07, 1.14)   -- tall ~15%
    end

    ent:SetModelScale(s, 0)
    ent:SetNWFloat("cgi_scale", s)
    dbg(fmt("scale -> %.3f", s))

    if s < 0.92 or s > 1.12 then
        local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
        if mins and maxs then
            mins = mins * s
            maxs = maxs * s
            maxs.z = math.min(maxs.z, 80 * s)
            ent:SetCollisionBounds(mins, maxs)
        end
    end
end

---------------------------------------
-- SERVER: randomize + share hair color
---------------------------------------
if SERVER then
    local function RandomizeNPC(ent)
        if not IsValid(ent) or not ent:IsNPC() or ent._cgi_rand_done then return end
        ent._cgi_rand_done = true

        -- Bodygroups: uniform RNG (no blacklist, no helmet bias), but keep 10% blind-eye logic
        local bgs = ent:GetBodyGroups() or {}
        for _, bg in ipairs(bgs) do
            local n = bg.num or 0
            if n > 0 then
                local bgRawName   = bg.name or ""
                local bgNameLower = lower(bgRawName)

                if find(bgNameLower, "eye_left", 1, true) or find(bgNameLower, "eye_right", 1, true) then
                    -- Blind-eye: pick a 'blind' index with 10% probability
                    local baseline, blindIndex
                    for i = 0, n - 1 do
                        local nm = lower(GetSubmodelName(ent, bg.id, i) or "")
                        if find(nm, "blind", 1, true) then
                            blindIndex = blindIndex or i
                        else
                            baseline = baseline or i
                        end
                    end
                    baseline   = baseline or 0
                    blindIndex = blindIndex or baseline
                    local choice = (Rand(0,1) < 0.10) and blindIndex or baseline
                    ent:SetBodygroup(bg.id, choice)
                else
                    -- Pure uniform RNG across available options
                    ent:SetBodygroup(bg.id, Random(0, n - 1))
                end
            end
        end

        -- Skins
        local sc = ent:SkinCount() or 0
        if sc > 0 then ent:SetSkin(Random(0, sc - 1)) end

        -- Hair color once; clients apply identical tint
        local hairCol, hairName = SoftHairColorVec()
        ent:SetNWVector("cgi_haircol", hairCol)
        ent:SetNWString("cgi_hairname", hairName or "")
        dbg(fmt("hair picked: %s  rgb=%.2f,%.2f,%.2f", hairName or "?", hairCol.x, hairCol.y, hairCol.z))

        -- Height/scale
        RandomizeScale(ent)
    end

    hook.Add("PlayerSpawnedNPC", "CGI_Randomize_CivNPCs_Spawned", function(_, ent)
        if not CVar_Randomize:GetBool() then return end
        if not IsCivPackNPC(ent) then return end
        timer.Simple(0, function() if IsValid(ent) then RandomizeNPC(ent) end end)
    end)

    hook.Add("OnEntityCreated", "CGI_Randomize_CivNPCs_Map", function(ent)
        if not CVar_Randomize:GetBool() then return end
        timer.Simple(0, function() if IsValid(ent) and IsCivPackNPC(ent) then RandomizeNPC(ent) end end)
    end)
end

---------------------------------------
-- CLIENT: clone/cache mats + apply tint (collision-proof)
---------------------------------------
if CLIENT then
    local MATCACHE = {}

    local function ColorKey(v)
        local function q(x) return math.floor(x*255 + 0.5) end
        return fmt("%02X%02X%02X", q(v.x), q(v.y), q(v.z))
    end

    -- Robust clone: works even if source VMT is detail-only or odd shader.
    local function SafeCloneHairMaterial(srcPath, vecColor)
        local m = Material(srcPath)
        if not m then return nil end

        -- Resolve a real base texture (never a VMT)
        local baseTex = m:GetString("$basetexture")
        if (not baseTex or baseTex == "" or baseTex:find("%.vmt")) then
            baseTex = m:GetString("$basetexture2")
        end

        -- If still missing, fall back to neutral base but PRESERVE $detail
        local usedFallbackBase = false
        if not baseTex or baseTex == "" or baseTex:find("%.vmt") then
            baseTex = "models/debug/debugwhite"
            usedFallbackBase = true
        end

        local key  = srcPath .. "|" .. (usedFallbackBase and "F|" or "B|") .. ColorKey(vecColor)
        local name = "cgi_hair_tint_" .. CRC(key)
        if MATCACHE[name] then return MATCACHE[name] end

        local function i(k) return m:GetInt(k) end
        local function f(k) return m:GetFloat(k) end
        local function s(k) return m:GetString(k) end
        local function v3(k)
            local v = m:GetVector(k)
            return v and fmt("[%g %g %g]", v.x, v.y, v.z) or nil
        end

        local params = {
            ["$basetexture"]            = baseTex,
            ["$color"]                  = "[1 1 1]",
            ["$halflambert"]            = tostring(i("$halflambert") or 1),
            ["$alphatest"]              = i("$alphatest") == 1 and "1" or nil,
            ["$translucent"]            = i("$translucent") == 1 and "1" or nil,
            ["$nocull"]                 = i("$nocull") == 1 and "1" or nil,
            ["$nodecal"]                = i("$nodecal") == 1 and "1" or nil,

            -- normal/phong
            ["$bumpmap"]                = s("$bumpmap"),
            ["$phong"]                  = (i("$phong") == 1 or s("$bumpmap")) and "1" or nil,
            ["$phongboost"]             = tostring(f("$phongboost") or 1),
            ["$phongfresnelranges"]     = v3("$phongfresnelranges") or "[0.3 0.5 1]",
            ["$basemapalphaphongmask"]  = i("$basemapalphaphongmask") == 1 and "1" or nil,
            ["$phongexponent"]          = tostring(f("$phongexponent") or 15),
            ["$phongexponenttexture"]   = s("$phongexponenttexture"),

            -- preserve detail strands
            ["$detail"]                 = s("$detail"),
            ["$detailscale"]            = tostring(f("$detailscale") or i("$detailscale") or nil),
            ["$detailblendmode"]        = tostring(i("$detailblendmode") or nil),
            ["$detailtexturetransform"] = s("$detailtexturetransform"),
            ["$detailblendfactor"]      = tostring(f("$detailblendfactor") or i("$detailblendfactor") or nil),

            -- our dye
            ["$blendtintcoloroverbase"] = "1",
            ["$blendtintbybasealpha"]   = "0",
            ["$color2"]                 = fmt("[%g %g %g]", vecColor.x, vecColor.y, vecColor.z),
        }

        local dyn = CreateMaterial(name, "VertexLitGeneric", params)
        MATCACHE[name] = dyn
        return dyn
    end

    local function ApplyTintToSlot(ent, slotIndex0, srcPath, vecColor)
        local dyn = SafeCloneHairMaterial(srcPath, vecColor)
        if not dyn then return end
        ent:SetSubMaterial(slotIndex0, "!" .. dyn:GetName())
    end

    local function ApplyHairAndFacialTint(ent)
        if not IsValid(ent) then return end
        local col = ent:GetNWVector("cgi_haircol", Vector(0,0,0))
        if col.x == 0 and col.y == 0 and col.z == 0 then
            local pickedCol = SoftHairColorVec()
            col = pickedCol
        end
        local mats = ent:GetMaterials() or {}
        for slot1 = 1, #mats do
            local matPath = mats[slot1]
            local isHair, kind, key = IsHairMaterial(matPath)
            if isHair then
                ApplyTintToSlot(ent, slot1 - 1, matPath, col)
                dbg(fmt("tinted %-6s slot %d (%s) color=%s", kind or "?", slot1-1, key or "?", tostring(col)))
            end
        end
        dbg(fmt("tint label: %s", ent:GetNWString("cgi_hairname","?")))
    end

    hook.Add("OnEntityCreated", "CGI_Randomize_CivNPCs_Tint_Client", function(ent)
        timer.Simple(0.05, function()
            if not IsValid(ent) or not ent:IsNPC() then return end
            if not IsCivPackNPC(ent) then return end
            ApplyHairAndFacialTint(ent)
        end)
    end)
end
