
-- write the manifest to given path
local function write_manifest(manifest, filename)
  local file = io.open(filename,"w")
  local json = minetest.write_json(manifest)
  if file and file:write(json) and file:close() then
    return
  else
    error("write to '" .. filename .. "' failed!")
  end
end


-- create a manifest with given coordinates
local function create_manifest(min, max)
  local total_parts =
    math.ceil(math.abs(min.x - max.x) / 16) *
    math.ceil(math.abs(min.y - max.y) / 16) *
    math.ceil(math.abs(min.z - max.z) / 16)

  return {
    version = 2,
    total_parts = total_parts,
    node_mapping = {},
    max_x = max.x - min.x,
    max_y = max.y - min.y,
    max_z = max.z - min.z
  }
end

local function int_to_bytes(i)
	local x =i + 32768
	local h = math.floor(x/256) % 256;
	local l = math.floor(x % 256);
	return(string.char(h, l));
end

local function write_mapblock(node_ids, param1, param2, filename)
  local file = io.open(filename,"wb")
  local data = ""
  for i=1,4096 do
    data = data .. int_to_bytes(node_ids[i])
  end
  for i=1,4096 do
    data = data .. string.char(param1[i])
  end
  for i=1,4096 do
    data = data .. string.char(param2[i])
  end

  file:write(minetest.compress(data, "deflate"))

  if file and file:close() then
    return
  else
    error("write to '" .. filename .. "' failed!")
  end
end

local function write_metadata(metadata, filename)
  local file = io.open(filename,"w")
  local json = minetest.write_json(metadata)
  if file and file:write(json) and file:close() then
    return
  else
    error("write to '" .. filename .. "' failed!")
  end
end

-- worker function, called iteratively
local function worker(ctx)
  if not ctx.pos then
    -- done, write manifest
    write_manifest(ctx.manifest, ctx.schema_dir .. "/manifest.json")
    minetest.log("action", "[eco_serialize] done writing schema to " .. ctx.schema_dir)
    return
  end

  minetest.log("action", "[eco_serialize] serializing mapblock at position " .. minetest.pos_to_string(ctx.pos))

  local data = eco_serialize.serialize_part(ctx.pos, ctx.manifest.node_mapping)

  write_mapblock(
    data.node_ids,
    data.param1,
    data.param2,
    ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".bin"
  )

  if data.metadata then
    write_metadata(
      data.metadata,
      ctx.schema_dir .. "/mapblock_" .. ctx.mapblock_index .. ".metadata.json"
    )
  end

  -- shift context
  ctx.mapblock_index = ctx.mapblock_index + 1
  ctx.pos = eco_serialize.iterator_next(ctx.min, ctx.max, ctx.pos)

  minetest.after(0.5, worker, ctx)
end

-- serializes the mapblocks between the positions and writes them to the schema_dir with
-- a manifest
function eco_serialize.serialize(pos1, pos2, schema_dir)
  minetest.mkdir(schema_dir)
  pos1, pos2 = eco_serialize.sort_pos(pos1, pos2)

  local min = eco_util.get_mapblock_bounds(pos1)
  local _, max = eco_util.get_mapblock_bounds(pos2)

  local manifest = create_manifest(min, max)

  local ctx = {
    manifest = manifest,
    schema_dir = schema_dir,
    min = min,
    max = max,
    mapblock_index = 1,
    pos = table.copy(min)
  }

  minetest.after(0, worker, ctx)
end
