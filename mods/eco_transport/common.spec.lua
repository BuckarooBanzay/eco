
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
    local routes_90deg = eco_transport.rotate_routes(routes, 90)
    assert(routes_90deg.main.type == "container-3")
    assert(routes_90deg.main.points[1].x == 0)
    assert(routes_90deg.main.points[1].y == 0)
    assert(routes_90deg.main.points[1].z == 15.5)
    assert(routes_90deg.main.points[2].x == 0)
    assert(routes_90deg.main.points[2].y == 0)
    assert(routes_90deg.main.points[2].z == -0.5)
    callback()
end)