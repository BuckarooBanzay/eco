building_lib = {
	-- name -> def
	buildings = {},

	-- name -> def
	placements = {}
}

local MP = minetest.get_modpath("building_lib")
dofile(MP .. "/util.lua")
dofile(MP .. "/register.lua")
dofile(MP .. "/placements/simple.lua")
dofile(MP .. "/place_override.lua")
