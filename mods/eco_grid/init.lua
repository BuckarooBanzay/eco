local MP = minetest.get_modpath("eco_grid")

eco_grid = {
  -- in-memory mirror of the in-world metadata
  -- for faster access and lookup
  grid = {}
}

dofile(MP .. "/api.lua")
dofile(MP .. "/influence.lua")
dofile(MP .. "/info.lua")
