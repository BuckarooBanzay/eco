-- TESTING ONLY


minetest.register_chatcommand("place_test", {
	func = function(name, building_key)
    if not building_key then
      return false, "no building key param"
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
      for x=-1,1 do
        for y=-1,1 do
          for z=-1,1 do
            local offset = {x=x, y=y, z=z}
            local offset_mapblock = vector.add(mapblock, offset)
            local grid_info = eco_grid.get_mapblock(offset_mapblock)

            if grid_info and connects_to[grid_info.build_key] then
              table.insert(foreign_connections, offset)
            end
          end
        end
      end

      for _, schema in ipairs(building_def.schemas_) do
        print(schema, min)
      end
    end
  end
})
