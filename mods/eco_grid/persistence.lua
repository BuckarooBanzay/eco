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
