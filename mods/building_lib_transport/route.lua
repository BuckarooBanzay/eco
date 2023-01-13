
-- name => route
local routes = {}

-- TODO: persist in mod_storage

function building_lib_transport.create_route(name, route)
    route.name = name
    routes[name] = route
end

function building_lib_transport.get_route(name)
    return routes[name]
end