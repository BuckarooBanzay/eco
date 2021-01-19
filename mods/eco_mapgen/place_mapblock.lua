
function eco_mapgen.place_mapblock(mapblock_pos, info, biome)
	local upper_mapblock_pos = { x=mapblock_pos.x, y=mapblock_pos.y+1, z=mapblock_pos.z }

	-- add mapgen info (if available) to grid data
	if info.type ~= "none" then
		-- only save if data available
		mapblock_lib.set_mapblock_data(mapblock_pos, {
			mapgen = {
				terrain_type = info.type,
				terrain_direction = info.direction
			}
		})
	end

	if info.type == "underground" and biome.full then
		local options = {
			use_cache = true,
		}

		mapblock_lib.deserialize(mapblock_pos, biome.full, options)

	elseif info.type == "flat" and biome.flat then
		local options = {
			use_cache = true,
		}

		mapblock_lib.deserialize(mapblock_pos, biome.flat, options)

	elseif info.type == "slope" then
		-- slope looks into z+ direction
		local rotate = nil
		if info.direction == "z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+" then
			rotate = { axis = "y", angle = 90 }
		elseif info.direction == "x-" then
			rotate = { axis = "y", angle = 270 }
		end

		local options = {
			use_cache = true,
			transform = {
				rotate = rotate
			}
		}

		if biome.slope_lower then
			mapblock_lib.deserialize(mapblock_pos, biome.slope_lower, options)
		end
		if biome.slope_upper then
			mapblock_lib.deserialize(upper_mapblock_pos, biome.slope_upper, options)
		end

	elseif info.type == "slope_inner" then
		-- slope looks into x-z+ direction
		local rotate = nil
		if info.direction == "x-z-" then
			rotate = { axis = "y", angle = 270 }
		elseif info.direction == "x+z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+z+" then
			rotate = { axis = "y", angle = 90 }
		end

		local options = {
			use_cache = true,
			transform = {
				rotate = rotate
			}
		}

		if biome.slope_inner_lower then
			mapblock_lib.deserialize(mapblock_pos, biome.slope_inner_lower, options)
		end
		if biome.slope_inner_upper then
			mapblock_lib.deserialize(upper_mapblock_pos, biome.slope_inner_upper, options)
		end

	elseif info.type == "slope_outer" then
		-- slope looks into x-z+ direction
		local rotate = nil
		if info.direction == "x-z-" then
			rotate = { axis = "y", angle = 270 }
		elseif info.direction == "x+z-" then
			rotate = { axis = "y", angle = 180 }
		elseif info.direction == "x+z+" then
			rotate = { axis = "y", angle = 90 }
		end

		local options = {
			use_cache = true,
			transform = {
				rotate = rotate
			}
		}

		if biome.slope_outer_lower then
			mapblock_lib.deserialize(mapblock_pos, biome.slope_outer_lower, options)
		end
		if biome.slope_outer_upper then
			mapblock_lib.deserialize(upper_mapblock_pos, biome.slope_outer_upper, options)
		end

	--elseif info.type == "none" then
		-- nothing here
	end

end
