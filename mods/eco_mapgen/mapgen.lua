local MP = minetest.get_modpath("eco_mapgen")

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = eco_util.get_mapblock(minp)
	local max_mapblock = eco_util.get_mapblock(maxp)

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
		local height = eco_mapgen.get_mapblock_height({ x=x, z=z })

		local xplus_height = eco_mapgen.get_mapblock_height({ x=x+1, z=z })
		local xminus_height = eco_mapgen.get_mapblock_height({ x=x-1, z=z })
		local zplus_height = eco_mapgen.get_mapblock_height({ x=x, z=z+1 })
		local zminus_height = eco_mapgen.get_mapblock_height({ x=x, z=z-1 })

		local xplus_higher = xplus_height > height
		local xminus_higher = xminus_height > height
		local zplus_higher = zplus_height > height
		local zminus_higher = zminus_height > height

		for y=min_mapblock.y,max_mapblock.y do

			if y == height then
				-- solid mapblock here
				-- TODO: check adjecent height and place slope

				local mapblock = { x=x, y=y, z=z }
				local pos = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
				eco_serialize.deserialize(pos, MP .. "/schematics/grass_flat", true)
			end

		end --y
	end --x
	end --z

end)
