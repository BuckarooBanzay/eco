building_lib = {
	schema_path = minetest.get_worldpath() .. "/buildings",

	mapblock_positions_1 = {},
	mapblock_positions_2 = {}
}

-- create global schema_path
minetest.mkdir(mapblock_lib.schema_path)

local MP = minetest.get_modpath("building_lib")

dofile(MP .. "/manifest.lua")
dofile(MP .. "/iterator_next.lua")
dofile(MP .. "/load.lua")
dofile(MP .. "/save.lua")
dofile(MP .. "/allocate.lua")
dofile(MP .. "/chatcommands.lua")
