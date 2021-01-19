
local height_params = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64},
	seed = 5477835,
	octaves = 2,
	persist = 0.5
}

local cache = {}
local height_perlin

function eco_mapgen.get_mapblock_height(mapblock)
	local hash = minetest.hash_node_position({ x=mapblock.x, y=0, z=mapblock.z })
	if cache[hash] ~= nil then
		return cache[hash]
	end

	local map_lengths_xyz = {x=1, y=1, z=1}
	height_perlin = height_perlin or minetest.get_perlin_map(height_params, map_lengths_xyz)

	local height_perlin_map = {}
	height_perlin:get_2d_map_flat({x=mapblock.x, y=mapblock.z}, height_perlin_map)

	local height_perlin_factor = math.abs( height_perlin_map[1] )
	local height = math.floor(height_perlin_factor * 6) - 1

	cache[hash] = height

	return height
end
