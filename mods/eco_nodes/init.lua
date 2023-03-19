local MP = minetest.get_modpath(minetest.get_current_modname())

-- namespace
eco_nodes = {}
dofile(MP .. "/api.lua")

-- tools(s)
dofile(MP .. "/tools.lua")

-- sounds
dofile(MP .. "/sounds.lua")

-- nodes, items, etc
dofile(MP .. "/nodes.lua")
dofile(MP .. "/glass.lua")
dofile(MP .. "/natural_nodes.lua")
dofile(MP .. "/bakedclay.lua")
dofile(MP .. "/trees.lua")
dofile(MP .. "/stones.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/plants.lua")
