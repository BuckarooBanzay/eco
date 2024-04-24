
mtt.register("rotate_routes", function(callback)
    local routes = {}
    local routes_90deg = eco_transport.rotate_routes(routes, 90)
    assert(routes_90deg) --TODO
    callback()
end)