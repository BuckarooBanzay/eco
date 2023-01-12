
building_lib_transport = {}

local MP = minetest.get_modpath("building_lib_transport")
dofile(MP .. "/api.lua")
dofile(MP .. "/path.lua")
dofile(MP .. "/vehicle.spec.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/setup.spec.lua")
	dofile(MP .. "/path.spec.lua")
	dofile(MP .. "/vehicle.spec.lua")
end
