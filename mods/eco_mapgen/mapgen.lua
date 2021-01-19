local height_generator = eco_mapgen.height_generator()
local landscape_generator = eco_mapgen.landscape_generator(height_generator)

local MP = minetest.get_modpath("eco_mapgen")
local schematic_dir = MP .. "/schematics"

local function place_mapblock(mapblock_pos, info)
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

	if info.type == "flat" then
		local options = {
			use_cache = true,
		}

		mapblock_lib.deserialize(mapblock_pos, schematic_dir .. "/grass_flat", options)

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

		mapblock_lib.deserialize(mapblock_pos, schematic_dir .. "/grass_slope_lower", options)
		mapblock_lib.deserialize(upper_mapblock_pos, schematic_dir .. "/grass_slope_upper", options)

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

		mapblock_lib.deserialize(mapblock_pos, schematic_dir .. "/grass_slope_inner_corner_lower", options)
		mapblock_lib.deserialize(upper_mapblock_pos, schematic_dir .. "/grass_slope_inner_corner_upper", options)

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

		mapblock_lib.deserialize(mapblock_pos, schematic_dir .. "/grass_slope_outer_corner_lower", options)
		mapblock_lib.deserialize(upper_mapblock_pos, schematic_dir .. "/grass_slope_outer_corner_upper", options)

	--elseif info.type == "none" then
		-- nothing here
	end

end

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = mapblock_lib.get_mapblock(minp)
	local max_mapblock = mapblock_lib.get_mapblock(maxp)

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
	for y=min_mapblock.y,max_mapblock.y do

		local mapblock_pos = { x=x, y=y, z=z }
		local info = landscape_generator.get_info(mapblock_pos)
		place_mapblock(mapblock_pos, info)

	end --y
	end --x
	end --z

end)
