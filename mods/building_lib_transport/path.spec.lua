
building_lib.register_building("building_lib_transport:path_straight", {
    placement = "dummy",
    paths = {
        {
            name = "left",
            type = "street",
            start_dir = {x=-1, y=0, z=0},
            end_dir = {x=1, y=0, z=0},
            points = {
                {x=0, y=3, z=3},
                {x=16, y=3, z=3}
            }
        },{
            name = "right",
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

mtt.register("path setup", function(callback)
    local playername = "singleplayer"
    assert(building_lib.build({x=0, y=0, z=0}, playername, "building_lib_transport:path_straight"))
    assert(building_lib.build({x=1, y=0, z=0}, playername, "building_lib_transport:path_straight"))
    assert(building_lib.build({x=2, y=0, z=0}, playername, "building_lib_transport:path_straight"))

    callback()
end)

mtt.register("get_rotated_paths", function(callback)
    local building_def = building_lib.get_building("building_lib_transport:path_straight")
    assert(building_def)
    local paths = building_lib_transport.get_rotated_paths(building_def, 90)

    assert(#paths == 2)
    assert(vector.equals({x=0, y=0, z=1}, paths[1].start_dir))

    callback()
end)

mtt.register("get_paths", function(callback)
    local paths, target_mapblock, err_msg = building_lib_transport.get_paths({x=0,y=0,z=0}, "left")
    assert(#paths == 1)
    assert(vector.equals({x=1, y=0, z=0}, target_mapblock))
    assert(not err_msg)

    paths, target_mapblock, err_msg = building_lib_transport.get_paths({x=1,y=0,z=0}, "left")
    assert(#paths == 1)
    assert(vector.equals({x=2, y=0, z=0}, target_mapblock))
    assert(not err_msg)

    paths, target_mapblock, err_msg = building_lib_transport.get_paths({x=1,y=0,z=0}, "right")
    assert(#paths == 1)
    assert(vector.equals({x=0, y=0, z=0}, target_mapblock))
    assert(not err_msg)

    paths, target_mapblock, err_msg = building_lib_transport.get_paths({x=0,y=0,z=0}, "right")
    assert(paths == nil)
    assert(target_mapblock == nil)
    assert(err_msg)

    callback()
end)
