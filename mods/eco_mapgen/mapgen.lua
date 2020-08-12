local MP = minetest.get_modpath("eco_mapgen")

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = eco_util.get_mapblock(minp)
	local max_mapblock = eco_util.get_mapblock(maxp)

	local i = 0

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
		for y=min_mapblock.y,max_mapblock.y do
			local mapblock = { x=x, y=y, z=z }
			local height = eco_mapgen.get_mapblock_height(mapblock)

			if y == height then
				local pos = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
				eco_serialize.deserialize(pos, MP .. "/schematics/grass_flat", true)
			end

			i = i + 1

		end --y
	end --x
	end --z

end)
