if (SERVER) then
	AddCSLuaFile("gmmp/cl_gmmp.lua")
	include("gmmp/sv_gmmp.lua")
else
	include("gmmp/cl_gmmp.lua")
end