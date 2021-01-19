local height_generator = eco_mapgen.height_generator()
local landscape_generator = eco_mapgen.landscape_generator(height_generator)

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
		local height = height_generator.get_mapblock_height(mapblock_pos)
		local biome = eco_mapgen.get_biome(mapblock_pos, info, height)

		eco_mapgen.place_mapblock(mapblock_pos, info, biome)

	end --y
	end --x
	end --z

end)
