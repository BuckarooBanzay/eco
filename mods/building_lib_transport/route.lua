
-- rotates all routes by the given rotation
function building_lib_transport.get_rotated_routes(building_def, rotation)
    if rotation == 0 or not building_def.routes then
        -- no rotation or no routes
        return building_def.routes
    end

    local mapblock_size = building_lib.get_building_size(building_def, rotation)
    local node_size = vector.multiply(mapblock_size, 16)

    local rotated_routes = {}
    for _, route in ipairs(building_def.routes) do
        local rotated_route = {
            name = route.name,
            type = route.type,
            points = {}
        }

        rotated_route.start_dir = mapblock_lib.rotate_pos(route.start_dir, vector.subtract(mapblock_size, 1), rotation)
        rotated_route.end_dir = mapblock_lib.rotate_pos(route.end_dir, vector.subtract(mapblock_size, 1), rotation)

        for _, point in ipairs(route.points) do
            local rotated_point = mapblock_lib.rotate_pos(point, node_size, rotation)
            table.insert(rotated_route.points, rotated_point)
        end

        table.insert(rotated_routes, rotated_route)
    end
    return rotated_routes
end

-- returns all available routes for the mapblock_pos and current route name
function building_lib_transport.get_routes(mapblock_pos, current_route_name)

    local info, origin = building_lib.get_placed_building_info(mapblock_pos)
    if not info then
        return nil, "no building found"
    end

    local building_def = building_lib.get_building(info.name)
    if not building_def then
        return nil, nil, "building def not found"
    end

    local rotated_routes = building_lib_transport.get_rotated_routes(building_def, info.rotation)

    -- get current route
    local current_route
    for _, route in ipairs(rotated_routes or {}) do
        if route.name == current_route_name then
            current_route = route
            break
        end
    end
    if not current_route then
        return nil, nil, "no route with name '" .. current_route_name .. "' found in building: '" .. info.name .. "'"
    end

    -- get target building
    local target_mapblock = vector.add(origin, current_route.end_dir)
    local target_info, target_origin = building_lib.get_placed_building_info(target_mapblock)
    if not target_info then
        return nil, nil, "no target building found"
    end

    local target_building_def = building_lib.get_building(info.name)
    if not target_building_def then
        return nil, nil, "target building def not found"
    end

    local target_rotated_routes = building_lib_transport.get_rotated_routes(target_building_def, target_info.rotation)
    if not target_rotated_routes then
        return nil, nil, "no target routes found"
    end

    -- calculate where the current route ends in absolute coords
    local node_pos_offset = vector.multiply(origin, 16)
    local target_node_pos_offset = vector.multiply(target_origin, 16)
    local current_route_end_abs = vector.add(node_pos_offset, current_route.points[#current_route.points])

    local routes = {}

    for _, target_route in ipairs(target_rotated_routes) do
        if target_route.type == current_route.type then
            -- calculate where the target route starts
            local target_route_start_pos = vector.add(target_node_pos_offset, target_route.points[1])
            if vector.equals(current_route_end_abs, target_route_start_pos) then
                -- positions match
                table.insert(routes, target_route)
            end
        end
    end

    return routes, target_mapblock
end
