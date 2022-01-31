local MP = minetest.get_modpath(minetest.get_current_modname())

-- namespace
eco_nodes = {}

-- sounds
dofile(MP .. "/sounds.lua")

-- nodes, items, etc
dofile(MP .. "/nodes.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/plants.lua")
dofile(MP .. "/torch.lua")
