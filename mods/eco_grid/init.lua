local MP = minetest.get_modpath("eco_grid")

eco_grid = {
  grid = {},
  modified = false
}

dofile(MP .. "/api.lua")
dofile(MP .. "/persistence.lua")

eco_grid.load()

local function save_worker()
  if eco_grid.modified then
    eco_grid.save()
    eco_grid.modified = false
  end
  minetest.after(10, save_worker)
end

minetest.register_on_shutdown(save_worker)
minetest.after(10, save_worker)
