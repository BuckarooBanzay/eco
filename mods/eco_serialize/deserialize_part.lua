local air_content_id = minetest.get_content_id("air")

function eco_serialize.deserialize_part(pos1, data, metadata, replace)
  local pos2 = vector.add(pos1, 15)

  local manip = minetest.get_voxel_manip()
  local e1, e2 = manip:read_from_map(pos1, pos2)
  local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})

  local node_data = manip:get_data()
  local param1 = manip:get_light_data()
  local param2 = manip:get_param2_data()

  local j = 1
  for z=pos1.z,pos2.z do
  for y=pos1.y,pos2.y do
  for x=pos1.x,pos2.x do
    local i = area:index(x,y,z)
    if replace or node_data[i] == air_content_id then
      node_data[i] = data.node_ids[j]
      param1[i] = data.param1[j]
      param2[i] = data.param2[j]
    end
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
