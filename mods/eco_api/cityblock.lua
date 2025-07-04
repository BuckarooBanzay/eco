
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

local player_shapes = {}
local player_cityblock_positions = {}

local function worker()
    for _, player in ipairs(minetest.get_connected_players()) do
        local playername = player:get_player_name()

        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)
        local cityblock_pos = eco_api.get_cityblock_pos(mapblock_pos)

        if player_cityblock_positions[playername] ~= minetest.pos_to_string(cityblock_pos) then
            -- position changed
            player_cityblock_positions[playername] = minetest.pos_to_string(cityblock_pos)

            if player_shapes[playername] then
                -- remove previous shape
                vizlib.erase_shape(player_shapes[playername])
            end

            -- create new shape
            local mapblock_min, mapblock_max = eco_api.get_cityblock_bounds(mapblock_pos)
            local min_pos = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_min)
            local _, max_pos = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_max)

            print(dump({
                playername = playername,
                min_pos = min_pos,
                max_pos = max_pos
            }))

            player_shapes[playername] = vizlib.draw_area(min_pos, max_pos, {
                infinite = true,
                color = "#00FF00",
                player = playername
            })

        end
    end

    minetest.after(10, worker)
end

worker()

