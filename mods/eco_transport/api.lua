
-- transport types

local types = {}

function eco_transport.register_type(name, def)
    types[name] = def
    eco_transport.register_entity_for_type(name, def)
end

function eco_transport.get_type(name)
    return types[name]
end

-- transport lifecycle

function eco_transport.add(mapblock_pos, route_name, type, data)
    local type_def = eco_transport.get_type(type)
    if not type_def then
        return false, "transport type not found: " .. type
    end

    local building_def, origin, rotation = building_lib.get_building_def_at(mapblock_pos)
    if not building_def then
        return false, "no building found at " .. minetest.pos_to_string(mapblock_pos)
    end
    if not building_def.transport then
        return false, "building has no transport-definition"
    end

    local building_size = building_lib.get_building_size(building_def, rotation)
    local rotated_routes = eco_transport.rotate_routes(building_def.transport.routes, building_size, rotation)

    local route = rotated_routes[route_name]
    if not route then
        return false, "route '" .. route_name .. "' not found"
    end

    local entry = {
        id = eco_transport.new_uuid(),
        type = type,
        route_name = route_name,
        building_pos = origin,
        velocity = 2,
        data = data
    }

    local success, err
    success, err = eco_transport.add_entry(entry)
    if not success then
        return false, "add_entry error: " .. err
    end

    local pos_data
    pos_data, err = eco_transport.get_position_data(entry)
    if not pos_data then
        return false, "add_entry error: " .. err
    end

    minetest.add_entity(pos_data.pos, "eco_transport:" .. entry.type, entry.id)
end
