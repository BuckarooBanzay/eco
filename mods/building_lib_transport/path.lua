
-- rotates all paths by the given rotation
function building_lib_transport.get_rotated_paths(building_def, rotation)
    if rotation == 0 or not building_def.paths then
        -- no rotation or no paths
        return building_def.paths
    end

    local mapblock_size = building_lib.get_building_size(building_def, rotation)
    local node_size = vector.multiply(mapblock_size, 16)

    local rotated_paths = {}
    for _, path in ipairs(building_def.paths) do
        local rotated_path = {
            name = path.name,
            type = path.type,
            points = {}
        }

        rotated_path.start_dir = mapblock_lib.rotate_pos(path.start_dir, vector.subtract(mapblock_size, 1), rotation)
        rotated_path.end_dir = mapblock_lib.rotate_pos(path.end_dir, vector.subtract(mapblock_size, 1), rotation)

        for _, point in ipairs(path.points) do
            local rotated_point = mapblock_lib.rotate_pos(point, node_size, rotation)
            table.insert(rotated_path.points, rotated_point)
        end

        table.insert(rotated_paths, rotated_path)
    end
    return rotated_paths
end

-- returns all available paths for the mapblock_pos and current path name
function building_lib_transport.get_paths(mapblock_pos, current_path_name)

    local info, origin = building_lib.get_placed_building_info(mapblock_pos)
    if not info then
        return nil, "no building found"
    end

    local building_def = building_lib.get_building(info.name)
    if not building_def then
        return nil, nil, "building def not found"
    end

    local rotated_paths = building_lib_transport.get_rotated_paths(building_def, info.rotation)

    -- get current path
    local current_path
    for _, path in ipairs(rotated_paths or {}) do
        if path.name == current_path_name then
            current_path = path
            break
        end
    end
    if not current_path then
        return nil, nil, "no path with name '" .. current_path_name .. "' found in building: '" .. info.name .. "'"
    end

    -- get target building
    local target_mapblock = vector.add(origin, current_path.end_dir)
    local target_info, target_origin = building_lib.get_placed_building_info(target_mapblock)
    if not target_info then
        return nil, nil, "no target building found"
    end

    local target_building_def = building_lib.get_building(info.name)
    if not target_building_def then
        return nil, nil, "target building def not found"
    end

    local target_rotated_paths = building_lib_transport.get_rotated_paths(target_building_def, target_info.rotation)
    if not target_rotated_paths then
        return nil, nil, "no target paths found"
    end

    -- calculate where the current path ends in absolute coords
    local node_pos_offset = vector.multiply(origin, 16)
    local target_node_pos_offset = vector.multiply(target_origin, 16)
    local current_path_end_abs = vector.add(node_pos_offset, current_path.points[#current_path.points])

    local paths = {}

    for _, target_path in ipairs(target_rotated_paths) do
        if target_path.type == current_path.type then
            -- calculate where the target path starts
            local target_path_start_pos = vector.add(target_node_pos_offset, target_path.points[1])
            if vector.equals(current_path_end_abs, target_path_start_pos) then
                -- positions match
                table.insert(paths, target_path)
            end
        end
    end

    return paths, target_mapblock
end
