building_lib = {
	-- name -> def
	buildings = {},

	-- name -> def
	placements = {}
}

local MP = minetest.get_modpath("building_lib")
dofile(MP .. "/register.lua")
dofile(MP .. "/get_building_at_pos.lua")
dofile(MP .. "/get_groups_at_pos.lua")
dofile(MP .. "/timer.lua")
dofile(MP .. "/inventory.lua")
dofile(MP .. "/placements/simple.lua")
dofile(MP .. "/placements/connected.lua")
dofile(MP .. "/get_size.lua")
dofile(MP .. "/can_build.lua")
dofile(MP .. "/do_build.lua")
