
-- size of the superblock in mapblocks
eco_api.superblock_size = 20

-- json formatted data storage (for potential retrieval in external applications)
local store = mapblock_lib.create_data_storage(eco_api.store, {
    serialize = minetest.write_json,
    deserialize = minetest.parse_json
})

-- returns the superblock position for the given mapblock position
function eco_api.get_superblock_pos(mapblock_pos)
    return vector.floor( vector.divide(mapblock_pos, eco_api.superblock_size))
end

-- returns the superblock data for given mapblock position
function eco_api.get_superblock(mapblock_pos)
    return store:get(eco_api.get_superblock_pos(mapblock_pos))
end

-- sets the superblock data in given mapblock position
function eco_api.set_superblock(mapblock_pos, superblock)
    return store:set(eco_api.get_superblock_pos(mapblock_pos), superblock)
end

-- returns the min and max mapblock positions in the superblock at given mapblock position
function eco_api.get_superblock_bounds(mapblock_pos)
    local superblock_pos = eco_api.get_superblock_pos(mapblock_pos)
    local min = vector.multiply(superblock_pos, eco_api.superblock_size)
	local max = vector.add(min, eco_api.superblock_size - 1)
	return min, max
end

minetest.register_chatcommand("superblock", {
    func = function(playername)
        local player = minetest.get_player_by_name(playername)
        if not player then
            return true, "no such player"
        end

        local pos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(pos)

        local superblock_pos = eco_api.get_superblock_pos(mapblock_pos)

        return true, string.format("Current superblock: %s", minetest.pos_to_string(superblock_pos))
    end
})

-- preview boundaries in overview

local function check_player(player)
    local pos = player:get_pos()

    if not building_lib_overview.is_in_overview(pos) then
        return
    end

    local mapblock_pos = building_lib_overview.overview_to_mapblock_pos(pos)
    local mapblock_min, mapblock_max = eco_api.get_superblock_bounds(mapblock_pos)
    local pos1 = building_lib_overview.mapblock_pos_to_overview(mapblock_min)
    local pos2 = building_lib_overview.mapblock_pos_to_overview(mapblock_max)

    pos1 = vector.subtract(pos1, 0.5)
    pos2 = vector.add(pos2, 0.5)

    -- create shape
    vizlib.draw_area(pos1, pos2, {
        time = 2,
        color = "#FF0000",
        player = player:get_player_name()
    })
end

minetest.register_on_joinplayer(check_player)

local function worker()
    for _, player in ipairs(minetest.get_connected_players()) do
        check_player(player)
    end

    minetest.after(1, worker)
end

minetest.after(1, worker)
