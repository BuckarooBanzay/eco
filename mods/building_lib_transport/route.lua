
function building_lib_transport.get_routes(mapblock_pos, dir, type)
    local routes = {}

    local info, origin = building_lib.get_placed_building_info(mapblock_pos)
    if not info then
        return routes
    end

    local building_def = building_lib.get_building(info.name)
    if not building_def then
        return routes
    end

    local mapblock_size = building_lib.get_building_size(building_def, info.rotation)
    local size = vector.multiply(mapblock_size, 16)

    for name, route in pairs(building_def.routes or {}) do
        local rotated_start_dir = mapblock_lib.rotate_pos(route.start_dir, size, info.rotation)
        if vector.equals(rotated_start_dir, dir) then
            -- direction matches, get target building
            local target_mapblock_pos = vector.add(mapblock_pos, dir)
            local target_info, target_origin = building_lib.get_placed_building_info(target_mapblock_pos)
            if target_info then
                local target_building_def = building_lib.get_building(target_info.name)
                for target_name, target_route in pairs(target_building_def.routes or {}) do
                    -- TODO
                end
                routes[name] = rotated_start_dir
            end
        end
        -- TODO
    end

    return routes
end
