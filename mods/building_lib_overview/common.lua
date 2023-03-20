local overview_start_y = 25000

-- mapblock_pos to node-pos
function building_lib_overview.mapblock_pos_to_overview(mapblock_pos)
    return {
        x = mapblock_pos.x,
        y = mapblock_pos.y + overview_start_y,
        z = mapblock_pos.z
    }
end

-- node_pos to mapblock_pos
function building_lib_overview.overview_to_mapblock_pos(node_pos)
    node_pos = vector.round(node_pos)
    return {
        x = node_pos.x,
        y = node_pos.y - overview_start_y,
        z = node_pos.z
    }
end

function building_lib_overview.is_in_overview(node_pos)
    return node_pos.y >= overview_start_y
end

-- node-pos to node-pos (centered)
function building_lib_overview.overview_to_node_pos(node_pos)
    local mapblock_pos = building_lib_overview.overview_to_mapblock_pos(node_pos)
    local min = mapblock_lib.get_mapblock_bounds_from_mapblock(mapblock_pos)
    return vector.add(min, 7.5)
end