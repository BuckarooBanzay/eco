
-- ${playername}/${routename} => route
local routes = {}

-- TODO: persist in mod_storage

local function format_key(playername, routename)
    return playername .. "/" .. routename
end

function building_lib_transport.create_route(playername, routename, route)
    route.playername = playername
    route.routename = routename
    route.key = format_key(playername, routename)
    routes[route.key] = route
end

function building_lib_transport.get_route(playername, routename)
    return routes[format_key(playername, routename)]
end