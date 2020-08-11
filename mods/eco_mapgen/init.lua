local MP = minetest.get_modpath("eco_mapgen")

local height_params = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64},
	seed = 5477835,
	octaves = 2,
	persist = 0.5
}

local height_perlin
local height_perlin_map = {}

minetest.register_on_generated(function(minp, maxp)

	-- 5x5x5 mapblocks per chunk
	assert((maxp.x - minp.x + 1) == 80)

	local min_mapblock = eco_util.get_mapblock(minp)
	local max_mapblock = eco_util.get_mapblock(maxp)

	local map_lengths_xyz = {x=5, y=5, z=5}
	height_perlin = height_perlin or minetest.get_perlin_map(height_params, map_lengths_xyz)
	height_perlin:get_2d_map_flat({x=min_mapblock.x, y=max_mapblock.z}, height_perlin_map)

	local i = 0
	local perlin_index = 1

	for z=min_mapblock.z,max_mapblock.z do
	for x=min_mapblock.x,max_mapblock.x do
		local height_perlin_factor = math.abs( height_perlin_map[perlin_index] )
		perlin_index = perlin_index + 1

		local height = math.floor(height_perlin_factor * 5)

		for y=min_mapblock.y,max_mapblock.y do

			if y == height then
				local mapblock = { x=x, y=y, z=z }
				local pos = eco_util.get_mapblock_bounds_from_mapblock(mapblock)
				eco_serialize.deserialize(pos, MP .. "/schematics/green", true)
			end

			i = i + 1

		end --y
	end --x
	end --z

end)
