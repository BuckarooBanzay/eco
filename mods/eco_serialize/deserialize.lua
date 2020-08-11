
local cache = {}

local function read_json_file(filename, use_cache)
  if use_cache and cache[filename] then
    return cache[filename]
  end

  local file = io.open(filename,"r")

  if file then
    local json = file:read("*a")
    local result = minetest.parse_json(json)
    if use_cache then
      cache[filename] = result
    end
    return result
  else
    return nil
  end
end


local function worker(ctx)
  if not ctx.pos then
    -- done
    minetest.log("verbose", "[eco_serialize] done reading schema from " .. ctx.schema_dir)
    return
  end

  minetest.log("verbose", "[eco_serialize] deserializing mapblock at position " .. minetest.pos_to_string(ctx.pos))

  local mapblock = read_json_file(
    ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".json",
    ctx.use_cache
  )

  local metadata = read_json_file(
    ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".metadata.json",
    ctx.use_cache
  )

  eco_serialize.deserialize_part(ctx.pos, ctx.manifest.node_mapping, mapblock, metadata)

  -- shift context
  ctx.mapblock_index = ctx.mapblock_index + 1
  ctx.pos = eco_serialize.iterator_next(ctx.min, ctx.max, ctx.pos)

  minetest.after(0.5, worker, ctx)
end


function eco_serialize.deserialize(pos, schema_dir, use_cache)
  local manifest = read_json_file(schema_dir .. "/manifest.json", use_cache)
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
    use_cache = use_cache
  }
  if manifest.total_parts == 1 then
    -- skip async work queue
    worker(ctx)
  else
    -- schedule async work
    minetest.after(0, worker, ctx)
  end
end
