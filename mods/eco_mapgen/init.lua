eco_mapgen = {}

local MP = minetest.get_modpath("eco_mapgen")

dofile(MP .. "/api.lua")
dofile(MP .. "/biome.lua")
dofile(MP .. "/slope_info.lua")
dofile(MP .. "/mapgen.lua")
dofile(MP .. "/render_mapblock.lua")
dofile(MP .. "/render_decorations.lua")
dofile(MP .. "/get_biome_data.lua")
dofile(MP .. "/restore.lua")

dofile(MP .. "/decorations/grass.lua")

dofile(MP .. "/biomes/grass.lua")
dofile(MP .. "/biomes/ice.lua")
dofile(MP .. "/biomes/desert.lua")

dofile(MP .. "/memoize.lua")
