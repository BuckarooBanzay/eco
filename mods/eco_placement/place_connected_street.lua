

local street_neighbor_updates = {
  { x=1, y=0, z=0 },
  { x=0, y=0, z=1 },
  { x=0, y=0, z=-1 },
  { x=-1, y=0, z=0 },

  { x=1, y=1, z=0 },
  { x=0, y=1, z=1 },
  { x=0, y=1, z=-1 },
  { x=-1, y=1, z=0 },

  { x=1, y=-1, z=0 },
  { x=0, y=-1, z=1 },
  { x=0, y=-1, z=-1 },
  { x=-1, y=-1, z=0 },
}

local propagate = true

local function is_connected(mapblock)
  local grid_info = eco_grid.get_mapblock(mapblock)
  return grid_info and grid_info.type == "street"
end

local function place_street(place_def, building_def, mapblock)
  local info = eco_mapgen.get_info(mapblock)
  if info.type == "slope" then
    -- place slope
    assert(place_def.schematics.slope)

    local options = {
      transform = {
        rotate = {
          axis = "y",
          angle = 0
        }
      }
    }

    -- rotate (z+ is default)
    if info.direction == "x+" then
      options.transform.rotate.angle = 90
    elseif info.direction == "z-" then
      options.transform.rotate.angle = 180
    elseif info.direction == "x-" then
      options.transform.rotate.angle = 270
    end

    local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
    eco_serialize.deserialize(min, place_def.schematics.slope, options)

    -- set grid data
    eco_grid.set_mapblock(mapblock, {
      type = "street",
      build_key = building_def.key
    })
    eco_grid.set_mapblock(vector.add(mapblock, {x=0, y=1, z=0}), {
      type = "street_slope_top",
      build_key = building_def.key
    })

  elseif info.type == "flat" then
    -- place flat

    -- check connections on flat surface and one layer below
    local xplus = is_connected(vector.add(mapblock, {x=1, y=0, z=0})) or
      is_connected(vector.add(mapblock, {x=1, y=-1, z=0}))
    local xminus = is_connected(vector.add(mapblock, {x=-1, y=0, z=0})) or
      is_connected(vector.add(mapblock, {x=-1, y=-1, z=0}))
    local zplus = is_connected(vector.add(mapblock, {x=0, y=0, z=1})) or
      is_connected(vector.add(mapblock, {x=0, y=-1, z=1}))
    local zminus = is_connected(vector.add(mapblock, {x=0, y=0, z=-1})) or
      is_connected(vector.add(mapblock, {x=0, y=-1, z=-1}))

    local schematic = place_def.schematics.straight
    local options = {
      transform = {
        rotate = {
          axis = "y",
          angle = 0,
          disable_orientation = place_def.disable_orientation
        }
      }
    }

    if xplus and xminus and zplus and zminus then
      -- all sides
      schematic = place_def.schematics.all_sides

    elseif not xplus and xminus and zplus and zminus then
      -- three sides 90°
      schematic = place_def.schematics.three_sides
      options.transform.rotate.angle = 90

    elseif xplus and not xminus and zplus and zminus then
      -- three sides 270°
      schematic = place_def.schematics.three_sides
      options.transform.rotate.angle = 270

    elseif xplus and xminus and not zplus and zminus then
      -- three sides 0°
      schematic = place_def.schematics.three_sides
      options.transform.rotate.angle = 0

    elseif xplus and xminus and zplus and not zminus then
      -- three sides 180°
      schematic = place_def.schematics.three_sides
      options.transform.rotate.angle = 180

    elseif xplus and not xminus and zplus and not zminus then
      -- corner 0°
      schematic = place_def.schematics.corner
      options.transform.rotate.angle = 0

    elseif not xplus and xminus and zplus and not zminus then
      -- corner 270°
      schematic = place_def.schematics.corner
      options.transform.rotate.angle = 270

    elseif xplus and not xminus and not zplus and zminus then
      -- corner 90°
      schematic = place_def.schematics.corner
      options.transform.rotate.angle = 90

    elseif not xplus and xminus and not zplus and zminus then
      -- corner 180°
      schematic = place_def.schematics.corner
      options.transform.rotate.angle = 180

    elseif xplus or xminus then
      -- straight 0°
      schematic = place_def.schematics.straight
      options.transform.rotate.angle = 0

    elseif zplus or zminus then
      -- straight 90°
      schematic = place_def.schematics.straight
      options.transform.rotate.angle = 90

    end

    local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
    eco_serialize.deserialize(min, schematic, options)

    -- set grid data
    eco_grid.set_mapblock(mapblock, {
      type = "street",
      build_key = building_def.key
    })

  end

  if propagate then
    -- update neighbors

    -- disable propagation (prevent infinite recursion)
    propagate = false

    -- iterate through possible connections
    for _, offset in ipairs(street_neighbor_updates) do
      local neighbor_mapblock = vector.add(mapblock, offset)
      local neighbor_grid_info = eco_grid.get_mapblock(neighbor_mapblock)

      if neighbor_grid_info and neighbor_grid_info.type == "street" then
        -- call "on_place" function of neighbor
        local neighbor_building_def = eco_api.get_building(neighbor_grid_info.build_key)

        if type(neighbor_building_def.on_place) == "function" then
          neighbor_building_def.on_place(neighbor_building_def, neighbor_mapblock)
        end
      end
    end

    -- re-enable propagation
    propagate = true

  end
end

function eco_placement.place_connected_street(place_def)
  return function(building_def, mapblock)
    return place_street(place_def, building_def, mapblock, true)
  end
end
