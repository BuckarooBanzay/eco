local MP = minetest.get_modpath("eco_mapgen")

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = eco_util.get_mapblock(minp)
	local max_mapblock = eco_util.get_mapblock(maxp)

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
	for y=min_mapblock.y,max_mapblock.y do

		local mapblock = { x=x, y=y, z=z }
		local info = eco_mapgen.get_info(mapblock)
		local pos = eco_util.get_mapblock_bounds_from_mapblock(mapblock)

		if info.type == "flat" then
			eco_serialize.deserialize(pos, MP .. "/schematics/grass_flat", {
				use_cache = true
			})
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

			eco_serialize.deserialize(pos, MP .. "/schematics/grass_slope", {
				-- use_cache = true,
				transform = {
					rotate = rotate
				}
			})

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

			eco_serialize.deserialize(pos, MP .. "/schematics/grass_slope_inner_corner", {
				-- use_cache = true,
				transform = {
					rotate = rotate
				}
			})

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

			eco_serialize.deserialize(pos, MP .. "/schematics/grass_slope_outer_corner", {
				-- use_cache = true,
				transform = {
					rotate = rotate
				}
			})
		end

		end --y
	end --x
	end --z

end)
