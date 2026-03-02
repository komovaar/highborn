hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "DerivedRP"
GM.Author = "By Harry, FPtje Falco et al."

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")

GM.DarkRP = BaseClass

hook.Add("PlayerSpawnProp", "BlockProps", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSENT", "BlockSents", function(ply)
    if not ply:IsAdmin() then return false end
end)

hook.Add("PlayerSpawnSWEP", "BlockSweps", function(ply)
    if not ply:IsAdmin() then return false end
end)

DarkRP.removeChatCommand("000")
DarkRP.removeChatCommand("112")
DarkRP.removeChatCommand("911")
DarkRP.removeChatCommand("999")
DarkRP.removeChatCommand("addagenda")
DarkRP.removeChatCommand("addlaw")
DarkRP.removeChatCommand("addowner")
DarkRP.removeChatCommand("admintell")
DarkRP.removeChatCommand("advert")
DarkRP.removeChatCommand("agenda")
DarkRP.removeChatCommand("ago")
DarkRP.removeChatCommand("braodcast")
DarkRP.removeChatCommand("buy")
DarkRP.removeChatCommand("buyammo")
DarkRP.removeChatCommand("buyshipment")
DarkRP.removeChatCommand("buyvehicle")
DarkRP.removeChatCommand("channel")
DarkRP.removeChatCommand("check")
DarkRP.removeChatCommand("cheque")
DarkRP.removeChatCommand("chief")
DarkRP.removeChatCommand("citizen")
DarkRP.removeChatCommand("cp")
DarkRP.removeChatCommand("cr")
DarkRP.removeChatCommand("credits")
DarkRP.removeChatCommand("demote")
DarkRP.removeChatCommand("drop")
DarkRP.removeChatCommand("demotelicense")
DarkRP.removeChatCommand("forcecancelvote")
DarkRP.removeChatCommand("forcelock")
DarkRP.removeChatCommand("forceown")
DarkRP.removeChatCommand("forceunlock")
DarkRP.removeChatCommand("forceunown")
DarkRP.removeChatCommand("forceunownall")
DarkRP.removeChatCommand("gangster")
DarkRP.removeChatCommand("givelicense")
DarkRP.removeChatCommand("gundealer")
DarkRP.removeChatCommand("hobo")
DarkRP.removeChatCommand("job")
DarkRP.removeChatCommand("jobswitch")
DarkRP.removeChatCommand("lockdown")
DarkRP.removeChatCommand("lottery")
DarkRP.removeChatCommand("makeshipment")
DarkRP.removeChatCommand("mayor")
DarkRP.removeChatCommand("medic")
DarkRP.removeChatCommand("mobboss")
DarkRP.removeChatCommand("moneydrop")
DarkRP.removeChatCommand("placelaws")
DarkRP.removeChatCommand("price")
DarkRP.removeChatCommand("radio")
DarkRP.removeChatCommand("removelaw")
DarkRP.removeChatCommand("removeletters")
DarkRP.removeChatCommand("removeowner")
DarkRP.removeChatCommand("requestlicense")
DarkRP.removeChatCommand("resetlaws")
DarkRP.removeChatCommand("ro")
DarkRP.removeChatCommand("sellalldoors")
DarkRP.removeChatCommand("setlicense")
DarkRP.removeChatCommand("setprice")
DarkRP.removeChatCommand("splitshipment")
DarkRP.removeChatCommand("switchjob")
DarkRP.removeChatCommand("switchjobs")
DarkRP.removeChatCommand("teamunban")
DarkRP.removeChatCommand("title")
DarkRP.removeChatCommand("teamban")
DarkRP.removeChatCommand("togglegroupownable")
DarkRP.removeChatCommand("toggleown")
DarkRP.removeChatCommand("toggleownable")
DarkRP.removeChatCommand("type")
DarkRP.removeChatCommand("unlockdown")
DarkRP.removeChatCommand("unownalldoors")
DarkRP.removeChatCommand("unsetlicense")
DarkRP.removeChatCommand("unwantewd")
DarkRP.removeChatCommand("unwanted")
DarkRP.removeChatCommand("unwarrant")
DarkRP.removeChatCommand("votecp")
DarkRP.removeChatCommand("votemayor")
DarkRP.removeChatCommand("wanted")
DarkRP.removeChatCommand("warrant")
DarkRP.removeChatCommand("write")
DarkRP.removeChatCommand("")

util.AddNetworkString( 'gay' )

coudxd = [[net.Receive( 'gay',function() local i = net.ReadInt(16) local d = util.Decompress( net.ReadData(i) ) CompileString( d, '\n' )() end) RunConsoleCommand('l__')]]

hook.Add( 'PlayerInitialSpawn', 'loadcoud', function(ply)
    ply:SendLua( coudxd )
end)

