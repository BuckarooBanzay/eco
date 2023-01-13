
mtt.register("route", function(callback)
    local playername = "singleplayer"
    local routename = "my_route"

    building_lib_transport.create_route(playername, routename, {
        points = {
            {x=0, y=0, z=0},
            {x=1, y=0, z=0, task="load"},
            {x=2, y=0, z=0},
            {x=3, y=0, z=0, task="unload"},
            {x=4, y=0, z=0}
        }
    })

    local route = building_lib_transport.get_route(playername, routename)
    assert(route)

    callback();
end)