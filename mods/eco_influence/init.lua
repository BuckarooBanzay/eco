
eco_influence = {
    store = mapblock_lib.create_data_storage(minetest.get_mod_storage())
}

local function apply_influence(origin_pos1, origin_pos2, name, value)
    -- TODO
end

building_lib.register_on("placed", function(mapblock_pos, playername, building_def, rotation, size)
    -- TODO
end)

building_lib.register_on("placed_mapgen", function(mapblock_pos, building_def, rotation)
    -- TODO
end)

building_lib.register_on("removed", function(mapblock_pos, playername, building_info)
    -- TODO
end)

function eco_influence.get_groups(mapblock_pos)
    -- TODO
end

function eco_influence.get(mapblock_pos, name)
    -- TODO
end

function eco_influence.clear(mapblock_pos1, mapblock_pos2)
    mapblock_pos2 = mapblock_pos2 or mapblock_pos1
    -- TODO
end