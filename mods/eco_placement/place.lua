
local function place_flat_street(mapblock, street_def, _, connections)

  local xplus = connections.xplus
  local xminus = connections.xminus
  local zplus = connections.zplus
  local zminus = connections.zminus

  local schema_dir = street_def.schemas.straight
  local rotate

  if xplus and xminus and zplus and zminus then
    -- all sides connected
    schema_dir = street_def.schemas.all_sides

  elseif xplus and xminus and zplus and not zminus then
    schema_dir = street_def.schemas.three_sides
    rotate = 180

  elseif xplus and xminus and not zplus and zminus then
    schema_dir = street_def.schemas.three_sides
    rotate = 0

  elseif xplus and not xminus and zplus and zminus then
    schema_dir = street_def.schemas.three_sides
    rotate = 270

  elseif not xplus and xminus and zplus and zminus then
    schema_dir = street_def.schemas.three_sides
    rotate = 90

  elseif (xplus or xminus) and not zplus and not zminus then
    schema_dir = street_def.schemas.straight
    rotate = 0

  elseif not xplus and not xminus and (zplus or zminus) then
    schema_dir = street_def.schemas.straight
    rotate = 90

  elseif not xplus and xminus and zplus and not zminus then
    schema_dir = street_def.schemas.corner
    rotate = 270

  elseif not xplus and xminus and not zplus and zminus then
    schema_dir = street_def.schemas.corner
    rotate = 180

  elseif xplus and not xminus and not zplus and zminus then
    schema_dir = street_def.schemas.corner
    rotate = 90

  elseif xplus and not xminus and zplus and not zminus then
    schema_dir = street_def.schemas.corner
    rotate = 0

  end

  local options = {}
  if rotate and rotate > 0 then
    options.transform = {
      rotate = {
        axis = "y",
        angle = rotate,
        -- disable_orientation = true
      }
    }
  end

  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
  eco_serialize.deserialize(min, schema_dir, options)

  eco_grid.set_mapblock(mapblock, {
    type = "street",
    build_key = street_def.key,
    connections = connections
  })

end

local function place_slope_street(mapblock, street_def, info, connections)
  local rotate = nil
  if info.direction == "z-" then
    rotate = { axis = "y", angle = 180 }
  elseif info.direction == "x+" then
    rotate = { axis = "y", angle = 90 }
  elseif info.direction == "x-" then
    rotate = { axis = "y", angle = 270 }
  end

  local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
  eco_serialize.deserialize(min, street_def.schemas.slope, {
    use_cache = true,
    sync = true,
    transform = {
      rotate = rotate
    }
  })

  eco_grid.set_mapblock(mapblock, {
    type = "street",
    build_key = street_def.key,
    connections = connections
  })
  eco_grid.set_mapblock({ x=mapblock.x, y=mapblock.y+1, z=mapblock.z}, {
    type = "street",
    upper_slope = true,
    connections = connections
  })
end

function eco_placement.place_street(mapblock, build_key, check_neighbors)

  -- gather surrounding grid data
  local xplus_data = eco_grid.get_mapblock({ x=mapblock.x+1, y=mapblock.y, z=mapblock.z })
  local xminus_data = eco_grid.get_mapblock({ x=mapblock.x-1, y=mapblock.y, z=mapblock.z })
  local zplus_data = eco_grid.get_mapblock({ x=mapblock.x, y=mapblock.y, z=mapblock.z+1 })
  local zminus_data = eco_grid.get_mapblock({ x=mapblock.x, y=mapblock.y, z=mapblock.z-1 })
  local current_data = eco_grid.get_mapblock(mapblock)

  if not build_key or build_key == "" then
    -- assign current build_key
    build_key = current_data.build_key
  end

  if not build_key or build_key == "" then
    return
  end

  local street_def = eco_api.get_street(build_key)
  assert(street_def)

  local xplus = xplus_data and xplus_data.type == "street"
  local xminus = xminus_data and xminus_data.type == "street"
  local zplus = zplus_data and zplus_data.type == "street"
  local zminus = zminus_data and zminus_data.type == "street"

  local connections = {
    xplus = xplus,
    xminus = xminus,
    zplus = zplus,
    zminus = zminus
  }

  local info = eco_mapgen.get_info(mapblock)

  if info.type == "slope" then
    place_slope_street(mapblock, street_def, info, connections)
  elseif info.type == "flat" then
    place_flat_street(mapblock, street_def, info, connections)
  end


  if check_neighbors then
    -- check neighbors
    if xplus and not xplus_data.connections.xminus then
      eco_placement.place_street({ x=mapblock.x+1, y=mapblock.y, z=mapblock.z })
    end
    if xminus and not xminus_data.connections.xplus then
      eco_placement.place_street({ x=mapblock.x-1, y=mapblock.y, z=mapblock.z })
    end
    if zplus and not zplus_data.connections.zminus then
      eco_placement.place_street({ x=mapblock.x, y=mapblock.y, z=mapblock.z+1 })
    end
    if zminus and not zminus_data.connections.zplus then
      eco_placement.place_street({ x=mapblock.x, y=mapblock.y, z=mapblock.z-1 })
    end
  end
end

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
