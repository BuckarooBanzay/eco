
local mapblock_cache = {}
local metadata_cache = {}
local manifest_cache = {}

local function read_json_file(filename)
  local file = io.open(filename,"r")
  if file then
    local json = file:read("*a")
    return minetest.parse_json(json)
  else
    return nil
  end
end

local function read_compressed_binary(filename)
  local file = io.open(filename,"rb")
  local data = file:read("*all")
  data = minetest.decompress(data, "deflate")
  local mapblock = {
    node_ids = {},
    param1 = {},
    param2 = {}
  }

  for i=1,4096 do
    -- 1, 3, 5 ... 8191
    local node_id_offset = (i * 2) - 1
    local node_id = (string.byte(data, node_id_offset) * 256) +
      string.byte(data, node_id_offset+1) - 32768

    local param1 = string.byte(data, (4096 * 2) + i)
    local param2 = string.byte(data, (4096 * 3) + i)

    table.insert(mapblock.node_ids, node_id)
    table.insert(mapblock.param1, param1)
    table.insert(mapblock.param2, param2)
  end
  return mapblock
end


local function worker(ctx)
  if not ctx.pos then
    -- done
    minetest.log("verbose", "[eco_serialize] done reading schema from " .. ctx.schema_dir)
    return
  end

  minetest.log("verbose", "[eco_serialize] deserializing mapblock at position " .. minetest.pos_to_string(ctx.pos))

  local mapblock
  local cache_key = ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index

  if ctx.options.transform and ctx.options.transform.rotate then
    -- add rotation info to cache key if specified
    cache_key = cache_key .. "/" .. ctx.options.transform.rotate.axis .. "/" .. ctx.options.transform.rotate.angle
  end

  -- true if the mapblock and metadata are read from cache
  -- they are already transformed
  local is_cached = false

  if ctx.options.use_cache and mapblock_cache[cache_key] then
    -- reuse from cache
    mapblock = mapblock_cache[cache_key]
    is_cached = true

  else
    -- read compressed binary mapblock
    mapblock = read_compressed_binary(
      ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".bin"
    )

  end

  if ctx.options.use_cache and not mapblock_cache[cache_key] then
    -- populate cache
    mapblock_cache[cache_key] = mapblock
  end

  -- cache metadata access
  local metadata
  if ctx.options.use_cache and metadata_cache[cache_key] ~= nil then
    metadata = metadata_cache[cache_key]
  else
    metadata = read_json_file(
      ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".metadata.json",
      ctx.options.use_cache
    )
    metadata_cache[cache_key] = metadata or false
  end

  if ctx.options.transform and not is_cached then
    -- apply transformation only on uncached data
    eco_serialize.transform(ctx.options.transform, mapblock, metadata)
  end

  eco_serialize.deserialize_part(ctx.pos, ctx.manifest.node_mapping, mapblock, metadata)

  -- shift context
  ctx.mapblock_index = ctx.mapblock_index + 1
  ctx.pos = eco_serialize.iterator_next(ctx.min, ctx.max, ctx.pos)

  if ctx.options.sync then
    -- sync call
    worker(ctx)
  else
    -- queue after a delay
    minetest.after(0.5, worker, ctx)
  end
end

--[[
options = {
  use_cache = false,
  transform = {}
}

--]]
function eco_serialize.deserialize(pos, schema_dir, options)
  options = options or {}

  local manifest_file = schema_dir .. "/manifest.json"
  local manifest

  -- cached manifest access
  if options.use_cache and manifest_cache[manifest_file] then
    manifest = manifest_cache[manifest_file]
  else
    manifest = read_json_file(manifest_file)
    manifest_cache[manifest_file] = manifest
  end

  local min = eco_util.get_mapblock_bounds(pos)

  local ctx = {
    manifest = manifest,
    schema_dir = schema_dir,
    min = min,
    max = {
      x = min.x + manifest.max_x,
      y = min.y + manifest.max_y,
      z = min.z + manifest.max_z
    },
    mapblock_index = 1,
    pos = table.copy(min),
    options = options
  }
  if manifest.total_parts == 1 or options.sync then
    -- skip async work queue
    worker(ctx)
  else
    -- schedule async work
    minetest.after(0, worker, ctx)
  end
end
