
local grid = {}

function eco_grid.set(pos, data)
  local mapblock = eco_util.get_mapblock(pos)
  local hash = minetest.hash_node_position(mapblock)
  grid[hash] = data
end

function eco_grid.get(pos)
  local mapblock = eco_util.get_mapblock(pos)
  local hash = minetest.hash_node_position(mapblock)
  return grid[hash]
end
