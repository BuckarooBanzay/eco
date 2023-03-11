
building_lib_transport = {}

-- **very** WIP, don't use

--[[
local MP = minetest.get_modpath("building_lib_transport")
dofile(MP .. "/api.lua")
dofile(MP .. "/path.lua")
dofile(MP .. "/vehicle.lua")
dofile(MP .. "/vehicle_store.lua")
dofile(MP .. "/active_vehicles.lua")
dofile(MP .. "/route.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/setup.spec.lua")
	dofile(MP .. "/path.spec.lua")
	dofile(MP .. "/vehicle.spec.lua")
	dofile(MP .. "/vehicle_store.spec.lua")
	dofile(MP .. "/active_vehicles.spec.lua")
	dofile(MP .. "/route.spec.lua")
end
--]]