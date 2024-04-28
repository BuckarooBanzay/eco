
-- transport types

local types = {}

function eco_transport.register_type(name, def)
    types[name] = def
end

function eco_transport.get_type(name)
    return types[name]
end

-- transport lifecycle

function eco_transport.add(mapblock_pos, route_name, type, opts)
    local type_def = eco_transport.get_type(type)
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

    local offset_pos = vector.subtract(vector.multiply(origin, 16), 1)
    local start_pos_rel = route.points[1]
    local start_pos = vector.add(offset_pos, start_pos_rel)
    -- TODO

    local entity = type_def.create_entity(start_pos, opts)
end
