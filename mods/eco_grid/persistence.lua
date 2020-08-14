minetest.mkdir(minetest.get_worldpath() .. "/eco")
local filename = minetest.get_worldpath() .. "/eco/grid.lua"

function eco_grid.save()
  local file = io.open(filename,"w")
  local data = minetest.serialize(eco_grid.grid)
  if file and file:write(data) and file:close() then
    return
  else
    error("write to '" .. filename .. "' failed!")
  end

end

function eco_grid.load()
  local file = io.open(filename,"r")
  if file then
    local data = file:read("*a")
    eco_grid.grid = minetest.deserialize(data) or {}
  end
end
