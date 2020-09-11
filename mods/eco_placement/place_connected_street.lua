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
  -- lower cross
  { x=1, y=-1, z=0 },
  { x=-1, y=-1, z=0 },
  { x=0, y=-1, z=1 },
  { x=0, y=-1, z=-1 }
}

-- propagation flag for recursive updates
local propagate = true

local function place_or_update_street(place_def, building_def, mapblock)
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

   -- true if a match got already placed
   local match_placed = false

   for _, schema_variant in ipairs(place_def) do
     -- every schema variant
     for _, angle in ipairs({0, 90, 180, 270}) do
       -- every angle
       local rotated_directions = rotate_schema_directions(schema_variant.directions, angle)
       local match = check_placement(foreign_connections, rotated_directions)

       if match then
         -- set inworld blocks
         local min = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
         eco_serialize.deserialize(min, schema_variant.schema, {
           transform = {
             rotate = {
               axis = "y",
               angle = angle
             }
           }
         })
         match_placed = true

         -- set grid data
         eco_grid.set_mapblock(mapblock, {
           type = "building",
           build_key = building_def.key
         })

         if schema_variant.slope then
           -- set upper half of the slope data
           eco_grid.set_mapblock(vector.add(mapblock, {x=0, y=1, z=0}), {
             type = "slope_top_half",
             build_key = building_def.key
           })
         end

         if propagate then
           -- disable propagation while updating neighbors
           propagate = false
           -- update surrounding streets
           for _, offset in ipairs(foreign_connections) do
             local foreign_mapblock = vector.add(mapblock, offset)
             local foreign_data = eco_grid.get_mapblock(foreign_mapblock)
             if foreign_data.type ~= "slope_top_half" then
               local foreign_building_def = eco_api.get_building(foreign_data.build_key)
               print("calling on_place", dump(foreign_mapblock), dump(foreign_data))
               foreign_building_def.on_place(foreign_building_def, foreign_mapblock)
             end
           end

           -- re-enable propagation
           propagate = true
         end

         break
       end -- match
     end -- angle

     if match_placed then
       break
     end

   end -- schema_variant
end

function eco_placement.place_connected_street(place_def)
  return function(building_def, mapblock)
    return place_or_update_street(place_def, building_def, mapblock)
  end
end
