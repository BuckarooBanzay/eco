
building_lib.register_building("building_lib_transport:route_start", {
	placement = "dummy",
    transport = {
        routes = {
            {
                from = {x=0, y=0, z=0},
                to = {x=1, y=0, z=0},
                points = {
                    {x=7.5, y=3, z=7.5},
                    {x=16, y=3, z=7.5}
                }
            }
        }
    }
})

building_lib.register_building("building_lib_transport:route_middle", {
	placement = "dummy",
    transport = {
        routes = {
            {
                from = {x=-1, y=0, z=0},
                to = {x=1, y=0, z=0},
                points = {
                    {x=0, y=3, z=7.5},
                    {x=16, y=3, z=7.5}
                }
            }
        }
    }
})

building_lib.register_building("building_lib_transport:route_end", {
	placement = "dummy",
    transport = {
        routes = {
            {
                from = {x=-1, y=0, z=0},
                to = {x=0, y=0, z=0},
                points = {
                    {x=0, y=3, z=7.5},
                    {x=7.5, y=3, z=7.5}
                }
            }
        }
    }
})

mtt.register("route", function(callback)
    -- create buildings to test route against
    -- x ->
    -- 0        1       2
    -- [start]  [middle] [end]
    local playername = "singleplayer"
    assert(building_lib.build({x=0, y=0, z=0}, playername, "building_lib_transport:route_start"))
    assert(building_lib.build({x=1, y=0, z=0}, playername, "building_lib_transport:route_middle"))
    assert(building_lib.build({x=2, y=0, z=0}, playername, "building_lib_transport:route_end"))

    local route = building_lib_transport.create_route()
    assert(route)
    assert(not route:add({x=-1, y=0, z=0})) -- no building
    assert(route:add({x=0, y=0, z=0})) -- start
    assert(route:add({x=1, y=0, z=0})) -- middle
    assert(route:add({x=2, y=0, z=0})) -- end

    local mb_pos, fraction = route:get_pos()
    assert(vector.equals(mb_pos, {x=0, y=0, z=0}))
    assert(fraction >= 0 and fraction <= 0.1)

    mb_pos, fraction = route:move(0.5)
    assert(vector.equals(mb_pos, {x=0, y=0, z=0}))
    assert(fraction >= 0.4 and fraction <= 0.6)

    mb_pos, fraction = route:move(0.5)
    assert(vector.equals(mb_pos, {x=1, y=0, z=0}))
    assert(fraction >= 0 and fraction <= 0.1)

    callback()
end)