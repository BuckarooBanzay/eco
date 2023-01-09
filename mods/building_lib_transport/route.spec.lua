
building_lib.register_building("building_lib_transport:route_straight", {
	placement = "dummy",
    transport = {
        left = {
            type = "street",
            points = {
                {x=0, y=3, z=3},
                {x=16, y=3, z=3}
            }
        },
        right = {
            type = "street",
            points = {
                {x=16, y=3, z=13},
                {x=0, y=3, z=13}
            }
        }
    }
})

building_lib_transport.register_connection_rotated(
    "building_lib_transport:route_straight", "left",
    { x=1, y=0, z=0 },
    "building_lib_transport:route_straight", "left"
)

mtt.register("route", function(callback)

    local playername = "singleplayer"
    assert(building_lib.build({x=0, y=0, z=0}, playername, "building_lib_transport:route_straight"))
    assert(building_lib.build({x=1, y=0, z=0}, playername, "building_lib_transport:route_straight"))
    assert(building_lib.build({x=2, y=0, z=0}, playername, "building_lib_transport:route_straight"))

    -- end of mb1
    local connections = building_lib_transport.get_connections({x=0, y=0, z=0}, {x=16, y=3, z=3})
    print(dump(connections))

    callback()
end)