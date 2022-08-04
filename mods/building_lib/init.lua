local storage = minetest.get_mod_storage()

building_lib = {
	-- name -> def
	buildings = {},

	-- name -> def
	placements = {},

	-- name -> def
	conditions = {},

	-- data storage
	store = mapblock_lib.create_data_storage(storage)
}

local MP = minetest.get_modpath("building_lib")
dofile(MP .. "/register.lua")
dofile(MP .. "/get_size.lua")
dofile(MP .. "/get_groups.lua")
dofile(MP .. "/get_building_at_pos.lua")
dofile(MP .. "/inventory.lua")
dofile(MP .. "/placements/simple.lua")
dofile(MP .. "/can_build.lua")
dofile(MP .. "/do_build.lua")
dofile(MP .. "/chat.lua")

if minetest.get_modpath("mtt") and mtt.enabled then
	dofile(MP .. "/mtt.lua")
end
