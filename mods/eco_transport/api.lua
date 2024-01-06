
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
    local transport_def = "?"
    -- TODO: get building-def
    -- TODO: get transport-def
    -- TODO: get route
    -- TODO: rotate route
    -- TODO: check if occupied
    local entity = type_def.create_entity(pos, opts)
end

-- routes

function eco_transport.get_item(mapblock_pos, route_name)
end

function eco_transport.set_item(mapblock_pos, route_name, opts)
end