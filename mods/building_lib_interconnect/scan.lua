
-- scans a connection tree (must start at a connection position)
function building_lib_interconnect.scan(mapblock_pos, connection_type, connections, visited_nodes, count)
    connections = connections or {} -- list of positions
    visited_nodes = visited_nodes or {} -- hash -> true
    count = count or 0

    if count > 1000 then
        return false, "max-count exceeded"
    end

    local hash = minetest.hash_node_position(mapblock_pos)
    if visited_nodes[hash] then
        -- already visited
        return
    end

    visited_nodes[hash] = true

    local building_def, origin = building_lib.get_building_def_at(mapblock_pos)
    if not building_def then
        return connections
    end

    local building_info = building_lib.get_placed_building_info(mapblock_pos)
    if not building_info then
        return connections
    end

    local ic = building_def.interconnect
    if ic.connects and type(ic.connects[connection_type]) == "table" then
        for _, dir in ipairs(ic.connects[connection_type]) do
            local rotated_dir = mapblock_lib.rotate_pos(dir, building_info.size, building_info.rotation)
            local neighbor_pos = vector.add(origin, rotated_dir)
            local neighbor_def, neighbor_origin = building_lib.get_building_def_at(neighbor_pos)
            local neighbor_building_info = building_lib.get_placed_building_info(neighbor_pos)

            local neighbor_ic = neighbor_def.interconnect
            if neighbor_ic.connects and type(neighbor_ic.connects[connection_type]) == "table" then
                -- neighbor is compatible, check back-connections
                for _, neighbor_dir in ipairs(neighbor_ic.connects[connection_type]) do
                    local neighbor_rotated_dir = mapblock_lib.rotate_pos(
                        neighbor_dir, neighbor_building_info.size, neighbor_building_info.rotation
                    )
                    if vector.equals(origin, vector.add(neighbor_origin, neighbor_rotated_dir)) then
                        -- neighbor points back, recurse
                        building_lib_interconnect.scan(
                            neighbor_origin, connection_type, connections, visited_nodes, count + 1
                        )
                    end
                end
            end

            if neighbor_ic.connects_to and type(neighbor_ic.connects_to[connection_type]) == "table" then
                -- connecting building, check back-connections
                for _, neighbor_dir in ipairs(neighbor_ic.connects_to[connection_type]) do
                    local neighbor_rotated_dir = mapblock_lib.rotate_pos(
                        neighbor_dir, neighbor_building_info.size, neighbor_building_info.rotation
                    )
                    if vector.equals(origin, vector.add(neighbor_origin, neighbor_rotated_dir)) then
                        -- neighbor points back, add to list
                        table.insert(connections, neighbor_origin)
                        break
                    end
                end
            end
        end
    end

    return connections, visited_nodes
end