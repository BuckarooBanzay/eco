local function transpose(data, indexFn, axis1, axis2)
  -- https://github.com/Uberi/Minetest-WorldEdit/blob/master/worldedit/manipulations.lua#L422
  local max = { x=15, y=15, z=15 }
  local pos = {x=0, y=0, z=0}

  while pos.x <= max.x do
    pos.y = 0
    while pos.y <= max.y do
      pos.z = 0
      while pos.z <= max.z do
        local extent1, extent2 = pos[axis1], pos[axis2]
        if extent1 < extent2 then -- Transpose only if below the diagonal
          local node_id_1 = data[indexFn(pos)]
          local value1, value2 = pos[axis1], pos[axis2] -- Save position values

          pos[axis1], pos[axis2] = extent2, extent1 -- Swap axis extents
          local node_id_2 = data[indexFn(pos)]
          data[indexFn(pos)] = node_id_1

          pos[axis1], pos[axis2] = value1, value2 -- Restore position values
          data[indexFn(pos)] = node_id_2
        end
        pos.z = pos.z + 1
      end
      pos.y = pos.y + 1
    end
    pos.x = pos.x + 1
  end
end

function eco_serialize.transform(options, mapblock, metadata)

  local axis1 = "x"
  local axis2 = "z"

  local min = { x=0, y=0, z=0 }
  local max = { x=15, y=15, z=15 }
  local area = VoxelArea:new({MinEdge=min, MaxEdge=max})

  if options.transpose then
    local vmanipIndex = function(pos) return area:indexp(pos) end
    transpose(mapblock.node_ids, vmanipIndex, axis1, axis2)
    transpose(mapblock.param1, vmanipIndex, axis1, axis2)
    transpose(mapblock.param2, vmanipIndex, axis1, axis2)

    if metadata and metadata.meta then
      local metaIndex = function(pos) return minetest.pos_to_string(pos) end
      transpose(metadata.meta, metaIndex, axis1, axis2)
    end
  end
end
