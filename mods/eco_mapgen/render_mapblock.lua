
local function rotate_slope(direction)
	-- slope looks into z+ direction
	if direction == "z-" then
		return { axis = "y", angle = 180 }
	elseif direction == "x+" then
		return { axis = "y", angle = 90 }
	elseif direction == "x-" then
		return { axis = "y", angle = 270 }
	end
end

local function rotate_slope_inner(direction)
	-- slope looks into x-z+ direction
	if direction == "x-z-" then
		return { axis = "y", angle = 270 }
	elseif direction == "x+z-" then
		return { axis = "y", angle = 180 }
	elseif direction == "x+z+" then
		return { axis = "y", angle = 90 }
	end
end

function eco_mapgen.render_mapblock(mapblock_pos)
	local info = eco_mapgen.get_info(mapblock_pos)
	local height = eco_mapgen.get_mapblock_height(mapblock_pos)
	local biome = eco_mapgen.get_biome(mapblock_pos, info, height)

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
		mapblock_lib.deserialize(mapblock_pos, biome.full, {
			use_cache = true,
		})

	elseif info.type == "flat" and biome.flat then
		mapblock_lib.deserialize(mapblock_pos, biome.flat, {
			use_cache = true,
			transform = {
				replace = biome.replace
			}
		})

	elseif info.type == "slope_lower" and biome.slope_lower then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_lower, {
			use_cache = true,
			transform = {
				rotate = rotate_slope(info.direction),
				replace = biome.replace
			}
		})

	elseif info.type == "slope_upper" and biome.slope_upper then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_upper, {
			use_cache = true,
			transform = {
				rotate = rotate_slope(info.direction),
				replace = biome.replace
			}
		})

	elseif info.type == "slope_inner_lower" and biome.slope_inner_lower then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_inner_lower, {
			use_cache = true,
			transform = {
				rotate = rotate_slope_inner(info.direction),
				replace = biome.replace
			}
		})

	elseif info.type == "slope_inner_upper" and biome.slope_inner_upper then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_inner_upper, {
			use_cache = true,
			transform = {
				rotate = rotate_slope_inner(info.direction),
				replace = biome.replace
			}
		})

	elseif info.type == "slope_outer_lower" and biome.slope_outer_lower then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_outer_lower, {
			use_cache = true,
			transform = {
				rotate = rotate_slope_inner(info.direction),
				replace = biome.replace
			}
		})

	elseif info.type == "slope_outer_upper" and biome.slope_outer_upper then
		mapblock_lib.deserialize(mapblock_pos, biome.slope_outer_upper, {
			use_cache = true,
			transform = {
				rotate = rotate_slope_inner(info.direction),
				replace = biome.replace
			}
		})

	--elseif info.type == "none" then
		-- nothing here
	end

	eco_mapgen.render_decorations(mapblock_pos, info, height, biome)
end
