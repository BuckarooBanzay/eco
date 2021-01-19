eco_mapgen = {}

local MP = minetest.get_modpath("eco_mapgen")

dofile(MP .. "/height_generator.lua")
dofile(MP .. "/landscape_generator.lua")
dofile(MP .. "/mapgen.lua")
dofile(MP .. "/place_mapblock.lua")

dofile(MP .. "/biome.lua")
dofile(MP .. "/biome_grass.lua")
dofile(MP .. "/biome_underground.lua")
dofile(MP .. "/biome_water.lua")
