
building_lib.register_building("building_lib_transport:path_straight", {
    placement = "dummy",
    paths = {
        {
            name = "left",
            type = "street",
            start_dir = {x=-1, y=0, z=0},
            end_dir = {x=1, y=0, z=0},
            max_velocity = 2,
            points = {
                {x=0, y=3, z=3},
                {x=16, y=3, z=3}
            }
        },{
            name = "right",
            type = "street",
            start_dir = {x=1, y=0, z=0},
            end_dir = {x=-1, y=0, z=0},
            max_velocity = 2,
            points = {
                {x=16, y=3, z=13},
                {x=0, y=3, z=13}
            }
        }
    }
})

building_lib_transport.register_vehicle("testcar", {
    model = "character.b3d",
    max_velocity = 10,
    drives_on = "street"
})

mtt.register("world setup", function(callback)
    local playername = "singleplayer"
    assert(building_lib.build({x=0, y=0, z=0}, playername, "building_lib_transport:path_straight"))
    assert(building_lib.build({x=1, y=0, z=0}, playername, "building_lib_transport:path_straight"))
    assert(building_lib.build({x=2, y=0, z=0}, playername, "building_lib_transport:path_straight"))

    callback()
end)