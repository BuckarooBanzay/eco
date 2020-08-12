local air_content_id = minetest.get_content_id("air")

-- local nodename->id cache
local local_nodename_to_id_mapping = {} -- name -> id

function eco_serialize.deserialize_part(pos1, node_mapping, data, metadata)
  local foreign_nodeid_to_name_mapping = {} -- id -> name
  if not data.node_ids_localized then
    for k, v in pairs(node_mapping) do
      foreign_nodeid_to_name_mapping[v] = k
    end
  end

  local pos2 = vector.add(pos1, 15)

  local manip = minetest.get_voxel_manip()
  local e1, e2 = manip:read_from_map(pos1, pos2)
  local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})

  if not data.node_ids_localized then
    for i, node_id in ipairs(data.node_ids) do
      local node_name = foreign_nodeid_to_name_mapping[node_id]
      local local_node_id = local_nodename_to_id_mapping[node_name]
      if not local_node_id then
        if minetest.registered_nodes[node_name] then
          -- node is locally available
          local_node_id = minetest.get_content_id(node_name)
        else
          -- node is not available here
          -- TODO: make replacements configurable
          local_node_id = air_content_id
        end
        local_nodename_to_id_mapping[node_name] = local_node_id

      end

      data.node_ids[i] = local_node_id
    end

    -- set marker for cached call afterwards
    data.node_ids_localized = true
  end

  local node_data = manip:get_data()
  local param1 = manip:get_light_data()
  local param2 = manip:get_param2_data()

  local j = 1
  for z=pos1.z,pos2.z do
  for y=pos1.y,pos2.y do
  for x=pos1.x,pos2.x do
    local i = area:index(x,y,z)
    node_data[i] = data.node_ids[j]
    param1[i] = data.param1[j]
    param2[i] = data.param2[j]
    j = j + 1
  end
  end
  end

  manip:set_data(node_data)
  manip:set_light_data(param1)
  manip:set_param2_data(param2)
  manip:write_to_map()

  -- deserialize metadata
  if metadata and metadata.meta then
    for pos_str, md in pairs(metadata.meta) do
      local relative_pos = minetest.string_to_pos(pos_str)
      local absolute_pos = vector.add(pos1, relative_pos)
      minetest.get_meta(absolute_pos):from_table(md)
    end
  end


end
