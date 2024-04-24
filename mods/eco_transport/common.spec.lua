
mtt.register("rotate_routes", function(callback)
    local routes = {
        main = {
            type = "container-3",
            points = {
                { x=-0.5, y=0, z=0 },
                { x=15.5, y=0, z=0 }
            }
        }
    }

    local building_size = { x=1, y=1, z=1 }

    local routes_90deg = eco_transport.rotate_routes(routes, building_size, 90)
    assert(routes_90deg.main.type == "container-3")
    assert(routes_90deg.main.points[1].x == 0)
    assert(routes_90deg.main.points[1].y == 0)
    assert(routes_90deg.main.points[1].z == 15.5)
    assert(routes_90deg.main.points[2].x == 0)
    assert(routes_90deg.main.points[2].y == 0)
    assert(routes_90deg.main.points[2].z == -0.5)
    callback()
end)

mtt.register("get_connected_route_dir", function(callback)
    local route = {
        points = {
            { x=-0.5, y=0, z=0 },
            { x=15.5, y=0, z=0 }
        }
    }

    local building_size = { x=1, y=1, z=1 }

    local dir = eco_transport.get_connected_route_dir(route, building_size)
    assert(dir.x == 1)
    assert(dir.y == 0)
    assert(dir.z == 0)

    callback()
end)


mtt.register("find_connected_route", function(callback)
    local target_routes = {
        main = {
            type = "container-3",
            points = {
                { x=-0.5, y=0, z=0 },
                { x=15.5, y=0, z=0 }
            }
        }
    }

    local target_offset = { x=1, y=0, z=0 }

    local source_route = {
        type = "container-3",
        points = {
            { x=-0.5, y=0, z=0 },
            { x=15.5, y=0, z=0 }
        }
    }

    local building_size = { x=1, y=1, z=1 }

    local connected_route = eco_transport.find_connected_route(source_route, building_size, target_routes, target_offset)
    assert(connected_route)
    -- TODO

    callback()
end)