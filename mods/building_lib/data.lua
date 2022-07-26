-- off-world storage for position-dependent data (data in mapblocks, tilenames, etc)
-- indexed in 10^3 groups and saved in the mod-storage

local storage = minetest.get_mod_storage()

-- "group" is a bundle of mapblock-positions
local function get_group_pos(mapblock_pos)
    -- 10^3 mapblock-datasets are in a group for better lookup, indexing and caching
    return vector.floor(vector.divide(mapblock_pos, 10))
end

local function get_group_data(mapblock_pos)
    local index = minetest.pos_to_string(get_group_pos(mapblock_pos))
    local serialized_data = storage:get_string(index)
    if serialized_data == "" then
        return {}
    else
        return minetest.deserialize(serialized_data)
    end
end

-- TODO: this could be saved in an async worker instead
local function set_group_data(mapblock_pos, data)
    local index = minetest.pos_to_string(get_group_pos(mapblock_pos))
    local serialized_data = minetest.serialize(data)
    storage:set_string(index, serialized_data)
end

-- mapblock_pos -> data
local cache = {}

-- exposed functions below here

function building_lib.get_mapblock_data(mapblock_pos)
    local index = minetest.pos_to_string(mapblock_pos)
    if cache[index] then
        return cache[index]
    end
    local group_data = get_group_data(mapblock_pos)
    return group_data[index]
end

function building_lib.set_mapblock_data(mapblock_pos, data)
    local index = minetest.pos_to_string(mapblock_pos)
    cache[index] = data
    local group_data = get_group_data(mapblock_pos)
    group_data[index] = data
    set_group_data(mapblock_pos, group_data)
end

minetest.register_chatcommand("building_lib_info", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local ppos = player:get_pos()
        local mapblock_pos = mapblock_lib.get_mapblock(ppos)
        local data = building_lib.get_mapblock_data(mapblock_pos)
        return true, "Data for mapblock " .. minetest.pos_to_string(mapblock_pos) .. ": " .. dump(data)
    end
})