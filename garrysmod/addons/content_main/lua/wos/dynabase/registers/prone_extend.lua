
wOS.DynaBase:RegisterSource({
    Name = "Prone Mod Extension",
    Type =  WOS_DYNABASE.EXTENSION,
    Shared = "models/player/wiltos/anim_extension_prone.mdl",
})

hook.Add( "PreLoadAnimations", "wOS.DynaBase.MountProne", function( gender )
    if gender != WOS_DYNABASE.SHARED then return end
    IncludeModel( "models/player/wiltos/anim_extension_prone.mdl" )
end )