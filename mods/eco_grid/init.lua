local MP = minetest.get_modpath("eco_grid")

eco_grid = {
  grid = {},
  modified = false
}

dofile(MP .. "/api.lua")
dofile(MP .. "/persistence.lua")
