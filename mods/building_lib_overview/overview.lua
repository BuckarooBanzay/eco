
local function place_overview_node(e)

    local mapblock_pos = e.mapblock_pos
    local overview_def = e.building_def.overview
    local rotation = e.rotation
    local size = e.size

    size = size or {x=1, y=1, z=1}
    local mapblock_pos2 = vector.add(mapblock_pos, vector.subtract(size, 1))

    mapblock_lib.for_each(mapblock_pos, mapblock_pos2, function(offset_mapblock_pos)
        local node_pos = building_lib_overview.mapblock_pos_to_overview(offset_mapblock_pos)
        minetest.load_area(node_pos)

        if type(overview_def) == "string" then
            local param2 = mapblock_lib.rotate_param2(overview_def, 0, rotation)
            minetest.set_node(node_pos, { name=overview_def, param2=param2 })
        elseif type(overview_def) == "table" then
            overview_def.param2 = mapblock_lib.rotate_param2(overview_def.name, overview_def.param2 or 0, rotation)
            minetest.set_node(node_pos, overview_def)
        elseif type(overview_def) == "function" then
            local rel_mapblock_pos = vector.subtract(offset_mapblock_pos, mapblock_pos)
            local node = overview_def(rel_mapblock_pos, e)
            if node then
                node.param2 = mapblock_lib.rotate_param2(node.name, node.param2 or 0, rotation)
                minetest.set_node(node_pos, node)
            end
        end
    end)
end

building_lib.register_on("placed_mapgen", function(e)
    place_overview_node(e)
end)

building_lib.register_on("placed", function(e)
    place_overview_node(e)
end)

building_lib.register_on("replaced", function(e)
    place_overview_node(e)
end)

building_lib.register_on("removed", function(e)
    local size = e.building_info.size or {x=1, y=1, z=1}
    local mapblock_pos2 = vector.add(e.mapblock_pos, vector.subtract(size, 1))

    mapblock_lib.for_each(e.mapblock_pos, mapblock_pos2, function(offset_mapblock_pos)
        local node_pos = building_lib_overview.mapblock_pos_to_overview(offset_mapblock_pos)
        minetest.load_area(node_pos)
        minetest.set_node(node_pos, { name = "air" })
    end)
end)
