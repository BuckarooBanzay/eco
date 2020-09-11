function eco_placement.place_simple(place_def)
  return function(building_def, mapblock, playername)
    print(playername .. " places '" .. building_def.name .. "' to " .. minetest.pos_to_string(mapblock) ..
      " Schema: " .. dump(place_def))


    local schema_entry = place_def
    if #place_def > 0 then
      -- select one if multiple specified
      schema_entry = place_def[math.random(#place_def)]
    end

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
      if #schema_entry.replacements > 0 then
        -- multiple, choose one randomly
        options.transform.replace = schema_entry.replacements[math.random(#schema_entry.replacements)]
      else
        -- only one, use that
        options.transform.replace = schema_entry.replacements
      end
    end

    local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
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
end
