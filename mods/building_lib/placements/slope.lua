
building_lib.register_placement({
	name = "slope",
	check = function(mapblock_pos)
		local mapblock_pos_upper = vector.add(mapblock_pos, {x=0, y=1, z=0})
		local lower_building = building_lib.get_building_at_pos(mapblock_pos)
		local upper_building = building_lib.get_building_at_pos(mapblock_pos_upper)

		if lower_building or upper_building then
			return false, "already occupied"
		end
		return true
	end,
	place = function(mapblock_pos, building_def)
		local mapblock_pos_upper = vector.add(mapblock_pos, {x=0, y=1, z=0})
		local mapblock_data = mapblock_lib.get_mapblock_data(mapblock_pos)
		local mapgen_info = mapblock_data.mapgen_info

		local options = {
			use_cache = true,
			transform = {
				rotate = {
					axis = "y",
					angle = 0
				}
			}
		}

		-- TODO: rotate in view direction

		-- rotate (z+ is default)
		if mapgen_info.direction == "x+" then
			options.transform.rotate.angle = 90
		elseif mapgen_info.direction == "z-" then
			options.transform.rotate.angle = 180
		elseif mapgen_info.direction == "x-" then
			options.transform.rotate.angle = 270
		end

		local affected_offsets = {
			{x=0,y=0,z=0}
		}

		mapblock_lib.deserialize(mapblock_pos, building_def.schematics.slope_lower, options)
		if building_def.schematics.slope_upper then
			mapblock_lib.deserialize(mapblock_pos_upper, building_def.schematics.slope_upper, options)
			table.insert(affected_offsets, {x=0,y=1,z=0})
		end

		return affected_offsets
	end,
	after_place = function(mapblock_pos)
		-- update connections
		local mapblock_pos_upper = vector.add(mapblock_pos, {x=0, y=1, z=0})

		building_lib.update_connections(mapblock_pos)
		building_lib.update_connections(mapblock_pos_upper)
	end
})
