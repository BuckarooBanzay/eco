
building_lib_transport = {}

local MP = minetest.get_modpath("building_lib_transport")
dofile(MP .. "/api.lua")
dofile(MP .. "/route.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/route.spec.lua")
end
