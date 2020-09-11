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

function eco_placement.place_connected_street(place_def)
  return function(building_def, mapblock, playername)
    print(playername .. " places connected street '" .. building_def.name .. "' to " ..
      minetest.pos_to_string(mapblock) ..
      " Schema: " .. dump(place_def))

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

 for _, schema_variant in ipairs(place_def) do
   -- every schema variant
   for _, angle in ipairs({0, 90, 180, 270}) do
     -- every angle
     local rotated_directions = rotate_schema_directions(schema_variant.directions, angle)
     local match = check_placement(foreign_connections, rotated_directions)
     print(match, angle, dump(rotated_directions), dump(foreign_connections))

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

       -- TODO: set grid data

     end
   end
 end
  end
end
