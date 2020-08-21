-- TESTING ONLY

local function check_placement(foreign_connections, schema_directions)
  local matches = 0

  for _, foreign_connection in ipairs(foreign_connections) do
    -- every foreign connection
    for _, schema_direction in ipairs(schema_directions) do
      -- every local direction
      if vector.equals(foreign_connection, schema_direction) then
        -- match
        matches = matches + 1
      end
    end
  end

  return matches == #foreign_connections
end

local function rotate_schema_directions(schema_directions, angle)
  if angle == 0 then
    return schema_directions
  end

  local transformed_directions = {}

  for _, direction in ipairs(schema_directions) do
    if angle == 180 then
      -- invert sign
      table.insert(transformed_directions, {
        x = direction.x * -1,
        y = direction.y,
        z = direction.z * -1
      })
    elseif angle == 90 then
      if direction.x == 1 then
        table.insert(transformed_directions, {x=0, y=direction.y, z=-1})
      elseif direction.z == 1 then
        table.insert(transformed_directions, {x=1, y=direction.y, z=0})
      elseif direction.z == -1 then
        table.insert(transformed_directions, {x=-1, y=direction.y, z=0})
      elseif direction.x == -1 then
        table.insert(transformed_directions, {x=0, y=direction.y, z=1})
      end

    elseif angle == 270 then
      if direction.x == 1 then
        table.insert(transformed_directions, {x=0, y=direction.y, z=1})
      elseif direction.z == 1 then
        table.insert(transformed_directions, {x=-1, y=direction.y, z=0})
      elseif direction.z == -1 then
        table.insert(transformed_directions, {x=1, y=direction.y, z=0})
      elseif direction.x == -1 then
        table.insert(transformed_directions, {x=0, y=direction.y, z=-1})
      end

    else
      error("unknown angle: " .. angle)
    end
  end

  return transformed_directions
end

local check_connections = {
  -- flat plane cross
  { x=1, y=0, z=0 },
  { x=-1, y=0, z=0 },
  { x=0, y=0, z=1 },
  { x=0, y=0, z=-1 },
  -- upper cross
  { x=1, y=1, z=0 },
  { x=-1, y=1, z=0 },
  { x=0, y=1, z=1 },
  { x=0, y=1, z=-1 },
}

minetest.register_chatcommand("place_test", {
	func = function(name, building_key)
    if not building_key or building_key == "" then
      building_key = "eco_streets:dirt_road"
    end

    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    local mapblock = eco_util.get_mapblock(pos)

    local building_def = eco_api.get_building(building_key)
    if not building_def then
      return false, "no definition found!"
    end

    local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)

    if building_def.placement_type == "connected_street" and building_def.connects_to then
      -- TODO

      -- rearrange data
      local connects_to = {}
      for _, key in ipairs(building_def.connects_to) do
        connects_to[key] = true
      end

      -- gather foreign connections
      -- { {x=1, y=0, z=0}, {} }
      local foreign_connections = {}
      for _, offset in ipairs(check_connections) do
        local offset_mapblock = vector.add(mapblock, offset)
        local grid_info = eco_grid.get_mapblock(offset_mapblock)

        if grid_info and connects_to[grid_info.build_key] then
          table.insert(foreign_connections, offset)
        end
      end

      for _, schema_variant in ipairs(building_def.schemas_) do
        -- every schema variant
        print(dump(schema_variant), dump(min))
        for _, angle in ipairs({0, 90, 180, 270}) do
          -- every angle
          local rotated_directions = rotate_schema_directions(schema_variant.directions, angle)
          local match = check_placement(foreign_connections, rotated_directions)
          print(match, angle, dump(rotated_directions), dump(foreign_connections))

          if match then
            return true, "ok: " .. angle .. " " .. schema_variant.schema
          end
        end
      end
    end

    return false, "no suitable placement found!"
  end
})
