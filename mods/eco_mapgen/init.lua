eco_mapgen = {}

local MP = minetest.get_modpath("eco_mapgen")

dofile(MP .. "/info.lua")
dofile(MP .. "/mapgen.lua")
dofile(MP .. "/render_mapblock.lua")
dofile(MP .. "/get_biome_data.lua")
dofile(MP .. "/restore.lua")

dofile(MP .. "/biome.lua")
dofile(MP .. "/biomes/grass.lua")
dofile(MP .. "/biomes/ice.lua")
dofile(MP .. "/biomes/desert.lua")
