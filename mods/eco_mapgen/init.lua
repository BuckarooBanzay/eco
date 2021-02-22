eco_mapgen = {}

local MP = minetest.get_modpath("eco_mapgen")

dofile(MP .. "/height.lua")
dofile(MP .. "/info.lua")
dofile(MP .. "/mapgen.lua")
dofile(MP .. "/decorations.lua")
dofile(MP .. "/render_mapblock.lua")
dofile(MP .. "/count_resources.lua")

dofile(MP .. "/biome.lua")
dofile(MP .. "/biome_grass.lua")
dofile(MP .. "/biome_underground.lua")
dofile(MP .. "/biome_water.lua")
dofile(MP .. "/biome_snow.lua")

dofile(MP .. "/decoration_grass.lua")
