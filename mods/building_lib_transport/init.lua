
building_lib_transport = {
	store = mapblock_lib.create_data_storage(minetest.get_mod_storage())
}

local MP = minetest.get_modpath("building_lib_transport")
dofile(MP .. "/api.lua")
dofile(MP .. "/path.lua")
dofile(MP .. "/vehicle.lua")
dofile(MP .. "/active_vehicles.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/setup.spec.lua")
	dofile(MP .. "/path.spec.lua")
	dofile(MP .. "/vehicle.spec.lua")
	dofile(MP .. "/active_vehicles.spec.lua")
end
