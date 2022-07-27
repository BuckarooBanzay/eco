local MP = minetest.get_modpath(minetest.get_current_modname())

-- namespace
eco_nodes = {}
dofile(MP .. "/api.lua")

-- sounds
dofile(MP .. "/sounds.lua")

-- nodes, items, etc
dofile(MP .. "/nodes.lua")
dofile(MP .. "/trees.lua")
dofile(MP .. "/stones.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/plants.lua")
dofile(MP .. "/torch.lua")
