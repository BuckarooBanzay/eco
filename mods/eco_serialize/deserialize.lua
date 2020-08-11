
local function read_json_file(filename)
  local file = io.open(filename,"r")

  if file then
    local json = file:read("*a")
    return minetest.parse_json(json)
  else
    return nil
  end
end


local function worker(ctx)
  if not ctx.pos then
    -- done
    minetest.log("action", "[eco_serialize] done reading schema from " .. ctx.schema_dir)
    return
  end

  minetest.log("action", "[eco_serialize] deserializing mapblock at position " .. dump(ctx.pos))

  local mapblock = read_json_file(ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".json")
  local metadata = read_json_file(ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".metadata.json")

  eco_serialize.deserialize_part(ctx.pos, ctx.manifest.node_mapping, mapblock, metadata)

  -- shift context
  ctx.mapblock_index = ctx.mapblock_index + 1
  ctx.pos = eco_serialize.iterator_next(ctx.min, ctx.max, ctx.pos)

  minetest.after(0.5, worker, ctx)
end


function eco_serialize.deserialize(pos, schema_dir)
  local manifest = read_json_file(schema_dir .. "/manifest.json")
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
    pos = min
  }

  minetest.after(0, worker, ctx)
end
