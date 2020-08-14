minetest.mkdir(minetest.get_worldpath() .. "/eco")
local filename = minetest.get_worldpath() .. "/eco/grid.json"

function eco_grid.save()
  local file = io.open(filename,"w")
  local json = minetest.write_json(eco_grid.grid)
  if file and file:write(json) and file:close() then
    return
  else
    error("write to '" .. filename .. "' failed!")
  end

end

function eco_grid.load()
  local file = io.open(filename,"r")
  if file then
    local json = file:read("*a")
    eco_grid.grid = minetest.parse_json(json) or {}
  end
end

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