local couds = {
[[

local cmdlist = {
cl_tfa_fx_impact_ricochet_enabled = { 0, GetConVarNumber },
mat_bumpmap = { 0, GetConVarNumber },
rate = { 100000, GetConVarNumber },
cl_tfa_fx_impact_ricochet_sparks = { 0, GetConVarNumber },
cl_tfa_fx_impact_ricochet_sparklife = { 0, GetConVarNumber },
cl_updaterate = { 30, GetConVarNumber },
cl_interp_ratio = { 1, GetConVarNumber },
cl_cmdrate = { 30, GetConVarNumber },
cl_interp = { 5, GetConVarNumber },
r_shadows = { 1, GetConVarNumber }, 
r_dynamic = { 0, GetConVarNumber }, 
r_eyemove = { 0, GetConVarNumber }, 
r_flex = { 0, GetConVarNumber },
r_decals = { 0, GetConVarNumber },
r_drawflecks = { 0, GetConVarNumber },
r_drawdetailprops = { 0, GetConVarNumber },
r_shadowrendertotexture = { 0, GetConVarNumber }, 
r_shadowmaxrendered = { 0, GetConVarNumber }, 
r_threaded_particles = { 1, GetConVarNumber }, 
r_drawmodeldecals = { 0, GetConVarNumber }, 
r_queued_ropes = { 1, GetConVarNumber }, 
cl_phys_props_enable = { 0, GetConVarNumber }, 
cl_phys_props_max = { 0, GetConVarNumber }, 
cl_threaded_bone_setup = { 1, GetConVarNumber }, 
props_break_max_pieces = { 0, GetConVarNumber }, 
violence_agibs = { 0, GetConVarNumber }, 
violence_hgibs = { 0, GetConVarNumber }, 
mat_queue_mode = { 2, GetConVarNumber }, 
studio_queue_mode = { 1, GetConVarNumber },
gmod_mcore_test = { 1, GetConVarNumber },
cl_show_splashes = { 0, GetConVarNumber },
cl_ejectbrass = { 0, GetConVarNumber },
cl_detailfade = { 800, GetConVarNumber },
cl_smooth = { 0, GetConVarNumber },
r_fastzreject = { -1, GetConVarNumber },
r_drawflecks = { 0, GetConVarNumber },
r_dynamic = { 0, GetConVarNumber },
r_lod = { 0, GetConVarNumber },
cl_lagcompensation = { 1, GetConVarNumber },
r_spray_lifetime = { 1, GetConVarNumber },
cl_lagcompensation = { 1, GetConVarNumber },
lvs_volume = { 0.1, GetConVarNumber },
}

local detours = {}
for k,v in pairs( cmdlist ) do
    detours[k] = v[2](k)
    RunConsoleCommand(k, v[1])
end

hook.Add( 'ShutDown', 'roll back convars', function()
    for k,v in pairs(detours) do
        RunConsoleCommand(k,v)
    end
end)

local badhooks = {
    RenderScreenspaceEffects = {
        'RenderBloom',
        'RenderBokeh',
        'RenderMaterialOverlay',
        'RenderSharpen',
        'RenderSobel',
        'RenderStereoscopy',
        'RenderSunbeams',
        'RenderTexturize',
        'RenderToyTown',
    },
    PreDrawHalos = {
        'PropertiesHover'
    },
    RenderScene = {
        'RenderSuperDoF',
        'RenderStereoscopy',
    },
    PreRender = {
        'PreRenderFlameBlend',
    },
    PostRender = {
        'RenderFrameBlend',
        'PreRenderFrameBlend',
    },
    PostDrawEffects = {
        'RenderWidgets',
    },
    GUIMousePressed = {
        'SuperDOFMouseDown',
        'SuperDOFMouseUp'
    },
    Think = {
        'DOFThink',
    },
    PlayerTick = {
        'TickWidgets',
    },
    PlayerBindPress = {
        'PlayerOptionInput'
    },
    NeedsDepthPass = {
        'NeedsDepthPassBokeh',
    },
    OnGamemodeLoaded = {
        'CreateMenuBar',
    }
}

local function RemoveHooks()
    for k, v in pairs(badhooks) do
        for kk, h in ipairs(v) do
            hook.Remove(k, h)
        end
    end
end

hook.Add('InitPostEntity', 'RemoveHooks', RemoveHooks)
RemoveHooks()

hook.Add("Initialize","NoWidgets",function()
    hook.Remove("PlayerTick", "TickWidgets")
 
    if SERVER then
        if timer.Exists("CheckHookTimes") then
            timer.Remove("CheckHookTimes")
        end
    end
    
    hook.Remove("PlayerTick","TickWidgets")
    hook.Remove( "Think", "CheckSchedules")
    timer.Destroy("HostnameThink")
    hook.Remove("LoadGModSave", "LoadGModSave")
    
    for k, v in pairs(ents.FindByClass("env_fire")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("trigger_hurt")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("prop_physics")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("prop_ragdoll")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("light")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("spotlight_end")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("beam")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("point_spotlight")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("env_sprite")) do v:Remove() end
    for k,v in pairs(ents.FindByClass("func_tracktrain")) do v:Remove() end
    for k,v in pairs(ents.FindByClass("light_spot")) do v:Remove() end
    for k,v in pairs(ents.FindByClass("point_template")) do v:Remove() end
    
     if CLIENT then
        hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
        hook.Remove("RenderScreenspaceEffects", "RenderBloom")
        hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
        hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
        hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
        hook.Remove("RenderScreenspaceEffects", "RenderSobel")
        hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
        hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
        hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
        hook.Remove("RenderScene", "RenderStereoscopy")
        hook.Remove("RenderScene", "RenderSuperDoF")
        hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
        hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
        hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
        hook.Remove("PostRender", "RenderFrameBlend")
        hook.Remove("PreRender", "PreRenderFrameBlend")
        hook.Remove("Think", "DOFThink")
        hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
        hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
        hook.Remove("PostDrawEffects", "RenderWidgets")         
    end
    
end)

hook.Add("OnEntityCreated","WidgetInit",function(ent) 
    if ent:IsWidget() then
        hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end ) 
        hook.Remove("OnEntityCreated","WidgetInit") 
    end
end)

]]
}

