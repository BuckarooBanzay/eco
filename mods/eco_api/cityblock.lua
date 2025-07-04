
-- size of the cityblock in mapblocks
eco_api.cityblock_size = 20

-- json formatted data storage (for potential retrieval in external applications)
local store = mapblock_lib.create_data_storage(eco_api.store, {
    serialize = minetest.write_json,
    deserialize = minetest.parse_json
})

-- returns the cityblock position for the given mapblock position
function eco_api.get_cityblock_pos(mapblock_pos)
    return vector.floor( vector.divide(mapblock_pos, eco_api.cityblock_size))
end

-- returns the cityblock data for given mapblock position
function eco_api.get_cityblock(mapblock_pos)
    return store:get(eco_api.get_cityblock_pos(mapblock_pos))
end

-- sets the cityblock data in given mapblock position
function eco_api.set_cityblock(mapblock_pos, cityblock)
    return store:set(eco_api.get_cityblock_pos(mapblock_pos), cityblock)
end

-- returns the min and max mapblock positions in the cityblock at given mapblock position
function eco_api.get_cityblock_bounds(mapblock_pos)
    local cityblock_pos = eco_api.get_cityblock_pos(mapblock_pos)
    local min = vector.multiply(cityblock_pos, eco_api.cityblock_size)
	local max = vector.add(min, eco_api.cityblock_size - 1)
	return min, max
end