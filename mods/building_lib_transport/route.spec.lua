
building_lib.register_building("building_lib_transport:route_straight", {
	placement = "dummy",
    routes = {
        left = {
            type = "street",
            start_dir = {x=-1, y=0, z=0},
            end_dir = {x=1, y=0, z=0},
            points = {
                {x=0, y=3, z=3},
                {x=16, y=3, z=3}
            }
        },
        right = {
            type = "street",
            start_dir = {x=1, y=0, z=0},
            end_dir = {x=-1, y=0, z=0},
            points = {
                {x=16, y=3, z=13},
                {x=0, y=3, z=13}
            }
        }
    }
})

mtt.register("route", function(callback)

    local playername = "singleplayer"
    assert(building_lib.build({x=0, y=0, z=0}, playername, "building_lib_transport:route_straight"))
    assert(building_lib.build({x=1, y=0, z=0}, playername, "building_lib_transport:route_straight"))
    assert(building_lib.build({x=2, y=0, z=0}, playername, "building_lib_transport:route_straight"))

    -- end of mb1
    local routes = building_lib_transport.get_routes({x=0, y=0, z=0}, {x=1, y=0, z=0}, "street")
    print(dump(routes))

    callback()
end)