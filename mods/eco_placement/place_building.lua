
function eco_placement.place_building(mapblock, build_key)
  local current_data = eco_grid.get_mapblock(mapblock)

  if not build_key or build_key == "" then
    -- assign current build_key
    build_key = current_data.build_key
  end

  if not build_key or build_key == "" then
    return
  end

  local building_def = eco_api.get_building(build_key)
  assert(building_def)

  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)

  -- randomize schemas if multiple available
  local schema_entry = building_def.schemas[math.random(#building_def.schemas)]

  local options = {
    transform = {}
  }

  if not schema_entry.disable_rotation then
    -- rotate randomly
    local rotations = {0, 90, 180, 270}
    options.transform.rotate = {
      axis = "y",
      angle = rotations[math.random(#rotations)]
    }
  end

  if schema_entry.replacements then
    options.transform.replace = schema_entry.replacements[math.random(#schema_entry.replacements)]
  end

  eco_serialize.deserialize(min, schema_entry.directory, options)

  eco_grid.set_mapblock(mapblock, {
    type = "building",
    build_key = building_def.key
  })

  local size_x = 1
  local size_z = 1

  if building_def.size then
    size_x = building_def.size.x
    size_z = building_def.size.z
  end

  for x=1,size_x do
    for z=1,size_z do
      if x>1 or z>1 then
        -- create links to original mapblock
        local ext_pos = { x=mapblock.x, y=mapblock.y, z=mapblock.z }
        ext_pos.x = ext_pos.x + (x - 1)
        ext_pos.z = ext_pos.z + (z - 1)

        eco_grid.set_mapblock(ext_pos, {
          type = "link",
          ref = mapblock
        })
      end
    end
  end
end
