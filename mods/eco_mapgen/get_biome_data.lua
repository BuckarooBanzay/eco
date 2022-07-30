

local temperature_perlin
local temperature_params = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64},
	seed = 952995,
	octaves = 2,
	persist = 0.5
}

local humidity_perlin
local humidity_params = {
	offset = 0,
	scale = 1,
	spread = {x=128, y=128, z=128},
	seed = 2946271,
	octaves = 2,
	persist = 0.5
}

local height_perlin
local height_params = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64},
	seed = 5477835,
	octaves = 2,
	persist = 0.5
}

function eco_mapgen.get_biome_data(mapblock_pos)
	local map_lengths_xyz = {x=1, y=1, z=1}

    local temperature_perlin_map = {}
	temperature_perlin = temperature_perlin or minetest.get_perlin_map(temperature_params, map_lengths_xyz)
	temperature_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, temperature_perlin_map)

    local humidity_perlin_map = {}
	humidity_perlin = humidity_perlin or minetest.get_perlin_map(humidity_params, map_lengths_xyz)
	humidity_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, humidity_perlin_map)

    local height_perlin_map = {}
	height_perlin = height_perlin or minetest.get_perlin_map(height_params, map_lengths_xyz)
	height_perlin:get_2d_map_flat({x=mapblock_pos.x, y=mapblock_pos.z}, height_perlin_map)

    local data = {
        temperature = math.floor(math.abs(temperature_perlin_map[1]) * 100),
        humidity = math.floor(math.abs(humidity_perlin_map[1]) * 100),
        height = math.floor(math.abs(height_perlin_map[1]) * 6) -1
    }

	return data
end

eco_mapgen.get_biome_data = memoize(eco_mapgen.get_biome_data, function(pos)
    return minetest.hash_node_position({ x=pos.x, y=0, z=pos.z })
end)

minetest.register_chatcommand("get_biome_data", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local mapblock_pos = mapblock_lib.get_mapblock(pos)
		local info = eco_mapgen.get_biome_data(mapblock_pos)

		return true, dump(info)
	end
})