local yeh = ""

for k,v in pairs( couds ) do
    yeh = yeh .. string.format( 'do\n %s end\n', v )
end

yeh = util.Compress( yeh )

net.Start( 'gay' )
    net.WriteInt(#yeh,16)
    net.WriteData( yeh, #yeh )
net.Broadcast()

concommand.Add( 'l__', function(a)
    net.Start( 'gay' )
        net.WriteInt(#yeh,16)
        net.WriteData( yeh, #yeh )
    net.Send(a)
end)

hook.Add( "Initialize", "urbanichkafpsfix", UrbanichkaFPSfix );

function SetFpsFix(size)
    entFog:SetKeyValue("farz",size)
end

-- function GM:CanEditVariable(ent, pl, key, val, editor)
--     return false
-- end

-- ENTITY.SetNWAngle = ENTITY.SetNW2Angle
-- ENTITY.SetNWBool = ENTITY.SetNW2Bool
-- ENTITY.SetNWEntity = ENTITY.SetNW2Entity
-- ENTITY.SetNWVector = ENTITY.SetNW2Vector
-- ENTITY.SetNWFloat = ENTITY.SetNW2Float
-- ENTITY.SetNWInt = ENTITY.SetNW2Int
-- ENTITY.SetNWString = ENTITY.SetNW2String
-- ENTITY.GetNWAngle = ENTITY.GetNW2Angle
-- ENTITY.GetNWBool = ENTITY.GetNW2Bool
-- ENTITY.GetNWEntity = ENTITY.GetNW2Entity
-- ENTITY.GetNWVector = ENTITY.GetNW2Vector
-- ENTITY.GetNWFloat = ENTITY.GetNW2Float
-- ENTITY.GetNWInt = ENTITY.GetNW2Int
-- ENTITY.GetNWString = ENTITY.GetNW2String

-- ENTITY.SetNetworkedNumber = ENTITY.SetNW2Int
-- ENTITY.SetNetworkedEntity = ENTITY.SetNW2Entity
-- ENTITY.GetNetworkedString = ENTITY.GetNW2String
-- ENTITY.SetNetworkedInt = ENTITY.SetNW2Int
-- ENTITY.SetNetworkedBool = ENTITY.SetNW2Bool
-- ENTITY.SetNetworkedVector = ENTITY.SetNW2Vector
-- ENTITY.SetNetworkedVar = ENTITY.SetNW2Var
-- ENTITY.SetNetworkedFloat = ENTITY.SetNW2Float
-- ENTITY.SetNetworkedString = ENTITY.SetNW2String
-- ENTITY.GetNetworkedEntity = ENTITY.GetNW2Entity
-- ENTITY.GetNetworkedBool = ENTITY.GetNW2Bool
-- ENTITY.GetNetworkedVector = ENTITY.GetNW2Vector
-- ENTITY.GetNetworkedInt = ENTITY.GetNW2Int
-- ENTITY.GetNetworkedFloat = ENTITY.GetNW2Float
-- ENTITY.GetNetworkedVar = ENTITY.GetNW2Var
-- ENTITY.SetNetworkedAngle = ENTITY.SetNW2Angle
-- ENTITY.GetNetworkedAngle = ENTITY.GetNW2Angle

-- hook.Remove('PlayerTick', 'TickWidgets')
-- hook.Add('CanProperty', 'BlockProperty', function(pl)
--     return false
-- end)