
wOS.DynaBase:RegisterSource({
    Name = "L4D Extension",
    Type =  WOS_DYNABASE.EXTENSION,
    Shared = "models/player/wiltos/anim_extension_l4d.mdl",
})

hook.Add( "PreLoadAnimations", "wOS.DynaBase.MountL4DEXT", function( gender )
    if gender != WOS_DYNABASE.SHARED then return end
    IncludeModel( "models/player/wiltos/anim_extension_l4d.mdl" )
end )