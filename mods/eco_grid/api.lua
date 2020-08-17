local function getkey(mapblock)
  return mapblock.x .. "/" .. mapblock.y .. "/" .. mapblock.z
end

local meta_key = "_eco_grid"

local function save_to_world(mapblock, data)
  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
  local meta = minetest.get_meta(min)
  if data ~= nil then
    -- save data
    meta:set_string(meta_key, minetest.serialize(data))
  else
    -- clear data
    meta:set_string(meta_key, "")
  end
end

local function load_from_world(mapblock)
  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
  local meta = minetest.get_meta(min)
  local str = meta:get_string(meta_key)
  if str and str ~= "" then
    -- deserialize data
    return minetest.deserialize(str)
  else
    -- no data available
    return nil
  end
end

function eco_grid.set_mapblock(mapblock, data)
  local key = getkey(mapblock)
  eco_grid.grid[key] = data
  save_to_world(mapblock, data)
end

function eco_grid.set(pos, data)
  local mapblock = eco_util.get_mapblock(pos)
  eco_grid.set_mapblock(mapblock, data)
end

function eco_grid.get_mapblock(mapblock)
  local key = getkey(mapblock)
  local data = eco_grid.grid[key]
  if data ~= nil then
    -- use cached data (false if no data available)
    return data
  else
    -- cache for future use
    data = load_from_world(mapblock)
    eco_grid.grid[key] = data or false
    return data
  end
end

function eco_grid.get(pos)
  local mapblock = eco_util.get_mapblock(pos)
  return eco_grid.get_mapblock(mapblock)
end
