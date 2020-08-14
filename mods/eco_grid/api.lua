local function getkey(mapblock)
  return mapblock.x .. "/" .. mapblock.y .. "/" .. mapblock.z
end

function eco_grid.set_mapblock(mapblock, data)
  local key = getkey(mapblock)
  eco_grid.modified = true
  eco_grid.grid[key] = data
end

function eco_grid.set(pos, data)
  local mapblock = eco_util.get_mapblock(pos)
  eco_grid.set_mapblock(mapblock, data)
end

function eco_grid.get_mapblock(mapblock)
  local key = getkey(mapblock)
  return eco_grid.grid[key]
end

function eco_grid.get(pos)
  local mapblock = eco_util.get_mapblock(pos)
  return eco_grid.get_mapblock(mapblock)
end
