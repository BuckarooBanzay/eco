
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
end
